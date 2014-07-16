Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbaGPQU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:20:29 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39635 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934713AbaGPQUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:20:22 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        ralf@linux-mips.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com
Cc: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/4] asm-generic: Add dma-contiguous.h
In-Reply-To: <1405525892-60383-2-git-send-email-Zubair.Kakakhel@imgtec.com>
Organization: http://mina86.com/
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1405525892-60383-2-git-send-email-Zubair.Kakakhel@imgtec.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140716:will.deacon@arm.com::XPUAp+4K1E9Gkjh8:0000000000000000000000000000000000000000001G3S
X-Hashcash: 1:20:140716:linux-arch@vger.kernel.org::nyC4dyXpioKy3rB7:000000000000000000000000000000000001Jnx
X-Hashcash: 1:20:140716:linux-arm-kernel@lists.infradead.org::TldaW93tH9z1vGC5:00000000000000000000000001kQT
X-Hashcash: 1:20:140716:ralf@linux-mips.org::aGvLYwjYA5sBHnj/:0000000000000000000000000000000000000000001hN+
X-Hashcash: 1:20:140716:linux-kernel@vger.kernel.org::YNisK1HA7JD4USYt:0000000000000000000000000000000002Ph3
X-Hashcash: 1:20:140716:mingo@redhat.com::StDnTQ3fjT3StROd:02XA0
X-Hashcash: 1:20:140716:tglx@linutronix.de::w/eAbXKkZ7QdCh8w:00000000000000000000000000000000000000000002TOD
X-Hashcash: 1:20:140716:linux-mips@linux-mips.org::6aKre8QJ2686EjuY:0000000000000000000000000000000000002/DY
X-Hashcash: 1:20:140716:arnd@arndb.de::m1bIi/Wb9KwALOCM:00003gvU
X-Hashcash: 1:20:140716:hpa@zytor.com::TqGpoq2bVNLA4+wv:00004zkD
X-Hashcash: 1:20:140716:x86@kernel.org::0U+mq/DWLWWkb5aA:0004Beh
X-Hashcash: 1:20:140716:gregkh@linuxfoundation.org::ElKeu3M9nB2UdwN9:000000000000000000000000000000000005cUj
X-Hashcash: 1:20:140716:catalin.marinas@arm.com::t2FyeWMkAUrGilAi:000000000000000000000000000000000000005NPc
X-Hashcash: 1:20:140716:zubair.kakakhel@imgtec.com::gZWMt3d348Bmg+vs:000000000000000000000000000000000005xff
Date: Wed, 16 Jul 2014 18:20:15 +0200
Message-ID: <xa1tfvi1b7i8.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16 2014, Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com> wrote:
> This header is used by arm64 and x86 individually.
>
> Adding to asm-generic to avoid further code repetition while adding cma
> to mips.
>
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>


> ---
>  include/asm-generic/dma-contiguous.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644 include/asm-generic/dma-contiguous.h
>
> diff --git a/include/asm-generic/dma-contiguous.h b/include/asm-generic/dma-contiguous.h
> new file mode 100644
> index 0000000..292c571
> --- /dev/null
> +++ b/include/asm-generic/dma-contiguous.h
> @@ -0,0 +1,9 @@
> +#ifndef _ASM_GENERIC_DMA_CONTIGUOUS_H
> +#define _ASM_GENERIC_DMA_CONTIGUOUS_H
> +
> +#include <linux/types.h>
> +
> +static inline void
> +dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
> +
> +#endif
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
