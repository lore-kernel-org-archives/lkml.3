Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaKYNIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:08:09 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:63424 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805AbaKYNIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:08:06 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <catalin.marinas@arm.com>,
        <gregkh@linuxfoundation.org>, <ijc+devicetree@hellion.org.uk>,
        <jslaby@suse.cz>, <galak@codeaurora.org>, <broonie@linaro.org>,
        <mark.rutland@arm.com>, <m-karicheri2@ti.com>, <pawel.moll@arm.com>,
        <artagnon@gmail.com>, <rrichter@cavium.com>, <will.deacon@arm.com>,
        <arnd@arndb.de>, <gnomes@lxorguk.ukuu.org.uk>, <corbet@lwn.net>,
        <jason@lakedaemon.net>, <broonie@kernel.org>, <heiko@sntech.de>,
        <shawn.guo@freescale.com>, <florian.vaussard@epfl.ch>,
        <andrew@lunn.ch>, <hytszk@gmail.com>, <orsonzhai@gmail.com>,
        <geng.ren@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <lanqing.liu@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>,
        <linux-doc@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: [PATCH v3 4/5] arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and defconfig
Date: Tue, 25 Nov 2014 20:16:57 +0800
Message-ID: <1416917818-10506-5-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.103]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com sAPCIHmR065158
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>

Adds support for Spreadtrum's SoC Platform and its subset Sharkl64
in the arm64 Kconfig and defconfig files.

Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
---
 arch/arm64/Kconfig           |   17 +++++++++++++++++
 arch/arm64/configs/defconfig |    2 ++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..a63ec45 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -147,6 +147,23 @@ config ARCH_THUNDER
 	help
 	  This enables support for Cavium's Thunder Family of SoCs.
 
+menuconfig ARCH_SPRD
+	bool "Spreadtrum SoC platform"
+	depends on ARM64
+	help
+	  Support for Spreadtrum ARM based SoCs
+
+if ARCH_SPRD
+
+config ARCH_SHARKL64
+	bool "Sharkl64 SoC Platform"
+	help
+	  Sharkl64 is a Spreadtrum's SoC Platform which is based
+	  on ARM 64-bit processor core including
+	    sc9836
+
+endif #ARCH_SPRD
+
 config ARCH_VEXPRESS
 	bool "ARMv8 software model (Versatile Express)"
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index dd301be..d7934a8 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -33,6 +33,8 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
 CONFIG_ARCH_THUNDER=y
+CONFIG_ARCH_SPRD=y
+CONFIG_ARCH_SHARKL64=y
 CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_XGENE=y
 CONFIG_PCI=y
-- 
1.7.9.5

