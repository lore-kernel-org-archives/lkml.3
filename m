Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaBKOmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:42:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBKOmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:42:43 -0500
Date: Tue, 11 Feb 2014 08:51:27 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, catalin.marinas@arm.com,
        will.deacon@arm.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, arndb@arndb.de, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/3] arm64: Add audit support
Message-ID: <20140211135127.GB17952@madcap2.tricolour.ca>
References: <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
 <1391767803-5350-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391767803-5350-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/07, AKASHI Takahiro wrote:
> This patchset adds system call audit support on arm64.
> Both 32-bit (AUDIT_ARCH_ARM) and 64-bit tasks (AUDIT_ARCH_AARCH64)
> are supported. Since arm64 has the exact same set of system calls
> on LE and BE, we don't care about endianness (or more specifically
> __AUDIT_ARCH_64BIT bit in AUDIT_ARCH_*).
> 
> There are some prerequisites for this patch to work correctly:
> * "generic compat system call audit support" patch
> * "correct a type mismatch in audit_syscall_exit()" patch
>    (already accepted and queued in 3.14)
> * "Modify a set of system calls in audit class" patch
>    (already accepted and queued in 3.14)
> * "__NR_* definitions for compat syscalls" patch from Catalin
> * "make a single hook to syscall_trace() for all syscall features" patch
> * userspace audit tool (v2.3.2 + my patch for arm64)
> 
> Please review them as well for better understandings.
> 
> This code was tested on both 32-bit and 64-bit LE userland 
> in the following two ways:
> 1) basic operations with auditctl/autrace
>   # auditctl -a exit,always -S openat -F path=/etc/inittab
>   # auditctl -a exit,always -F dir=/tmp -F perm=rw
>   # auditctl -a task,always
>   # autrace /bin/ls
>     by comparing output from autrace with one from strace
> 
> 2) audit-test-code (+ my workarounds for arm/arm64)
>   by running "audit-tool", "filter" and "syscalls" test categories.
> 
> Changes v1 -> v2:
> * Modified to utilize "generic compat system call audit" [3/6, 4/6, 5/6]
>   Please note that a required header, unistd_32.h, is automatically
>   generated from unistd32.h.
> * Refer to regs->orig_x0 instead of regs->x0 as the first argument of
>   system call in audit_syscall_entry() [6/6]
> * Include "Add regs_return_value() in syscall.h" patch [2/6],
>   which was not intentionally included in v1 because it could be added
>   by "kprobes support".
> 
> Changes v2 -> v3:
> * Remove asm/audit.h.
>   See "generic compat syscall audit support" patch v4
> * Remove endianness dependency, ie. AUDIT_ARCH_ARMEB/AARCH64EB.
> * Remove kernel/syscalls/Makefile which was used to create unistd32.h.
>   See Catalin's "Add __NR_* definitions for compat syscalls" patch
> 
> Changes v3 -> v4:
> * Modified to sync with the patch, "make a single hook to syscall_trace()
>   for all syscall features"
> 
> 
> AKASHI Takahiro (3):
>   arm64: Add regs_return_value() in syscall.h
>   arm64: Add audit support
>   arm64: audit: Add audit hook in ptrace/syscall_trace
> 
>  arch/arm64/Kconfig               |    1 +
>  arch/arm64/include/asm/ptrace.h  |    5 +++++
>  arch/arm64/include/asm/syscall.h |   15 +++++++++++++++
>  arch/arm64/kernel/ptrace.c       |    7 +++++++
>  include/uapi/linux/audit.h       |    1 +
>  5 files changed, 29 insertions(+)

Compile and regression tested on: ppc s390 x86_64 ppc64 i686 s390x.

Acked-by: Richard Guy Briggs <rgb@redhat.com>

> -- 
> 1.7.9.5
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
