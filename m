Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbaISFXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:23:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaISFXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:23:38 -0400
Date: Thu, 18 Sep 2014 22:22:44 -0700
From: tip-bot for Anton Blanchard <tipbot@zytor.com>
Message-ID: <tip-c657f423aed0d836c807ea1d6d8d28b3914446fa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        anton@samba.org, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <20140909091152.2698c0f7@kryten>
References: <20140909091152.2698c0f7@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Add path to Ubuntu kernel debuginfo file
Git-Commit-ID: c657f423aed0d836c807ea1d6d8d28b3914446fa
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

Commit-ID:  c657f423aed0d836c807ea1d6d8d28b3914446fa
Gitweb:     http://git.kernel.org/tip/c657f423aed0d836c807ea1d6d8d28b3914446fa
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 15 Sep 2014 16:57:56 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:10 -0300

perf symbols: Add path to Ubuntu kernel debuginfo file

Ubuntu places the kernel debuginfo in /usr/lib/debug/boot/vmlinux-*

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
Link: http://lkml.kernel.org/r/20140909091152.2698c0f7@kryten
[ Adapted it to use the perf.data file kernel version as in 0a7e6d1b6844 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1adb143..be84f7a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1757,7 +1757,7 @@ static int vmlinux_path__init(struct perf_session_env *env)
 	char bf[PATH_MAX];
 	char *kernel_version;
 
-	vmlinux_path = malloc(sizeof(char *) * 5);
+	vmlinux_path = malloc(sizeof(char *) * 6);
 	if (vmlinux_path == NULL)
 		return -1;
 
@@ -1788,6 +1788,12 @@ static int vmlinux_path__init(struct perf_session_env *env)
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/usr/lib/debug/boot/vmlinux-%s",
+		 kernel_version);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+        ++vmlinux_path__nr_entries;
 	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", kernel_version);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
