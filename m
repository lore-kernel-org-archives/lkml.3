Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaBDDQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 22:16:18 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48544 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBDDQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 22:16:15 -0500
Message-ID: <52F05A90.4040703@linux.vnet.ibm.com>
Date: Tue, 04 Feb 2014 08:42:16 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Alex Shi <alex.shi@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: a LLC sched domain bug for panda board?
References: <52EFC11A.8010709@linaro.org> <CAKfTPtDD9g6PPx=cDkbH2VDO0k1HDAjcxwxeW2YLXwL5T4d6NA@mail.gmail.com> <CAKfTPtDJ267W9UMRj-pgyha0yf1L-VWBMKgi+QdVEA4zFJYXLw@mail.gmail.com> <52EFC8A4.2060906@linaro.org> <CAKfTPtBV0cSALdVcMsnGHwQPoNCEp5CXQGg36ZAgK7kWJ6gaMQ@mail.gmail.com>
In-Reply-To: <CAKfTPtBV0cSALdVcMsnGHwQPoNCEp5CXQGg36ZAgK7kWJ6gaMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020403-6688-0000-0000-000006186E52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex, Vincent,

On 02/04/2014 02:10 AM, Vincent Guittot wrote:
> Yes,  it's probably worth enabling by default for all ARM arch.
> 
> Vincent
> 
> On 02/04/2014 12:28 AM, Vincent Guittot wrote:
>> On 3 February 2014 17:27, Vincent Guittot <vincent.guittot@linaro.org>
> wrote:
>>> Have you checked that CONFIG_SCHED_LC is set ?
>>
>> sorry it's CONFIG_SCHED_MC
> 
> Thanks for reminder! no it wasn't set. Does it means
> arch/arm/configs/omap2plus_defconfig need add this config?

Hmm..ok let me think this aloud. So looks like the SMT,MC and the NUMA
sched domains are optional depending on the architecture. They are
config dependent. These domains could potentially exist on the processor
layout, but if the respective CONFIG options are not set, the scheduler
could very well ignore these levels.

What this means is that although the architecture could populate the
cpu_sibling_mask and cpu_coregroup_mask, the scheduler is not mandated
to schedule across the SMT and MC levels of the topology.
Its just the CPU sched domain which is guaranteed to be present no
matter what.

This is indeed interesting to note :) Thanks Alex for bringing up this
point :)

On PowerPC, the SCHED_MC option can never be set. Its not even optional.
On x86, it is on by default and on arm looks like its off by default.

Thanks,

Regards
Preeti U Murthy



> 
>>
>>>
>>>
>>> On 3 February 2014 17:17, Alex Shi <alex.shi@linaro.org> wrote:
>>>> I just run the 3.14-rc1 kernel on panda board. The only domain for it is
>>>> 'CPU' domain, but this domain has no SD_SHARE_PKG_RESOURCES setting, it
>>>> has no sd_llc.
>>>>
>>>> Guess the right domain for this board should be MC. So is it a bug?
>>>>
>>>> ..
>>>> /proc/sys/kernel/sched_domain/cpu0/domain0/name:CPU
>>>> ..
>>>> /proc/sys/kernel/sched_domain/cpu1/domain0/name:CPU
>>>>
>>>> --
>>>> Thanks
>>>>     Alex
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> Thanks
>     Alex
> 

