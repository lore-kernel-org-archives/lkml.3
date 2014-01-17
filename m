Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaAQToq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaAQToo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:44:44 -0500
Date: Fri, 17 Jan 2014 14:44:08 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, catalin.marinas@arm.com,
        will.deacon@arm.com, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH v2 0/6] arm64: Add audit support
Message-ID: <20140117194408.GC7084@madcap2.tricolour.ca>
References: <1383733546-2846-1-git-send-email-takahiro.akashi@linaro.org>
 <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/17, AKASHI Takahiro wrote:
> This patchset adds system call audit support on arm64.
> Both 32-bit (AUIDT_ARCH_ARM[EB]) and 64-bit tasks (AUDIT_ARCH_AARCH64[EB])
> are supported, but presuming 32-LE on 64-LE or 32-BE on 64-BE.
> 
> There are some prerequisites for this patch to work correctly:
> * "generic compat system call audit support" patch
> * "correct a type mismatch in audit_syscall_exit()" patch
>    (already accepted and queued in 3.14)
> * "Modify a set of system calls in audit class" patch
> * userspace audit tool (v2.3.2 + my patch for arm64)
> 
> All those were already or will be soon posted separately.
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
> 
> AKASHI Takahiro (6):
>   audit: Enable arm64 support
>   arm64: Add regs_return_value() in syscall.h
>   arm64: Add audit support
>   arm64: audit: Add 32-bit (compat) syscall support
>   arm64: audit: Add makefile rule to create unistd_32.h for compat
>     syscalls
>   arm64: audit: Add audit hook in ptrace/syscall_trace
> 
>  arch/arm64/Makefile                  |    4 ++++
>  arch/arm64/include/asm/audit.h       |   20 ++++++++++++++++++++
>  arch/arm64/include/asm/ptrace.h      |    5 +++++
>  arch/arm64/include/asm/syscall.h     |   22 ++++++++++++++++++++++
>  arch/arm64/include/asm/thread_info.h |    1 +
>  arch/arm64/kernel/entry.S            |    3 +++
>  arch/arm64/kernel/ptrace.c           |   12 ++++++++++++
>  arch/arm64/kernel/syscalls/Makefile  |   20 ++++++++++++++++++++
>  include/uapi/linux/audit.h           |    2 ++
>  init/Kconfig                         |    2 +-
>  10 files changed, 90 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/audit.h
>  create mode 100644 arch/arm64/kernel/syscalls/Makefile
> 
> -- 
> 1.7.9.5

Set:
Acked-by: Richard Guy Briggs <rgb@redhat.com>

> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
