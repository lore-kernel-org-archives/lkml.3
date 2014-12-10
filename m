Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaLJQ7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:59:40 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39159 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbaLJQ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:59:38 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Ley Foon Tan <lftan@altera.com>
Cc: nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] nios2: add definition of ioremap_wc to io.h
Date: Wed, 10 Dec 2014 08:59:27 -0800
Message-Id: <1418230767-24597-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54887C05.0042,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix

drivers/gpu/drm/drm_bufs.c: In function 'drm_addmap_core':
drivers/gpu/drm/drm_bufs.c:213:5:
			error: implicit declaration of function 'ioremap_wc'

seen when building nios2:allmodconfig.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/nios2/include/asm/io.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/nios2/include/asm/io.h b/arch/nios2/include/asm/io.h
index 9102bfd..6e24d7c 100644
--- a/arch/nios2/include/asm/io.h
+++ b/arch/nios2/include/asm/io.h
@@ -45,6 +45,8 @@ static inline void iounmap(void __iomem *addr)
 	__iounmap(addr);
 }
 
+#define ioremap_wc ioremap_nocache
+
 /* Pages to physical address... */
 #define page_to_phys(page)	virt_to_phys(page_to_virt(page))
 #define page_to_bus(page)	page_to_virt(page)
-- 
1.9.1

