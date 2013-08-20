Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3HTVeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3HTVdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:44 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 10/12] pid: modify task_tgid_nr to work without task->tgid.
Date: Tue, 20 Aug 2013 17:32:02 -0400
Message-Id: <d4740f46a6b926e2753635460c68a3498b8d7a1e.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->tgid is an error prone construct and results in duplicate maintenance.
Start it's demise by modifying task_tgid_nr to not use it.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fb09b93..8e69807 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1495,7 +1495,7 @@ static inline pid_t task_pid_vnr(struct task_struct *tsk)
 
 static inline pid_t task_tgid_nr(struct task_struct *tsk)
 {
-	return tsk->tgid;
+	return pid_nr(task_tgid(tsk));
 }
 
 pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
-- 
1.7.1

