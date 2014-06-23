Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaFWQrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:47:11 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:62664 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbaFWQrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:47:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAOpYqFNbskjJ/2dsb2JhbABZgw2rZgUBAQEBAQEFAZk1gQ8XdYQxLyOBGjeIRgHEJxeFY4kZHYQtBJpMk2ODRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 1/1] fs/pstore/ram.c:  replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:45:49 +0200
Message-Id: <1403541949-11131-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/pstore/ram.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 3b57443..87aa37c 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -347,8 +347,7 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 	if (!cxt->max_dump_cnt)
 		return -ENOMEM;
 
-	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_cnt,
-			     GFP_KERNEL);
+	cxt->przs = kcalloc(cxt->max_dump_cnt, sizeof(*cxt->przs), GFP_KERNEL);
 	if (!cxt->przs) {
 		dev_err(dev, "failed to initialize a prz array for dumps\n");
 		goto fail_prz;
-- 
1.8.4.5

