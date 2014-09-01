Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaIAIcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:32:42 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:41959 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaIAIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:32:40 -0400
Date: Mon, 1 Sep 2014 09:32:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v5 1/2] mfd: arizona: Add support for
 INn_Mode register control
Message-ID: <20140901083233.GC7374@lee--X1>
References: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
 <1409365639-5320-2-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409365639-5320-2-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2014, Inha Song wrote:

> Some boards need to set the INn_MODE[1:0] register to change
> the input signal patch. This wlf,inmode property is optional.
> If present, values must be specified less than or equal to
> the number of input singals. If values less than the number
> of input signals, elements that has not been specifed are set
> to 0 by default.
> 
> Example:
>    - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

That looks better.

Applied, thanks.

Charles,
  Can you confirm your Reviewed-by for this version of the patch
  please?

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 10a0cb9..31757f7 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -534,7 +534,11 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
>  static int arizona_of_get_core_pdata(struct arizona *arizona)
>  {
>  	struct arizona_pdata *pdata = &arizona->pdata;
> +	struct property *prop;
> +	const __be32 *cur;
> +	u32 val;
>  	int ret, i;
> +	int count = 0;
>  
>  	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
>  
> @@ -560,6 +564,15 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  			ret);
>  	}
>  
> +	of_property_for_each_u32(arizona->dev->of_node, "wlf,inmode", prop,
> +				 cur, val) {
> +		if (count == ARRAY_SIZE(arizona->pdata.inmode))
> +			break;
> +
> +		arizona->pdata.inmode[count] = val;
> +		count++;
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
