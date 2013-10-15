Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3JOFdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:33:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab3JOFdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:33:14 -0400
Date: Mon, 14 Oct 2013 22:33:02 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-h8k7h49z3cndqgjdftkmm9f8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@gmail.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@gmail.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix old GCC build error in '
 get_srcline'
Git-Commit-ID: a949fffb84df6f9be136198a00f796a9dc696bd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:33:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a949fffb84df6f9be136198a00f796a9dc696bd0
Gitweb:     http://git.kernel.org/tip/a949fffb84df6f9be136198a00f796a9dc696bd0
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 9 Oct 2013 21:51:31 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:28:52 -0300

perf tools: Fix old GCC build error in 'get_srcline'

trace-event-parse.c:parse_proc_kallsyms()

    Old GCC (4.4.2) does not see through the code flow of get_srcline() and
gets confused about the status of 'file' and 'line':

    CC       /tmp/build/perf/util/srcline.o
  cc1: warnings being treated as errors
  util/srcline.c: In function ¿get_srcline¿:
  util/srcline.c:226: error: ¿file¿ may be used uninitialized in this function
  util/srcline.c:227: error: ¿line¿ may be used uninitialized in this function
  make[1]: *** [/tmp/build/perf/util/srcline.o] Error 1
  make: *** [install] Error 2
  make: Leaving directory `/home/acme/git/linux/tools/perf'
  [acme@fedora12 linux]$

Help out GCC by initializing 'file' and 'line'.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Link: http://lkml.kernel.org/n/tip-h8k7h49z3cndqgjdftkmm9f8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 3735319..d11aefb 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -223,8 +223,8 @@ out:
 
 char *get_srcline(struct dso *dso, unsigned long addr)
 {
-	char *file;
-	unsigned line;
+	char *file = NULL;
+	unsigned line = 0;
 	char *srcline;
 	char *dso_name = dso->long_name;
 	size_t size;
