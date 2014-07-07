Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaGGWpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:45:11 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45274 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaGGWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:45:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Kees Cook <keescook@chromium.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] torture: Avoid format string leak to thead name
Date: Mon,  7 Jul 2014 15:44:57 -0700
Message-Id: <1404773097-9932-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404773097-9932-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707224434.GA9624@linux.vnet.ibm.com>
 <1404773097-9932-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-1344-0000-0000-000002A9C745
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Since the torture-test thread creation interface does not include
format string arguments, this commit makes sure the name can never be
accidentally processed as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/torture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index 40bb511cca48..d600af21f022 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -708,7 +708,7 @@ int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
 	int ret = 0;
 
 	VERBOSE_TOROUT_STRING(m);
-	*tp = kthread_run(fn, arg, s);
+	*tp = kthread_run(fn, arg, "%s", s);
 	if (IS_ERR(*tp)) {
 		ret = PTR_ERR(*tp);
 		VERBOSE_TOROUT_ERRSTRING(f);
-- 
1.8.1.5

