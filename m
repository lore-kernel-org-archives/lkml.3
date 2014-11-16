Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaKPMom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:44:42 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:57932 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114AbaKPMol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:44:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAOabaFRbsk2U/2dsb2JhbABbgw6BLrhMBQF1mg8EAoEKFwEBAQEBfYRfI4EaN4hFAcBtj2mGPopkHYQ1BZIdjC+WeoFHAYI1PDCCSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 1/1] fs/affs/file.c: remove obsolete pagesize check
Date: Sun, 16 Nov 2014 13:44:24 +0100
Message-Id: <1416141864-20802-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux kernel doesn't manage page sizes below 4kb.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 05005bd..8faa659 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -15,10 +15,6 @@
 #include <linux/aio.h>
 #include "affs.h"
 
-#if PAGE_SIZE < 4096
-#error PAGE_SIZE must be at least 4096
-#endif
-
 static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
 
 static int
-- 
1.9.3

