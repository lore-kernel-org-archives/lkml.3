Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaDVMjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:39:19 -0400
Received: from sym2.noone.org ([178.63.92.236]:57504 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaDVMjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:39:15 -0400
Date: Tue, 22 Apr 2014 14:39:14 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 23/28] nios2: Nios2 registers
Message-ID: <20140422123914.GB1053@distanz.ch>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-20-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397824031-4892-20-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-18 at 14:27:06 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> This file contains constants for the instruction macros, cpu registers, fields and bits.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  arch/nios2/include/asm/registers.h | 65 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 arch/nios2/include/asm/registers.h
> 
> diff --git a/arch/nios2/include/asm/registers.h b/arch/nios2/include/asm/registers.h
> new file mode 100644
> index 0000000..0e6ffef08b20e072480ca3780e2626eb3f1de2bd
> --- /dev/null
> +++ b/arch/nios2/include/asm/registers.h
> @@ -0,0 +1,65 @@
> +/*
> + * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
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
> +#ifndef _ASM_NIOS2_REGISTERS_H
> +#define _ASM_NIOS2_REGISTERS_H
> +
> +/* control register numbers */
> +#define CTL_STATUS	0
> +#define CTL_ESTATUS	1
> +#define CTL_BSTATUS	2
> +#define CTL_IENABLE	3
> +#define CTL_IPENDING	4
> +#define CTL_CPUID	5
> +#define CTL_RSV1	6
> +#define CTL_EXCEPTION	7
> +#define CTL_PTEADDR	8
> +#define CTL_TLBACC	9
> +#define CTL_TLBMISC	10
> +#define CTL_RSV2	11
> +#define CTL_BADADDR	12
> +#define CTL_CONFIG	13
> +#define CTL_MPUBASE	14
> +#define CTL_MPUACC	15
> +
> +/* access control registers using GCC builtins */
> +#define RDCTL(r)	__builtin_rdctl(r)
> +#define WRCTL(r, v)	__builtin_wrctl(r, v)
> +
> +/* status register bits */
> +#define STATUS_PIE	(1 << 0)	/* processor interrupt enable */
> +#define STATUS_U	(1 << 1)	/* user mode */
> +#define STATUS_EH	(1 << 2)	/* Exception mode */
> +
> +/* estatus register bits */
> +#define ESTATUS_EPIE	(1 << 0)	/* processor interrupt enable */
> +#define ESTATUS_EU	(1 << 1)	/* user mode */
> +#define ESTATUS_EH	(1 << 2)	/* Exception mode */
> +
> +/* tlbmisc register bits */
> +#define TLBMISC_PID_SHIFT	4
> +#define TLBMISC_PID_MASK	((1UL << cpuinfo.tlb_pid_num_bits) - 1)

You should probably #include <asm/cpuinfo.h> here since struct cpuinfo
is used in the definition.

> +#define TLBMISC_WAY_MASK	0xf
> +#define TLBMISC_WAY_SHIFT	20
> +
> +#define TLBMISC_PID	(TLBMISC_PID_MASK << TLBMISC_PID_SHIFT)	/* TLB PID */
> +#define TLBMISC_WE	(1 << 18)	/* TLB write enable */
> +#define TLBMISC_RD	(1 << 19)	/* TLB read */
> +#define TLBMISC_WAY	(TLBMISC_WAY_MASK << TLBMISC_WAY_SHIFT) /* TLB way */
> +
> +#endif /* _ASM_NIOS2_REGISTERS_H */
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
