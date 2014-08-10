Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaHJUwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:52:01 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51949 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaHJUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:51:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steve French <sfrench@samba.org>, Sachin Prabhu <sprabhu@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] cifs: Remove unused sess_auth_kerberos() for !CONFIG_CIFS_UPCALL case
Date: Sun, 10 Aug 2014 22:51:49 +0200
Message-Id: <1407703909-24350-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407703909-24350-1-git-send-email-geert@linux-m68k.org>
References: <1407703909-24350-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_CIFS_UPCALL is not set:

fs/cifs/sess.c:1100: warning: ‘sess_auth_kerberos’ defined but not used

Commit cc87c47d9d7ac25554aa81cd8ded56e75f79c198 ("cifs: Separate
rawntlmssp auth from CIFS_SessSetup()") removed the sole user of the
dummy version of sess_auth_kerberos() in the non-CONFIG_CIFS_UPCALL
case, but forgot to remove the actual function definition.

Remove the dummy version to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/cifs/sess.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 8090ad3c5ea5..31817bd5f4b0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1092,17 +1092,7 @@ out:
 	kfree(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
-
-#else
-
-static void
-sess_auth_kerberos(struct sess_data *sess_data)
-{
-	cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
-	sess_data->result = -ENOSYS;
-	sess_data->func = NULL;
-}
-#endif /* ! CONFIG_CIFS_UPCALL */
+#endif /* CONFIG_CIFS_UPCALL */
 
 /*
  * The required kvec buffers have to be allocated before calling this
-- 
1.9.1

