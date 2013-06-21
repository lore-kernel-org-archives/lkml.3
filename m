Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423342Ab3FUPi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:38:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:5997 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161419Ab3FUPi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:38:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,913,1363158000"; 
   d="scan'208";a="353590885"
Message-ID: <51C47377.2000208@linux.intel.com>
Date: Fri, 21 Jun 2013 08:38:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: David Lang <david@lang.hm>, Ingo Molnar <mingo@kernel.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin> <51C07ABC.2080704@linux.intel.com> <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz> <51C1D0BB.3040705@linux.intel.com> <20130619170042.GH5460@e103034-lin> <51C1E58D.9000408@linux.intel.com> <20130621085002.GJ5460@e103034-lin>
In-Reply-To: <20130621085002.GJ5460@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2013 1:50 AM, Morten Rasmussen wrote:
>> ypically.
> A hint when a task is moved to a new cpu is too late if the migration
> shouldn't have happened at all. If the scheduler knows that the cpu is
> able to switch to a higher p-state it can decide to wait for the p-state
> change instead of migrating the task and waking up another cpu.
>

oops sorry I misread your mail (lack of early coffee I suppose)

I can see your point of having a thing for "did we ask for all the performance
we could ask for" prior to doing a load balance (although, for power efficiency,
if you have two tasks that could run in parallel, it's usually better to
run them in parallel... so likely we should balance anyway)
