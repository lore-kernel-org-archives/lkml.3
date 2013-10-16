Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872Ab3JPQCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:02:19 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40669 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760597Ab3JPQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:02:15 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: lidza.louina@gmail.com
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] drivers: staging: dgap: Remove useless casting in dgap_parse.c
Date: Wed, 16 Oct 2013 12:57:36 -0300
Message-Id: <1381939056-27898-2-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
References: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting (void *) value returned by kmalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/staging/dgap/dgap_parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgap/dgap_parse.c b/drivers/staging/dgap/dgap_parse.c
index 5497e6d..d41aa1c 100644
--- a/drivers/staging/dgap/dgap_parse.c
+++ b/drivers/staging/dgap/dgap_parse.c
@@ -1013,7 +1013,7 @@ static void dgap_err(char *s)
 static struct cnode *dgap_newnode(int t)
 {
 	struct cnode *n;
-	if ( (n = (struct cnode *) kmalloc(sizeof(struct cnode ), GFP_ATOMIC) ) != NULL) {
+	if ( (n = kmalloc(sizeof(struct cnode ), GFP_ATOMIC) ) != NULL) {
 		memset( (char *)n, 0, sizeof(struct cnode ) );
 		n->type = t;
 	}
-- 
1.8.4

