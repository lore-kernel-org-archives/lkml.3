Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaKLTnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:43:50 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38230 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKLTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:43:47 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 0/4] MIPS: GIC device-tree support
Date: Wed, 12 Nov 2014 11:43:35 -0800
Message-Id: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add support for mapping and routing GIC interrupts as well
as setting up the GIC timer through device-tree.  Patches 1 adds the
"mti" vendor prefix, patch 2 adds the GIC binding document, and patches
3 and 4 add device-tree support for the GIC irqchip and clocksource drivers,
respectively.

Based on next-20141028, which includes part 1 [0] and part 2 [1] of my
GIC cleanup series.

Changes from v4:
 - don't probe clocksource from irqchip; just WARN() if device-tree
   is incorrect

Changes from v3:
 - dropped the CPU name from the compatible string
 - replaced available-cpu-vectors property with reserved-cpu-vectors
 - made reg property optional
 - probed GIC timer from GIC irqchip driver

Changes from v2:
 - added back third cell to specifier to differentiate between shared and
   local interrupts
 - added timer sub-node and it's properties
 - changed compatible string to include CPU version
 - rebased on GIC cleanup series

Changes from v1:
 - updated bindings to drop third interrupt cell and remove CPU interrupt
   controller as the parent of the GIC
 - moved GIC to drivers/irqchip/
 - other minor fixes/cleanups

[0] https://lkml.org/lkml/2014/9/18/487
[1] https://lkml.org/lkml/2014/10/20/481

Andrew Bresticker (4):
  of: Add vendor prefix for MIPS Technologies, Inc.
  of: Add binding document for MIPS GIC
  irqchip: mips-gic: Add device-tree support
  clocksource: mips-gic: Add device-tree support

 .../bindings/interrupt-controller/mips-gic.txt     | 55 +++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 drivers/clocksource/Kconfig                        |  1 +
 drivers/clocksource/mips-gic-timer.c               | 41 ++++++++--
 drivers/irqchip/irq-mips-gic.c                     | 92 ++++++++++++++++++++--
 .../dt-bindings/interrupt-controller/mips-gic.h    |  9 +++
 6 files changed, 187 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
 create mode 100644 include/dt-bindings/interrupt-controller/mips-gic.h

-- 
2.1.0.rc2.206.gedb03e5

