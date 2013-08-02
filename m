Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3HBCPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:15:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33148 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3HBCPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:15:39 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Nicolas Pitre <nico@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [RESEND PATCH 0/4]Add SMP support for MSM8660, MSM8960 and MSM8974
Date: Thu,  1 Aug 2013 19:15:21 -0700
Message-Id: <1375409725-22004-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series re-organizes the platsmp.c and adds SMP support for
MSM8660, MSM8960 and MSM8974. This is based on 3.11-rc3.
We convert to using the cpus property in device tree and
add a "enable-method" property for arm32.
This helps select the appropriate release sequence for the
secondary cores based on the cpu.

Rohit Vaswani (4):
  ARM: msm: Remove pen_release usage
  ARM: msm: Re-organize platsmp to make it extensible
  ARM: msm: Add SMP support for 8960
  ARM: msm: Add support for 8974 SMP

 Documentation/devicetree/bindings/arm/cpus.txt     |   9 +
 Documentation/devicetree/bindings/arm/msm/kpss.txt |  16 ++
 Documentation/devicetree/bindings/arm/msm/scss.txt |  15 ++
 arch/arm/boot/dts/msm8660-surf.dts                 |  23 +-
 arch/arm/boot/dts/msm8960-cdp.dts                  |  22 ++
 arch/arm/boot/dts/msm8974.dts                      |  23 ++
 arch/arm/mach-msm/Makefile                         |   2 +-
 arch/arm/mach-msm/board-dt-8974.c                  |   3 +
 arch/arm/mach-msm/headsmp.S                        |  39 ---
 arch/arm/mach-msm/hotplug.c                        |  31 +--
 arch/arm/mach-msm/platsmp.c                        | 263 ++++++++++++++++-----
 arch/arm/mach-msm/scm-boot.h                       |   8 +-
 12 files changed, 330 insertions(+), 124 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/kpss.txt
 create mode 100644 Documentation/devicetree/bindings/arm/msm/scss.txt
 delete mode 100644 arch/arm/mach-msm/headsmp.S

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

