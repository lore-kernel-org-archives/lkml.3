Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3EaLNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:13:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3EaLNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:13:10 -0400
Date: Fri, 31 May 2013 04:12:38 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-6956664a5c4c32d5aa48fe96d5e2421a3e3f72d5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sukadev@linux.vnet.ibm.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com,
        namhyung@kernel.org
In-Reply-To: <20130329192950.GA9312@us.ibm.com>
References: <20130329192950.GA9312@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix bug in isupper() and islower()
Git-Commit-ID: 6956664a5c4c32d5aa48fe96d5e2421a3e3f72d5
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

Commit-ID:  6956664a5c4c32d5aa48fe96d5e2421a3e3f72d5
Gitweb:     http://git.kernel.org/tip/6956664a5c4c32d5aa48fe96d5e2421a3e3f72d5
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Fri, 29 Mar 2013 12:14:43 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:51 +0300

perf tools: Fix bug in isupper() and islower()

One of the reasons 'perf test' is failing on Power appears to be due to
a bug in isupper().

isupper(c) and islower(c) should be checking 'c' against the mask 0x20.
Instead they are checking sane_ctype[c] which causes isupper() to be
true for lower case letters.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20130329192950.GA9312@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a45710b..7a484c9 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -221,8 +221,8 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
-#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
-#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
+#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
