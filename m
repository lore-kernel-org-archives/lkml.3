Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3CBNPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:15:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3CBNPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:15:23 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5BHuyXGbWtAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lh4F20eZPa0A:10 a=0qE759PFQrRirdWu8-AA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362230122.31874.8.camel@gandalf.local.home>
Subject: Re: [trace:tip/perf/core 5/15]
 kernel/trace/trace_functions.c:79:16: sparse: incorrect type in initializer
 (different address spaces)
From: Steven Rostedt <rostedt@goodmis.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 02 Mar 2013 08:15:22 -0500
In-Reply-To: <1362229972.31874.7.camel@gandalf.local.home>
References: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
	 <1362229972.31874.7.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 08:12 -0500, Steven Rostedt wrote:

> Hmm, actually it seems to be complaining everywhere but in trace.c which
> is where the per_cpu was allocated. Do I need to annotate the trace.h
> header to specify (at least to sparse) that the pointer is allocated per
> cpu?

I guess I need this patch:

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c597523..50a9c81 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -198,7 +198,7 @@ struct trace_array {
        struct list_head        systems;
        struct list_head        events;
        struct task_struct      *waiter;
-       struct trace_array_cpu  *data;
+       struct trace_array_cpu __percpu *data;
 };
 
 enum {

-- Steve


