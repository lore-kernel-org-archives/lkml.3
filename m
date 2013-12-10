Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3LJIMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:12:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3LJICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.12 22/62] ARM: mvebu: re-enable PCIe on Armada 370 DB
Date: Tue, 10 Dec 2013 00:00:53 -0800
Message-Id: <20131210080058.982534466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 96039f735e290281d0c8a08fc467de2cd610543d upstream.

Commit 14fd8ed0a7fd19913 ("ARM: mvebu: Relocate Armada 370/XP PCIe
device tree nodes") relocated the PCIe controller DT nodes one level
up in the Device Tree, to reflect a more correct representation of the
hardware introduced by the mvebu-mbus Device Tree binding.

However, while most of the boards were properly adjusted accordingly,
the Armada 370 DB board was left unchanged, and therefore, PCIe is
seen as not enabled on this board. This patch fixes that by moving the
PCIe controller node one level-up in armada-370-db.dts.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Fixes: 14fd8ed0a7fd19913 "ARM: mvebu: Relocate Armada 370/XP PCIe device tree nodes"
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-370-db.dts |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -99,22 +99,22 @@
 					spi-max-frequency = <50000000>;
 				};
 			};
+		};
 
-			pcie-controller {
+		pcie-controller {
+			status = "okay";
+			/*
+			 * The two PCIe units are accessible through
+			 * both standard PCIe slots and mini-PCIe
+			 * slots on the board.
+			 */
+			pcie@1,0 {
+				/* Port 0, Lane 0 */
+				status = "okay";
+			};
+			pcie@2,0 {
+				/* Port 1, Lane 0 */
 				status = "okay";
-				/*
-				 * The two PCIe units are accessible through
-				 * both standard PCIe slots and mini-PCIe
-				 * slots on the board.
-				 */
-				pcie@1,0 {
-					/* Port 0, Lane 0 */
-					status = "okay";
-				};
-				pcie@2,0 {
-					/* Port 1, Lane 0 */
-					status = "okay";
-				};
 			};
 		};
 	};


