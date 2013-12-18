Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3LRNfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:35:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46985 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:35:04 -0500
Date: Wed, 18 Dec 2013 14:34:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131218133439.GR21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
 <20131217161126.GL13532@twins.programming.kicks-ass.net>
 <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:23:41PM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, Dec 11, 2013 at 02:36:16PM +0200, Alexander Shishkin wrote:
> >> Instruction tracing PMUs are capable of recording a log of instruction
> >> execution flow on a cpu core, which can be useful for profiling and crash
> >> analysis. This patch adds itrace infrastructure for perf events and the
> >> rest of the kernel to use.
> >> 
> >> Since such PMUs can produce copious amounts of trace data, it may be
> >> impractical to process it inside the kernel in real time, but instead export
> >> raw trace streams to userspace for subsequent analysis. Thus, itrace PMUs
> >> may export their trace buffers, which can be mmap()ed to userspace from a
> >> perf event fd with a PERF_EVENT_ITRACE_OFFSET offset. To that end, perf
> >> is extended to work with multiple ring buffers per event, reusing the
> >> ring_buffer code in an attempt to reduce complexity.
> >
> > Please read the thread here: https://lkml.org/lkml/2008/12/4/64
> >
> > On my thoughts of this creative mmap() usage.
> 
> That's unfortunate, it made sense to me. But let's then have a look at
> the alternative approaches. Bearing in mind that it is crucial for us to
> export trace buffers to userspace as opposed to processing the trace
> data in the kernel, the fact that we still need the normal perf data
> stream and your dislike for mmap trickery, we need two separate file
> descriptors: one for the perf data and one for the trace data.

Why don't you start by explaining _why_ you need a second stream to
begin with?
