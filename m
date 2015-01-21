Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbbAUPFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:05:00 -0500
Received: from mail.kernel.org ([198.145.29.136]:43337 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbbAUPBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:25 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/9] perf evlist: Remove extraneous 'was' on error message
Date: Wed, 21 Jan 2015 12:01:02 -0300
Message-Id: <1421852470-20153-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index cbab1fb77b1d..2e507b5025a3 100644
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
-- 
1.9.3

