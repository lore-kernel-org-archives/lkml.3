Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3ISSku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:40:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3ISSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:40:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/9] perf tools: Sharpen the libaudit dependencies test
Date: Thu, 19 Sep 2013 15:40:24 -0300
Message-Id: <1379616032-13061-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379616032-13061-1-git-send-email-acme@infradead.org>
References: <1379616032-13061-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
-- 
1.8.1.4

