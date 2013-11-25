Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3KYJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:09:27 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:59717 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3KYJJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:09:23 -0500
Date: Mon, 25 Nov 2013 10:09:22 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 14/24] avr32: Use Kbuild logic to provide <asm/types.h>
Message-ID: <20131125090922.GB13358@samfundet.no>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
 <1385369734-24893-15-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385369734-24893-15-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 25 Nov 2013 09:55:24 +0100 or thereabout, Geert Uytterhoeven wrote:
> The extra definition for BITS_PER_LONG is also indirectly provided
> by <asm-generic/types.h>, via <asm-generic/int-ll64.h> and
> <asm/bitsperlong.h>

Are you adding a new include/asm-generic/types.h, which will include
bitsperlong.h ?

If so, nice cleaning, and you have my

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/Kbuild  |    1 +
>  arch/avr32/include/asm/types.h |   19 -------------------
>  2 files changed, 1 insertion(+), 19 deletions(-)
>  delete mode 100644 arch/avr32/include/asm/types.h
> 
> diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
> index 658001b52400..129f4ff68066 100644
> --- a/arch/avr32/include/asm/Kbuild
> +++ b/arch/avr32/include/asm/Kbuild
> @@ -17,4 +17,5 @@ generic-y       += scatterlist.h
>  generic-y       += sections.h
>  generic-y       += topology.h
>  generic-y	+= trace_clock.h
> +generic-y	+= types.h
>  generic-y       += xor.h
> diff --git a/arch/avr32/include/asm/types.h b/arch/avr32/include/asm/types.h
> deleted file mode 100644
> index 59324058069c..000000000000
> --- a/arch/avr32/include/asm/types.h
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -/*
> - * Copyright (C) 2004-2006 Atmel Corporation
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -#ifndef __ASM_AVR32_TYPES_H
> -#define __ASM_AVR32_TYPES_H
> -
> -#include <uapi/asm/types.h>
> -
> -/*
> - * These aren't exported outside the kernel to avoid name space clashes
> - */
> -
> -#define BITS_PER_LONG 32
> -
> -#endif /* __ASM_AVR32_TYPES_H */
-- 
mvh
Hans-Christian Egtvedt
