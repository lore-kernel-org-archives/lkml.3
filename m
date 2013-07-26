Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3GZDG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:06:27 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37709 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3GZDGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:06:25 -0400
Message-ID: <51F1E70C.1020408@linux.vnet.ibm.com>
Date: Fri, 26 Jul 2013 08:33:40 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: rjw@sisk.pl, shangw@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, geoff@infradead.org, rostedt@goodmis.org,
        deepthi@linux.vnet.ibm.com, paul.gortmaker@windriver.com,
        paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, john.stultz@linaro.org, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, chenhui.zhao@freescale.com
Subject: Re: [RFC PATCH 4/5] cpuidle/ppc: CPU goes tickless if there are no
 arch-specific constraints
References: <20130725090016.12500.28888.stgit@preeti.in.ibm.com> <20130725090302.12500.42998.stgit@preeti.in.ibm.com> <20130725133044.GA7400@somewhere>
In-Reply-To: <20130725133044.GA7400@somewhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072602-9574-0000-0000-000008E3FDC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On 07/25/2013 07:00 PM, Frederic Weisbecker wrote:
> On Thu, Jul 25, 2013 at 02:33:02PM +0530, Preeti U Murthy wrote:
>> In the current design of timer offload framework, the broadcast cpu should
>> *not* go into tickless idle so as to avoid missed wakeups on CPUs in deep idle states.
>>
>> Since we prevent the CPUs entering deep idle states from programming the lapic of the
>> broadcast cpu for their respective next local events for reasons mentioned in
>> PATCH[3/5], the broadcast CPU checks if there are any CPUs to be woken up during
>> each of its timer interrupt programmed to its local events.
>>
>> With tickless idle, the broadcast CPU might not get a timer interrupt till after
>> many ticks which can result in missed wakeups on CPUs in deep idle states. By
>> disabling tickless idle, worst case, the tick_sched hrtimer will trigger a
>> timer interrupt every period to check for broadcast.
>>
>> However the current setup of tickless idle does not let us make the choice
>> of tickless on individual cpus. NOHZ_MODE_INACTIVE which disables tickless idle,
>> is a system wide setting. Hence resort to an arch specific call to check if a cpu
>> can go into tickless idle.
> 
> Hi Preeti,
> 
> I'm not exactly sure why you can't enter the broadcast CPU in dynticks idle mode.
> I read in the previous patch that's because in dynticks idle mode the broadcast
> CPU deactivates its lapic so it doesn't receive the IPI. But may be I misunderstood.
> Anyway that's not good for powersaving.
> 
> Also when an arch wants to prevent a CPU from entering dynticks idle mode, it typically
> use arch_needs_cpu(). May be that could fit for you as well?

Yes this will suit our requirement perfectly. I will note down this
change for the next version of this patchset. Thank you very much for
pointing this out :)

Regards
Preeti U Murthy

