Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3IUNii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 09:38:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39722 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3IUNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 09:38:37 -0400
Date: Sat, 21 Sep 2013 14:31:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130921133141.GL12758@n2100.arm.linux.org.uk>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com> <1379768716-11672-2-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379768716-11672-2-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 09:05:14PM +0800, Fan Rong wrote:
> @@ -0,0 +1,12 @@
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +        .section ".text.head", "ax"

Please use a tab instead of 8 spaces.

> +	__CPUINIT

__CPUINIT has been removed.

> +
> +ENTRY(sun7i_secondary_startup)
> +	msr	cpsr_fsxc, #0xd3
> +	mov r0, #0
> +	ldr r1, =0xffffffff

You don't  need to set r0 nor r1 here.

> +	b       secondary_startup
> +ENDPROC(sun7i_secondary_startup)
> diff --git a/arch/arm/mach-sunxi/platform.h b/arch/arm/mach-sunxi/platform.h
> new file mode 100644
> index 0000000..7e127c9
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/platform.h
> @@ -0,0 +1,347 @@
> +/*
> + * arch/arm/plat-sunxi/include/plat/platform.h
> + *
> + * (C) Copyright 2007-2012
> + * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> + * Benn Huang <benn@allwinnertech.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA

Just the first paragraph is sufficient.  Also are you sure you want the
"or any later version"?  The kernel is predominantly a GPLv2 only project.

What are the origins of this file - do you have the ability to change this?

> +	/* step3: clear power-off gating */
> +	pwr_reg = readl(sunxi7i_cc_base + AW_CPU1_PWROFF_REG);
> +	pwr_reg &= ~(1);

I think I've said this before.  The parens around '1' are not required.
What do you think you gain by having the additional parens?

> +	writel(pwr_reg, sunxi7i_cc_base + AW_CPU1_PWROFF_REG);
> +	mdelay(1);
> +
> +	/* step4: de-assert core reset */
> +	writel(3, sunxi7i_cc_base + CPUX_RESET_CTL(cpu));
> +
> +	/* step5: assert DBGPWRDUP signal */
> +	pwr_reg = readl(sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> +	pwr_reg |= (1<<cpu);

The parens around 1<<cpu are not required.  What do you think you gain
by having them?  Coding style also suggests placing a space before and
after the "<<" operation as well.  Again, I've said this in my previous
review.
