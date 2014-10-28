Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaJ1KPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:15:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47286 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaJ1KPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141013193618.GD29810@saruman>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
	<1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
	<20141013191405.GB29810@saruman>
	<20141013192404.GB4034@psi-dev26.jf.intel.com>
	<20141013192632.GC29810@saruman>
	<20141013193618.GD29810@saruman>
Date: Tue, 28 Oct 2014 11:15:20 +0100
Message-ID: <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 9:36 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Oct 13, 2014 at 02:26:32PM -0500, Felipe Balbi wrote:

> I also noticed that this is missing:
>
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index e12e5b0..7db5ab9 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -614,3 +614,9 @@ static int __init byt_gpio_init(void)
>  }
>
>  subsys_initcall(byt_gpio_init);
> +
> +static void __exit byt_gpio_exit(void)
> +{
> +       platform_driver_unregister(&byt_gpio_driver);
> +}
> +module_exit(byt_gpio_exit);

But the Baytrail driver is not a loadable module, it is bool:

config PINCTRL_BAYTRAIL
        bool "Intel Baytrail GPIO pin control"
        depends on GPIOLIB && ACPI && X86

(...)

So I guess it won't need handling for removal, as it can only
be compiled-in.

Yours,
Linus Walleij
