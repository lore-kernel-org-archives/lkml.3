Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3KOEzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:55:42 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41293 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab3KOEzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:55:31 -0500
X-AuditID: 85900ec0-d1d29b9000001514-e9-5285a8d80e20
Subject: [PATCH -tip RFC v2 10/22] ftrace/kprobes: Allow probing on some
 preparation functions
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:53:43 +0000
Message-ID: <20131115045343.27580.58030.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to prohibit probing on the functions
used for preparation. Those are safely probed because
those are not invoked from breakpoint/fault/debug handlers,
there is no chance to cause recursive exceptions.

Following functions are now removed from the kprobes blacklist.
update_bitfield_fetch_param
free_bitfield_fetch_param
kprobe_register

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kprobe.c |    2 +-
 kernel/trace/trace_probe.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 243f683..e0132b4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1151,7 +1151,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
  * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
  * lockless, but we can't race with this __init function.
  */
-static __kprobes
+static
 int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
 {
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959..43638a2 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -346,7 +346,7 @@ DEFINE_BASIC_FETCH_FUNCS(bitfield)
 #define fetch_bitfield_string		NULL
 #define fetch_bitfield_string_size	NULL
 
-static __kprobes void
+static void
 update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
@@ -359,7 +359,7 @@ update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 		update_symbol_cache(data->orig.data);
 }
 
-static __kprobes void
+static void
 free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*

