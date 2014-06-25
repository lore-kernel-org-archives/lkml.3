Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaFYSl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:41:56 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:65148 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbaFYSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:41:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8HAJYXq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZR6hECBDhd1hDEvI4EaN4hGAasQmBcXhWOINWQdhC0Fj3SKXYs2iDWDRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/binfmt_elf.c: replace count*size kmalloc by kmalloc_array
Date: Wed, 25 Jun 2014 20:41:49 +0200
Message-Id: <1403721709-19498-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_array manages count*sizeof overflow.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/binfmt_elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3892c1a..49b1880 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1816,7 +1816,7 @@ static int elf_note_info_init(struct elf_note_info *info)
 	INIT_LIST_HEAD(&info->thread_list);
 
 	/* Allocate space for ELF notes */
-	info->notes = kmalloc(8 * sizeof(struct memelfnote), GFP_KERNEL);
+	info->notes = kmalloc_array(8, sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
-- 
1.9.1

