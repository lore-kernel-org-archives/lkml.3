Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3AYLCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:02:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3AYLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:01:57 -0500
Date: Fri, 25 Jan 2013 03:01:22 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0bd3f0840bf4bc900b4beb8e792ad499b43dad3b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1355749718-4355-2-git-send-email-jolsa@redhat.com>
References: <1355749718-4355-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add missing closedir in multi tracepoint processing
Git-Commit-ID: 0bd3f0840bf4bc900b4beb8e792ad499b43dad3b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:01:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bd3f0840bf4bc900b4beb8e792ad499b43dad3b
Gitweb:     http://git.kernel.org/tip/0bd3f0840bf4bc900b4beb8e792ad499b43dad3b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 17 Dec 2012 14:08:36 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:10 -0300

perf tools: Add missing closedir in multi tracepoint processing

We don't close 'events' directory when reading multiple tracepoint
events. Adding missing closedir.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355749718-4355-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2d8d53be..d64ff29 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -408,6 +408,7 @@ static int add_tracepoint_multi(struct list_head **list, int *idx,
 		ret = add_tracepoint(list, idx, sys_name, evt_ent->d_name);
 	}
 
+	closedir(evt_dir);
 	return ret;
 }
 
