Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaJVOSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:18:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:50855 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaJVOSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:18:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="404148388"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        mathieu.poirier@linaro.org
Subject: Re: [PATCH v5 06/20] perf: Add AUX record
In-Reply-To: <20141022132608.GM12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-7-git-send-email-alexander.shishkin@linux.intel.com> <20141022132608.GM12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Oct 2014 17:18:29 +0300
Message-ID: <87fvegdw7e.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:34PM +0300, Alexander Shishkin wrote:
>> +	/*
>> +	 * Records that new data landed in the AUX buffer part.
>> +	 *
>> +	 * struct {
>> +	 * 	struct perf_event_header	header;
>> +	 *
>> +	 * 	u64				aux_offset;
>> +	 * 	u64				aux_size;
>> +	 *	u64				flags;
>> +	 * 	struct sample_id		sample_id;
>> +	 * };
>> +	 */
>> +	PERF_RECORD_AUX				= 11,
>
> Given the discussion with the ARM people the last time, do we want to
> add the possibility of a variable data field in this event? Its easy to
> add now, harder to do later (although not impossible).

Iirc, what they want is to save a once-per-session chunk of data, which
would be better synthesized by perf record than sent from a pmu driver?

We do something like that with PT right now, perf record looks at pmu's
sysfs attributes and stores them in some synthesized record.

> Also added Mathieu Poirier on CC, he asked to be included in your next
> postings.

Indeed, my apologies.

Regards,
--
Alex
