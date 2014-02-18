Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaBRMmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:42:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:20805 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbaBRMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:42:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="477011333"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 07/11] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20140217144617.GT27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com> <20140217144617.GT27965@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 18 Feb 2014 14:42:23 +0200
Message-ID: <874n3wk2xb.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, Feb 06, 2014 at 12:50:30PM +0200, Alexander Shishkin wrote:
>> Add support for Intel Processor Trace (PT) to kernel's perf/itrace events.
>> PT is an extension of Intel Architecture that collects information about
>> software execuction such as control flow, execution modes and timings and
>> formats it into highly compressed binary packets. Even being compressed,
>> these packets are generated at hundreds of megabytes per second per core,
>> which makes it impractical to decode them on the fly in the kernel. Thus,
>> buffers containing this binary stream are zero-copy mapped to the debug
>> tools in userspace for subsequent decoding and analysis.
>> 
>> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> ---
>>  arch/x86/include/uapi/asm/msr-index.h     |  18 +
>>  arch/x86/kernel/cpu/Makefile              |   1 +
>>  arch/x86/kernel/cpu/intel_pt.h            | 127 ++++
>>  arch/x86/kernel/cpu/perf_event.c          |   4 +
>>  arch/x86/kernel/cpu/perf_event_intel.c    |  10 +
>>  arch/x86/kernel/cpu/perf_event_intel_pt.c | 991 ++++++++++++++++++++++++++++++
>>  6 files changed, 1151 insertions(+)
>>  create mode 100644 arch/x86/kernel/cpu/intel_pt.h
>>  create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c
>
> Andi said that when itrace is enabled the LBR is wrecked; this patch
> seems to fail to deal with that.

True, there needs to be a _safe() msr access before any configuration is
done, I have a fix for that, but let's first deal with the buffer
management.

Regards,
--
Alex
