Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3H1LEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:04:23 -0400
Received: from 13.mo3.mail-out.ovh.net ([188.165.33.202]:39570 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753082Ab3H1LEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:04:21 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 2/9] ARM: at91/dt: add ethernet phy to at91rm9200ek board
Date: Wed, 28 Aug 2013 13:03:39 +0200
Message-Id: <1377687819-10653-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 15639875607332878560
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ethernet phy node in at91rm9200ek.dts.
The reg register is not specified, as it may differ depending on the init
process of the board:
ADDR0/1 phy pins are connected to PA13/14 rm9200 pins. Which means the phy
will take its address from these pins during the reset process.

The macb driver will launch a full scan on the mdio bus to discover the phy
address.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91rm9200ek.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
index d2d72c3..37b0880 100644
--- a/arch/arm/boot/dts/at91rm9200ek.dts
+++ b/arch/arm/boot/dts/at91rm9200ek.dts
@@ -47,6 +47,11 @@
 			macb0: ethernet@fffbc000 {
 				phy-mode = "rmii";
 				status = "okay";
+
+				phy0: ethernet-phy {
+					interrupt-parent = <&pioC>;
+					interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
+				};
 			};
 
 			usb1: gadget@fffb0000 {
-- 
1.7.9.5

