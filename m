Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3KVTRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:17:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3KVTRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:17:03 -0500
Date: Fri, 22 Nov 2013 20:18:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] proc: change do_task_stat() to use while_each_thread()
Message-ID: <20131122191818.GA16933@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122191803.GA16919@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_task_stat() can use while_each_thread(), no changes in
the compiled code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c995807..c59e74f 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -442,8 +442,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-				t = next_thread(t);
-			} while (t != task);
+			} while_each_thread(task, t);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-- 
1.5.5.1

