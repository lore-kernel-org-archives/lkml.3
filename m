Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbbAYSYC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:24:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbbAYSKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mugunthan V N <mugunthanvnm@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 173/183] ARM: dts: dra7-evm: fix qspi device tree partition size
Date: Sun, 25 Jan 2015 10:08:15 -0800
Message-Id: <20150125180817.683316743@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7-evm.dts |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -399,23 +399,23 @@
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


