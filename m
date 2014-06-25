Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbaFYSU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:20:59 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:47452 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaFYSU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:20:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8HALARq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZR6hECBDhd1hDEvI4EaN4hGAapymBgXhWOINWQdhC0Fj3SKXYs2iDWDRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/adfs/dir_fplus.c: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:20:52 +0200
Message-Id: <1403720452-19247-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/adfs/dir_fplus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/dir_fplus.c b/fs/adfs/dir_fplus.c
index d9e3bee..a7b2595 100644
--- a/fs/adfs/dir_fplus.c
+++ b/fs/adfs/dir_fplus.c
@@ -58,7 +58,7 @@ adfs_fplus_read(struct super_block *sb, unsigned int id, unsigned int sz, struct
 	if (size > sizeof(dir->bh)/sizeof(dir->bh[0])) {
 		/* this directory is too big for fixed bh set, must allocate */
 		struct buffer_head **bh_fplus =
-			kzalloc(size * sizeof(struct buffer_head *),
+			kcalloc(size, sizeof(struct buffer_head *),
 				GFP_KERNEL);
 		if (!bh_fplus) {
 			adfs_error(sb, "not enough memory for"
-- 
1.9.1

