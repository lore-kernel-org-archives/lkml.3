Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaFMKF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:05:56 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:50604 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaFMKFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:05:52 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2014 06:05:51 EDT
Date: Fri, 13 Jun 2014 11:58:20 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>
Subject: REGRESSION: Kernel PANIC 8777c5c11764d8336d8270f96778158c34c92108 -
 drm/nouveau/dp: probe dpcd to determine connectedness
Message-ID: <20140613095820.GA21162@glanzmann.de>
Mail-Followup-To: Ben Skeggs <bskeggs@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	nouveau <nouveau@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,
commit

(mini) [~/work/linux-2.6] git bisect bad
8777c5c11764d8336d8270f96778158c34c92108 is the first bad commit
commit 8777c5c11764d8336d8270f96778158c34c92108
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jun 6 18:09:55 2014 +1000

    drm/nouveau/dp: probe dpcd to determine connectedness

    Signed-off-by: Ben Skeggs <bskeggs@redhat.com> 

introduces a regression: My Mac Mini panics when I start X:

[    5.173109] usb 4-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.182343] input: HID 05ac:820a as /devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.2/4-1.2:1.0/input/input3
[    5.182490] generic-usb 0003:05AC:820A.0005: input,hidraw4: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:06.0-1.2/input0
[    5.258031] usb 4-1.3: new full-speed USB device number 6 using ohci_hcd
[    5.353602] udevd[413]: starting version 175
[    5.373034] usb 4-1.3: New USB device found, idVendor=05ac, idProduct=820b
[    5.373109] usb 4-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.382321] input: HID 05ac:820b as /devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.3/4-1.3:1.0/input/input4
[    5.382511] generic-usb 0003:05AC:820B.0006: input,hidraw5: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:06.0-1.3/input0
[    5.450205] ACPI: Requesting acpi_cpufreq
[    5.451449] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input5
[    5.451498] ACPI: Power Button [PWRB]
[    5.451593] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input6
[    5.451630] ACPI: Sleep Button [SLPB]
[    5.452584] i2c i2c-0: nForce2 SMBus adapter at 0x2140
[    5.452646] i2c i2c-1: nForce2 SMBus adapter at 0x2100
[    5.459554] Marking TSC unstable due to TSC halts in idle
[    5.460190] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input7
[    5.460237] ACPI: Power Button [PWRF]
[    5.476086] Switching to clocksource hpet
[    5.542565] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.548648] input: PC Speaker as /devices/platform/pcspkr/input/input8
[    5.562654] cfg80211: Calling CRDA to update world regulatory domain
[    5.611694] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[    5.611768] hda_intel: Disabling MSI
[    5.616818] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
[    5.643615] cfg80211: World regulatory domain updated:
[    5.643687] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    5.643763] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.643838] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.643910] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.643985] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.644087] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.665166] applesmc: key=154 fan=1 temp=8 acc=0 lux=0 kbd=0
[    5.688998] Broadcom 43xx driver loaded [ Features: PMNLS ]
[    6.071334] Bluetooth: Core ver 2.16
[    6.071432] NET: Registered protocol family 31
[    6.071497] Bluetooth: HCI device and connection manager initialized
[    6.071564] Bluetooth: HCI socket layer initialized
[    6.079065] Bluetooth: L2CAP socket layer initialized
[    6.082838] Bluetooth: SCO socket layer initialized
[    6.083214] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    6.083822] usbcore: registered new interface driver btusb
[    6.094120] usb 4-1.2: USB disconnect, device number 5
[    6.233321] hda_codec: ALC889A: SKU not ready 0x400000f0
[    6.308136] usb 4-1.3: USB disconnect, device number 6
[    6.384293] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:08.0/input/input9
[    6.576851] input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input10
[    7.394974] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.429089] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.472205] loop: module loaded
[    7.509903] [drm] Initialized drm 1.1.0 20060810
[    7.516271] wmi: Mapper loaded
[    7.526861] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 22
[    7.527880] [drm] nouveau 0000:02:00.0: Detected an NV50 generation card (0x0ac080b1)
[    7.536263] [drm] nouveau 0000:02:00.0: Checking PRAMIN for VBIOS
[    7.598520] [drm] nouveau 0000:02:00.0: ... appears to be valid
[    7.598589] [drm] nouveau 0000:02:00.0: Using VBIOS from PRAMIN
[    7.598661] [drm] nouveau 0000:02:00.0: BIT BIOS found
[    7.598723] [drm] nouveau 0000:02:00.0: Bios version 62.79.4e.00
[    7.598789] [drm] nouveau 0000:02:00.0: TMDS table version 2.0
[    7.600693] [drm] nouveau 0000:02:00.0: MXM: no VBIOS data, nothing to do
[    7.600759] [drm] nouveau 0000:02:00.0: DCB version 4.0
[    7.600829] [drm] nouveau 0000:02:00.0: DCB outp 00: 02021286 0f220010
[    7.600892] [drm] nouveau 0000:02:00.0: DCB outp 01: 01000122 00000010
[    7.600957] [drm] nouveau 0000:02:00.0: DCB outp 02: 01000120 0000001e
[    7.601022] [drm] nouveau 0000:02:00.0: DCB outp 03: 02021232 00000010
[    7.601087] [drm] nouveau 0000:02:00.0: DCB conn 00: 00001020
[    7.601198] [drm] nouveau 0000:02:00.0: DCB conn 01: 0000a146
[    7.601307] [drm] nouveau 0000:02:00.0: DCB conn 02: 00005246
[    7.601421] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 0 at offset 0xD97C
[    7.686005] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 1 at offset 0xDC3E
[    7.686087] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 2 at offset 0xDC40
[    7.686174] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 3 at offset 0xDD01
[    7.686255] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 4 at offset 0xDDC6
[    7.686327] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table at offset 0xDE2B
[    7.706245] [drm] nouveau 0000:02:00.0: 0xDE2B: Condition still not met after 20ms, skipping following opcodes
[    7.746254] [TTM] Zone  kernel: Available graphics memory: 1887798 kiB
[    7.746327] [TTM] Initializing pool allocator
[    7.746404] [TTM] Initializing DMA pool allocator
[    7.746479] [drm] nouveau 0000:02:00.0: Detected 256MiB VRAM (DDR1)
[    7.746542] [drm] nouveau 0000:02:00.0: Stolen system memory at: 0x0080000000
[    7.748198] [drm] nouveau 0000:02:00.0: 64 MiB GART (aperture)
[    7.769820] [drm] nouveau 0000:02:00.0: unknown connector type 20
[    7.771064] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    7.771129] [drm] No driver support for vblank timestamp query.
[    7.944268] [drm] nouveau 0000:02:00.0: 4 available performance level(s)
[    7.944340] [drm] nouveau 0000:02:00.0: 0: core 150MHz shader 300MHz voltage 900mV fanspeed 100%
[    7.944426] [drm] nouveau 0000:02:00.0: 1: core 150MHz shader 300MHz voltage 900mV fanspeed 100%
[    7.944502] [drm] nouveau 0000:02:00.0: 2: core 350MHz shader 800MHz voltage 900mV fanspeed 100%
[    7.944580] [drm] nouveau 0000:02:00.0: 3: core 450MHz shader 1100MHz voltage 1010mV fanspeed 100%
[    7.944655] [drm] nouveau 0000:02:00.0: c:
[    8.079222] [drm] nouveau 0000:02:00.0: allocated 1920x1200 fb: 0x2f0000, bo ffff880138302000
[    8.080159] fbcon: nouveaufb (fb0) is primary device
[    8.105153] Console: switching to colour frame buffer device 240x75
[    8.109197] fb0: nouveaufb frame buffer device
[    8.109207] drm: registered panic notifier
[    8.109948] [drm] Initialized nouveau 1.0.0 20120316 for 0000:02:00.0 on minor 0
[    9.108265] RPC: Registered named UNIX socket transport module.
[    9.108296] RPC: Registered udp transport module.
[    9.108318] RPC: Registered tcp transport module.
[    9.108330] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    9.116459] FS-Cache: Loaded
[    9.127826] FS-Cache: Netfs 'nfs' registered for caching
[    9.133387] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.502073] NET: Registered protocol family 15
[    9.503786] alg: No test for cipher_null (cipher_null-generic)
[    9.503829] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    9.503863] alg: No test for digest_null (digest_null-generic)
[    9.503896] alg: No test for compress_null (compress_null-generic)
[    9.512190] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[   10.495752] lp: driver loaded but no devices found
[   10.499656] ppdev: user-space parallel port driver
[   10.800810] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input11
[   11.111500] Ebtables v2.0 registered
[   11.158231] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.206365] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   14.096129] postgres (3746): /proc/3746/oom_adj is deprecated, please use /proc/3746/oom_score_adj instead.
^C
(gateway) [~]
(gateway) [~] nc -u -l -p 6666
[  152.191174] Bridge firewalling registered
[  152.396039] Ebtables v2.0 unregistered
[    4.680003]    generic_sse:  6108.000 MB/sec
[    4.680064] xor: using function: prefetch64-sse (6887.000 MB/sec)
[    4.750588] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    5.012771] udevd[439]: starting version 175
[    5.093780] i2c i2c-0: nForce2 SMBus adapter at 0x2140
[    5.093925] i2c i2c-1: nForce2 SMBus adapter at 0x2100
[    5.112529] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.124085] tsc: Marking TSC unstable due to TSC halts in idle
[    5.128091] Switched to clocksource hpet
[    5.130867] ACPI: bus type USB registered
[    5.133906] usbcore: registered new interface driver usbfs
[    5.134009] usbcore: registered new interface driver hub
[    5.136237] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.136330] ACPI: Power Button [PWRB]
[    5.139218] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    5.139337] usbcore: registered new device driver usb
[    5.140436] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.141024] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    5.141109] ACPI: Sleep Button [SLPB]
[    5.141555] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.141635] ehci-pci: EHCI PCI platform driver
[    5.142026] ohci-pci: OHCI PCI platform driver
[    5.142052] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    5.142055] ACPI: Power Button [PWRF]
[    5.143908] ehci-pci 0000:00:04.1: EHCI Host Controller
[    5.144000] ehci-pci 0000:00:04.1: new USB bus registered, assigned bus number 1
[    5.145858] ehci-pci 0000:00:04.1: debug port 1
[    5.145979] ehci-pci 0000:00:04.1: irq 22, io mem 0xd3489200
[    5.156034] ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    5.156183] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.156248] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.156325] usb usb1: Product: EHCI Host Controller
[    5.156388] usb usb1: Manufacturer: Linux 3.15.0-rc8+ ehci_hcd
[    5.156452] usb usb1: SerialNumber: 0000:00:04.1
[    5.160216] hub 1-0:1.0: USB hub found
[    5.160679] hub 1-0:1.0: 7 ports detected
[    5.171974] ohci-pci 0000:00:04.0: OHCI PCI host controller
[    5.172085] ohci-pci 0000:00:04.0: new USB bus registered, assigned bus number 2
[    5.172202] ohci-pci 0000:00:04.0: irq 23, io mem 0xd3488000
[    5.200311] ssb: Found chip with id 0x4321, rev 0x05 and package 0x00
[    5.234536] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.234611] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.234694] usb usb2: Product: OHCI PCI host controller
[    5.234755] usb usb2: Manufacturer: Linux 3.15.0-rc8+ ohci_hcd
[    5.234820] usb usb2: SerialNumber: 0000:00:04.0
[    5.235718] hub 2-0:1.0: USB hub found
[    5.235795] hub 2-0:1.0: 7 ports detected
[    5.237073] ohci-pci 0000:00:06.0: OHCI PCI host controller
[    5.237150] ohci-pci 0000:00:06.0: new USB bus registered, assigned bus number 3
[    5.237267] ohci-pci 0000:00:06.0: irq 21, io mem 0xd3487000
[    5.269169] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
[    5.296645] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.296716] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.296806] usb usb3: Product: OHCI PCI host controller
[    5.296868] usb usb3: Manufacturer: Linux 3.15.0-rc8+ ohci_hcd
[    5.296937] usb usb3: SerialNumber: 0000:00:06.0
[    5.297185] hub 3-0:1.0: USB hub found
[    5.297257] hub 3-0:1.0: 5 ports detected
[    5.298158] ehci-pci 0000:00:06.1: EHCI Host Controller
[    5.298234] ehci-pci 0000:00:06.1: new USB bus registered, assigned bus number 4
[    5.298317] ehci-pci 0000:00:06.1: debug port 1
[    5.298418] ehci-pci 0000:00:06.1: irq 20, io mem 0xd3489100
[    5.309564] ehci-pci 0000:00:06.1: USB 2.0 started, EHCI 1.00
[    5.309713] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    5.309786] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.309870] usb usb4: Product: EHCI Host Controller
[    5.309943] usb usb4: Manufacturer: Linux 3.15.0-rc8+ ehci_hcd
[    5.310016] usb usb4: SerialNumber: 0000:00:06.1
[    5.310310] hub 4-0:1.0: USB hub found
[    5.310432] hub 4-0:1.0: 5 ports detected
[    5.321512] cfg80211: Calling CRDA to update world regulatory domain
[    5.328256] random: nonblocking pool is initialized
[    5.342663] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
[    5.368633] cfg80211: World regulatory domain updated:
[    5.368702] cfg80211:  DFS Master region: unset
[    5.368755] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.368886] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.368960] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.369037] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.369111] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.369184] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.372104] hub 3-0:1.0: USB hub found
[    5.372220] hub 3-0:1.0: 5 ports detected
[    5.373780] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[    5.373853] snd_hda_intel 0000:00:08.0: Disabling MSI
[    5.384248] b43-phy0: Found PHY: Analog 5, Type 4 (N), Revision 2
[    5.401739] applesmc: key=154 fan=1 temp=8 index=8 acc=0 lux=0 kbd=0
[    5.408373] Broadcom 43xx driver loaded [ Features: PMNLS ]
[    5.976087] sound hdaudioC0D0: ALC889A: SKU not ready 0x400000f0
[    6.016051] sound hdaudioC0D0: autoconfig: line_outs=1 (0x18/0x0/0x0/0x0/0x0) type:speaker
[    6.016142] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    6.016209] sound hdaudioC0D0:    hp_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    6.016273] sound hdaudioC0D0:    mono: mono_out=0x0
[    6.016337] sound hdaudioC0D0:    dig-out=0x1e/0x0
[    6.016400] sound hdaudioC0D0:    inputs:
[    6.016464] sound hdaudioC0D0:      Line=0x15
[    6.016527] sound hdaudioC0D0:    dig-in=0x1f
[    6.267037] EXT4-fs (sda1): re-mounted. Opts: (null)
[    6.304973] EXT4-fs (sda1): re-mounted. Opts: (null)
[    6.355928] loop: module loaded
[    6.391238] [drm] Initialized drm 1.1.0 20060810
[    6.396438] wmi: Mapper loaded
[    6.408805] ACPI Warning: \_SB_.PCI0.IXVE.IGPU._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140214/nsarguments-95)
[    6.409002] ACPI: \_SB_.PCI0.IXVE.IGPU: failed to evaluate _DSM
[    6.409319] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 22
[    6.410309] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
[    6.410380] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
[    6.410442] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    6.411772] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    6.473582] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    6.473654] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    6.473958] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    6.474021] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
[    6.474206] usb 2-3: new low-speed USB device number 2 using ohci-pci
[    6.496927] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
[    6.497028] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
[    6.497091] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    6.497154] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
[    6.533217] nouveau  [  PTHERM][0000:02:00.0] FAN control: none / external
[    6.533298] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
[    6.533366] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
[    6.533440] nouveau  [     CLK][0000:02:00.0] 03: core 150 MHz shader 300 MHz vdec 150 MHz
[    6.533524] nouveau  [     CLK][0000:02:00.0] 05: core 150 MHz shader 300 MHz vdec 150 MHz
[    6.533600] nouveau  [     CLK][0000:02:00.0] 0e: core 350 MHz shader 800 MHz vdec 350 MHz
[    6.533679] nouveau  [     CLK][0000:02:00.0] 0f: core 450 MHz shader 1100 MHz vdec 450 MHz
[    6.533771] nouveau  [     CLK][0000:02:00.0] --: core 350 MHz shader 800 MHz vdec 350 MHz
[    6.534010] [TTM] Zone  kernel: Available graphics memory: 1887582 kiB
[    6.534072] [TTM] Initializing pool allocator
[    6.534143] [TTM] Initializing DMA pool allocator
[    6.534220] nouveau  [     DRM] VRAM: 256 MiB
[    6.534284] nouveau  [     DRM] GART: 1048576 MiB
[    6.534352] nouveau  [     DRM] TMDS table version 2.0
[    6.534417] nouveau  [     DRM] DCB version 4.0
[    6.534482] nouveau  [     DRM] DCB outp 00: 02021286 0f220010
[    6.534549] nouveau  [     DRM] DCB outp 01: 01000122 00000010
[    6.534615] nouveau  [     DRM] DCB outp 02: 01000120 0000001e
[    6.534682] nouveau  [     DRM] DCB outp 03: 02021232 00000010
[    6.534748] nouveau  [     DRM] DCB conn 00: 00001020
[    6.534861] nouveau  [     DRM] DCB conn 01: 0000a146
[    6.534977] nouveau  [     DRM] DCB conn 02: 00005246
[    6.545624] nouveau W[     DRM] unknown connector type 20
[    6.546314] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.546380] [drm] Driver supports precise vblank timestamp query.
[    6.559193] nouveau  [     DRM] MM: using M2MF for buffer copies
[    6.673981] nouveau  [     DRM] allocated 1920x1200 fb: 0x50000, bo ffff8800b824dc00
[    6.675213] fbcon: nouveaufb (fb0) is primary device
[    6.688057] usb 2-3: New USB device found, idVendor=046d, idProduct=c05b
[    6.688059] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.688060] usb 2-3: Product: USB Optical Mouse
[    6.688062] usb 2-3: Manufacturer: Logitech
[    6.750107] Console: switching to colour frame buffer device 240x75
[    6.754071] nouveau 0000:02:00.0: fb0: nouveaufb frame buffer device
[    6.754089] nouveau 0000:02:00.0: registered panic notifier
[    6.754112] [drm] Initialized nouveau 1.1.1 20120801 for 0000:02:00.0 on minor 0
[    6.868068] usb 2-5: new low-speed USB device number 3 using ohci-pci
[    7.087070] usb 2-5: New USB device found, idVendor=05ac, idProduct=8242
[    7.087108] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.087124] usb 2-5: Product: IR Receiver
[    7.087136] usb 2-5: Manufacturer: Apple Computer, Inc.
[    7.276736] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:08.0/sound/card0/hdaudioC0D0/input4
[    7.280666] input: HDA NVidia Line as /devices/pci0000:00/0000:00:08.0/sound/card0/input5
[    7.280824] input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input6
[    7.404081] usb 3-1: new full-speed USB device number 2 using ohci-pci
[    7.629609] usb 3-1: New USB device found, idVendor=0a5c, idProduct=4500
[    7.629645] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.629659] usb 3-1: Product: BCM2045B2
[    7.629669] usb 3-1: Manufacturer: Broadcom
[    7.632691] hub 3-1:1.0: USB hub found
[    7.635617] hub 3-1:1.0: 3 ports detected
[    7.815756] RPC: Registered named UNIX socket transport module.
[    7.815789] RPC: Registered udp transport module.
[    7.815801] RPC: Registered tcp transport module.
[    7.815811] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.819784] FS-Cache: Loaded
[    7.826404] FS-Cache: Netfs 'nfs' registered for caching
[    7.834031] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.956070] usb 3-4: new full-speed USB device number 3 using ohci-pci
[    8.183617] usb 3-4: New USB device found, idVendor=17ef, idProduct=6047
[    8.184285] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.184910] usb 3-4: Product: ThinkPad Compact USB Keyboard with TrackPoint
[    8.185492] usb 3-4: Manufacturer: Lenovo
[    8.367767] NET: Registered protocol family 15
[    8.521624] usb 3-1.1: new full-speed USB device number 4 using ohci-pci
[    8.553829] hidraw: raw HID events driver (C) Jiri Kosina
[    8.584633] usbcore: registered new interface driver usbhid
[    8.585137] usbhid: USB HID core driver
[    8.589534] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:04.0/usb2/2-3/2-3:1.0/0003:046D:C05B.0001/input/input7
[    8.591953] hid-generic 0003:046D:C05B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:04.0-3/input0
[    8.592799] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:06.0/usb3/3-4/3-4:1.0/0003:17EF:6047.0003/input/input8
[    8.594803] hid-generic 0003:17EF:6047.0003: input,hidraw1: USB HID v1.00 Keyboard [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:06.0-4/input0
[    8.595958] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:06.0/usb3/3-4/3-4:1.1/0003:17EF:6047.0004/input/input9
[    8.597332] hid-generic 0003:17EF:6047.0004: input,hiddev0,hidraw2: USB HID v1.00 Mouse [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:06.0-4/input1
[    8.644599] usb 3-1.1: New USB device found, idVendor=05ac, idProduct=8216
[    8.645110] usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.645872] usb 3-1.1: Product: Bluetooth USB Host Controller
[    8.646911] usb 3-1.1: Manufacturer: Apple, Inc.
[    8.647945] usb 3-1.1: SerialNumber: 002436EB7CF7
[    8.861827] Bluetooth: Core ver 2.19
[    8.863573] NET: Registered protocol family 31
[    8.864087] Bluetooth: HCI device and connection manager initialized
[    8.864535] Bluetooth: HCI socket layer initialized
[    8.864537] Bluetooth: L2CAP socket layer initialized
[    8.864546] Bluetooth: SCO socket layer initialized
[    8.886612] usbcore: registered new interface driver btusb
[    9.479753] lp: driver loaded but no devices found
[    9.487961] ppdev: user-space parallel port driver
[    9.640232] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input10
[    9.856443] Ebtables v2.0 registered
[    9.870685] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.886109] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   11.848300] postgres (4055): /proc/4055/oom_adj is deprecated, please use /proc/4055/oom_score_adj instead.
[   17.607636] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[   17.607678] IP: [<ffffffffa055f901>] exec_clkcmp+0x15e/0x2be [nouveau]
[   17.607729] PGD 0
[   17.607740] Oops: 0000 [#1] SMP
[   17.607755] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport autofs4 ecb btusb bluetooth uinput hid_generic usbhid hid deflate ctr twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common blowfish_generic blowfish_x86_64 blowfish_common des_generic cbc xcbc rmd160 sha512_generic sha256_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop snd_hda_codec_realtek snd_hda_codec_generic arc4 b43 rng_core bcma mac80211 cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec rfkill snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi evdev snd_seq applesmc snd_seq_device input_polldev snd_timer coretemp snd kvm_intel ssb pcmcia kvm pcmcia_core ohci_pci ehci_pci ohci_hcd ehci_hcd mmc_core pcspkr acpi_cpufreq button soundcore processor usbcore thermal_sys shpchp usb_common i2c_nforce2 i2c_core ext4 crc16 jbd2 mbcache xor raid6_pq dm_mod netconsole configfs sg sd_mod sr_mod cdrom crc_t10dif crct10dif_common ata_generic microcode firewire_ohci firewire_core crc_itu_t ahci libahci libata forcedeth scsi_mod
[   17.608348] CPU: 0 PID: 249 Comm: kworker/0:2 Not tainted 3.15.0-rc8+ #162
[   17.608359] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
[   17.608395] Workqueue: events nv50_disp_intr_supervisor [nouveau]
[   17.608408] task: ffff8800b9184bd0 ti: ffff88013aa74000 task.ti: ffff88013aa74000
[   17.608419] RIP: 0010:[<ffffffffa055f901>]  [<ffffffffa055f901>] exec_clkcmp+0x15e/0x2be [nouveau]
[   17.608456] RSP: 0000:ffff88013aa77ce8  EFLAGS: 00010202
[   17.608465] RAX: 0000000000000000 RBX: ffff88003748f400 RCX: ffff88003748f4a0
[   17.608475] RDX: 0000000000000141 RSI: 0000000000000002 RDI: ffff8800b9703940
[   17.608485] RBP: 0000000000000000 R08: 0000000000000040 R09: ffff88013aa77d28
[   17.608496] R10: ffff88013fc12e80 R11: ffff88013fc12e80 R12: ffff88013aa77e04
[   17.608507] R13: 0000000000025990 R14: ffff8800b9703940 R15: 0000000000002101
[   17.608518] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[   17.608529] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   17.608538] CR2: 0000000000000040 CR3: 0000000001610000 CR4: 00000000000407f0
[   17.608547] Stack:
[   17.608553]  ffff88013aa77d29 ffff88013aa77d2a ffff88013aa77d2b ffff88013aa77d36
[   17.608575]  0000000000000000 0000000000000000 0000000000610794 000000ff00000000
[   17.608596]  0000000200000000 0000000000000000 ffff88013fc0d320 0000000000000000
[   17.608619] Call Trace:
[   17.608632]  [<ffffffff8105f229>] ? sched_clock_local+0xd/0x6f
[   17.608667]  [<ffffffffa056035d>] ? nv50_disp_intr_supervisor+0x1c3/0x702 [nouveau]
[   17.608681]  [<ffffffff810594c2>] ? mmdrop+0xd/0x1c
[   17.608693]  [<ffffffff8104d5c0>] ? process_one_work+0x191/0x293
[   17.608705]  [<ffffffff8104d808>] ? worker_thread+0x121/0x1e7
[   17.608715]  [<ffffffff8104d6e7>] ? process_scheduled_works+0x25/0x25
[   17.608727]  [<ffffffff810521de>] ? kthread+0x99/0xa1
[   17.608738]  [<ffffffff81052145>] ? __kthread_parkme+0x59/0x59
[   17.608749]  [<ffffffff813880bc>] ? ret_from_fork+0x7c/0xb0
[   17.608760]  [<ffffffff81052145>] ? __kthread_parkme+0x59/0x59
[   17.608769] Code: 48 89 df 48 89 44 24 10 48 8d 44 24 42 48 89 44 24 08 48 8d 44 24 41 48 89 04 24 e8 55 fb ff ff 8b 74 24 44 48 89 c5 85 f6 74 ac <80> 78 40 00 75 5e 8b 40 38 83 f8 03 74 2c 83 f8 06 74 33 83 f8
[   17.608986] RIP  [<ffffffffa055f901>] exec_clkcmp+0x15e/0x2be [nouveau]
[   17.609022]  RSP <ffff88013aa77ce8>
[   17.609145] CR2: 0000000000000040
[   22.475239] ---[ end trace 6f1e0944641fce9e ]---
[   22.475689] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   22.475718] IP: [<ffffffff8105260f>] kthread_data+0x7/0xc
[   22.475738] PGD 1611067 PUD 1613067 PMD 0
[   22.475758] Oops: 0000 [#2] SMP
[   22.475773] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport autofs4 ecb btusb bluetooth uinput hid_generic usbhid hid deflate ctr twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common blowfish_generic blowfish_x86_64 blowfish_common des_generic cbc xcbc rmd160 sha512_generic sha256_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop snd_hda_codec_realtek snd_hda_codec_generic arc4 b43 rng_core bcma mac80211 cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec rfkill snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi evdev snd_seq applesmc snd_seq_device input_polldev snd_timer coretemp snd kvm_intel ssb pcmcia kvm pcmcia_core ohci_pci ehci_pci ohci_hcd ehci_hcd mmc_core pcspkr acpi_cpufreq button soundcore processor usbcore thermal_sys shpchp usb_common i2c_nforce2 i2c_core ext4 crc16 jbd2 mbcache xor raid6_pq dm_mod netconsole configfs sg sd_mod sr_mod cdrom crc_t10dif crct10dif_common ata_generic microcode firewire_ohci firewire_core crc_itu_t ahci libahci libata forcedeth scsi_mod
[   22.476008] CPU: 0 PID: 249 Comm: kworker/0:2 Tainted: G      D       3.15.0-rc8+ #162
[   22.476008] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
[   22.476008] task: ffff8800b9184bd0 ti: ffff88013aa74000 task.ti: ffff88013aa74000
[   22.476008] RIP: 0010:[<ffffffff8105260f>]  [<ffffffff8105260f>] kthread_data+0x7/0xc
[   22.476008] RSP: 0018:ffff88013aa779a0  EFLAGS: 00010002
[   22.476008] RAX: 0000000000000000 RBX: ffff88013fc12e80 RCX: ffff88013fc12ef0
[   22.476008] RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff8800b9184bd0
[   22.476008] RBP: 0000000000000000 R08: ffffffff817c0480 R09: 000000000000b64a
[   22.476008] R10: 000000000000002f R11: 000000000000bb9b R12: 0000000000000000
[   22.476008] R13: ffff8800b9185028 R14: ffff8800b9184f20 R15: ffff88013b2cd090
[   22.476008] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[   22.476008] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   22.476008] CR2: 0000000000000028 CR3: 0000000037457000 CR4: 00000000000407f0
[   22.476008] Stack:
[   22.476008]  ffffffff8104de14 ffff8800b9184bd0 ffff88013fc12e80 ffff8800b9184bd0
[   22.476008]  ffffffff81380ad9 ffff88013b2cd090 0000000000000086 0000000000012e80
[   22.476008]  0000000000012e80 ffff8800b9184bd0 ffff88013aa77fd8 0000000000000246
[   22.476008] Call Trace:
[   22.476008]  [<ffffffff8104de14>] ? wq_worker_sleeping+0xa/0x80
[   22.476008]  [<ffffffff81380ad9>] ? __schedule+0x131/0x4f4
[   22.476008]  [<ffffffff8103b7fc>] ? do_exit+0x8f0/0x907
[   22.476008]  [<ffffffff81383f17>] ? oops_end+0x9c/0xa1
[   22.476008]  [<ffffffff8137c590>] ? no_context+0x289/0x2b4
[   22.476008]  [<ffffffff81059f82>] ? finish_task_switch+0x7f/0xbf
[   22.476008]  [<ffffffff81385f67>] ? __do_page_fault+0x34d/0x3e0
[   22.476008]  [<ffffffff810622fe>] ? find_busiest_group+0x14e/0x4c4
[   22.476008]  [<ffffffff813835a2>] ? page_fault+0x22/0x30
[   22.476008]  [<ffffffffa055f901>] ? exec_clkcmp+0x15e/0x2be [nouveau]
[   22.476008]  [<ffffffffa055f8f6>] ? exec_clkcmp+0x153/0x2be [nouveau]
[   22.476008]  [<ffffffff8105f229>] ? sched_clock_local+0xd/0x6f
[   22.476008]  [<ffffffffa056035d>] ? nv50_disp_intr_supervisor+0x1c3/0x702 [nouveau]
[   22.476008]  [<ffffffff810594c2>] ? mmdrop+0xd/0x1c
[   22.476008]  [<ffffffff8104d5c0>] ? process_one_work+0x191/0x293
[   22.476008]  [<ffffffff8104d808>] ? worker_thread+0x121/0x1e7
[   22.476008]  [<ffffffff8104d6e7>] ? process_scheduled_works+0x25/0x25
[   22.476008]  [<ffffffff810521de>] ? kthread+0x99/0xa1
[   22.476008]  [<ffffffff81052145>] ? __kthread_parkme+0x59/0x59
[   22.476008]  [<ffffffff813880bc>] ? ret_from_fork+0x7c/0xb0
[   22.476008]  [<ffffffff81052145>] ? __kthread_parkme+0x59/0x59
[   22.476008] Code: c4 88 00 00 00 5b 5d c3 65 48 8b 04 25 80 b9 00 00 48 8b 80 00 04 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 48 8b 87 00 04 00 00 <48> 8b 40 d8 c3 48 83 ec 18 48 8b b7 00

(mini) [~/work/linux-2.6] lspci | grep -i vga
02:00.0 VGA compatible controller: NVIDIA Corporation C79 [GeForce 9400] (rev b1)
(mini) [~/work/linux-2.6] lspci -nv | grep -A 10 02:00.0
02:00.0 0300: 10de:0861 (rev b1) (prog-if 00 [VGA controller])
        Subsystem: 106b:00ae
        Flags: bus master, fast devsel, latency 0, IRQ 22
        Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at d0000000 (64-bit, prefetchable) [size=32M]
        I/O ports at 1000 [size=128]
        Expansion ROM at d3000000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: nouveau

(mini) [~/work/linux-2.6] git bisect log
# bad: [c1fdb2d3389c5a1e7c559a37a4967c1d2580e75c] Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
# good: [dfb945473ae8528fd885607b6fa843c676745e0c] Merge git://www.linux-watchdog.org/linux-watchdog
git bisect start 'HEAD' 'v3.15-8556-gdfb9454'
# good: [f3591fd4c9881889dfa9203328a89316fcc834e1] Merge branch 'inet_csums'
git bisect good f3591fd4c9881889dfa9203328a89316fcc834e1
# bad: [bc1dfff04a5d4064ba0db1fab13f84ab4f333d2b] Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
git bisect bad bc1dfff04a5d4064ba0db1fab13f84ab4f333d2b
# good: [4fa62c890cea83f28c30e1d5dc8fc86f61210280] drm/i915: Move buffer pinning and ring selection to intel_crtc_page_flip()
git bisect good 4fa62c890cea83f28c30e1d5dc8fc86f61210280
# good: [b33a51e457b7e01e3e25eaa7c99aec32e65c00de] Merge branch 'exynos-drm-next' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next
git bisect good b33a51e457b7e01e3e25eaa7c99aec32e65c00de
# good: [5330fb412948420be83d1d247b79d8108408efe6] Merge tag 'drm/panel/for-3.16-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
git bisect good 5330fb412948420be83d1d247b79d8108408efe6
# good: [7a014a872914a6bb5af8b67eba603f8546794ab9] drm/nouveau/disp: add internal representaion of output paths and connectors
git bisect good 7a014a872914a6bb5af8b67eba603f8546794ab9
# good: [c1a6e9fe82b46159af8cc4cf34fb51ee47862f05] Merge branch 'topic/ipu-destaging' of git://git.pengutronix.de/git/pza/linux into drm-next
git bisect good c1a6e9fe82b46159af8cc4cf34fb51ee47862f05
# good: [ebd6acbb068b6558735eb80aabce1e7af9e78e1e] drm/g94-/disp: add method to power-off dp lanes
git bisect good ebd6acbb068b6558735eb80aabce1e7af9e78e1e
# good: [c33ba689e54d91bac52a6f7a86d06699c9a8e7c3] drm/nouveau/disp/dp: make use of postcursor when its available
git bisect good c33ba689e54d91bac52a6f7a86d06699c9a8e7c3
# good: [efa366fdf5658ca9ccad38e235818d121b1b8002] drm/nv50-: trigger update after all connectors disabled
git bisect good efa366fdf5658ca9ccad38e235818d121b1b8002
# bad: [1ae5a62bb8b6b544bdfac7bdcb15c9eb22dd6620] drm/nouveau/disp/dp: fix tmds passthrough on dp connector
git bisect bad 1ae5a62bb8b6b544bdfac7bdcb15c9eb22dd6620
# bad: [8777c5c11764d8336d8270f96778158c34c92108] drm/nouveau/dp: probe dpcd to determine connectedness
git bisect bad 8777c5c11764d8336d8270f96778158c34c92108

I'm available for testing.

Cheers,
        Thomas
