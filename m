Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3AaKnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:43:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36063 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3AaKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:43:43 -0500
Date: Thu, 31 Jan 2013 02:43:07 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-g449kvnbcpli4ceyxbe2jp1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Free browser->helpline()
  on ui_browser__hide()
Git-Commit-ID: 56ab7140325c835c8bb53cf3bca0cf7b6e967f15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:43:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56ab7140325c835c8bb53cf3bca0cf7b6e967f15
Gitweb:     http://git.kernel.org/tip/56ab7140325c835c8bb53cf3bca0cf7b6e967f15
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 22:45:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jan 2013 12:49:29 -0300

perf ui browser: Free browser->helpline() on ui_browser__hide()

It is allocated at ui_browser__show(), so free it in its counterpart,
ui_browser__hide().

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-g449kvnbcpli4ceyxbe2jp1e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 588bcb2..809ea46 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -273,6 +273,8 @@ void ui_browser__hide(struct ui_browser *browser __maybe_unused)
 {
 	pthread_mutex_lock(&ui__lock);
 	ui_helpline__pop();
+	free(browser->helpline);
+	browser->helpline = NULL;
 	pthread_mutex_unlock(&ui__lock);
 }
 
