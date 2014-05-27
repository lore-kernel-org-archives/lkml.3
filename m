Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaE0JSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:18:48 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47136 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaE0JSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:18:42 -0400
Date: Tue, 27 May 2014 10:18:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vexpress: refine dependencies for new code
Message-ID: <20140527091836.GE5875@lee--X1>
References: <6862654.ZzBrnrRESe@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6862654.ZzBrnrRESe@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The versatile express changes for 3.16 introduced a number of
> build regressions for randconfig kernels by not tracking dependencies
> between the components right.
> 
> This patch tries to rectify that:
> 
> * the mach-vexpress code cannot link without the syscfg driver,
>   which in turn needs MFD_VEXPRESS_SYSREG
> * various drivers call devm_regmap_init_vexpress_config(), which
>   has to be exported so it can be used by loadable modules
> * the configuration bus uses OF DT helper functions that are not
>   available to platforms disable CONFIG_OF
> * The sysreg driver exports GPIOs through gpiolib, which can
>   be disabled on some platforms.
> * The clocksource code cannot be built on platforms that don't
>   use modern timekeeping but rely on gettimeoffset.

Where's the diff?

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

[...]

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig

For the MFD part:

  Acked-by: Lee Jones <lee.jones@linaro.org>

This patch has a high chance of creating conflicts.  Can someone apply
this to a branch, tag it and sent out a pull-request to the other
maintainers please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
