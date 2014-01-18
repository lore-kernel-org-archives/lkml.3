Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaARJot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 04:44:49 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51287 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaARJoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 04:44:44 -0500
Message-ID: <52DA4D09.7030904@gmail.com>
Date: Sat, 18 Jan 2014 17:44:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com> <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz> <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com> <52CA76D3.2010102@suse.cz> <52CE4496.5030401@synopsys.com> <52D01639.9000205@gmail.com> <52D1F6F1.1070006@gmail.com>
In-Reply-To: <52D1F6F1.1070006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch when you have time.

Thanks.

On 01/12/2014 09:59 AM, Chen Gang wrote:
> For some assemblers, they use another character as newline in a macro
> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
> macro) instead of ';' for it.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> Acked-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/include/asm/linkage.h |  2 ++
>  include/linux/linkage.h        | 19 ++++++++++++-------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
> index 0283e9e..66ee552 100644
> --- a/arch/arc/include/asm/linkage.h
> +++ b/arch/arc/include/asm/linkage.h
> @@ -11,6 +11,8 @@
>  
>  #ifdef __ASSEMBLY__
>  
> +#define ASM_NL		 `	/* use '`' to mark new line in macro */
> +
>  /* Can't use the ENTRY macro in linux/linkage.h
>   * gas considers ';' as comment vs. newline
>   */
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index d3e8ad2..a6a42dd 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -6,6 +6,11 @@
>  #include <linux/export.h>
>  #include <asm/linkage.h>
>  
> +/* Some toolchains use other characters (e.g. '`') to mark new line in macro */
> +#ifndef ASM_NL
> +#define ASM_NL		 ;
> +#endif
> +
>  #ifdef __cplusplus
>  #define CPP_ASMLINKAGE extern "C"
>  #else
> @@ -75,21 +80,21 @@
>  
>  #ifndef ENTRY
>  #define ENTRY(name) \
> -  .globl name; \
> -  ALIGN; \
> -  name:
> +	.globl name ASM_NL \
> +	ALIGN ASM_NL \
> +	name:
>  #endif
>  #endif /* LINKER_SCRIPT */
>  
>  #ifndef WEAK
>  #define WEAK(name)	   \
> -	.weak name;	   \
> +	.weak name ASM_NL   \
>  	name:
>  #endif
>  
>  #ifndef END
>  #define END(name) \
> -  .size name, .-name
> +	.size name, .-name
>  #endif
>  
>  /* If symbol 'name' is treated as a subroutine (gets called, and returns)
> @@ -98,8 +103,8 @@
>   */
>  #ifndef ENDPROC
>  #define ENDPROC(name) \
> -  .type name, @function; \
> -  END(name)
> +	.type name, @function ASM_NL \
> +	END(name)
>  #endif
>  
>  #endif
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
