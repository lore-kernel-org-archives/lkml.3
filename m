Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaIRCJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:09:43 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55798 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbaIRCJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:09:01 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] kdump: fix compiling error: undefined elfcorehdr_addr
Date: Thu, 18 Sep 2014 10:06:50 +0800
Message-Id: <1411006010-4645-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging the kdump kernel, I found there is a compiling error:
If is_kdump_kernel() is called in some driver(for example, add it in
debugging code in module qla2xxx), there will be a compiling error:

ERROR: "elfcorehdr_addr" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!

Add EXPORT_SYMBOL for elfcorehdr_addr will fix this.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 kernel/crash_dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/crash_dump.c b/kernel/crash_dump.c
index c766ee5..8cb4838 100644
--- a/kernel/crash_dump.c
+++ b/kernel/crash_dump.c
@@ -18,6 +18,7 @@ unsigned long saved_max_pfn;
  * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
  */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+EXPORT_SYMBOL(elfcorehdr_addr);
 
 /*
  * stores the size of elf header of crash image
-- 
2.0.0-rc0

