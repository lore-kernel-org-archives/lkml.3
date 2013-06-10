Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3FJSnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3FJSnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:43:19 -0400
Date: Mon, 10 Jun 2013 20:33:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        John Stultz <johnstul@us.ibm.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] de_thread: mt-exec should update ->real_start_time
Message-ID: <20130610183317.GA14398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610183300.GA14379@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

924b42d5 "Use boot based time for process start time and boot
time in /proc" updated copy_process/do_task_stat but forgot
about de_thread(). This breaks "ps axOT" if a sub-thread execs.

Note: I think that task->start_time should die.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 00eaba7..aeace12 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -930,6 +930,7 @@ static int de_thread(struct task_struct *tsk)
 		 * also take its birthdate (always earlier than our own).
 		 */
 		tsk->start_time = leader->start_time;
+		tsk->real_start_time = leader->real_start_time;
 
 		BUG_ON(!same_thread_group(leader, tsk));
 		BUG_ON(has_group_leader_pid(tsk));
-- 
1.5.5.1

