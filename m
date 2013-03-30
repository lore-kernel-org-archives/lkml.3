Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3C3OFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:05:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:3056 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab3C3OFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:05:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220560347"
Message-ID: <5156F103.6000508@intel.com>
Date: Sat, 30 Mar 2013 22:04:51 +0800
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com> <514BB452.2070906@intel.com> <514BE8AC.6000607@linux.vnet.ibm.com> <514FD801.8070403@intel.com> <51558C31.1060605@linux.vnet.ibm.com> <515599AD.5090901@intel.com> <5156CB90.5060209@linux.vnet.ibm.com>
In-Reply-To: <5156CB90.5060209@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 07:25 PM, Preeti U Murthy wrote:
>> > I still give the rq->util weight even the nr_running is 0, because some
>> > transitory tasks may actived on the cpu, but just missed on balancing point.
>> > 
>> > I just wondering that forgetting rq->util when nr_running = 0 is the
>> > real root cause if your finding is just on VM and without fixed VCPU to
>> > CPU pin.
> I find the same situation on a physical machine too. On a 2 socket, 4
> core machine as well. In fact, using trace_printks in the load balancing
> part, I could find that the reason that the load was not getting
> consolidated onto a socket was because the rq->util of a run-queue with
> no processes on it, had not decayed to 0, which is why it would consider
> the socket as overloaded and would  rule out power aware balancing.All
> this was on a physical machine.

Consider of this situation, we may stop account the rq->util when
nr_running is zero. Tasks will be a bit more compact. but anyway, that's
powersaving policy.

-- 
Thanks
    Alex
