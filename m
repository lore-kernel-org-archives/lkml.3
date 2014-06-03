Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099AbaFCV3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:29:23 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:56013 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965063AbaFCV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:29:21 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andrea Adami <andrea.adami@gmail.com>
Subject: [PATCH 2/2] arm: sa1100: collie: add top boot mtd partition
Date: Tue,  3 Jun 2014 23:29:01 +0200
Message-Id: <1401830941-17086-3-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401830941-17086-1-git-send-email-andrea.adami@gmail.com>
References: <1401830941-17086-1-git-send-email-andrea.adami@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CFI mapping is now perfect so we can expose the top block, read only.
There isn't much to read, though, just the sharpsl_params values.

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/mach-sa1100/collie.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
index f26aeea..3f449b0 100644
--- a/arch/arm/mach-sa1100/collie.c
+++ b/arch/arm/mach-sa1100/collie.c
@@ -329,6 +329,11 @@ static struct mtd_partition collie_partitions[] = {
 		.name		= "rootfs",
 		.offset 	= MTDPART_OFS_APPEND,
 		.size		= 0x00e20000,
+	}, {
+		.name		= "bootblock",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 0x00020000,
+		.mask_flags	= MTD_WRITEABLE
 	}
 };
 
-- 
1.9.1

