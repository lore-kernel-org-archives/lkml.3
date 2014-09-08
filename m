Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaIHPVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:21:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60412 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaIHPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:21:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] cifs: remove dead code
Date: Mon, 08 Sep 2014 17:20:56 +0200
Message-ID: <3319326.1eJrmz0Vgc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AVBBbaIbRPcO1nlb10C8as/Jya4939kHshUzS0XTF9L
 wzvlq5SRpWMe43noeLIx01ZEHkYZTevDBaDBFLKqfpg26UhaWd
 CIz6KnAgL4RlllBlSK8eqxFyNnUbCRAtGmu0FkyB356fbpaNgw
 3i8KtCWmM2jpkj8pikIzJPD/gnmWP16peu+jDSvghapjO+JgpC
 ghMXMvsCiw63nnTowmtQrw9PhlWK5lQvsuNlPG/LGUd8kgfPFj
 18ts18Qr+6qC/qph0xjPqzgwNoOlwYRtpqccg4my87loyIi6LF
 qJ5OkLlVgpF5md9h3i5q5K0qrdGkv/T4FloeWjVUR99TtvSW2B
 3FXH5jNzjwmofJ2r2Cdg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cifs provides two dummy functions 'sess_auth_lanman' and
'sess_auth_kerberos' for the case in which the respective
features are not defined. However, the caller is also under
an #ifdef, so we just get warnings about unused code:

fs/cifs/sess.c:1109:1: warning: 'sess_auth_kerberos' defined but not used [-Wunused-function]
 sess_auth_kerberos(struct sess_data *sess_data)

Removing the dead functions gets rid of the warnings without
any downsides that I can see.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 07fe97ac6b0c..ab0fda6e8e58 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -745,14 +745,6 @@ out:
 	sess_free_buffer(sess_data);
 }
 
-#else
-
-static void
-sess_auth_lanman(struct sess_data *sess_data)
-{
-	sess_data->result = -EOPNOTSUPP;
-	sess_data->func = NULL;
-}
 #endif
 
 static void
@@ -1103,15 +1095,6 @@ out:
 	ses->auth_key.response = NULL;
 }
 
-#else
-
-static void
-sess_auth_kerberos(struct sess_data *sess_data)
-{
-	cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
-	sess_data->result = -ENOSYS;
-	sess_data->func = NULL;
-}
 #endif /* ! CONFIG_CIFS_UPCALL */
 
 /*

