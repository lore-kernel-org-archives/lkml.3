Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3LQQLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:11:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3LQQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:11:44 -0500
Date: Tue, 17 Dec 2013 17:11:26 +0100
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
Message-ID: <20131217161126.GL13532@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 02:36:16PM +0200, Alexander Shishkin wrote:
> Instruction tracing PMUs are capable of recording a log of instruction
> execution flow on a cpu core, which can be useful for profiling and crash
> analysis. This patch adds itrace infrastructure for perf events and the
> rest of the kernel to use.
> 
> Since such PMUs can produce copious amounts of trace data, it may be
> impractical to process it inside the kernel in real time, but instead export
> raw trace streams to userspace for subsequent analysis. Thus, itrace PMUs
> may export their trace buffers, which can be mmap()ed to userspace from a
> perf event fd with a PERF_EVENT_ITRACE_OFFSET offset. To that end, perf
> is extended to work with multiple ring buffers per event, reusing the
> ring_buffer code in an attempt to reduce complexity.

Please read the thread here: https://lkml.org/lkml/2008/12/4/64

On my thoughts of this creative mmap() usage.

tl;dr: no f*cking way.
