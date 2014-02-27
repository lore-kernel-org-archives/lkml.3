Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaB0MYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:24:23 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64398 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0MYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:24:22 -0500
Date: Thu, 27 Feb 2014 17:52:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sahara <keun-o.park@windriver.com>, josh@joshtriplett.org
Subject: [PATCH 37/46] kernel: Include appropriate header file in tracepoint.c
Message-ID: <146d7ec7dd9959f01020fb5543699966b50484ef.1393493277.git.rashika.kheria@gmail.com>
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

Include appropriate header file include/trace/events/syscalls.h in
kernel/tracepoint.c because it has prototype definition of functions
defined in kernel/tracepoint.c.

This eliminates the following warning in kernel/tracepoint.c:
kernel/tracepoint.c:738:6: warning: no previous prototype for ‘syscall_regfunc’ [-Wmissing-prototypes]
kernel/tracepoint.c:755:6: warning: no previous prototype for ‘syscall_unregfunc’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/tracepoint.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 0e26255..124d733 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/static_key.h>
+#include <trace/events/syscalls.h>
 
 extern struct tracepoint * const __start___tracepoints_ptrs[];
 extern struct tracepoint * const __stop___tracepoints_ptrs[];
-- 
1.7.9.5

