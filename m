Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaB0MU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:20:57 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39679 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0MUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:20:55 -0500
Date: Thu, 27 Feb 2014 17:50:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sahara <keun-o.park@windriver.com>, josh@joshtriplett.org
Subject: [PATCH 36/46] kernel: Mark functions as static in kernel/tracepoint.c
Message-ID: <e3451542f23840c5047daf8ac1b5a74cb510f756.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in kernel/tracepoint.c because they are not
used outside this file.

This eliminates the following warning in kernel/tracepoint.c:
kernel/tracepoint.c:326:6: warning: no previous prototype for ‘module_update_tracepoints’ [-Wmissing-prototypes]
kernel/tracepoint.c:702:5: warning: no previous prototype for ‘tracepoint_module_notify’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/tracepoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..0e26255 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -323,7 +323,7 @@ static void tracepoint_update_probe_range(struct tracepoint * const *begin,
 }
 
 #ifdef CONFIG_MODULES
-void module_update_tracepoints(void)
+static void module_update_tracepoints(void)
 {
 	struct tp_module *tp_mod;
 
@@ -332,7 +332,7 @@ void module_update_tracepoints(void)
 			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
 }
 #else /* CONFIG_MODULES */
-void module_update_tracepoints(void)
+static void module_update_tracepoints(void)
 {
 }
 #endif /* CONFIG_MODULES */
@@ -699,7 +699,7 @@ static int tracepoint_module_going(struct module *mod)
 	return 0;
 }
 
-int tracepoint_module_notify(struct notifier_block *self,
+static int tracepoint_module_notify(struct notifier_block *self,
 			     unsigned long val, void *data)
 {
 	struct module *mod = data;
-- 
1.7.9.5

