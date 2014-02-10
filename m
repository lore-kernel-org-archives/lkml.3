Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaBJTzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:55:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaBJTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 067/124] arm: mvebu: fix length of SATA registers area in .dtsi
Date: Mon, 10 Feb 2014 11:40:07 -0800
Message-Id: <1392061264-28124-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 911492de45ccefc2bff4b8e0fb412287ca6fe9d9 upstream.

The length of the registers area for the Marvell 370/XP SATA
controller was incorrect in the .dtsi: 0x2400 while it should have
been 0x5000. Until now, this problem wasn't noticed because there was
a large static mapping for all I/Os set up by ->map_io(). But since
we're going to get rid of this static mapping, we need to ensure that
the register areas are properly sized.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/armada-370-xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 269b6b0..eadd0bf 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -80,7 +80,7 @@
 
 		sata@d00a0000 {
 			compatible = "marvell,orion-sata";
-			reg = <0xd00a0000 0x2400>;
+			reg = <0xd00a0000 0x5000>;
 			interrupts = <55>;
 			clocks = <&gateclk 15>, <&gateclk 30>;
 			clock-names = "0", "1";
-- 
1.8.3.2

