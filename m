Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbbALSnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:43:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56600 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755679AbbALSmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:23 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/7] AT91 cleanup for 3.20 #1
Date: Mon, 12 Jan 2015 19:42:09 +0100
Message-Id: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set cleans a lot of remaining header, config options and functions
that are not used anymore since the switch to DT only.

Patch 5 is moving mach/debug-macro.S to include/debug/at91.S to prepare the
upcoming switch to multiplatform.


Alexandre Belloni (7):
  ARM: at91: remove unused mach/memory.h
  ARM: at91: remove useless config MACH_AT91RM9200_DT
  ARM: at91: remove useless config MACH_AT91SAM9_DT
  ARM: at91: remove useless at91_sysirq_mask_rtx
  ARM: at91: move debug-macro.S into the common space
  ARM: at91: remove useless at91rm9200_dt_initialize()
  ARM: at91: remove useless at91rm9200_set_type()

 MAINTAINERS                                        |  1 +
 arch/arm/Kconfig.debug                             |  9 ++-
 .../mach/debug-macro.S => include/debug/at91.S}    | 19 +++---
 arch/arm/mach-at91/Kconfig                         |  8 ---
 arch/arm/mach-at91/Makefile                        |  6 +-
 arch/arm/mach-at91/at91sam9260.c                   |  2 -
 arch/arm/mach-at91/at91sam9261.c                   |  2 -
 arch/arm/mach-at91/at91sam9263.c                   |  3 -
 arch/arm/mach-at91/at91sam9g45.c                   |  3 -
 arch/arm/mach-at91/at91sam9n12.c                   |  6 --
 arch/arm/mach-at91/at91sam9rl.c                    |  3 -
 arch/arm/mach-at91/at91sam9x5.c                    | 10 ---
 arch/arm/mach-at91/board-dt-rm9200.c               |  2 +-
 arch/arm/mach-at91/generic.h                       |  6 --
 arch/arm/mach-at91/include/mach/at91_rtt.h         | 35 ----------
 arch/arm/mach-at91/include/mach/memory.h           | 26 --------
 arch/arm/mach-at91/sama5d3.c                       |  6 --
 arch/arm/mach-at91/setup.c                         | 18 ------
 arch/arm/mach-at91/sysirq_mask.c                   | 75 ----------------------
 19 files changed, 23 insertions(+), 217 deletions(-)
 rename arch/arm/{mach-at91/include/mach/debug-macro.S => include/debug/at91.S} (68%)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_rtt.h
 delete mode 100644 arch/arm/mach-at91/include/mach/memory.h
 delete mode 100644 arch/arm/mach-at91/sysirq_mask.c

-- 
2.1.0

