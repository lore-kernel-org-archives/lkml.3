Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaIIJdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:33:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:64230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbaIIJdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:33:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="600137390"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@redhat.com
Subject: Re: [PATCH v4 11/22] perf: add ITRACE_START record to indicate that tracing has started
In-Reply-To: <20140909090830.GZ19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-12-git-send-email-alexander.shishkin@linux.intel.com> <20140909090830.GZ19379@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Sep 2014 12:33:46 +0300
Message-ID: <871trluohx.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 20, 2014 at 03:36:08PM +0300, Alexander Shishkin wrote:
>> For counters such as instruction tracing, it is useful for the decoder
>> to know which tasks are running when the event is first scheduled in,
>> before the first sched_switch.
>> 
>> To single out such instruction tracing pmus, this patch alse introduces
>> ITRACE PMU capability.
>
> You forgot to tell why. Also explain why.
>
> The next context switch event will also tell you the previous task. So
> this seems like superfluous information. Also if you really want this
> you could simply emit an empty AUX record I suppose, no need to create
> yet another record type.

Before the first sched_switch we don't actually know what pid/tid is
running, so we can't make sense of the beginning of the trace without
some event reordering trickery. We can use AUX for that as well, I guess
this might be another use case for those flags in the AUX
record. Changelog, got it.

Adrian and Arnaldo cc'ed.

Cheers,
--
Alex
