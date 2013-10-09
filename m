Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3JIMTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:19:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:59456 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3JIMTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:19:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1063,1371106800"; 
   d="s'?scan'208";a="408250140"
Date: Wed, 9 Oct 2013 20:19:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009121911.GA18770@localhost>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20131009080459.GA2298@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > Fengguang, I do not think this will help, but just in case. Could you
> > show the result of
> > 
> >         $ kernel/task_work.s

Update: I recompiled the kernel with gcc 4.4.7 and find it booting fine!

Attached is the new kernel/task_work.s.

Thanks,
Fengguang

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="task_work.s"

	.file	"task_work.c"
# GNU C (Debian 4.4.7-4) version 4.4.7 (x86_64-linux-gnu)
#	compiled by GNU C version 4.4.7, GMP version 5.1.1, MPFR version 3.1.1-p2.
# warning: GMP header version 5.1.1 differs from library version 5.0.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -nostdinc -I/c/wfg/tip/arch/x86/include
# -Iarch/x86/include/generated -I/c/wfg/tip/include -Iinclude
# -I/c/wfg/tip/arch/x86/include/uapi -Iarch/x86/include/generated/uapi
# -I/c/wfg/tip/include/uapi -Iinclude/generated/uapi -I/c/wfg/tip/kernel
# -Ikernel -imultilib 32 -imultiarch i386-linux-gnu -D__KERNEL__
# -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
# -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1
# -DKBUILD_STR(s)=#s -DKBUILD_BASENAME=KBUILD_STR(task_work)
# -DKBUILD_MODNAME=KBUILD_STR(task_work) -isystem
# /usr/lib/gcc/x86_64-linux-gnu/4.4.7/include -include
# /c/wfg/tip/include/linux/kconfig.h -MD kernel/.task_work.s.d
# /c/wfg/tip/kernel/task_work.c -m32 -msoft-float -mregparm=3
# -mpreferred-stack-boundary=2 -march=winchip2 -maccumulate-outgoing-args
# -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -auxbase-strip
# kernel/task_work.s -O2 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
# -Werror-implicit-function-declaration -Wno-format-security
# -Wno-sign-compare -Wframe-larger-than=1024 -Wdeclaration-after-statement
# -Wno-pointer-sign -p -fno-strict-aliasing -fno-common
# -fno-delete-null-pointer-checks -freg-struct-return -fno-pic
# -ffreestanding -fno-asynchronous-unwind-tables -fno-stack-protector
# -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-strict-overflow
# -fconserve-stack -fverbose-asm
# options enabled:  -falign-loops -fargument-alias -fauto-inc-dec
# -fbranch-count-reg -fcaller-saves -fcprop-registers -fcrossjumping
# -fcse-follow-jumps -fdefer-pop -fdwarf2-cfi-asm -fearly-inlining
# -feliminate-unused-debug-types -fexpensive-optimizations
# -fforward-propagate -ffunction-cse -fgcse -fgcse-lm
# -fguess-branch-probability -fident -fif-conversion -fif-conversion2
# -findirect-inlining -finline -finline-functions-called-once
# -finline-small-functions -fipa-cp -fipa-pure-const -fipa-reference
# -fira-share-save-slots -fira-share-spill-slots -fivopts
# -fkeep-static-consts -fleading-underscore -fmath-errno -fmerge-constants
# -fmerge-debug-strings -fmove-loop-invariants -foptimize-register-move
# -fpeephole -fpeephole2 -fprofile -freg-struct-return -fregmove
# -freorder-blocks -freorder-functions -frerun-cse-after-loop
# -fsched-interblock -fsched-spec -fsched-stalled-insns-dep -fsigned-zeros
# -fsplit-ivs-in-unroller -fsplit-wide-types -fthread-jumps
# -ftoplevel-reorder -ftrapping-math -ftree-builtin-call-dce -ftree-ccp
# -ftree-ch -ftree-copy-prop -ftree-copyrename -ftree-cselim -ftree-dce
# -ftree-dominator-opts -ftree-dse -ftree-fre -ftree-loop-im
# -ftree-loop-ivcanon -ftree-loop-optimize -ftree-parallelize-loops=
# -ftree-pre -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-sra
# -ftree-switch-conversion -ftree-ter -ftree-vect-loop-version -ftree-vrp
# -funit-at-a-time -fvect-cost-model -fverbose-asm
# -fzero-initialized-in-bss -m32 -m96bit-long-double
# -maccumulate-outgoing-args -malign-stringops -mfused-madd -mglibc
# -mieee-fp -mno-fancy-math-387 -mno-red-zone -mno-sse4 -mpush-args -msahf
# -mtls-direct-seg-refs

# Compiler executable checksum: f7c11247ad5a53a602823d9bd673a474

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"/c/wfg/tip/kernel/task_work.c"
	.text
	.p2align 4,,15
.globl task_work_run
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
	movl current_task,%edi	#, task
# 0 "" 2
#NO_APP
	leal	904(%edi), %ebx	#, D.18648
	.p2align 4,,15
.L15:
	movl	(%ebx), %edx	#* D.18648, work
	testl	%edx, %edx	# work
	je	.L17	#,
.L2:
	xorl	%ecx, %ecx	# head.458
.L3:
	movl	%edx, %eax	# work, __ret
#APP
# 99 "/c/wfg/tip/kernel/task_work.c" 1
	cmpxchgl %ecx,(%ebx)	# head.458,* D.18648
# 0 "" 2
#NO_APP
	cmpl	%eax, %edx	# __ret, work
	jne	.L15	#,
	testl	%edx, %edx	# work
	je	.L10	#,
	.p2align 4,,15
.L12:
#APP
# 656 "/c/wfg/tip/arch/x86/include/asm/processor.h" 1
	rep; nop
# 0 "" 2
#NO_APP
	movl	960(%edi), %eax	# <variable>.pi_lock.raw_lock.slock, D.18658
	testl	%eax, %eax	# D.18658
	je	.L12	#,
	xorl	%esi, %esi	# head
	jmp	.L8	#
	.p2align 4,,15
.L18:
	movl	%edx, %esi	# work, head
	movl	%eax, %edx	# next, work
.L8:
	movl	(%edx), %eax	# <variable>.next, next
	movl	%esi, (%edx)	# head, <variable>.next
	testl	%eax, %eax	# next
	jne	.L18	#,
	jmp	.L9	#
	.p2align 4,,15
.L17:
	testb	$4, 12(%edi)	#, <variable>.flags
	je	.L2	#,
	movl	$work_exited, %ecx	#, head.458
	jmp	.L3	#
	.p2align 4,,15
.L19:
	movl	%esi, %edx	# work.461, work
	movl	(%esi), %esi	# <variable>.next, work.461
.L9:
	movl	%edx, %eax	# work,
	call	*4(%edx)	# <variable>.func
	xorl	%ecx, %ecx	#
	movl	$125, %edx	#,
	movl	$.LC0, %eax	#,
	call	__might_sleep	#
	call	_cond_resched	#
	testl	%esi, %esi	# work.461
	jne	.L19	#,
	jmp	.L15	#
	.p2align 4,,15
.L10:
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	task_work_run, .-task_work_run
	.p2align 4,,15
.globl task_work_cancel
	.type	task_work_cancel, @function
task_work_cancel:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	subl	$4, %esp	#,
	call	mcount
	movl	%edx, %edi	# func, func
	leal	904(%eax), %esi	#, pprev
	addl	$960, %eax	#,
	movl	%eax, -16(%ebp)	#, %sfp
	call	_raw_spin_lock_irqsave	#
	movl	%eax, %edx	#, flags
	jmp	.L28	#
	.p2align 4,,15
.L29:
	movl	%ebx, %esi	# work, pprev
.L28:
	movl	(%esi), %ebx	#* pprev, work
	testl	%ebx, %ebx	# work
	je	.L23	#,
	cmpl	%edi, 4(%ebx)	# func, <variable>.func
	jne	.L29	#,
	movl	(%ebx), %ecx	# <variable>.next, __new
	movl	%ebx, %eax	# work, __ret
#APP
# 69 "/c/wfg/tip/kernel/task_work.c" 1
	cmpxchgl %ecx,(%esi)	# __new,* pprev
# 0 "" 2
#NO_APP
	cmpl	%eax, %ebx	# __ret, work
	jne	.L28	#,
	.p2align 4,,15
.L23:
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
	.p2align 4,,15
.globl task_work_add
	.type	task_work_add, @function
task_work_add:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	subl	$12, %esp	#,
	call	mcount
	movl	%eax, -20(%ebp)	# task, %sfp
	movl	%edx, -16(%ebp)	# work, %sfp
	movb	%cl, -21(%ebp)	# notify, %sfp
	movl	%eax, %edi	# task, D.18562
	addl	$904, %edi	#, D.18562
	.p2align 4,,15
.L33:
	movl	(%edi), %esi	#* D.18562, head
	cmpl	$work_exited, %esi	#, head
	sete	%al	#, tmp72
	xorl	%ebx, %ebx	# D.18565
	movb	%al, %bl	# tmp72, D.18565
	xorl	%ecx, %ecx	#
	movl	%ebx, %edx	# D.18565,
	movl	$______f.18543, %eax	#,
	call	ftrace_likely_update	#
	testl	%ebx, %ebx	# D.18565
	jne	.L38	#,
	movl	-16(%ebp), %eax	# %sfp,
	movl	%esi, (%eax)	# head, <variable>.next
	movl	%esi, %eax	# head, __ret
	movl	-16(%ebp), %edx	# %sfp,
#APP
# 34 "/c/wfg/tip/kernel/task_work.c" 1
	cmpxchgl %edx,(%edi)	#,* D.18562
# 0 "" 2
#NO_APP
	cmpl	%eax, %esi	# __ret, head
	jne	.L33	#,
	cmpb	$0, -21(%ebp)	# %sfp
	je	.L37	#,
	movl	-20(%ebp), %edx	# %sfp,
	movl	4(%edx), %eax	# <variable>.stack, <variable>.stack
#APP
# 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
	bts $1, 8(%eax); setc %dl	#,, c
# 0 "" 2
#NO_APP
.L37:
	xorl	%eax, %eax	# D.18573
	addl	$12, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.p2align 4,,15
.L38:
	movl	$-3, %eax	#, D.18573
	addl	$12, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	task_work_add, .-task_work_add
	.section	_ftrace_annotated_branch,"aw",@progbits
	.align 4
	.type	______f.18543, @object
	.size	______f.18543, 20
______f.18543:
# func:
	.long	__func__.18544
# file:
	.long	.LC0
# line:
	.long	31
	.zero	8
	.local	work_exited
	.comm	work_exited,8,4
	.section	.rodata
	.type	__func__.18544, @object
	.size	__func__.18544, 14
__func__.18544:
	.string	"task_work_add"
	.ident	"GCC: (Debian 4.4.7-4) 4.4.7"
	.section	.note.GNU-stack,"",@progbits

--cNdxnHkX5QqsyA0e--
