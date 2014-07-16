Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482AbaGPQUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:20:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48888 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934733AbaGPQUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:20:33 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        ralf@linux-mips.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com
Cc: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/4] arm64: use generic dma-contiguous.h
In-Reply-To: <1405525892-60383-3-git-send-email-Zubair.Kakakhel@imgtec.com>
Organization: http://mina86.com/
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1405525892-60383-3-git-send-email-Zubair.Kakakhel@imgtec.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140716:linux-arch@vger.kernel.org::ikVP6ny+B0p2H+Jx:000000000000000000000000000000000000Imt
X-Hashcash: 1:20:140716:x86@kernel.org::hd9DW4HOvkjdXUdk:0000VgH
X-Hashcash: 1:20:140716:catalin.marinas@arm.com::kTka2XaB0MNLBUHc:000000000000000000000000000000000000002J/m
X-Hashcash: 1:20:140716:will.deacon@arm.com::KKl9z/ZEK9eJ1EjB:0000000000000000000000000000000000000000002qQR
X-Hashcash: 1:20:140716:gregkh@linuxfoundation.org::V66IRISnXsm3ps2j:0000000000000000000000000000000000038v+
X-Hashcash: 1:20:140716:mingo@redhat.com::B+eUlrjt/YNehRev:04T0w
X-Hashcash: 1:20:140716:linux-arm-kernel@lists.infradead.org::5GSPr4tmTPZ1KDD7:00000000000000000000000003/fJ
X-Hashcash: 1:20:140716:hpa@zytor.com::UipkHc6zjaJLQsKJ:00004w8I
X-Hashcash: 1:20:140716:zubair.kakakhel@imgtec.com::m7QTYUjfWQ9Krc/a:000000000000000000000000000000000005jjE
X-Hashcash: 1:20:140716:linux-kernel@vger.kernel.org::Qoa5HXm6jUHs03gv:0000000000000000000000000000000005D9O
X-Hashcash: 1:20:140716:arnd@arndb.de::gsl0oMCLybGcDUqu:00006WVF
X-Hashcash: 1:20:140716:ralf@linux-mips.org::9dzxX0rr0Sd144W9:0000000000000000000000000000000000000000005bP9
X-Hashcash: 1:20:140716:m.szyprowski@samsung.com::0PuRdwurMtIQH3kV:00000000000000000000000000000000000008i20
X-Hashcash: 1:20:140716:linux-mips@linux-mips.org::tBO2w++gCl0dO04R:000000000000000000000000000000000000Axhp
X-Hashcash: 1:20:140716:tglx@linutronix.de::AV74fn752xyxpQH9:0000000000000000000000000000000000000000000FKSy
Date: Wed, 16 Jul 2014 18:20:29 +0200
Message-ID: <xa1td2d5b7hu.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16 2014, Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com> wrote:
> dma-contiguous.h is now in asm-generic. Use that to avoid code
> repetition in arm64.
>
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  arch/arm64/include/asm/Kbuild           |  1 +
>  arch/arm64/include/asm/dma-contiguous.h | 28 ----------------------------
>  2 files changed, 1 insertion(+), 28 deletions(-)
>  delete mode 100644 arch/arm64/include/asm/dma-contiguous.h
>
> diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
> index 0b3fcf8..92bf7cb 100644
> --- a/arch/arm64/include/asm/Kbuild
> +++ b/arch/arm64/include/asm/Kbuild
> @@ -9,6 +9,7 @@ generic-y += current.h
>  generic-y += delay.h
>  generic-y += div64.h
>  generic-y += dma.h
> +generic-y += dma-contiguous.h
>  generic-y += emergency-restart.h
>  generic-y += early_ioremap.h
>  generic-y += errno.h
> diff --git a/arch/arm64/include/asm/dma-contiguous.h b/arch/arm64/include/asm/dma-contiguous.h
> deleted file mode 100644
> index 14c4c0c..0000000
> --- a/arch/arm64/include/asm/dma-contiguous.h
> +++ /dev/null
> @@ -1,28 +0,0 @@
> -/*
> - * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 and
> - * only version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef _ASM_DMA_CONTIGUOUS_H
> -#define _ASM_DMA_CONTIGUOUS_H
> -
> -#ifdef __KERNEL__
> -#ifdef CONFIG_DMA_CMA
> -
> -#include <linux/types.h>
> -
> -static inline void
> -dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
> -
> -#endif
> -#endif
> -
> -#endif
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
