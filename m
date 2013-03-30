Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3C3Pd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 11:33:29 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54741 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3C3Pd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 11:33:28 -0400
Message-ID: <5157056C.5000705@linux.vnet.ibm.com>
Date: Sat, 30 Mar 2013 21:01:56 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com> <514BB452.2070906@intel.com> <514BE8AC.6000607@linux.vnet.ibm.com> <514FD801.8070403@intel.com> <51558C31.1060605@linux.vnet.ibm.com> <515599AD.5090901@intel.com> <5156CB90.5060209@linux.vnet.ibm.com> <5156F103.6000508@intel.com>
In-Reply-To: <5156F103.6000508@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13033015-9574-0000-0000-00000743B412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/30/2013 07:34 PM, Alex Shi wrote:
> On 03/30/2013 07:25 PM, Preeti U Murthy wrote:
>>>> I still give the rq->util weight even the nr_running is 0, because some
>>>> transitory tasks may actived on the cpu, but just missed on balancing point.
>>>>
>>>> I just wondering that forgetting rq->util when nr_running = 0 is the
>>>> real root cause if your finding is just on VM and without fixed VCPU to
>>>> CPU pin.
>> I find the same situation on a physical machine too. On a 2 socket, 4
>> core machine as well. In fact, using trace_printks in the load balancing
>> part, I could find that the reason that the load was not getting
>> consolidated onto a socket was because the rq->util of a run-queue with
>> no processes on it, had not decayed to 0, which is why it would consider
>> the socket as overloaded and would  rule out power aware balancing.All
>> this was on a physical machine.
> 
> Consider of this situation, we may stop account the rq->util when
> nr_running is zero. Tasks will be a bit more compact. but anyway, that's
> powersaving policy.
> 
True, the tasks will be packed a bit more compactly, but we can expect
the behaviour of your patchset *defaulting to performance policy when
overloaded*, to come to the rescue of such a situation.

Regards
Preeti U Murthy

