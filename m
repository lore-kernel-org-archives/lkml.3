Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbaIIKph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:45:37 -0400
Received: from v032797.home.net.pl ([89.161.177.31]:65346 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756222AbaIIKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:45:35 -0400
Message-ID: <540EDA58.1000202@elproma.com.pl>
Date: Tue, 09 Sep 2014 12:45:44 +0200
From: =?UTF-8?B?SmFudXN6IFXFvHlja2k=?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lisovy Rostislav <lisovy@gmail.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
CC: Michal Vokac <michal.vokac@comap.cz>
Subject: Re: Watchdog start during boot
References: <1410258569.15354.3.camel@lp-lvrv.comap.cz>
In-Reply-To: <1410258569.15354.3.camel@lp-lvrv.comap.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Please join to the watchdog_dev thread: 
http://www.spinics.net/lists/linux-watchdog/msg05004.html.

best regards
Janusz

W dniu 2014-09-09 12:29, Lisovy Rostislav pisze:
> Hello;
> If my understanding is correct, the purpose of the "watchdog subsystem"
> is to provide an unified interface from user-space to watchdog devices
> (via /dev). The issue I am trying to solve is how to start the watchdog
> during boot (it would be sufficient just not to disable it since the
> bootloader enables it) to be controlled later on with the user-space
> tool -- i.e. when the user-space will not boot properly, I would like
> the device to be rebooted.
>
> My "quick and dirty" device-specific solution is:
>
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 3691b15..1e44b03f 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -53,6 +53,10 @@ static unsigned timer_margin;
>   module_param(timer_margin, uint, 0);
>   MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
>   
> +static bool start_on_boot = false;
> +module_param(start_on_boot, bool, 0);
> +MODULE_PARM_DESC(start_on_boot, "Start the watchdog during boot");
> +
>   struct omap_wdt_dev {
>          void __iomem    *base;          /* physical */
>          struct device   *dev;
> @@ -269,6 +273,9 @@ static int omap_wdt_probe(struct platform_device *pdev)
>   
>          pm_runtime_put_sync(wdev->dev);
>   
> +       if (start_on_boot)
> +               omap_wdt_start(omap_wdt);
> +
>          return 0;
>   }
>
> however I think it would be much beneficial to do this in a generic way.
> Maybe to create a device tree property, that would store some flag to
> start the watchdog during boot?
>
> Your opinion is appreciated.
>   
> Best regards;
> Rostislav Lisovy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

