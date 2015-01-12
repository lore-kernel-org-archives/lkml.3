Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbbALJaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:30:16 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:50809 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbALJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:30:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418831474-24428-7-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-7-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:30:13 +0100
Message-ID: <CACRpkdYq_tyamCzM575D8vdMg_rvDy93fSm+7Oss3tQzFu+TTA@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] gpio/gpiolib-of: Create of_mm_gpiochip_remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 4:51 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Create counterpart of of_mm_gpiochip_add(). This way the modules that
> can be removable do not duplicate the cleanup code.
>
> Suggested-by: Alexandre Courbot <gnurou@gmail.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied.

Hm.

$ git grep of_mm_gpiochip_add
arch/powerpc/sysdev/cpm1.c:     return of_mm_gpiochip_add(np, mm_gc);
arch/powerpc/sysdev/cpm1.c:     return of_mm_gpiochip_add(np, mm_gc);
arch/powerpc/sysdev/cpm_common.c:       return of_mm_gpiochip_add(np, mm_gc);
arch/powerpc/sysdev/ppc4xx_gpio.c:              ret =
of_mm_gpiochip_add(np, mm_gc);
arch/powerpc/sysdev/qe_lib/gpio.c:              ret =
of_mm_gpiochip_add(np, mm_gc);
arch/powerpc/sysdev/simple_gpio.c:      ret = of_mm_gpiochip_add(np, mm_gc);
drivers/gpio/gpio-ge.c: return of_mm_gpiochip_add(pdev->dev.of_node, mmchip);
drivers/gpio/gpio-mm-lantiq.c:  ret =
of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
drivers/gpio/gpio-mpc5200.c:    ret =
of_mm_gpiochip_add(ofdev->dev.of_node, &chip->mmchip);
drivers/gpio/gpio-mpc5200.c:    ret =
of_mm_gpiochip_add(ofdev->dev.of_node, &chip->mmchip);
drivers/gpio/gpio-mpc8xxx.c:    ret = of_mm_gpiochip_add(np, mm_gc);
drivers/gpio/gpio-xilinx.c:     status = of_mm_gpiochip_add(np, &chip->mmchip);
drivers/gpio/gpio-zevio.c:      status =
of_mm_gpiochip_add(pdev->dev.of_node, &(controller->chip));

Should these all be patched to use this, or reviewed for applicability?

Yours,
Linus Walleij
