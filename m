Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaAWTeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:34:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbaAWTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:27 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4/7] pid: modify task_tgid_nr to work without task->tgid.
Date: Thu, 23 Jan 2014 14:32:37 -0500
Message-Id: <4c2bd4df9a53965a50c83e7ea38e0d39601a4326.1390495874.git.rgb@redhat.com>
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
References: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <cover.1390495874.git.rgb@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com>
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
index 195f6bd..b4e658c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1550,7 +1550,7 @@ static inline pid_t task_pid_vnr(struct task_struct *tsk)
 
 static inline pid_t task_tgid_nr(struct task_struct *tsk)
 {
-	return tsk->tgid;
+	return pid_nr(task_tgid(tsk));
 }
 
 pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
-- 
1.7.1

