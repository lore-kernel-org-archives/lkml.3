Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3JHKks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:40:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37561 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3JHKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:40:46 -0400
Date: Tue, 8 Oct 2013 03:40:20 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-6adb0b0ae26fcc35cfec068d71f13863faac5b44@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1379900700-5186-5-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Add default handler for mmap2 events
Git-Commit-ID: 6adb0b0ae26fcc35cfec068d71f13863faac5b44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 03:40:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6adb0b0ae26fcc35cfec068d71f13863faac5b44
Gitweb:     http://git.kernel.org/tip/6adb0b0ae26fcc35cfec068d71f13863faac5b44
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 22 Sep 2013 19:44:59 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 Oct 2013 15:16:04 -0300

perf tools: Add default handler for mmap2 events

Commands that do not implement an mmap2 handler should at least not die
with a segfault when processing files with MMAP2 events.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 70ffa41..37c4718 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -256,6 +256,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->sample = process_event_sample_stub;
 	if (tool->mmap == NULL)
 		tool->mmap = process_event_stub;
+	if (tool->mmap2 == NULL)
+		tool->mmap2 = process_event_stub;
 	if (tool->comm == NULL)
 		tool->comm = process_event_stub;
 	if (tool->fork == NULL)
