Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3DNVZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 17:25:07 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33507 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3DNVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 17:25:05 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: =Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: James Morris <james.l.morris@oracle.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] lib: digsig: Use ERR_CAST function
Date: Fri, 12 Apr 2013 04:12:34 +0300
Message-Id: <1365729154-24240-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ERR_CAST function instead of ERR_PTR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 lib/digsig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 2f31e6a..8793aed 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -209,7 +209,7 @@ int digsig_verify(struct key *keyring, const char *sig, int siglen,
 		kref = keyring_search(make_key_ref(keyring, 1UL),
 						&key_type_user, name);
 		if (IS_ERR(kref))
-			key = ERR_PTR(PTR_ERR(kref));
+			key = ERR_CAST(kref);
 		else
 			key = key_ref_to_ptr(kref);
 	} else {
-- 
1.7.9.5

