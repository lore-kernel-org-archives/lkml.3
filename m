Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3KWSCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:02:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3KWSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:02:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Fwd: [PATCH 6/8] watchdog: davinci: reuse driver for keystone arch
Date: Sat, 23 Nov 2013 19:02:02 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, wim@iguana.be,
        nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@kernel.crashing.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
References: <1383680783-12114-7-git-send-email-ivan.khoronzhuk@ti.com> <527A28DE.4030906@ti.com>
In-Reply-To: <527A28DE.4030906@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311231902.02807.arnd@arndb.de>
X-Provags-ID: V02:K0:ZzU8ipWjWuPVZHgOLwDVMTj1mfVh/9WlMoxM99co3g6
 U0GZB8HN5WRYxBevA7Oe0Ne6Gai9OSov97y5nDhc9aiE6TpCl6
 IPIHu668zJAukYjRrsZo8Avs46OpBWmwK1eYqJXWplOERvzJak
 MX5UqgeEdJKn+l5ZTQ2hAWsuNkzQzM028uONIOePgBHsZnSsmr
 kVz8f8WcFePLqnF17AKknsxXEUeFf0RenBEuaE6yihfCgf7x12
 eAP717FNuJLVPYvZj0yPl4gTgnptkKD+SWTrA/THcSw5EXgqNG
 iNB9Qumxx1nuBnJkdXnBdEDtfWZ2AIyEtpbZjRGlHMW0ePozjP
 bgb2hDG/WwzqOUVkX9V8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 November 2013, ivan.khoronzhuk wrote:

> @@ -1,13 +1,20 @@
> -DaVinci Watchdog Timer (WDT) Controller
> +Texas Instruments DaVinci/Keystone Watchdog Timer (WDT) Controller
>  
>  Required properties:
> -- compatible : Should be "ti,davinci-wdt"
> +
> +- compatible:          "ti,davinci-wdt"
> +                       "ti,keystone-wdt"
> +
>  - reg : Should contain WDT registers location and length
>  

...

> @@ -229,6 +229,7 @@ static int davinci_wdt_remove(struct platform_device *pdev)
>  
>  static const struct of_device_id davinci_wdt_of_match[] = {
>         { .compatible = "ti,davinci-wdt", },
> +       { .compatible = "ti,keystone-wdt", },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, davinci_wdt_of_match);

You should clarify the compatible list here: It seems that the devices are fully
compatible, so the driver should only need to check for "ti,davinci-wdt" as the
compatible string, while the dtb files should list both "ti,davinci-wdt" and
"ti,keystone-wdt" for keystone, but only the davinci string for davinci.

	Arnd
