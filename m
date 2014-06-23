Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaFWQmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:42:42 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:36344 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbaFWQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:42:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsHAKJYqFNbskjJ/2dsb2JhbABZgw2rZgUBAQEBAQEFAZF1h0CBDxd1hAsCJC8jgQIHETeILgMVAb1TDYZLF4VjhnSCJR2ELQSXZmyBeo1dhgaDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] fs/ubifs/super.c: replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:41:23 +0200
Message-Id: <1403541683-10898-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3904c85..537b91d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -796,8 +796,8 @@ static int alloc_wbufs(struct ubifs_info *c)
 {
 	int i, err;
 
-	c->jheads = kzalloc(c->jhead_cnt * sizeof(struct ubifs_jhead),
-			   GFP_KERNEL);
+	c->jheads = kcalloc(c->jhead_cnt, sizeof(struct ubifs_jhead),
+			    GFP_KERNEL);
 	if (!c->jheads)
 		return -ENOMEM;
 
-- 
1.8.4.5

