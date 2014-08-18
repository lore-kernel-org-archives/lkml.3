Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHRR1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:27:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33763 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbaHRR1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:27:19 -0400
Message-ID: <53F23761.6000904@linux.vnet.ibm.com>
Date: Mon, 18 Aug 2014 22:56:57 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, len.brown@intel.com,
        yuyang.du@intel.com, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, corbet@lwn.net, catalin.marinas@arm.com,
        markgross@thegnar.org, sundar.iyer@intel.com,
        linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        Lorenzo.Pieralisi@arm.com, mike.turquette@linaro.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Subject: Re: [RFC PATCH V2 01/19] sched/power: Remove cpu idle state selection
 and cpu frequency tuning
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com> <20140811113145.31956.32224.stgit@preeti.in.ibm.com> <alpine.LFD.2.11.1408181125100.29347@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1408181125100.29347@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081817-0320-0000-0000-000000413C0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 09:09 PM, Nicolas Pitre wrote:
> On Mon, 11 Aug 2014, Preeti U Murthy wrote:
> 
>> As a first step towards improving the power awareness of the scheduler,
>> this patch enables a "dumb" state where all power management is turned off.
>> Whatever additionally we put into the kernel for cpu power management must
>> do better than this in terms of performance as well as powersavings.
>> This will enable us to benchmark and optimize the power aware scheduler
>> from scratch.If we are to benchmark it against the performance of the
>> existing design, we will get sufficiently distracted by the performance
>> numbers and get steered away from a sane design.
> 
> I understand your goal here, but people *will* compare performance 
> between the old and the new design anyway.  So I think it would be a 
> better approach to simply let the existing code be and create a new 
> scheduler-based governor that can be swapped with the existing ones at 
> run time.  Eventually we'll want average users to test and compare this, 
> and asking them to recompile a second kernel and reboot between them 
> might get unwieldy to many people.
> 
> And by allowing both to coexist at run time, we're making sure both the 
> old and the new code are built helping not breaking the old code.  And 
> that will also cut down on the number of #ifdefs in many places.
> 
> In other words, CONFIG_SCHED_POWER is needed to select the scheduler 
> based governor but it shouldn't force the existing code disabled.

I don't think I understand you here. So are you proposing a runtime
switch like a sysfs interface instead of a config switch? Wouldn't that
be unwise given that its a complete turnaround of the behavior kernel
after the switch? I agree that the first patch is a dummy patch, its
meant to ensure that we have *atleast* the power efficiency that this
patch brings in. Of course after that point this patch is a no-op. In
fact the subsequent patches will mitigate the effect of this.

Regards
Preeti U Murthy
> 
> 
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

