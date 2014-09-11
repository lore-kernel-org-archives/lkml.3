Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaIKIj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:39:26 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:14760 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbaIKIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:39:22 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>,
        "'sfrench@samba.org'" <sfrench@samba.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-cifs@vger.kernel.org'" <linux-cifs@vger.kernel.org>,
        "'samba-technical@lists.samba.org'" <samba-technical@lists.samba.org>
Date: Thu, 11 Sep 2014 16:39:17 +0800
Subject: [PATCH] cifs:fix build warnings
Thread-Topic: [PATCH] cifs:fix build warnings
Thread-Index: Ac/Nm66al6dDe1qdQiObatmyCAjtKgAABH/Q
Message-ID: <35FD53F367049845BC99AC72306C23D103CDBFBFB01C@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB01B@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103CDBFBFB01B@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8B8dY2g022111

this fix the following warningsï¼š
kernel.torvalds.git/fs/cifs/sess.c:751:1: warning: 'sess_auth_lanman' defined but not used [-Wunused-function]
kernel.torvalds.git/fs/cifs/sess.c:1109:1: warning: 'sess_auth_kerberos' defined but not used [-Wunused-function]

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
fs/cifs/sess.c | 19 -------------------
1 file changed, 19 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3a5e833..7bc9c03 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -744,15 +744,6 @@ out:
Â Â Â Â Â Â Â Â Â Â Â Â Â Â  sess_data->func = NULL;
Â Â Â Â Â Â Â Â Â Â Â Â Â Â  sess_free_buffer(sess_data);
}
-
-#else
-
-static void
-sess_auth_lanman(struct sess_data *sess_data)
-{
-Â Â Â Â Â Â Â Â Â Â Â Â Â  sess_data->result = -EOPNOTSUPP;
-Â Â Â Â Â Â Â Â Â Â Â Â Â  sess_data->func = NULL;
-}
#endif

Â static void
@@ -1102,16 +1093,6 @@ out:
Â Â Â Â Â Â Â Â Â Â Â Â Â Â  kfree(ses->auth_key.response);
Â Â Â Â Â Â Â Â Â Â Â Â Â Â  ses->auth_key.response = NULL;
}
-
-#else
-
-static void
-sess_auth_kerberos(struct sess_data *sess_data)
-{
-Â Â Â Â Â Â Â Â Â Â Â Â Â  cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
-Â Â Â Â Â Â Â Â Â Â Â Â Â  sess_data->result = -ENOSYS;
-Â Â Â Â Â Â Â Â Â Â Â Â Â  sess_data->func = NULL;
-}
#endif /* ! CONFIG_CIFS_UPCALL */

Â /*
-- 
2.1.0
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
