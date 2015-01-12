Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbbALJb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:31:59 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:58572 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbALJb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYq_tyamCzM575D8vdMg_rvDy93fSm+7Oss3tQzFu+TTA@mail.gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418831474-24428-7-git-send-email-ricardo.ribalda@gmail.com> <CACRpkdYq_tyamCzM575D8vdMg_rvDy93fSm+7Oss3tQzFu+TTA@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:31:35 +0100
Message-ID: <CAPybu_1n0mGjm+Si_e4soVcQgGbP=fPFXDU71f3bvABDLraNVQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] gpio/gpiolib-of: Create of_mm_gpiochip_remove
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I think that only gpio-mpc5200.c would benefit from the new API, I can
send a patchset to support removal and use the new API if you want.

Thanks!

On Mon, Jan 12, 2015 at 10:30 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Dec 17, 2014 at 4:51 PM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>
>> Create counterpart of of_mm_gpiochip_add(). This way the modules that
>> can be removable do not duplicate the cleanup code.
>>
>> Suggested-by: Alexandre Courbot <gnurou@gmail.com>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> Patch applied.
>
> Hm.
>
> $ git grep of_mm_gpiochip_add
> arch/powerpc/sysdev/cpm1.c:     return of_mm_gpiochip_add(np, mm_gc);
> arch/powerpc/sysdev/cpm1.c:     return of_mm_gpiochip_add(np, mm_gc);
> arch/powerpc/sysdev/cpm_common.c:       return of_mm_gpiochip_add(np, mm_gc);
> arch/powerpc/sysdev/ppc4xx_gpio.c:              ret =
> of_mm_gpiochip_add(np, mm_gc);
> arch/powerpc/sysdev/qe_lib/gpio.c:              ret =
> of_mm_gpiochip_add(np, mm_gc);
> arch/powerpc/sysdev/simple_gpio.c:      ret = of_mm_gpiochip_add(np, mm_gc);
> drivers/gpio/gpio-ge.c: return of_mm_gpiochip_add(pdev->dev.of_node, mmchip);
> drivers/gpio/gpio-mm-lantiq.c:  ret =
> of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
> drivers/gpio/gpio-mpc5200.c:    ret =
> of_mm_gpiochip_add(ofdev->dev.of_node, &chip->mmchip);
> drivers/gpio/gpio-mpc5200.c:    ret =
> of_mm_gpiochip_add(ofdev->dev.of_node, &chip->mmchip);
> drivers/gpio/gpio-mpc8xxx.c:    ret = of_mm_gpiochip_add(np, mm_gc);
> drivers/gpio/gpio-xilinx.c:     status = of_mm_gpiochip_add(np, &chip->mmchip);
> drivers/gpio/gpio-zevio.c:      status =
> of_mm_gpiochip_add(pdev->dev.of_node, &(controller->chip));
>
> Should these all be patched to use this, or reviewed for applicability?
>
> Yours,
> Linus Walleij



-- 
Ricardo Ribalda
