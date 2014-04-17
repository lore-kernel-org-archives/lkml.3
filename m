Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaDQXoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:44:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:64333 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944AbaDQXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:43:57 -0400
Message-Id: <20140417234256.185058335@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 17 Apr 2014 19:42:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: A couple of fixes
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This contains two fixes.

The first is to remove a duplication of creating debugfs files that
already exist and causes an error report to be printed due to the
failure of the second creation.

The second is a memory leak fix that was introduced in 3.14.

Please pull the latest trace-fixes-v3.15-rc1 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.15-rc1

Tag SHA1: cda50faf0eace20c60940638a550ecd5e9eac4c1
Head SHA1: 6ea6215fe394e320468589d9bba464a48f6d823a


Steven Rostedt (Red Hat) (1):
      tracing: Do not try to recreated toplevel set_ftrace_* files

zhangwei(Jovi) (1):
      tracing/uprobes: Fix uprobe_cpu_buffer memory leak

----
 kernel/trace/trace_functions.c | 16 ++++++++++------
 kernel/trace/trace_uprobe.c    |  6 ++++++
 2 files changed, 16 insertions(+), 6 deletions(-)
