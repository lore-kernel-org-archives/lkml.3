Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3HVP7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:59:16 -0400
Received: from 2.mo3.mail-out.ovh.net ([46.105.75.36]:59338 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753727Ab3HVP7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:59:15 -0400
X-Greylist: delayed 12268 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 11:59:15 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 2/2] ARM: at91/dt: define phy available on sama5d3 mother board
Date: Thu, 22 Aug 2013 17:58:29 +0200
Message-Id: <1377187109-21981-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377186980-21902-1-git-send-email-b.brezillon@overkiz.com>
References: <1377186980-21902-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 3830030008635062380
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch describe the phy used on atmel sama5d3 mother board:
 - phy address
 - phy interrupt pin

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3xmb.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 8a9e05d..e9521d5 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -81,6 +81,14 @@
 
 			macb1: ethernet@f802c000 {
 				phy-mode = "rmii";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+				phy0: ethernet-phy@0 {
+					interrupt-parent = <&pioE>;
+					interrupts = <30 IRQ_TYPE_EDGE_FALLING>;
+					reg = <1>;
+				};
 			};
 
 			pinctrl@fffff200 {
-- 
1.7.9.5

