Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaFYLM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:12:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:30487 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaFYLMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:12:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,545,1400050800"; 
   d="scan'208";a="560702727"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 5/7] perf: add a pmu capability for "exclusive" events
In-Reply-To: <20140624171819.GQ3213@twins.programming.kicks-ass.net>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com> <1402501310-31940-6-git-send-email-alexander.shishkin@linux.intel.com> <20140624171819.GQ3213@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 25 Jun 2014 14:12:05 +0300
Message-ID: <87ionpxmyi.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Jun 11, 2014 at 06:41:48PM +0300, Alexander Shishkin wrote:
>> +static bool exclusive_event_ok(struct perf_event *event,
>> +			      struct perf_event_context *ctx)
>> +{
>> +	struct perf_event *iter_event;
>> +
>> +	if (!(event->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
>> +		return true;
>> +
>> +	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
>> +		if (exclusive_event_match(iter_event, event))
>> +			return false;
>> +	}
>
> This list iteration needs either rcu or ctx->lock or ctx->mutex, and the
> two callsites below don't have either afaict.

True, this needs to be done before perf_install_in_context() under the
same ctx->mutex. Thanks!

Regards,
--
Alex
