Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3KLTwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:52:12 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757169Ab3KLTvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:51:33 -0500
Message-ID: <528286C2.70908@nod.at>
Date: Tue, 12 Nov 2013 20:51:30 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 17/17] um: Remove unused declarations from <as-layout.h>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-18-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-18-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.11.2013 20:42, schrieb Geert Uytterhoeven:
> _end is used, but it's already provided by <asm/sections.h>, so use that.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: user-mode-linux-devel@lists.sourceforge.net

Geert, do you want me to pickup this patch or takes Andrew the whole series?

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

> ---
>  arch/um/include/shared/as-layout.h |    3 ---
>  arch/um/kernel/um_arch.c           |    1 +
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/um/include/shared/as-layout.h b/arch/um/include/shared/as-layout.h
> index 694c792bab4e..41c8c774ec10 100644
> --- a/arch/um/include/shared/as-layout.h
> +++ b/arch/um/include/shared/as-layout.h
> @@ -44,7 +44,6 @@ struct cpu_task {
>  
>  extern struct cpu_task cpu_tasks[];
>  
> -extern unsigned long low_physmem;
>  extern unsigned long high_physmem;
>  extern unsigned long uml_physmem;
>  extern unsigned long uml_reserved;
> @@ -52,8 +51,6 @@ extern unsigned long end_vm;
>  extern unsigned long start_vm;
>  extern unsigned long long highmem;
>  
> -extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
> -extern unsigned long _unprotected_end;
>  extern unsigned long brk_start;
>  
>  extern unsigned long host_task_size;
> diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> index 9fce866b0416..c44139833212 100644
> --- a/arch/um/kernel/um_arch.c
> +++ b/arch/um/kernel/um_arch.c
> @@ -17,6 +17,7 @@
>  #include <asm/byteorder.h>
>  #include <asm/pgtable.h>
>  #include <asm/processor.h>
> +#include <asm/sections.h>
>  #include <asm/setup.h>
>  #include <as-layout.h>
>  #include <arch.h>
> 

