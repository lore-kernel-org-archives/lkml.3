Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaFWQgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:36:37 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:56196 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbaFWQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:36:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsHANNWqFNbskjJ/2dsb2JhbABZgw2rZQUBAQEBAQEFAZF1h0CBDxd1hAsCUyOBCRE3iEYBxCUXhWOJGR2ELQSXZoJmk2ODRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH 1/1] fs/fuse/file.c: replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:35:15 +0200
Message-Id: <1403541315-10698-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/fuse/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6e16dad..ce7d55c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1955,8 +1955,8 @@ static int fuse_writepages(struct address_space *mapping,
 	data.ff = NULL;
 
 	err = -ENOMEM;
-	data.orig_pages = kzalloc(sizeof(struct page *) *
-				  FUSE_MAX_PAGES_PER_REQ,
+	data.orig_pages = kcalloc(FUSE_MAX_PAGES_PER_REQ,
+				  sizeof(struct page *),
 				  GFP_NOFS);
 	if (!data.orig_pages)
 		goto out;
-- 
1.8.4.5

