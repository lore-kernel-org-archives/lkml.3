Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3K2NwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:52:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:45620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3K2NwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:52:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,798,1378882800"; 
   d="scan'208";a="444145771"
Message-ID: <52989C0A.7000309@linux.intel.com>
Date: Fri, 29 Nov 2013 15:52:10 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, David Miller <davem@davemloft.net>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 7/8] sched, net: Fixup busy_loop_us_clock()
References: <20131126155743.116756708@infradead.org> <20131126160815.293633156@infradead.org> <529773FC.6020707@linux.intel.com> <20131128174001.GH10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131128174001.GH10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/2013 19:40, Peter Zijlstra wrote:
> On Thu, Nov 28, 2013 at 06:49:00PM +0200, Eliezer Tamir wrote:
>> I have tested this patch and I see a performance regression of about
>> 1.5%.
> 
> Cute, can you qualify your metric? Since this is a poll loop the only
> metric that would be interesting is the response latency. Is that what's
> increased by 1.5%? Also, what's the standard deviation of your result?

Sorry, I should have been more specific.

I use netperf tcp_rr, with all settings except the time (30s) on their
defaults. The setup is exactly the same as in the commit message of the
original patch set.

I get 91.5 KRR/s vs. 90.0 KRR/s.

Unfortunately you need two machines, both of which need NICs that have
driver support for busy poll. currently AFAIK bnx2x, ixgbe, mlx4 and
myri10ge are the only ones, but it's not that hard to add to most NAPI
based drivers.

I will try to test your latest patches and hopefully also get some perf
numbers on Sunday.

Thanks,
Eliezer
