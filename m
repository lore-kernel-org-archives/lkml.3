Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3L0Ura (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:47:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35684 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3L0UrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 38/49] perf tools: Set event->header.misc to PERF_RECORD_MISC_GUEST_USER if machine is guest.
Date: Fri, 27 Dec 2013 17:46:54 -0300
Message-Id: <1388177225-17349-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

When we synthesize the mmap events of user space, if machine is guest,
we should set the event->header.misc to PERF_RECORD_MISC_GUEST_USER,
rather than PERF_RECORD_MISC_USER.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/e6f8ff6505d2db8a4b21bff8e448bb9be0bcff35.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index a61726ea01a9..07c07833de53 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -220,7 +220,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 		 */
-		event->header.misc = PERF_RECORD_MISC_USER;
+		if (machine__is_host(machine))
+			event->header.misc = PERF_RECORD_MISC_USER;
+		else
+			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
 
 		if (prot[2] != 'x') {
 			if (!mmap_data || prot[0] != 'r')
-- 
1.8.1.4

