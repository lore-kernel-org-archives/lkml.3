Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaG3PHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:07:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41390 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaG3PHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:07:19 -0400
From: Robert Richter <rric@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 1/5] arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
Date: Wed, 30 Jul 2014 17:06:30 +0200
Message-Id: <1406732794-20920-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406732794-20920-1-git-send-email-rric@kernel.org>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
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
index a474de346be6..e989d8cab8c7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -128,6 +128,11 @@ source "kernel/Kconfig.freezer"
 
 menu "Platform selection"
 
+config ARCH_THUNDER
+	bool "Cavium Inc. Thunder SoC Family"
+	help
+	  This enables support for Cavium's Thunder Family of SoCs.
+
 config ARCH_VEXPRESS
 	bool "ARMv8 software model (Versatile Express)"
 	select ARCH_REQUIRE_GPIOLIB
@@ -201,6 +206,7 @@ config NR_CPUS
 	range 2 32
 	depends on SMP
 	# These have to remain sorted largest to smallest
+	default "32" if ARCH_THUNDER
 	default "8"
 
 config HOTPLUG_CPU
-- 
2.0.1

