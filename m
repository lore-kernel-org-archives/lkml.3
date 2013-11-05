Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3KETNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:13:09 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:43043 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3KETNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:13:07 -0500
Message-ID: <52794340.7030009@linaro.org>
Date: Tue, 05 Nov 2013 14:13:04 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/13] uprobes: move function declarations out of arch
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-2-git-send-email-dave.long@linaro.org> <20131105160150.GA1539@redhat.com> <20131105181614.GA7614@redhat.com>
In-Reply-To: <20131105181614.GA7614@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 13:16, Oleg Nesterov wrote:
> On 11/05, Oleg Nesterov wrote:
>>
>> On 10/15, David Long wrote:
>>>
>>> Move the function declarations from the arch header to the common
>>> header, since only the function bodies are architecture-specific.
>>> These changes are from Vincent Rabin's uprobes patch.
>>
>> Hmm. I didn't look at this patch because I thought it is obviously
>> fine, but...
>>
>>>   arch/x86/include/asm/uprobes.h | 7 -------
>>>   include/linux/uprobes.h        | 8 ++++++++
>>>   2 files changed, 8 insertions(+), 7 deletions(-)
>>
>> it should also update arch/powerpc/include/asm/uprobes.h ?
>>
>> And 12/13 should not touch arch/powerpc/ or include/linux/uprobes.h.
>
> And I think we can merge this change separately to reduce the
> number of non-arm changes in the next version.
>
> Please see the patch I am going to add to my tree below.
>
> Oleg.
> ---
>
> Subject: [PATCH] uprobes: move function declarations out of arch
> From: David A. Long <dave.long@linaro.org>
> Date: Tue, 15 Oct 2013 17:04:16 -0400
>
> Move the function declarations from the arch headers to the common
> header, since only the function bodies are architecture-specific.
> These changes are from Vincent Rabin's uprobes patch.
>
> [ oleg: update arch/powerpc/include/asm/uprobes.h ]
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> Signed-off-by: David A. Long <dave.long@linaro.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>   arch/powerpc/include/asm/uprobes.h |    7 -------
>   arch/x86/include/asm/uprobes.h     |    7 -------
>   include/linux/uprobes.h            |    8 ++++++++
>   3 files changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
> index 541fd6f..75c6ecd 100644
> --- a/arch/powerpc/include/asm/uprobes.h
> +++ b/arch/powerpc/include/asm/uprobes.h
> @@ -46,11 +46,4 @@ struct arch_uprobe_task {
>   	unsigned long	saved_trap_nr;
>   };
>
> -extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> -extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> -extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> -extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
>   #endif	/* _ASM_UPROBES_H */
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 2a24180..3087ea9 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -52,11 +52,4 @@ struct arch_uprobe_task {
>   	unsigned int			saved_tf;
>   };
>
> -extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> -extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> -extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> -extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
>   #endif	/* _ASM_UPROBES_H */
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 06f28be..9fd60c5 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -30,6 +30,7 @@
>   struct vm_area_struct;
>   struct mm_struct;
>   struct inode;
> +struct notifier_block;
>
>   #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
>   # include <asm/uprobes.h>
> @@ -125,6 +126,13 @@ extern void uprobe_notify_resume(struct pt_regs *regs);
>   extern bool uprobe_deny_signal(void);
>   extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
>   extern void uprobe_clear_state(struct mm_struct *mm);
> +extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> +extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> +extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> +extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
>   #else /* !CONFIG_UPROBES */
>   struct uprobes_state {
>   };
>

Looks good to me.  ARM builds/runs fine with your patch.  I will remove 
my (updated) version from my patch set.

-dl

