Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaHRJxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:53:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaHRJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Silesh C V <svellattu@mvista.com>, Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 076/137] coredump: fix the setting of PF_DUMPCORE
Date: Mon, 18 Aug 2014 10:32:17 +0100
Message-Id: <1408354398-10226-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/coredump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 729a2ededcb9..b2fa3937a7eb 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -302,7 +302,7 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 	if (unlikely(nr < 0))
 		return nr;
 
-	tsk->flags = PF_DUMPCORE;
+	tsk->flags |= PF_DUMPCORE;
 	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
-- 
1.9.1

