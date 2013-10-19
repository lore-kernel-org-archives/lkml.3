Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3JSNfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 09:35:46 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49258 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3JSNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 09:35:45 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] digsig: replace ERR_PTR(PTR_ERR(...)) with ERR_CAST
Date: Sat, 19 Oct 2013 10:31:07 -0300
Message-Id: <1382189468-27189-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...)).

'err_cast.cocci' catch.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 lib/digsig.c | 2 +-
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
1.8.4

