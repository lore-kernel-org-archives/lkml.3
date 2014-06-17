Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967479AbaFQWBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:01:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54866 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967118AbaFQVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 079/212] ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
Date: Tue, 17 Jun 2014 14:42:53 -0700
Message-Id: <1403041506-13646-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 1a88f809ccb5db1509a7514b187c00b3a995fc82 upstream.

The mvebu-devbus driver had a serious bug, which lead to a 8 bits bus
width declared in the Device Tree being considered as a 16 bits bus
width when configuring the hardware.

This bug in mvebu-devbus driver was compensated by a symetric mistake
in the Armada XP GP Device Tree: a 8 bits bus width was declared, even
though the hardware actually has a 16 bits bus width connection with
the NOR flash.

Now that we have fixed the mvebu-devbus driver to behave according to
its Device Tree binding, this commit fixes the problematic Device Tree
files as well.

This bug was introduced in commit
da8d1b38356853c37116f9afa29f15648d7fb159 ('ARM: mvebu: Add support for
NOR flash device on Armada XP-GP board') which was merged in v3.10.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397489361-5833-3-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: da8d1b383568 ('ARM: mvebu: Add support for NOR flash device on Armada XP-GP board')
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/armada-xp-gp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index 2298e4a..e325e62 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -49,7 +49,7 @@
 			/* Device Bus parameters are required */
 
 			/* Read parameters */
-			devbus,bus-width    = <8>;
+			devbus,bus-width    = <16>;
 			devbus,turn-off-ps  = <60000>;
 			devbus,badr-skew-ps = <0>;
 			devbus,acc-first-ps = <124000>;
-- 
1.9.1

