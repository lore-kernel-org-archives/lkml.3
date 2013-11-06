Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3KFLFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:05:48 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:35545 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3KFLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:05:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131025152428.GD10673@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-7-git-send-email-sandeepa.prabhu@linaro.org>
	<20131025152428.GD10673@mudshark.cambridge.arm.com>
Date: Wed, 6 Nov 2013 16:35:44 +0530
Message-ID: <CA+b37P16kSi9Zja=oLRSCn74-ystxpcfKsy5A8r3eDEMfzZycQ@mail.gmail.com>
Subject: Re: [PATCH RFC 6/6] kprobes: Add cases for arm and arm64 in sample module
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2013 20:54, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Oct 17, 2013 at 12:17:51PM +0100, Sandeepa Prabhu wrote:
>> Add info prints in sample kprobe handlers for ARM and ARM64
>> architecture.
>>
>> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>> ---
>>  samples/kprobes/kprobe_example.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
>> index 366db1a..0521246 100644
>> --- a/samples/kprobes/kprobe_example.c
>> +++ b/samples/kprobes/kprobe_example.c
>> @@ -42,6 +42,14 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
>>                       " ex1 = 0x%lx\n",
>>               p->addr, regs->pc, regs->ex1);
>>  #endif
>> +#ifdef CONFIG_ARM
>> +     printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
>> +                     p->addr, regs->ARM_pc);
>> +#endif
>> +#ifdef CONFIG_ARM64
>> +     printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
>> +             p->addr, (long)regs->pc);
>> +#endif
>
> Huh? Why can't you combine these two together and either unconditionall cast
> to long, or use void * and %p?
pt_regs member names are different: regs->pc (arm64) vs. regs->ARM_pc
(arm32). It is still possible to use instruction_pointer(regs) for
both architectures, but this needs including asm/ptrace.h which I am
not sure good thing to do in samples/

Thanks,
Sandeepa
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
