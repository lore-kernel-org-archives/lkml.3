Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbaFYOyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112AbaFYOyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:54:16 -0400
Message-ID: <1403708017.755.86.camel@deneb.redhat.com>
Subject: Re: [PATCH_v4 0/2] arm64: Add seccomp support
From: Mark Salter <msalter@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arndb@arndb.de, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Date: Wed, 25 Jun 2014 10:53:37 -0400
In-Reply-To: <1394862604-29105-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394862604-29105-1-git-send-email-takahiro.akashi@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the current status of this patch series? Is it on track
for 3.17?

On Sat, 2014-03-15 at 14:50 +0900, AKASHI Takahiro wrote:
> (Please apply this patch after my ftrace patch and audit patch in order
> to avoid some conflict on arm64/Kconfig.)
> 
> This patch enables secure computing (system call filtering) on arm64.
> System calls can be allowed or denied by loaded bpf-style rules.
> Architecture specific part is to run secure_computing() on syscall entry
> and check the result. See [2/2]
> 
> Prerequisites are:
>  * "arm64: make a single hook to syscall_trace() for all syscall features" patch
>  * "arm64: split syscall_trace() into separate functions for enter/exit" patch
>  * "arm64: Add audit support" patch
>  * "arm64: is_compat_task is defined both in asm/compat.h and 
>     linux/compat.h" patch
> 
> This code is tested on ARMv8 fast model using libseccomp v2.1.1 with
> modifications for arm64 and verified by its "live" tests, 20, 21 and 24.
> 
> Changes v3 -> v4:
> * removed the following patch and moved it to "arm64: prerequisites for
>   audit and ftrace" patchset since it is required for audit and ftrace in
>   case of !COMPAT, too.
>   "arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h"
> 
> Changes v2 -> v3:
> * removed unnecessary 'type cast' operations [2/3]
> * check for a return value (-1) of secure_computing() explicitly [2/3]
> * aligned with the patch, "arm64: split syscall_trace() into separate
>   functions for enter/exit" [2/3]
> * changed default of CONFIG_SECCOMP to n [2/3]
> 
> Changes v1 -> v2:
> * added generic seccomp.h for arm64 to utilize it [1,2/3] 
> * changed syscall_trace() to return more meaningful value (-EPERM)
>   on seccomp failure case [2/3]
> * aligned with the change in "arm64: make a single hook to syscall_trace()
>   for all syscall features" v2 [2/3]
> * removed is_compat_task() definition from compat.h [3/3]
> 
> AKASHI Takahiro (2):
>   asm-generic: Add generic seccomp.h for secure computing mode 1
>   arm64: Add seccomp support
> 
>  arch/arm64/Kconfig               | 14 ++++++++++++++
>  arch/arm64/include/asm/seccomp.h | 25 +++++++++++++++++++++++++
>  arch/arm64/include/asm/unistd.h  |  3 +++
>  arch/arm64/kernel/entry.S        |  4 ++++
>  arch/arm64/kernel/ptrace.c       |  6 ++++++
>  include/asm-generic/seccomp.h    | 28 ++++++++++++++++++++++++++++
>  6 files changed, 80 insertions(+)
>  create mode 100644 arch/arm64/include/asm/seccomp.h
>  create mode 100644 include/asm-generic/seccomp.h
> 


