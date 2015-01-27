Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbbA0MUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:20:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781AbbA0MU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mugunthan V N <mugunthanvnm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 125/126] ARM: dts: dra7-evm: fix qspi device tree partition size
Date: Tue, 27 Jan 2015 12:17:10 +0000
Message-Id: <1422361031-19364-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mugunthan V N <mugunthanvnm@ti.com>

commit 69d2626f97b7f017ee4416b7dc071e9499c2c944 upstream.

64KiB is allocated for qspi dtb partition which is not
sufficient, so updating the partition table size to 512KiB
for device tree partition.

This also aligns the QSPI partition definitions between
kernel and U-Boot.

Fixes: dc2dd5b8 ("ARM: dts: dra7: Add qspi device")

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 780d66119f3c..6944a6e9e162 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -377,23 +377,23 @@
 		};
 		partition@5 {
 			label = "QSPI.u-boot-spl-os";
-			reg = <0x00140000 0x00010000>;
+			reg = <0x00140000 0x00080000>;
 		};
 		partition@6 {
 			label = "QSPI.u-boot-env";
-			reg = <0x00150000 0x00010000>;
+			reg = <0x001c0000 0x00010000>;
 		};
 		partition@7 {
 			label = "QSPI.u-boot-env.backup1";
-			reg = <0x00160000 0x0010000>;
+			reg = <0x001d0000 0x0010000>;
 		};
 		partition@8 {
 			label = "QSPI.kernel";
-			reg = <0x00170000 0x0800000>;
+			reg = <0x001e0000 0x0800000>;
 		};
 		partition@9 {
 			label = "QSPI.file-system";
-			reg = <0x00970000 0x01690000>;
+			reg = <0x009e0000 0x01620000>;
 		};
 	};
 };
-- 
2.1.4

