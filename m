Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3KZHQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:16:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:30137 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab3KZHQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:16:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,773,1378882800"; 
   d="scan'208";a="441967426"
Message-ID: <52944A9A.6090906@linux.intel.com>
Date: Tue, 26 Nov 2013 09:15:38 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer@tamir.org.il>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
References: <20131120160450.072555619@infradead.org> <20131120162736.691879744@infradead.org> <528CF94E.8020300@linux.intel.com> <20131121101018.GX10022@twins.programming.kicks-ass.net> <528E09F9.9030501@linux.intel.com> <20131121133936.GF10022@twins.programming.kicks-ass.net> <528F0000.7000505@linux.intel.com> <20131122113044.GL10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131122113044.GL10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/2013 13:30, Peter Zijlstra wrote:
> On Fri, Nov 22, 2013 at 08:56:00AM +0200, Eliezer Tamir wrote:
>> On 21/11/2013 15:39, Peter Zijlstra wrote:
>>> On Thu, Nov 21, 2013 at 03:26:17PM +0200, Eliezer Tamir wrote:
> 
> Please use local_clock(), yes its slightly more expensive, but I doubt
> you can actually measure the effects on sane hardware.

If we limit the discussion to sane hardware, I should mention that on
current Intel CPUs TSC is guaranteed to be monotonic for anything up to
8 sockets. Even on slightly older HS TSC skew is very small and should
not be an issue for this use case.

So:
Modern sane HW does not have this issue.
The people that do busy polling typically pin tasks to cores anyway.
You need cap_net_admin to use this setting.
There is no real damage if the issue happens.
This is fast-low-latency-path so we are very sensitive to adding even
a small cost.
Linus really didn't like adding to the cost of poll/select when busy
polling is not being used.

Having said that, since we need to fix the timeout issue you pointed
out, we will test the use of local_clock() and see if it matters or
not.

Again, I have no objection to changing the use of
preempt_enable_no_resched() to a plain preempt_enable().

Cheers,
Eliezer
