Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3LFHyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:54:13 -0500
Received: from infra.glanzmann.de ([78.47.70.69]:54716 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3LFHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:54:08 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 02:54:07 EST
Date: Fri, 6 Dec 2013 08:44:55 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nouveau@lists.freedesktop.org
Subject: Regression: drm/nouveau/clk: implement power state and engine clock
 control in core (7c856522069755ab9d163a24ac332cd3cb35fe30) breaks GeForce
 9400 on Intel Mac Mini Model November 2010 model
Message-ID: <20131206074455.GB21029@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Ben Skeggs <bskeggs@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, nouveau@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
the current git HEAD of Linus Torvalds tree breaks Nouveau on my Mac Mini
Model 2010. I get variation of the following kernel panic when booting.

(gateway) [~] nc -u -l -p 6666
[    3.796018] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.796100] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.796304] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HA, max UDMA/133
[    3.796370] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.796672] ata1.00: configured for UDMA/133
[    3.796894] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    3.806643] ata2.00: ATAPI: PIONEER DVD-RW  DVRTS08, Q81B, max UDMA/33
[    3.818934] ata2.00: configured for UDMA/33
[    3.873892] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVRTS08  Q81B PQ: 0 ANSI: 5
[    3.884561] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.884790] sd 0:0:0:0: [sda] Write Protect is off
[    3.884898] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.885526]  sda: sda1
[    3.885973] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.920096] firewire_core 0000:04:00.0: created device fw0: GUID 0023dffffe7ed446, S800
[    3.934618] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
[    3.934684] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.938525] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.938659] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.248270] device-mapper: uevent: version 1.0.3
[    4.248427] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: dm-devel@redhat.com
[    4.324025] raid6: sse2x1    2845 MB/s
[    4.392010] raid6: sse2x2    3597 MB/s
[    4.460007] raid6: sse2x4    4706 MB/s
[    4.460068] raid6: using algorithm sse2x4 (4706 MB/s)
[    4.460136] raid6: using ssse3x2 recovery algorithm
[    4.460405] xor: measuring software checksum speed
[    4.500004]    prefetch64-sse:  6964.000 MB/sec
[    4.540003]    generic_sse:  6115.000 MB/sec
[    4.540065] xor: using function: prefetch64-sse (6964.000 MB/sec)
[    4.548866] bio: create slab <bio-1> at 1
[    4.549122] Btrfs loaded
[    4.690419] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    4.945318] udevd[440]: starting version 175
[    5.025560] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    5.025648] ACPI: Power Button [PWRB]
[    5.025789] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    5.025792] ACPI: Sleep Button [SLPB]
[    5.025922] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    5.025924] ACPI: Power Button [PWRF]
[    5.026903] ACPI: Requesting acpi_cpufreq
[    5.031899] tsc: Marking TSC unstable due to TSC halts in idle
[    5.034066] Switched to clocksource hpet
[    5.123175] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.123579] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    5.124160] i2c i2c-0: nForce2 SMBus adapter at 0x2140
[    5.124260] i2c i2c-1: nForce2 SMBus adapter at 0x2100
[    5.125485] ACPI: bus type USB registered
[    5.125577] usbcore: registered new interface driver usbfs
[    5.125650] usbcore: registered new interface driver hub
[    5.127100] usbcore: registered new device driver usb
[    5.128156] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.129481] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.130620] ohci-pci: OHCI PCI platform driver
[    5.130902] ohci-pci 0000:00:04.0: OHCI PCI host controller
[    5.130972] ohci-pci 0000:00:04.0: new USB bus registered, assigned bus number 1
[    5.131077] ohci-pci 0000:00:04.0: irq 23, io mem 0xd3488000
[    5.131288] ehci-pci: EHCI PCI platform driver
[    5.173695] ssb: Found chip with id 0x4321, rev 0x05 and package 0x00
[    5.187724] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.187797] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.187878] usb usb1: Product: OHCI PCI host controller
[    5.187938] usb usb1: Manufacturer: Linux 3.12.0-rc3+ ohci_hcd
[    5.188020] usb usb1: SerialNumber: 0000:00:04.0
[    5.188459] hub 1-0:1.0: USB hub found
[    5.188564] hub 1-0:1.0: 7 ports detected
[    5.189220] ehci-pci 0000:00:04.1: EHCI Host Controller
[    5.189284] ehci-pci 0000:00:04.1: new USB bus registered, assigned bus number 2
[    5.189363] ehci-pci 0000:00:04.1: debug port 1
[    5.189463] ehci-pci 0000:00:04.1: irq 22, io mem 0xd3489200
[    5.202613] ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    5.203875] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.203940] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.204036] usb usb2: Product: EHCI Host Controller
[    5.204100] usb usb2: Manufacturer: Linux 3.12.0-rc3+ ehci_hcd
[    5.204163] usb usb2: SerialNumber: 0000:00:04.1
[    5.204417] hub 2-0:1.0: USB hub found
[    5.204514] hub 2-0:1.0: 7 ports detected
[    5.236292] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
[    5.260724] cfg80211: Calling CRDA to update world regulatory domain
[    5.268086] hub 1-0:1.0: USB hub found
[    5.268225] hub 1-0:1.0: 7 ports detected
[    5.268727] ehci-pci 0000:00:06.1: EHCI Host Controller
[    5.268792] ehci-pci 0000:00:06.1: new USB bus registered, assigned bus number 3
[    5.268871] ehci-pci 0000:00:06.1: debug port 1
[    5.268975] ehci-pci 0000:00:06.1: irq 20, io mem 0xd3489100
[    5.281075] applesmc: key=154 fan=1 temp=8 index=8 acc=0 lux=0 kbd=0
[    5.281164] ehci-pci 0000:00:06.1: USB 2.0 started, EHCI 1.00
[    5.281275] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    5.281340] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.281412] usb usb3: Product: EHCI Host Controller
[    5.281472] usb usb3: Manufacturer: Linux 3.12.0-rc3+ ehci_hcd
[    5.281536] usb usb3: SerialNumber: 0000:00:06.1
[    5.281841] hub 3-0:1.0: USB hub found
[    5.281941] hub 3-0:1.0: 5 ports detected
[    5.282649] ohci-pci 0000:00:06.0: OHCI PCI host controller
[    5.282719] ohci-pci 0000:00:06.0: new USB bus registered, assigned bus number 4
[    5.282821] ohci-pci 0000:00:06.0: irq 21, io mem 0xd3487000
[    5.283078] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
[    5.296970] cfg80211: World regulatory domain updated:
[    5.297040] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    5.297113] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.297186] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.297259] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.297332] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.297406] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.324314] b43-phy0: Found PHY: Analog 5, Type 4 (N), Revision 2
[    5.338074] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.338138] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.338214] usb usb4: Product: OHCI PCI host controller
[    5.338278] usb usb4: Manufacturer: Linux 3.12.0-rc3+ ohci_hcd
[    5.338343] usb usb4: SerialNumber: 0000:00:06.0
[    5.338578] hub 4-0:1.0: USB hub found
[    5.338653] hub 4-0:1.0: 5 ports detected
[    5.339292] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[    5.339360] hda_intel: Disabling MSI
[    5.348396] Broadcom 43xx driver loaded [ Features: PMNLS ]
[    5.939512] hda_codec: ALC889A: SKU not ready 0x400000f0
[    6.372263] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:08.0/input/input4
[    6.468165] usb 1-3: new low-speed USB device number 2 using ohci-pci
[    6.681163] usb 1-3: New USB device found, idVendor=046d, idProduct=c05b
[    6.681242] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.681747] usb 1-3: Product: USB Optical Mouse
[    6.681810] usb 1-3: Manufacturer: Logitech
[    6.903306] hidraw: raw HID events driver (C) Jiri Kosina
[    6.910510] usbcore: registered new interface driver usbhid
[    6.910587] usbhid: USB HID core driver
[    6.913905] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:04.0/usb1/1-3/1-3:1.0/input/input5
[    6.914159] hid-generic 0003:046D:C05B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:04.0-3/input0
[    6.992188] usb 1-5: new low-speed USB device number 3 using ohci-pci
[    7.088332] input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input6
[    7.088640] input: HDA NVidia Line as /devices/pci0000:00/0000:00:08.0/sound/card0/input7
[    7.212058] usb 1-5: New USB device found, idVendor=05ac, idProduct=8242
[    7.212137] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.212203] usb 1-5: Product: IR Receiver
[    7.212272] usb 1-5: Manufacturer: Apple Computer, Inc.
[    7.432974] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.464863] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.514603] loop: module loaded
[    7.532115] usb 1-7: new full-speed USB device number 4 using ohci-pci
[    7.550713] [drm] Initialized drm 1.1.0 20060810
[    7.558106] wmi: Mapper loaded
[    7.567828] ACPI Warning: \_SB_.PCI0.IXVE.IGPU._DSM: Argument #4 type mismatch - Found [Integer], ACPI requires [Package] (20130725/nsarguments-95)
[    7.568160] ACPI Warning: \_SB_.PCI0.IXVE.IGPU._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
[    7.568614] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 22
[    7.568828] [drm] hdmi device  not found 2 0 1
[    7.569394] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
[    7.569460] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
[    7.569530] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    7.571151] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    7.633082] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    7.633155] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    7.633468] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    7.633533] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
[    7.654309] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
[    7.654417] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
[    7.654481] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    7.654546] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
[    7.687282] nouveau  [  PTHERM][0000:02:00.0] FAN control: none / external
[    7.687366] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
[    7.687429] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
[    7.687500] nouveau  [     CLK][0000:02:00.0] 03: core 150 MHz shader 300 MHz
[    7.687575] nouveau  [     CLK][0000:02:00.0] 05: core 150 MHz shader 300 MHz
[    7.687648] nouveau  [     CLK][0000:02:00.0] 0e: core 350 MHz shader 800 MHz
[    7.687721] nouveau  [     CLK][0000:02:00.0] 0f: core 450 MHz shader 1100 MHz
[    7.687806] nouveau E[     CLK][0000:02:00.0] 17 freq unknown
[    7.687867] nouveau E[     CLK][0000:02:00.0] init failed, -22
[    7.687932] nouveau E[     DRM] failed to create 0x80000080, -22
[    7.692470] BUG: unable to handle kernel NULL pointer dereference at 000000000000004c
[    7.692640] IP: [<ffffffffa057f34f>] drm_unplug_minor+0xd/0x31 [drm]
[    7.692757] PGD b7c93067 PUD 0
[    7.692901] Oops: 0000 [#1] SMP
[    7.693049] Modules linked in: nouveau(+) video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop hid_generic usbhid hid snd_hda_codec_realtek arc4 b43 rng_core bcma mac80211 cfg80211 rfkill snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer evdev coretemp snd ssb kvm_intel pcmcia pcmcia_core applesmc ehci_pci ohci_pci ohci_hcd kvm ehci_hcd input_polldev mmc_core i2c_nforce2 pcspkr shpchp soundcore usbcore i2c_core usb_common acpi_cpufreq processor button thermal_sys ext4 crc16 mbcache jbd2 btrfs crc32c libcrc32c xor raid6_pq dm_mod sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ata_generic ahci libahci microcode firewire_ohci libata firewire_core crc_itu_t scsi_mod
[    7.696174] CPU: 1 PID: 1131 Comm: modprobe Not tainted 3.12.0-rc3+ #40
[    7.696174] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
[    7.696174] task: ffff8800b7c33080 ti: ffff8800b7c8e000 task.ti: ffff8800b7c8e000
[    7.696174] RIP: 0010:[<ffffffffa057f34f>]  [<ffffffffa057f34f>] drm_unplug_minor+0xd/0x31 [drm]
[    7.696174] RSP: 0018:ffff8800b7c8fb38  EFLAGS: 00010282
[    7.696174] RAX: 0000000000000000 RBX: ffff8800b8e2a440 RCX: ffffffffa059f737
[    7.696174] RDX: ffffffffa0594610 RSI: ffffffffa059f753 RDI: ffff8800b8e2a440
[    7.696174] RBP: ffff88013acc8000 R08: 0000000000000040 R09: ffff8800b7c8fa78
[    7.696174] R10: ffff8800b7c8fa78 R11: ffff8800b7c8fa78 R12: ffffffffa0669360
[    7.696174] R13: 00000000ffffffea R14: ffff88013acc8098 R15: ffffffffa06692f0
[    7.696174] FS:  0000000000000000(0000) GS:ffff88013fd00000(0063) knlGS:00000000f754db40
[    7.696174] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    7.696174] CR2: 000000000000004c CR3: 00000000b7c38000 CR4: 00000000000407e0
[    7.696174] Stack:
[    7.696174]  ffff8800b8e2a440 ffffffffa057f464 ffff8800b7dff800 ffffffffa057f47f
[    7.696174]  ffff8800b7dff800 ffffffffa05813aa ffff88000000000d 0000000000000000
[    7.696174]  ffff88013acc8000 ffff88013acc8000 ffff88013acb1b20 ffffffffa06692f0
[    7.696174] Call Trace:
[    7.696174]  [<ffffffffa057f464>] ? drm_put_minor+0x35/0x40 [drm]
[    7.696174]  [<ffffffffa057f47f>] ? drm_dev_free+0x10/0x66 [drm]
[    7.696174]  [<ffffffffa05813aa>] ? drm_get_pci_dev+0x10a/0x124 [drm]
[    7.696174]  [<ffffffffa06185a2>] ? nouveau_drm_probe+0x1d1/0x1fb [nouveau]
[    7.696174]  [<ffffffff811e1c57>] ? local_pci_probe+0x34/0x5a
[    7.696174]  [<ffffffff8126c9d5>] ? driver_probe_device+0x1b3/0x1b3
[    7.696174]  [<ffffffff811e1d3e>] ? pci_device_probe+0xc1/0xe5
[    7.696174]  [<ffffffff8126c8b4>] ? driver_probe_device+0x92/0x1b3
[    7.696174]  [<ffffffff8126ca28>] ? __driver_attach+0x53/0x73
[    7.696174]  [<ffffffff8126b018>] ? bus_for_each_dev+0x4e/0x7f
[    7.696174]  [<ffffffff8126c07b>] ? bus_add_driver+0xea/0x232
[    7.696174]  [<ffffffffa0684000>] ? 0xffffffffa0683fff
[    7.696174]  [<ffffffff8126cf6a>] ? driver_register+0x82/0xb5
[    7.696174]  [<ffffffffa0684000>] ? 0xffffffffa0683fff
[    7.696174]  [<ffffffffa0684000>] ? 0xffffffffa0683fff
[    7.696174]  [<ffffffff8100025a>] ? do_one_initcall+0x78/0xf6
[    7.696174]  [<ffffffffa0684000>] ? 0xffffffffa0683fff
[    7.696174]  [<ffffffff8102e9c8>] ? change_page_attr_set+0x23/0x28
[    7.696174]  [<ffffffff810547f3>] ? __blocking_notifier_call_chain+0x4f/0x5d
[    7.696174]  [<ffffffffa0684000>] ? 0xffffffffa0683fff
[    7.696174]  [<ffffffff810848a1>] ? load_module+0x1b11/0x1df7
[    7.696174]  [<ffffffff810817ae>] ? show_initstate+0x41/0x41
[    7.696174]  [<ffffffff81370572>] ? page_fault+0x22/0x30
[    7.696174]  [<ffffffff81084c17>] ? SyS_init_module+0x90/0x9b
[    7.696174]  [<ffffffff813767f5>] ? sysenter_dispatch+0x7/0x1a
[    7.696174] Code: 48 8d 44 24 18 c7 44 24 18 10 00 00 00 48 89 44 24 10 31 c0 e8 98 ab de e0 48 83 c4 68 c3 48 85 ff 53 48 89 fb 74 26 48 8b 47 10 <f6> 40 4c 02 74 1c e8 62 d6 00 00 48 89 df e8 fa 31 00 00 8b 33
[    7.696174] RIP  [<ffffffffa057f34f>] drm_unplug_minor+0xd/0x31 [drm]
[    7.696174]  RSP <ffff8800b7c8fb38>
[    7.696174] CR2: 000000000000004c
[    7.704562] ---[ end trace 3cd6c393a9a969c7 ]---
[    7.756073] usb 1-7: New USB device found, idVendor=17ef, idProduct=6047
[    7.756151] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.756229] usb 1-7: Product: ThinkPad Compact USB Keyboard with TrackPoint
[    7.756294] usb 1-7: Manufacturer: Lenovo
[    7.766623] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:04.0/usb1/1-7/1-7:1.0/input/input8
[    7.766938] hid-generic 0003:17EF:6047.0003: input,hidraw1: USB HID v1.00 Keyboard [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:04.0-7/input0
[    7.776285] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:04.0/usb1/1-7/1-7:1.1/input/input9
[    7.776892] hid-generic 0003:17EF:6047.0004: input,hiddev0,hidraw2: USB HID v1.00 Mouse [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:04.0-7/input1
[    8.328061] usb 4-1: new full-speed USB device number 2 using ohci-pci
[    8.550081] usb 4-1: New USB device found, idVendor=0a5c, idProduct=4500
[    8.550187] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.550254] usb 4-1: Product: BCM2045B2
[    8.550320] usb 4-1: Manufacturer: Broadcom
[    8.553197] hub 4-1:1.0: USB hub found
[    8.556059] hub 4-1:1.0: 3 ports detected
[    8.854079] usb 4-1.1: new full-speed USB device number 3 using ohci-pci
[    8.956061] RPC: Registered named UNIX socket transport module.
[    8.963520] RPC: Registered udp transport module.
[    8.963588] RPC: Registered tcp transport module.
[    8.963649] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.967482] FS-Cache: Loaded
[    8.974392] FS-Cache: Netfs 'nfs' registered for caching
[    8.981081] usb 4-1.1: New USB device found, idVendor=05ac, idProduct=8216
[    8.981151] usb 4-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.981231] usb 4-1.1: Product: Bluetooth USB Host Controller
[    8.981292] usb 4-1.1: Manufacturer: Apple, Inc.
[    8.981355] usb 4-1.1: SerialNumber: 002436EB7CF7
[    8.982020] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.194337] Bluetooth: Core ver 2.16
[    9.194437] NET: Registered protocol family 31
[    9.194499] Bluetooth: HCI device and connection manager initialized
[    9.194719] Bluetooth: HCI socket layer initialized
[    9.194783] Bluetooth: L2CAP socket layer initialized
[    9.194851] Bluetooth: SCO socket layer initialized
[    9.196967] usbcore: registered new interface driver btusb
[   10.414882] Ebtables v2.0 registered
[   10.425528] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.435630] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   10.488836] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input10
[   11.340470] postgres (3450): /proc/3450/oom_adj is deprecated, please use /proc/3450/oom_score_adj instead.
[   17.687914] SysRq : Resetting

More variations of the same bug:

https://thomas.glanzmann.de/tmp/nouveau_breakage.txt

So I bisected it and found that commit
7c856522069755ab9d163a24ac332cd3cb35fe30 is the culprit. Please advise.
It panics before X is started. I'm available for regression testing.

commit 7c856522069755ab9d163a24ac332cd3cb35fe30
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 14 08:28:28 2013 +1000

    drm/nouveau/clk: implement power state and engine clock control in core

    User control of this has been hard-coded as disabled for now.

    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

LSPCI Output:

02:00.0 VGA compatible controller: NVIDIA Corporation C79 [GeForce 9400] (rev b1) (prog-if 00 [VGA controller])
        Subsystem: Apple Inc. Device 00ae
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 256 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Region 3: Memory at d0000000 (64-bit, prefetchable) [size=32M]
        Region 5: I/O ports at 1000 [size=128]
        Expansion ROM at d3000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: nouveau

(mini) [/scratch/linux-2.6] git bisect log
# bad: [002acf1fc16cf60e60345bd68e03734628505b83] Merge tag 'pm-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
# good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
git bisect start 'HEAD' 'v3.12'
# good: [5cbb3d216e2041700231bcfc383ee5f8b7fc8b74] Merge branch 'akpm' (patches from Andrew Morton)
git bisect good 5cbb3d216e2041700231bcfc383ee5f8b7fc8b74
# good: [eda670c626a4f53eb8ac5f20d8c10d3f0b54c583] Merge tag 'stable/for-linus-3.13-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
git bisect good eda670c626a4f53eb8ac5f20d8c10d3f0b54c583
# bad: [cdd278db0e3dd714e8076e58f723f3c59547591b] Merge branch 'linux_next' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac
git bisect bad cdd278db0e3dd714e8076e58f723f3c59547591b
# bad: [a3483353ca4e6dbeef2ed62ebed01af109b5b27a] drm: check for !kdev in drm_unplug_minor()
git bisect bad a3483353ca4e6dbeef2ed62ebed01af109b5b27a
# good: [ddb642fb0566758ace34384538720db0e24bcd4c] drm/i915: rename i915_init_power_well to init_power_domains_init
git bisect good ddb642fb0566758ace34384538720db0e24bcd4c
# good: [9e2b734f1cc43e94558bfd2b779d8e493abea0f4] drm/nouveau/i2c: use a custom bitbanging delay for the adt7473
git bisect good 9e2b734f1cc43e94558bfd2b779d8e493abea0f4
# bad: [8d0a2215931f1ffd77aef65cae2c0becc3f5d560] Merge branch 'drm-next-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-next
git bisect bad 8d0a2215931f1ffd77aef65cae2c0becc3f5d560
# bad: [21136946c495b0e1e0f7e25a8de6f170efbdeadf] drm/vmwgfx: fix warning if config intel iommu is off.
git bisect bad 21136946c495b0e1e0f7e25a8de6f170efbdeadf
# good: [09b8d73bd5aa4a4897d2fa603e683f09ac7e9916] drm/nvc0/therm: allow fan control if we've killed the vbios ppwr ucode
git bisect good 09b8d73bd5aa4a4897d2fa603e683f09ac7e9916
# good: [0833428e7d1b250afbd41e0a4c8c247cccd15aad] drm/nouveau/bios: parsing for various tables required for power management
git bisect good 0833428e7d1b250afbd41e0a4c8c247cccd15aad
# bad: [26fdd78cce3f51a49e1f2d3ad27ee893a28d220e] drm/nouveau: implement a simple sysfs interface to new pm code
git bisect bad 26fdd78cce3f51a49e1f2d3ad27ee893a28d220e
# bad: [7c856522069755ab9d163a24ac332cd3cb35fe30] drm/nouveau/clk: implement power state and engine clock control in core
git bisect bad 7c856522069755ab9d163a24ac332cd3cb35fe30
# good: [c9c0ccae48e27b767e98a4c120976e43195dd3a7] drm/nouveau/volt: implement voltage control in core
git bisect good c9c0ccae48e27b767e98a4c120976e43195dd3a7

Cheers,
        Thomas
