Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaG3Btd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:49:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaG3Btb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Silesh C V <svellattu@mvista.com>, Oleg Nesterov <oleg@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 13/21] coredump: fix the setting of PF_DUMPCORE
Date: Tue, 29 Jul 2014 18:48:42 -0700
Message-Id: <20140730014831.030390588@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014830.424826215@linuxfoundation.org>
References: <20140730014830.424826215@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Silesh C V <svellattu@mvista.com>

commit aed8adb7688d5744cb484226820163af31d2499a upstream.

Commit 079148b919d0 ("coredump: factor out the setting of PF_DUMPCORE")
cleaned up the setting of PF_DUMPCORE by removing it from all the
linux_binfmt->core_dump() and moving it to zap_threads().But this ended
up clearing all the previously set flags.  This causes issues during
core generation when tsk->flags is checked again (eg.  for PF_USED_MATH
to dump floating point registers).  Fix this.

Signed-off-by: Silesh C V <svellattu@mvista.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/coredump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -299,7 +299,7 @@ static int zap_threads(struct task_struc
 	if (unlikely(nr < 0))
 		return nr;
 
-	tsk->flags = PF_DUMPCORE;
+	tsk->flags |= PF_DUMPCORE;
 	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*


