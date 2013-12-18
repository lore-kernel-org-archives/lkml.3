Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3LRPcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:32:53 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3601 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LRPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:32:52 -0500
Date: Wed, 18 Dec 2013 16:32:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE MONITORING" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052  power driver
Message-ID: <20131218163234.714a166c@endymion.delvare>
In-Reply-To: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 15:21:13 +0000, Anthony Olech wrote:
> The ADC resolution of the PMIC is 10-bits, this means that the maximum
> possible value is 1023 and not the 1024 as in the code.

The conversion from register value to mV depends on the ADC's LSB, not
its range. So the maximum value which can be represented is irrelevant.

> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> ---
> This patch is relative to linux-next repository tag next-20131218
> 
>  drivers/power/da9052-battery.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
> index f8f4c0f..8f0f259 100644
> --- a/drivers/power/da9052-battery.c
> +++ b/drivers/power/da9052-battery.c
> @@ -178,7 +178,7 @@ struct da9052_battery {
>  
>  static inline int volt_reg_to_mV(int value)
>  {
> -	return ((value * 1000) / 512) + 2500;
> +	return DIV_ROUND_CLOSEST(value * 2000, 1023) + 2500;
>  }
>  
>  static inline int ichg_reg_to_mA(int value)


-- 
Jean Delvare
