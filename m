Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3IUOBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 10:01:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50836 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946Ab3IUOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 10:01:11 -0400
Date: Sat, 21 Sep 2013 09:00:59 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.co,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130921140059.GA2779@lukather>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
 <1379768716-11672-2-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1379768716-11672-2-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fan,

On Sat, Sep 21, 2013 at 09:05:14PM +0800, Fan Rong wrote:
> Signed-off-by: Fan Rong <cinifr@gmail.com>

I'd prefer a more verbose commit log here, and for the following patches
as well.

Usually, you detail what you're doing in the commit "title", and the
rest of the commit log would be why you're doing so, the possible
consequences it might have (for example, in your architected timer
related patch, it would be great to have a mention that in order to use
it, you need to upgrade your bootloader, or it will fail to boot).

This will ensure to have a decent history, and we can easily get the
context of a given change.

> ---
>  arch/arm/mach-sunxi/Makefile   |   2 +
>  arch/arm/mach-sunxi/headsmp.S  |  12 ++
>  arch/arm/mach-sunxi/platform.h | 347 +++++++++++++++++++++++++++++++++++=
++++++
>  arch/arm/mach-sunxi/platsmp.c  | 100 ++++++++++++
>  arch/arm/mach-sunxi/sunxi.c    |  34 +++-
>  5 files changed, 494 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/mach-sunxi/headsmp.S
>  create mode 100644 arch/arm/mach-sunxi/platform.h
>  create mode 100644 arch/arm/mach-sunxi/platsmp.c
>=20
> diff --git a/arch/arm/mach-sunxi/Makefile b/arch/arm/mach-sunxi/Makefile
> index 93bebfc..d7f1ef4 100644
> --- a/arch/arm/mach-sunxi/Makefile
> +++ b/arch/arm/mach-sunxi/Makefile
> @@ -1 +1,3 @@
>  obj-$(CONFIG_ARCH_SUNXI) +=3D sunxi.o
> +obj-$(CONFIG_ARCH_SUNXI) +=3D platsmp.o
> +obj-$(CONFIG_ARCH_SUNXI) +=3D headsmp.o
> diff --git a/arch/arm/mach-sunxi/headsmp.S b/arch/arm/mach-sunxi/headsmp.S
> new file mode 100644
> index 0000000..b400602
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/headsmp.S
> @@ -0,0 +1,12 @@
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +        .section ".text.head", "ax"
> +	__CPUINIT
> +
> +ENTRY(sun7i_secondary_startup)
> +	msr	cpsr_fsxc, #0xd3
> +	mov r0, #0
> +	ldr r1, =3D0xffffffff

I don't think setting r0 and r1 is needed here.

> +	b       secondary_startup
> +ENDPROC(sun7i_secondary_startup)
> diff --git a/arch/arm/mach-sunxi/platform.h b/arch/arm/mach-sunxi/platfor=
m.h
> new file mode 100644
> index 0000000..7e127c9
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/platform.h
> @@ -0,0 +1,347 @@
> +/*
> + * arch/arm/plat-sunxi/include/plat/platform.h
> + *

Please remove this file. We don't need it at all.

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
> + */
> +extern struct smp_operations sunxi7i_smp_ops;
> +extern void __iomem *sunxi7i_cc_base;
> +void sun7i_secondary_startup(void);
> +
> +#ifndef __SW_PLATFORM_H
> +#define __SW_PLATFORM_H
> +
> +
> +
> +/* Physical Address */
> +#define SW_PA_BROM_START                  0xffff0000
> +#define SW_PA_BROM_END                    0xffff7fff   /* 32KB */
> +
> +#define SW_PA_SRAM_BASE                   0x00000000
> +
> +/* sun7i sram addresses */
> +#define SW_PA_SRAM_A1_BASE                0x00000000
> +#define SW_PA_SRAM_A2_BASE                0x00004000
> +#define SW_PA_SRAM_A3_BASE                0x00008000
> +#define SW_PA_SRAM_A4_BASE                0x0000b400
> +#define SW_PA_SRAM_D_BASE                 0x00010000
> +#define SW_PA_SRAM_B_BASE                 0x00020000
> +
> +#define SW_PA_SDRAM_START                 0x40000000
> +#define SW_PA_IO_BASE                     0x01c00000
> +#define SW_PA_SRAM_IO_BASE                0x01c00000   /* 4KB */
> +#define SW_PA_DRAM_IO_BASE                0x01c01000
> +#define SW_PA_DMAC_IO_BASE                0x01c02000
> +#define SW_PA_NANDFLASHC_IO_BASE          0x01c03000
> +#define SW_PA_TSI_IO_BASE                 0x01c04000
> +#define SW_PA_SPI0_IO_BASE                0x01c05000
> +#define SW_PA_SPI1_IO_BASE                0x01c06000
> +#define SW_PA_MSCC_IO_BASE                0x01c07000
> +#define SW_PA_TVD_IO_BASE                 0x01c08000
> +#define SW_PA_CSI0_IO_BASE                0x01c09000
> +#define SW_PA_TVE_IO_BASE                 0x01c0a000
> +#define SW_PA_EMAC_IO_BASE                0x01c0b000
> +#define SW_PA_TCON0_IO_BASE               0x01c0c000
> +#define SW_PA_TCON1_IO_BASE               0x01c0d000
> +#define SW_PA_VE_IO_BASE                  0x01c0e000
> +#define SW_PA_SDC0_IO_BASE                0x01c0f000
> +#define SW_PA_SDC1_IO_BASE                0x01c10000
> +#define SW_PA_SDC2_IO_BASE                0x01c11000
> +#define SW_PA_SDC3_IO_BASE                0x01c12000
> +#define SW_PA_USB0_IO_BASE                0x01c13000
> +#define SW_PA_USB1_IO_BASE                0x01c14000
> +#define SW_PA_SSE_IO_BASE                 0x01c15000
> +#define SW_PA_HDMI_IO_BASE                0x01c16000
> +#define SW_PA_SPI2_IO_BASE                0x01c17000
> +#define SW_PA_SATA_IO_BASE                0x01c18000
> +#define SW_PA_PATA_IO_BASE                0x01c19000
> +#define SW_PA_ACE_IO_BASE                 0x01c1a000
> +#define SW_PA_TVE1_IO_BASE                0x01c1b000
> +#define SW_PA_USB2_IO_BASE                0x01c1c000
> +#define SW_PA_CSI1_IO_BASE                0x01c1d000
> +#define SW_PA_TZASC_IO_BASE               0x01c1e000
> +#define SW_PA_SPI3_IO_BASE                0x01c1f000
> +#define SW_PA_CCM_IO_BASE                 0x01c20000
> +#define SW_PA_INT_IO_BASE                 0x01c20400
> +#define SW_PA_PORTC_IO_BASE               0x01c20800
> +#define SW_PA_TIMERC_IO_BASE              0x01c20c00
> +#define SW_PA_SPDIF_IO_BASE               0x01c21000
> +#define SW_PA_AC97_IO_BASE                0x01c21400
> +#define SW_PA_IR0_IO_BASE                 0x01c21800
> +#define SW_PA_IR1_IO_BASE                 0x01c21c00
> +#define SW_PA_IIS1_IO_BASE                0x01c22000
> +#define SW_PA_IIS_IO_BASE                 0x01c22400
> +#define SW_PA_LRADC_IO_BASE               0x01c22800
> +#define SW_PA_ADDA_IO_BASE                0x01c22c00
> +#define SW_PA_KEYPAD_IO_BASE              0x01c23000
> +#define SW_PA_TZPC_IO_BASE                0x01c23400
> +#define SW_PA_SID_IO_BASE                 0x01c23800
> +#define SW_PA_SJTAG_IO_BASE               0x01c23c00
> +#define SW_PA_IIS2_IO_BASE                0x01c24400
> +#define SW_PA_TP_IO_BASE                  0x01c25000
> +#define SW_PA_PMU_IO_BASE                 0x01c25400
> +#define SW_PA_CPUCFG_IO_BASE              0x01c25c00
> +#define SW_PA_UART0_IO_BASE               0x01c28000
> +#define SW_PA_UART1_IO_BASE               0x01c28400
> +#define SW_PA_UART2_IO_BASE               0x01c28800
> +#define SW_PA_UART3_IO_BASE               0x01c28c00
> +#define SW_PA_UART4_IO_BASE               0x01c29000
> +#define SW_PA_UART5_IO_BASE               0x01c29400
> +#define SW_PA_UART6_IO_BASE               0x01c29800
> +#define SW_PA_UART7_IO_BASE               0x01c29c00
> +#define SW_PA_PS20_IO_BASE                0x01c2a000
> +#define SW_PA_PS21_IO_BASE                0x01c2a400
> +#define SW_PA_TWI0_IO_BASE                0x01c2ac00
> +#define SW_PA_TWI1_IO_BASE                0x01c2b000
> +#define SW_PA_TWI2_IO_BASE                0x01c2b400
> +#define SW_PA_TWI3_IO_BASE                0x01c2b800
> +#define SW_PA_CAN0_IO_BASE                0x01c2bc00
> +#define SW_PA_CAN1_IO_BASE                0x01c2c000 /* sun4i */
> +#define SW_PA_TWI4_IO_BASE                0x01c2c000 /* sun7i */
> +#define SW_PA_SCR_IO_BASE                 0x01c2c400
> +#define SW_PA_GPS_IO_BASE                 0x01c30000
> +#define SW_PA_MALI_IO_BASE                0x01c40000
> +#define SW_PA_GMAC_IO_BASE                0x01c50000
> +#define SW_PA_HSTIMER_IO_BASE             0x01c60000
> +#define SW_PA_GIC_IO_BASE                 0x01c80000
> +#define SW_PA_GIC_DIST_IO_BASE            0x01c81000
> +#define SW_PA_GIC_CPU_IO_BASE             0x01c82000
> +#define SW_PA_SCU_IO_BASE                 0x01c80000
> +
> +#define SW_PA_TIMER_G_IO_BASE             0x01c80200
> +/* CPU global timer, not used */
> +
> +#define SW_PA_TIMER_P_IO_BASE             0x01c80600
> +/* CPU private timer, not used */
> +
> +#define SW_PA_HDMI1_IO_BASE               0x01ce0000
> +#define SW_PA_SRAM_C_IO_BASE              0x01d00000
> +#define SW_PA_DEFE0_IO_BASE               0x01e00000
> +#define SW_PA_DEFE1_IO_BASE               0x01e20000
> +#define SW_PA_DEBE0_IO_BASE               0x01e60000
> +#define SW_PA_DEBE1_IO_BASE               0x01e40000
> +#define SW_PA_MP_IO_BASE                  0x01e80000
> +#define SW_PA_AVG_IO_BASE                 0x01ea0000
> +#define SW_PA_CPUBIST_IO_BASE             0x3f501000
> +#define SW_PA_BROM_BASE                   0xffff0000
> +
> +/* Virtual Address */
> +#define SW_VA_SRAM_BASE                   0xf0000000	/*16KB*/
> +
> +/* sun7i sram addresses */
> +#define SW_VA_SRAM_A1_BASE                0xf0000000
> +#define SW_VA_SRAM_A2_BASE                0xf0004000
> +#define SW_VA_SRAM_A3_BASE                0xf0008000
> +#define SW_VA_SRAM_A4_BASE                0xf000b400
> +#define SW_VA_SRAM_D_BASE                 0xf0010000
> +#define SW_VA_SRAM_B_BASE                 0xf0020000
> +
> +#define SW_VA_BROM_BASE                   0xf0100000	/*64KB*/
> +#define SW_VA_BROM_START                  0xf0100000
> +#define SW_VA_BROM_END                    0xf0107fff
> +
> +#define SW_VA_IO_BASE                     0xf1c00000
> +#define SW_VA_SRAM_IO_BASE                0xf1c00000   /* 4KB */
> +#define SW_VA_DRAM_IO_BASE                0xf1c01000
> +#define SW_VA_DMAC_IO_BASE                0xf1c02000
> +#define SW_VA_NANDFLASHC_IO_BASE          0xf1c03000
> +#define SW_VA_TSI_IO_BASE                 0xf1c04000
> +#define SW_VA_SPI0_IO_BASE                0xf1c05000
> +#define SW_VA_SPI1_IO_BASE                0xf1c06000
> +#define SW_VA_MSCC_IO_BASE                0xf1c07000
> +#define SW_VA_TVD_IO_BASE                 0xf1c08000
> +#define SW_VA_CSI0_IO_BASE                0xf1c09000
> +#define SW_VA_TVE_IO_BASE                 0xf1c0a000
> +#define SW_VA_EMAC_IO_BASE                0xf1c0b000
> +#define SW_VA_TCON0_IO_BASE               0xf1c0c000
> +#define SW_VA_TCON1_IO_BASE               0xf1c0d000
> +#define SW_VA_VE_IO_BASE                  0xf1c0e000
> +#define SW_VA_SDC0_IO_BASE                0xf1c0f000
> +#define SW_VA_SDC1_IO_BASE                0xf1c10000
> +#define SW_VA_SDC2_IO_BASE                0xf1c11000
> +#define SW_VA_SDC3_IO_BASE                0xf1c12000
> +#define SW_VA_USB0_IO_BASE                0xf1c13000
> +#define SW_VA_USB1_IO_BASE                0xf1c14000
> +#define SW_VA_SSE_IO_BASE                 0xf1c15000
> +#define SW_VA_HDMI_IO_BASE                0xf1c16000
> +#define SW_VA_SPI2_IO_BASE                0xf1c17000
> +#define SW_VA_SATA_IO_BASE                0xf1c18000
> +#define SW_VA_PATA_IO_BASE                0xf1c19000
> +#define SW_VA_ACE_IO_BASE                 0xf1c1a000
> +#define SW_VA_TVE1_IO_BASE                0xf1c1b000
> +#define SW_VA_USB2_IO_BASE                0xf1c1c000
> +#define SW_VA_CSI1_IO_BASE                0xf1c1d000
> +#define SW_VA_TZASC_IO_BASE               0xf1c1e000
> +#define SW_VA_SPI3_IO_BASE                0xf1c1f000
> +#define SW_VA_CCM_IO_BASE                 0xf1c20000
> +#define SW_VA_INT_IO_BASE                 0xf1c20400
> +#define SW_VA_PORTC_IO_BASE               0xf1c20800
> +#define SW_VA_TIMERC_IO_BASE              0xf1c20c00
> +#define SW_VA_SPDIF_IO_BASE               0xf1c21000
> +#define SW_VA_AC97_IO_BASE                0xf1c21400
> +#define SW_VA_IR0_IO_BASE                 0xf1c21800
> +#define SW_VA_IR1_IO_BASE                 0xf1c21c00
> +#define SW_VA_IIS1_IO_BASE                0xf1c22000
> +#define SW_VA_IIS_IO_BASE                 0xf1c22400
> +#define SW_VA_LRADC_IO_BASE               0xf1c22800
> +#define SW_VA_ADDA_IO_BASE                0xf1c22c00
> +#define SW_VA_KEYPAD_IO_BASE              0xf1c23000
> +#define SW_VA_TZPC_IO_BASE                0xf1c23400
> +#define SW_VA_SID_IO_BASE                 0xf1c23800
> +#define SW_VA_SJTAG_IO_BASE               0xf1c23c00
> +#define SW_VA_IIS2_IO_BASE                0xf1c24400
> +#define SW_VA_TP_IO_BASE                  0xf1c25000
> +#define SW_VA_PMU_IO_BASE                 0xf1c25400
> +#define SW_VA_CPUCFG_IO_BASE              0xf1c25c00
> +#define SW_VA_UART0_IO_BASE               0xf1c28000
> +#define SW_VA_UART1_IO_BASE               0xf1c28400
> +#define SW_VA_UART2_IO_BASE               0xf1c28800
> +#define SW_VA_UART3_IO_BASE               0xf1c28c00
> +#define SW_VA_UART4_IO_BASE               0xf1c29000
> +#define SW_VA_UART5_IO_BASE               0xf1c29400
> +#define SW_VA_UART6_IO_BASE               0xf1c29800
> +#define SW_VA_UART7_IO_BASE               0xf1c29c00
> +#define SW_VA_PS20_IO_BASE                0xf1c2a000
> +#define SW_VA_PS21_IO_BASE                0xf1c2a400
> +#define SW_VA_TWI0_IO_BASE                0xf1c2ac00
> +#define SW_VA_TWI1_IO_BASE                0xf1c2b000
> +#define SW_VA_TWI2_IO_BASE                0xf1c2b400
> +#define SW_VA_TWI3_IO_BASE                0xf1c2b800
> +#define SW_VA_CAN0_IO_BASE                0xf1c2bc00
> +#define SW_VA_CAN1_IO_BASE                0xf1c2c000 /* sun4i */
> +#define SW_VA_TWI4_IO_BASE                0xf1c2c000 /* sun7i */
> +#define SW_VA_SCR_IO_BASE                 0xf1c2c400
> +#define SW_VA_GPS_IO_BASE                 0xf1c30000
> +#define SW_VA_MALI_IO_BASE                0xf1c40000
> +#define SW_VA_GMAC_IO_BASE                0xf1c50000
> +#define SW_VA_HSTIMER_IO_BASE             0xf1c60000
> +#define SW_VA_GIC_IO_BASE                 0xf1c80000
> +#define SW_VA_GIC_DIST_IO_BASE            0xf1c81000
> +#define SW_VA_GIC_CPU_IO_BASE             0xf1c82000
> +#define SW_VA_SCU_IO_BASE                 0xf1c80000
> +
> +#define SW_VA_TIMER_G_IO_BASE             0xf1c80200
> +/* CPU global timer, not used */
> +
> +#define SW_VA_TIMER_P_IO_BASE             0xf1c80600
> +/* CPU private timer, not used */
> +
> +#define SW_VA_HDMI1_IO_BASE               0xf1ce0000
> +#define SW_VA_SRAM_C_IO_BASE              0xf1d00000
> +#define SW_VA_DEFE0_IO_BASE               0xf1e00000
> +#define SW_VA_DEFE1_IO_BASE               0xf1e20000
> +#define SW_VA_DEBE0_IO_BASE               0xf1e60000
> +#define SW_VA_DEBE1_IO_BASE               0xf1e40000
> +#define SW_VA_MP_IO_BASE                  0xf1e80000
> +#define SW_VA_AVG_IO_BASE                 0xf1ea0000
> +
> +/* memory size */
> +#define SW_IO_SIZE                        0x00400000 /* 4MB(Max) */
> +#define SW_SRAM_A1_SIZE                   0x00004000 /* 16k */
> +#define SW_SRAM_A2_SIZE                   0x00004000 /* 16k */
> +#define SW_SRAM_A3_SIZE                   0x00003400 /* 13k */
> +#define SW_SRAM_A4_SIZE                   0x00000c00 /* 3k */
> +#define SW_SRAM_D_SIZE                    0x00001000 /* 4k */
> +#define SW_SRAM_B_SIZE                    0x00010000 /* 64k */
> +#define SW_BROM_SIZE                      0x00008000 /* 32k */
> +
> +/**
> + * Interrupt controller registers
> + *
> + */
> +#define SW_INT_VECTOR_REG                 (SW_VA_INT_IO_BASE + 0x00)
> +#define SW_INT_BASE_ADR_REG               (SW_VA_INT_IO_BASE + 0x04)
> +#define SW_INT_PROTECTION_REG             (SW_VA_INT_IO_BASE + 0x08)
> +#define SW_INT_NMI_CTRL_REG               (SW_VA_INT_IO_BASE + 0x0c)
> +#define SW_INT_IRQ_PENDING_REG0           (SW_VA_INT_IO_BASE + 0x10)
> +#define SW_INT_IRQ_PENDING_REG1           (SW_VA_INT_IO_BASE + 0x14)
> +#define SW_INT_IRQ_PENDING_REG2           (SW_VA_INT_IO_BASE + 0x18)
> +
> +#define SW_INT_FIQ_PENDING_REG0           (SW_VA_INT_IO_BASE + 0x20)
> +#define SW_INT_FIQ_PENDING_REG1           (SW_VA_INT_IO_BASE + 0x24)
> +#define SW_INT_FIQ_PENDING_REG2           (SW_VA_INT_IO_BASE + 0x28)
> +
> +#define SW_INT_SELECT_REG0                (SW_VA_INT_IO_BASE + 0x30)
> +#define SW_INT_SELECT_REG1                (SW_VA_INT_IO_BASE + 0x34)
> +#define SW_INT_SELECT_REG2                (SW_VA_INT_IO_BASE + 0x38)
> +
> +#define SW_INT_ENABLE_REG0                (SW_VA_INT_IO_BASE + 0x40)
> +#define SW_INT_ENABLE_REG1                (SW_VA_INT_IO_BASE + 0x44)
> +#define SW_INT_ENABLE_REG2                (SW_VA_INT_IO_BASE + 0x48)
> +
> +#define SW_INT_MASK_REG0                  (SW_VA_INT_IO_BASE + 0x50)
> +#define SW_INT_MASK_REG1                  (SW_VA_INT_IO_BASE + 0x54)
> +#define SW_INT_MASK_REG2                  (SW_VA_INT_IO_BASE + 0x58)
> +
> +#define SW_INT_RESP_REG0                  (SW_VA_INT_IO_BASE + 0x60)
> +#define SW_INT_RESP_REG1                  (SW_VA_INT_IO_BASE + 0x64)
> +#define SW_INT_RESP_REG2                  (SW_VA_INT_IO_BASE + 0x68)
> +
> +#define SW_INT_FASTFORCE_REG0             (SW_VA_INT_IO_BASE + 0x70)
> +#define SW_INT_FASTFORCE_REG1             (SW_VA_INT_IO_BASE + 0x74)
> +#define SW_INT_FASTFORCE_REG2             (SW_VA_INT_IO_BASE + 0x78)
> +
> +#define SW_INT_SRCPRIO_REG0               (SW_VA_INT_IO_BASE + 0x80)
> +#define SW_INT_SRCPRIO_REG1               (SW_VA_INT_IO_BASE + 0x84)
> +#define SW_INT_SRCPRIO_REG2               (SW_VA_INT_IO_BASE + 0x88)
> +#define SW_INT_SRCPRIO_REG3               (SW_VA_INT_IO_BASE + 0x8c)
> +#define SW_INT_SRCPRIO_REG4               (SW_VA_INT_IO_BASE + 0x90)
> +#ifdef CONFIG_ARCH_SUN5I
> +#define SW_INT_SRCPRIO_REG5               (SW_VA_INT_IO_BASE + 0x94)
> +#endif
> +
> +
> +#define PA_VIC_BASE                       0x01c20400
> +#define VA_VIC_BASE                       IO_ADDRESS(PA_VIC_BASE)
> +#define PIO_BASE                          SW_PA_PORTC_IO_BASE
> +
> +/**
> +*@name DRAM controller register address
> +*@{
> +*/
> +#define SW_DRAM_SDR_CTL_REG               (SW_VA_DRAM_IO_BASE + 0x0C)
> +#define SW_DRAM_SDR_DCR                   (SW_VA_DRAM_IO_BASE + 0x04)
> +
> +/*
> + * other reg defination, not found in spec
> + */
> +#define AW_GIC_DIST_BASE                  0x01c81000
> +#define AW_GIC_CPU_BASE                   0x01c82000
> +
> +#define AW_TIMER_G_BASE                   0x01c80200
> +/* CPU global timer, not used */
> +
> +#define AW_TIMER_P_BASE                   0x01c80600
> +/* CPU private timer, not used */
> +
> +/*
> + * CPUCFG
> + */
> +#define AW_CPUCFG_P_REG0            0x01a4
> +#define CPUX_RESET_CTL(x) (0x40 + (x)*0x40)
> +#define CPUX_CONTROL(x)   (0x44 + (x)*0x40)
> +#define CPUX_STATUS(x)    (0x48 + (x)*0x40)
> +#define AW_CPUCFG_GENCTL            0x0184
> +#define AW_CPUCFG_DBGCTL0           0x01e0
> +#define AW_CPUCFG_DBGCTL1           0x01e4
> +
> +#define AW_CPU1_PWR_CLAMP         0x01b0
> +#define AW_CPU1_PWROFF_REG        0x01b4

And move these definitions to platsmp.c.

I'd also like to have some mention that this is for sun7i only, so
naming the registers SUN7I_CPUCFG_* maybe? The A31 has a slightly
different SMP bringup mechanism, that we will need to support as well.

> +#endif
> diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
> new file mode 100644
> index 0000000..c76652d
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/platsmp.c
> @@ -0,0 +1,100 @@
> +/*
> + *  linux/arch/arm/mach-sun7i/platsmp.c

The path is wrong here. And you probably can remove it actually.

> + *
> + *  Copyright (C) 2012-2016 Allwinner Ltd.

The copyright years are wrong as well.

> + *  All Rights Reserved
> + *
> + * merge it to 3.11 by cini <cinifr@gmail.com>

Use your real name here. And I would probably add your name to the
copyright holders, just aside with allwinner.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/smp.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/jiffies.h>
> +#include <linux/smp.h>
> +
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
> +
> +#include <linux/irqchip/arm-gic.h>
> +#include <asm/mach-types.h>
> +#include <asm/smp_scu.h>
> +#include <asm/cacheflush.h>
> +#include <asm/smp_plat.h>
> +
> +#include "platform.h"
> +#include <asm/arch_timer.h>

There seem to be a lot of unused includes here. You seem to only be
needing linux/smp.h, linux/io.h and platform.h

> +
> +
> +/*
> + * for linux/arch/arm/kernel/smp.c:__cpu_up(..)
> + */
> +static int sunxi7i_boot_secondary(unsigned int cpu, struct task_struct *=
idle)

sun7i will be enough :)

> +{
> +	long paddr;
> +	u32 pwr_reg;
> +	if (!sunxi7i_cc_base) {
> +		pr_debug("error map cpu configure\n");
> +		return -ENOSYS;
> +	}
> +
> +	paddr =3D virt_to_phys(sun7i_secondary_startup);
> +	writel(paddr, sunxi7i_cc_base + AW_CPUCFG_P_REG0);
> +	/* step1: Assert nCOREPORESET LOW and hold L1RSTDISABLE LOW.
> +		Ensure DBGPWRDUP is held LOW to prevent any external
> +		debug access to the processor.
> +	*/
> +	/* assert cpu core reset */
> +	writel(0, sunxi7i_cc_base + CPUX_RESET_CTL(cpu));
> +	/* L1RSTDISABLE hold low */
> +	pwr_reg =3D readl(sunxi7i_cc_base + AW_CPUCFG_GENCTL);
> +	pwr_reg &=3D ~(1<<cpu);
> +	writel(pwr_reg, sunxi7i_cc_base + AW_CPUCFG_GENCTL);
> +	/* DBGPWRDUP hold low */
> +	pwr_reg =3D readl(sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> +	pwr_reg &=3D ~(1<<cpu);

Use BIT(cpu) here. And you should run scripts/checkpatch.pl on your
patches before sending them.

> +	writel(pwr_reg, sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> +
> +	/* step2: release power clamp */
> +	writel(0xff, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x7f, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x3f, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x1f, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x0f, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x07, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x03, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x01, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);
> +	writel(0x00, sunxi7i_cc_base + AW_CPU1_PWR_CLAMP);

You can probably turn it into a loop to simplify it.

> +	mdelay(10);

Ah, and you also need linux/delay.h

> +	/* step3: clear power-off gating */
> +	pwr_reg =3D readl(sunxi7i_cc_base + AW_CPU1_PWROFF_REG);
> +	pwr_reg &=3D ~(1);
> +	writel(pwr_reg, sunxi7i_cc_base + AW_CPU1_PWROFF_REG);
> +	mdelay(1);
> +
> +	/* step4: de-assert core reset */
> +	writel(3, sunxi7i_cc_base + CPUX_RESET_CTL(cpu));
> +
> +	/* step5: assert DBGPWRDUP signal */
> +	pwr_reg =3D readl(sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> +	pwr_reg |=3D (1<<cpu);
> +	writel(pwr_reg, sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> +	return 0;
> +}
> +
> +
> +

No need for the extra new lines here, one will be enough.

> +struct smp_operations sunxi7i_smp_ops __initdata =3D {
> +	.smp_boot_secondary	=3D sunxi7i_boot_secondary,
> +};
> +
> +

Ditto.

> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index e79fb34..88e7ecb 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -26,6 +26,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> =20
> +#include "platform.h"
> +
> +

Ditto.

>  #define SUN4I_WATCHDOG_CTRL_REG		0x00
>  #define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
>  #define SUN4I_WATCHDOG_MODE_REG		0x04
> @@ -42,6 +45,14 @@
>  #define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
> =20
>  static void __iomem *wdt_base;
> +/*
> + * CPU Configure module support
> + * 1: Software reset for smp cpus
> + * 2: Configure for smp cpus including boot.
> + * 3: Three 64-bit idle counters and two 64-bit common counters
> + * it is needed for smp cpus
> + */
> +void __iomem *sunxi7i_cc_base; /*CPU Configure Base*/
> =20
>  static void sun4i_restart(enum reboot_mode mode, const char *cmd)
>  {
> @@ -98,6 +109,11 @@ static struct of_device_id sunxi_restart_ids[] =3D {
>  	{ /*sentinel*/ }
>  };
> =20
> +static struct of_device_id sunxi_cc_ids[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-cpuconfig"},
> +	{ /*sentinel*/ }
> +};
> +
>  static void sunxi_setup_restart(void)
>  {
>  	const struct of_device_id *of_id;
> @@ -125,7 +141,6 @@ static void __init sunxi_timer_init(void)
>  static void __init sunxi_dt_init(void)
>  {
>  	sunxi_setup_restart();
> -

This is useless.

>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  }
> =20
> @@ -138,7 +153,24 @@ static const char * const sunxi_board_dt_compat[] =
=3D {
>  	NULL,
>  };
> =20
> +
> +static void __init sunxi_init_cpuconfig_map(void)
> +{
> +	struct device_node *np;
> +
> +	np =3D of_find_matching_node(NULL, sunxi_cc_ids);
> +	if (WARN(!np, "unable to setup cup configure"))
> +		return;
> +	sunxi7i_cc_base =3D of_iomap(np, 0);
> +	WARN(!sunxi7i_cc_base, "failed to map cup configure base address");
> +}
> +
> +
> +early_initcall(sunxi_init_cpuconfig_map);
> +
> +

I'm wondering, can't this go into the init_cpus SMP callback?

>  DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
> +	.smp	=3D smp_ops(sunxi7i_smp_ops),

Hmm, no, that won't work. The A31 will have different SMP ops.

As part of the work I started on the SMP, I created a new machine for
the A20.

Let me send the patch, and base your work on top of it.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSPaaaAAoJEBx+YmzsjxAgoJ8P/3aBr/iyw5IOvVaZXItF2jcG
+ZbQl9gKAAHXE4MZfYYNAY9y37dGbGTzu8jVwyA1dEgGE4UCWCaKzfn3QEAUl7GM
vMpTVoAz7CsKwCHzt0sC4FN7zSXAm3fJ9wVk4h2MxHvkkVWR+qTY/L1kh8+9vdHH
8VcQgT4Ybt22BuBi+DzcbgHD2AHM1DbhoEk06BKp14IAdhE9sqbfDE1oGLzDksEq
cMl0BtYCyIcVuMLjc6a+c7D1rziKN/zAvd93x31y+j05qibxoW5mNzFaNdPFX1DL
mChvIDuqAB3Pry22LsQ1yUvHrJBz/TbQEySNhwRiLinryNyenev2lKzD6xorlY2p
pLckyRhLlgXdigNnJtwD2oRB2RrD7tJOYG/DTv8a+4T9bp40ZKWzrC6cM/XhzemT
ZB7jZFpEmXSL5K3xpctDm4+Cv/1ExuOgQvAvRjGJ5/ob63t3qoMW1pjRCsZSy1wT
trzbAbXbu7jTes9SsToq0qEQFXjA3oDT2wqY43cjh4ybCzgAS3JSpaIskWz73dJ+
ktzB1cgnMb9EoPkXPzRuuHvRfrI+QRSiH0IDxJgAlSelsGhoUvpuwiD5YRmZbZ9o
RXtB9eSdRA9M4P8t+zbD3+E7jU67E1C/G08zDeOfYbXqgcWgPRMmkSa/bI6BvWrw
eHdyQwYXkJxkjxCC8ncG
=bkzz
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
