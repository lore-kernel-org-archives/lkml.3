Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaHSPru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:47:50 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33310 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHSPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:47:49 -0400
Message-ID: <53F371A0.8060700@gmail.com>
Date: Tue, 19 Aug 2014 23:47:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/microblaze/include/asm/entry.h: Include "linux/linkage.h"
 to avoid compiling issue
References: <53E22E85.9010205@gmail.com>
In-Reply-To: <53E22E85.9010205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello maintainers:

Please help check the related 2 patches when you have time.

Thanks.

On 08/06/2014 09:32 PM, Chen Gang wrote:
> "entry.h" needs 'asmlinkage', and "asm/linkage.h" does not provide it.
> So need include "linux/linkage.h" to use generic one instead of.
> 
> The related error (with allmodconfig under microblaze):
> 
>     CC [M]  drivers/net/ethernet/emulex/benet/be_main.o
>   In file included from ./arch/microblaze/include/asm/processor.h:17:0,
>                    from include/linux/prefetch.h:14,
>                    from drivers/net/ethernet/emulex/benet/be_main.c:18:
>   ./arch/microblaze/include/asm/entry.h:33:19: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void'
>    extern asmlinkage void do_notify_resume(struct pt_regs *regs, int in_syscall);
>                      ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/microblaze/include/asm/entry.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
> index b4a4cb1..596e485 100644
> --- a/arch/microblaze/include/asm/entry.h
> +++ b/arch/microblaze/include/asm/entry.h
> @@ -15,6 +15,7 @@
>  
>  #include <asm/percpu.h>
>  #include <asm/ptrace.h>
> +#include <linux/linkage.h>
>  
>  /*
>   * These are per-cpu variables required in entry.S, among other
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
