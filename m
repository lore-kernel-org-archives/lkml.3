Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031129Ab3HIUsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:48:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50566 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031057Ab3HIUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:48:01 -0400
Date: Fri, 9 Aug 2013 13:43:26 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] power supply: collie_battery: convert to use dev_pm_ops
Message-ID: <20130809204326.GB12638@lizard.sbx05730.santaca.wayport.net>
References: <1374361664-3124-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374361664-3124-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 01:07:44AM +0200, Andrea Adami wrote:
> Fix
> linux/drivers/power/collie_battery.c:372:2: warning: initialization from
> incompatible pointer type [enabled by default]
> linux/drivers/power/collie_battery.c:372:2: warning: (near initialization
> for 'collie_bat_driver.suspend') [enabled by default]
> 
> Referencess:
> MFD: ucb1x00-core: convert to use dev_pm_ops
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/include/linux/mfd?id=5a09b7120a965a7d7e8494d0ed509135bbce0118
> 
> MFD: mcp-core: remove legacy driver suspend/resume methods
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/include/linux/mfd?id=cf4abfcc0df2985ff6061f74e63b8353f2a1d0bc
> 
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
> ---

Applied. Thanks a lot, Andrea!

>  drivers/power/collie_battery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
> index c58d0e3..d02ae02 100644
> --- a/drivers/power/collie_battery.c
> +++ b/drivers/power/collie_battery.c
> @@ -287,7 +287,7 @@ static struct gpio collie_batt_gpios[] = {
>  };
>  
>  #ifdef CONFIG_PM
> -static int collie_bat_suspend(struct ucb1x00_dev *dev, pm_message_t state)
> +static int collie_bat_suspend(struct ucb1x00_dev *dev)
>  {
>  	/* flush all pending status updates */
>  	flush_work(&bat_work);
> -- 
> 1.8.1.5
