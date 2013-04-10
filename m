Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab3DJLvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:51:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10737 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3DJLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:51:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Apr 2013 04:51:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: pluto: populate key mapping
Date: Wed, 10 Apr 2013 17:17:34 +0530
Message-ID: <1365594454-20614-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1365594454-20614-1-git-send-email-ldewangan@nvidia.com>
References: <1365594454-20614-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keys on Pluto interfaced through Tegra KBC controller
in key matrix topology.

Add the key mapping for the keys

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The system is booted on Pluto with the fastboot.

 arch/arm/boot/dts/tegra114-pluto.dts |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-pluto.dts b/arch/arm/boot/dts/tegra114-pluto.dts
index 6bbc8ef..290c9ce 100644
--- a/arch/arm/boot/dts/tegra114-pluto.dts
+++ b/arch/arm/boot/dts/tegra114-pluto.dts
@@ -14,6 +14,23 @@
 		status = "okay";
 	};
 
+	kbc {
+		status = "okay";
+		nvidia,debounce-delay-ms = <640>;
+		nvidia,repeat-delay-ms = <1>;
+		nvidia,kbc-row-pins = <0 1 2>;
+		nvidia,kbc-col-pins = <11 12 13>;
+		linux,keymap = < 0x00000074	/* KEY_POWER */
+				 0x00010073	/* KEY_VOLUMEUP */
+				 0x00020072	/* KEY_VOLUMEDOWN */
+				 0x010000D9	/* KEY_SEARCH */
+				 0x010100D4	/* KEY_CAMERA */
+				 0x010200D2	/* KEY_CAMERA_FOCUS */
+				 0x02000066	/* KEY_HOME */
+				 0x0201009E	/* KEY_BACK */
+				 0x0202008B>;	/* KEY_MENU */
+	};
+
 	pmc {
 		nvidia,invert-interrupt;
 	};
-- 
1.7.1.1

