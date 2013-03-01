Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3CATto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:49:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3CATqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: [ 20/30] wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task
Date: Fri,  1 Mar 2013 11:45:41 -0800
Message-Id: <20130301194530.159088198@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Oleg Nesterov <oleg@redhat.com>

Upstream commit 9067ac85d533651b98c2ff903182a20cbb361fcb.

wake_up_process() should never wakeup a TASK_STOPPED/TRACED task.
Change it to use TASK_NORMAL and add the WARN_ON().

TASK_ALL has no other users, probably can be killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2778,7 +2778,8 @@ out:
  */
 int wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_ALL, 0);
+	WARN_ON(task_is_stopped_or_traced(p));
+	return try_to_wake_up(p, TASK_NORMAL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 


