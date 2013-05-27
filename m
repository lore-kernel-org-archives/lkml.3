Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3E0H6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:58:45 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:61667 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3E0H6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:58:44 -0400
From: Runzhen Wang <icycoder@gmail.com>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Runzhen Wang <icycoder@gmail.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH] perf tools: fix a wrong header file path in util/unwind.c
Date: Mon, 27 May 2013 15:54:26 +0800
Message-Id: <1369641266-16913-1-git-send-email-icycoder@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the latest perf core tree:
(git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git),
in util/unwind.c line 29 includes "perf_regs.h". That means compiler
will search for this header file in current directory, so, gcc will
puts the following error messages:

util/unwind.c: In function ‘access_mem’:
util/unwind.c:400:50: error: ‘PERF_REG_SP’ undeclared (first use in this
function)
util/unwind.c:400:50: note: each undeclared identifier is reported only
once for each function it appears in
util/unwind.c: In function ‘unwind__get_entries’:
util/unwind.c:562:41: error: ‘PERF_REG_IP’ undeclared (first use in this
function)

Changing #include "perf_regs.h" to #include <perf_regs.h> will fix the
error.

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/util/unwind.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 958723b..50e14f7 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -26,7 +26,7 @@
 #include <libunwind-ptrace.h>
 #include "thread.h"
 #include "session.h"
-#include "perf_regs.h"
+#include <perf_regs.h>
 #include "unwind.h"
 #include "util.h"
 
-- 
1.7.9.5

