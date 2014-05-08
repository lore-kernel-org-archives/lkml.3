Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaEHI3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:29:23 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64388 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaEHI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:29:20 -0400
Date: Thu, 8 May 2014 09:29:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: usb backend needs LED support
Message-ID: <20140508082911.GA5767@lee--X1>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
 <7208467.nZIXMIfPji@wuerfel>
 <CAPDyKFpJrrviaZo_L8MkLF=v7DqGEVj9=uSNsNtU-FXNwu-MmQ@mail.gmail.com>
 <201404300228.s3U2S7WA026782@rtits1.realtek.com>
 <53606F49.1000401@realtek.com>
 <CAPDyKFrA39eFnoy-sAGcAUeDqtB78cvAivV+mmRR5C-tov-9eg@mail.gmail.com>
 <536B3B6F.1010209@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536B3B6F.1010209@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>From: Roger Tseng <rogerable@realtek.com>
> >>Date: Wed, 30 Apr 2014 11:11:25 +0800
> >>Subject: [PATCH] mmc: rtsx: fix possible linking error if built-in
> >>
> >>rtsx_usb_sdmmc module uses the LED classdev if available, but the code
> >>failed
> >>to consider the situation that it is built-in and the LED classdev is a
> >>module,
> >>leading to following linking error:
> >>
> >>   LD      init/built-in.o
> >>drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
> >>rtsx_usb_sdmmc.c:(.text+0x2a018e): undefined reference to
> >>`led_classdev_unregister'
> >>drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
> >>rtsx_usb_sdmmc.c:(.text+0x2a197e): undefined reference to
> >>`led_classdev_register'
> >>
> >>Fix by excluding such condition when defining macro RTSX_USB_USE_LEDS_CLASS.
> >>
> >>Signed-off-by: Roger Tseng <rogerable@realtek.com>
> >
> >Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Would this patch be merged into linux-next or Lee's mfd.git
> ib-mfd-mmc-memstick-3.16 branch?

This patch doesn't have anything to do with MFD.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
