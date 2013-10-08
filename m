Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3JHKmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:42:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3JHKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:41:49 -0400
Date: Tue, 8 Oct 2013 03:40:40 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-0trw8qs9hafeopc0vj1sicay@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix libaudit test
Git-Commit-ID: 47a92b828639dcb1a6033cd0a441099df828b7a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 03:40:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47a92b828639dcb1a6033cd0a441099df828b7a9
Gitweb:     http://git.kernel.org/tip/47a92b828639dcb1a6033cd0a441099df828b7a9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 2 Oct 2013 18:25:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 Oct 2013 15:16:05 -0300

perf tools: Fix libaudit test

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
index d5a8dd4..f793057 100644
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
