Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbaDWOEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:04:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57086 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbaDWOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:04:33 -0400
Message-ID: <5357C840.1000701@ti.com>
Date: Wed, 23 Apr 2014 17:03:44 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-arm-kernel@lists.infradead.org>, <mszeredi@suse.cz>,
        <tytso@mit.edu>
Subject: Re: [PATCH] ARM: Wire up the renameat2() syscall
References: <1398150338-23475-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1398150338-23475-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 10:05 AM, Peter Ujfalusi wrote:
> The new renameat2() system call was only wired up for ARM causing:

obviously I mean that "system call was _not_ wired up for ARM causing"

I can send the patch again with a fixed up commit message...

>  CALL    /home/ujfalusi/work/kernel/kernel.org-next-linux-next/scripts/checksyscalls.sh
> <stdin>:1232:2: warning: #warning syscall renameat2 not implemented [-Wcpp]
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> Hi,
> 
> I have noticed this with linux-next.
> 
> Regards,
> Peter
> 
>  arch/arm/include/uapi/asm/unistd.h | 1 +
>  arch/arm/kernel/calls.S            | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
> index fb5584d0cc05..ba94446c72d9 100644
> --- a/arch/arm/include/uapi/asm/unistd.h
> +++ b/arch/arm/include/uapi/asm/unistd.h
> @@ -408,6 +408,7 @@
>  #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
>  #define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
>  #define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
> +#define __NR_renameat2			(__NR_SYSCALL_BASE+382)
>  
>  /*
>   * This may need to be greater than __NR_last_syscall+1 in order to
> diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
> index 166e945de832..8f51bdcdacbb 100644
> --- a/arch/arm/kernel/calls.S
> +++ b/arch/arm/kernel/calls.S
> @@ -391,6 +391,7 @@
>  		CALL(sys_finit_module)
>  /* 380 */	CALL(sys_sched_setattr)
>  		CALL(sys_sched_getattr)
> +		CALL(sys_renameat2)
>  #ifndef syscalls_counted
>  .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
>  #define syscalls_counted
> 


-- 
Péter
