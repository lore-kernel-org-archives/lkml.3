Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaJANMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:12:48 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40086 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJANMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:12:47 -0400
Date: Wed, 1 Oct 2014 14:12:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 13/24] ARM64:ILP32: Use the non compat HWCAP for ILP32
Message-ID: <20141001131232.GK12702@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-14-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-14-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:07PM +0100, Andrew Pinski wrote:
> Signed-off-by: Andrew Pinski <apinski@cavium.com>
> ---
>  arch/arm64/include/asm/compat.h |   10 ++++++++++
>  arch/arm64/include/asm/hwcap.h  |    2 --
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index eca6eec..2f84d2c 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -296,6 +296,16 @@ struct compat_shmid64_ds {
>  	compat_ulong_t __unused5;
>  };
>  
> +#define COMPAT_ELF_HWCAP	\
> +	(is_a32_compat_task()	\
> +	  ? compat_elf_hwcap	\
> +	  : elf_hwcap)
> +
> +#define COMPAT_ELF_HWCAP2	\
> +	(is_a32_compat_task()	\
> +	  ? compat_elf_hwcap2	\
> +	  : 0)
> +
>  static inline int is_compat_task(void)
>  {
>  	return test_thread_flag(TIF_32BIT);
> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> index 024c461..31e7e02 100644
> --- a/arch/arm64/include/asm/hwcap.h
> +++ b/arch/arm64/include/asm/hwcap.h
> @@ -46,8 +46,6 @@
>  #define ELF_HWCAP		(elf_hwcap)
>  
>  #ifdef CONFIG_COMPAT
> -#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
> -#define COMPAT_ELF_HWCAP2	(compat_elf_hwcap2)
>  extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
>  #endif

Any reason why you are moving the definitions from here? Can you not
include asm/compat.h in asm/hwcap.h? (or move the compat_elf_hwcap
declaration as well).

-- 
Catalin
