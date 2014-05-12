Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaELJRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:17:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085AbaELJRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:17:04 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] ARM: berlin: enable the eSATA interface on the BG2Q DMP
Date: Mon, 12 May 2014 11:16:57 +0200
Message-Id: <1399886217-20474-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BG2Q has an AHCI SATA controller with an eSATA interface. Enable it.
Also use the SATA PHY 0, the BG2Q DMP does not has the SATA PHY 1.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 2da9c41e29d8..3782204100d8 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -26,3 +26,13 @@
 &uart0 {
 	status = "okay";
 };
+
+&ahci {
+	phys = <&sata_phy 0>;
+	phy-names = "port0";
+	status = "okay";
+};
+
+&sata_phy {
+	status = "okay";
+};
-- 
1.9.1

