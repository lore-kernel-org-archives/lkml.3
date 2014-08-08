Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaHHH7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:59:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42893 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaHHH7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:59:48 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a8-53e483708d3d
Message-id: <1407484788.21474.13.camel@AMDC1943>
Subject: Re: [PATCH] mfd: max77686: fix support for devices without irq
 specified
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Aug 2014 09:59:48 +0200
In-reply-to: <1457999.lNPdqEWCCR@amdc1032>
References: <1457999.lNPdqEWCCR@amdc1032>
Content-type: multipart/mixed; boundary="=-nx5Pr7L4Ea/EjKbnMD2x"
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7oFzU+CDX5u0LDYOGM9q8XZZQfZ
	LI7+LrA42/SG3eL+16OMFpd3zWGzmHF+H5PF6W5WBw6P2Q0XWTz+Pr/O4nHn2h42j3knAz36
	tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr41jjWbaCpgWMFVfWT2VqYNzWyNjFyMkhIWAicX7y
	bSYIW0ziwr31bF2MXBxCAksZJdae7WMGSQgJfGaU+L7RAcTmFTCQmPv/ATuILSwQLLHm5Fo2
	EJtNwFhi8/IlYLaIgIXE2hVvWUAGMQssZJL4PvEnWAOLgKrEq/evWEBsTgEtiUt79zFBLNCU
	6Nx6D8xmFnCQWLu7gxniImWJefuPMUEsFpT4MfkeywRG/llIymYhSUHENSVat/9mh7DlJba/
	ncMMYdtKXDl0iQ3Cdpa4srKDCVnNAkb2VYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghEfR1
	B+PSY1aHGAU4GJV4eBX23g0WYk0sK67MPcSoAjTn0YbVFxilWPLy81KVRHi3Nz4JFuJNSays
	Si3Kjy8qzUktPsTIxMEp1cDou4hhzdSy2KO/p6Ze/XP8yWS3b1eLXqeei0voPFLo+G1hk+6O
	Bb7bT5+Ou3dwBYuj2eM1tbyZpxor3hvx3a/7srX555T9K3dq6R+cMZOpmK/QdtaBZu/Heu2R
	LrXG4YqiJidcDsXYr1D6KrZw9V+G0B38NdMdM5fmJPzmvHjIzGtzkH3uvr5FSizFGYmGWsxF
	xYkAM+gBY4oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nx5Pr7L4Ea/EjKbnMD2x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On czw, 2014-08-07 at 18:09 +0200, Bartlomiej Zolnierkiewicz wrote:
> Before commit 6f1c1e71d933 ("mfd: max77686: Convert to use regmap_irq")
> max77686_irq_init() return value was never checked so devices without
> irq specified (like Hardkernel's Exynos4412 based ODROID-U3 board)
> worked fine even though -ENODEV was returned by the function.  Add
> handling for no irq specified case in max77686_i2c_probe() restoring
> the previous driver's behavior.
> 
> The patch fixes boot for Hardkernel's Exynos4412 based ODROID-U3 board.
> 
> Error messages before the patch:
> ...
> [    0.163995] max77686 0-0009: Failed to request IRQ 0 for max77686-pmic: -22
> [    0.164020] max77686 0-0009: failed to add PMIC irq chip: -22
> [    0.164478] max77686: probe of 0-0009 failed with error -22
> ...
> 
> Fixes: 6f1c1e71d933 ("mfd: max77686: Convert to use regmap_irq")
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> patch is against next-20140804 branch of linux-next kernel
> 
>  drivers/mfd/max77686.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 86e5523..5fe024c 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -314,6 +314,11 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  		}
>  	}
>  
> +	if (!max77686->irq) {
> +		dev_info(max77686->dev, "irq is not specified\n");
> +		goto skip_irq_setup;
> +	}
> +
>  	ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
>  				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
>  				  IRQF_SHARED, 0, irq_chip,
> @@ -332,6 +337,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  		goto err_del_irqc;
>  	}
>  
> +skip_irq_setup:
>  	ret = mfd_add_devices(max77686->dev, -1, cells, n_devs, NULL, 0, NULL);
>  	if (ret < 0) {
>  		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);

Not sufficient. You have to also fix RTC driver (OOPS from Trats2
attached). Also consider adding checks for (max77686->irq) to the
suspend and resume.

Best regards,
Krzysztof



--=-nx5Pr7L4Ea/EjKbnMD2x
Content-Disposition: attachment; filename="max77686-oops.txt"
Content-Type: text/plain; name="max77686-oops.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Linux version 3.16.0-next-20140808-00004-g6ff587eb153e-dirty (k.kozlowski@AMDC1943) (gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-12ubuntu1) ) #157 SMP PREEMPT Fri Aug 8 09:40:37 CEST 2014
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine model: Samsung Trats 2 based on Exynos4412
[    0.000000] cma: Reserved 64 MiB at 6b800000
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] Running under secure firmware.
[    0.000000] PERCPU: Embedded 7 pages/cpu @eaf84000 s7488 r8192 d12992 u32768
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260368
[    0.000000] Kernel command line: root=/dev/mmcblk0p5 rw rootfstype=ext4 rootwait console=ttySAC2,115200n8 fbmem=24M@0x52000000 normal lcd=s6e8ax0 pmic_info=3 resume=179:3 csa=/dev/mmcblk0p1 bootloader_log=1068@0x43908010
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 965980K/1047552K available (4249K kernel code, 273K rwdata, 1440K rodata, 283K init, 275K bss, 81572K reserved, 269312K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0596870   (5691 kB)
[    0.000000]       .init : 0xc0597000 - 0xc05ddd40   ( 284 kB)
[    0.000000]       .data : 0xc05de000 - 0xc0622400   ( 273 kB)
[    0.000000]        .bss : 0xc0622400 - 0xc06670c0   ( 276 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] GIC physical location is 0x10490000
[    0.000000] L2C: failed to init: -19
[    0.000000] Exynos4x12 clocks: sclk_apll = 800000000, sclk_mpll = 800000000
[    0.000000]  sclk_epll = 96000000, sclk_vpll = 108000000, arm_clk = 800000000
[    0.000000] Switching to timer-based delay loop, resolution 41ns
[    0.000008] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956969942ns
[    0.000279] Console: colour dummy device 80x30
[    0.000313] Calibrating delay loop (skipped), value calculated using timer frequency.. 48.00 BogoMIPS (lpj=120000)
[    0.000332] pid_max: default: 32768 minimum: 301
[    0.000520] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000541] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001306] CPU: Testing write buffer coherency: ok
[    0.001690] missing device node for CPU 0
[    0.001752] missing device node for CPU 1
[    0.001792] missing device node for CPU 2
[    0.001827] missing device node for CPU 3
[    0.001842] CPU0: thread -1, cpu 0, socket 10, mpidr 80000a00
[    0.002699] Setting up static identity map for 0x40407358 - 0x404073b0
[    0.030792] CPU1: Booted secondary processor
[    0.030852] CPU1: thread -1, cpu 1, socket 10, mpidr 80000a01
[    0.040759] CPU2: Booted secondary processor
[    0.040820] CPU2: thread -1, cpu 2, socket 10, mpidr 80000a02
[    0.050782] CPU3: Booted secondary processor
[    0.050845] CPU3: thread -1, cpu 3, socket 10, mpidr 80000a03
[    0.050977] Brought up 4 CPUs
[    0.051013] SMP: Total of 4 processors activated.
[    0.051022] CPU: All CPU(s) started in SVC mode.
[    0.052043] devtmpfs: initialized
[    0.057169] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
[    0.062998] pinctrl core: initialized pinctrl subsystem
[    0.064075] regulator-dummy: no parameters
[    0.080273] NET: Registered protocol family 16
[    0.082152] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.089342] exynos-audss-clk 3810000.clock-controller: setup completed
[    0.122253] EXYNOS4x12 PMU Initialize
[    0.173469] VMEM_VDD_2.8V: 2800 mV
[    0.174156] CAM_SENSOR_A: 2800 mV
[    0.174870] LCD_VDD_2.2V: 2200 mV
[    0.175669] CAM_AF: 2800 mV
[    0.176396] CAM_ISP_CORE_1.2V_EN: 1200 mV
[    0.177064] LED_A_3.0V: 3000 mV
[    0.181794] SCSI subsystem initialized
[    0.183412] usbcore: registered new interface driver usbfs
[    0.183726] usbcore: registered new interface driver hub
[    0.184078] usbcore: registered new device driver usb
[    0.185478] s3c-i2c 13860000.i2c: slave address 0x10
[    0.185505] s3c-i2c 13860000.i2c: bus frequency set to 390 KHz
[    0.186857] s3c-i2c 13860000.i2c: i2c-0: S3C I2C adapter
[    0.187193] s3c-i2c 13890000.i2c: slave address 0x10
[    0.187219] s3c-i2c 13890000.i2c: bus frequency set to 390 KHz
[    0.188444] s3c-i2c 13890000.i2c: i2c-3: S3C I2C adapter
[    0.188818] s3c-i2c 138d0000.i2c: slave address 0x10
[    0.188845] s3c-i2c 138d0000.i2c: bus frequency set to 97 KHz
[    0.191228] max77686 7-0009: irq is not specified
[    0.194702] VALIVE_1.0V_AP: 1000 mV
[    0.196936] VM1M2_1.2V_AP: 1200 mV
[    0.199169] VCC_1.8V_AP: 1800 mV
[    0.201460] VCC_2.8V_AP: 2800 mV
[    0.203708] VCC_1.8V_IO: 1800 mV
[    0.207651] VMPLL_1.0V_AP: 1000 mV
[    0.211642] VPLL_1.0V_AP: 1000 mV
[    0.213031] VMIPI_1.0V: 1000 mV
[    0.215712] CAM_ISP_MIPI_1.2V: 1200 mV
[    0.217145] VMIPI_1.8V: 1800 mV
[    0.221079] VABB1_1.95V: 1950 mV
[    0.222473] VUOTG_3.0V: 3000 mV
[    0.223862] NFC_AVDD_1.8V: 1800 mV
[    0.227891] VABB2_1.95V: 1950 mV
[    0.229281] VHSIC_1.0V: 1000 mV
[    0.230742] VHSIC_1.8V: 1800 mV
[    0.232132] CAM_SENSOR_CORE_1.2V: 1200 mV
[    0.233541] CAM_ISP_SEN_IO_1.8V: 1800 mV
[    0.234967] VT_CAM_1.8V: 1800 mV
[    0.236477] VDDQ_PRE_1.8V: 1800 mV
[    0.237878] VTF_2.8V: 2800 mV
[    0.240145] VMEM_VDD_2.8V: 2800 mV
[    0.240718] VMEM_VDD_2.8V: Failed to create debugfs directory
[    0.241550] TSP_AVDD_3.3V: 3300 mV
[    0.242965] TSP_VDD_1.8V: 1800 mV
[    0.246133] LCD_VCC_3.3V: 2800 mV
[    0.247548] MOTOR_VCC_3.0V: 3000 mV
[    0.249775] vdd_mif: 850 <--> 1100 mV at 1000 mV
[    0.251661] vdd_arm: 850 <--> 1500 mV at 1100 mV
[    0.253538] vdd_int: 850 <--> 1150 mV at 1000 mV
[    0.255487] vdd_g3d: 850 <--> 1150 mV at 1000 mV
[    0.257347] VMEM_1.2V_AP: 1200 mV
[    0.259219] VCC_SUB_1.35V: 1350 mV
[    0.261149] VCC_SUB_2.0V: 2000 mV
[    0.263411] VMEM_VDDF_3.0V: 2850 mV
[    0.264844] CAM_ISP_CORE_1.2V: 1000 <--> 1200 mV at 1200 mV
[    0.266226] s3c-i2c 138d0000.i2c: i2c-7: S3C I2C adapter
[    0.273432] Advanced Linux Sound Architecture Driver Initialized.
[    0.275371] Switched to clocksource mct-frc
[    0.314352] NET: Registered protocol family 2
[    0.315565] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.315691] TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
[    0.315929] TCP: Hash tables configured (established 8192 bind 8192)
[    0.316065] TCP: reno registered
[    0.316094] UDP hash table entries: 512 (order: 2, 24576 bytes)
[    0.316146] UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
[    0.316485] NET: Registered protocol family 1
[    0.321345] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.347974] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.348398] msgmni has been set to 1488
[    0.349817] bounce: pool size: 64 pages
[    0.349850] io scheduler noop registered
[    0.349871] io scheduler deadline registered
[    0.350798] io scheduler cfq registered (default)
[    0.362742] dma-pl330 12680000.pdma: Loaded driver for PL330 DMAC-1315632
[    0.362775] dma-pl330 12680000.pdma:         DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
[    0.369417] dma-pl330 12690000.pdma: Loaded driver for PL330 DMAC-1315632
[    0.369453] dma-pl330 12690000.pdma:         DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
[    0.371711] dma-pl330 12850000.mdma: Loaded driver for PL330 DMAC-1315632
[    0.371745] dma-pl330 12850000.mdma:         DBUFF-64x8bytes Num_Chans-8 Num_Peri-1 Num_Events-32
[    0.533569] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.536799] 13800000.serial: ttySAC0 at MMIO 0x13800000 (irq = 84, base_baud = 0) is a S3C6400/10
[    0.537567] 13810000.serial: ttySAC1 at MMIO 0x13810000 (irq = 85, base_baud = 0) is a S3C6400/10
[    0.538323] 13820000.serial: ttySAC2 at MMIO 0x13820000 (irq = 86, base_baud = 0) is a S3C6400/10
[    1.324665] console [ttySAC2] enabled
[    1.329082] 13830000.serial: ttySAC3 at MMIO 0x13830000 (irq = 87, base_baud = 0) is a S3C6400/10
[    1.352721] brd: module loaded
[    1.361425] loop: module loaded
[    1.364409] s3c64xx-spi 13930000.spi: spi bus clock parent not specified, using clock at index 0 as parent
[    1.372817] s3c64xx-spi 13930000.spi: number of chip select lines not specified, assuming 1 chip select line
[    1.384641] usbcore: registered new interface driver asix
[    1.388783] usbcore: registered new interface driver ax88179_178a
[    1.394876] usbcore: registered new interface driver cdc_ether
[    1.400673] usbcore: registered new interface driver smsc75xx
[    1.406433] usbcore: registered new interface driver smsc95xx
[    1.412106] usbcore: registered new interface driver net1080
[    1.417735] usbcore: registered new interface driver cdc_subset
[    1.423642] usbcore: registered new interface driver zaurus
[    1.429242] usbcore: registered new interface driver cdc_ncm
[    1.435312] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.441232] ehci-exynos: EHCI EXYNOS driver
[    1.445721] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.451580] ohci-exynos: OHCI EXYNOS driver
[    1.456642] usbcore: registered new interface driver usb-storage
[    1.462956] mousedev: PS/2 mouse device common for all mice
[    1.468352] max77686-rtc max77686-rtc: max77686_rtc_probe
[    1.571966] max77686-rtc max77686-rtc: rtc core: registered max77686-rtc as rtc0
[    1.577942] Unable to handle kernel NULL pointer dereference at virtual address 00000094
[    1.586010] pgd = c0004000
[    1.588653] [00000094] *pgd=00000000
[    1.592218] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    1.597506] Modules linked in:
[    1.600550] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-next-20140808-00004-g6ff587eb153e-dirty #157
[    1.610094] task: ea80ec00 ti: ea888000 task.ti: ea888000
[    1.615497] PC is at regmap_irq_get_virq+0x0/0x28
[    1.620166] LR is at max77686_rtc_probe+0xe4/0x1d8
[    1.624938] pc : [<c0254ce8>]    lr : [<c02da210>]    psr: 80000113
[    1.624938] sp : ea889e58  ip : 00000001  fp : 00000000
[    1.636393] r10: 00000000  r9 : c05c00f8  r8 : 00000001
[    1.641601] r7 : eaa4bb90  r6 : 00000000  r5 : eaa95610  r4 : ea2a8590
[    1.648110] r3 : 00000000  r2 : 00000000  r1 : 00000001  r0 : 00000000
[    1.654622] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    1.661913] Control: 10c5387d  Table: 4000404a  DAC: 00000015
[    1.667642] Process swapper/0 (pid: 1, stack limit = 0xea888240)
[    1.673631] Stack: (0xea889e58 to 0xea88a000)
[    1.677973] 9e40:                                                       c05c00f8 00000001
[    1.686134] 9e60: 00000000 eaa95610 c0614ad0 02030000 eaa95610 c0614ad0 00000000 c0614ad0
[    1.694293] 9e80: 00000000 c0240498 c024046c eaa95610 c065e3a8 c023f0ac eaa95610 c0614ad0
[    1.702452] 9ea0: eaa95644 00000000 c05b1b04 c023f258 00000000 c0614ad0 c023f1cc c023d8f0
[    1.710611] 9ec0: ea805478 eaa6dd40 c0614ad0 ea2a8500 c060cad0 c023e8b0 c0515d20 c0614ad0
[    1.718770] 9ee0: c05e8c18 c0614ad0 c05e8c18 ea2adbc0 c0622400 c023f878 c0240188 c05e8c18
[    1.726929] 9f00: c05e8c18 c0008884 0000002e 00000000 c04ece74 c0570284 00000000 ea889f30
[    1.735088] 9f20: c0037574 c01cb820 20000113 ffffffff eb7ff89d c041e168 0000008e c0037768
[    1.743247] 9f40: c056ffa4 00000006 eb7ff8bb 00000006 c05ebdb4 eb7ff800 c05dbaec 00000006
[    1.751407] 9f60: c05c00ec c0622400 0000008e c05c00f8 c0597518 c0597cb4 00000006 00000006
[    1.759565] 9f80: c0597518 c003bfe8 00000000 c03fdc98 00000000 00000000 00000000 00000000
[    1.767725] 9fa0: 00000000 c03fdca0 00000000 c000e6b8 00000000 00000000 00000000 00000000
[    1.775883] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    1.784043] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 c0c0c0c0 c0c0c0c0
[    1.792219] [<c0254ce8>] (regmap_irq_get_virq) from [<c02da210>] (max77686_rtc_probe+0xe4/0x1d8)
[    1.800984] [<c02da210>] (max77686_rtc_probe) from [<c0240498>] (platform_drv_probe+0x2c/0x5c)
[    1.809570] [<c0240498>] (platform_drv_probe) from [<c023f0ac>] (driver_probe_device+0x10c/0x22c)
[    1.818421] [<c023f0ac>] (driver_probe_device) from [<c023f258>] (__driver_attach+0x8c/0x90)
[    1.826839] [<c023f258>] (__driver_attach) from [<c023d8f0>] (bus_for_each_dev+0x54/0x88)
[    1.834998] [<c023d8f0>] (bus_for_each_dev) from [<c023e8b0>] (bus_add_driver+0xd4/0x1d0)
[    1.843156] [<c023e8b0>] (bus_add_driver) from [<c023f878>] (driver_register+0x78/0xf4)
[    1.851145] [<c023f878>] (driver_register) from [<c0008884>] (do_one_initcall+0x80/0x1d0)
[    1.859313] [<c0008884>] (do_one_initcall) from [<c0597cb4>] (kernel_init_freeable+0x108/0x1d4)
[    1.867985] [<c0597cb4>] (kernel_init_freeable) from [<c03fdca0>] (kernel_init+0x8/0xec)
[    1.876061] [<c03fdca0>] (kernel_init) from [<c000e6b8>] (ret_from_fork+0x14/0x3c)
[    1.883606] Code: e8bd8070 e3500000 1590009c e12fff1e (e5903094)
[    1.889778] ---[ end trace e2ee427d70aa8e98 ]---
[    1.894334] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    1.894334]
[    1.903404] CPU2: stopping
[    1.906090] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D        3.16.0-next-20140808-00004-g6ff587eb153e-dirty #157
[    1.916787] [<c0013bc4>] (unwind_backtrace) from [<c0010e48>] (show_stack+0x10/0x14)
[    1.924496] [<c0010e48>] (show_stack) from [<c0401884>] (dump_stack+0x70/0xbc)
[    1.931696] [<c0401884>] (dump_stack) from [<c0012e50>] (handle_IPI+0x154/0x188)
[    1.939071] [<c0012e50>] (handle_IPI) from [<c00085f8>] (gic_handle_irq+0x60/0x68)
[    1.946626] [<c00085f8>] (gic_handle_irq) from [<c0011980>] (__irq_svc+0x40/0x70)
[    1.954082] Exception stack(0xea8b3fa0 to 0xea8b3fe8)
[    1.959121] 3fa0: 00000002 c04fb4d0 ea8b3ff0 c001aac0 c05e64ec c040b4f4 c06222e1 c06222e1
[    1.967279] 3fc0: 00000001 413fc090 00000000 00000000 00000001 ea8b3fe8 c000f20c c000f210
[    1.975434] 3fe0: 60000113 ffffffff
[    1.978916] [<c0011980>] (__irq_svc) from [<c000f210>] (arch_cpu_idle+0x30/0x3c)
[    1.986295] [<c000f210>] (arch_cpu_idle) from [<c004d214>] (cpu_startup_entry+0x114/0x18c)
[    1.994537] [<c004d214>] (cpu_startup_entry) from [<40008684>] (0x40008684)
[    2.001481] CPU1: stopping
[    2.004173] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D        3.16.0-next-20140808-00004-g6ff587eb153e-dirty #157
[    2.014862] [<c0013bc4>] (unwind_backtrace) from [<c0010e48>] (show_stack+0x10/0x14)
[    2.022577] [<c0010e48>] (show_stack) from [<c0401884>] (dump_stack+0x70/0xbc)
[    2.029777] [<c0401884>] (dump_stack) from [<c0012e50>] (handle_IPI+0x154/0x188)
[    2.037154] [<c0012e50>] (handle_IPI) from [<c00085f8>] (gic_handle_irq+0x60/0x68)
[    2.044708] [<c00085f8>] (gic_handle_irq) from [<c0011980>] (__irq_svc+0x40/0x70)
[    2.052165] Exception stack(0xea8b1fa0 to 0xea8b1fe8)
[    2.057204] 1fa0: 00000001 c04fb4d0 ea8b1ff0 c001aac0 c05e64ec c040b4f4 c06222e1 c06222e1
[    2.065362] 1fc0: 00000001 413fc090 00000000 00000000 00000001 ea8b1fe8 c000f20c c000f210
[    2.073518] 1fe0: 60000113 ffffffff
[    2.076999] [<c0011980>] (__irq_svc) from [<c000f210>] (arch_cpu_idle+0x30/0x3c)
[    2.084375] [<c000f210>] (arch_cpu_idle) from [<c004d214>] (cpu_startup_entry+0x114/0x18c)
[    2.092619] [<c004d214>] (cpu_startup_entry) from [<40008684>] (0x40008684)
[    2.099565] CPU3: stopping
[    2.102256] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D        3.16.0-next-20140808-00004-g6ff587eb153e-dirty #157
[    2.112945] [<c0013bc4>] (unwind_backtrace) from [<c0010e48>] (show_stack+0x10/0x14)
[    2.120661] [<c0010e48>] (show_stack) from [<c0401884>] (dump_stack+0x70/0xbc)
[    2.127862] [<c0401884>] (dump_stack) from [<c0012e50>] (handle_IPI+0x154/0x188)
[    2.135239] [<c0012e50>] (handle_IPI) from [<c00085f8>] (gic_handle_irq+0x60/0x68)
[    2.142791] [<c00085f8>] (gic_handle_irq) from [<c0011980>] (__irq_svc+0x40/0x70)
[    2.150249] Exception stack(0xea8b5fa0 to 0xea8b5fe8)
[    2.155288] 5fa0: 00000003 c04fb4d0 ea8b5ff0 c001aac0 c05e64ec c040b4f4 c06222e1 c06222e1
[    2.163447] 5fc0: 00000001 413fc090 00000000 00000000 00000001 ea8b5fe8 c000f20c c000f210
[    2.171602] 5fe0: 60000113 ffffffff
[    2.175082] [<c0011980>] (__irq_svc) from [<c000f210>] (arch_cpu_idle+0x30/0x3c)
[    2.182459] [<c000f210>] (arch_cpu_idle) from [<c004d214>] (cpu_startup_entry+0x114/0x18c)
[    2.190703] [<c004d214>] (cpu_startup_entry) from [<40008684>] (0x40008684)
[    2.197651] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.197651]


--=-nx5Pr7L4Ea/EjKbnMD2x--

