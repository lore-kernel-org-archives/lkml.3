Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaHMM33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:29:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55366 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbaHMM32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:29:28 -0400
Date: Wed, 13 Aug 2014 13:29:26 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v2 1/2] mfd: arizona: Add support for
	INn_Mode register control
Message-ID: <20140813122926.GJ15833@opensource.wolfsonmicro.com>
References: <20140813205313.65bbe343@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813205313.65bbe343@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 08:53:13PM +0900, Inha Song wrote:
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
> 
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

of_property_read_u32_array with proplen as the length should be
ok here since we know the size is smaller than the inmode array.

Thanks,
Charles
