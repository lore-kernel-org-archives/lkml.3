Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3C2NkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:40:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:18514 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab3C2NkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:40:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,373,1363158000"; 
   d="scan'208";a="309131576"
Message-ID: <515599AD.5090901@intel.com>
Date: Fri, 29 Mar 2013 21:39:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com> <514BB452.2070906@intel.com> <514BE8AC.6000607@linux.vnet.ibm.com> <514FD801.8070403@intel.com> <51558C31.1060605@linux.vnet.ibm.com>
In-Reply-To: <51558C31.1060605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 08:42 PM, Preeti U Murthy wrote:
>> > did you try the simplest benchmark: while true; do :; done
> Yeah I tried out this while true; do :; done benchmark on a vm which ran

Thanks a lot for trying!

What's do you mean 'vm'? Virtual machine?

> on 2 socket, 2 cores each socket and 2 threads each core emulation.
> I ran two instances of this loop with balance policy on, and it was
> found that there was one instance running on each socket, rather than
> both instances getting consolidated on one socket.
> 
> But when I apply the change where we do not consider rq->util if it has
> no nr_running on the rq,the two instances of the above benchmark get
> consolidated onto one socket.
> 
> 

I don't know much of virtual machine, guess the unstable VCPU to CPU pin
cause rq->util keep large? Did you try to pin VCPU to physical CPU?

I still give the rq->util weight even the nr_running is 0, because some
transitory tasks may actived on the cpu, but just missed on balancing point.

I just wondering that forgetting rq->util when nr_running = 0 is the
real root cause if your finding is just on VM and without fixed VCPU to
CPU pin.


-- 
Thanks
    Alex
