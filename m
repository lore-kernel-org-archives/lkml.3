Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaBQOqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:46:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43524 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBQOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:46:28 -0500
Date: Mon, 17 Feb 2014 15:46:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 07/11] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20140217144617.GT27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 12:50:30PM +0200, Alexander Shishkin wrote:
> Add support for Intel Processor Trace (PT) to kernel's perf/itrace events.
> PT is an extension of Intel Architecture that collects information about
> software execuction such as control flow, execution modes and timings and
> formats it into highly compressed binary packets. Even being compressed,
> these packets are generated at hundreds of megabytes per second per core,
> which makes it impractical to decode them on the fly in the kernel. Thus,
> buffers containing this binary stream are zero-copy mapped to the debug
> tools in userspace for subsequent decoding and analysis.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h     |  18 +
>  arch/x86/kernel/cpu/Makefile              |   1 +
>  arch/x86/kernel/cpu/intel_pt.h            | 127 ++++
>  arch/x86/kernel/cpu/perf_event.c          |   4 +
>  arch/x86/kernel/cpu/perf_event_intel.c    |  10 +
>  arch/x86/kernel/cpu/perf_event_intel_pt.c | 991 ++++++++++++++++++++++++++++++
>  6 files changed, 1151 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/intel_pt.h
>  create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c

Andi said that when itrace is enabled the LBR is wrecked; this patch
seems to fail to deal with that.
