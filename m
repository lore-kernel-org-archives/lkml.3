Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbaHHOhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:37:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54149 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756983AbaHHOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:37:14 -0400
Message-Id: <20140808143254.145903999@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 08 Aug 2014 10:32:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 0/4] [GIT PULL] tracing/arm/arm64: Basic IPI tracing
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Nicolas Pitre added generic tracepoints for tracing IPIs and updated the
arm and arm64 architectures. It required some minor updates to the generic
tracepoint system, so it had to wait for me to implement them.

I know this is a little late in the merge window, but Nicolas had these out
for a while, and my going on vacation prevented them from getting in earlier.

I've ran them through all my tests, and uploaded them to korg to make sure
they pass Wu's tests as well.

Please pull the latest trace-ipi-tracepoints tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-ipi-tracepoints

Tag SHA1: 648c6f8edfeede5fb34aa6307e0944b33aa24c43
Head SHA1: 45ed695ac10a23cb4e60a3e0b68b3f21a8670670


Nicolas Pitre (3):
      tracepoint: add generic tracepoint definitions for IPI tracing
      ARM: add IPI tracepoints
      ARM64: add IPI tracepoints

Steven Rostedt (1):
      tracing: Do not do anything special with tracepoint_string when tracing is disabled

----
 arch/arm/kernel/smp.c        | 70 ++++++++++++++++++++--------------
 arch/arm64/kernel/smp.c      | 65 +++++++++++++++++++-------------
 include/linux/ftrace_event.h | 34 -----------------
 include/linux/tracepoint.h   | 44 ++++++++++++++++++++++
 include/trace/events/ipi.h   | 89 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 214 insertions(+), 88 deletions(-)
