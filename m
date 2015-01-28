Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbbA1VTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:19:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761157AbbA1UuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:25 -0500
Date: Wed, 28 Jan 2015 07:00:04 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-kb9s0xy5z8i51abdu4bgm3rv@git.kernel.org>
Cc: jolsa@redhat.com, namhyung@kernel.org, dsahern@gmail.com,
        adrian.hunter@intel.com, acme@redhat.com, hpa@zytor.com,
        eranian@google.com, tglx@linutronix.de, efault@gmx.de, bp@suse.de,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, dzickus@redhat.com,
        mingo@kernel.org
Reply-To: eranian@google.com, tglx@linutronix.de, efault@gmx.de, bp@suse.de,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        dzickus@redhat.com, namhyung@kernel.org, adrian.hunter@intel.com,
        dsahern@gmail.com, jolsa@redhat.com, acme@redhat.com, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Remove extraneous 'was'
  on error message
Git-Commit-ID: 267b677eec06de178558337f0074e30ec3d11d9b
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

Commit-ID:  267b677eec06de178558337f0074e30ec3d11d9b
Gitweb:     http://git.kernel.org/tip/267b677eec06de178558337f0074e30ec3d11d9b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 19 Jan 2015 11:54:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:04:15 -0300

perf evlist: Remove extraneous 'was' on error message

  [acme@mica ~]$ trace -p 3330
  Error:  Unable to find debugfs
  Hint:   Was your kernel was compiled with debugfs support?
                          ^^^
                          ^^^
  Hint:   Is the debugfs filesystem mounted?
  Hint:   Try 'sudo mount -t debugfs nodev /sys/kernel/debug'

Fix it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-kb9s0xy5z8i51abdu4bgm3rv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cbab1fb..2e507b5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1445,7 +1445,7 @@ int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
 	case ENOENT:
 		scnprintf(buf, size, "%s",
 			  "Error:\tUnable to find debugfs\n"
-			  "Hint:\tWas your kernel was compiled with debugfs support?\n"
+			  "Hint:\tWas your kernel compiled with debugfs support?\n"
 			  "Hint:\tIs the debugfs filesystem mounted?\n"
 			  "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'");
 		break;
