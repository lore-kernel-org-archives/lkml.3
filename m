Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaAFSw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:52:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35295 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093AbaAFSwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:52:12 -0500
Date: Mon, 6 Jan 2014 18:51:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20140106185139.GK1096@mudshark.cambridge.arm.com>
References: <1387725944-810-1-git-send-email-liuj97@gmail.com>
 <1387725944-810-7-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387725944-810-7-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 03:25:42PM +0000, Jiang Liu wrote:
> Optimize jump label implementation for ARM64 by dynamically patching
> kernel text.

Almost!

> diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
> new file mode 100644
> index 0000000..47cd130
> --- /dev/null
> +++ b/arch/arm64/include/asm/jump_label.h
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright (C) 2013 Huawei Ltd.
> + * Author: Jiang Liu <liuj97@gmail.com>
> + *
> + * Based on arch/arm/include/asm/jump_label.h
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
> +#ifndef _ASM_JUMP_LABEL_H
> +#define _ASM_JUMP_LABEL_H

It's actually prefixed with double-underscore in our other headers.

> +#include <linux/types.h>
> +
> +#ifdef __KERNEL__
> +
> +#define JUMP_LABEL_NOP_SIZE		4

I know you didn't like including asm/insn.h, but I don't see why that's such
a problem. Does it cause a circular dependency or something?

Will
