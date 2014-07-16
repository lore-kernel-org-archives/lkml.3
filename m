Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557AbaGPQVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:21:01 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33902 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965494AbaGPQUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:20:54 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        ralf@linux-mips.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com
Cc: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: use generic dma-contiguous.h
In-Reply-To: <1405525892-60383-4-git-send-email-Zubair.Kakakhel@imgtec.com>
Organization: http://mina86.com/
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1405525892-60383-4-git-send-email-Zubair.Kakakhel@imgtec.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140716:catalin.marinas@arm.com::Palh8q9qT3qX5tU3:0000000000000000000000000000000000000003UC
X-Hashcash: 1:20:140716:linux-arm-kernel@lists.infradead.org::+dGmSykDTGheinxh:00000000000000000000000000Ya3
X-Hashcash: 1:20:140716:mingo@redhat.com::covzxqOaiJfkY0nk:00Xrl
X-Hashcash: 1:20:140716:m.szyprowski@samsung.com::DcZqJ8ZwAuk5Tw3+:00000000000000000000000000000000000000tYO
X-Hashcash: 1:20:140716:ralf@linux-mips.org::nbpXSjE/oPHTJVv7:0000000000000000000000000000000000000000000uS2
X-Hashcash: 1:20:140716:linux-arch@vger.kernel.org::1lBj8CLMj90A/DDM:000000000000000000000000000000000001Od8
X-Hashcash: 1:20:140716:tglx@linutronix.de::MNccQdAtK9pP3xYB:00000000000000000000000000000000000000000001rU4
X-Hashcash: 1:20:140716:zubair.kakakhel@imgtec.com::1jumXx7o1a85FpWx:000000000000000000000000000000000002Yt/
X-Hashcash: 1:20:140716:linux-kernel@vger.kernel.org::2OeEnRiqBIRckkfU:0000000000000000000000000000000002W5q
X-Hashcash: 1:20:140716:gregkh@linuxfoundation.org::kAz30K0sdO+hRPkG:000000000000000000000000000000000002dAb
X-Hashcash: 1:20:140716:x86@kernel.org::lQeAaLaQskcKoivp:0004pW7
X-Hashcash: 1:20:140716:linux-mips@linux-mips.org::hus92bFhNzHWOCxG:0000000000000000000000000000000000005CLw
X-Hashcash: 1:20:140716:arnd@arndb.de::grdNF8pO7zOe+lH2:00007pjZ
X-Hashcash: 1:20:140716:will.deacon@arm.com::rNzoDB0KjD1CHh4k:00000000000000000000000000000000000000000081Tn
X-Hashcash: 1:20:140716:hpa@zytor.com::u+3EVN98WcdAoCU9:0000CZ3U
Date: Wed, 16 Jul 2014 18:20:49 +0200
Message-ID: <xa1ta989b7ha.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16 2014, Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com> wrote:
> dma-contiguous.h is now in asm-generic. Use that to avoid code
> repetition in x86.
>
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

But to be honest, I would fold the three into a single commit.

> ---
>  arch/x86/include/asm/Kbuild           |  1 +
>  arch/x86/include/asm/dma-contiguous.h | 12 ------------
>  2 files changed, 1 insertion(+), 12 deletions(-)
>  delete mode 100644 arch/x86/include/asm/dma-contiguous.h
>
> diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
> index 3bf000f..d55a210 100644
> --- a/arch/x86/include/asm/Kbuild
> +++ b/arch/x86/include/asm/Kbuild
> @@ -6,6 +6,7 @@ genhdr-y += unistd_x32.h
>  
>  generic-y += clkdev.h
>  generic-y += cputime.h
> +generic-y += dma-contiguous.h
>  generic-y += early_ioremap.h
>  generic-y += mcs_spinlock.h
>  generic-y += scatterlist.h
> diff --git a/arch/x86/include/asm/dma-contiguous.h b/arch/x86/include/asm/dma-contiguous.h
> deleted file mode 100644
> index b4b38ba..0000000
> --- a/arch/x86/include/asm/dma-contiguous.h
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -#ifndef ASMX86_DMA_CONTIGUOUS_H
> -#define ASMX86_DMA_CONTIGUOUS_H
> -
> -#ifdef __KERNEL__
> -
> -#include <linux/types.h>
> -
> -static inline void
> -dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
> -
> -#endif
> -#endif
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
