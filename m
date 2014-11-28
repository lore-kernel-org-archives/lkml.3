Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaK1LOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:14:04 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39051 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbaK1LOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:14:00 -0500
Date: Fri, 28 Nov 2014 12:13:45 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Message-ID: <20141128121345.5fdcc775@bbrezillon>
In-Reply-To: <cover.1417103399.git.nicolas.ferre@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 17:06:28 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> This is the last series of patches that removes the non-Device-Tree board
> support for older Atmel SoCs.
> Again, for the record, it was announced here
> https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91: removal of board
> files) two months ago.
> Several files beyond at91rm9200 are touched this time as I tried to remove the
> biggest parts that were related to !DT SoC initializations. More cleanup is
> certainly needed to remove dead code.
> 
> The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
> 
> Bye,

On whole series:

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> 
> Nicolas Ferre (11):
>   ARM: at91: remove at91rm9200 legacy boards files
>   ARM: at91: remove at91rm9200 legacy board support
>   ARM: at91: switch configuration option to SOC_AT91RM9200
>   ARM: at91/Kconfig: remove ARCH_AT91RM9200 option for drivers
>   ARM: at91: always USE_OF from now on
>   ARM: at91/trivial: update Kconfig comment to mention SAMA5
>   ARM: at91: remove all !DT related configuration options
>   ARM: at91: remove clock data in at91sam9n12.c and at91sam9x5.c files
>   ARM: at91: remove old at91-specific clock driver
>   ARM: at91: remove legacy IRQ driver and related code
>   ARM: at91: remove unused IRQ function declarations
> 
>  arch/arm/Kconfig                        |    5 +-
>  arch/arm/configs/at91rm9200_defconfig   |  161 ----
>  arch/arm/mach-at91/Kconfig              |   34 +-
>  arch/arm/mach-at91/Kconfig.non_dt       |  114 ---
>  arch/arm/mach-at91/Makefile             |   19 -
>  arch/arm/mach-at91/at91_aic.h           |   99 ---
>  arch/arm/mach-at91/at91rm9200.c         |  341 ---------
>  arch/arm/mach-at91/at91rm9200_devices.c | 1212 -------------------------------
>  arch/arm/mach-at91/at91sam9n12.c        |  213 +-----
>  arch/arm/mach-at91/at91sam9x5.c         |  311 +-------
>  arch/arm/mach-at91/board-1arm.c         |   99 ---
>  arch/arm/mach-at91/board-carmeva.c      |  167 -----
>  arch/arm/mach-at91/board-cpuat91.c      |  189 -----
>  arch/arm/mach-at91/board-csb337.c       |  260 -------
>  arch/arm/mach-at91/board-csb637.c       |  142 ----
>  arch/arm/mach-at91/board-dt-rm9200.c    |    1 -
>  arch/arm/mach-at91/board-dt-sam9.c      |    1 -
>  arch/arm/mach-at91/board-dt-sama5.c     |    1 -
>  arch/arm/mach-at91/board-eb9200.c       |  126 ----
>  arch/arm/mach-at91/board-ecbat91.c      |  191 -----
>  arch/arm/mach-at91/board-eco920.c       |  160 ----
>  arch/arm/mach-at91/board-kafa.c         |  113 ---
>  arch/arm/mach-at91/board-kb9202.c       |  159 ----
>  arch/arm/mach-at91/board-picotux200.c   |  129 ----
>  arch/arm/mach-at91/board-rm9200ek.c     |  196 -----
>  arch/arm/mach-at91/board-yl-9200.c      |  597 ---------------
>  arch/arm/mach-at91/clock.c              |  977 -------------------------
>  arch/arm/mach-at91/clock.h              |   49 --
>  arch/arm/mach-at91/generic.h            |   17 -
>  arch/arm/mach-at91/irq.c                |  296 --------
>  arch/arm/mach-at91/pm.c                 |   22 -
>  arch/arm/mach-at91/setup.c              |   13 -
>  drivers/net/ethernet/cadence/Kconfig    |    2 +-
>  drivers/rtc/Kconfig                     |    2 +-
>  drivers/watchdog/Kconfig                |    4 +-
>  35 files changed, 19 insertions(+), 6403 deletions(-)
>  delete mode 100644 arch/arm/configs/at91rm9200_defconfig
>  delete mode 100644 arch/arm/mach-at91/Kconfig.non_dt
>  delete mode 100644 arch/arm/mach-at91/at91_aic.h
>  delete mode 100644 arch/arm/mach-at91/at91rm9200_devices.c
>  delete mode 100644 arch/arm/mach-at91/board-1arm.c
>  delete mode 100644 arch/arm/mach-at91/board-carmeva.c
>  delete mode 100644 arch/arm/mach-at91/board-cpuat91.c
>  delete mode 100644 arch/arm/mach-at91/board-csb337.c
>  delete mode 100644 arch/arm/mach-at91/board-csb637.c
>  delete mode 100644 arch/arm/mach-at91/board-eb9200.c
>  delete mode 100644 arch/arm/mach-at91/board-ecbat91.c
>  delete mode 100644 arch/arm/mach-at91/board-eco920.c
>  delete mode 100644 arch/arm/mach-at91/board-kafa.c
>  delete mode 100644 arch/arm/mach-at91/board-kb9202.c
>  delete mode 100644 arch/arm/mach-at91/board-picotux200.c
>  delete mode 100644 arch/arm/mach-at91/board-rm9200ek.c
>  delete mode 100644 arch/arm/mach-at91/board-yl-9200.c
>  delete mode 100644 arch/arm/mach-at91/clock.c
>  delete mode 100644 arch/arm/mach-at91/clock.h
>  delete mode 100644 arch/arm/mach-at91/irq.c
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
