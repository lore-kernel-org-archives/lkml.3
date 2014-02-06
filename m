Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaBFU4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:56:03 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:20988 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbaBFU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:56:01 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsGANP181JbsGxA/2dsb2JhbABZgwyCQ4EOvDWBDRd0glMTHCMYgQI3iAkBzRQXjhZkHYQiBJgqAYpPh1KDLjuBLA
Date: Thu, 6 Feb 2014 21:55:59 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org
Subject: [PATCH 1/1] efs: Add __init macro to init_inodecache
Message-Id: <20140206215559.b4150bbd5a730960ffa3dbb8@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_efs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index 50215bb..f8def1a 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -91,7 +91,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	efs_inode_cachep = kmem_cache_create("efs_inode_cache",
 				sizeof(struct efs_inode_info),
-- 
1.8.1.4

