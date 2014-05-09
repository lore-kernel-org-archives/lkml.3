Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaEILZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:25:04 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:49695 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaEILZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:25:03 -0400
Date: Fri, 9 May 2014 12:24:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH 04/10] mfd: vexpress: Define the device as MFD cells
Message-ID: <20140509112455.GU5767@lee--X1>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
 <1398707877-22596-5-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398707877-22596-5-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014, Pawel Moll wrote:

> This patch - finally, after over 6 months! :-( - addresses
> Samuel's request to split the vexpress-sysreg driver into
> smaller portions and define the device in a form of MFD
> cells:
> 
> * LEDs code has been completely removed and replaced with
>   "gpio-leds" nodes in the tree (referencing dedicated
>   GPIO subnodes in sysreg - bindings documentation updated);
>   this also better fits the reality as some variants of the
>   motherboard don't have all the LEDs populated
> 
> * syscfg bridge code has been extracted into a separate
>   driver (placed in drivers/misc for no better place)
> 
> * all the ID & MISC registers are defined as sysconf
>   making them available for other drivers should they need
>   to use them (and also to the user via /sys/kernel/debug/regmap
>   which can be helpful in platform debugging)
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  .../devicetree/bindings/arm/vexpress-sysreg.txt    |  36 +-
>  arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  76 ++-
>  arch/arm/boot/dts/vexpress-v2m.dtsi                |  76 ++-
>  arch/arm/mach-vexpress/ct-ca9x4.c                  |   2 +-
>  arch/arm/mach-vexpress/v2m.c                       |  15 +-
>  drivers/mfd/Kconfig                                |  15 +-
>  drivers/mfd/Makefile                               |   2 +-
>  drivers/mfd/vexpress-sysreg.c                      | 533 ++++++---------------
>  drivers/misc/Kconfig                               |   9 +
>  drivers/misc/Makefile                              |   1 +
>  drivers/misc/vexpress-syscfg.c                     | 324 +++++++++++++
>  include/linux/vexpress.h                           |  16 +-
>  12 files changed, 667 insertions(+), 438 deletions(-)
>  create mode 100644 drivers/misc/vexpress-syscfg.c

MFD changes look reasonable to me, and remove a hell of a lot of code.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
