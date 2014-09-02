Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaIBVTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:19:24 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58748 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaIBVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:19:22 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 0/9] Zynq PM updates
Date: Tue,  2 Sep 2014 14:19:05 -0700
Message-Id: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here is v2 of this series. It's mostly the same and most changes are
related to reformatting comments. The only functional change is in 'ARM:
zynq: PM: Enable DDR clock stop' which does no longer enable
self-refresh too. It seems self-refresh is inflicting a non-negligible
amount of latency that degrades memory performance if enabled throughout
the whole run time.

	Thanks,
	Sören

Daniel Lezcano (2):
  ARM: zynq: Remove invalidate cache for cpu die
  ARM: zynq: cpuidle: Remove pointless code

Soren Brinkmann (7):
  ARM: zynq: PM: Enable A9 internal clock gating feature
  Documentation: devicetree: Add binding for Synopsys DDR controller
  ARM: zynq: DT: Add DDRC node
  ARM: zynq: PM: Enable DDR clock stop
  ARM: zynq: Synchronise zynq_cpu_die/kill
  ARM: zynq: Remove hotplug.c
  ARM: zynq: Rename 'zynq_platform_cpu_die'

 .../bindings/memory-controllers/synopsys.txt       | 11 +++
 arch/arm/boot/dts/zynq-7000.dtsi                   |  5 ++
 arch/arm/mach-zynq/Makefile                        |  3 +-
 arch/arm/mach-zynq/common.c                        |  7 ++
 arch/arm/mach-zynq/common.h                        | 16 ++++-
 arch/arm/mach-zynq/hotplug.c                       | 47 +-----------
 arch/arm/mach-zynq/platsmp.c                       | 41 ++++++++++-
 arch/arm/mach-zynq/pm.c                            | 83 ++++++++++++++++++++++
 arch/arm/mach-zynq/slcr.c                          | 43 ++++++++++-
 drivers/cpuidle/cpuidle-zynq.c                     | 10 +--
 10 files changed, 205 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/synopsys.txt
 create mode 100644 arch/arm/mach-zynq/pm.c

-- 
2.1.0.1.g27b9230

