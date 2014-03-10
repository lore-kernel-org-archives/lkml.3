Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaCJU5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:57:08 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:61966 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755214AbaCJU5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:57:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmsGAGomHlNbsHk5/2dsb2JhbABagwbCV4EgF3SCZhwjGIECJBOHfQHPcI5bhD8EmEQBilaHV4MuPA
Date: Mon, 10 Mar 2014 21:56:58 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] HFSPLUS: add __init to hfsplus_create_attr_tree_cache()
Message-Id: <20140310215658.965a9750989dc3866713afd0@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus_create_attr_tree_cache is only called by __init init_hfsplus_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfsplus/attributes.c | 2 +-
 fs/hfsplus/hfsplus_fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/attributes.c b/fs/hfsplus/attributes.c
index 0f47890..caf89a7 100644
--- a/fs/hfsplus/attributes.c
+++ b/fs/hfsplus/attributes.c
@@ -11,7 +11,7 @@
 
 static struct kmem_cache *hfsplus_attr_tree_cachep;
 
-int hfsplus_create_attr_tree_cache(void)
+int __init hfsplus_create_attr_tree_cache(void)
 {
 	if (hfsplus_attr_tree_cachep)
 		return -EEXIST;
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 08846425b..bb75586 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -366,7 +366,7 @@ typedef int (*search_strategy_t)(struct hfs_bnode *,
  */
 
 /* attributes.c */
-int hfsplus_create_attr_tree_cache(void);
+int __init hfsplus_create_attr_tree_cache(void);
 void hfsplus_destroy_attr_tree_cache(void);
 hfsplus_attr_entry *hfsplus_alloc_attr_entry(void);
 void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry_p);
-- 
1.8.1.4

