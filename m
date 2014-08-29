Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaH2IRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:17:51 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34781 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2IRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:17:47 -0400
Date: Fri, 29 Aug 2014 09:17:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v3 1/2] mfd: arizona: Add support for
 INn_Modec register control
Message-ID: <20140829081741.GD24579@lee--X1>
References: <20140818200003.2ab8aca0@songinha-Samsung-DeskTop-System>
 <20140828113651.GN24579@lee--X1>
 <20140829170230.673ca9ff@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140829170230.673ca9ff@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014, Inha Song wrote:

> Hi, Lee
> Thanks for your review.
> 
> On Thu, 28 Aug 2014 12:36:51 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > On Mon, 18 Aug 2014, Inha Song wrote:
> > 
> > > Some boards need to set the INn_MODE[1:0] register to change
> > > the input signal patch. This wlf,inmode property is optional.
> > > If present, values must be specified less than or equal to
> > > the number of input singals. If values less than the number
> > > of input signals, elements that has not been specifed are set
> > > to 0 by default.
> > > 
> > > Example:
> > >    - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */
> > > 
> > > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > > ---
> > >  drivers/mfd/arizona-core.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > > index 10a0cb9..81e6db8 100644
> > > --- a/drivers/mfd/arizona-core.c
> > > +++ b/drivers/mfd/arizona-core.c
> > > @@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
> > >  static int arizona_of_get_core_pdata(struct arizona *arizona)
> > >  {
> > >  	struct arizona_pdata *pdata = &arizona->pdata;
> > > -	int ret, i;
> > > +	int ret, i, proplen;
> > >  
> > >  	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
> > >  
> > > @@ -560,6 +560,12 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
> > >  			ret);
> > >  	}
> > >  
> > > +	proplen = of_property_count_u32_elems(arizona->dev->of_node,
> > > +					      "wlf,inmode");
> > > +	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode))
> > > +		of_property_read_u32_array(arizona->dev->of_node, "wlf,inmode",
> > > +					   arizona->pdata.inmode, proplen);
> > 
> > of_property_for_each_u32()?
> 
> Is it more clear to use of_property_for_each_u32() instead of
> of_property_read_u32_array()?

It prevents you from having to use of_property_count_u32_elems() first.

> If so, I will fix in v5.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
