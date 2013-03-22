Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3CVIty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:49:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:48473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3CVItv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,891,1355126400"; 
   d="scan'208";a="274498966"
Message-ID: <514C1B23.20701@intel.com>
Date: Fri, 22 Mar 2013 16:49:39 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>   <1361164062-20111-7-git-send-email-alex.shi@intel.com>  <1361352643.10155.4.camel@laptop> <5124DED5.5050207@intel.com> <1361373740.10155.42.camel@laptop>
In-Reply-To: <1361373740.10155.42.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 11:22 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 22:33 +0800, Alex Shi wrote:
>>> You don't actually compute the rq utilization, you only compute the
>>> utilization as per the fair class, so if there's significant RT
>> activity
>>> it'll think the cpu is under-utilized, whihc I think will result in
>> the
>>> wrong thing.
>>
>> yes. A bit complicit to resolve this. Any suggestions on this, guys?
> 
> Shouldn't be too hard seeing as we already track cpu utilization for !
> fair usage; see rq::rt_avg and scale_rt_power.
> 

Hi Peter,

rt_avg will be accumulated the irq time and steal time in
update_rq_clock_task(), if CONFIG_IRQ_TIME_ACCOUNTING or
CONFIG_IRQ_TIME_ACCOUNTING defined. That cause irq/steal time was double
added into rq utilisation, since normal rq->util already include the irq
time. So we do wrongly judgement to think it is a overload cpu. but it
is not.

To resolve this issue, if is it possible to introduce another member in
rq to describe rt_avg non irq/steal beside the rt_avg? If so, what the
name do you like to use?

-- 
Thanks Alex
