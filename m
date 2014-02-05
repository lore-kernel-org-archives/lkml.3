Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaBEBIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:08:54 -0500
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:56283 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755125AbaBEBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:08:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAPCL8VKVhxBY/2dsb2JhbAANTMI6gR+DGQEBAQR4ARALGAkWDwkDAgECAUUGDQEFAgEBtAiiIheOEWQHhDgBA6J6ixGBVg
X-IronPort-AV: E=Sophos;i="4.95,783,1384272000"; 
   d="scan'208";a="389541108"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 389541108
X-WN-SMTPAUTHID: gregungerer
Message-ID: <52F18D2B.4030501@uclinux.org>
Date: Wed, 05 Feb 2014 11:00:27 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] m68k: Wire up sched_setattr and sched_getattr
References: <1391544954-7422-1-git-send-email-geert@linux-m68k.org> <1391544954-7422-3-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1391544954-7422-3-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 06:15, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>  arch/m68k/include/asm/unistd.h      |    2 +-
>  arch/m68k/include/uapi/asm/unistd.h |    2 ++
>  arch/m68k/kernel/syscalltable.S     |    2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
> index 014f288fc813..9d38b73989eb 100644
> --- a/arch/m68k/include/asm/unistd.h
> +++ b/arch/m68k/include/asm/unistd.h
> @@ -4,7 +4,7 @@
>  #include <uapi/asm/unistd.h>
>  
>  
> -#define NR_syscalls		349
> +#define NR_syscalls		351
>  
>  #define __ARCH_WANT_OLD_READDIR
>  #define __ARCH_WANT_OLD_STAT
> diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
> index 625f321001dc..b932dd470041 100644
> --- a/arch/m68k/include/uapi/asm/unistd.h
> +++ b/arch/m68k/include/uapi/asm/unistd.h
> @@ -354,5 +354,7 @@
>  #define __NR_process_vm_writev	346
>  #define __NR_kcmp		347
>  #define __NR_finit_module	348
> +#define __NR_sched_setattr	349
> +#define __NR_sched_getattr	350
>  
>  #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
> diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
> index 3f04ea0ab802..b6223dc41d82 100644
> --- a/arch/m68k/kernel/syscalltable.S
> +++ b/arch/m68k/kernel/syscalltable.S
> @@ -369,4 +369,6 @@ ENTRY(sys_call_table)
>  	.long sys_process_vm_writev
>  	.long sys_kcmp
>  	.long sys_finit_module
> +	.long sys_sched_setattr
> +	.long sys_sched_getattr		/* 350 */
>  
> 

