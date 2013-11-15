Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3KOH2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:28:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3KOH0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:21 -0500
Date: Thu, 14 Nov 2013 23:25:36 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3g83ipasqi219ktv764xzzjs@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf ui browser:
  Fix segfault caused by off by one handling END key
Git-Commit-ID: 48d038fcd09fa231e254965c3b69f8f640c9e62d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:25:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48d038fcd09fa231e254965c3b69f8f640c9e62d
Gitweb:     http://git.kernel.org/tip/48d038fcd09fa231e254965c3b69f8f640c9e62d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 14 Nov 2013 15:30:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:00:31 -0300

perf ui browser: Fix segfault caused by off by one handling END key

$ perf record ls
$ perf report

Press 'down enter end'

Result:

Program received signal SIGSEGV, Segmentation fault.

The UI browser, used on a argv array would access past the end of the
array on SEEK_END because it wasn't using 'nr_entries - 1', fix it.

Reported-by: v.karpov@samsung.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=59291
Link: http://lkml.kernel.org/n/tip-3g83ipasqi219ktv764xzzjs@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3648d4e..cbaa7af 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -569,7 +569,7 @@ void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence)
 		browser->top = browser->top + browser->top_idx + offset;
 		break;
 	case SEEK_END:
-		browser->top = browser->top + browser->nr_entries + offset;
+		browser->top = browser->top + browser->nr_entries - 1 + offset;
 		break;
 	default:
 		return;
