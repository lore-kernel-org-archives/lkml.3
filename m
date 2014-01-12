Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaALShR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45829 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaALShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:13 -0500
Date: Sun, 12 Jan 2014 10:36:55 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-fb50bb43d051d12aad9e2337d0d5d14d0d3dd281@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <3dd652201171a19c910b500984c7c3590e77603b.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <3dd652201171a19c910b500984c7c3590e77603b.1387572416.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support for PERF_RECORD_MISC_GUEST_USER in thread__find_addr_map().
Git-Commit-ID: fb50bb43d051d12aad9e2337d0d5d14d0d3dd281
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:37:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb50bb43d051d12aad9e2337d0d5d14d0d3dd281
Gitweb:     http://git.kernel.org/tip/fb50bb43d051d12aad9e2337d0d5d14d0d3dd281
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 20 Dec 2013 15:52:56 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Dec 2013 16:49:49 -0300

perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in thread__find_addr_map().

This patch remove a TODO in thread__find_addr_map() and add support of
PERF_RECORD_MISC_GUEST_USER.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/3dd652201171a19c910b500984c7c3590e77603b.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index fe20227..484e994 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -659,15 +659,10 @@ void thread__find_addr_map(struct thread *thread,
 		al->level = 'g';
 		mg = &machine->kmaps;
 		load_map = true;
+	} else if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest) {
+		al->level = 'u';
 	} else {
-		/*
-		 * 'u' means guest os user space.
-		 * TODO: We don't support guest user space. Might support late.
-		 */
-		if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest)
-			al->level = 'u';
-		else
-			al->level = 'H';
+		al->level = 'H';
 		al->map = NULL;
 
 		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
