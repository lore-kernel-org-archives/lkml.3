Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaFSMyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:54:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32557 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752141AbaFSMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:54:12 -0400
Date: Thu, 19 Jun 2014 13:54:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/24] ARM64:ILP32: Use the non compat HWCAP for ILP32.
Message-ID: <20140619125408.GD8476@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-16-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-16-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:10AM -0700, Andrew Pinski wrote:
> Signed-off-by: Andrew Pinski <apinski@cavium.com>

Please add some commit log, even if minimal.

> ---
>  arch/arm64/include/asm/hwcap.h |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> index 024c461..cb87f91 100644
> --- a/arch/arm64/include/asm/hwcap.h
> +++ b/arch/arm64/include/asm/hwcap.h
> @@ -46,9 +46,17 @@
>  #define ELF_HWCAP		(elf_hwcap)
>  
>  #ifdef CONFIG_COMPAT
> -#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
> -#define COMPAT_ELF_HWCAP2	(compat_elf_hwcap2)
>  extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
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
>  #endif
>  
>  extern unsigned long elf_hwcap;

Do any extra headers need to be included? It looks like we rely on the
code including hwcap.h to have the correct headers.

-- 
Catalin
