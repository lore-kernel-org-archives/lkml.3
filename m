Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3HFJPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:15:39 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:45122 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab3HFJPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:15:37 -0400
Message-ID: <1375780486.2725.7.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 06 Aug 2013 12:14:46 +0300
In-Reply-To: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: multipart/mixed; boundary="=-NwRlKioaeMfCTiOP8AFT"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NwRlKioaeMfCTiOP8AFT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2013-08-05 at 16:02 -0700, Rohit Vaswani wrote:
> This patch adds basic board support for MSM8974 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/boot/dts/Makefile        |  3 ++-
>  arch/arm/boot/dts/msm8974-db.dts  | 26 ++++++++++++++++++++++++++
>  arch/arm/mach-msm/Kconfig         | 21 ++++++++++++++++++---
>  arch/arm/mach-msm/Makefile        |  1 +
>  arch/arm/mach-msm/board-dt-8974.c | 23 +++++++++++++++++++++++
>  5 files changed, 70 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm/boot/dts/msm8974-db.dts
>  create mode 100644 arch/arm/mach-msm/board-dt-8974.c

Thanks. 

Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Attached patch enables earlyprink for this board.

[920] booting linux @ 0x8000, ramdisk @ 0x2000000 (1067699), tags/device tree @ 0x1e00000
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.11.0-rc4-00003-g7c8394e (iivanov@dev) (gcc version 4.6.3 (GCC) ) #502 SMP PREEMPT Tue Aug 6 12:09:07 EEST3
[    0.000000] CPU: ARMv7 Processor [512f06f0] revision 0 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine: Qualcomm MSM (Flattened Device Tree), model: Qualcomm MSM8974 Dragonboard
....


--=-NwRlKioaeMfCTiOP8AFT
Content-Disposition: attachment;
	filename="0001-msm-Add-low-level-debugging-via-MSM-8974-UART.patch"
Content-Type: text/x-patch;
	name="0001-msm-Add-low-level-debugging-via-MSM-8974-UART.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 7c8394ea8d926cc90c90c76aa48c5cee88f2f149 Mon Sep 17 00:00:00 2001
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Date: Wed, 5 Jun 2013 17:35:40 +0300
Subject: [PATCH] msm: Add low-level debugging via MSM 8974 UART

Enable low-level debug print routines to direct their
output to the serial port on MSM 8974 devices.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/Kconfig.debug                     |    8 ++++++++
 arch/arm/mach-msm/board-dt-8974.c          |    2 ++
 arch/arm/mach-msm/include/mach/msm_iomap.h |    4 ++++
 3 files changed, 14 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 583f4a0..4a8584f 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -323,6 +323,14 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the serial port on MSM 8960 devices.
 
+	config DEBUG_MSM8974_UART
+		bool "Kernel low-level debugging messages via MSM 8974 UART"
+		depends on ARCH_MSM8974
+		select MSM_HAS_DEBUG_UART_HS
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the serial port on MSM 8974 devices.
+
 	config DEBUG_MVEBU_UART
 		bool "Kernel low-level debugging messages via MVEBU UART (old bootloaders)"
 		depends on ARCH_MVEBU
diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
index 697623e..0ce016a 100644
--- a/arch/arm/mach-msm/board-dt-8974.c
+++ b/arch/arm/mach-msm/board-dt-8974.c
@@ -12,6 +12,7 @@
 
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
+#include <asm/mach/map.h>
 
 static const char * const msm8974_dt_match[] __initconst = {
 	"qcom,msm8974-db",
@@ -20,4 +21,5 @@ static const char * const msm8974_dt_match[] __initconst = {
 
 DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.dt_compat = msm8974_dt_match,
+	.map_io = debug_ll_io_init,
 MACHINE_END
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index c56e81f..7e08189 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -59,6 +59,10 @@
 #define MSM_DEBUG_UART_BASE	0xE1000000
 #define MSM_DEBUG_UART_PHYS	MSM_UART3_PHYS
 #endif
+#ifdef CONFIG_DEBUG_MSM8974_UART
+#define MSM_DEBUG_UART_BASE	0xfa71e000
+#define MSM_DEBUG_UART_PHYS	0xf991e000
+#endif
 
 /* Virtual addresses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
-- 
1.7.9.5


--=-NwRlKioaeMfCTiOP8AFT--

