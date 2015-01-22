Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbbAVKbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:31:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:41074 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbAVKbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:31:47 -0500
Message-ID: <54C0D179.700@atmel.com>
Date: Thu, 22 Jan 2015 11:31:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Bo Shen" <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/17] AT91 cleanup for 3.20 #3
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/01/2015 22:58, Alexandre Belloni a écrit :
> This patch sets is based on AT91 cleanup for 3.20 #2. it goes further in the
> cleanup.
> 
> It merges board-dt ans soc files, ending up with only at91rm9200.c, at91sam9.c,
> sama5d3.c and sama5d4.c.

I'm not entirely comfortable with this this merge. Maybe I'm too used to
"board files" ;-)
On the other hand, there is also a phy fixup that will go into the sama5
board file (in "fixes for 3.19").

So, I may delay these changes a little bit.

> It merges all the SOC_AT91SAM9xxx config option under SOC_AT91SAM9.
> 
> It also removes unused headers.
> 
> There is also one fix regarding arm_pm_idle for sam9n12 and sam9g45.

I'm reordering these patches a little bit for creating a at91-cleanup3
tag that I can send quickly.

So, let's rework this series a little bit.

Bye,

> Alexandre Belloni (15):
>   ARM: at91:remove unused mach/system_rev.h
>   ARM: at91: fix sam9n12 and sam9x5 arm_pm_idle
>   ARM: at91: sam9: set arm_pm_idle from sam9_dt_device_init
>   ARM: at91: remove unused at91_ioremap_matrix and header
>   ARM: at91: remove unused _matrix.h headers
>   ARM: at91: stop using HAVE_AT91_DBGUx
>   ARM: at91: pm: remove warning to remove SOC_AT91SAM9263 usage
>   ARM: at91: merge SOC_AT91SAM9xxx
>   ARM: at91: remove at91_boot_soc
>   ARM: at91: rework initialization for rm9200 based boards
>   ARM: at91: rework initialization for sam9 based boards
>   ARM: at91: rework initialization for sama5 based boards
>   ARM: at91: remove old setup
>   ARM: at91: mark const init data with __initconst instead of __initdata
>   ARM: at91: remove at91_dt_initialize
> 
> Arnd Bergmann (2):
>   ARM: at91: merge at91rm9200 files
>   ARM: at91: move sama5 specific code into per-soc files
> 
>  arch/arm/Kconfig.debug                             |   6 +-
>  arch/arm/configs/at91_dt_defconfig                 |  10 +-
>  arch/arm/mach-at91/Kconfig                         | 111 ++----
>  arch/arm/mach-at91/Makefile                        |  17 +-
>  arch/arm/mach-at91/at91rm9200.c                    |  49 ++-
>  arch/arm/mach-at91/{board-dt-sam9.c => at91sam9.c} |  21 +-
>  arch/arm/mach-at91/at91sam9260.c                   |  32 --
>  arch/arm/mach-at91/at91sam9261.c                   |  31 --
>  arch/arm/mach-at91/at91sam9263.c                   |  30 --
>  arch/arm/mach-at91/at91sam9g45.c                   |  30 --
>  arch/arm/mach-at91/at91sam9n12.c                   |  20 -
>  arch/arm/mach-at91/at91sam9rl.c                    |  32 --
>  arch/arm/mach-at91/at91sam9x5.c                    |  20 -
>  arch/arm/mach-at91/board-dt-rm9200.c               |  54 ---
>  arch/arm/mach-at91/board-dt-sama5.c                |  60 ---
>  arch/arm/mach-at91/generic.h                       |  11 -
>  arch/arm/mach-at91/include/mach/at91_dbgu.h        |  63 ----
>  arch/arm/mach-at91/include/mach/at91_matrix.h      |  23 --
>  arch/arm/mach-at91/include/mach/at91_ramc.h        |   6 -
>  .../mach-at91/include/mach/at91sam9260_matrix.h    |  80 ----
>  .../mach-at91/include/mach/at91sam9261_matrix.h    |  64 ----
>  .../mach-at91/include/mach/at91sam9263_matrix.h    | 129 -------
>  arch/arm/mach-at91/include/mach/at91sam9_smc.h     |   2 -
>  .../mach-at91/include/mach/at91sam9g45_matrix.h    | 153 --------
>  .../mach-at91/include/mach/at91sam9n12_matrix.h    |  53 ---
>  .../arm/mach-at91/include/mach/at91sam9rl_matrix.h |  96 -----
>  .../arm/mach-at91/include/mach/at91sam9x5_matrix.h |  53 ---
>  arch/arm/mach-at91/include/mach/cpu.h              | 240 ------------
>  arch/arm/mach-at91/include/mach/system_rev.h       |  27 --
>  arch/arm/mach-at91/pm.c                            |  48 ++-
>  arch/arm/mach-at91/pm_slowclock.S                  |   9 -
>  arch/arm/mach-at91/sama5d3.c                       |  31 +-
>  arch/arm/mach-at91/sama5d4.c                       |  35 +-
>  arch/arm/mach-at91/setup.c                         | 407 ---------------------
>  arch/arm/mach-at91/soc.h                           |  77 ----
>  35 files changed, 151 insertions(+), 1979 deletions(-)
>  rename arch/arm/mach-at91/{board-dt-sam9.c => at91sam9.c} (71%)
>  delete mode 100644 arch/arm/mach-at91/at91sam9260.c
>  delete mode 100644 arch/arm/mach-at91/at91sam9261.c
>  delete mode 100644 arch/arm/mach-at91/at91sam9263.c
>  delete mode 100644 arch/arm/mach-at91/at91sam9g45.c
>  delete mode 100644 arch/arm/mach-at91/at91sam9n12.c
>  delete mode 100644 arch/arm/mach-at91/at91sam9rl.c
>  delete mode 100644 arch/arm/mach-at91/at91sam9x5.c
>  delete mode 100644 arch/arm/mach-at91/board-dt-rm9200.c
>  delete mode 100644 arch/arm/mach-at91/board-dt-sama5.c
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91_dbgu.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9260_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9261_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9263_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9g45_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9n12_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9rl_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5_matrix.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/cpu.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/system_rev.h
>  delete mode 100644 arch/arm/mach-at91/setup.c
>  delete mode 100644 arch/arm/mach-at91/soc.h
> 


-- 
Nicolas Ferre
