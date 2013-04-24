Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab3DXKXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:23:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38490 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331Ab3DXKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:23:38 -0400
Date: Wed, 24 Apr 2013 11:23:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: compiling issue, need add include/asm/vga.h
 file
Message-ID: <20130424102327.GF21850@mudshark.cambridge.arm.com>
References: <5177551D.8090007@asianux.com>
 <20130424082237.GA23397@arm.com>
 <5177B1F0.10106@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177B1F0.10106@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:20:32AM +0100, Chen Gang wrote:
> 
> For compiling with allmodconfig, need vga.h file, so generate it which
> just only include the asm-generic one.
> 
> It is firstly used by drivers/gpu/drm/drm_irq.c.
> 
> The related error:
> include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/include/asm/vga.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm64/include/asm/vga.h
> 
> diff --git a/arch/arm64/include/asm/vga.h b/arch/arm64/include/asm/vga.h
> new file mode 100644
> index 0000000..1c49d51
> --- /dev/null
> +++ b/arch/arm64/include/asm/vga.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef ASMARM_VGA_H
> +#define ASMARM_VGA_H
> +
> +#include <asm-generic/vga.h>
> +
> +#endif /* ASMARM_VGA_H */

Can't you just add this as a generic-y entry in asm/Kbuild?

Will
