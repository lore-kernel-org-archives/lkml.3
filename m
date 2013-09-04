Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704Ab3IDJml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:42:41 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36831 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563Ab3IDJmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:42:40 -0400
Date: Wed, 4 Sep 2013 10:42:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org
Subject: Re: [PATCH 3/4] pm2301-charger: Check return value of
 regulator_enable
Message-ID: <20130904094234.GE20150@lee--X1>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
 <1378120226-24805-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378120226-24805-3-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Sep 2013, Sachin Kamat wrote:

> Check the return value of regulator_enable to silence the following
> warning:
> drivers/power/pm2301_charger.c:725:20: warning:
> ignoring return value of ‘regulator_enable’, declared with
> attribute warn_unused_result [-Wunused-result]

Same thing here.

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/power/pm2301_charger.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
> index ffa10ed..ab87d1a 100644
> --- a/drivers/power/pm2301_charger.c
> +++ b/drivers/power/pm2301_charger.c
> @@ -722,7 +722,12 @@ static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
>  
>  		dev_dbg(pm2->dev, "Enable AC: %dmV %dmA\n", vset, iset);
>  		if (!pm2->vddadc_en_ac) {
> -			regulator_enable(pm2->regu);
> +			ret = regulator_enable(pm2->regu);
> +			if (ret) {
> +				dev_err(pm2->dev,
> +					"Failed to enable regulator\n");
> +				goto error_occured;
> +			}
>  			pm2->vddadc_en_ac = true;
>  		}
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
