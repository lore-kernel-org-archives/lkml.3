Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaJXHwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:52:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:56699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbaJXHwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:52:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,779,1406617200"; 
   d="scan'208";a="595067400"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141022143418.GU12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022143418.GU12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 10:52:05 +0300
Message-ID: <8738ad3nx6.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
>> +static bool pt_event_valid(struct perf_event *event)
>> +{
>> +	u64 config = event->attr.config;
>> +
>> +	/* admin can set any packet generation parameters */
>> +	if (capable(CAP_SYS_ADMIN) && (config & PT_BYPASS_MASK) == config)
>> +		return true;
>> +
>> +	if ((config & PT_CONFIG_MASK) != config)
>> +		return false;
>> +
>> +	return true;
>> +}
>
> This seems to suggest PT is available to !priv users, is this right?

Yes, that's the intention. PT does CPL-based filtering in hardware and
unlike previous attempts at branch tracing, does not leak out-of-context
addresses (or any other information for that matter).

Regards,
--
Alex
