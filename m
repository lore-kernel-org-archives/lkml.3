Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3LPRtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:49:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:65059 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab3LPRtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:49:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,496,1384329600"; 
   d="scan'208";a="450861270"
Message-ID: <52AF3CF0.3090502@linux.intel.com>
Date: Mon, 16 Dec 2013 19:48:32 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] cleanups and optimizations
References: <20131212140835.729222186@infradead.org> <52AAE61D.4060406@linux.intel.com> <20131213135626.GL21999@twins.programming.kicks-ass.net>
In-Reply-To: <20131213135626.GL21999@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/2013 15:56, Peter Zijlstra wrote:
> On Fri, Dec 13, 2013 at 12:49:01PM +0200, Eliezer Tamir wrote:
>> On 12/12/2013 16:08, Peter Zijlstra wrote:
>>> This series contains the preempt_enable_no_resched() cleanups that include
>>> spin_lock_bh() optimizations and local_clock() optimizations.
>>
>> I'm trying to test this on tip/master.
>> Patch 3 fails to apply on kenrel/softirq.c
> 
> https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/log/?h=preempt_clock
> 
> Applied just fine here.. stuffed it in a git tree.

Thanks,
That worked.

My test is, netperf TCP_RR 1 byte, with busy polling enabled, 30s run.

I see 92.0K RR with your patches, 91.8K RR with out them.
This is barely above the noise level, but I'm pretty sure it's real.
In any case I don't see any regression.

Thanks,
Eliezer
