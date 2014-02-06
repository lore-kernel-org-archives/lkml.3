Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaBGAAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 19:00:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:16114 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaBGAAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 19:00:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,796,1384329600"; 
   d="scan'208";a="477276710"
From: Andi Kleen <andi@firstfloor.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 09/11] x86: perf: intel_pt: Add core dump functionality
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com>
Date: Thu, 06 Feb 2014 15:59:46 -0800
In-Reply-To: <1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com>
	(Alexander Shishkin's message of "Thu, 6 Feb 2014 12:50:32 +0200")
Message-ID: <87iosr6bd9.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:
> +
> +static void pt_trace_core_output(struct coredump_params *cprm,
> +				 struct perf_event *event,
> +				 unsigned long len)
> +{
> +	struct pt_buffer *buf;
> +	u64 from, to;
> +	int ret;
> +
> +	buf = itrace_priv(event);
> +
> +	if (!dump_emit(cprm, pt_pmu.capstr, pt_pmu.caplen))
> +		return;

It would be nicer if this was a separate note, instead of just being
concatenated with the rest of the data.

Would make simpler parsing and be cleaner.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
