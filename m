Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab3LIKFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:05:48 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34380 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755818Ab3LIKFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:05:46 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ipslinux@adaptec.com, aacraid@adaptec.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] ips: remove unused defines
Date: Mon,  9 Dec 2013 11:05:40 +0100
Message-Id: <1386583540-5190-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382857160-3306-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382857160-3306-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused defines from drivers/scsi/ips.h

- the min() macro is not used
- the __iomem define is no longer needed
  to compile ips.c without warnings

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/ips.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
index 45b9566b928e..26df4f6e9d70 100644
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -88,14 +88,6 @@
 		touch_nmi_watchdog();	\
 	} while (0)
 
-   #ifndef min
-      #define min(x,y) ((x) < (y) ? x : y)
-   #endif
-
-   #ifndef __iomem       /* For clean compiles in earlier kernels without __iomem annotations */
-      #define __iomem
-   #endif
-
    #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
 
-- 
1.8.3.2

