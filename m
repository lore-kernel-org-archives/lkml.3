Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbaGWVUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:20:55 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:34190 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933585AbaGWVUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:24 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 5/6] openrisc: include l.swa in check for write data pagefault
Date: Thu, 24 Jul 2014 00:18:15 +0300
Message-Id: <1406150296-13308-6-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way to determine if a data pagefault was caused
by a write is to read the instruction at the PC that caused
the fault and check if it's a store instruction.
To recognize pagefaults caused by the l.swa instruction with
opcode 0x33, has to be included in the check.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 572d223..aac0bde 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -264,7 +264,7 @@ EXCEPTION_ENTRY(_data_page_fault_handler)
 	l.srli  r6,r6,26                   // check opcode for write access
 #endif
 
-	l.sfgeui r6,0x34		   // check opcode for write access
+	l.sfgeui r6,0x33		   // check opcode for write access
 	l.bnf   1f
 	l.sfleui r6,0x37
 	l.bnf   1f
-- 
1.8.3.2

