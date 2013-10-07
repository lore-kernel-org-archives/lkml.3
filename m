Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3JGTCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:02:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab3JGTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:02:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/6] perf tools: Fix libaudit test
Date: Mon,  7 Oct 2013 16:02:26 -0300
Message-Id: <1381172549-3210-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381172549-3210-1-git-send-email-acme@infradead.org>
References: <1381172549-3210-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In ubuntu systems the libaudit test was always failing due to the
newline in the printf call not being escaped, which somehow didn't
prevented the test from working as expected on other systems, such
as fedora18.

Fix it by removing the newline, as this is just a test, that program is
just a compile test.

The error messages, obtained using 'make V=1':

    CHK libaudit
<stdin>: In function ‘main’:
<stdin>:5:9: error: missing terminating " character [-Werror]
<stdin>:5:2: error: missing terminating " character
<stdin>:6:1: error: missing terminating " character [-Werror]
<stdin>:6:1: error: missing terminating " character
<stdin>:7:2: error: expected expression before ‘return’
<stdin>:8:1: error: expected ‘;’ before ‘}’ token
cc1: all warnings being treated as errors
config/Makefile:241: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev

After this change the test works as expected in all systems tested and the
'trace' tool is built when the needed devel packages are installed.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0trw8qs9hafeopc0vj1sicay@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-tests.mak | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index d5a8dd44945f..f79305739ecc 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -219,7 +219,7 @@ define SOURCE_LIBAUDIT
 
 int main(void)
 {
-	printf(\"error message: %s\n\", audit_errno_to_name(0));
+	printf(\"error message: %s\", audit_errno_to_name(0));
 	return audit_open();
 }
 endef
-- 
1.8.1.4

