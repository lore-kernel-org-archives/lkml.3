Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaGIHar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:30:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45171 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaGIHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:30:46 -0400
Date: Wed, 9 Jul 2014 16:29:33 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: dgap: use kzalloc instead of kmalloc/memset
Message-ID: <20140709072933.GA30045@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index da11dfb..8e3fd87 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -7307,11 +7307,9 @@ static struct cnode *dgap_newnode(int t)
 {
 	struct cnode *n;
 
-	n = kmalloc(sizeof(struct cnode), GFP_KERNEL);
-	if (n) {
-		memset((char *)n, 0, sizeof(struct cnode));
+	n = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+	if (n)
 		n->type = t;
-	}
 	return n;
 }
 
-- 
1.7.1

