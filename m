Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbaEMJW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:22:29 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:8420 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837AbaEMJW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:22:26 -0400
Message-ID: <5371E44E.20509@imgtec.com>
Date: Tue, 13 May 2014 10:22:22 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <lftan.linux@gmail.com>, <cltang@codesourcery.com>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH 12/25] metag: Add 32 bit time_t and clock_t
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <1399971885-4413-1-git-send-email-lftan@altera.com>
In-Reply-To: <1399971885-4413-1-git-send-email-lftan@altera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13/05/14 10:04, Ley Foon Tan wrote:
> Override time_t and clock_t in include/uapi/asm-generic.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  arch/metag/include/asm/Kbuild             |  1 -
>  arch/metag/include/uapi/asm/Kbuild        |  1 +
>  arch/metag/include/uapi/asm/posix_types.h | 17 +++++++++++++++++
>  3 files changed, 18 insertions(+), 1 deletion(-)
>  create mode 100644 arch/metag/include/uapi/asm/posix_types.h
> 
> diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
> index c29ead8..5a97e0d6 100644
> --- a/arch/metag/include/asm/Kbuild
> +++ b/arch/metag/include/asm/Kbuild
> @@ -31,7 +31,6 @@ generic-y += param.h
>  generic-y += pci.h
>  generic-y += percpu.h
>  generic-y += poll.h
> -generic-y += posix_types.h
>  generic-y += preempt.h
>  generic-y += scatterlist.h
>  generic-y += sections.h
> diff --git a/arch/metag/include/uapi/asm/Kbuild b/arch/metag/include/uapi/asm/Kbuild
> index 84e09fe..1542689 100644
> --- a/arch/metag/include/uapi/asm/Kbuild
> +++ b/arch/metag/include/uapi/asm/Kbuild
> @@ -3,6 +3,7 @@ include include/uapi/asm-generic/Kbuild.asm
>  
>  header-y += byteorder.h
>  header-y += ech.h
> +header-y += posix_types.h

I don't think you need this. The file
include/uapi/asm-generic/Kbuild.asm which is included at the top of each
arches uapi/asm/Kbuild already has it.
(Admittedly there's already a lot of duplication of these that should
probably be fixed at some point).

Other than that it looks okay to me.

Cheers
James

>  header-y += ptrace.h
>  header-y += resource.h
>  header-y += sigcontext.h
> diff --git a/arch/metag/include/uapi/asm/posix_types.h b/arch/metag/include/uapi/asm/posix_types.h
> new file mode 100644
> index 0000000..d643b22
> --- /dev/null
> +++ b/arch/metag/include/uapi/asm/posix_types.h
> @@ -0,0 +1,17 @@
> +#ifndef __ARCH_METAG_POSIX_TYPES_H
> +#define __ARCH_METAG_POSIX_TYPES_H
> +
> +/*
> + * This file is generally used by user-level software, so you need to
> + * be a little careful about namespace pollution etc. Also, we cannot
> + * assume GCC is being used.
> + */
> +typedef long	__kernel_time_t;
> +#define __kernel_time_t __kernel_time_t
> +
> +typedef long	__kernel_clock_t;
> +#define __kernel_clock_t __kernel_clock_t
> +
> +#include <asm-generic/posix_types.h>
> +
> +#endif
> 
