Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaHTUmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:42:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35794 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaHTUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:42:33 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 0/9] Zynq PM updates
Date: Wed, 20 Aug 2014 13:41:46 -0700
Message-Id: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on some PM-related updates and suspend for Zynq (for the
interested, a branch with all patches is found here:
https://github.com/sorenb-xlnx/linux-xlnx/commits/suspend).

This series consists of the rather unproblematic parts that affect Zynq
only and have no further dependencies. It's a little bit of clean up
(thanks to Daniel too) and enabling a couple of the HW's power saving
features.

	Thanks,
	Sören

Daniel Lezcano (2):
  ARM: zynq: Remove invalidate cache for cpu die
  ARM: zynq: cpuidle: Remove pointless code

Soren Brinkmann (7):
  ARM: zynq: PM: Enable A9 internal clock gating feature
  Documentation: devicetree: Add binding for Synopsys DDR controller
  ARM: zynq: DT: Add DDRC node
  ARM: zynq: PM: Enable DDR self-refresh and clock stop
  ARM: zynq: Synchronise zynq_cpu_die/kill
  ARM: zynq: Remove hotplug.c
  ARM: zynq: Rename 'zynq_platform_cpu_die'

 .../bindings/memory-controllers/synopsys.txt       | 11 +++
 arch/arm/boot/dts/zynq-7000.dtsi                   |  5 ++
 arch/arm/mach-zynq/Makefile                        |  3 +-
 arch/arm/mach-zynq/common.c                        |  7 ++
 arch/arm/mach-zynq/common.h                        | 18 ++++-
 arch/arm/mach-zynq/hotplug.c                       | 47 +-----------
 arch/arm/mach-zynq/platsmp.c                       | 35 ++++++++-
 arch/arm/mach-zynq/pm.c                            | 84 ++++++++++++++++++++++
 arch/arm/mach-zynq/slcr.c                          | 43 ++++++++++-
 drivers/cpuidle/cpuidle-zynq.c                     | 10 +--
 10 files changed, 202 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/synopsys.txt
 create mode 100644 arch/arm/mach-zynq/pm.c

-- 
2.0.1.1.gfbfc394

