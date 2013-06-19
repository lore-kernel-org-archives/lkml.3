Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3FSTFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:05:15 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:65230 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3FSTFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <1371202532-14628-8-git-send-email-avinashphilip@ti.com>
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com>
	<1371202532-14628-8-git-send-email-avinashphilip@ti.com>
Date: Wed, 19 Jun 2013 21:05:12 +0200
Message-ID: <CACRpkdY+6x6UyrHLrh+ya3Y+e8MjsWjZ8FS3RoQwW14mr6x6Vw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] ARM: davinci: Start using gpiolib API inplace of
 inline functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 11:35 AM, Philip Avinash <avinashphilip@ti.com> wrote:

> Remove NEED_MACH_GPIO_H config select option for ARCH_DAVINCI to start
> use gpiolib interface for davinci platforms. However with this software
> latencies for gpio_get/set APIs will affect. Latency has increased by 18
> microsecond with gpiolib API as compared with inline API's.
>
> Software latency is calculated on da850 EVM for gpio_get_value API by
> taking the printk timing for API execution with interrupts disabled.
> Experiment has done for inline and gpiolib API interface.
>
>   inline gpio API with interrupt disabled
>   [   29.734337] before gpio_get
>   [   29.736847] after gpio_get
>
>   Time difference 0.00251
>
>   gpio library with interrupt disabled
>   [  272.876763] before gpio_get
>   [  272.879291] after gpio_get
>
>   Time difference 0.002528
>   Latency increased by (0.002528 -  0.00251) = 18 microsecond.
>
> Also being here
> - Moved following definitions from mach folder to include directory
>         struct davinci_gpio_controller
>         Macro GPIO(x)
>         inline function __gpio_mask
> - Removed GPIO_TYPE_DAVINCI enum definition as GPIO Davinci is converted
>   to Linux device driver model.
> - With removal of select option of NEED_MACH_GPIO_H for ARCH_DAVINCI,
>   gpio-tnetv107x also start using gpiolib interface. Hence removes
>   related header files
>         arch/arm/mach-davinci/include/mach/gpio-davinci.h
>         arch/arm/mach-davinci/include/mach/gpio.h
>
>   and include linux/platform_data/gpio-davinci.h header file to support
>   gpio-davinci platform definitions.
>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
> Changes since v1:
>         - Remove inline GPIO API support for tnetv107x platforms
>         - Remove gpio header files in mach directory.
>         - Remove include of gpio header files from mach directory.
>         - Moved enum davinci_gpio_type to include folder
>         - Replace __ASM_ARCH_DAVINCI_GPIO_H with __DAVINCI_GPIO_PLATFORM_H

Acked-by: Linus Walleij <linus.walleij@linaro.org>
on this as well, and this whole 7-patch series.

For sure things look better after this series than before it,
even if there may be details I think need to be adressed later.

Yours,
Linus Walleij
