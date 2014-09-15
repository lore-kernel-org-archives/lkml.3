Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaIOB0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 21:26:55 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44964 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaIOB0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 21:26:54 -0400
Message-ID: <5416403D.8010504@huawei.com>
Date: Mon, 15 Sep 2014 09:26:21 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
        "Pei Feiyue" <peifeiyue@huawei.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] kprobes/x86: opt: free optinsn cache when range check
 fails
References: <1406550019-70935-1-git-send-email-wangnan0@huawei.com> <53D6FC38.8070801@hitachi.com> <53FDCBF1.2020606@huawei.com> <53FDDF08.5090604@hitachi.com>
In-Reply-To: <53FDDF08.5090604@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Masami,

I still unable to find this bugfix in mainline code. Is there any problem?

Thank you!

On 2014/8/27 21:37, Masami Hiramatsu wrote:
> 
> Hi Ingo,
> 
> Could you pull this for a bugfix of a memory leak?
> 
> (2014/08/27 21:15), Wang Nan wrote:
>> On 2014/7/29 9:43, Masami Hiramatsu wrote:
>>> (2014/07/28 21:20), Wang Nan wrote:
>>>> This patch frees optinsn slot when range check error to prevent memory
>>>> leaks. Before this patch, cache entry in kprobe_insn_cache won't be
>>>> freed if kprobe optimizing fails due to range check failure.
>>>>
>>>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>>>
>>> Oops, thank you for finding it!
>>>
>>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>
>>
>> Hi Masami Hiramatsu,
>>
>> I don't find this patch in newest upstream. Is there any problem?
>>
>>> BTW, would you really have hit this error?
>>> I'd like to know the case if this really happens.
>>>
>>>> ---
>>>>  arch/x86/kernel/kprobes/opt.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
>>>> index f304773..f1314d0 100644
>>>> --- a/arch/x86/kernel/kprobes/opt.c
>>>> +++ b/arch/x86/kernel/kprobes/opt.c
>>>> @@ -338,8 +338,10 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
>>>>  	 * a relative jump.
>>>>  	 */
>>>>  	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
>>>> -	if (abs(rel) > 0x7fffffff)
>>>> +	if (abs(rel) > 0x7fffffff) {
>>>> +		__arch_remove_optimized_kprobe(op, 0);
>>>>  		return -ERANGE;
>>>> +	}
>>>>  
>>>>  	buf = (u8 *)op->optinsn.insn;
>>>>  
>>>>
>>>
>>>
>>
>>
>>
> 
> 


