Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565Ab3CHSB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:01:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab3CHSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:01:53 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0s9H3sysQVkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ekHsynXZwlYA:10 a=Q4bLJgByv824hRe0pqQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308175931.135352630@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Mar 2013 12:59:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 0/2] tracing: Snapshot command line and branch tracer fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two more patches to my queue. I added alloc_snapshot to the kernel
command line parameter to alloc allocation of the snapshot buffer
when the main tracing buffer is allocated, allowing the use of
tracing_snapshot() without the fear of it not being allocated.

Also Fengguang Wu's tests discovered that my changes broke the branch
tracer. I guess I should add that to my test suite ;-)

Steven Rostedt (Red Hat) (2):
      tracing: Add alloc_snapshot kernel command line parameter
      tracing: Fix the branch tracer that broke with buffer change

----
 Documentation/kernel-parameters.txt |    7 +++
 kernel/trace/trace.c                |   81 +++++++++++++++++++++--------------
 kernel/trace/trace.h                |    2 +-
 kernel/trace/trace_branch.c         |    4 +-
 kernel/trace/trace_events.c         |    4 +-
 5 files changed, 60 insertions(+), 38 deletions(-)

