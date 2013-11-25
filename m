Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab3KYObd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:31:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144Ab3KYNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:34 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Markus Trippelsdorf" <markus@trippelsdorf.de>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.699254835@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 30/87] perf tools: Fix getrusage() related build
 failure on glibc trunk
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Trippelsdorf <markus@trippelsdorf.de>

commit 7b78f13603c6fcb64e020a0bbe31a651ea2b657b upstream.

On a system running glibc trunk perf doesn't build:

    CC builtin-sched.o
builtin-sched.c: In function ‘get_cpu_usage_nsec_parent’: builtin-sched.c:399:16: error: storage size of ‘ru’ isn’t known builtin-sched.c:403:2: error: implicit declaration of function ‘getrusage’ [-Werror=implicit-function-declaration]
    [...]

Fix it by including sys/resource.h.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120404084527.GA294@x4
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/builtin-sched.c | 1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -14,6 +14,7 @@
 #include "util/debug.h"
 
 #include <sys/prctl.h>
+#include <sys/resource.h>
 
 #include <semaphore.h>
 #include <pthread.h>

