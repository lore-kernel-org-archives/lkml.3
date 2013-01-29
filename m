Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3A2WIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:08:45 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63670 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3A2WIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:08:42 -0500
MIME-Version: 1.0
In-Reply-To: <1359123276-15833-13-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<1359123276-15833-13-git-send-email-arnd@arndb.de>
Date: Tue, 29 Jan 2013 23:08:41 +0100
Message-ID: <CACRpkda_XOG_ASEGSmERY3W7zCYG4qGVXQX=cKETaah=YJMO3g@mail.gmail.com>
Subject: Re: [PATCH 12/19] pinctrl: exynos: don't mark probing functions as __init
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 3:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Functions called from a driver probe() method must not be
> marked __init, because they may get called after the
> init phase is done, when the device shows up late, or
> because of deferred probing.
>
> Without this patch, building exynos_defconfig results in
> multiple warnings like:
>
> WARNING: drivers/pinctrl/built-in.o(.text+0x51bc): Section mismatch in reference from the function exynos5440_pinctrl_probe() to the function .init.text:exynos5440_gpiolib_register()
> The function exynos5440_pinctrl_probe() references
> the function __init exynos5440_gpiolib_register().
> This is often because exynos5440_pinctrl_probe lacks a __init
> annotation or the annotation of exynos5440_gpiolib_register is wrong.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Applied with Kukjin's ACK, thanks!

Yours,
Linus Walleij
