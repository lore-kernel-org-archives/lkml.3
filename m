Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbaIEHsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:48:24 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63012 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbaIEHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:47:06 -0400
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>
Subject: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
Date: Fri,  5 Sep 2014 09:46:42 +0200
Message-Id: <1409903205-2762-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409903205-2762-1-git-send-email-rric@kernel.org>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>

Increase maximum numbers of cpus to 32. This relates to current
maximal possible cpu number. Increasing this to 64 cpus will be a
separate patch not part of this enablement patches.

Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a4e1ce..77fb82b0f684 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -134,6 +134,11 @@ source "kernel/Kconfig.freezer"
 
 menu "Platform selection"
 
+config ARCH_THUNDER
+	bool "Cavium Inc. Thunder SoC Family"
+	help
+	  This enables support for Cavium's Thunder Family of SoCs.
+
 config ARCH_VEXPRESS
 	bool "ARMv8 software model (Versatile Express)"
 	select ARCH_REQUIRE_GPIOLIB
@@ -256,6 +261,7 @@ config NR_CPUS
 	range 2 32
 	depends on SMP
 	# These have to remain sorted largest to smallest
+	default "32" if ARCH_THUNDER
 	default "8"
 
 config HOTPLUG_CPU
-- 
2.0.1

