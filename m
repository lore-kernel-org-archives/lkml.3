Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbaFQVqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:46:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965155AbaFQVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:46:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 071/212] ARM: orion5x: fix target ID for crypto SRAM window
Date: Tue, 17 Jun 2014 14:42:45 -0700
Message-Id: <1403041506-13646-72-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-orion5x/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-orion5x/common.h b/arch/arm/mach-orion5x/common.h
index f565f99..7548db2 100644
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
1.9.1

