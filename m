Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3JIIFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:05:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:64944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3JIIFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1062,1371106800"; 
   d="s'?scan'208";a="408113335"
Date: Wed, 9 Oct 2013 16:04:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009080459.GA2298@localhost>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20131008143400.GA14721@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Oleg,

Thanks for looking into this. Attached is the task_work.s for you.

> Fengguang, I do not think this will help, but just in case. Could you
> show the result of
> 
>         $ kernel/task_work.s
> 
> ?

Sorry I lost some emails and found it back in LKML. Opened up too many
mutt clients..

Thanks,
Fengguang

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="task_work.s"

	.file	"task_work.c"
# GNU C (Debian 4.6.3-1) version 4.6.3 (x86_64-linux-gnu)
#	compiled by GNU C version 4.6.3, GMP version 5.0.4, MPFR version 3.1.0-p3, MPC version 0.9
# warning: GMP header version 5.0.4 differs from library version 5.0.2.
# warning: MPFR header version 3.1.0-p3 differs from library version 3.1.1-p2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -nostdinc -I /c/wfg/tip/arch/x86/include
# -I arch/x86/include/generated -I /c/wfg/tip/include -I include
# -I /c/wfg/tip/arch/x86/include/uapi -I arch/x86/include/generated/uapi
# -I /c/wfg/tip/include/uapi -I include/generated/uapi -I /c/wfg/tip/kernel
# -I kernel -imultilib 32 -imultiarch i386-linux-gnu -D __KERNEL__
# -D CONFIG_AS_CFI=1 -D CONFIG_AS_CFI_SIGNAL_FRAME=1
# -D CONFIG_AS_CFI_SECTIONS=1 -D CONFIG_AS_AVX=1 -D CONFIG_AS_AVX2=1
# -D CC_HAVE_ASM_GOTO -D KBUILD_STR(s)=#s
# -D KBUILD_BASENAME=KBUILD_STR(task_work)
# -D KBUILD_MODNAME=KBUILD_STR(task_work)
# -isystem /usr/lib/gcc/x86_64-linux-gnu/4.6/include
# -include /c/wfg/tip/include/linux/kconfig.h -MD kernel/.task_work.s.d
# /c/wfg/tip/kernel/task_work.c -m32 -msoft-float -mregparm=3
# -mpreferred-stack-boundary=2 -march=winchip2 -maccumulate-outgoing-args
# -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
# -auxbase-strip kernel/task_work.s -O2 -Wall -Wundef -Wstrict-prototypes
# -Wno-trigraphs -Werror=implicit-function-declaration -Wno-format-security
# -Wno-sign-compare -Wframe-larger-than=1024 -Wno-unused-but-set-variable
# -Wdeclaration-after-statement -Wno-pointer-sign -p -fno-strict-aliasing
# -fno-common -fno-delete-null-pointer-checks -freg-struct-return -fno-pic
# -ffreestanding -fno-asynchronous-unwind-tables -fno-stack-protector
# -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-strict-overflow
# -fconserve-stack -fverbose-asm
# options enabled:  -fauto-inc-dec -fbranch-count-reg -fcaller-saves
# -fcombine-stack-adjustments -fcompare-elim -fcprop-registers
# -fcrossjumping -fcse-follow-jumps -fdefer-pop -fdevirtualize
# -fdwarf2-cfi-asm -fearly-inlining -feliminate-unused-debug-types
# -fexpensive-optimizations -fforward-propagate -ffunction-cse -fgcse
# -fgcse-lm -fguess-branch-probability -fident -fif-conversion
# -fif-conversion2 -findirect-inlining -finline
# -finline-functions-called-once -finline-small-functions -fipa-cp
# -fipa-profile -fipa-pure-const -fipa-reference -fipa-sra
# -fira-share-save-slots -fira-share-spill-slots -fivopts
# -fkeep-static-consts -fleading-underscore -fmath-errno -fmerge-constants
# -fmerge-debug-strings -fmove-loop-invariants -foptimize-register-move
# -fpartial-inlining -fpeephole -fpeephole2 -fprefetch-loop-arrays
# -fprofile -freg-struct-return -fregmove -freorder-blocks
# -freorder-functions -frerun-cse-after-loop
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fshow-column -fsigned-zeros
# -fsplit-ivs-in-unroller -fsplit-wide-types -fstrict-volatile-bitfields
# -fthread-jumps -ftoplevel-reorder -ftrapping-math -ftree-bit-ccp
# -ftree-builtin-call-dce -ftree-ccp -ftree-ch -ftree-copy-prop
# -ftree-copyrename -ftree-cselim -ftree-dce -ftree-dominator-opts
# -ftree-dse -ftree-forwprop -ftree-fre -ftree-loop-if-convert
# -ftree-loop-im -ftree-loop-ivcanon -ftree-loop-optimize
# -ftree-parallelize-loops= -ftree-phiprop -ftree-pre -ftree-pta
# -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slp-vectorize
# -ftree-sra -ftree-switch-conversion -ftree-ter -ftree-vect-loop-version
# -ftree-vrp -funit-at-a-time -fvect-cost-model -fverbose-asm
# -fzero-initialized-in-bss -m32 -m96bit-long-double
# -maccumulate-outgoing-args -malign-stringops -mglibc -mieee-fp
# -mno-fancy-math-387 -mno-red-zone -mno-sse4 -mpush-args -msahf
# -mtls-direct-seg-refs

# Compiler executable checksum: aa5cb4c8e9c62c6cc9349213df314c34

	.text
	.p2align 4,,15
	.globl	task_work_add
	.type	task_work_add, @function
task_work_add:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	subl	$12, %esp	#,
	call	mcount
	movl	%eax, %edi	# task, task
	movl	%edx, -16(%ebp)	# work, %sfp
	movb	%cl, -21(%ebp)	# notify, %sfp
	.p2align 4,,15
.L3:
	movl	904(%edi), %esi	# task_3(D)->task_works, head
	cmpl	$work_exited, %esi	#, head
	sete	%bl	#, D.14145
	andl	$255, %ebx	#, D.14145
	xorl	%ecx, %ecx	#
	movl	%ebx, %edx	# D.14145,
	movl	$______f.14042, %eax	#,
	call	ftrace_likely_update	#
	testl	%ebx, %ebx	# D.14145
	jne	.L4	#,
	movl	-16(%ebp), %edx	# %sfp,
	movl	%esi, (%edx)	# head, work_13(D)->next
	movl	%esi, %eax	# head, __ret
#APP
# 34 "/c/wfg/tip/kernel/task_work.c" 1
	cmpxchgl %edx,904(%edi)	#, *__ptr_16
# 0 "" 2
#NO_APP
	cmpl	%eax, %esi	# __ret, head
	jne	.L3	#,
	cmpb	$0, -21(%ebp)	#, %sfp
	je	.L5	#,
	movl	4(%edi), %eax	# task_3(D)->stack, task_3(D)->stack
#APP
# 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
	bts $1, 8(%eax); jc .L2	#, MEM[(volatile long unsigned int *)D.14203_29],
# 0 "" 2
#NO_APP
.L5:
	movl	$0, -20(%ebp)	#, %sfp
.L2:
	movl	-20(%ebp), %eax	# %sfp,
	addl	$12, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.p2align 4,,15
.L4:
	movl	$-3, -20(%ebp)	#, %sfp
	movl	-20(%ebp), %eax	# %sfp,
	addl	$12, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	task_work_add, .-task_work_add
	.p2align 4,,15
	.globl	task_work_cancel
	.type	task_work_cancel, @function
task_work_cancel:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	pushl	%ecx	#
	call	mcount
	movl	%edx, %edi	# func, func
	leal	904(%eax), %esi	#, pprev
	addl	$960, %eax	#,
	movl	%eax, -16(%ebp)	#, %sfp
	call	_raw_spin_lock_irqsave	#
	movl	%eax, %ecx	#, flags
	jmp	.L14	#
	.p2align 4,,15
.L15:
	movl	%ebx, %esi	# work, pprev
.L14:
	movl	(%esi), %ebx	# MEM[(struct callback_head * volatile *)pprev_1], work
	testl	%ebx, %ebx	# work
	je	.L12	#,
	cmpl	%edi, 4(%ebx)	# func, work_7->func
	jne	.L15	#,
	movl	(%ebx), %edx	# work_7->next, __new
	movl	%ebx, %eax	# work, __ret
#APP
# 69 "/c/wfg/tip/kernel/task_work.c" 1
	cmpxchgl %edx,(%esi)	# __new, MEM[(volatile u32 *)pprev_1]
# 0 "" 2
#NO_APP
	cmpl	%eax, %ebx	# __ret, work
	jne	.L14	#,
	.p2align 4,,15
.L12:
	movl	%ecx, %edx	# flags,
	movl	-16(%ebp), %eax	# %sfp,
	call	_raw_spin_unlock_irqrestore	#
	movl	%ebx, %eax	# work,
	popl	%edx	#
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	task_work_cancel, .-task_work_cancel
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"/c/wfg/tip/kernel/task_work.c"
	.text
	.p2align 4,,15
	.globl	task_work_run
	.type	task_work_run, @function
task_work_run:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	call	mcount
#APP
# 14 "/c/wfg/tip/arch/x86/include/asm/current.h" 1
	movl current_task,%esi	#, task
# 0 "" 2
#NO_APP
	leal	904(%esi), %edi	#, __ptr
	.p2align 4,,15
.L31:
	movl	904(%esi), %edx	# task_39->task_works, work
	testl	%edx, %edx	# work
	je	.L32	#,
.L24:
	xorl	%ecx, %ecx	# head
.L17:
	movl	%edx, %eax	# work, __ret
#APP
# 99 "/c/wfg/tip/kernel/task_work.c" 1
	cmpxchgl %ecx,(%edi)	# head, *__ptr_14
# 0 "" 2
#NO_APP
	cmpl	%eax, %edx	# __ret, work
	jne	.L31	#,
	testl	%edx, %edx	# work
	je	.L16	#,
	.p2align 4,,15
.L28:
#APP
# 656 "/c/wfg/tip/arch/x86/include/asm/processor.h" 1
	rep; nop
# 0 "" 2
#NO_APP
	movl	960(%esi), %eax	# task_39->pi_lock.raw_lock.slock, D.14132
	testl	%eax, %eax	# D.14132
	je	.L28	#,
	xorl	%ebx, %ebx	# head
	jmp	.L21	#
	.p2align 4,,15
.L26:
	movl	%edx, %ebx	# work, head
	movl	%eax, %edx	# next, work
.L21:
	movl	(%edx), %eax	# work_1->next, next
	movl	%ebx, (%edx)	# head, work_1->next
	testl	%eax, %eax	# next
	jne	.L26	#,
	jmp	.L23	#
	.p2align 4,,15
.L32:
	testb	$4, 12(%esi)	#, task_39->flags
	je	.L24	#,
	movl	$work_exited, %ecx	#, head
	jmp	.L17	#
	.p2align 4,,15
.L33:
	movl	%ebx, %edx	# work, work
	movl	(%ebx), %ebx	# work_5->next, work
.L23:
	movl	%edx, %eax	# work,
	call	*4(%edx)	# work_2->func
	xorl	%ecx, %ecx	#
	movl	$125, %edx	#,
	movl	$.LC0, %eax	#,
	call	__might_sleep	#
	call	_cond_resched	#
	testl	%ebx, %ebx	# work
	jne	.L33	#,
	jmp	.L31	#
	.p2align 4,,15
.L16:
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	task_work_run, .-task_work_run
	.local	work_exited
	.comm	work_exited,8,4
	.section	_ftrace_annotated_branch,"aw",@progbits
	.align 4
	.type	______f.14042, @object
	.size	______f.14042, 20
______f.14042:
# func:
	.long	__func__.14043
# file:
	.long	.LC0
# line:
	.long	31
	.zero	8
	.section	.rodata
	.type	__func__.14043, @object
	.size	__func__.14043, 14
__func__.14043:
	.string	"task_work_add"
	.ident	"GCC: (Debian 4.6.3-1) 4.6.3"
	.section	.note.GNU-stack,"",@progbits

--7JfCtLOvnd9MIVvH--
