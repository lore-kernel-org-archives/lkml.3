Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3FGMVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:21:49 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:45012 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3FGMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:21:42 -0400
MBOX-Line: From nobody Fri Jun  7 06:18:51 2013
Subject: [PATCH 0/3] clk: tegra: T114: add DFLL prerequisites
To: linux-tegra@vger.kernel.org, mturquette@linaro.org
From: Paul Walmsley <pwalmsley@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Jun 2013 06:18:51 -0600
Message-ID: <20130607121505.21868.72360.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the CAR IP block infrastructure needed to support the DFLL clocksource
to the Tegra114 clock code and data files.

Based on linux-next master.  Mike, please let me know if you want the
patches based on a v3.10-rc.

Boot-tested on Tegra114 Dalmore; log follows.


- Paul


---

Paul Walmsley (3):
      clk: tegra: T114: add FCPU clock shaper programming, needed by the DFLL
      clk: tegra: T114: add DFLL source clocks
      clk: tegra: T114: add DFLL DVCO reset control


 drivers/clk/tegra/clk-tegra114.c |  166 ++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h          |    6 +
 2 files changed, 172 insertions(+)


---------------------------------------------------------------------


U-Boot SPL 2013.04-rc1-ga0618e4 (May 27 2013 - 02:41:17)


U-Boot 2013.04-rc1-ga0618e4 (May 27 2013 - 02:41:17)

TEGRA114
Board: NVIDIA Puppy
DRAM:  256 MiB
WARNING: Caches not enabled
MMC:   Tegra SD/MMC: 0, Tegra SD/MMC: 1
*** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial
Net:   Net Initialization Skipped
No ethernet found.
(Re)start USB...
USB0:   USB EHCI 1.10
scanning bus 0 for devices... 2 USB Device(s) found
       scanning usb for storage devices... 0 Storage Device(s) found
       scanning usb for ethernet devices... 
Warning: asx0 using MAC address from net device
1 Ethernet Device(s) found
Hit any key to stop autoboot:  2  0 
Tegra114 (Puppy) # 
Tegra114 (Puppy) # 
Tegra114 (Puppy) # 
Tegra114 (Puppy) # 
Tegra114 (Puppy) # setenv bootargs 'ignore_loglevel console=ttyS0,115200n8'
Tegra114 (Puppy) # setenv ipaddr 192.168.100.100; setenv serverip 192.168.100.1; setenv tftpserverip 192.168.100.1
Tegra114 (Puppy) # tftpboot 0x8040e000 fit_image_2; bootm 0x8040e000
Waiting for Ethernet connection... done.
Using asx0 device
TFTP from server 192.168.100.1; our IP address is 192.168.100.100
Filename 'fit_image_2'.
Load address: 0x8040e000
Loading: *#################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 ####################################
	 1.4 MiB/s
done
Bytes transferred = 19598020 (12b0ac4 hex)
## Loading kernel from FIT Image at 8040e000 ...
   Using 'conf@1' configuration
   Trying 'kernel@1' kernel subimage
     Description:  unavailable
     Type:         Kernel Image (no loading done)
     Compression:  uncompressed
     Data Start:   0x8040e0c8
     Data Size:    4299472 Bytes = 4.1 MiB
   Verifying Hash Integrity ... OK
## Loading ramdisk from FIT Image at 8040e000 ...
   Using 'conf@1' configuration
   Trying 'ramdisk@1' ramdisk subimage
     Description:  unavailable
     Type:         RAMDisk Image
     Compression:  gzip compressed
     Data Start:   0x8082d80c
     Data Size:    15273879 Bytes = 14.6 MiB
     Architecture: ARM
     OS:           Linux
     Load Address: 0x82100000
     Entry Point:  0x00000038
   Verifying Hash Integrity ... OK
   Loading ramdisk from 0x8082d80c to 0x82100000
## Loading fdt from FIT Image at 8040e000 ...
   Using 'conf@1' configuration
   Trying 'fdt@1' fdt subimage
     Description:  tegra114-dalmore.dtb
     Type:         Flat Device Tree
     Compression:  uncompressed
     Data Start:   0x80827c4c
     Data Size:    23332 Bytes = 22.8 KiB
     Architecture: ARM
     Hash algo:    sha1
     Hash value:   8b9883d7da439600ba30365e683897dfa97cc4d7
   Verifying Hash Integrity ... sha1+ OK
   Booting using the fdt blob at 0x80827c4c
   XIP Kernel Image (no loading done) ... OK
OK
   Loading Device Tree to 8fb27000, end 8fb34b23 ... OK
boot_kernel.c: ft_board_setup: warning: g_crossystem_data is NULL

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-rc4-next-20130607-00003-geb0f105 (pwalmsley@baseline) (gcc version 4.5.1 (Sourcery G++ Lite 2010.09-50) ) #8 SMP PREEMPT Fri Jun 7 04:48:48 PDT 2013
[    0.000000] CPU: ARMv7 Processor [412fc0f2] revision 2 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine: NVIDIA Tegra SoC (Flattened Device Tree), model: NVIDIA Tegra114 Dalmore evaluation board
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] cma: CMA: reserved 16 MiB at 8e800000
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] On node 0 totalpages: 65536
[    0.000000] free_area_init_node: node 0, pgdat c07ebe00, node_mem_map c0843000
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65536 pages, LIFO batch:15
[    0.000000] Tegra Revision: A01 SKU: 0 CPU Process: 1 Core Process: 0
[    0.000000] PERCPU: Embedded 8 pages/cpu @c0a50000 s9024 r8192 d15552 u32768
[    0.000000] pcpu-alloc: s9024 r8192 d15552 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
[    0.000000] Kernel command line: ignore_loglevel console=ttyS0,115200n8
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Memory: 219884K/262144K available (5845K kernel code, 293K rwdata, 1704K rodata, 232K init, 340K bss, 42260K reserved, 0K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0767acc   (7551 kB)
[    0.000000]       .init : 0xc0768000 - 0xc07a2340   ( 233 kB)
[    0.000000]       .data : 0xc07a4000 - 0xc07ed6a0   ( 294 kB)
[    0.000000]        .bss : 0xc07ed6a0 - 0xc08427d0   ( 341 kB)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] sched_clock: 32 bits at 1000kHz, resolution 1000ns, wraps every 4294967ms
[    0.000000] Architected local timer running at 12.00MHz (virt).
[    0.000000] Switching to timer-based delay loop
[    0.000000] sched_clock: ARM arch timer >56 bits at 12000kHz, resolution 83ns
[    0.000000] Console: colour dummy device 80x30
[   32.509433] Calibrating delay loop (skipped), value calculated using timer frequency.. 24.00 BogoMIPS (lpj=120000)
[   32.509449] pid_max: default: 32768 minimum: 301
[   32.509883] Mount-cache hash table entries: 512
[   32.525337] Initializing cgroup subsys debug
[   32.525352] Initializing cgroup subsys freezer
[   32.525400] CPU: Testing write buffer coherency: ok
[   32.525707] /cpus/cpu@0 missing clock-frequency property
[   32.525720] /cpus/cpu@1 missing clock-frequency property
[   32.525730] /cpus/cpu@2 missing clock-frequency property
[   32.525739] /cpus/cpu@3 missing clock-frequency property
[   32.525753] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[   32.525777] Setting up static identity map for 0xc058fb40 - 0xc058fbd8
[   32.579918] CPU1: Booted secondary processor
[   32.579943] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[   32.599827] CPU2: Booted secondary processor
[   32.599851] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[   32.619759] CPU3: Booted secondary processor
[   32.619782] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[   32.619889] Brought up 4 CPUs
[   32.619918] SMP: Total of 4 processors activated (96.00 BogoMIPS).
[   32.619925] CPU: All CPU(s) started in SVC mode.
[   32.620918] devtmpfs: initialized
[   32.634447] pinctrl core: initialized pinctrl subsystem
[   32.634971] regulator-dummy: no parameters
[   32.635803] NET: Registered protocol family 16
[   32.637418] DMA: preallocated 256 KiB pool for atomic coherent allocations
[   32.648266] No ATAGs?
[   32.648295] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[   32.648305] hw-breakpoint: maximum watchpoint size is 8 bytes.
[   32.659264] bio: create slab <bio-0> at 0
[   32.660500] vdd_ac_bat: 5000 mV 
[   32.660802] dvdd_ts: Failed to request enable GPIO61: -517
[   32.660966] reg-fixed-voltage 1.regulator: Failed to register regulator: -517
[   32.660990] platform 1.regulator: Driver reg-fixed-voltage requests probe deferral
[   32.661190] lcd_bl_en: Failed to request enable GPIO58: -517
[   32.661340] reg-fixed-voltage 2.regulator: Failed to register regulator: -517
[   32.661363] platform 2.regulator: Driver reg-fixed-voltage requests probe deferral
[   32.661559] usb1_vbus: Failed to request enable GPIO108: -517
[   32.661706] reg-fixed-voltage 3.regulator: Failed to register regulator: -517
[   32.661729] platform 3.regulator: Driver reg-fixed-voltage requests probe deferral
[   32.661924] usb2_vbus: Failed to request enable GPIO86: -517
[   32.662072] reg-fixed-voltage 4.regulator: Failed to register regulator: -517
[   32.662094] platform 4.regulator: Driver reg-fixed-voltage requests probe deferral
[   32.662289] vdd_hdmi_5v0: Failed to request enable GPIO81: -517
[   32.662435] reg-fixed-voltage 5.regulator: Failed to register regulator: -517
[   32.662457] platform 5.regulator: Driver reg-fixed-voltage requests probe deferral
[   32.663438] vgaarb: loaded
[   32.664617] SCSI subsystem initialized
[   32.664995] usbcore: registered new interface driver usbfs
[   32.665090] usbcore: registered new interface driver hub
[   32.665232] usbcore: registered new device driver usb
[   32.667551] vdd-cpu: 500 <--> 1520 mV at 1100 mV 
[   32.668178] tps65090 1-0048: No cache defaults, reading back from HW
[   32.669461] vdd-sys-5v0: no parameters
[   32.669508] vdd-sys-5v0: supplied by vdd_ac_bat
[   32.669802] vdd-sys-3v3: no parameters
[   32.669839] vdd-sys-3v3: supplied by vdd_ac_bat
[   32.670097] vdd-ao: no parameters
[   32.670134] vdd-ao: supplied by vdd_ac_bat
[   32.670403] vdd-lcd-bl: no parameters
[   32.670438] vdd-lcd-bl: supplied by vdd_ac_bat
[   32.670684] TPS65090_RAILSFET2: no parameters
[   32.670720] TPS65090_RAILSFET2: supplied by vdd_ac_bat
[   32.670974] vdd-modem-3v3: no parameters
[   32.671020] vdd-modem-3v3: supplied by vdd-sys-3v3
[   32.671280] avdd-lcd: no parameters
[   32.671315] avdd-lcd: supplied by vdd-sys-3v3
[   32.671567] vdd-lvds: no parameters
[   32.671600] vdd-lvds: supplied by vdd-sys-3v3
[   32.671876] vdd-sd-slot: no parameters
[   32.671911] vdd-sd-slot: supplied by vdd-sys-3v3
[   32.672180] vdd-com-3v3: no parameters
[   32.672218] vdd-com-3v3: supplied by vdd-sys-3v3
[   32.672471] vdd-sby-5v0: no parameters
[   32.672503] vdd-sby-5v0: supplied by vdd_ac_bat
[   32.672758] vdd-sby-3v3: no parameters
[   32.672792] vdd-sby-3v3: supplied by vdd_ac_bat
[   32.673228] Linux video capture interface: v2.00
[   32.673915] platform 7000f010.iommu: Driver tegra-smmu requests probe deferral
[   32.674217] Advanced Linux Sound Architecture Driver Initialized.
[   32.674993] Bluetooth: Core ver 2.16
[   32.675063] NET: Registered protocol family 31
[   32.675071] Bluetooth: HCI device and connection manager initialized
[   32.675096] Bluetooth: HCI socket layer initialized
[   32.675117] Bluetooth: L2CAP socket layer initialized
[   32.675165] Bluetooth: SCO socket layer initialized
[   32.675775] cfg80211: Calling CRDA to update world regulatory domain
[   32.676771] Switching to clocksource arch_sys_counter
[   32.691263] NET: Registered protocol family 2
[   32.692155] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[   32.692225] TCP bind hash table entries: 2048 (order: 2, 16384 bytes)
[   32.692276] TCP: Hash tables configured (established 2048 bind 2048)
[   32.692533] TCP: reno registered
[   32.692548] UDP hash table entries: 256 (order: 1, 8192 bytes)
[   32.692575] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[   32.692971] NET: Registered protocol family 1
[   32.693636] RPC: Registered named UNIX socket transport module.
[   32.693646] RPC: Registered udp transport module.
[   32.693653] RPC: Registered tcp transport module.
[   32.693661] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   32.693671] PCI: CLS 0 bytes, default 64
[   32.694359] Unpacking initramfs...
[   34.522719] Freeing initrd memory: 14912K (c2100000 - c2f90000)
[   34.526581] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   34.528975] io scheduler noop registered (default)
[   34.540503] tegra-apbdma 6000a000.dma: Tegra20 APB DMA driver register 32 channels
[   34.540998] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   34.543028] 70006300.serial: ttyS0 at MMIO 0x70006300 (irq = 122) is a Tegra
[   35.363293] console [ttyS0] enabled
[   35.367532] [drm] Initialized drm 1.1.0 20060810
[   35.377913] loop: module loaded
[   35.388509] m25p80 spi32766.0: w25q32dw (4096 Kbytes)
[   35.399535] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   35.406990] usbcore: registered new interface driver pegasus
[   35.412704] usbcore: registered new interface driver asix
[   35.418172] usbcore: registered new interface driver ax88179_178a
[   35.424296] usbcore: registered new interface driver cdc_ether
[   35.430271] usbcore: registered new interface driver smsc75xx
[   35.436103] usbcore: registered new interface driver smsc95xx
[   35.441884] usbcore: registered new interface driver net1080
[   35.447600] usbcore: registered new interface driver cdc_subset
[   35.453563] usbcore: registered new interface driver zaurus
[   35.459255] usbcore: registered new interface driver cdc_ncm
[   35.464922] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   35.471598] ehci-pci: EHCI PCI platform driver
[   35.476203] usbcore: registered new interface driver cdc_acm
[   35.481829] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   35.489877] usbcore: registered new interface driver cdc_wdm
[   35.495621] usbcore: registered new interface driver usb-storage
[   35.502221] mousedev: PS/2 mouse device common for all mice
[   35.509150] tegra_rtc 7000e000.rtc: rtc core: registered 7000e000.rtc as rtc0
[   35.516295] tegra_rtc 7000e000.rtc: Tegra internal Real Time Clock
[   35.523469] sbs-battery 0-000b: sbs_probe: Failed to get device status
[   35.530010] sbs-battery: probe of 0-000b failed with error -121
[   35.537450] cpuidle: using governor ladder
[   35.541527] cpuidle: using governor menu
[   35.545575] sdhci: Secure Digital Host Controller Interface driver
[   35.551720] sdhci: Copyright(c) Pierre Ossman
[   35.556066] sdhci-pltfm: SDHCI platform and OF driver helper
[   35.562098] sdhci-tegra 78000400.sdhci: Got CD GPIO #170.
[   35.568539] mmc0: no vqmmc regulator found
[   35.572616] mmc0: no vmmc regulator found
[   35.576618] mmc0: Invalid maximum block size, assuming 512 bytes
[   35.625009] mmc0: SDHCI controller on 78000400.sdhci [78000400.sdhci] using ADMA
[   35.632556] mmc1: no vqmmc regulator found
[   35.638694] mmc1: no vmmc regulator found
[   35.645792] mmc1: Invalid maximum block size, assuming 512 bytes
[   35.694736] mmc1: SDHCI controller on 78000600.sdhci [78000600.sdhci] using ADMA
[   35.702745] usbcore: registered new interface driver usbhid
[   35.708304] usbhid: USB HID core driver
[   35.715950] TCP: cubic registered
[   35.719546] NET: Registered protocol family 10
[   35.726787] mip6: Mobile IPv6
[   35.729741] sit: IPv6 over IPv4 tunneling driver
[   35.736030] NET: Registered protocol family 17
[   35.740488] NET: Registered protocol family 15
[   35.745088] Bluetooth: RFCOMM socket layer initialized
[   35.750198] Bluetooth: RFCOMM ver 1.11
[   35.753925] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   35.759240] Bluetooth: BNEP socket layer initialized
[   35.764175] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   35.770089] Bluetooth: HIDP socket layer initialized
[   35.775194] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[   35.783072] Registering SWP/SWPB emulation handler
[   35.788503] vdd-com-3v3: disabling
[   35.792009] vdd-lvds: disabling
[   35.797305] avdd-lcd: disabling
[   35.800547] vdd-lcd-bl: disabling
[   35.806560] dvdd_ts: 1800 mV 
[   35.809861] lcd_bl_en: 5000 mV 
[   35.815407] usb1_vbus: 5000 mV 
[   35.818573] usb1_vbus: supplied by vdd-sys-5v0
[   35.825415] usb2_vbus: 5000 mV 
[   35.828570] usb2_vbus: supplied by vdd-sys-5v0
[   35.835395] vdd_hdmi_5v0: 5000 mV 
[   35.838810] vdd_hdmi_5v0: supplied by vdd-sys-5v0
[   35.846556] tegra_rtc 7000e000.rtc: setting system clock to 1970-01-01 00:00:36 UTC (36)
[   35.854970] ALSA device list:
[   35.857921]   No soundcards found.
[   35.861842] Freeing unused kernel memory: 232K (c0768000 - c07a2000)
/init: 0: can't access tty; job control turned off
# [   36.367522] mmc1: BKOPS_EN bit is not set
[   36.378786] mmc1: new high speed MMC card at address 0001
[   36.384764] mmcblk0: mmc1:0001 SEM32G 29.1 GiB 
[   36.389573] mmcblk0boot0: mmc1:0001 SEM32G partition 1 4.00 MiB
[   36.395767] mmcblk0boot1: mmc1:0001 SEM32G partition 2 4.00 MiB
[   36.401934] mmcblk0rpmb: mmc1:0001 SEM32G partition 3 4.00 MiB
[   36.408964]  mmcblk0: unknown partition table
[   36.415507]  mmcblk0boot1: unknown partition table
[   36.421822]  mmcblk0boot0: unknown partition table

