Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaJBVfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:35:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:56980 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaJBVfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:35:02 -0400
Message-ID: <1412285674.28143.35.camel@pasglop>
Subject: Re: [PATCH] powerpc: fix sys_call_table declaration
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Romeo Cane <romeo.cane.ext@coriant.com>
Cc: Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 07:34:34 +1000
In-Reply-To: <20141002144131.GA3855@rcane-VirtualBox>
References: <20141002144131.GA3855@rcane-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 15:41 +0100, Romeo Cane wrote:
> Declaring sys_call_table as a pointer causes the compiler to generate the wrong lookup code in arch_syscall_addr

Care to elaborate ?

Ben.

> Signed-off-by: Romeo Cane <romeo.cane.ext@coriant.com>
> ---
>  arch/powerpc/include/asm/syscall.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
> index b54b2ad..528ba9d 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -17,7 +17,7 @@
>  
>  /* ftrace syscalls requires exporting the sys_call_table */
>  #ifdef CONFIG_FTRACE_SYSCALLS
> -extern const unsigned long *sys_call_table;
> +extern const unsigned long sys_call_table[];
>  #endif /* CONFIG_FTRACE_SYSCALLS */
>  
>  static inline long syscall_get_nr(struct task_struct *task,


