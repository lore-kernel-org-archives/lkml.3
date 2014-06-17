Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbaFQPWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:22:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57983 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933112AbaFQPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:22:53 -0400
Date: Tue, 17 Jun 2014 16:22:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/24] ARM64:UAPI: Set the correct __BITS_PER_LONG for
 ILP32.
Message-ID: <20140617152250.GC21752@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-6-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-6-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:00AM -0700, Andrew Pinski wrote:
> diff --git a/arch/arm64/include/uapi/asm/bitsperlong.h b/arch/arm64/include/uapi/asm/bitsperlong.h
> index fce9c29..5e06c59 100644
> --- a/arch/arm64/include/uapi/asm/bitsperlong.h
> +++ b/arch/arm64/include/uapi/asm/bitsperlong.h
> @@ -16,7 +16,12 @@
>  #ifndef __ASM_BITSPERLONG_H
>  #define __ASM_BITSPERLONG_H
>  
> -#define __BITS_PER_LONG 64
> +/* Assuming __LP64__ will be defined for native ELF64's and not for ILP32. */
> +#ifdef __LP64__
> +# define __BITS_PER_LONG 64
> +#else
> +# define __BITS_PER_LONG 32
> +#endif

I think it's enough to just define it for the __LP64__ case.

>  #include <asm-generic/bitsperlong.h>

The asm-generic definition if 32 by default.

-- 
Catalin
