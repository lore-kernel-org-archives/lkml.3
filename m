Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbaD2LFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:05:18 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:55206 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596AbaD2LFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <7208467.nZIXMIfPji@wuerfel>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
	<7208467.nZIXMIfPji@wuerfel>
Date: Tue, 29 Apr 2014 13:05:15 +0200
Message-ID: <CAPDyKFpJrrviaZo_L8MkLF=v7DqGEVj9=uSNsNtU-FXNwu-MmQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: usb backend needs LED support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 11:45, Arnd Bergmann <arnd@arndb.de> wrote:
> [hijacking the thread since it has the right Cc list already, sorry]
>
> I stumbled over this doing randconfig builds on linux-next
>
> 8<----------
>
> From c11f54f1e5ea0557e076867ca31c90bcb20e3e0c Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Tue, 29 Apr 2014 11:41:40 +0200
> Subject: [PATCH] mmc: rtsx: usb backend needs LED support
>
> Building the rtsx USB driver requires the LED classdev base
> support, otherwise we get this build error:
>
> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
> :(.text+0x806480): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
> :(.text+0x806708): undefined reference to `led_classdev_register'
>
> This adds an explicit dependency in Kconfig

I think the proper solution is to fix the dependency in the driver code instead.

There are already some ifdefs hackery for making it optional to use
leds, apparently that's not working properly.

Kind regards
Ulf Hansson

>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 92d91fe..66aedf3 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -696,6 +696,7 @@ config MMC_REALTEK_PCI
>  config MMC_REALTEK_USB
>         tristate "Realtek USB SD/MMC Card Interface Driver"
>         depends on MFD_RTSX_USB
> +       depends on LEDS_CLASS
>         help
>           Say Y here to include driver code to support SD/MMC card interface
>           of Realtek RTS5129/39 series card reader
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
