Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaBGJJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:09:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:16585 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBGJJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:09:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,799,1384329600"; 
   d="scan'208";a="479510357"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 09/11] x86: perf: intel_pt: Add core dump functionality
In-Reply-To: <87iosr6bd9.fsf@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com> <87iosr6bd9.fsf@tassilo.jf.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Feb 2014 11:09:26 +0200
Message-ID: <87lhxnl261.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:
>> +
>> +static void pt_trace_core_output(struct coredump_params *cprm,
>> +				 struct perf_event *event,
>> +				 unsigned long len)
>> +{
>> +	struct pt_buffer *buf;
>> +	u64 from, to;
>> +	int ret;
>> +
>> +	buf = itrace_priv(event);
>> +
>> +	if (!dump_emit(cprm, pt_pmu.capstr, pt_pmu.caplen))
>> +		return;
>
> It would be nicer if this was a separate note, instead of just being
> concatenated with the rest of the data.
>
> Would make simpler parsing and be cleaner.

So long as we won't have to include traces from two different pmus in
the same core file, then matching these sections may provide another
challenge. Doesn't seem like a sensible scenario, though.

Regards,
--
Alex
