Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3GKLhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:37:16 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:48232 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3GKLhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:37:13 -0400
Message-ID: <51DE9859.8090405@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 17:04:49 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <51DC414F.5050900@linux.intel.com>
In-Reply-To: <51DC414F.5050900@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071111-9574-0000-0000-000008ABA6CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

I have a few quick comments.

On 07/09/2013 10:28 PM, Arjan van de Ven wrote:
> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
>> Hi,
>>
>> This patch set is an initial prototype aiming at the overall power-aware
>> scheduler design proposal that I previously described
>> <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
>>
>> The patch set introduces a cpu capacity managing 'power scheduler'
>> which lives
>> by the side of the existing (process) scheduler. Its role is to
>> monitor the
>> system load and decide which cpus that should be available to the process
>> scheduler. Long term the power scheduler is intended to replace the
>> currently
>> distributed uncoordinated power management policies and will interface a
>> unified platform specific power driver obtain power topology
>> information and
>> handle idle and P-states. The power driver interface should be made
>> flexible
>> enough to support multiple platforms including Intel and ARM.
>>
> I quickly browsed through it but have a hard time seeing what the
> real interface is between the scheduler and the hardware driver.
> What information does the scheduler give the hardware driver exactly?
> e.g. what does it mean?
> 
> If the interface is "go faster please" or "we need you to be at fastest
> now",
> that doesn't sound too bad.
> But if the interface is "you should be at THIS number" that is pretty
> bad and
> not going to work for us.
> 
> also, it almost looks like there is a fundamental assumption in the code
> that you can get the current effective P state to make scheduler
> decisions on;
> on Intel at least that is basically impossible... and getting more so
> with every generation
> (likewise for AMD afaics)

I am concerned too about scheduler making its load balancing decisions
based on the cpu frequency for the reason that it could create an
imbalance in the load across cpus.

Scheduler could keep loading a cpu, because its cpu frequency goes on
increasing, and it could keep un-loading a cpu because its cpu frequency
goes on decreasing. This increase and decrease as an effect of the load
itself. This is of course assuming that the driver would make its
decisions proportional to the cpu load. There could be many more
complications, if the driver makes its decisions on factors unknown to
the scheduler.

Therefore my suggestion is that we should simply have the scheduler
asking for increase/decrease in the frequency and letting it at that.

Secondly, I think we should spend more time on when to make a call to
the frequency driver in your patchset regarding the change in the
frequency of the CPU, the scheduler wishes to request. The reason being,
the whole effort of integrating the knowledge of cpu frequency
statistics into the scheduler is being done because the scheduler can
call the frequency driver at times *complimenting* load balancing,
unlike now.

Also adding Rafael to the cc list.

Regards
Preeti U Murthy

