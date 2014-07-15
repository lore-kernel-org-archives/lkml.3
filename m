Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbaGOKWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:22:08 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50283 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479AbaGOKWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:22:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 22/29] nios2: Miscellaneous header files
Date: Tue, 15 Jul 2014 12:22:01 +0200
Message-ID: <4999408.jEEY9BVX9F@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405413956-2772-23-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-23-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vg2//13wfVXGi1J/TzC7tRj6y84usM8qtBR4Auivo9+
 2HwVUjcZIq1xfBtwB5qlxK2YwRHhD811xTSV5HwclQ3qdQsiGQ
 1hH7eLtCjZaaO615DoMq7QvBNA8942/hpsZ4mxNNayjRFDTOcw
 IK3FYsSMuI+uUEmrc9KIRuHnI4LYpaVGDqh3B97xjt841Iaxoq
 tEI6M653VUKeuIk9nEP9wN4TJu20T8SO0wRmBWRAnOltGT75ht
 YUjouWndfxF0l/jlhCwydP5c6nUFZrcaS1I0zzyIHB3C7ZJMU9
 MDN70SdmIxrQvlSRj/AeWEMsS7HSHhQ3ib8G/cgl1zz4BJDvWU
 1twy/b4FHa4S7fjvtBu0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 16:45:49 Ley Foon Tan wrote:
> diff --git a/arch/nios2/include/asm/gpio.h b/arch/nios2/include/asm/gpio.h
> new file mode 100644
> index 0000000..e726bfc
> --- /dev/null
> +++ b/arch/nios2/include/asm/gpio.h
> @@ -0,0 +1,23 @@
> +/*
> + * Copyright (C) 2013 Altera Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#ifndef _ASM_NIOS2_GPIO_H
> +#define _ASM_NIOS2_GPIO_H
> +
> +#include <linux/gpio.h>
> +
> +#endif /* _ASM_NIOS2_GPIO_H */

This seems wrong. If any device drivers rely on this, better fix them to
use linux/gpio.h directly.

> diff --git a/arch/nios2/include/asm/pci.h b/arch/nios2/include/asm/pci.h
> new file mode 100644
> index 0000000..69c86fa
> --- /dev/null
> +++ b/arch/nios2/include/asm/pci.h
> @@ -0,0 +1,25 @@
> +/*
> + *  Copyright (C) 2013 Altera Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +
> +#ifndef __ASM_NIOS2_PCI_H__
> +#define __ASM_NIOS2_PCI_H__
> +
> +/* We don't support PCI yet, but some drivers require this file anyway */
> +
> +#endif /* __ASM_NIOS2_PCI_H__ */

What's wrong with the generic version?

> +#ifndef _UAPI_ASM_NIOS2_STAT_H
> +#define _UAPI_ASM_NIOS2_STAT_H
> +
> +#include <asm-generic/stat.h>
> +
> +#endif

This should just use the Kconfig logic to fall back on the generic file.


> +
> +#ifndef _UAPI_ASM_NIOS2_STATFS_H
> +#define _UAPI_ASM_NIOS2_STATFS_H
> +
> +#define __statfs_word __s32

Why this? Every other architecture except parisc uses the default __u32 here.

> +#include <linux/types.h>
> +#include <asm-generic/swab.h>
> +
> +#ifdef CONFIG_NIOS2_CI_SWAB_SUPPORT
> +#ifdef __GNUC__
> +
> +#define __nios2_swab(x)		\
> +	__builtin_custom_ini(CONFIG_NIOS2_CI_SWAB_NO, (x))
> +
> +static inline __attribute__((const)) __u16 __arch_swab16(__u16 x)
> +{
> +	return (__u16) __nios2_swab(((__u32) x) << 16);
> +}

Is this actually better than ___constant_swab16()?

Also, have you checked if you need to support old compiler versions that
don't have __builtin_bswap16/32/64? With newer compilers you don't need
to define any of these yourself.

	Arnd
