Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaEEIGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:06:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:11018 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaEEIGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:06:16 -0400
Message-ID: <53674615.5000509@huawei.com>
Date: Mon, 5 May 2014 16:04:37 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: William Cohen <wcohen@nc.rr.com>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH] arm64: add OProfile support
References: <535B707F.7020802@huawei.com>	<58ED971B-CC04-4BE1-916C-386D219874A8@arm.com>	<535B88C9.6000908@huawei.com> <535DBDA4.6070607@huawei.com> <535EBC96.3090008@nc.rr.com>
In-Reply-To: <535EBC96.3090008@nc.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/29 4:39, William Cohen wrote:
> On 04/27/2014 10:32 PM, Ding Tianhong wrote:
>> On 2014/4/26 18:22, Ding Tianhong wrote:
>>> On 2014/4/26 17:23, Catalin Marinas wrote:
>>>> On 26 Apr 2014, at 09:38, Ding Tianhong <dingtianhong@huawei.com> wrote:
>>>>> Add OProfile support for arm64,  using the perf backend, and failing back
>>>>> to generic timer based sampling if PMU interrupt is not supported.
>>>>>
>>>>> I have test this patch on Cortex-A53 and Cortex-A57 motherboard, the OProfile
>>>>> could work well by PMU irq or arch timer irq.
>>>>
>>>> This came up before a few times and we also had an implementation but
>>>> decided not to merge it. We should rather get the user space oprofile to
>>>> use the perf kernel API.
>>>>
>>>> That’s an old thread, it may have even made it into mainline oprofile
>>>> but I haven’t followed the development:
>>>>
>>>> http://marc.info/?l=oprofile-list&m=133002515616302&w=2
>>>>
>>>> Catalin
>>>>
>>
>> Hi Cadtalin:
>>
>> Sorry I could not find the implementation that not to merge the orpfile support for aarch64 till now, and
>> I still have questions that the existing code only support oprofile by arch timer event, but not
>> PMU event, this patch only add HW PMU support for oprofile, it is more accurate and stable, can you
>> give me more advise and appreciate for your help.
>>
>> Regards
>> Ding
> 
> Hi Ding,
> 
> There is some basic support for arm64 in oprofile using the kernel's perf infrastructure for the Applied Micro X-Gene processor checked into the upstream oprofile git repository:
> 
> http://sourceforge.net/p/oprofile/oprofile/ci/34d0065a1a790fc2be05a5ef1d8b0bbf28b814fe/
> 
> It should be straight forward to adapt and extend this to work for A53 and A57 processors in libop/op_cpu_type.c.  At the time I didn't have access to the cortex a57/a53 documentation so this was implemented for the the base ARMv8 PMUv3 events. The processor identification for Cortex a53 and a57 will also need to be added. to /libop/op_cpu_type.c.  I don't currently have access to cortex a53 or a57 processors, so I don't know what the magic vendorid and cpuid values are. What is the output of "cat /proc/cpuinfo" for each of the aarch64 processors you are running oprofile on?
> 
> -Will
> 

Hi Will:

Sorry for feedback so late, too busy these days. :)

Thanks for your message, you can add the the A53 and A57 to support arm-v8 for oprofile.

	A53	A57
Vendid	0x41	0x41
cpuid	0xD03	0xD07

-Ding

>>
>>> Ok, I will check it and then decide the next step, thanks for your feedback.
>>>
>>> Regards
>>> Ding
>>>
>>
>>
>>
>> ------------------------------------------------------------------------------
>> "Accelerate Dev Cycles with Automated Cross-Browser Testing - For FREE
>> Instantly run your Selenium tests across 300+ browser/OS combos.  Get 
>> unparalleled scalability from the best Selenium testing platform available.
>> Simple to use. Nothing to install. Get started now for free."
>> http://p.sf.net/sfu/SauceLabs
>> _______________________________________________
>> oprofile-list mailing list
>> oprofile-list@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/oprofile-list
>>
> 
> 
> .
> 


