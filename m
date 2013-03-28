Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3C1RDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:03:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47746
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756812Ab3C1RCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 36/36] perf map browser: Exit just on well known key presses
Date: Thu, 28 Mar 2013 14:02:36 -0300
Message-Id: <1364490156-32064-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 tools/perf/ui/browsers/map.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

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
-- 
1.7.1

