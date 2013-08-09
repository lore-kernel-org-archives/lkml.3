Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031100Ab3HIUtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:49:22 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35677 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031057Ab3HIUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:49:21 -0400
Date: Fri, 9 Aug 2013 13:44:46 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] power supply: tosa_battery: get rid of irq_to_gpio usage
Message-ID: <20130809204446.GC12638@lizard.sbx05730.santaca.wayport.net>
References: <1374361666-3154-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374361666-3154-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 01:07:46AM +0200, Andrea Adami wrote:
> Fix
> linux/drivers/power/tosa_battery.c:153:2: error: implicit declaration of
> function 'irq_to_gpio' [-Werror=implicit-function-declaration]
> |   pr_info("tosa_bat_gpio irq: %d\n",
> gpio_get_value(irq_to_gpio(irq)));
> 
> as done for collie_battery.c with
> commit 629bcb4b72d49b3631ae3dd0fe1d345820fadfcc
> 
> Since 9d08d5d77a355510c2f5657c86b0a4b25acfe72c, irq_to_gpio() is no
> longer available but still in use by collie_battery.c. As it's just
> for a debug message, just get rid of this call.
> 
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
> ---

Applied, thanks!

>  drivers/power/tosa_battery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
> index 0224de5..f4d80df 100644
> --- a/drivers/power/tosa_battery.c
> +++ b/drivers/power/tosa_battery.c
> @@ -150,7 +150,7 @@ static void tosa_bat_external_power_changed(struct power_supply *psy)
>  
>  static irqreturn_t tosa_bat_gpio_isr(int irq, void *data)
>  {
> -	pr_info("tosa_bat_gpio irq: %d\n", gpio_get_value(irq_to_gpio(irq)));
> +	pr_info("tosa_bat_gpio irq\n");
>  	schedule_work(&bat_work);
>  	return IRQ_HANDLED;
>  }
> -- 
> 1.8.1.5
