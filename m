Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3KVTRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:17:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3KVTRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:17:06 -0500
Date: Fri, 22 Nov 2013 20:18:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] k_getrusage() can use while_each_thread()
Message-ID: <20131122191820.GA16936@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122191803.GA16919@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change k_getrusage() to use while_each_thread(), no changes in
the compiled code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 1d9a218..70d56d6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1572,8 +1572,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			t = p;
 			do {
 				accumulate_thread_rusage(t, r);
-				t = next_thread(t);
-			} while (t != p);
+			} while_each_thread(p, t);
 			break;
 
 		default:
-- 
1.5.5.1

