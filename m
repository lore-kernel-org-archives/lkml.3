Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab3K0BkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:40:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6385 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759015Ab3K0Bjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:39:52 -0500
Message-Id: <20131127013841.321519823@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Nov 2013 20:38:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: Fix event null strings and function graph with modules
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes two fixes.

1) is a bug fix that happens when root does the following:

  echo function_graph > current_tracer
  modprobe foo
  echo nop > current_tracer

This causes the ftrace internal accounting to get screwed up and
crashes ftrace, preventing the user from using the function tracer
after that.

2) if a TRACE_EVENT has a string field, and NULL is given for it.

The internal trace event code does a strlen() and strcpy() on the
source of field. If it is NULL it causes the system to oops.

This bug has been there since 2.6.31, but no TRACE_EVENT ever passed
in a NULL to the string field, until now.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.13-rc1

Tag SHA1: 8186830c5ab0c57fae8e081ef0321443d8acb14c
Head SHA1: 8a56d7761d2d041ae5e8215d20b4167d8aa93f51


Steven Rostedt (Red Hat) (2):
      tracing: Allow events to have NULL strings
      ftrace: Fix function graph with loading of modules

----
 include/trace/ftrace.h |  5 ++--
 kernel/trace/ftrace.c  | 64 +++++++++++++++++++++++++++-----------------------
 2 files changed, 38 insertions(+), 31 deletions(-)
