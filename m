Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3ISLLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:11:08 -0400
Received: from wmsmtp.opaltelecom.net ([62.24.128.253]:3660 "EHLO
	mxot-1.cpwnetworks.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004Ab3ISLLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:11:06 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2013 07:11:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAGDYOlI+GID9/2dsb2JhbABbgmZZg3upfYxshxqBN3SCKiVWNQImAi5EiAQDCKdZkh+BKYxzgUsdglOBNQOeLYtEgyWBZw
X-IPAS-Result: AuYEAGDYOlI+GID9/2dsb2JhbABbgmZZg3upfYxshxqBN3SCKiVWNQImAi5EiAQDCKdZkh+BKYxzgUsdglOBNQOeLYtEgyWBZw
X-IronPort-AV: E=Sophos;i="4.90,936,1371078000"; 
   d="scan'208";a="354455357"
Message-ID: <1379588429.2484.84.camel@samson1.armitage.org.uk>
Subject: [PATCH 1/1] Fix address of second XOR engine in Kirkwood SoC DT
From: Quentin Armitage <quentin@armitage.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>
Date: Thu, 19 Sep 2013 12:00:29 +0100
Organization: The Armitage family
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to be an error in the second address of the second XOR
engine in the Kirkwood SoC device tree, which is specified as 0xd0b00
but should be 0x60b00.

For confirmation of address see
http://www.marvell.com/embedded-processors/kirkwood/assets/FS_88F6180_9x_6281_OpenSource.pdf table 581 page 658.
Also see definition of XOR1_HIGH_PHYS_BASE in
arch/arm/mach-kirkwood/include/mach/kirkwood.h
#define XOR1_HIGH_PHYS_BASE    (KIRKWOOD_REGS_PHYS_BASE + 0x60B00)

Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>

---
 arch/arm/boot/dts/kirkwood.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/kirkwood.dtsi
b/arch/arm/boot/dts/kirkwood.dtsi
index cf7aeaf..63d4066 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -167,7 +167,7 @@
 		xor@60900 {
 			compatible = "marvell,orion-xor";
 			reg = <0x60900 0x100
-			       0xd0B00 0x100>;
+			       0x60B00 0x100>;
 			status = "okay";
 			clocks = <&gate_clk 16>;
 
---

