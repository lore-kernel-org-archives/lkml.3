Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbaFIJFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58507 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 069/146] ARM: orion5x: fix target ID for crypto SRAM window
Date: Mon,  9 Jun 2014 10:50:04 +0200
Message-Id: <c31101678ba3847d1ac1f28a8460b1f2ef03409a.1402303821.git.jslaby@suse.cz>
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

commit 1cc9d48145b81e307fab94a5cf6ee66ec2f0de60 upstream.

In commit 4ca2c04085a1caa903e92a5fc0da25362150aac2 ('ARM: orion5x:
Move to ID based window creation'), the mach-orion5x code was changed
to use the new mvebu-mbus API. However, in the process, a mistake was
made on the crypto SRAM window target ID: it should have been 0x9
(verified in the datasheet) and not 0x0.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Link: https://lkml.kernel.org/r/1397400006-4315-2-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: 4ca2c04085a1 ('ARM: orion5x: Move to ID based window creation')
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-orion5x/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-orion5x/common.h b/arch/arm/mach-orion5x/common.h
index f565f9944af2..7548db2bfb8a 100644
--- a/arch/arm/mach-orion5x/common.h
+++ b/arch/arm/mach-orion5x/common.h
@@ -21,7 +21,7 @@ struct mv_sata_platform_data;
 #define ORION_MBUS_DEVBUS_BOOT_ATTR   0x0f
 #define ORION_MBUS_DEVBUS_TARGET(cs)  0x01
 #define ORION_MBUS_DEVBUS_ATTR(cs)    (~(1 << cs))
-#define ORION_MBUS_SRAM_TARGET        0x00
+#define ORION_MBUS_SRAM_TARGET        0x09
 #define ORION_MBUS_SRAM_ATTR          0x00
 
 /*
-- 
1.9.3

