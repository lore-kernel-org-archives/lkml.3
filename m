Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3AXTj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:39:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3AXTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:39:48 -0500
Date: Thu, 24 Jan 2013 11:39:33 -0800
From: tip-bot for Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Message-ID: <tip-a54164114b96b4693b42cdb553260eec41ea4393@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, hiraku.toyooka.gu@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hiraku.toyooka.gu@hitachi.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20121219070234.31200.93863.stgit@liselsia>
References: <20121219070234.31200.93863.stgit@liselsia>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add checks if tr->
 buffer is NULL in tracing_reset{_online_cpus}
Git-Commit-ID: a54164114b96b4693b42cdb553260eec41ea4393
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:39:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a54164114b96b4693b42cdb553260eec41ea4393
Gitweb:     http://git.kernel.org/tip/a54164114b96b4693b42cdb553260eec41ea4393
Author:     Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
AuthorDate: Wed, 19 Dec 2012 16:02:34 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 21 Jan 2013 13:22:32 -0500

tracing: Add checks if tr->buffer is NULL in tracing_reset{_online_cpus}

max_tr->buffer could be NULL in the tracing_reset{_online_cpus}. In this
case, a NULL pointer dereference happens, so we should return immediately
from these functions.

Note, the current code does not call tracing_reset*() with max_tr when
its buffer is NULL, but future code will. This patch is needed to prevent
the future code from crashing.

Link: http://lkml.kernel.org/r/20121219070234.31200.93863.stgit@liselsia

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f8b7c62..72b171b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -922,6 +922,9 @@ void tracing_reset(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer *buffer = tr->buffer;
 
+	if (!buffer)
+		return;
+
 	ring_buffer_record_disable(buffer);
 
 	/* Make sure all commits have finished */
@@ -936,6 +939,9 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	struct ring_buffer *buffer = tr->buffer;
 	int cpu;
 
+	if (!buffer)
+		return;
+
 	ring_buffer_record_disable(buffer);
 
 	/* Make sure all commits have finished */
