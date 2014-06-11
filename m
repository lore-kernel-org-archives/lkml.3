Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaFKCBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:01:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56912 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752183AbaFKCBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:01:11 -0400
Message-Id: <20140611015948.013451560@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 10 Jun 2014 21:59:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/4] tracing: Cleanups and fixes for 3.16
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Namhyung Kim who pointed out some slight things with the code
that went to Linus already, I have some early cleanups.

There's also a bug that needs to be fixed in the ring buffer waiter
logic.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: da9c3413a27be5ba6f996e90495c836dd30b8841


Namhyung Kim (1)
      tracing: Cleanup saved_cmdlines_size changes

Steven Rostedt (Red Hat) (3)
      ring-buffer: Check if buffer exists before polling
      tracing: Fix leak of per cpu max data in instances
      tracing: Fix check of ftrace_trace_arrays list_empty() check

----
 include/linux/ring_buffer.h |    2 -
 kernel/trace/ring_buffer.c  |    5 +++-
 kernel/trace/trace.c        |   49 +++++++++++++++++++++++++++-----------------
 kernel/trace/trace.h        |    2 -
 4 files changed, 37 insertions(+), 21 deletions(-)
