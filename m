Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3DOKmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:42:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3DOKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:42:34 -0400
Date: Mon, 15 Apr 2013 03:42:01 -0700
From: tip-bot for Tommi Rantala <tipbot@zytor.com>
Message-ID: <tip-8176cced706b5e5d15887584150764894e94e02f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        tglx@linutronix.de, tt.rantala@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, tglx@linutronix.de, tt.rantala@gmail.com
In-Reply-To: <1365882554-30259-1-git-send-email-tt.rantala@gmail.com>
References: <1365882554-30259-1-git-send-email-tt.rantala@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Treat attr.config as u64 in perf_swevent_init()
Git-Commit-ID: 8176cced706b5e5d15887584150764894e94e02f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 15 Apr 2013 03:42:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8176cced706b5e5d15887584150764894e94e02f
Gitweb:     http://git.kernel.org/tip/8176cced706b5e5d15887584150764894e94e02f
Author:     Tommi Rantala <tt.rantala@gmail.com>
AuthorDate: Sat, 13 Apr 2013 22:49:14 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Apr 2013 11:42:12 +0200

perf: Treat attr.config as u64 in perf_swevent_init()

Trinity discovered that we fail to check all 64 bits of
attr.config passed by user space, resulting to out-of-bounds
access of the perf_swevent_enabled array in
sw_perf_event_destroy().

Introduced in commit b0a873ebb ("perf: Register PMU
implementations").

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1365882554-30259-1-git-send-email-tt.rantala@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7e0962e..4d3124b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5331,7 +5331,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
