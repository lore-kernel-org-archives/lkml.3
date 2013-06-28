Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3F1X0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:26:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1X0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:26:17 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/4] Add SMP support for MSM8660, MSM8960 and MSM8974
Date: Fri, 28 Jun 2013 16:25:58 -0700
Message-Id: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series re-organizes the platsmp.c and adds SMP support for
MSM8660, MSM8960 and MSM8974.
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
 arch/arm/mach-msm/board-dt-8974.c                  |   3 +
 arch/arm/mach-msm/headsmp.S                        |  41 ----
 arch/arm/mach-msm/hotplug.c                        |  31 +--
 arch/arm/mach-msm/platsmp.c                        | 265 ++++++++++++++++-----
 arch/arm/mach-msm/scm-boot.h                       |   8 +-
 11 files changed, 330 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/kpss.txt
 create mode 100644 Documentation/devicetree/bindings/arm/msm/scss.txt
 delete mode 100644 arch/arm/mach-msm/headsmp.S

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

