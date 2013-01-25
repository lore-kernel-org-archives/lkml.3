Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3AYL0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:26:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYL0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:26:09 -0500
Date: Fri, 25 Jan 2013 03:25:53 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-fba7a78220fd969beeaa9abbb97c5f7027a7b4fd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, sasha.levin@oracle.com,
        hpa@zytor.com, mingo@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1356120062-2648-1-git-send-email-sasha.levin@oracle.com>
References: <1356120062-2648-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  test correct variable after allocation
Git-Commit-ID: fba7a78220fd969beeaa9abbb97c5f7027a7b4fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:25:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fba7a78220fd969beeaa9abbb97c5f7027a7b4fd
Gitweb:     http://git.kernel.org/tip/fba7a78220fd969beeaa9abbb97c5f7027a7b4fd
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Fri, 21 Dec 2012 15:00:58 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:16 -0300

tools lib traceevent: test correct variable after allocation

we've tested the wrong variable for allocation failure, fix it to
test the right one.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1356120062-2648-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5a824e3..7538a1f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2481,7 +2481,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
 	free_token(token);
 	arg = alloc_arg();
-	if (!field) {
+	if (!arg) {
 		do_warning("%s: not enough memory!", __func__);
 		*tok = NULL;
 		return EVENT_ERROR;
