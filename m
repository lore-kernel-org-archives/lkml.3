Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaJUKRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:17:14 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57403 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaJUKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:17:12 -0400
Date: Tue, 21 Oct 2014 11:17:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-api@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/5] mfd: max77693: Map charger device to its own
 of_node
Message-ID: <20141021101705.GF26842@x1>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
 <20141020150630.GB26784@x1>
 <1413817781.11298.0.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413817781.11298.0.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:

> On pon, 2014-10-20 at 16:06 +0100, Lee Jones wrote:
> > On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:
> > 
> > > Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the MFD
> > > child device (the charger) will have its own of_node set. This will be
> > > used by the max77693 charger driver in next patches to obtain battery
> > > configuration from DTS.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > ---
> > >  drivers/mfd/max77693.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> > > index cf008f45968c..2277a11b6629 100644
> > > --- a/drivers/mfd/max77693.c
> > > +++ b/drivers/mfd/max77693.c
> > > @@ -43,7 +43,10 @@
> > >  
> > >  static const struct mfd_cell max77693_devs[] = {
> > >  	{ .name = "max77693-pmic", },
> > > -	{ .name = "max77693-charger", },
> > > +	{
> > > +		.name = "max77693-charger",
> > > +		.of_compatible = "maxim,max77693-charger",
> > > +	},
> > >  	{ .name = "max77693-muic", },
> > >  	{ .name = "max77693-haptic", },
> > >  	{
> > 
> > I'm guessing this can be applied separately?
> 
> Yes. Patch 3/5 also (it adds necessary defines and symbols for
> chargers).

I'll take this patch, but I think 3/5 is required by some of the other
patches in the set, no?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
