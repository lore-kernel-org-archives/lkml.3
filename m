Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439Ab3DBKGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:06:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760978Ab3DBKGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:06:08 -0400
Date: Tue, 2 Apr 2013 03:05:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-20xezxim2y4agmkx7f3sucll@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf map browser:
  Exit just on well known key presses
Git-Commit-ID: d06f7911792780c6e973a137b766530c8d031aeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 03:05:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d06f7911792780c6e973a137b766530c8d031aeb
Gitweb:     http://git.kernel.org/tip/d06f7911792780c6e973a137b766530c8d031aeb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 28 Mar 2013 11:47:17 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:23:55 -0300

perf map browser: Exit just on well known key presses

Initial motivation was to avoid the confusing exit when when '/' is
pressed in non verbose mode, as specified in the help line searches
are only available in verbose mode.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-20xezxim2y4agmkx7f3sucll@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/map.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index 10b549c..95c7cfb 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -80,12 +80,20 @@ static int map_browser__run(struct map_browser *self)
 	while (1) {
 		key = ui_browser__run(&self->b, 0);
 
-		if (verbose && key == '/')
-			map_browser__search(self);
-		else
+		switch (key) {
+		case '/':
+			if (verbose)
+				map_browser__search(self);
+		default:
 			break;
+                case K_LEFT:
+                case K_ESC:
+                case 'q':
+                case CTRL('c'):
+                        goto out;
+		}
 	}
-
+out:
 	ui_browser__hide(&self->b);
 	return key;
 }
