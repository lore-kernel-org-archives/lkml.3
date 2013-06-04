Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3FDXUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:20:01 -0400
Received: from 1wt.eu ([62.212.114.60]:35316 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab3FDWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:48 -0400
Message-Id: <20130604172130.718498876@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 010/184] usermodehelper: introduce umh_complete(sub_info)
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b3449922502f5a161ee2b5022a33aec8472fbf18 upstream

Preparation.  Add the new trivial helper, umh_complete().  Currently it
simply does complete(sub_info->complete).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf: Adjusted to apply to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/kmod.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index a061472..2a27d17 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -206,6 +206,11 @@ void call_usermodehelper_freeinfo(struct subprocess_info *info)
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	complete(sub_info->complete);
+}
+
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -245,7 +250,7 @@ static int wait_for_helper(void *data)
 	if (sub_info->wait == UMH_NO_WAIT)
 		call_usermodehelper_freeinfo(sub_info);
 	else
-		complete(sub_info->complete);
+		umh_complete(sub_info);
 	return 0;
 }
 
@@ -280,7 +285,7 @@ static void __call_usermodehelper(struct work_struct *work)
 		/* FALLTHROUGH */
 
 	case UMH_WAIT_EXEC:
-		complete(sub_info->complete);
+		umh_complete(sub_info);
 	}
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



