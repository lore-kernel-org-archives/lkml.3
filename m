Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3ITJ4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:56:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3ITJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:56:31 -0400
Date: Fri, 20 Sep 2013 02:55:39 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-33cbbdccf39f6d7e01c282c4320d818a75b67d54@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <20130912132706.GD23826@gmail.com>
References: <20130912132706.GD23826@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Sharpen the libaudit dependencies test
Git-Commit-ID: 33cbbdccf39f6d7e01c282c4320d818a75b67d54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:55:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33cbbdccf39f6d7e01c282c4320d818a75b67d54
Gitweb:     http://git.kernel.org/tip/33cbbdccf39f6d7e01c282c4320d818a75b67d54
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 12 Sep 2013 15:27:06 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Sep 2013 11:32:17 -0300

perf tools: Sharpen the libaudit dependencies test

There are older libaudit versions that don't have an
audit_errno_to_name() method, resulting in a builtin-trace.c build
error:

  builtin-trace.c: In function ‘trace__sys_exit’:
  builtin-trace.c:794: warning: implicit declaration of function ‘audit_errno_to_name’

Expand the libaudit test to detect this.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130912132706.GD23826@gmail.com
[ Fix the test by escaping the double quotes ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-tests.mak | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..7f550c1 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -210,6 +210,7 @@ define SOURCE_LIBAUDIT
 
 int main(void)
 {
+	printf(\"error message: %s\n\", audit_errno_to_name(0));
 	return audit_open();
 }
 endef
