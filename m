Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaFII6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58505 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/146] ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
Date: Mon,  9 Jun 2014 10:50:08 +0200
Message-Id: <0b1e0bc4b75b241e989d7a203122e62a63529ace.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f3aec8f3f05025e7b450102dae0759375346706e upstream.

The mvebu-devbus driver had a serious bug, which lead to a 8 bits bus
width declared in the Device Tree being considered as a 16 bits bus
width when configuring the hardware.

This bug in mvebu-devbus driver was compensated by a symetric mistake
in the Armada XP DB Device Tree: a 8 bits bus width was declared, even
though the hardware actually has a 16 bits bus width connection with
the NOR flash.

Now that we have fixed the mvebu-devbus driver to behave according to
its Device Tree binding, this commit fixes the problematic Device Tree
files as well.

This bug was introduced in commit
b484ff42df475c5087d614c4d477273e1906bcb9 ('ARM: mvebu: Add support for
NOR flash device on Armada XP-DB board') which was merged in v3.11.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397489361-5833-4-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: b484ff42df47 ('ARM: mvebu: Add support for NOR flash device on Armada XP-DB board')
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/armada-xp-db.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index bcf6d79a57ec..8c2fe44e4dfe 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -40,7 +40,7 @@
 			/* Device Bus parameters are required */
 
 			/* Read parameters */
-			devbus,bus-width    = <8>;
+			devbus,bus-width    = <16>;
 			devbus,turn-off-ps  = <60000>;
 			devbus,badr-skew-ps = <0>;
 			devbus,acc-first-ps = <124000>;
-- 
1.9.3

