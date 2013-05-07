Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab3EGE3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:29:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3EGEZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:58 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=epZaAQJ01QAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DdXK66c3KMYA:10 a=wCmvBT1CAAAA:8 a=JfrnYn6hAAAA:8 a=drOt6m5kAAAA:8 a=FP58Ms26AAAA:8 a=Z4Rwk6OoAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=8HaUlT0CE8IA:10 a=3Rfx1nUSh_UA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=lLNwBsiYNJVVeVZ8:21 a=gQ6u5wy0EQrQHr_L:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035851.894681815@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [066/126] hfsplus: fix potential overflow in hfsplus_file_truncate()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0066-hfsplus-fix-potential-overflow-in-hfsplus_file_trunc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vyacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 12f267a20aecf8b84a2a9069b9011f1661c779b4 ]

Change a u32 to loff_t hfsplus_file_truncate().

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/hfsplus/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 5849e3e..32b12e5 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -517,7 +517,7 @@ void hfsplus_file_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 
 		res = pagecache_write_begin(NULL, mapping, size, 0,
 						AOP_FLAG_UNINTERRUPTIBLE,
-- 
1.7.10.4


