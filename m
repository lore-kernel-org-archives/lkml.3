Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbaISFWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:22:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbaISFWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:22:33 -0400
Date: Thu, 18 Sep 2014 22:22:16 -0700
From: tip-bot for Chanho Park <tipbot@zytor.com>
Message-ID: <tip-512fe365373b9c95a70b4b6357503ee74d27214f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        chanho61.park@samsung.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        chanho61.park@samsung.com, tglx@linutronix.de
In-Reply-To: <1410487817-13403-1-git-send-email-chanho61.park@samsung.com>
References: <1410487817-13403-1-git-send-email-chanho61.park@samsung.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: define _DEFAULT_SOURCE for glibc_2.20
Git-Commit-ID: 512fe365373b9c95a70b4b6357503ee74d27214f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  512fe365373b9c95a70b4b6357503ee74d27214f
Gitweb:     http://git.kernel.org/tip/512fe365373b9c95a70b4b6357503ee74d27214f
Author:     Chanho Park <chanho61.park@samsung.com>
AuthorDate: Fri, 12 Sep 2014 11:10:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:10 -0300

perf tools: define _DEFAULT_SOURCE for glibc_2.20

_BSD_SOURCE was deprecated in favour of _DEFAULT_SOURCE since glibc
2.20[1]. To avoid build warning on glibc2.20, _DEFAULT_SOURCE should
also be defined.

[1]: https://sourceware.org/glibc/wiki/Release/2.20

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1410487817-13403-1-git-send-email-chanho61.park@samsung.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6ad2b5e..80bfdaa 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,6 +39,8 @@
 
 #define _ALL_SOURCE 1
 #define _BSD_SOURCE 1
+/* glibc 2.20 deprecates _BSD_SOURCE in favour of _DEFAULT_SOURCE */
+#define _DEFAULT_SOURCE 1
 #define HAS_BOOL
 
 #include <unistd.h>
