Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbaFIWpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:45:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbaFIWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>
Subject: [PATCH 3.14 43/78] sched: Fix sched_policy < 0 comparison
Date: Mon,  9 Jun 2014 15:48:23 -0700
Message-Id: <20140609224814.739297176@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3 upstream.

attr.sched_policy is u32, therefore a comparison against < 0 is never true.
Fix this by casting sched_policy to int.

This issue was reported by coverity CID 1219934.

Fixes: dbdb22754fde ("sched: Disallow sched_attr::sched_policy < 0")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1401741514-7045-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3707,7 +3707,7 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
 	if (retval)
 		return retval;
 
-	if (attr.sched_policy < 0)
+	if ((int)attr.sched_policy < 0)
 		return -EINVAL;
 
 	rcu_read_lock();


