Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbaCTUj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:39:57 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37991 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbaCTUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:39:54 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: berlin: SMP support
Date: Thu, 20 Mar 2014 21:39:44 +0100
Message-Id: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small patch set for SMP support on Marvell Berlin BG2
and recently provided BG2Q. Nothing spectacular, as it basically
copies SMP holding pen mechanism from mach-prima2 and plat-versatile
with minor Berlin specific code for SCU and general purpose registers
used by secondary CPUs to get their boot address.

There was some IRC discussion with Alexandre about using
scu_get_base() instead of a DT node. Although BG2Q is true A9
and provides SCU base; BG2 with PJ4b does not and I decided to
depend on a DT node for SCU in both cases, which is fine I guess.

I tested this on BG2, and BG2CD (which is UP). I expect the
Free-Electrons guys to test on BG2Q.

There is a branch based on v3.14-rc1 and latest BG2Q DTs for the
lucky ones who are able to boot unsigned images at

https://github.com/shesselba/linux-berlin.git topic/smp-bg2-bg2q

Sebastian

Sebastian Hesselbarth (2):
  ARM: berlin: add scu and chipctrl device nodes for BG2/BG2Q
  ARM: berlin: add SMP support

 arch/arm/boot/dts/berlin2.dtsi  |  10 +++
 arch/arm/boot/dts/berlin2q.dtsi |  10 +++
 arch/arm/mach-berlin/Kconfig    |   1 +
 arch/arm/mach-berlin/Makefile   |   1 +
 arch/arm/mach-berlin/berlin.c   |   3 +
 arch/arm/mach-berlin/common.h   |  18 ++++++
 arch/arm/mach-berlin/headsmp.S  |  43 +++++++++++++
 arch/arm/mach-berlin/platsmp.c  | 139 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 225 insertions(+)
 create mode 100644 arch/arm/mach-berlin/common.h
 create mode 100644 arch/arm/mach-berlin/headsmp.S
 create mode 100644 arch/arm/mach-berlin/platsmp.c

---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.9.0

