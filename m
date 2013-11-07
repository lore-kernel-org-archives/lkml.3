Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab3KGFpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:45:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46290 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab3KGFpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:45:19 -0500
Date: Thu, 7 Nov 2013 13:40:33 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 9/9] ARM: add initial support for Marvell Berlin SoCs
Message-ID: <20131107134033.59bd127a@xhacker>
In-Reply-To: <1383661723-17956-10-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1383661723-17956-10-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_02:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian,

On Tue, 5 Nov 2013 06:28:43 -0800
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> This adds initial support for the Marvell Berlin SoC family with
> Armada 1500 (88DE3100) and Armada 1500-mini (88DE3005) SoCs.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changelog:
> v2->v3:
> - add Armada 1500-mini (BG2CD) Kconfig
> v1->v2:
> - replace 88DE3xxx numbering with SoC variant name
>   (Requested by Jisheng Zhang)
> - remove LOCAL_TIMERS dependency (Suggested by Dinh Nguyen)
> RFCv2->v1:
> - remove custom .init_time, adds dependency for arch-wide of_clk_init call
> RFCv1->RFCv2:
> - nuke .map_io (Reported by Arnd Bergmann)
> - add copyright reference
> - switch to mach-berlin instead of mach-mvebu
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Kevin Hilman <khilman@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/Kconfig              |    2 ++
>  arch/arm/Makefile             |    1 +
>  arch/arm/mach-berlin/Kconfig  |   30 ++++++++++++++++++++++++++++++
>  arch/arm/mach-berlin/Makefile |    1 +
>  arch/arm/mach-berlin/berlin.c |   39
> +++++++++++++++++++++++++++++++++++++++ 5 files changed, 73 insertions(+)
>  create mode 100644 arch/arm/mach-berlin/Kconfig
>  create mode 100644 arch/arm/mach-berlin/Makefile
>  create mode 100644 arch/arm/mach-berlin/berlin.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1ad6fb6..5692426 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -932,6 +932,8 @@ source "arch/arm/mach-bcm/Kconfig"
>  
>  source "arch/arm/mach-bcm2835/Kconfig"
>  
> +source "arch/arm/mach-berlin/Kconfig"
> +
>  source "arch/arm/mach-clps711x/Kconfig"
>  
>  source "arch/arm/mach-cns3xxx/Kconfig"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index db50b62..07258c7 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -147,6 +147,7 @@ textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
>  machine-$(CONFIG_ARCH_AT91)		+= at91
>  machine-$(CONFIG_ARCH_BCM)		+= bcm
>  machine-$(CONFIG_ARCH_BCM2835)		+= bcm2835
> +machine-$(CONFIG_ARCH_BERLIN)		+= berlin
>  machine-$(CONFIG_ARCH_CLPS711X)		+= clps711x
>  machine-$(CONFIG_ARCH_CNS3XXX)		+= cns3xxx
>  machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> new file mode 100644
> index 0000000..c5b39b1
> --- /dev/null
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -0,0 +1,30 @@
> +config ARCH_BERLIN
> +	bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
> +	select GENERIC_CLOCKEVENTS
> +	select GENERIC_IRQ_CHIP
> +	select COMMON_CLK
> +	select DW_APB_ICTL
> +	select DW_APB_TIMER_OF
> +
> +if ARCH_BERLIN
> +
> +menu "Marvell Berlin SoC variants"
> +
> +config MACH_BERLIN_BG2
> +	bool "Marvell Armada 1500 (BG2)"
> +	select ARM_GIC
ARM_GIC is common on berlin SoCs. we can put it below ARCH_BERLIN?
> +	select CACHE_L2X0
ditto
> +	select CPU_PJ4B
> +	select HAVE_ARM_TWD
> +	select HAVE_SMP
> +
> +config MACH_BERLIN_BG2CD
> +	bool "Marvell Armada 1500-mini (BG2CD)"
> +	select ARM_GIC
> +	select CACHE_L2X0
> +	select CPU_V7
> +	select HAVE_ARM_TWD
BG2CD is single core, I'm not sure it have twd. I will check with SoC people.
But can twd be really used in single CA9 system?
> +
> +endmenu
> +
> +endif
> diff --git a/arch/arm/mach-berlin/Makefile b/arch/arm/mach-berlin/Makefile
> new file mode 100644
> index 0000000..ab69fe9
> --- /dev/null
> +++ b/arch/arm/mach-berlin/Makefile
> @@ -0,0 +1 @@
> +obj-y += berlin.o
> diff --git a/arch/arm/mach-berlin/berlin.c b/arch/arm/mach-berlin/berlin.c
> new file mode 100644
> index 0000000..16c2942
> --- /dev/null
> +++ b/arch/arm/mach-berlin/berlin.c
> @@ -0,0 +1,39 @@
> +/*
> + * Device Tree support for Marvell Berlin SoCs.
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * based on GPL'ed 2.6 kernel sources
> + *  (c) Marvell International Ltd.
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/of_platform.h>
> +#include <asm/hardware/cache-l2x0.h>
> +#include <asm/mach/arch.h>
> +
> +static void __init berlin_init_machine(void)
> +{
> +	/*
> +	 * with DT probing for L2CCs, berlin_init_machine can be removed.
> +	 * Note: 88DE3005 (Armada 1500-mini) uses pl310 l2cc
> +	 */
> +	l2x0_of_init(0x70c00000, 0xfeffffff);
Per my experience, put l2x0 initialization in init_machine is too late. It
did cause some boot stability problems during our product massive bootup test.
In our internal 3.10.y tree, we put it in init_early, I also suggest we do
this too in mainline.
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
If l2 initialization is put in init_early, this is not needed any more.
> +}
> +
> +static const char * const berlin_dt_compat[] = {
> +	"marvell,berlin",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(BERLIN_DT, "Marvell Berlin")
> +	.dt_compat      = berlin_dt_compat,
> +	.init_machine   = berlin_init_machine,
> +MACHINE_END

