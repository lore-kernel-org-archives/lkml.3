Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaJXHuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:50:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:64637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbaJXHuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:50:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="624506285"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141022142706.GS12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022142706.GS12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 10:50:07 +0300
Message-ID: <8761f93o0g.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
>> +	if (test_cpu_cap(&boot_cpu_data, X86_FEATURE_INTEL_PT)) {
>> +		for (i = 0; i < PT_CPUID_LEAVES; i++)
>> +			cpuid_count(20, i,
>> +				    &pt_pmu.caps[CR_EAX + i * 4],
>> +				    &pt_pmu.caps[CR_EBX + i * 4],
>> +				    &pt_pmu.caps[CR_ECX + i * 4],
>> +				    &pt_pmu.caps[CR_EDX + i * 4]);
>> +	} else
>> +		return -ENODEV;
>
> Please use {} for every multi-line stmt, even if its a single stmt, also
> use {} in both branches of a condition, even if only one strictly
> requires it.

Ok.
