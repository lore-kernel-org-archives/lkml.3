Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaGUVrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:47:52 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:17436 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbaGUVru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:47:50 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-next@vger.kernel.org, linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Steve French <sfrench@samba.org>
Subject: [PATCH linux-next] cifs: remove unused function cifs_oplock_break_wait
Date: Mon, 21 Jul 2014 23:47:36 +0200
Message-Id: <1405979256-8921-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 743162013d40 ("sched: Remove proliferation of wait_on_bit() action
functions") has removed the call to cifs_oplock_break_wait, making this
function unused; remove it.

This fixes the following compilation warning:

  fs/cifs/misc.c:578:1: warning: ‘cifs_oplock_break_wait’ defined but not used [-Wunused-function]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Steve French <sfrench@samba.org>
---

Hi,

This can be seen with e.g. linux next-20140721 and arm allmodconfig.

Best regards,

V.

 fs/cifs/misc.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 9a70792..65c2682 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -574,13 +574,6 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 		cinode->oplock = 0;
 }
 
-static int
-cifs_oplock_break_wait(void *unused)
-{
-	schedule();
-	return signal_pending(current) ? -ERESTARTSYS : 0;
-}
-
 /*
  * We wait for oplock breaks to be processed before we attempt to perform
  * writes.
-- 
2.0.1

