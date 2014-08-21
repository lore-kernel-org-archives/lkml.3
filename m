Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaHUMM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:12:28 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48254 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaHUMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:12:26 -0400
Date: Thu, 21 Aug 2014 13:12:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v2 1/2] mfd: arizona: Add support for
 INn_Mode register control
Message-ID: <20140821121219.GF4266@lee--X1>
References: <20140813205313.65bbe343@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140813205313.65bbe343@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Inha Song wrote:

> Some boards need to set the INn_MODE[1:0] register to change
> the input signal patch. This wlf,inmode property is optional.
> If present values must be specified by the number of
> ARIZONA_MAX_INPUT.
> 
> Example:
>    - wlf,inmode = <2 0 2 0>;	/* IN1, IN3 use DMIC */
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  drivers/mfd/arizona-core.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

This is going to require a DT Ack.

Is [2/2] adding the documentation?  I can't easily go and look because
you send the patch-set unthreaded.  Please thread patch-sets.  See
the man page for `git send-email` for more information.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 10a0cb9..2b68ccd 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
>  static int arizona_of_get_core_pdata(struct arizona *arizona)
>  {
>  	struct arizona_pdata *pdata = &arizona->pdata;
> -	int ret, i;
> +	int ret, i, proplen;
>  
>  	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
>  
> @@ -560,6 +560,15 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  			ret);
>  	}
>  
> +	proplen = of_property_count_u32_elems(arizona->dev->of_node,
> +					      "wlf,inmode");
> +	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode)) {
> +		for (i = 0; i < proplen; i++)
> +			of_property_read_u32_index(arizona->dev->of_node,
> +						   "wlf,inmode", i,
> +						    &arizona->pdata.inmode[i]);
> +	}
> +
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
