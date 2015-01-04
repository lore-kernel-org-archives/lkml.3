Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbADNvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:51:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADNvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:51:06 -0500
Message-ID: <54A94513.20808@redhat.com>
Date: Sun, 04 Jan 2015 19:20:11 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com
Subject: Re: [RFC 3/8] Kernel/uprobe: Define arch_uprobe_exception_notify
 as __weak
References: <cover.1420038188.git.panand@redhat.com> <c40bb09f1edad6899c3855eb56bf4a4f541c49f7.1420038188.git.panand@redhat.com> <20150102174314.GA6761@redhat.com>
In-Reply-To: <20150102174314.GA6761@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 02 January 2015 11:13 PM, Oleg Nesterov wrote:
> On 12/31, Pratyush Anand wrote:
>>
>> Both ARM and ARM64 handle uprobe exceptions through their own hooks.So
>> nothing to be done in arch_uprobe_exception_notify except to return
>> NOTIFY_DONE. Implement this as weak default function and remove
>> definition from arm arch code.
>>
>> Signed-off-by: Pratyush Anand <panand@redhat.com>
>> ---
>>   arch/arm/kernel/uprobes.c |  6 ------
>>   kernel/events/uprobes.c   | 18 ++++++++++++++++++
>>   2 files changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
>> index 56adf9c1fde0..0f3663ca82fc 100644
>> --- a/arch/arm/kernel/uprobes.c
>> +++ b/arch/arm/kernel/uprobes.c
>> @@ -178,12 +178,6 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>>   	instruction_pointer_set(regs, utask->vaddr);
>>   }
>>
>> -int arch_uprobe_exception_notify(struct notifier_block *self,
>> -				 unsigned long val, void *data)
>> -{
>> -	return NOTIFY_DONE;
>> -}
>
> I agree, this is ugly. But I disagree with this change.
>
> I think we should simply kill uprobe_exception_nb and unexport
> arch_uprobe_exception_notify on x86/powerpc, and in fact I was going to do
> this a long ago.
>
> I'll send the patch later. Until then please add the dummy arch_uprobe_exception_notify()
> like arch/arm does, to make the generic code happy.

OK.

~Pratyush
>
> Oleg.
>
