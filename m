Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3FDX0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:26:44 -0400
Received: from 1wt.eu ([62.212.114.60]:35182 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3FDWkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:53 -0400
Message-Id: <20130604172130.802022318@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 012/184] usermodehelper: ____call_usermodehelper() doesnt
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 need do_exit()

From: Oleg Nesterov <oleg@redhat.com>

commit 5b9bd473e3b8a8c6c4ae99be475e6e9b27568555 upstream

Minor cleanup.  ____call_usermodehelper() can simply return, no need to
call do_exit() explicitely.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf: adjusted to apply to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/kmod.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2c2a020..f12d883 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -193,7 +193,7 @@ static int ____call_usermodehelper(void *data)
 
 	/* Exec failed? */
 	sub_info->retval = retval;
-	do_exit(0);
+	return 0;
 }
 
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
-- 
1.7.12.2.21.g234cd45.dirty



