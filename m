Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaALShg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45854 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaALSh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:28 -0500
Date: Sun, 12 Jan 2014 10:37:13 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-73547aacdcd45cdf8b53245ded9593d7c587501a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <e6f8ff6505d2db8a4b21bff8e448bb9be0bcff35.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <e6f8ff6505d2db8a4b21bff8e448bb9be0bcff35.1387572416.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Set event->
 header.misc to PERF_RECORD_MISC_GUEST_USER if machine is guest.
Git-Commit-ID: 73547aacdcd45cdf8b53245ded9593d7c587501a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:37:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73547aacdcd45cdf8b53245ded9593d7c587501a
Gitweb:     http://git.kernel.org/tip/73547aacdcd45cdf8b53245ded9593d7c587501a
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 20 Dec 2013 15:52:58 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Dec 2013 16:49:50 -0300

perf tools: Set event->header.misc to PERF_RECORD_MISC_GUEST_USER if machine is guest.

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
index a61726e..07c0783 100644
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
