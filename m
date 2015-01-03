Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbbACRCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 12:02:20 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:10197 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbbACRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 12:02:17 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkOAGkfqFRXQzKq/2dsb2JhbABbgwaBKrNvBQEBAQEBAQUBd5cuBAKBBRcBAQEBAX2EaSOBGjeIMAGuc44FLIYDiRBkHYQTBZcIiWeHaSKBRQGCKT0xgQOBQAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ceph: use %zu for size_t display
Date: Sat,  3 Jan 2015 18:02:11 +0100
Message-Id: <1420304531-15176-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following 32-bit compilation warning:
fs/ceph/addr.c:1419:2: warning: format '%lu' expects argument of type
'long unsigned int', but argument 5 has type 'size_t' [-Wformat=]

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f5013d9..c81c0e0 100644
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
2.1.0

