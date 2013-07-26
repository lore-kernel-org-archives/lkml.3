Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab3GZPow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:44:52 -0400
Received: from 14.mo5.mail-out.ovh.net ([188.165.51.82]:33329 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757340Ab3GZPos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:44:48 -0400
Message-ID: <51F2996B.6000406@overkiz.com>
Date: Fri, 26 Jul 2013 17:44:43 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 00/42] ARM: at91: move to common clk framework
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com> <51F28370.6050304@gmail.com>
In-Reply-To: <51F28370.6050304@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040702020707040703050806"
X-Ovh-Tracer-Id: 11050707586986309797
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrgeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrgeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040702020707040703050806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 26/07/2013 16:10, Richard Genoud wrote:
> On 17/07/2013 15:34, Boris BREZILLON wrote:
>> Hello,
>>
>> This patch series is a proposal to move at91 clock implementation
>> to common clk framework.
>>
>> Most of the clock provided by the PMC (Power Management Controller) are
>> implemented :
>> - main clock (main oscillator)
>> - pll clocks
>> - master clock
>> - programmable clocks
>> - utmi clock
>> - peripheral clocks
>> - system clocks
>>
>> This implementation is compatible with device tree: the goal is
>> to define the whole clock tree in the device tree (all currently
>> available dt SoCs and boards are patched to support dt clocks).
>> Please feel free to comment the dt bindinds.
>>
>> I removed the register_clocks function in SoC supporting dt boards only:
>> - at91sam9x5 SoCs
>> - at91sam9n12 SoC
>> - sama5d3 SoCs
>>
>> This patch series is based on linux-next and has been tested on sama5d31ek
>> board using device tree. It compiles for other SoCs and both with and without
>> dt support, but it has not been tested.
>>
>> BTW could other people test it on other boards (I only have a kizbox and
>> a sama5d31ek dev kit).
>>
>> Best Regards,
>> Boris
>>
>> Changes since v1:
>>   - fix bugs in pll, programmable and system clock implementations
>>     (wrong bit position).
>>   - add usb clock configuration support (ohci and udc drivers +
>>     clk_lookup for non dt boards)
>>   - rework of the system clock interfaces (no need to define a parent clock,
>>     system clock is a gate with no rate info)
>>   - change system, peripheral and programmable clk dt bindings (1 master node
>>     and multiple child nodes each defining a system/peripheral or prog clock)
>>   - fix bugs in sama5 dt definition
>>
> Hi Boris,
>
> First of all: Big thumbs up for this work !
>
> Then, I tested the serie on at91sam9g35ek (sam9x5 familly), and I see some problems:
> kernel is next-20130725 with the v4 serie of "ARM: at91: prepare transition to common clk framework"
> and v2 serie of "ARM: at91: move to common clk framework"
>
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 3.11.0-rc2-next-20130725+ (rgenoud@lnx-rg) (gcc version 4.7.3 (Buildroot 2013.05-00157-g6d1e60b-dirty) ) #61 Fri Jul 26 15:30:13 CEST 2013
> [    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
> [    0.000000] CPU: VIVT data cache, VIVT instruction cache
> [    0.000000] Machine: Atmel AT91SAM (Device Tree), model: Atmel AT91SAM9G35-EK
> [    0.000000] bootconsole [earlycon0] enabled
> [    0.000000] Memory policy: ECC disabled, Data cache writeback
> [    0.000000] AT91: Detected soc type: at91sam9x5
> [    0.000000] AT91: Detected soc subtype: at91sam9g35
> [    0.000000] AT91: sram at 0x300000 of 0x8000 mapped at 0xfef70000
> [    0.000000] On node 0 totalpages: 32768
> [    0.000000] free_area_init_node: node 0, pgdat c039d208, node_mem_map c03b5000
> [    0.000000]   Normal zone: 256 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 32768 pages, LIFO batch:7
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
> [    0.000000] Kernel command line: console=ttyS0,115200 loglevel=8 ip=dhcp root=/dev/nfs nfsroot=10.128.0.9:/nfsroot,v3 rw earlyprintk
> [    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
> [    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.000000] Memory: 126044K/131072K available (2804K kernel code, 126K rwdata, 592K rodata, 141K init, 93K bss, 5028K reserved)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
> [    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
> [    0.000000]     vmalloc : 0xc8800000 - 0xff000000   ( 872 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
> [    0.000000]       .text : 0xc0008000 - 0xc0359550   (3398 kB)
> [    0.000000]       .init : 0xc035a000 - 0xc037d61c   ( 142 kB)
> [    0.000000]       .data : 0xc037e000 - 0xc039d920   ( 127 kB)
> [    0.000000]        .bss : 0xc039d920 - 0xc03b4ff4   (  94 kB)
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] AT91: PIT: mck rate = 0
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm/mach-at91/at91sam926x_time.c:259 at91sam926x_pit_init+0x114/0x234()
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0-rc2-next-20130725+ #61
> [    0.000000] [<c000ca18>] (unwind_backtrace+0x0/0xe0) from [<c000b0f0>] (show_stack+0x10/0x14)
> [    0.000000] [<c000b0f0>] (show_stack+0x10/0x14) from [<c00144e0>] (warn_slowpath_common+0x5c/0x7c)
> [    0.000000] [<c00144e0>] (warn_slowpath_common+0x5c/0x7c) from [<c00145b8>] (warn_slowpath_null+0x18/0x1c)
> [    0.000000] [<c00145b8>] (warn_slowpath_null+0x18/0x1c) from [<c03607b0>] (at91sam926x_pit_init+0x114/0x234)
> [    0.000000] [<c03607b0>] (at91sam926x_pit_init+0x114/0x234) from [<c035ca4c>] (time_init+0x1c/0x24)
> [    0.000000] [<c035ca4c>] (time_init+0x1c/0x24) from [<c035a650>] (start_kernel+0x19c/0x2f4)
> [    0.000000] [<c035a650>] (start_kernel+0x19c/0x2f4) from [<20008040>] (0x20008040)
> [    0.000000] ---[ end trace 1b75b31a2719ed1c ]---
> [    0.000000] Division by zero in kernel.
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W    3.11.0-rc2-next-20130725+ #61
> [    0.000000] [<c000ca18>] (unwind_backtrace+0x0/0xe0) from [<c000b0f0>] (show_stack+0x10/0x14)
> [    0.000000] [<c000b0f0>] (show_stack+0x10/0x14) from [<c013f0a0>] (Ldiv0_64+0x8/0x18)
> [    0.000000] [<c013f0a0>] (Ldiv0_64+0x8/0x18) from [<c003b864>] (__clocksource_updatefreq_scale+0x30/0x104)
> [    0.000000] [<c003b864>] (__clocksource_updatefreq_scale+0x30/0x104) from [<c003b944>] (__clocksource_register_scale+0xc/0x48)
> [    0.000000] [<c003b944>] (__clocksource_register_scale+0xc/0x48) from [<c0360810>] (at91sam926x_pit_init+0x174/0x234)
> [    0.000000] [<c0360810>] (at91sam926x_pit_init+0x174/0x234) from [<c035ca4c>] (time_init+0x1c/0x24)
> [    0.000000] [<c035ca4c>] (time_init+0x1c/0x24) from [<c035a650>] (start_kernel+0x19c/0x2f4)
> [    0.000000] [<c035a650>] (start_kernel+0x19c/0x2f4) from [<20008040>] (0x20008040)
> [    0.000000] Division by zero in kernel.
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W    3.11.0-rc2-next-20130725+ #61
> [    0.000000] [<c000ca18>] (unwind_backtrace+0x0/0xe0) from [<c000b0f0>] (show_stack+0x10/0x14)
> [    0.000000] [<c000b0f0>] (show_stack+0x10/0x14) from [<c013f0a0>] (Ldiv0_64+0x8/0x18)
> [    0.000000] [<c013f0a0>] (Ldiv0_64+0x8/0x18) from [<c003b76c>] (clocks_calc_mult_shift+0x70/0xa4)
> [    0.000000] [<c003b76c>] (clocks_calc_mult_shift+0x70/0xa4) from [<c003b8e4>] (__clocksource_updatefreq_scale+0xb0/0x104)
> [    0.000000] [<c003b8e4>] (__clocksource_updatefreq_scale+0xb0/0x104) from [<c003b944>] (__clocksource_register_scale+0xc/0x48)
> [    0.000000] [<c003b944>] (__clocksource_register_scale+0xc/0x48) from [<c0360810>] (at91sam926x_pit_init+0x174/0x234)
> [    0.000000] [<c0360810>] (at91sam926x_pit_init+0x174/0x234) from [<c035ca4c>] (time_init+0x1c/0x24)
> [    0.000000] [<c035ca4c>] (time_init+0x1c/0x24) from [<c035a650>] (start_kernel+0x19c/0x2f4)
> [    0.000000] [<c035a650>] (start_kernel+0x19c/0x2f4) from [<20008040>] (0x20008040)
> [...]
>
> Best regards,
> Richard
Hi Richard,

First, I'd like to thank you for your tests.

Regarding your problem, it seems that mck rate is calculated as 0, which 
is either a bug in recalc_rate callback
of master clock driver or a bug in master clock parent clk (no parent 
found or bug in the current parent clk recalc_rate function).

I checked the dts[i] files and I found a missing clock-frequency 
property for main clock of some
at91sam9x5 boards (those including at91sam9x5cm.dtsi).

You'll find a patch adding this property in attachments.
Tell me if this works for you. If not I'll make a patch adding pr_info 
to trace the bug.

Anyway, it should work without this property (main clock rate can be 
computed using slow clock rate and MCFR register).
I will investigate this bug...

Best Regards,
Boris


--------------040702020707040703050806
Content-Type: text/x-patch;
 name="0001-ARM-at91-dt-at91sam9x5cm-fix-main-clock-frequency-de.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ARM-at91-dt-at91sam9x5cm-fix-main-clock-frequency-de.pa";
 filename*1="tch"

>From 0a2f054b54fb25d610c64da19220b952a8798805 Mon Sep 17 00:00:00 2001
From: Boris BREZILLON <b.brezillon@overkiz.com>
Date: Fri, 26 Jul 2013 17:30:47 +0200
Subject: [PATCH] ARM: at91/dt: at91sam9x5cm: fix main clock frequency
 defintion

---
 arch/arm/boot/dts/at91sam9x5cm.dtsi |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5cm.dtsi b/arch/arm/boot/dts/at91sam9x5cm.dtsi
index 4a5ee5c..a613c8c 100644
--- a/arch/arm/boot/dts/at91sam9x5cm.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5cm.dtsi
@@ -12,17 +12,6 @@
 		reg = <0x20000000 0x8000000>;
 	};
 
-	clocks {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		main_clock: clock@0 {
-			compatible = "atmel,osc", "fixed-clock";
-			clock-frequency = <12000000>;
-		};
-	};
-
 	ahb {
 		apb {
 			pinctrl@fffff400 {
@@ -32,6 +21,12 @@
 					};
 				};
 			};
+
+			pmc: pmc@fffffc00 {
+				main: mainck {
+					clock-frequency = <12000000>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5


--------------040702020707040703050806--
