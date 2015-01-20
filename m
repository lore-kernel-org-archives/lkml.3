Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbbATMUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:20:35 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44023 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbATMUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:20:33 -0500
Date: Tue, 20 Jan 2015 12:20:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH v2 RESEND 1/2] mfd: arizona: Add support for
 OUTn_MONO register control
Message-ID: <20150120122027.GB13701@x1>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
 <1420185829-24886-2-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420185829-24886-2-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT Ack (for this and the doc) required.

> Some boards need to set the OUTn_MONO register to configurates
> the output signal path as a mono differential output. This
> wlf,out-mono property is optional. If present, values must be
> specified less than or equal to the number of output signals.
> If values less than the number of output signals, elements
> that has not been specified are set to 0 by default.
> 
> Example:
>  - wlf,out-mono = <1 0 1>; /* set OUT1,OUT3 to mono differential */
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  drivers/mfd/arizona-core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index bce7c07..cc2927d 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -561,6 +561,16 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  		count++;
>  	}
>  
> +	count = 0;
> +	of_property_for_each_u32(arizona->dev->of_node,
> +				 "wlf,out-mono", prop, cur, val) {
> +		if (count >= ARRAY_SIZE(arizona->pdata.out_mono))
> +			break;
> +
> +		arizona->pdata.out_mono[count] = !!val;
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
