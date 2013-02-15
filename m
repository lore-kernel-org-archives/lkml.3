Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3BOQjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:39:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3BOQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:39:31 -0500
Date: Fri, 15 Feb 2013 08:38:07 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-viqtvd6hppqgt68zz4wlqm20@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dirk.behme@de.bosch.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, dirk.behme@de.bosch.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Limit unwind support to x86 archs
Git-Commit-ID: 02320931ce000836aa231ac1311769e303122099
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:38:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02320931ce000836aa231ac1311769e303122099
Gitweb:     http://git.kernel.org/tip/02320931ce000836aa231ac1311769e303122099
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 14 Feb 2013 15:59:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 15:59:33 -0300

perf tools: Limit unwind support to x86 archs

There's DWARF unwind support only for x86 archs, so limit the unwind.o
object to them only.

Without this building for other archs (e.g. cross compiling for ARM) is
broken.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Link: http://lkml.kernel.org/n/tip-viqtvd6hppqgt68zz4wlqm20@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1c8df6f..b90528d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -581,6 +581,11 @@ else
 endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
+# There's only x86 (both 32 and 64) support for CFI unwind so far
+ifneq ($(ARCH),x86)
+	NO_LIBUNWIND := 1
+endif
+
 ifndef NO_LIBUNWIND
 # for linking with debug library, run like:
 # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
