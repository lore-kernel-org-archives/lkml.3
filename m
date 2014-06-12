Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaFLMDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:03:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaFLMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:03:28 -0400
Date: Thu, 12 Jun 2014 05:03:16 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-2b1b71003ea809e619bd73e74dfc2a73069de66f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1401480605-97442-1-git-send-email-dzickus@redhat.com>
References: <1401480605-97442-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support to dynamically get cacheline size
Git-Commit-ID: 2b1b71003ea809e619bd73e74dfc2a73069de66f
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

Commit-ID:  2b1b71003ea809e619bd73e74dfc2a73069de66f
Gitweb:     http://git.kernel.org/tip/2b1b71003ea809e619bd73e74dfc2a73069de66f
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 30 May 2014 16:10:05 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 13:34:48 +0200

perf tools: Add support to dynamically get cacheline size

Different arches may have different cacheline sizes.  Look it up and set
a global variable for reference.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1401480605-97442-1-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.c      | 1 +
 tools/perf/util/util.c | 1 +
 tools/perf/util/util.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 78f7b92..95c58fc 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -458,6 +458,7 @@ int main(int argc, const char **argv)
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
+	cacheline_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 7fff6be..95aefa7 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -17,6 +17,7 @@
  * XXX We need to find a better place for these things...
  */
 unsigned int page_size;
+int cacheline_size;
 
 bool test_attr__enabled;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b03da44..6686436 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -304,6 +304,7 @@ char *rtrim(char *s);
 void dump_stack(void);
 
 extern unsigned int page_size;
+extern int cacheline_size;
 
 void get_term_dimensions(struct winsize *ws);
 
