Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaLUK40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:56:26 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34371 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLUK4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:56:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ceph: Use %zu to format size_t in ceph_fill_inline_data()
Date: Sun, 21 Dec 2014 11:56:19 +0100
Message-Id: <1419159379-11407-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit, where size_t is unsigned int:

fs/ceph/addr.c: In function ‘ceph_fill_inline_data’:
fs/ceph/addr.c:1419: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 10 has type ‘size_t’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f5013d92a7e6b73d..c81c0e004588b9e2 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1416,7 +1416,7 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 		}
 	}
 
-	dout("fill_inline_data %p %llx.%llx len %lu locked_page %p\n",
+	dout("fill_inline_data %p %llx.%llx len %zu locked_page %p\n",
 	     inode, ceph_vinop(inode), len, locked_page);
 
 	if (len > 0) {
-- 
1.9.1

