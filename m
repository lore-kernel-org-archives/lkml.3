Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3A2FKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:10:38 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36443 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3A2FKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:10:34 -0500
MIME-Version: 1.0
Date: Tue, 29 Jan 2013 10:40:34 +0530
Message-ID: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
Subject: Failure due to missing (Exynos related) pinctrl patch
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Kukjin,

Patch titled "pinctrl: exynos: change PINCTRL_EXYNOS option"
(linux-next commit Id: 7452b64d) which is present in linux-next is
missing in the mainline kernel. This patch is required along with the
patch "gpio: samsung: fix pinctrl condition for exynos and exynos5440"
(mainline commit Id: e4a5da51) which has already made it into
mainline. Without the missing patch we get the following boot up
warnings and subsequent failures with dt boot on 4412 based board:

 WARNING: at drivers/gpio/gpio-samsung.c:3102 samsung_gpiolib_init+0x29c/0x2e8()
 Unknown SoC in gpio-samsung, no GPIOs added
 Modules linked in:
 [<c00142dc>] (unwind_backtrace+0x0/0xf8) from [<c00202bc>]
(warn_slowpath_common+0x4c/0x64)
 [<c00202bc>] (warn_slowpath_common+0x4c/0x64) from [<c0020368>]
(warn_slowpath_fmt+0x30/0x40)
 [<c0020368>] (warn_slowpath_fmt+0x30/0x40) from [<c028b924>]
(samsung_gpiolib_init+0x29c/0x2e8)
 [<c028b924>] (samsung_gpiolib_init+0x29c/0x2e8) from [<c000862c>]
(do_one_initcall+0x34/0x174)
 [<c000862c>] (do_one_initcall+0x34/0x174) from [<c0275960>]
(kernel_init_freeable+0xfc/0x1c8)
 [<c0275960>] (kernel_init_freeable+0xfc/0x1c8) from [<c01c0a5c>]
(kernel_init+0x8/0xe4)
 [<c01c0a5c>] (kernel_init+0x8/0xe4) from [<c000e158>] (ret_from_fork+0x14/0x3c)

-- 
With warm regards,
Sachin
