Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCJVBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:01:51 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:35575 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbaCJVBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:01:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwGAKEnHlNbsHk5/2dsb2JhbABagwaCSIERvn6BIBd0glMTHCMYgQIkE4d9Ac9vjXdkhD8BA5hEAYpWh1eDLjyBLA
Date: Mon, 10 Mar 2014 22:01:48 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] fs/isofs/inode.c add __init to init_inodecache()
Message-Id: <20140310220148.df8c4583466ec55ca4db53e1@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_iso9660_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/isofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 4a9e10e..7df1914 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -93,7 +93,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	isofs_inode_cachep = kmem_cache_create("isofs_inode_cache",
 					sizeof(struct iso_inode_info),
-- 
1.8.1.4

