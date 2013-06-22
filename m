Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3FVG51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 02:57:27 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45726 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3FVG5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 02:57:25 -0400
X-Spam-Score: -100.8
Message-ID: <51C54A9B.9060009@asianux.com>
Date: Sat, 22 Jun 2013 14:56:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: include: asm: define 'VM_DATA_DEFAULT_FLAGS'
 no matter whether has 'NOMMU' or not.
References: <51C548E2.1060104@asianux.com>
In-Reply-To: <51C548E2.1060104@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The same .config file, also report the compiling error below:

drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of function ‘iowrite8’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of function ‘iowrite16’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of function ‘iowrite32’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of function ‘ioread8’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of function ‘ioread16’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of function ‘ioread32’ [-Werror=implicit-function-declaration]

Excuse me, I am not quite familiar with the related hardware and m68k,
I guess under m68k architecture, we need not this drivers, is it correct ?

Thanks.


On 06/22/2013 02:49 PM, Chen Gang wrote:
> 
> Define 'VM_DATA_DEFAULT_FLAGS' when 'NOMMU' to pass compiling.
> 
> So move it from "include/asm/page_mm.h to "include/asm/page.h"
> 
> The related make:
> 
>   make ARCH=m68k randconfig
>   make ARCH=m68k menuconfig
>     choose cross compiler
>     disable MMU support
>   make ARCH=m68k V=1 EXTRA_CFLAGS=-W
> 
> The related error:
> 
>   security/selinux/hooks.c: In function �selinux_init�:
>   security/selinux/hooks.c:5821:21: error: �VM_DATA_DEFAULT_FLAGS� undeclared (first use in this function)
> 
> (the attachment is the related .config file)
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/m68k/include/asm/page.h    |    3 +++
>  arch/m68k/include/asm/page_mm.h |    3 ---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
> index 7c360da..38b024a 100644
> --- a/arch/m68k/include/asm/page.h
> +++ b/arch/m68k/include/asm/page.h
> @@ -48,6 +48,9 @@ extern unsigned long _ramend;
>  #include <asm/page_no.h>
>  #endif
>  
> +#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
> +				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
> +
>  #include <asm-generic/getorder.h>
>  
>  #endif /* _M68K_PAGE_H */
> diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
> index 89f2014..5029f73 100644
> --- a/arch/m68k/include/asm/page_mm.h
> +++ b/arch/m68k/include/asm/page_mm.h
> @@ -173,7 +173,4 @@ static inline __attribute_const__ int __virt_to_node_shift(void)
>  
>  #endif /* __ASSEMBLY__ */
>  
> -#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
> -				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
> -
>  #endif /* _M68K_PAGE_MM_H */
> 


-- 
Chen Gang

Asianux Corporation
