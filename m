Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935453AbaH0RSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:18:07 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56677 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935423AbaH0RSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:18:02 -0400
From: mathieu.poirier@linaro.org
To: thomas.petazzoni@free-electrons.com, will.deacon@arm.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, arnd@linaro.org
Cc: john.stultz@linaro.org, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 00/11 v5] Coresight framework and drivers
Date: Wed, 27 Aug 2014 11:17:21 -0600
Message-Id: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This patchset concentrates on enabling HW assisted tracing on ARM
SoCs.  This first wave centers on the basic tracing functionnality,
enabling components such ETM/PTM, funnel, replicator, TMC, TPIU and
ETB.  Subsequent submissions will enable more intricate IP blocks such
as STM and CTI.

Generated traces are encoded in a PFTv1.1 format and can be interpreted
using the procedure detailed here [1] or ptm2human [2]. STM abides to the
widely available STPv2.

Bindings for the driver have been sent separately to the devicetree list.

[1].https://wiki.linaro.org/WorklingGroups/Kernel/Coresight/traceDecodingWithDS5
[2].https://github.com/hwangcc23/ptm2human

New in this patchset:
. drivers/coresight/Makefile has been fixed - files are now listed
  incrementally as they are added.
. corrected typos in Documentation/tracing/coresight.txt

Mathieu Poirier (4):
  coresight: adding documentation for coresight
  coresight: adding support for beagle and beagleXM
  coresight: adding basic support for Vexpress TC2
  ARM: removing support for etb/etm in "arch/arm/kernel/"

Pratik Patel (7):
  coresight: add CoreSight core layer framework
  coresight-tmc: add CoreSight TMC driver
  coresight-tpiu: add CoreSight TPIU driver
  coresight-etb: add CoreSight ETB driver
  coresight-funnel: add CoreSight Funnel driver
  coresight-replicator: add CoreSight Replicator driver
  coresight-etm: add CoreSight ETM/PTM driver

 Documentation/trace/coresight.txt          |  237 ++++
 arch/arm/Kconfig.debug                     |   36 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts      |   28 +
 arch/arm/boot/dts/omap3-beagle.dts         |   28 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |  199 ++++
 arch/arm/include/asm/hardware/coresight.h  |  157 ---
 arch/arm/include/asm/hardware/cp14.h       |  540 +++++++++
 arch/arm/kernel/Makefile                   |    1 -
 arch/arm/kernel/etm.c                      |  654 -----------
 arch/arm/kernel/hw_breakpoint.c            |    4 +-
 arch/arm/mach-omap2/Kconfig                |    8 -
 arch/arm/mach-omap2/Makefile               |    1 -
 arch/arm/mach-omap2/emu.c                  |   50 -
 drivers/Makefile                           |    1 +
 drivers/amba/bus.c                         |    2 +-
 drivers/coresight/Makefile                 |    9 +
 drivers/coresight/coresight-etb10.c        |  529 +++++++++
 drivers/coresight/coresight-etm-cp14.c     |  506 +++++++++
 drivers/coresight/coresight-etm.h          |  200 ++++
 drivers/coresight/coresight-etm3x.c        | 1702 ++++++++++++++++++++++++++++
 drivers/coresight/coresight-funnel.c       |  251 ++++
 drivers/coresight/coresight-priv.h         |   63 +
 drivers/coresight/coresight-replicator.c   |  153 +++
 drivers/coresight/coresight-tmc.c          |  740 ++++++++++++
 drivers/coresight/coresight-tpiu.c         |  212 ++++
 drivers/coresight/coresight.c              |  669 +++++++++++
 drivers/coresight/of_coresight.c           |  202 ++++
 include/linux/amba/bus.h                   |    1 +
 include/linux/coresight.h                  |  200 ++++
 29 files changed, 6501 insertions(+), 882 deletions(-)
 create mode 100644 Documentation/trace/coresight.txt
 delete mode 100644 arch/arm/include/asm/hardware/coresight.h
 create mode 100644 arch/arm/include/asm/hardware/cp14.h
 delete mode 100644 arch/arm/kernel/etm.c
 delete mode 100644 arch/arm/mach-omap2/emu.c
 create mode 100644 drivers/coresight/Makefile
 create mode 100644 drivers/coresight/coresight-etb10.c
 create mode 100644 drivers/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/coresight/coresight-etm.h
 create mode 100644 drivers/coresight/coresight-etm3x.c
 create mode 100644 drivers/coresight/coresight-funnel.c
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight-replicator.c
 create mode 100644 drivers/coresight/coresight-tmc.c
 create mode 100644 drivers/coresight/coresight-tpiu.c
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 include/linux/coresight.h

-- 
1.9.1

