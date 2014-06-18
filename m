Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaFRRio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:38:44 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:12599 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbaFRRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:38:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgKAAvOoVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZRphD+BCxd1hDEvI4ECGDeILgMVAcZlDYY2F4VihnCCIx2ELQSYSoF5izCCKIYAg0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/1] fs/ubifs/tnc.c: replace count*size kmalloc by kmalloc_array
Date: Wed, 18 Jun 2014 19:37:18 +0200
Message-Id: <1403113038-7359-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_array manages count*sizeof overflow.

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/tnc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 8a40cf9..2ed76c2 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1087,8 +1087,8 @@ static struct ubifs_znode *dirty_cow_bottom_up(struct ubifs_info *c,
 	ubifs_assert(znode);
 	if (c->zroot.znode->level > BOTTOM_UP_HEIGHT) {
 		kfree(c->bottom_up_buf);
-		c->bottom_up_buf = kmalloc(c->zroot.znode->level * sizeof(int),
-					   GFP_NOFS);
+		c->bottom_up_buf = kmalloc_array(c->zroot.znode->level,
+						 sizeof(int), GFP_NOFS);
 		if (!c->bottom_up_buf)
 			return ERR_PTR(-ENOMEM);
 		path = c->bottom_up_buf;
-- 
1.8.4.5

