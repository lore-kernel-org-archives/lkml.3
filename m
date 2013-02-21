Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3BUBmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:42:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:14091 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab3BUBmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:42:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,705,1355126400"; 
   d="scan'208";a="293892480"
Message-ID: <51257BAF.9050204@intel.com>
Date: Thu, 21 Feb 2013 09:43:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 04/15] sched: add sched balance policies in kernel
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-5-git-send-email-alex.shi@intel.com> <20130220093751.GA2444@gmail.com> <5124D253.6090606@intel.com> <20130220154101.GA13388@gmail.com>
In-Reply-To: <20130220154101.GA13388@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 11:41 PM, Ingo Molnar wrote:
> 
> * Alex Shi <alex.shi@intel.com> wrote:
> 
>> Now there is just 2 types policy: performance and 
>> powersaving(with 2 degrees, powersaving and balance).
> 
> I don't think we really want to have 'degrees' to the policies 
> at this point - we want each policy to be extremely good at what 
> it aims to do:
> 
>  - 'performance' should finish jobs in in the least amount of 
>     time possible. No ifs and whens.
> 
>  - 'power saving' should finish jobs with the least amount of 
>     watts consumed. No ifs and whens.
> 
>> powersaving policy will try to assign one task to each LCPU, 
>> whichever the LCPU is SMT thread or a core. The balance policy 
>> is also a kind of powersaving policy, just a bit less 
>> aggressive. It will try to assign tasks according group 
>> capacity, one task to one capacity.
> 
> The thing is, 'a bit less aggressive' is an awfully vague 
> concept to maintain on a long term basis - while the two 
> definitions above are reasonably deterministic which can be 
> measured and improved upon.
> 
> Those two policies and definitions are also much easier to 
> communicate to user-space and to users - it's much easier to 
> explain what each policy is supposed to do.
> 
> I'd be totally glad if we got so far that those two policies 
> work really well. Any further nuance visible at the ABI level is 
> I think many years down the road - if at all. Simple things 
> first - those are complex enough already.


Thanks for comments!
I will remove the 'balance' policy.

> 
> Thanks,
> 
> 	Ingo
> 


-- 
Thanks Alex
