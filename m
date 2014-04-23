Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaDWP6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:58:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:64840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbaDWP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:58:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/5] wdt: sunxi: Move restart code to the watchdog driver
Date: Wed, 23 Apr 2014 17:57:56 +0200
Message-ID: <11279831.fXrrNoqKX2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398265476-29373-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com> <1398265476-29373-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JiYQcvIj8UgTeek7UlBQyrrTkuoYai+j2wush2iPg7i
 ffyEpvGhOSXBtynYqVqXawbcnLnPFyohIQuS1eaIsXQeJ4ELoW
 bBRfqpur30/Xpp0xqhBcRsQAzztJxAVN5P2X5AetbMf1VinqBH
 Vvj1GOxvk7/5v9SKy7WZyCZJJ1lrBHLvyXyy5qz02Oz9NErUHW
 9n/lOrMJzhpf4PCSnfrlWUJk2hJDrgF2wlUwW9LJnWI2k7zoY5
 Jmtr05Ir+TSAcY5onhcDQPG7fZEQ6IstfzmgO8ojubNeOjS0Of
 9UzBxKLKXV1itYCHy/gsTuJkw0iWHpEMJBZVIrZGbmgoIoeTSQ
 uXR1PZKVErjFHq4VVfbs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 17:04:32 Maxime Ripard wrote:
> Most of the watchdog code is duplicated between the machine restart code and
> the watchdog driver. Add the restart hook to the watchdog driver, to be able to
> remove it from the machine code eventually.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>


> @@ -181,6 +209,9 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
>  	if (unlikely(err))
>  		return err;
>  
> +	sunxi_restart_ctx = sunxi_wdt;
> +	arm_pm_restart = sun4i_wdt_restart;
> +
>  	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
>  			sunxi_wdt->wdt_dev.timeout, nowayout);
>  
> @@ -191,6 +222,8 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
>  {
>  	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
>  
> +	arm_pm_restart = NULL;
> +
>  	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
>  	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);

I think we will eventually want a more sophisticated method of registering
and unregistering reset handlers in order to deal with multiple ways of
triggering reset. For now, your approach seems sufficient.

	Arnd
