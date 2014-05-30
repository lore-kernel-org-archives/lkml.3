Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbaE3Nnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:43:42 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56994 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaE3Nnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:43:41 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: [RFC PATCH 00/11] CoreSight framework and drivers 
Date: Fri, 30 May 2014 07:43:00 -0600
Message-Id: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This RFC is rescucitating the work submitted by Pratik Patel in 
2012 [1].  

This set is addressing comments gathered from the initial RFC
and enhance the framework in a few areas.  More specifically:

. Sysfs entries have been moved to debugfs.
. The removal of the "bus" concept.
. Setting the size of the ETB in accordance to HW capabilities.
. Adding a "status" entry in debugfs to better debug ETM configurations.
. Adding cpu affinity for ETM/PTMs.
. Tying of each IP block to a specific and configurable clock.
. Adjusted the ETM/PTM power up sequence.
. Adding support for beagle/beagleXM and ARM's TC2 platform.

Support for other platforms will be coming shortly but we felt 
confident the current code base was mature enough to suscitate 
comments.  More advanced features like CTI and STMs present in 
the original patchset was intentionally left out to concentrate
on the foundation.  They will be added at a later stage when the 
initial framework has been ironned-out.

Regards,
Mathieu


[1]. http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/138028.html

Mathieu Poirier (3):
  coresight: adding basic support for Vexpress TC2
  coresight: adding support for beagleXM
  ARM: moving support for etb/etm to the "drivers" directory

Panchaxari Prasannamurthy (1):
  coresight: adding support for beagle board

Pratik Patel (7):
  coresight: add CoreSight core layer framework
  coresight: add CoreSight TMC driver
  coresight: add CoreSight TPIU driver
  coresight: add CoreSight ETB driver
  coresight: add CoreSight Funnel driver
  coresight: add CoreSight Replicator driver
  coresight: add CoreSight ETM driver

 .../devicetree/bindings/arm/coresight.txt          |  138 ++
 arch/arm/boot/dts/omap3-beagle-xm.dts              |   30 +
 arch/arm/boot/dts/omap3-beagle.dts                 |   30 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |  122 +
 arch/arm/include/asm/hardware/coresight.h          |  157 --
 arch/arm/include/asm/hardware/cp14.h               |  540 +++++
 arch/arm/kernel/Makefile                           |    1 -
 arch/arm/kernel/etm.c                              |  654 ------
 arch/arm/kernel/hw_breakpoint.c                    |    4 +-
 arch/arm/mach-omap2/Kconfig                        |    8 -
 arch/arm/mach-omap2/Makefile                       |    1 -
 arch/arm/mach-omap2/emu.c                          |   50 -
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/coresight/Kconfig                          |   37 +
 drivers/coresight/Makefile                         |    8 +
 drivers/coresight/coresight-etb.c                  |  586 +++++
 drivers/coresight/coresight-etm-cp14.c             |  511 +++++
 drivers/coresight/coresight-etm.c                  | 2360 ++++++++++++++++++++
 drivers/coresight/coresight-funnel.c               |  310 +++
 drivers/coresight/coresight-priv.h                 |   46 +
 drivers/coresight/coresight-replicator.c           |  130 ++
 drivers/coresight/coresight-tmc.c                  |  796 +++++++
 drivers/coresight/coresight-tpiu.c                 |  229 ++
 drivers/coresight/coresight.c                      |  739 ++++++
 drivers/coresight/of_coresight.c                   |  124 +
 include/linux/coresight.h                          |  181 ++
 include/linux/of_coresight.h                       |   27 +
 28 files changed, 6949 insertions(+), 873 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt
 delete mode 100644 arch/arm/include/asm/hardware/coresight.h
 create mode 100644 arch/arm/include/asm/hardware/cp14.h
 delete mode 100644 arch/arm/kernel/etm.c
 delete mode 100644 arch/arm/mach-omap2/emu.c
 create mode 100644 drivers/coresight/Kconfig
 create mode 100644 drivers/coresight/Makefile
 create mode 100644 drivers/coresight/coresight-etb.c
 create mode 100644 drivers/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/coresight/coresight-etm.c
 create mode 100644 drivers/coresight/coresight-funnel.c
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight-replicator.c
 create mode 100644 drivers/coresight/coresight-tmc.c
 create mode 100644 drivers/coresight/coresight-tpiu.c
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 include/linux/coresight.h
 create mode 100644 include/linux/of_coresight.h

-- 
1.9.1

