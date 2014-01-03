Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaACCLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:11:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44074 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751487AbaACCLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:46 -0500
Message-Id: <20140103021021.238772653@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/17] tracing/uprobes: Add support for more fetch methods 
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: b7e0bf341f6cfa92ae0a0e3d0c3496729595e1e9


Hyeoncheol Lee (1):
      tracing/probes: Add fetch{,_size} member into deref fetch method

Namhyung Kim (15):
      tracing/uprobes: Fix documentation of uprobe registration syntax
      tracing/probes: Fix basic print type functions
      tracing/kprobes: Factor out struct trace_probe
      tracing/uprobes: Convert to struct trace_probe
      tracing/kprobes: Move common functions to trace_probe.h
      tracing/probes: Integrate duplicate set_print_fmt()
      tracing/probes: Move fetch function helpers to trace_probe.h
      tracing/probes: Split [ku]probes_fetch_type_table
      tracing/probes: Implement 'stack' fetch method for uprobes
      tracing/probes: Move 'symbol' fetch method to kprobes
      tracing/probes: Implement 'memory' fetch method for uprobes
      tracing/uprobes: Pass 'is_return' to traceprobe_parse_probe_arg()
      tracing/uprobes: Fetch args before reserving a ring buffer
      tracing/uprobes: Add support for full argument access methods
      tracing/uprobes: Add @+file_offset fetch method

Oleg Nesterov (1):
      uprobes: Allocate ->utask before handler_chain() for tracing handlers

----
 Documentation/trace/uprobetracer.txt |  36 +-
 kernel/events/uprobes.c              |   4 +
 kernel/trace/trace_kprobe.c          | 824 +++++++++++++++++++----------------
 kernel/trace/trace_probe.c           | 440 +++++++------------
 kernel/trace/trace_probe.h           | 216 +++++++++
 kernel/trace/trace_uprobe.c          | 495 +++++++++++++++------
 6 files changed, 1214 insertions(+), 801 deletions(-)
