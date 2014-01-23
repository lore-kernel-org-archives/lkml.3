Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaAWTed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:34:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbaAWTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:27 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5/7] pid: rewrite task helper function is_global_init() avoiding task->pid
Date: Thu, 23 Jan 2014 14:32:38 -0500
Message-Id: <a8c13f38e0ecfa2c842f0075dbbde77f3e6befc9.1390495874.git.rgb@redhat.com>
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
References: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <cover.1390495874.git.rgb@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the access function task_pid_nr() to get pid.

(informed by ebiederman's ea5a4d01)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4e658c..f60de19 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1615,7 +1615,7 @@ static inline int pid_alive(struct task_struct *p)
  */
 static inline int is_global_init(struct task_struct *tsk)
 {
-	return tsk->pid == 1;
+	return task_pid_nr(tsk) == 1;
 }
 
 extern struct pid *cad_pid;
-- 
1.7.1

