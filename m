Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaF0SEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:04:40 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46601 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaF0SEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:04:35 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        daniel.thompson@linaro.org, robherring2@gmail.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9 v2] Coresight framework and drivers 
Date: Fri, 27 Jun 2014 12:04:12 -0600
Message-Id: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This set is addressing comments received after the May 30th
submission[1].  More specifically:

.All drivers have been converted to use the AMBA bus
 interface.
.Debugfs entries are now created with a macro.
.A header file was created for the ETM driver to allow
 for the reuse of constant definition.
.Error path on some drivers have been corrected.
.All types converted from uintX_t to uX.
.All numeric constant have been replaced with #defines and
 comments added where necessary.
.Removal of "coresight-id" and "coresigh-name" DT bindings.
.Move all DT connections specification to use the generic
 graph bindings.
.The removal of the replicator driver since it doesn't show
 on the AMBA bus.  Drivers for enhanced replicators that have
 a configuration space can be added when the need arises.

Regards,
Mathieu

[1]. http://thread.gmane.org/gmane.linux.kernel/1714785

Mathieu Poirier (3):
  coresight: adding support for beagle and beagleXM
  coresight: adding basic support for Vexpress TC2
  ARM: removing support for etb/etm in "arch/arm/kernel/"

Pratik Patel (6):
  coresight: add CoreSight core layer framework
  coresight-tmc: add CoreSight TMC driver
  coresight-tpiu: add CoreSight TPIU driver
  coresight-etb: add CoreSight ETB driver
  coresight-funnel: add CoreSight Funnel driver
  coresight-etm: add CoreSight ETM/PTM driver

 .../devicetree/bindings/arm/coresight.txt          |  141 ++
 arch/arm/boot/dts/omap3-beagle-xm.dts              |   28 +
 arch/arm/boot/dts/omap3-beagle.dts                 |   28 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |  174 +++
 arch/arm/include/asm/hardware/coresight.h          |  157 --
 arch/arm/include/asm/hardware/cp14.h               |  540 +++++++
 arch/arm/kernel/Makefile                           |    1 -
 arch/arm/kernel/etm.c                              |  654 ---------
 arch/arm/kernel/hw_breakpoint.c                    |    4 +-
 arch/arm/mach-omap2/Kconfig                        |    8 -
 arch/arm/mach-omap2/Makefile                       |    1 -
 arch/arm/mach-omap2/emu.c                          |   50 -
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/amba/bus.c                                 |    2 +-
 drivers/coresight/Kconfig                          |   39 +
 drivers/coresight/Makefile                         |    8 +
 drivers/coresight/coresight-etb.c                  |  557 ++++++++
 drivers/coresight/coresight-etm-cp14.c             |  506 +++++++
 drivers/coresight/coresight-etm.c                  | 1507 ++++++++++++++++++++
 drivers/coresight/coresight-etm.h                  |  192 +++
 drivers/coresight/coresight-funnel.c               |  252 ++++
 drivers/coresight/coresight-priv.h                 |   69 +
 drivers/coresight/coresight-tmc.c                  |  791 ++++++++++
 drivers/coresight/coresight-tpiu.c                 |  223 +++
 drivers/coresight/coresight.c                      |  680 +++++++++
 drivers/coresight/of_coresight.c                   |  207 +++
 include/linux/amba/bus.h                           |    1 +
 include/linux/coresight.h                          |  190 +++
 include/linux/of_coresight.h                       |   27 +
 30 files changed, 6166 insertions(+), 874 deletions(-)
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
 create mode 100644 drivers/coresight/coresight-etm.h
 create mode 100644 drivers/coresight/coresight-funnel.c
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight-tmc.c
 create mode 100644 drivers/coresight/coresight-tpiu.c
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 include/linux/coresight.h
 create mode 100644 include/linux/of_coresight.h

-- 
1.9.1

