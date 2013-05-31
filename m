Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3EaUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:01:46 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62416 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab3EaUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org>
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org>
	<1369268964-28304-4-git-send-email-rvaswani@codeaurora.org>
Date: Fri, 31 May 2013 23:01:36 +0300
Message-ID: <CAHp75Ve1rSf6McAJXFohDJF9yWzhpSx3fbKp0ewxC9tpJOMhBw@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 3:29 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
> This cleans up the gpio-msm-v2 driver of all the global define usage.
> The number of gpios are now defined in the device tree. This enables
> adding irqdomain support as well.

Besides the other comments, I have one important here.

> -static int __init msm_gpio_init(void)
> -{
> -       int rc;
> -
> -       rc = platform_driver_register(&msm_gpio_driver);
> -       if (!rc) {
> -               rc = platform_device_register(&msm_device_gpio);
> -               if (rc)
> -                       platform_driver_unregister(&msm_gpio_driver);
> -       }
> -
> -       return rc;
> -}
> -
> -static void __exit msm_gpio_exit(void)
> -{
> -       platform_device_unregister(&msm_device_gpio);
> -       platform_driver_unregister(&msm_gpio_driver);
> -}
> -
> -postcore_initcall(msm_gpio_init);
> -module_exit(msm_gpio_exit);
> +module_platform_driver(msm_gpio_driver)

It's a really big mistake to do this.
GPIO nowadays is used in many hardware subsystems to support early
stages of booting and initializing.

postcore_initcall is early enough to support mostly anything that
hardware wants from GPIO (for example, ACPI events, though it seems
not a case here).

Please, do not do such changes without good argumets.

--
With Best Regards,
Andy Shevchenko
