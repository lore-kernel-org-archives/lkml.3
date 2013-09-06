Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab3IFHDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 03:03:45 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64358 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3IFHDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:03:44 -0400
Date: Fri, 6 Sep 2013 08:03:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, dwmw2@infradead.org
Subject: Re: [PATCH v2 3/4] pm2301-charger: Check return value of
 regulator_enable
Message-ID: <20130906070340.GC32654@lee--X1>
References: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
 <1378448873-4430-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378448873-4430-3-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, Sachin Kamat wrote:

> Check the return value of regulator_enable to silence the following
> warning:
> drivers/power/pm2301_charger.c:725:20: warning:
> ignoring return value of ‘regulator_enable’, declared with
> attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
> Compile tested.
> Changes since v1:
> * converted dev_err and return to dev_warn as suggested by Lee Jones.
> ---
>  drivers/power/pm2301_charger.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
> index ffa10ed..e55d809 100644
> --- a/drivers/power/pm2301_charger.c
> +++ b/drivers/power/pm2301_charger.c
> @@ -722,8 +722,14 @@ static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
>  
>  		dev_dbg(pm2->dev, "Enable AC: %dmV %dmA\n", vset, iset);
>  		if (!pm2->vddadc_en_ac) {
> -			regulator_enable(pm2->regu);
> -			pm2->vddadc_en_ac = true;
> +			ret = regulator_enable(pm2->regu);
> +			if (ret) {
> +				dev_warn(pm2->dev,
> +					"Failed to enable vddadc regulator\n");
> +				pm2->vddadc_en_ac = false;

pm2->vddadc_en_ac is already false.

> +			} else {
> +				pm2->vddadc_en_ac = true;
> +			}
>  		}
>  
>  		ret = pm2xxx_charging_init(pm2);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
