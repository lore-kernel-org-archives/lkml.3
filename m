Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaDYOJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:09:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47374 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189AbaDYOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:07:52 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v2 17/18] ARM: mvebu: dts: Enable USB3 in Armada 375 DB
Date: Fri, 25 Apr 2014 16:07:15 +0200
Message-Id: <1398434836-18908-18-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to enable the USB3 host controller on the Armada 375 DB
platform, we need to create a ranges at the soc node level to describe
the special static window for USB3.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-375-db.dts | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-375-db.dts b/arch/arm/boot/dts/armada-375-db.dts
index 9378d3136b41..928de536a0ff 100644
--- a/arch/arm/boot/dts/armada-375-db.dts
+++ b/arch/arm/boot/dts/armada-375-db.dts
@@ -30,8 +30,9 @@
 	};
 
 	soc {
-		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x100000
-			  MBUS_ID(0x01, 0x1d) 0 0xfff00000 0x100000>;
+		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x100000 /* internal regs */
+			  MBUS_ID(0x05, 0x00) 0 0xff100000 0x20000  /* USB3 XHCI */
+			  MBUS_ID(0x01, 0x1d) 0 0xfff00000 0x100000 /* bootrom */>;
 
 		internal-regs {
 			spi@10600 {
@@ -126,5 +127,10 @@
 				status = "okay";
 			};
 		};
+
+		usb3-controller {
+			status = "okay";
+		};
+
 	};
 };
-- 
1.8.1.2

