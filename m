Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbaKRVaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:30:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaKRVaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:30:15 -0500
Date: Tue, 18 Nov 2014 22:30:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] exit: reparent: fix the dead-parent
	PR_SET_CHILD_SUBREAPER reparenting
Message-ID: <20141118213014.GA5010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212952.GA4754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->has_child_subreaper code in find_new_reaper() finds alive
"thread" but returns another "reaper" thread which can be dead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f773863..31da440 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -512,7 +512,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 			thread = reaper;
 			do {
 				if (!(thread->flags & PF_EXITING))
-					return reaper;
+					return thread;
 			} while_each_thread(reaper, thread);
 		}
 	}
-- 
1.5.5.1

