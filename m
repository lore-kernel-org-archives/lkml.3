Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab3CNQrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:47:15 -0400
Received: from morework.geizhals.at ([78.142.138.3]:52679 "EHLO
	morework.geizhals.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3CNQrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:47:12 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Mar 2013 12:47:11 EDT
Message-ID: <5141FCE4.8080107@geizhals.at>
Date: Thu, 14 Mar 2013 17:37:56 +0100
From: Johannes Truschnigg <johannes.truschnigg@geizhals.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Icedove/10.0.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Curious (non-trivial?) stability problem with two identical systems
Content-Type: multipart/mixed;
 boundary="------------040604050201000703070408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040604050201000703070408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi LKML folks,

I have a curious problem with a Tyan S8228-based, two-node system (data
sheet: http://www.tyan.com/datasheets/YR190-B8228_DataSheet.pdf or
http://www.tyan.com/product_SKU_spec.aspx?ProductType=MB&pid=678&SKU=600000191),
and I hope that this list can help me determine the root of the problem,
if not work around or even fix it...

We have two Opteron 4272 with 32GB DDR3 ECC UDIMM in each of those
boards, and their configs are 100% identical - same BIOS release, same
CMOS sletettings, same BMC firmware release - the only thing that
differs from one machine to the other is the IP address of the IPMI mgmt
interface. Now, when we first got the system, I put it through our usual
testing routine, which includes a load test over the weekend, running
prime95 (http://mersenne.org/freesoft/) in torture test mode. That's
usually enough to rule out any kind of CPU, memory or thermal problems.
When torture-testing the new setup unter Debian Squeeze (with the 3.2.0
kernel from bpo, backported from Wheezy) we quickly found out that one
node kept failing (that is, became unresponsive to any kind of user
input) after a few minutes into the test, while the other node was happy
to run flawlessly for several days, with prime95 not reporting any
errors.

We gradually swapped all components from one node to the other to
identify which part was at fault - in the end, when we had swapped all
components except for the motherboard and chassis (so even PSUs and the
harddisks with their OS installations on them, etc.), the initially
faulty node still kept failing, which told us that, probably, the board
had some kind of defect. No problem, we got a replacent from the
manufacturer three days ago, and went on to put that new machine through
the same testing routine.  Things is - it keeps failing in the exact
same way as before, despite both chassis and mainboard having been
replaced by new hardware. The problem is 100% reproducible with
Squeeze's default kernel (2.6.32) and a recent-ish test-build of 3.8.0
that I did. I also tried if selecting a different clocksource for the
system would make any kind of difference, but no matter if I use tsc,
hpet or acpi_pm (there's no more alternatives for the kernel image I
tested that with), the failure does happen after at most 20 minutes into
the test. Setting the "performance" instead of "ondemand" cpufreq
governor doesn't help either. System temperatures are fine.

When failing, the machine doesn't outright die, but reports CPU
soft-lockups on the console - networking goes down, the USB ports die,
and there's no way to interact with the machine any more apart from a
hard reboot. I've logged the console output using the serial console
support in the kernel (that does work even after we trigger the error,
though a shell on the serial console won't accept any more input once
that happens), and attached it for your viewing pleasure.  Maybe you
have an idea what we can try to determine what's the all-important
difference between the silbling systems, or what we could do to get the
other, second node to work?

If you need me to provide any other info than what's already in this
mail, please let me know. Please keep me CC'd, as I'm a subscriber of
this list at present.

Thanks a bunch for reading, have a nice day :)

-- 
Mit freundlichen Grüßen
Johannes Truschnigg
Senior System Administrator
--
mailto:johannes.truschnigg@geizhals.at (in dringenden Fällen bitte an
info@geizhals.at)

Geizhals(R) - Preisvergleich Internet Services AG
Obere Donaustrasse 63/2
A-1020 Wien
Tel: +43 1 5811609/87
Fax: +43 1 5811609/55
http://geizhals.at => Preisvergleich für Österreich
http://geizhals.de => Preisvergleich für Deutschland
http://geizhals.eu => Preisvergleich EU-weit
Handelsgericht Wien | FN 197241K | Firmensitz Wien

--------------040604050201000703070408
Content-Type: text/plain;
 name="ser.out.3.8.0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ser.out.3.8.0"

[...]
[   21.857533] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[   21.926327] igb 0000:03:00.0: added PHC on eth1
[   21.926330] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
[   21.926332] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:e0:81:d5:22:06
[   21.926415] igb 0000:03:00.0: eth1: PBA No: FFFFFF-0FF
[   21.926417] igb 0000:03:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   22.118021] igb 0000:03:00.1: added PHC on eth2
[   22.118023] igb 0000:03:00.1: Intel(R) Gigabit Ethernet Network Connection
[   22.118025] igb 0000:03:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:e0:81:d5:22:07
[   22.118108] igb 0000:03:00.1: eth2: PBA No: FFFFFF-0FF
[   22.118110] igb 0000:03:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   22.689127] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x1 impl SATA mode
[   22.704132] usbcore: registered new interface driver usbhid
[   22.704132] usbhid: USB HID core driver
[   22.898594] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[   22.999388] scsi2 : ahci
[   23.029856] scsi3 : ahci
[   23.060393] scsi4 : ahci
[   23.090911] scsi5 : ahci
[   23.121331] scsi6 : ahci
[   23.151758] scsi7 : ahci
[   23.182142] ata3: SATA max UDMA/133 abar m1024@0xfe9fa400 port 0xfe9fa500 irq 22
[   23.270671] ata4: DUMMY
[   23.299957] ata5: DUMMY
[   23.329244] ata6: DUMMY
[   23.358525] ata7: DUMMY
[   23.387821] ata8: DUMMY
[   23.906887] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   23.981107] ata3.00: ATA-8: PLEXTOR PX-128M3, 1.01, max UDMA/133
[   24.053015] ata3.00: 250069680 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[   24.137710] ata3.00: configured for UDMA/133
[   24.189006] scsi 2:0:0:0: Direct-Access     ATA      PLEXTOR PX-128M3 1.01 PQ: 0 ANSI: 5
[   24.291279] sd 2:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[   24.380954] sd 2:0:0:0: [sda] Write Protect is off
[   24.438336] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.547049]  sda: sda1
[   24.575534] sd 2:0:0:0: [sda] Attached SCSI disk
[   24.664014] md: raid1 personality registered for level 1
[   24.732915] md: md0 stopped.
[   24.767942] md: bind<sda1>
[   24.801631] md/raid1:md0: active with 1 out of 1 mirrors
[   24.865284] md0: detected capacity change from 0 to 59997347840
[   24.937539]  md0: unknown partition table
[   25.216007] EXT4-fs (md0): INFO: recovery required on readonly filesystem
[   25.297300] EXT4-fs (md0): write access will be enabled during recovery
[   25.397141] EXT4-fs (md0): recovery complete
[   25.450338] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
[   25.657826] udev[405]: starting version 164
[   25.742733] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[   25.844455] ACPI: Power Button [PWRB]
[   25.888651] MCE: In-kernel MCE decoding enabled.
[   25.943998] ehci-pci: EHCI PCI platform driver
[   25.997372] microcode: CPU0: patch_level=0x06000624
[   25.997656] input: PC Speaker as /devices/platform/pcspkr/input/input1
[   25.997722] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb1/1-1/1-1:1.0/input/input2
[   25.997825] hid-generic 0003:046A:0011.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
[   25.998075] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-3/2-3.1/2-3.1:1.0/input/input3
[   25.998168] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:12.1-3.1/input0
[   25.998378] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-3/2-3.1/2-3.1:1.1/input/input4
[   25.998478] hid-generic 0003:046B:FF10.0003: input,hidraw2: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:12.1-3.1/input1
[   27.043896] ehci-pci 0000:00:12.2: EHCI Host Controller
[   27.046458] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   27.046464] ACPI: Power Button [PWRF]
[   27.048364] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[   27.048376] microcode: CPU1: patch_level=0x06000624
[   27.048393] microcode: CPU2: patch_level=0x06000624
[   27.048405] microcode: CPU3: patch_level=0x06000624
[   27.048415] microcode: CPU4: patch_level=0x06000624
[   27.048425] microcode: CPU5: patch_level=0x06000624
[   27.048443] microcode: CPU6: patch_level=0x06000624
[   27.674425] microcode: CPU7: patch_level=0x06000624
[   27.732838] microcode: CPU8: patch_level=0x06000624
[   27.732961] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 6
[   27.732971] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   27.732994] ehci-pci 0000:00:12.2: debug port 1
[   27.733059] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe9fa800
[   27.733138] usb 1-1: USB disconnect, device number 2
[   28.072760] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   28.072788] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[   28.072791] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   28.072793] usb usb6: Product: EHCI Host Controller
[   28.072795] usb usb6: Manufacturer: Linux 3.8.0-2013-02-20 ehci_hcd
[   28.072797] usb usb6: SerialNumber: 0000:00:12.2
[   28.590470] microcode: CPU9: patch_level=0x06000624
[   28.648926] microcode: CPU10: patch_level=0x06000624
[   28.708412] microcode: CPU11: patch_level=0x06000624
[   28.767947] microcode: CPU12: patch_level=0x06000624
[   28.827464] microcode: CPU13: patch_level=0x06000624
[   28.886963] microcode: CPU14: patch_level=0x06000624
[   28.946575] microcode: CPU15: patch_level=0x06000624
[   29.006052] EDAC MC: Ver: 3.0.0
[   29.006153] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   29.149766] [drm] Initialized drm 1.1.0 20060810
[   29.151400] hub 6-0:1.0: USB hub found
[   29.151406] hub 6-0:1.0: 6 ports detected
[   29.298015] ehci-pci 0000:00:13.2: EHCI Host Controller
[   29.360679] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 7
[   29.360687] AMD64 EDAC driver v3.4.0
[   29.492117] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   29.596282] ehci-pci 0000:00:13.2: debug port 1
[   29.650673] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe9fac00
[   29.726755] Error: Driver 'pcspkr' is already registered, aborting...
[   29.727329] [drm] AST 1100 detected
[   29.727358] [drm] dram 816000000 0 16 04000000
[   29.727488] [TTM] Zone  kernel: Available graphics memory: 16444412 kiB
[   29.727489] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   29.727491] [TTM] Initializing pool allocator
[   29.727508] [TTM] Initializing DMA pool allocator
[   30.200941] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   30.203830] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   30.329482] usb 2-3: USB disconnect, device number 2
[   30.329486] usb 2-3.1: USB disconnect, device number 3
[   30.467766] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[   30.549031] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.635550] usb usb7: Product: EHCI Host Controller
[   30.694012] usb usb7: Manufacturer: Linux 3.8.0-2013-02-20 ehci_hcd
[   30.769107] usb usb7: SerialNumber: 0000:00:13.2
[   30.836591] kvm: Nested Virtualization enabled
[   30.889781] kvm: Nested Paging enabled
[   36.432722] hub 7-0:1.0: USB hub found
[   36.477983] hub 7-0:1.0: 6 ports detected
[   36.526211] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   36.526336] acpi-cpufreq: overriding BIOS provided _PSD data
[   36.683673] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[   36.770394] EDAC amd64: DRAM ECC enabled.
[   36.818492] EDAC amd64: F15h detected (node 0).
[   36.872859] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   36.929283] EDAC amd64: MC: 2:     0MB 3:     0MB
[   36.985657] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   37.042056] EDAC amd64: MC: 6:     0MB 7:     0MB
[   37.098442] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   37.154830] EDAC amd64: MC: 2:     0MB 3:     0MB
[   37.211221] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   37.267629] EDAC amd64: MC: 6:     0MB 7:     0MB
[   37.267650] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.03
[   37.267755] sp5100_tco: PCI Revision ID: 0x3d
[   37.267849] sp5100_tco: Using 0xfec00400 for watchdog MMIO address
[   37.267868] sp5100_tco: Last reboot was not triggered by watchdog.
[   37.268112] sp5100_tco: initialized (0xffffc90003070400). heartbeat=60 sec (nowayout=0, force_addr=none)
[   37.714035] EDAC amd64: using x4 syndromes.
[   37.764141] EDAC amd64: MCT channel count: 2
[   41.681020] EDAC amd64: CS0: Registered DDR3 RAM
[   41.684785] [sched_delayed] sched: RT throttling activated
[   41.802218] EDAC amd64: CS4: Registered DDR3 RAM
[   41.858073] EDAC MC0: Giving out device to 'amd64_edac' 'F15h': DEV 0000:00:18.2
[   41.946791] EDAC amd64: DRAM ECC enabled.
[   41.994928] EDAC amd64: F15h detected (node 1).
[   42.049269] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   42.105594] EDAC amd64: MC: 2:     0MB 3:     0MB
[   42.161987] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   42.218380] EDAC amd64: MC: 6:     0MB 7:     0MB
[   42.274771] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   42.331166] EDAC amd64: MC: 2:     0MB 3:     0MB
[   42.387559] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   42.443955] EDAC amd64: MC: 6:     0MB 7:     0MB
[   42.500341] EDAC amd64: using x4 syndromes.
[   42.550509] EDAC amd64: MCT channel count: 2
[   42.601739] EDAC amd64: CS0: Registered DDR3 RAM
[   42.657064] EDAC amd64: CS4: Registered DDR3 RAM
[   42.712760] EDAC MC1: Giving out device to 'amd64_edac' 'F15h': DEV 0000:00:19.2
[   42.801543] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   42.801887] fbcon: astdrmfb (fb0) is primary device
[   43.143744] Console: switching to colour frame buffer device 128x48
[   43.292038] ast 0000:01:09.0: fb0: astdrmfb frame buffer device
[   43.363585] ast 0000:01:09.0: registered panic notifier
[   43.426758] [drm] Initialized ast 0.1.0 20120228 for 0000:01:09.0 on minor 0
[   43.727214] EXT4-fs (md0): re-mounted. Opts: (null)
[   43.812375] EXT4-fs (md0): re-mounted. Opts: errors=remount-ro
[   43.833663] usb 6-6: new high-speed USB device number 3 using ehci-pci
[   43.984636] loop: module loaded
[   44.074698] usb 6-6: New USB device found, idVendor=046b, idProduct=ff01
[   44.155720] usb 6-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   44.242011] usb 6-6: Product: Generic Hub
[   44.313077] usb 6-6: Manufacturer: American Megatrends Inc.
[   44.313081] usb 6-6: SerialNumber: serial
[   44.315988] hub 6-6:1.0: USB hub found
[   44.317140] hub 6-6:1.0: 3 ports detected
[   44.580583] usb 1-1: new low-speed USB device number 3 using ohci_hcd
[   44.742742] usb 1-1: New USB device found, idVendor=046a, idProduct=0011
[   44.742747] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   44.751202] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb1/1-1/1-1:1.0/input/input6
[   44.751694] hid-generic 0003:046A:0011.0004: input,hidraw0: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
[   44.836417] usb 6-6.1: new low-speed USB device number 4 using ehci-pci
[   44.949358] usb 6-6.1: New USB device found, idVendor=046b, idProduct=ff10
[   44.949363] usb 6-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   44.949366] usb 6-6.1: Product: Virtual Keyboard and Mouse
[   44.949368] usb 6-6.1: Manufacturer: American Megatrends Inc.
[   44.949371] usb 6-6.1: SerialNumber: serial
[   44.951484] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:12.2/usb6/6-6/6-6.1/6-6.1:1.0/input/input7
[   44.951749] hid-generic 0003:046B:FF10.0005: input,hidraw1: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:12.2-6.1/input0
[   44.952927] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:12.2/usb6/6-6/6-6.1/6-6.1:1.1/input/input8
[   44.953268] hid-generic 0003:046B:FF10.0006: input,hidraw2: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:12.2-6.1/input1
[   48.658302] wackamole uses obsolete (PF_INET,SOCK_PACKET)
[   48.698810] sshd (1557): /proc/1557/oom_adj is deprecated, please use /proc/1557/oom_score_adj instead.
[  241.606931] BUG: soft lockup - CPU#9 stuck for 23s! [mprime:2233]
[  241.726054] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  242.763149] CPU 9 
[  242.785376] Pid: 2233, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  242.975534] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  243.131210] RSP: 0000:ffff88040ca13cd8  EFLAGS: 00000202
[  243.241402] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  243.373400] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  243.504984] RBP: ffff88081fc54630 R08: 0000000000000200 R09: ffffffff8168cde0
[  243.635945] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  243.766077] R13: 00000000000000fc R14: ffffffff8174d650 R15: 0000000000000027
[  243.895583] FS:  00007f5627511700(0000) GS:ffff88081fc40000(0000) knlGS:0000000000000000
[  244.036202] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  244.148055] CR2: 00000000027515e0 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  244.276211] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  244.403537] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  244.529928] Process mprime (pid: 2233, threadinfo ffff88040ca12000, task ffff88040c408860)
[  244.669717] Stack:
[  244.733588]  00000000ffffffff 0100000000000000 ffffea0020058fc0 ffff88080b709c00
[  244.862680]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  244.991148]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  245.118890] Call Trace:
[  245.185882]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  245.300639]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  245.411557]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  245.520710]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  245.617450] BUG: soft lockup - CPU#10 stuck for 22s! [mprime:2234]
[  245.617486] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  245.617490] CPU 10 
[  245.617490] Pid: 2234, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  245.617497] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  245.617498] RSP: 0000:ffff88040ca15cd8  EFLAGS: 00000202
[  245.617500] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  245.617501] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  245.617502] RBP: ffff88081fc94630 R08: 0000000000000200 R09: ffffffff8168cde0
[  245.617504] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  245.617505] R13: ffff88040c0b8e60 R14: ffffffff8107bc24 R15: ffffffff81010027
[  245.617507] FS:  00007f5626d10700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[  245.617508] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  245.617510] CR2: 0000000000c41000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  245.617511] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  245.617512] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  245.617514] Process mprime (pid: 2234, threadinfo ffff88040ca14000, task ffff88040d43e760)
[  245.617515] Stack:
[  245.617521]  00000000ffffffff 01ff880800000000 0000000000000001 ffff88080b709c00
[  245.617525]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  245.617529]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  245.617530] Call Trace:
[  245.617534]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  245.617538]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  245.617542]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  245.617546]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  245.617551]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  245.617554]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  245.617558]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  245.617563]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  245.617567]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  245.617572]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  245.617598] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  245.637439] BUG: soft lockup - CPU#11 stuck for 22s! [mprime:2235]
[  245.637479] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  245.637488] CPU 11 
[  245.637489] Pid: 2235, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  245.637496] RIP: 0010:[<ffffffff81399fa3>]  [<ffffffff81399fa3>] _raw_spin_lock+0x15/0x1b
[  245.637498] RSP: 0000:ffff88040ca17df0  EFLAGS: 00000297
[  245.637499] RAX: 000000000000011e RBX: ffff88080ce4acc0 RCX: 000000080357d124
[  245.637500] RDX: 00000000011e011d RSI: ffff88080db12590 RDI: ffffea00202dc4f0
[  245.637502] RBP: 000000080357d124 R08: ffff88080b713228 R09: ffff88080b71e030
[  245.637503] R10: 0000000000000000 R11: 000000000274e000 R12: 0000000000000001
[  245.637504] R13: 0000000000000001 R14: ffff88080ce4acc0 R15: ffff88080b71e0c0
[  245.637506] FS:  00007f562650f700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[  245.637508] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  245.637509] CR2: 0000000000c45000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  245.637510] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  245.637511] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  245.637515] Process mprime (pid: 2235, threadinfo ffff88040ca16000, task ffff88040c7f7860)
[  245.637516] Stack:
[  245.637521]  ffffffff810eb936 0000000000000000 0000000000000004 ffff88040ca17f58
[  245.637525]  ffff88040ca17f58 0000000000000014 0000000000c45000 ffff88080db12590
[  245.637530]  ffff88080b709c68 ffff88040c7f7860 ffffffff8139d336 0000000002f38000
[  245.637531] Call Trace:
[  245.637542]  [<ffffffff810eb936>] ? do_numa_page+0x4a/0x108
[  245.637546]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  245.637549]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  245.637552]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  245.637555]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  245.637559]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  245.637562]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  245.637589] Code: 0f c1 03 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 66 8b 13 eb f4 5b c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 <66> 8b 17 eb f4 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 
[  245.709324] BUG: soft lockup - CPU#15 stuck for 22s! [mprime:2239]
[  245.709351] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  245.709354] CPU 15 
[  245.709355] Pid: 2239, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  245.709360] RIP: 0010:[<ffffffff81086de2>]  [<ffffffff81086de2>] smp_call_function_many+0x1e8/0x1ff
[  245.709361] RSP: 0000:ffff88040ca1faf8  EFLAGS: 00000202
[  245.709362] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  245.709363] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000292
[  245.709364] RBP: ffff88081fdd4630 R08: 0000000000000200 R09: ffffffff8168cde0
[  245.709365] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  245.709366] R13: ffff88081fffcd48 R14: 0000000000000003 R15: 0000000000000026
[  245.709368] FS:  00007f5622507700(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
[  245.709369] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  245.709370] CR2: 0000000000c949ac CR3: 000000080ccdd000 CR4: 00000000000407e0
[  245.709371] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  245.709372] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  245.709373] Process mprime (pid: 2239, threadinfo ffff88040ca1e000, task ffff88040d3d48a0)
[  245.709374] Stack:
[  245.709379]  ffff88081fffcd48 01ff88081fffcd40 000000000d3d48a0 ffff88080b709c00
[  245.709382]  ffff88080b709ec0 0000000000c94000 0000000000000301 ffff88080b7134a0
[  245.709384]  0000000000c94000 ffffffff8103a05c ffff88080b709c00 0000000000c94000
[  245.709385] Call Trace:
[  245.709389]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  245.709391]  [<ffffffff8103a158>] ? flush_tlb_page+0x6f/0x76
[  245.709395]  [<ffffffff810fb170>] ? ptep_clear_flush+0x30/0x3c
[  245.709397]  [<ffffffff810f6bbc>] ? try_to_unmap_one+0xa8/0x396
[  245.709400]  [<ffffffff810d3b88>] ? __alloc_pages_nodemask+0x17a/0x7a0
[  245.709403]  [<ffffffff810f6ff2>] ? try_to_unmap_file+0x6f/0x505
[  245.709406]  [<ffffffff810ceab0>] ? filemap_fault+0x346/0x34f
[  245.709409]  [<ffffffff810cd079>] ? __lock_page+0x63/0x63
[  245.709411]  [<ffffffff810f74f8>] ? try_to_unmap+0x36/0x4a
[  245.709414]  [<ffffffff8110cc9d>] ? migrate_pages+0x240/0x476
[  245.709416]  [<ffffffff8110b6e6>] ? ftrace_raw_event_mm_migrate_pages+0xaf/0xaf
[  245.709419]  [<ffffffff8110cf5e>] ? migrate_misplaced_page+0x8b/0xbb
[  245.709421]  [<ffffffff810eb9bf>] ? do_numa_page+0xd3/0x108
[  245.709425]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  245.709428]  [<ffffffff8106a6c3>] ? ttwu_do_wakeup+0x51/0xc8
[  245.709431]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  245.709436]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  245.709438]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  245.709441]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  245.709444]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  245.709460] Code: 89 1d 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 <f3> 90 f6 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 
[  260.131747]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  260.226979]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  260.324394]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  260.420982]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  260.513514]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  260.608337]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  260.699724] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  273.579248] BUG: soft lockup - CPU#10 stuck for 22s! [mprime:2234]
[  273.599228] BUG: soft lockup - CPU#11 stuck for 22s! [mprime:2235]
[  273.599298] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  273.599303] CPU 11 
[  273.599303] Pid: 2235, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  273.599310] RIP: 0010:[<ffffffff81399fa3>]  [<ffffffff81399fa3>] _raw_spin_lock+0x15/0x1b
[  273.599311] RSP: 0000:ffff88040ca17df0  EFLAGS: 00000297
[  273.599312] RAX: 000000000000011e RBX: ffff88080ce4acc0 RCX: 000000080357d124
[  273.599313] RDX: 00000000011e011d RSI: ffff88080db12590 RDI: ffffea00202dc4f0
[  273.599314] RBP: 000000080357d124 R08: ffff88080b713228 R09: ffff88080b71e030
[  273.599315] R10: 0000000000000000 R11: 000000000274e000 R12: 0000000000000001
[  273.599316] R13: 0000000000000001 R14: ffff88080ce4acc0 R15: ffff88080b71e0c0
[  273.599318] FS:  00007f562650f700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[  273.599319] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  273.599320] CR2: 0000000000c45000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  273.599321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  273.599322] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  273.599323] Process mprime (pid: 2235, threadinfo ffff88040ca16000, task ffff88040c7f7860)
[  273.599324] Stack:
[  273.599328]  ffffffff810eb936 0000000000000000 0000000000000004 ffff88040ca17f58
[  273.599332]  ffff88040ca17f58 0000000000000014 0000000000c45000 ffff88080db12590
[  273.599454]  ffff88080b709c68 ffff88040c7f7860 ffffffff8139d336 0000000002f38000
[  273.599455] Call Trace:
[  273.599460]  [<ffffffff810eb936>] ? do_numa_page+0x4a/0x108
[  273.599463]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  273.599466]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  273.599472]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  273.599476]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  273.599479]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  273.599482]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  273.599541] Code: 0f c1 03 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 66 8b 13 eb f4 5b c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 <66> 8b 17 eb f4 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 
[  273.671122] BUG: soft lockup - CPU#15 stuck for 22s! [mprime:2239]
[  273.671146] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  273.671148] CPU 15 
[  273.671149] Pid: 2239, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  273.671152] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  273.671153] RSP: 0000:ffff88040ca1faf8  EFLAGS: 00000202
[  273.671154] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  273.671155] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000292
[  273.671156] RBP: ffff88081fdd4630 R08: 0000000000000200 R09: ffffffff8168cde0
[  273.671157] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  273.671158] R13: ffff88081fffcd48 R14: 0000000000000003 R15: 0000000000000026
[  273.671160] FS:  00007f5622507700(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
[  273.671161] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  273.671162] CR2: 0000000000c949ac CR3: 000000080ccdd000 CR4: 00000000000407e0
[  273.671163] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  273.671164] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  273.671165] Process mprime (pid: 2239, threadinfo ffff88040ca1e000, task ffff88040d3d48a0)
[  273.671165] Stack:
[  273.671169]  ffff88081fffcd48 01ff88081fffcd40 000000000d3d48a0 ffff88080b709c00
[  273.671171]  ffff88080b709ec0 0000000000c94000 0000000000000301 ffff88080b7134a0
[  273.671174]  0000000000c94000 ffffffff8103a05c ffff88080b709c00 0000000000c94000
[  273.671175] Call Trace:
[  273.671178]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  273.671180]  [<ffffffff8103a158>] ? flush_tlb_page+0x6f/0x76
[  273.671183]  [<ffffffff810fb170>] ? ptep_clear_flush+0x30/0x3c
[  273.671185]  [<ffffffff810f6bbc>] ? try_to_unmap_one+0xa8/0x396
[  273.671187]  [<ffffffff810d3b88>] ? __alloc_pages_nodemask+0x17a/0x7a0
[  273.671189]  [<ffffffff810f6ff2>] ? try_to_unmap_file+0x6f/0x505
[  273.671192]  [<ffffffff810ceab0>] ? filemap_fault+0x346/0x34f
[  273.671194]  [<ffffffff810cd079>] ? __lock_page+0x63/0x63
[  273.671196]  [<ffffffff810f74f8>] ? try_to_unmap+0x36/0x4a
[  273.671198]  [<ffffffff8110cc9d>] ? migrate_pages+0x240/0x476
[  273.671201]  [<ffffffff8110b6e6>] ? ftrace_raw_event_mm_migrate_pages+0xaf/0xaf
[  273.671203]  [<ffffffff8110cf5e>] ? migrate_misplaced_page+0x8b/0xbb
[  273.671205]  [<ffffffff810eb9bf>] ? do_numa_page+0xd3/0x108
[  273.671207]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  273.671210]  [<ffffffff8106a6c3>] ? ttwu_do_wakeup+0x51/0xc8
[  273.671212]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  273.671214]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  273.671216]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  273.671219]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  273.671221]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  273.671237] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  283.433981] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  284.366287] CPU 10 
[  284.389553] Pid: 2234, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  284.544295] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  284.682734] RSP: 0000:ffff88040ca15cd8  EFLAGS: 00000202
[  284.776202] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  284.892208] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  285.008006] RBP: ffff88081fc94630 R08: 0000000000000200 R09: ffffffff8168cde0
[  285.123910] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  285.239708] R13: ffff88040c0b8e60 R14: ffffffff8107bc24 R15: ffffffff81010027
[  285.355297] FS:  00007f5626d10700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[  285.482520] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.546897] BUG: soft lockup - CPU#9 stuck for 22s! [mprime:2233]
[  285.546923] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  285.546926] CPU 9 
[  285.546926] Pid: 2233, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  285.546930] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  285.546931] RSP: 0000:ffff88040ca13cd8  EFLAGS: 00000202
[  285.546932] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  285.546933] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  285.546934] RBP: ffff88081fc54630 R08: 0000000000000200 R09: ffffffff8168cde0
[  285.546935] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  285.546936] R13: 00000000000000fc R14: ffffffff8174d650 R15: 0000000000000027
[  285.546938] FS:  00007f5627511700(0000) GS:ffff88081fc40000(0000) knlGS:0000000000000000
[  285.546939] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.546940] CR2: 00000000027515e0 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  285.546941] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  285.546942] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  285.546943] Process mprime (pid: 2233, threadinfo ffff88040ca12000, task ffff88040c408860)
[  285.546943] Stack:
[  285.546947]  00000000ffffffff 0100000000000000 ffffea0020058fc0 ffff88080b709c00
[  285.546949]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  285.546952]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  285.546952] Call Trace:
[  285.546956]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  285.546958]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  285.546961]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  285.546963]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  285.546966]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  285.546969]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  285.546971]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  285.546974]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  285.546976]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  285.546979]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  285.546995] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  290.251020] CR2: 0000000000c41000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  290.367856] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  290.484485] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  290.601115] Process mprime (pid: 2234, threadinfo ffff88040ca14000, task ffff88040d43e760)
[  290.731763] Stack:
[  290.787222]  00000000ffffffff 01ff880800000000 0000000000000001 ffff88080b709c00
[  290.908627]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  291.029722]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  291.150506] Call Trace:
[  291.211161]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  291.319586]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  291.423959]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  291.526360]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  291.624814]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  291.719322]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  291.816115]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  291.912597]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  292.005547]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  292.101092]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  292.193106] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  294.486686] INFO: rcu_sched self-detected stall on CPU
[  294.486687] INFO: rcu_sched self-detected stall on CPU
[  294.486689] INFO: rcu_sched self-detected stall on CPU
[  294.486690]  {
[  294.486693]  {
[  294.486694]  11
[  294.486695]  10
[  294.486695] } 
[  294.486698]  (t=15000 jiffies g=1034 c=1033 q=45)
[  294.486700] }  (t=15000 jiffies g=1034 c=1033 q=45)
[  294.486701] sending NMI to all CPUs:
[  294.486706] NMI backtrace for cpu 10
[  294.486709] CPU 10 
[  294.486710] Pid: 2234, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.486715] RIP: 0010:[<ffffffff8139a1ee>]  [<ffffffff8139a1ee>] ret_from_intr+0x1/0x15
[  294.486716] RSP: 0000:ffff88081fc83fb8  EFLAGS: 00000046
[  294.486718] RAX: 0140000000000000 RBX: ffff88081fc945c0 RCX: ffff88081fc945c0
[  294.486719] RDX: ffff88081fc945f0 RSI: 0000000000000000 RDI: 0000000000000046
[  294.486720] RBP: ffff88081fc94630 R08: 7fffffffffffffff R09: 0000000000000001
[  294.486722] R10: ffff88081fc93be0 R11: ffffffff81407e70 R12: 000000000000000f
[  294.486723] R13: ffff88040ca15d28 R14: ffffffff8103a330 R15: ffff88081fc945f0
[  294.486725] FS:  00007f5626d10700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[  294.486726] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  294.486728] CR2: 0000000000c41000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  294.486729] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.486730] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.486732] Process mprime (pid: 2234, threadinfo ffff88040ca14000, task ffff88040d43e760)
[  294.486733] Stack:
[  294.486738]  ffff88040ca15c48 <EOI>  ffff88081fc94630 000000000000000f 0000000000000008
[  294.486742]  0000000000000000 ffffffff8168cde0 0000000000000200 0000000000000200
[  294.486745]  0000000000000010 0000000000000200 0000000000000200 0000000000000296
[  294.486746] Call Trace:
[  294.486748]  <IRQ> 
[  294.486749]  <EOI> 
[  294.486752]  [<ffffffff81086de4>] ? smp_call_function_many+0x1ea/0x1ff
[  294.486755]  [<ffffffff81086dd9>] ? smp_call_function_many+0x1df/0x1ff
[  294.486759]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  294.486762]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  294.486765]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  294.486768]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  294.486772]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  294.486775]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  294.486778]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  294.486782]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  294.486785]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  294.486788]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  294.486814] Code: 7c 24 e0 f7 46 68 03 00 00 00 74 06 0f 01 f8 66 66 90 65 ff 04 25 18 c7 00 00 65 48 0f 44 24 25 10 c7 00 00 56 e8 0e 61 c7 ff fa <66> 66 66 90 66 66 90 65 ff 0c 25 18 c7 00 00 5e 48 8d 66 10 65 
[  294.486815] NMI backtrace for cpu 11
[  294.486818] CPU 11 
[  294.486818] Pid: 2235, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.486825] RIP: 0010:[<ffffffff8102ed19>]  [<ffffffff8102ed19>] native_apic_mem_read+0x8/0x9
[  294.486826] RSP: 0000:ffff88081fcc3d80  EFLAGS: 00000096
[  294.486827] RAX: 0000000000000400 RBX: 0000000000000000 RCX: 000000000000000c
[  294.486828] RDX: 000000000000000c RSI: 0000000000000200 RDI: 0000000000000300
[  294.486830] RBP: 000000000000b0d4 R08: 0000000000000000 R09: ffffffff8168cda0
[  294.486831] R10: 000000000000002d R11: 000000000000000b R12: 0000000000000002
[  294.486832] R13: 0000000000000400 R14: ffffffff8168cda0 R15: 000000000000000c
[  294.486834] FS:  00007f562650f700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[  294.486835] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  294.486837] CR2: 0000000000c45000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  294.486838] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.486839] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.486841] Process mprime (pid: 2235, threadinfo ffff88040ca16000, task ffff88040c7f7860)
[  294.486841] Stack:
[  294.486846]  ffffffff8102bbf9 ffffffff81081de2 0000000000000092 000000000000b0d4
[  294.486850]  ffffffff8102beb5 ffff88081fcc0024 ffff88081fcc3e08 ffff88081fcc3dc8
[  294.486853]  0000000000000000 ffff88081fccec20 ffffffff8162b880 ffffffff8168cd60
[  294.486854] Call Trace:
[  294.486856]  <IRQ> 
[  294.486859]  [<ffffffff8102bbf9>] ? native_safe_apic_wait_icr_idle+0x1a/0x49
[  294.486862]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.486865]  [<ffffffff8102beb5>] ? default_send_IPI_mask_sequence_phys+0x5c/0xc7
[  294.486868]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.486871]  [<ffffffff8102bf7f>] ? arch_trigger_all_cpu_backtrace+0x4a/0x7f
[  294.486876]  [<ffffffff810aac6a>] ? __rcu_pending+0x127/0x4ad
[  294.486879]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.486882]  [<ffffffff810abf83>] ? rcu_check_callbacks+0xa5/0xe2
[  294.486884]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.486889]  [<ffffffff8104ded0>] ? update_process_times+0x31/0x63
[  294.486891]  [<ffffffff81081c8b>] ? tick_sched_handle+0x42/0x4f
[  294.486894]  [<ffffffff81081e31>] ? tick_sched_timer+0x4f/0x6b
[  294.486897]  [<ffffffff8106021c>] ? __run_hrtimer+0xb2/0x13c
[  294.486900]  [<ffffffff810604de>] ? hrtimer_interrupt+0xd6/0x1be
[  294.486903]  [<ffffffff8102bbcd>] ? smp_apic_timer_interrupt+0x80/0x92
[  294.486907]  [<ffffffff813a039d>] ? apic_timer_interrupt+0x6d/0x80
[  294.486909]  <EOI> 
[  294.486911]  [<ffffffff81399fa3>] ? _raw_spin_lock+0x15/0x1b
[  294.486914]  [<ffffffff810eb936>] ? do_numa_page+0x4a/0x108
[  294.486917]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  294.486920]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  294.486923]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  294.486925]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  294.486928]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  294.486932]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  294.486957] Code: fe f0 44 0f ab 0a 48 c7 c7 80 47 67 81 e8 66 89 35 00 b8 01 00 00 00 5a c3 90 89 ff 89 b7 00 30 5f ff c3 89 ff 8b 87 00 30 5f ff <c3> 48 8b 05 17 80 3d 00 c3 31 c0 81 ff fe 00 00 00 0f 9e c0 c3 
[  294.486964] NMI backtrace for cpu 9
[  294.486967] CPU 9 
[  294.486968] Pid: 2233, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.486974] RIP: 0010:[<ffffffff8121ba84>]  [<ffffffff8121ba84>] sys_imageblit+0x190/0x424
[  294.486975] RSP: 0000:ffff88081fc43a38  EFLAGS: 00000087
[  294.486976] RAX: 0000000000000720 RBX: ffff88080d9b3800 RCX: 0000000000000008
[  294.486978] RDX: ffffc90013c52320 RSI: 000000000000000f RDI: 0000000000000000
[  294.486979] RBP: ffff88080c6f8912 R08: 0000000000000001 R09: 0000000000000039
[  294.486980] R10: 0000000000000000 R11: ffffffff81441230 R12: ffffc90013c52000
[  294.486982] R13: ffff88080c6f88f9 R14: ffffc90013c52720 R15: 0000000000aaaaaa
[  294.486984] FS:  00007f5627511700(0000) GS:ffff88081fc40000(0000) knlGS:0000000000000000
[  294.486985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  294.486986] CR2: 00000000027515e0 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  294.486988] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.486989] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.486991] Process mprime (pid: 2233, threadinfo ffff88040ca12000, task ffff88040c408860)
[  294.486991] Stack:
[  294.486996]  ffff88080b0d7c00 ffff88040cdde980 0000000000000001 ffffffffa039a94c
[  294.487000]  0000000000000001 0000001000000000 ffff88080b0d7c00 ffff88080b0d7c40
[  294.487004]  0000000000000092 0000000000000001 ffff88081fc43b78 ffff88081fc43b88
[  294.487005] Call Trace:
[  294.487007]  <IRQ> 
[  294.487014]  [<ffffffffa039a94c>] ? ttm_bo_reserve+0xc3/0xd4 [ttm]
[  294.487020]  [<ffffffffa05156b2>] ? ast_imageblit+0x15/0x2c [ast]
[  294.487024]  [<ffffffff81215aa0>] ? bit_putcs+0x3dd/0x431
[  294.487027]  [<ffffffff8106ddc2>] ? update_sd_lb_stats+0x260/0x527
[  294.487031]  [<ffffffff8121079f>] ? fbcon_putcs+0xfb/0x10a
[  294.487033]  [<ffffffff812156c3>] ? bit_cursor+0x48c/0x48c
[  294.487038]  [<ffffffff8126f1be>] ? vt_console_print+0x152/0x2cc
[  294.487042]  [<ffffffff8104257b>] ? T.947+0xaf/0xbd
[  294.487045]  [<ffffffff81042802>] ? console_unlock+0x279/0x31a
[  294.487048]  [<ffffffff81042df8>] ? vprintk_emit+0x3c4/0x3f5
[  294.487051]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.487054]  [<ffffffff81398210>] ? printk+0x4c/0x51
[  294.487059]  [<ffffffff810aabc1>] ? __rcu_pending+0x7e/0x4ad
[  294.487063]  [<ffffffff8139d393>] ? notifier_call_chain+0x2e/0x5b
[  294.487065]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.487069]  [<ffffffff810abf83>] ? rcu_check_callbacks+0xa5/0xe2
[  294.487071]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  294.487076]  [<ffffffff8104ded0>] ? update_process_times+0x31/0x63
[  294.487078]  [<ffffffff81081c8b>] ? tick_sched_handle+0x42/0x4f
[  294.487081]  [<ffffffff81081e31>] ? tick_sched_timer+0x4f/0x6b
[  294.487085]  [<ffffffff8106021c>] ? __run_hrtimer+0xb2/0x13c
[  294.487088]  [<ffffffff810604de>] ? hrtimer_interrupt+0xd6/0x1be
[  294.487091]  [<ffffffff8103a330>] ? flush_tlb_mm_range+0x1d1/0x1d1
[  294.487095]  [<ffffffff8102bbcd>] ? smp_apic_timer_interrupt+0x80/0x92
[  294.487098]  [<ffffffff813a039d>] ? apic_timer_interrupt+0x6d/0x80
[  294.487100]  <EOI> 
[  294.487102]  [<ffffffff81086de4>] ? smp_call_function_many+0x1ea/0x1ff
[  294.487105]  [<ffffffff81086dd9>] ? smp_call_function_many+0x1df/0x1ff
[  294.487109]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  294.487111]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  294.487114]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  294.487117]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  294.487121]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  294.487124]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  294.487127]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  294.487130]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  294.487133]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  294.487137]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  294.487163] Code: 45 89 c9 89 74 24 20 8b 75 0c 89 c0 48 c1 e0 02 eb 54 4c 89 e2 4d 8d 34 04 4c 89 d5 b9 08 00 00 00 4d 89 d5 eb 2a 44 0f be 55 00 <44> 29 c1 41 d3 fa 44 23 54 24 20 47 8b 14 93 45 21 fa 41 31 fa 
[  294.487164] NMI backtrace for cpu 8
[  294.487168] CPU 8 
[  294.487168] Pid: 0, comm: swapper/8 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.487174] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  294.487175] RSP: 0018:ffff88040dcd3ef0  EFLAGS: 00000246
[  294.487177] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: ffff88081fc0eb80
[  294.487178] RDX: ffffffff8162ee00 RSI: 0000000000000008 RDI: 0000000000000001
[  294.487179] RBP: ffff88040dcd2010 R08: 0000000000000000 R09: 0000000000000000
[  294.487180] R10: 0000000000000246 R11: 0000000000000000 R12: 0000000000000000
[  294.487181] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  294.487183] FS:  00007f429395d700(0000) GS:ffff88081fc00000(0000) knlGS:0000000000000000
[  294.487184] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  294.487185] CR2: 00007f428c0280a8 CR3: 000000080c479000 CR4: 00000000000407e0
[  294.487186] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.487187] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.487189] Process swapper/8 (pid: 0, threadinfo ffff88040dcd2000, task ffff88040dc95820)
[  294.487189] Stack:
[  294.487193]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 ffffffff81399dc9
[  294.487709]  4c41eb39c80aa9f1 0000000000000286 0000000000000008 0000000000000000
[  294.487713]  ffffffff8139199d 0000000000000000 f046a0dd7c728d11 0000000050000000
[  294.487714] Call Trace:
[  294.487734]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  294.487736]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  294.487739]  [<ffffffff81399dc9>] ? _raw_spin_unlock_irqrestore+0xc/0x12
[  294.487743]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  294.487760] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  294.487762] NMI backtrace for cpu 15
[  294.487768] CPU 15 
[  294.487771] Pid: 2239, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.487780] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  294.487781] RSP: 0000:ffff88040ca1faf8  EFLAGS: 00000202
[  294.487783] RAX: 0000000000000200 RBX: ffff88081fdd45c0 RCX: 0000000000000010
[  294.487784] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000292
[  294.487785] RBP: ffff88081fdd4630 R08: 0000000000000200 R09: ffffffff8168cde0
[  294.487786] R10: 0000000000000000 R11: 0000000000000008 R12: 000000000000000f
[  294.487788] R13: ffff88040ca1fb48 R14: ffffffff8103a330 R15: ffff88081fdd45f0
[  294.487790] FS:  00007f5622507700(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
[  294.487791] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  294.487793] CR2: 0000000000c949ac CR3: 000000080ccdd000 CR4: 00000000000407e0
[  294.487794] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.487795] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.487797] Process mprime (pid: 2239, threadinfo ffff88040ca1e000, task ffff88040d3d48a0)
[  294.487798] Stack:
[  294.487803]  ffff88081fffcd48 01ff88081fffcd40 000000000d3d48a0 ffff88080b709c00
[  294.487807]  ffff88080b709ec0 0000000000c94000 0000000000000301 ffff88080b7134a0
[  294.487811]  0000000000c94000 ffffffff8103a05c ffff88080b709c00 0000000000c94000
[  294.487812] Call Trace:
[  294.487816]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  294.487819]  [<ffffffff8103a158>] ? flush_tlb_page+0x6f/0x76
[  294.487822]  [<ffffffff810fb170>] ? ptep_clear_flush+0x30/0x3c
[  294.487825]  [<ffffffff810f6bbc>] ? try_to_unmap_one+0xa8/0x396
[  294.487828]  [<ffffffff810d3b88>] ? __alloc_pages_nodemask+0x17a/0x7a0
[  294.487831]  [<ffffffff810f6ff2>] ? try_to_unmap_file+0x6f/0x505
[  294.487834]  [<ffffffff810ceab0>] ? filemap_fault+0x346/0x34f
[  294.487838]  [<ffffffff810cd079>] ? __lock_page+0x63/0x63
[  294.487841]  [<ffffffff810f74f8>] ? try_to_unmap+0x36/0x4a
[  294.487843]  [<ffffffff8110cc9d>] ? migrate_pages+0x240/0x476
[  294.487846]  [<ffffffff8110b6e6>] ? ftrace_raw_event_mm_migrate_pages+0xaf/0xaf
[  294.487851]  [<ffffffff8110cf5e>] ? migrate_misplaced_page+0x8b/0xbb
[  294.487853]  [<ffffffff810eb9bf>] ? do_numa_page+0xd3/0x108
[  294.487856]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  294.487859]  [<ffffffff8106a6c3>] ? ttwu_do_wakeup+0x51/0xc8
[  294.487862]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  294.487865]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  294.487868]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  294.487871]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  294.487875]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  294.487900] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  294.487904] NMI backtrace for cpu 14
[  294.487908] CPU 14 
[  294.487908] Pid: 0, comm: swapper/14 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.487921] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  294.487922] RSP: 0018:ffff88040dd03ef0  EFLAGS: 00000246
[  294.487924] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: 0000000000013bc0
[  294.487925] RDX: ffffffff8162ee00 RSI: 000000000000000e RDI: 0000000000000001
[  294.487926] RBP: ffff88040dd02010 R08: 0000000000000000 R09: 0000000000000000
[  294.487928] R10: ffff88081fd8e2c0 R11: 0000000000000000 R12: 0000000000000000
[  294.487929] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  294.487931] FS:  00007f90a0b477a0(0000) GS:ffff88081fd80000(0000) knlGS:0000000000000000
[  294.487932] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  294.487934] CR2: ffffffffff600400 CR3: 000000080bb33000 CR4: 00000000000407e0
[  294.487936] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.487937] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.487942] Process swapper/14 (pid: 0, threadinfo ffff88040dd02000, task ffff88040dce2760)
[  294.487942] Stack:
[  294.487950]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 ffffffff81399dc9
[  294.487953]  bf9bd0c5066e2549 0000000000000282 000000000000000e 0000000000000000
[  294.487957]  ffffffff8139199d 0000000000000000 e78828c9c48d3fa5 0000000050000000
[  294.487958] Call Trace:
[  294.487969]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  294.487972]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  294.487979]  [<ffffffff81399dc9>] ? _raw_spin_unlock_irqrestore+0xc/0x12
[  294.487997]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  294.488022] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  294.488027] NMI backtrace for cpu 13
[  294.488035] CPU 13 
[  294.488036] Pid: 0, comm: swapper/13 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.488052] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  294.488055] RSP: 0000:ffff88040dce1ef0  EFLAGS: 00000246
[  294.488057] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: 0000000000013bc0
[  294.488060] RDX: ffffffff8162ee00 RSI: 000000000000000d RDI: 0000000000000001
[  294.488062] RBP: ffff88040dce0010 R08: 0000000000000000 R09: 0000000000000000
[  294.488064] R10: 0000000000000498 R11: 0000000000000000 R12: 0000000000000000
[  294.488066] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  294.488070] FS:  00007f5623509700(0000) GS:ffff88081fd40000(0000) knlGS:0000000000000000
[  294.488072] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  294.488075] CR2: 00000000004454b0 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  294.488077] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.488080] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.488083] Process swapper/13 (pid: 0, threadinfo ffff88040dce0000, task ffff88040dc97180)
[  294.488084] Stack:
[  294.488096]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 0000000000000000
[  294.488103]  4cad36a4364823bb 0000000000000000 000000000000000d 0000000000000000
[  294.488110]  ffffffff8139199d 0000000000000000 5bd4467663f59715 0000000050000000
[  294.488111] Call Trace:
[  294.488122]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  294.488129]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  294.488140]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  294.488187] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  294.488193] NMI backtrace for cpu 12
[  294.488212] CPU 12 
[  294.488212] Pid: 0, comm: swapper/12 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  294.488228] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  294.488230] RSP: 0018:ffff88040dcdfef0  EFLAGS: 00000246
[  294.488234] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: 0000000000013bc0
[  294.488235] RDX: ffff88080da5c000 RSI: 000000000000000c RDI: 0000000000000001
[  294.488239] RBP: ffff88040dcde010 R08: 0000000000000000 R09: 0000000000000000
[  294.488241] R10: 0000000000000000 R11: ffff88080da148a8 R12: 0000000000000000
[  294.488243] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  294.488246] FS:  00007fd5ae1d3700(0000) GS:ffff88081fd00000(0000) knlGS:0000000000000000
[  294.488249] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  294.488251] CR2: ffffffffff600400 CR3: 000000080b129000 CR4: 00000000000407e0
[  294.488253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.488255] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  294.488259] Process swapper/12 (pid: 0, threadinfo ffff88040dcde000, task ffff88040dc978a0)
[  294.488259] Stack:
[  294.488265]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 ffffffff81399dc9
[  294.488269]  24f4633cee0a7f8e 0000000000000286 000000000000000c 0000000000000000
[  294.488274]  ffffffff8139199d 0000000000000000 c9afcf60d7796950 0000000050000000
[  294.488276] Call Trace:
[  294.488282]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  294.488286]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  294.488291]  [<ffffffff81399dc9>] ? _raw_spin_unlock_irqrestore+0xc/0x12
[  294.488298]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  294.488345] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  321.513763] BUG: soft lockup - CPU#10 stuck for 22s! [mprime:2234]
[  321.513802] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  321.513806] CPU 10 
[  321.513806] Pid: 2234, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  321.513811] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  321.513812] RSP: 0000:ffff88040ca15cd8  EFLAGS: 00000202
[  321.513813] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  321.513815] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  321.513816] RBP: ffff88081fc94630 R08: 0000000000000200 R09: ffffffff8168cde0
[  321.513820] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  321.513821] R13: ffff88040c0b8e60 R14: ffffffff8107bc24 R15: ffffffff81010027
[  321.513823] FS:  00007f5626d10700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[  321.513825] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  321.513826] CR2: 0000000000c41000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  321.513827] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  321.513828] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  321.513830] Process mprime (pid: 2234, threadinfo ffff88040ca14000, task ffff88040d43e760)
[  321.513831] Stack:
[  321.513851]  00000000ffffffff 01ff880800000000 0000000000000001 ffff88080b709c00
[  321.513855]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  321.513859]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  321.513860] Call Trace:
[  321.513864]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  321.513869]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  321.513872]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  321.513875]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  321.513879]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  321.513882]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  321.513885]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  321.513888]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  321.513891]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  321.513894]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  321.513920] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  321.605633] BUG: soft lockup - CPU#15 stuck for 22s! [mprime:2239]
[  321.605656] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  321.605659] CPU 15 
[  321.605659] Pid: 2239, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  321.605663] RIP: 0010:[<ffffffff81086de8>]  [<ffffffff81086de8>] smp_call_function_many+0x1ee/0x1ff
[  321.605664] RSP: 0000:ffff88040ca1faf8  EFLAGS: 00000202
[  321.605665] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  321.605666] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000292
[  321.605667] RBP: ffff88081fdd4630 R08: 0000000000000200 R09: ffffffff8168cde0
[  321.605668] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  321.605669] R13: ffff88081fffcd48 R14: 0000000000000003 R15: 0000000000000026
[  321.605671] FS:  00007f5622507700(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
[  321.605672] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  321.605673] CR2: 0000000000c949ac CR3: 000000080ccdd000 CR4: 00000000000407e0
[  321.605674] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  321.605675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  321.605676] Process mprime (pid: 2239, threadinfo ffff88040ca1e000, task ffff88040d3d48a0)
[  321.605676] Stack:
[  321.605680]  ffff88081fffcd48 01ff88081fffcd40 000000000d3d48a0 ffff88080b709c00
[  321.605683]  ffff88080b709ec0 0000000000c94000 0000000000000301 ffff88080b7134a0
[  321.605685]  0000000000c94000 ffffffff8103a05c ffff88080b709c00 0000000000c94000
[  321.605686] Call Trace:
[  321.605689]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  321.605691]  [<ffffffff8103a158>] ? flush_tlb_page+0x6f/0x76
[  321.605694]  [<ffffffff810fb170>] ? ptep_clear_flush+0x30/0x3c
[  321.605696]  [<ffffffff810f6bbc>] ? try_to_unmap_one+0xa8/0x396
[  321.605698]  [<ffffffff810d3b88>] ? __alloc_pages_nodemask+0x17a/0x7a0
[  321.605701]  [<ffffffff810f6ff2>] ? try_to_unmap_file+0x6f/0x505
[  321.605703]  [<ffffffff810ceab0>] ? filemap_fault+0x346/0x34f
[  321.605705]  [<ffffffff810cd079>] ? __lock_page+0x63/0x63
[  321.605707]  [<ffffffff810f74f8>] ? try_to_unmap+0x36/0x4a
[  321.605710]  [<ffffffff8110cc9d>] ? migrate_pages+0x240/0x476
[  321.605712]  [<ffffffff8110b6e6>] ? ftrace_raw_event_mm_migrate_pages+0xaf/0xaf
[  321.605714]  [<ffffffff8110cf5e>] ? migrate_misplaced_page+0x8b/0xbb
[  321.605716]  [<ffffffff810eb9bf>] ? do_numa_page+0xd3/0x108
[  321.605718]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  321.605721]  [<ffffffff8106a6c3>] ? ttwu_do_wakeup+0x51/0xc8
[  321.605723]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  321.605725]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  321.605727]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  321.605730]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  321.605732]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  321.605748] Code: 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 f6 43 20 01 <75> f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 55 0f b6 
[  329.522817] BUG: soft lockup - CPU#11 stuck for 23s! [mprime:2235]
[  329.522851] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  329.522855] CPU 11 
[  329.522855] Pid: 2235, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  329.522859] RIP: 0010:[<ffffffff81399fa3>]  [<ffffffff81399fa3>] _raw_spin_lock+0x15/0x1b
[  329.522860] RSP: 0000:ffff88040ca17df0  EFLAGS: 00000297
[  329.522862] RAX: 000000000000011e RBX: ffff88080ce4acc0 RCX: 000000080357d124
[  329.522863] RDX: 00000000011e011d RSI: ffff88080db12590 RDI: ffffea00202dc4f0
[  329.522864] RBP: 000000080357d124 R08: ffff88080b713228 R09: ffff88080b71e030
[  329.522865] R10: 0000000000000000 R11: 000000000274e000 R12: 0000000000000001
[  329.522867] R13: 0000000000000001 R14: ffff88080ce4acc0 R15: ffff88080b71e0c0
[  329.522869] FS:  00007f562650f700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[  329.522870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  329.522871] CR2: 0000000000c45000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  329.522872] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  329.522874] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  329.522875] Process mprime (pid: 2235, threadinfo ffff88040ca16000, task ffff88040c7f7860)
[  329.522876] Stack:
[  329.522880]  ffffffff810eb936 0000000000000000 0000000000000004 ffff88040ca17f58
[  329.522884]  ffff88040ca17f58 0000000000000014 0000000000c45000 ffff88080db12590
[  329.522888]  ffff88080b709c68 ffff88040c7f7860 ffffffff8139d336 0000000002f38000
[  329.522889] Call Trace:
[  329.522892]  [<ffffffff810eb936>] ? do_numa_page+0x4a/0x108
[  329.522895]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  329.522898]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  329.522901]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  329.522904]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  329.522907]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  329.522910]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  329.522935] Code: 0f c1 03 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 66 8b 13 eb f4 5b c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 <66> 8b 17 eb f4 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 
[  339.257764]  { 9}  (t=26211 jiffies g=1034 c=1033 q=45)
[  339.352169] sending NMI to all CPUs:
[  339.426221] NMI backtrace for cpu 9
[  339.499125] CPU 9 
[  339.521352] Pid: 2233, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  339.680144] RIP: 0010:[<ffffffff8102ed19>]  [<ffffffff8102ed19>] native_apic_mem_read+0x8/0x9
[  339.814946] RSP: 0000:ffff88081fc43d80  EFLAGS: 00000096
[  339.911221] RAX: 0000000000000400 RBX: 0000000000000000 RCX: 000000000000000a
[  340.029719] RDX: 000000000000000a RSI: 0000000000000200 RDI: 0000000000000300
[  340.148219] RBP: 000000000000b0d4 R08: 0000000000000000 R09: ffffffff8168cda0
[  340.266092] R10: 000000000000002d R11: ffff88040f81c400 R12: 0000000000000002
[  340.383451] R13: 0000000000000400 R14: ffffffff8168cda0 R15: 000000000000000a
[  340.500288] FS:  00007f5627511700(0000) GS:ffff88081fc40000(0000) knlGS:0000000000000000
[  340.628236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  340.727210] CR2: 00000000027515e0 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  340.842280] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  340.956416] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  341.069516] Process mprime (pid: 2233, threadinfo ffff88040ca12000, task ffff88040c408860)
[  341.195904] Stack:
[  341.246793]  ffffffff8102bbf9 ffffffff81081de2 0000000000000092 000000000000b0d4
[  341.363321]  ffffffff8102beb5 ffff88081fc40022 ffff88081fc43e08 ffff88081fc43dc8
[  341.479637]  0000000000000000 ffff88081fc4ec20 ffffffff8162b880 ffffffff8168cd60
[  341.595747] Call Trace:
[  341.651621]  <IRQ> 
[  341.674885]  [<ffffffff8102bbf9>] ? native_safe_apic_wait_icr_idle+0x1a/0x49
[  341.815091]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  341.913234]  [<ffffffff8102beb5>] ? default_send_IPI_mask_sequence_phys+0x5c/0xc7
[  342.030486]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  342.128630]  [<ffffffff8102bf7f>] ? arch_trigger_all_cpu_backtrace+0x4a/0x7f
[  342.240275]  [<ffffffff810aac6a>] ? __rcu_pending+0x127/0x4ad
[  342.336132]  [<ffffffff8139d393>] ? notifier_call_chain+0x2e/0x5b
[  342.436352]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  342.534704]  [<ffffffff810abf83>] ? rcu_check_callbacks+0xa5/0xe2
[  342.634819]  [<ffffffff81081de2>] ? tick_nohz_handler+0xa9/0xa9
[  342.732443]  [<ffffffff8104ded0>] ? update_process_times+0x31/0x63
[  342.832975]  [<ffffffff81081c8b>] ? tick_sched_handle+0x42/0x4f
[  342.930495]  [<ffffffff81081e31>] ? tick_sched_timer+0x4f/0x6b
[  343.026560]  [<ffffffff8106021c>] ? __run_hrtimer+0xb2/0x13c
[  343.120238]  [<ffffffff810604de>] ? hrtimer_interrupt+0xd6/0x1be
[  343.218069]  [<ffffffff8103a330>] ? flush_tlb_mm_range+0x1d1/0x1d1
[  343.318080]  [<ffffffff8102bbcd>] ? smp_apic_timer_interrupt+0x80/0x92
[  343.422351]  [<ffffffff813a039d>] ? apic_timer_interrupt+0x6d/0x80
[  343.522568]  <EOI> 
[  343.545832]  [<ffffffff81086de4>] ? smp_call_function_many+0x1ea/0x1ff
[  343.678874]  [<ffffffff81086dd9>] ? smp_call_function_many+0x1df/0x1ff
[  343.783661]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  343.886894]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  343.986388]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  344.084530]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  344.179455]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  344.271364]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  344.366497]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  344.461316]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  344.552397]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  344.646179]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  344.736633] Code: fe f0 44 0f ab 0a 48 c7 c7 80 47 67 81 e8 66 89 35 00 b8 01 00 00 00 5a c3 90 89 ff 89 b7 00 30 5f ff c3 89 ff 8b 87 00 30 5f ff <c3> 48 8b 05 17 80 3d 00 c3 31 c0 81 ff fe 00 00 00 0f 9e c0 c3 
[  345.024310] NMI backtrace for cpu 8
[  345.091193] CPU 8 
[  345.113419] Pid: 0, comm: swapper/8 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  345.259853] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  345.383752] RSP: 0018:ffff88040dcd3ef0  EFLAGS: 00000246
[  345.472963] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: ffff88081fc0eb80
[  345.584608] RDX: ffffffff8162ee00 RSI: 0000000000000008 RDI: 0000000000000001
[  345.696564] RBP: ffff88040dcd2010 R08: 0000000000000000 R09: 0000000000000000
[  345.807998] R10: 0000000000000246 R11: 0000000000000000 R12: 0000000000000000
[  345.918917] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  346.029212] FS:  00007f429395d700(0000) GS:ffff88081fc00000(0000) knlGS:0000000000000000
[  346.151240] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  346.245126] CR2: 00007f428c0280a8 CR3: 000000080c479000 CR4: 00000000000407e0
[  346.355731] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  346.466543] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  346.576837] Process swapper/8 (pid: 0, threadinfo ffff88040dcd2000, task ffff88040dc95820)
[  346.701048] Stack:
[  346.749963]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 ffffffff81399dc9
[  346.864618]  4c41eb39c80aa9f1 0000000000000286 0000000000000008 0000000000000000
[  346.979274]  ffffffff8139199d 0000000000000000 f046a0dd7c728d11 0000000050000000
[  347.093827] Call Trace:
[  347.148356]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  347.239746]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  347.326882]  [<ffffffff81399dc9>] ? _raw_spin_unlock_irqrestore+0xc/0x12
[  347.433021]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  347.529809] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  347.821436] NMI backtrace for cpu 10
[  347.891433] CPU 10 
[  347.914698] Pid: 2234, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  348.065390] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  348.202478] RSP: 0000:ffff88040ca15cd8  EFLAGS: 00000202
[  348.294702] RAX: 0000000000000200 RBX: ffff88081fc945c0 RCX: 0000000000000010
[  348.408943] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  348.522871] RBP: ffff88081fc94630 R08: 0000000000000200 R09: ffffffff8168cde0
[  348.637112] R10: 0000000000000000 R11: 0000000000000008 R12: 000000000000000f
[  348.751456] R13: ffff88040ca15d28 R14: ffffffff8103a330 R15: ffff88081fc945f0
[  348.865905] FS:  00007f5626d10700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[  348.992294] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  349.090644] CR2: 0000000000c41000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  349.206029] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  349.321307] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  349.436379] Process mprime (pid: 2234, threadinfo ffff88040ca14000, task ffff88040d43e760)
[  349.565573] Stack:
[  349.619681]  00000000ffffffff 01ff880800000000 0000000000000001 ffff88080b709c00
[  349.739737]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  349.859276]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  349.978293] Call Trace:
[  350.036976]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  350.144361]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  350.248319]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  350.350824]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  350.449798]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  350.545344]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  350.643903]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  350.742565]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  350.838112]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  350.937086]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  351.032525] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  351.329030] NMI backtrace for cpu 15
[  351.401312] CPU 15 
[  351.424579] Pid: 2239, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  351.579737] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  351.718383] RSP: 0000:ffff88040ca1faf8  EFLAGS: 00000202
[  351.811957] RAX: 0000000000000200 RBX: ffff88081fdd45c0 RCX: 0000000000000010
[  351.927651] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000292
[  352.043240] RBP: ffff88081fdd4630 R08: 0000000000000200 R09: ffffffff8168cde0
[  352.158520] R10: 0000000000000000 R11: 0000000000000008 R12: 000000000000000f
[  352.273696] R13: ffff88040ca1fb48 R14: ffffffff8103a330 R15: ffff88081fdd45f0
[  352.389080] FS:  00007f5622507700(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
[  352.516301] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  352.615482] CR2: 0000000000c949ac CR3: 000000080ccdd000 CR4: 00000000000407e0
[  352.731072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  352.846039] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  352.960488] Process mprime (pid: 2239, threadinfo ffff88040ca1e000, task ffff88040d3d48a0)
[  353.089060] Stack:
[  353.142129]  ffff88081fffcd48 01ff88081fffcd40 000000000d3d48a0 ffff88080b709c00
[  353.260627]  ffff88080b709ec0 0000000000c94000 0000000000000301 ffff88080b7134a0
[  353.378711]  0000000000c94000 ffffffff8103a05c ffff88080b709c00 0000000000c94000
[  353.496793] Call Trace:
[  353.554956]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  353.661615]  [<ffffffff8103a158>] ? flush_tlb_page+0x6f/0x76
[  353.758721]  [<ffffffff810fb170>] ? ptep_clear_flush+0x30/0x3c
[  353.857798]  [<ffffffff810f6bbc>] ? try_to_unmap_one+0xa8/0x396
[  353.957393]  [<ffffffff810d3b88>] ? __alloc_pages_nodemask+0x17a/0x7a0
[  354.064052]  [<ffffffff810f6ff2>] ? try_to_unmap_file+0x6f/0x505
[  354.164272]  [<ffffffff810ceab0>] ? filemap_fault+0x346/0x34f
[  354.261376]  [<ffffffff810cd079>] ? __lock_page+0x63/0x63
[  354.354432]  [<ffffffff810f74f8>] ? try_to_unmap+0x36/0x4a
[  354.448108]  [<ffffffff8110cc9d>] ? migrate_pages+0x240/0x476
[  354.544486]  [<ffffffff8110b6e6>] ? ftrace_raw_event_mm_migrate_pages+0xaf/0xaf
[  354.659556]  [<ffffffff8110cf5e>] ? migrate_misplaced_page+0x8b/0xbb
[  354.763101]  [<ffffffff810eb9bf>] ? do_numa_page+0xd3/0x108
[  354.857295]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  354.955337]  [<ffffffff8106a6c3>] ? ttwu_do_wakeup+0x51/0xc8
[  355.049947]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  355.146533]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  355.240002]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  355.340742]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  355.433174]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  355.523315] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  355.816395] NMI backtrace for cpu 11
[  355.887119] CPU 11 
[  355.910385] Pid: 2235, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  356.061906] RIP: 0010:[<ffffffff81399fa3>]  [<ffffffff81399fa3>] _raw_spin_lock+0x15/0x1b
[  356.187882] RSP: 0000:ffff88040ca17df0  EFLAGS: 00000297
[  356.279172] RAX: 000000000000011e RBX: ffffea00202dc4c0 RCX: 000000080357d124
[  356.392893] RDX: 00000000011e011d RSI: ffff88080db12590 RDI: ffffea00202dc4f0
[  356.506304] RBP: 000000080357d124 R08: ffff88080b713228 R09: ffff88080b71e030
[  356.619089] R10: 0000000000000000 R11: 000000000274e000 R12: ffff88080b713228
[  356.731460] R13: 0000000000c45000 R14: ffff88080db12590 R15: ffff88080b709c00
[  356.843521] FS:  00007f562650f700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[  356.967625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  357.063587] CR2: 0000000000c45000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  357.176581] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  357.289265] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  357.401428] Process mprime (pid: 2235, threadinfo ffff88040ca16000, task ffff88040c7f7860)
[  357.527299] Stack:
[  357.577774]  ffffffff810eb936 0000000000000000 0000000000000004 ffff88040ca17f58
[  357.694194]  ffff88040ca17f58 0000000000000014 0000000000c45000 ffff88080db12590
[  357.810822]  ffff88080b709c68 ffff88040c7f7860 ffffffff8139d336 0000000002f38000
[  357.927245] Call Trace:
[  357.983226]  [<ffffffff810eb936>] ? do_numa_page+0x4a/0x108
[  358.076695]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  358.174424]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  358.270696]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  358.363542]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  358.463452]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  358.554949]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  358.644260] Code: 0f c1 03 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 66 8b 13 eb f4 5b c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 <66> 8b 17 eb f4 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 
[  358.935677] NMI backtrace for cpu 14
[  359.005466] CPU 14 
[  359.028732] Pid: 0, comm: swapper/14 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  359.180047] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  359.306336] RSP: 0018:ffff88040dd03ef0  EFLAGS: 00000246
[  359.398350] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: 0000000000013bc0
[  359.512488] RDX: ffffffff8162ee00 RSI: 000000000000000e RDI: 0000000000000001
[  359.626518] RBP: ffff88040dd02010 R08: 0000000000000000 R09: 0000000000000000
[  359.740343] R10: ffff88080dad5028 R11: 0000000000000000 R12: 0000000000000000
[  359.853963] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  359.967476] FS:  00007f90a0b477a0(0000) GS:ffff88081fd80000(0000) knlGS:0000000000000000
[  360.092828] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  360.190244] CR2: ffffffffff600400 CR3: 000000080bb33000 CR4: 00000000000407e0
[  360.304692] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  360.419140] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  360.533486] Process swapper/14 (pid: 0, threadinfo ffff88040dd02000, task ffff88040dce2760)
[  360.662368] Stack:
[  360.714502]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 ffffffff81399dc9
[  360.832274]  bf9bd0c5066e2549 0000000000000282 000000000000000e 0000000000000000
[  360.950357]  ffffffff8139199d 0000000000000000 e78828c9c48d3fa5 0000000050000000
[  361.068130] Call Trace:
[  361.125461]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  361.219346]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  361.308661]  [<ffffffff81399dc9>] ? _raw_spin_unlock_irqrestore+0xc/0x12
[  361.416983]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  361.515951] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  361.811939] NMI backtrace for cpu 12
[  361.883806] CPU 12 
[  361.907073] Pid: 0, comm: swapper/12 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  362.061608] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  362.189557] RSP: 0018:ffff88040dcdfef0  EFLAGS: 00000246
[  362.283233] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: 0000000000013bc0
[  362.398826] RDX: ffff88080da5c000 RSI: 000000000000000c RDI: 0000000000000001
[  362.514105] RBP: ffff88040dcde010 R08: 0000000000000000 R09: 0000000000000000
[  362.628864] R10: 0000000000000000 R11: ffff88080da148a8 R12: 0000000000000000
[  362.743727] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  362.858280] FS:  00007fd5ae1d3700(0000) GS:ffff88081fd00000(0000) knlGS:0000000000000000
[  362.984255] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  363.082087] CR2: ffffffffff600400 CR3: 000000080b129000 CR4: 00000000000407e0
[  363.196950] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  363.312020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  363.426885] Process swapper/12 (pid: 0, threadinfo ffff88040dcde000, task ffff88040dc978a0)
[  363.556805] Stack:
[  363.610499]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 ffffffff81399dc9
[  363.730244]  24f4633cee0a7f8e 0000000000000286 000000000000000c 0000000000000000
[  363.849571]  ffffffff8139199d 0000000000000000 c9afcf60d7796950 0000000050000000
[  363.968277] Call Trace:
[  364.026653]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  364.122095]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  364.212865]  [<ffffffff81399dc9>] ? _raw_spin_unlock_irqrestore+0xc/0x12
[  364.322222]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  364.421812] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  364.718425] NMI backtrace for cpu 13
[  364.791018] CPU 13 
[  364.814284] Pid: 0, comm: swapper/13 Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  364.971517] RIP: 0010:[<ffffffff81032ab8>]  [<ffffffff81032ab8>] native_safe_halt+0x2/0x3
[  365.100609] RSP: 0000:ffff88040dce1ef0  EFLAGS: 00000246
[  365.194909] RAX: 0000000000000000 RBX: ffffffff8168cda0 RCX: 0000000000013bc0
[  365.311227] RDX: ffffffff8162ee00 RSI: 000000000000000d RDI: 0000000000000001
[  365.427545] RBP: ffff88040dce0010 R08: 0000000000000000 R09: 0000000000000000
[  365.543966] R10: 0000000000000498 R11: 0000000000000000 R12: 0000000000000000
[  365.659867] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  365.775043] FS:  00007f5623509700(0000) GS:ffff88081fd40000(0000) knlGS:0000000000000000
[  365.901745] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  366.000202] CR2: 00000000004454b0 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  366.115688] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  366.230760] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  366.345519] Process swapper/13 (pid: 0, threadinfo ffff88040dce0000, task ffff88040dc97180)
[  366.475439] Stack:
[  366.529028]  ffffffff8101623e 0000000000000000 ffffffff81015ad7 0000000000000000
[  366.648462]  4cad36a4364823bb 0000000000000000 000000000000000d 0000000000000000
[  366.767273]  ffffffff8139199d 0000000000000000 5bd4467663f59715 0000000050000000
[  366.885563] Call Trace:
[  366.943522]  [<ffffffff8101623e>] ? default_idle+0x4b/0x84
[  367.038444]  [<ffffffff81015ad7>] ? cpu_idle+0xb8/0xf7
[  367.128798]  [<ffffffff8139199d>] ? start_secondary+0x1dc/0x1e2
[  367.228075] Code: d8 c3 0f 22 df c3 0f 20 e0 c3 0f 20 e0 c3 0f 22 e7 c3 44 0f 20 c0 c3 44 0f 22 c7 c3 0f 09 c3 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 8b 07 53 49 89 c9 49 89 d0 8b 0a 0f a2 89 07 89 1e 41 
[  372.556195] INFO: task mprime:2237 blocked for more than 120 seconds.
[  372.662720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  372.786614] mprime          D ffff88040d108860     0  2237   2176 0x00000000
[  372.901787]  ffff88040d108860 0000000000000086 ffff88040d108860 ffff88080b907860
[  373.021739]  0000000000013bc0 ffff88040ca1bfd8 0000000000013bc0 ffff88040ca1bfd8
[  373.141689]  0000000000013bc0 ffff88040d108860 0000000000013bc0 ffff88040ca1a010
[  373.261020] Call Trace:
[  373.320123]  [<ffffffff813986da>] ? __mutex_lock_common+0x10d/0x175
[  373.425640]  [<ffffffff810d3b88>] ? __alloc_pages_nodemask+0x17a/0x7a0
[  373.534477]  [<ffffffff81398808>] ? mutex_lock+0x1a/0x2c
[  373.628264]  [<ffffffff810f6fb5>] ? try_to_unmap_file+0x32/0x505
[  373.730140]  [<ffffffff810d78b8>] ? __lru_cache_add+0x2b/0x51
[  373.828489]  [<ffffffff810f74f8>] ? try_to_unmap+0x36/0x4a
[  373.923515]  [<ffffffff8110cc9d>] ? migrate_pages+0x240/0x476
[  374.021661]  [<ffffffff8110b6e6>] ? ftrace_raw_event_mm_migrate_pages+0xaf/0xaf
[  374.138501]  [<ffffffff810d0355>] ? zone_watermark_ok+0x7/0x16
[  374.237473]  [<ffffffff8110cf5e>] ? migrate_misplaced_page+0x8b/0xbb
[  374.342883]  [<ffffffff810eb9bf>] ? do_numa_page+0xd3/0x108
[  374.438846]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  374.538958]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  374.637315]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  374.731930]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  374.833496]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  374.926862]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  377.421378] BUG: soft lockup - CPU#9 stuck for 21s! [mprime:2233]
[  377.437371] BUG: soft lockup - CPU#10 stuck for 24s! [mprime:2234]
[  377.437549] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  377.437552] CPU 10 
[  377.437553] Pid: 2234, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  377.437559] RIP: 0010:[<ffffffff81086de4>]  [<ffffffff81086de4>] smp_call_function_many+0x1ea/0x1ff
[  377.437560] RSP: 0000:ffff88040ca15cd8  EFLAGS: 00000202
[  377.437561] RAX: 0000000000000200 RBX: 000000000000000f RCX: 0000000000000010
[  377.437565] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000296
[  377.437567] RBP: ffff88081fc94630 R08: 0000000000000200 R09: ffffffff8168cde0
[  377.437569] R10: 0000000000000000 R11: 0000000000000008 R12: ffffffff8168cda0
[  377.437571] R13: ffff88040c0b8e60 R14: ffffffff8107bc24 R15: ffffffff81010027
[  377.437573] FS:  00007f5626d10700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[  377.437575] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  377.437576] CR2: 0000000000c41000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  377.437578] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  377.437579] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  377.437581] Process mprime (pid: 2234, threadinfo ffff88040ca14000, task ffff88040d43e760)
[  377.437581] Stack:
[  377.437586]  00000000ffffffff 01ff880800000000 0000000000000001 ffff88080b709c00
[  377.437590]  ffff88080b709ec0 000000000210b000 0000000000400000 000000000210b000
[  377.437594]  ffff88080db12590 ffffffff8103a05c ffff88080b709c00 0000000000000000
[  377.437595] Call Trace:
[  377.437599]  [<ffffffff8103a05c>] ? native_flush_tlb_others+0x26/0x2b
[  377.437603]  [<ffffffff8103a323>] ? flush_tlb_mm_range+0x1c4/0x1d1
[  377.437606]  [<ffffffff810f4e57>] ? change_protection+0x53b/0x6c9
[  377.437610]  [<ffffffff81103b3b>] ? mpol_misplaced+0x115/0x122
[  377.437614]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  377.437618]  [<ffffffff811031e5>] ? change_prot_numa+0x16/0x2b
[  377.437621]  [<ffffffff8106f3b1>] ? task_numa_work+0x21a/0x2aa
[  377.437627]  [<ffffffff8105a123>] ? task_work_run+0x7f/0x96
[  377.437630]  [<ffffffff8100f530>] ? do_notify_resume+0x56/0x67
[  377.437636]  [<ffffffff8139a2fc>] ? retint_signal+0x48/0x8c
[  377.437661] Code: 03 e4 57 00 48 89 c6 48 89 5a 08 44 89 63 28 e8 f0 2f 31 00 0f ae f0 48 89 ef ff 15 8f 85 59 00 80 7c 24 0f 00 75 04 eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  381.451873] BUG: soft lockup - CPU#11 stuck for 21s! [mprime:2235]
[  381.451914] Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop sp5100_tco acpi_cpufreq mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel ast aesni_intel ablk_helper snd_pcm cryptd ttm lrw snd_timer aes_x86_64 snd drm_kms_helper xts amd64_edac_mod soundcore gf128mul drm tpm_tis psmouse i2c_piix4 snd_page_alloc edac_core joydev i2c_algo_bit tpm evdev microcode tpm_bios pcspkr hid_generic serio_raw fam15h_power edac_mce_amd k10temp i2c_core ehci_pci button processor thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif ata_generic usbhid hid ahci libahci pata_atiixp igb ohci_hcd libata dca ehci_hcd usbcore ptp usb_common e1000e scsi_mod pps_core
[  381.451917] CPU 11 
[  381.451917] Pid: 2235, comm: mprime Not tainted 3.8.0-2013-02-20 #3 empty empty/S8228
[  381.451925] RIP: 0010:[<ffffffff81399fa3>]  [<ffffffff81399fa3>] _raw_spin_lock+0x15/0x1b
[  381.451928] RSP: 0000:ffff88040ca17df0  EFLAGS: 00000297
[  381.451930] RAX: 000000000000011e RBX: ffff88080ce4acc0 RCX: 000000080357d124
[  381.451931] RDX: 00000000011e011d RSI: ffff88080db12590 RDI: ffffea00202dc4f0
[  381.451932] RBP: 000000080357d124 R08: ffff88080b713228 R09: ffff88080b71e030
[  381.451934] R10: 0000000000000000 R11: 000000000274e000 R12: 0000000000000001
[  381.451935] R13: 0000000000000001 R14: ffff88080ce4acc0 R15: ffff88080b71e0c0
[  381.451937] FS:  00007f562650f700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[  381.451938] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  381.451940] CR2: 0000000000c45000 CR3: 000000080ccdd000 CR4: 00000000000407e0
[  381.451941] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  381.451942] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  381.451944] Process mprime (pid: 2235, threadinfo ffff88040ca16000, task ffff88040c7f7860)
[  381.451945] Stack:
[  381.451949]  ffffffff810eb936 0000000000000000 0000000000000004 ffff88040ca17f58
[  381.451953]  ffff88040ca17f58 0000000000000014 0000000000c45000 ffff88080db12590
[  381.451957]  ffff88080b709c68 ffff88040c7f7860 ffffffff8139d336 0000000002f38000
[  381.451958] Call Trace:
[  381.451961]  [<ffffffff810eb936>] ? do_numa_page+0x4a/0x108
[  381.451969]  [<ffffffff8139d336>] ? __do_page_fault+0x35b/0x380
[  381.451972]  [<ffffffff8106cee5>] ? __dequeue_entity+0x1b/0x2e
[  381.451976]  [<ffffffff8100e80c>] ? __switch_to+0x235/0x3c5
[  381.451978]  [<ffffffff8106d992>] ? pick_next_task_fair+0xeb/0x13d
[  381.451981]  [<ffffffff81399304>] ? __schedule+0x4c9/0x4f6
[  381.451985]  [<ffffffff8139a4d8>] ? page_fault+0x28/0x30
[  381.452010] Code: 0f c1 03 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 66 8b 13 eb f4 5b c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 e8 10 66 39 c2 74 07 f3 90 <66> 8b 17 eb f4 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 
[...]

--------------040604050201000703070408
Content-Type: text/plain;
 name="ser.out.3.2.0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ser.out.3.2.0"

[...]
[    1.808141] NMI watchdog enabled, takes one hw-pmu counter.
[    1.812144] Brought up 16 CPUs
[    1.816117] Total of 16 processors activated (79997.96 BogoMIPS).
[    1.824614] devtmpfs: initialized
[    1.835923] PM: Registering ACPI NVS region at dffb0000 (196608 bytes)
[    1.836332] print_constraints: dummy: 
[    1.840256] NET: Registered protocol family 16
[    1.844230] Extended Config Space enabled on 2 nodes
[    1.848172] ACPI: bus type pci registered
[    1.852198] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.856119] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.888893] PCI: Using configuration type 1 for base access
[    1.897562] bio: create slab <bio-0> at 0
[    1.900261] ACPI: Added _OSI(Module Device)
[    1.904121] ACPI: Added _OSI(Processor Device)
[    1.908121] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.912121] ACPI: Added _OSI(Processor Aggregator Device)
[    1.920877] ACPI: Executed 2 blocks of module-level executable AML code
[    1.938220] ACPI: Interpreter enabled
[    1.940125] ACPI: (supports S0 S1 S4 S5)
[    1.956127] ACPI: Using IOAPIC for interrupt routing
[    1.967581] ACPI: No dock devices found.
[    1.968125] HEST: Table not found.
[    1.972126] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.976246] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.980375] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0c9f]
[    1.984126] pci_root PNP0A03:00: host bridge window [io  0x0cb0-0x0cf7]
[    1.988127] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    1.992127] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.996127] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    2.000127] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    2.012141] pci 0000:00:04.0: PCI bridge to [bus 03-03]
[    2.024142] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    2.028353] pci 0000:00:14.4: PCI bridge to [bus 01-01] (subtractive decode)
[    2.032454]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.036131]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    2.040129] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.054951] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 11 12 14 15)
[    2.082461] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    2.110460] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    2.138460] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    2.166460] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 12 14 15)
[    2.194462] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 12 14 15)
[    2.222464] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    2.250467] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 *7 10 11 12 14 15)
[    2.278518] vgaarb: device added: PCI:0000:01:09.0,decodes=io+mem,owns=io+mem,locks=none
[    2.280144] vgaarb: loaded
[    2.284144] vgaarb: bridge control possible 0000:01:09.0
[    2.288189] PCI: Using ACPI for IRQ routing
[    2.303986] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    2.322426] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    2.326205] Switching to clocksource hpet
[    2.330248] pnp: PnP ACPI init
[    2.366887] ACPI: bus type pnp registered
[    2.416386] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.499900] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.579538] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    2.650499] system 00:09: [io  0x040b] has been reserved
[    2.714151] system 00:09: [io  0x04d6] has been reserved
[    2.777808] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    2.848739] system 00:09: [io  0x0c14] has been reserved
[    2.912392] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    2.983325] system 00:09: [io  0x0c52] has been reserved
[    3.046975] system 00:09: [io  0x0c6c] has been reserved
[    3.110626] system 00:09: [io  0x0c6f] has been reserved
[    3.174281] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    3.245214] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    3.316146] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    3.387082] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    3.458014] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    3.528943] system 00:09: [io  0x0800-0x089f] has been reserved
[    3.599878] system 00:09: [io  0x0b00-0x0b0f] has been reserved
[    3.670813] system 00:09: [io  0x0b20-0x0b3f] has been reserved
[    3.741745] system 00:09: [io  0x0900-0x090f] has been reserved
[    3.812675] system 00:09: [io  0x0910-0x091f] has been reserved
[    3.883613] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    3.954544] system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
[    4.033799] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    4.113304] system 00:0a: [io  0x0a00-0x0a0f] has been reserved
[    4.184296] system 00:0a: [io  0x0228-0x0237] has been reserved
[    4.255364] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    4.334926] system 00:0c: [mem 0xfec20000-0xfec200ff] could not be reserved
[    4.418545] system 00:0d: [mem 0xf6000000-0xf6003fff] has been reserved
[    4.498261] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    4.581707] system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
[    4.665123] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    4.748535] system 00:0e: [mem 0x00100000-0xdfffffff] could not be reserved
[    4.831950] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    4.915725] pnp: PnP ACPI: found 16 devices
[    4.965913] ACPI: ACPI bus type pnp unregistered
[    5.029054] pci 0000:03:00.0: BAR 7: can't assign mem (size 0x20000)
[    5.105294] pci 0000:03:00.0: BAR 10: can't assign mem (size 0x20000)
[    5.182569] pci 0000:03:00.1: BAR 7: can't assign mem (size 0x20000)
[    5.258809] pci 0000:03:00.1: BAR 10: can't assign mem (size 0x20000)
[    5.336073] pci 0000:00:04.0: PCI bridge to [bus 03-03]
[    5.398685] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    5.471698] pci 0000:00:04.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    5.553034] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    5.615642] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    5.688659] pci 0000:00:09.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    5.769991] pci 0000:00:14.4: PCI bridge to [bus 01-01]
[    5.832604] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    5.905619] pci 0000:00:14.4:   bridge window [mem 0xfdf00000-0xfe7fffff]
[    5.987312] NET: Registered protocol family 2
[    6.040074] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    6.130793] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    6.223057] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    6.303724] TCP: Hash tables configured (established 524288 bind 65536)
[    6.383006] TCP reno registered
[    6.420703] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    6.495016] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    6.574710] NET: Registered protocol family 1
[    7.708160] Unpacking initramfs...
[    8.037581] Freeing initrd memory: 10364k freed
[    8.094795] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
[    8.228423] AMD-Vi: Lazy IO/TLB flushing enabled
[    8.283847] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.361023] Placing 64MB software IO TLB between ffff8800dbf9e000 - ffff8800dff9e000
[    8.453898] software IO TLB at phys 0xdbf9e000 - 0xdff9e000
[    8.522096] perf: AMD IBS detected (0x000000ff)
[    8.576784] audit: initializing netlink socket (disabled)
[    8.641535] type=2000 audit(1363262621.636:1): initialized
[    8.722693] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.803653] VFS: Disk quotas dquot_6.5.2
[    8.850777] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    8.928106] msgmni has been set to 32768
[    8.975463] alg: No test for stdrng (krng)
[    9.024691] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    9.113412] io scheduler noop registered
[    9.160420] io scheduler deadline registered
[    9.211691] io scheduler cfq registered (default)
[    9.268296] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.335183] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    9.414511] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    9.491996] ERST: Table is not found!
[    9.535993] GHES: HEST is not enabled!
[    9.580927] Refined TSC clocksource calibration: 2499.999 MHz.
[    9.650854] Switching to clocksource tsc
[    9.650925] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.718467] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.928442] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.032823] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   10.128528] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.204307] Linux agpgart interface v0.103
[   10.253672] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   10.337798] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.397303] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.464522] mousedev: PS/2 mouse device common for all mice
[   10.531415] rtc_cmos 00:02: RTC can wake from S4
[   10.586926] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[   10.660403] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   10.741848] cpuidle: using governor ladder
[   10.790967] cpuidle: using governor menu
[   10.838542] TCP cubic registered
[   10.877446] NET: Registered protocol family 10
[   10.931393] Mobile IPv6
[   10.960706] NET: Registered protocol family 17
[   11.013957] Registering the dns_resolver key type
[   11.070481] registered taskstats version 1
[   11.122008] rtc_cmos 00:02: setting system clock to 2013-03-14 12:04:00 UTC (1363262640)
[   11.219099] Initializing network drop monitor service
[   11.281067] Freeing unused kernel memory: 612k freed
[   11.340796] Write protecting the kernel read-only data: 6144k
[   11.411813] Freeing unused kernel memory: 552k freed
[   11.474112] Freeing unused kernel memory: 716k freed
[   11.548642] udev[115]: starting version 164
[   11.606852] dca service started, version 1.12.1
[   11.669967] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[   11.739947] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[   11.811027] e1000e 0000:02:00.0: Disabling ASPM L0s L1
[   11.872692] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[   11.872802] SCSI subsystem initialized
[   11.985457] e1000e 0000:02:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:e0:81:d5:22:08
[   11.985460] e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   11.985546] e1000e 0000:02:00.0: eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   12.257732] Copyright (c) 2007-2011 Intel Corporation.
[   12.257762] usbcore: registered new interface driver usbfs
[   12.257825] usbcore: registered new interface driver hub
[   12.257893] usbcore: registered new device driver usb
[   12.510037] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.588461] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   12.651202] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[   12.700893] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
[   12.700896] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:e0:81:d5:22:06
[   12.700978] igb 0000:03:00.0: eth1: PBA No: FFFFFF-0FF
[   12.700980] igb 0000:03:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.060137] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   13.164479] ehci_hcd 0000:00:12.2: debug port 1
[   13.218880] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe9fa800
[   13.252918] igb 0000:03:00.1: Intel(R) Gigabit Ethernet Network Connection
[   13.252921] igb 0000:03:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:e0:81:d5:22:07
[   13.253003] igb 0000:03:00.1: eth2: PBA No: FFFFFF-0FF
[   13.253005] igb 0000:03:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.607036] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.616041] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   13.616068] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   13.616070] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.616072] usb usb1: Product: EHCI Host Controller
[   13.616074] usb usb1: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ehci_hcd
[   13.616076] usb usb1: SerialNumber: 0000:00:12.2
[   13.616215] hub 1-0:1.0: USB hub found
[   13.616220] hub 1-0:1.0: 6 ports detected
[   13.616347] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   13.616355] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[   13.616364] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   13.616390] ehci_hcd 0000:00:13.2: debug port 1
[   13.616417] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe9fac00
[   13.632037] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   13.632058] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   13.632061] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.632063] usb usb2: Product: EHCI Host Controller
[   13.632064] usb usb2: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ehci_hcd
[   13.632066] usb usb2: SerialNumber: 0000:00:13.2
[   13.632187] hub 2-0:1.0: USB hub found
[   13.632191] hub 2-0:1.0: 6 ports detected
[   13.632724] scsi0 : pata_atiixp
[   15.140285] scsi1 : pata_atiixp
[   15.178733] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[   15.262243] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[   15.345868] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x1 impl SATA mode
[   15.412043] usb 1-6: new high-speed USB device number 3 using ehci_hcd
[   15.521124] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[   15.577658] usb 1-6: New USB device found, idVendor=046b, idProduct=ff01
[   15.577666] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   15.577673] usb 1-6: Product: Generic Hub
[   15.577678] usb 1-6: Manufacturer: American Megatrends Inc.
[   15.577684] usb 1-6: SerialNumber: serial
[   15.578446] hub 1-6:1.0: USB hub found
[   15.578530] hub 1-6:1.0: 3 ports detected
[   15.860892] usb 1-6.1: new low-speed USB device number 4 using ehci_hcd
[   15.977384] usb 1-6.1: New USB device found, idVendor=046b, idProduct=ff10
[   15.977392] usb 1-6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   15.977396] usb 1-6.1: Product: Virtual Keyboard and Mouse
[   15.977401] usb 1-6.1: Manufacturer: American Megatrends Inc.
[   15.977406] usb 1-6.1: SerialNumber: serial
[   16.477899] scsi2 : ahci
[   16.478774] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:12.2/usb1/1-6/1-6.1/1-6.1:1.0/input/input0
[   16.478954] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:12.2-6.1/input0
[   16.480080] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:12.2/usb1/1-6/1-6.1/1-6.1:1.1/input/input1
[   16.480273] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:12.2-6.1/input1
[   16.480311] usbcore: registered new interface driver usbhid
[   16.480314] usbhid: USB HID core driver
[   17.287023] scsi3 : ahci
[   17.317529] scsi4 : ahci
[   17.347994] scsi5 : ahci
[   17.378470] scsi6 : ahci
[   17.408947] scsi7 : ahci
[   17.439681] ata3: SATA max UDMA/133 abar m1024@0xfe9fa400 port 0xfe9fa500 irq 22
[   17.528352] ata4: DUMMY
[   17.557680] ata5: DUMMY
[   17.587010] ata6: DUMMY
[   17.616340] ata7: DUMMY
[   17.645671] ata8: DUMMY
[   17.675097] ohci_hcd 0000:00:12.0: OHCI Host Controller
[   17.737728] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[   17.826529] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe9f6000
[   17.952040] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   18.033433] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.120049] usb usb3: Product: OHCI Host Controller
[   18.164041] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   18.252593] usb usb3: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ohci_hcd
[   18.330886] usb usb3: SerialNumber: 0000:00:12.0
[   18.386225] ata3.00: ATA-8: PLEXTOR PX-128M3, 1.01, max UDMA/133
[   18.386363] hub 3-0:1.0: USB hub found
[   18.386372] hub 3-0:1.0: 3 ports detected
[   18.386485] ohci_hcd 0000:00:12.1: OHCI Host Controller
[   18.386492] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[   18.386511] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe9f7000
[   18.444053] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   18.444056] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.444058] usb usb4: Product: OHCI Host Controller
[   18.444059] usb usb4: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ohci_hcd
[   18.444061] usb usb4: SerialNumber: 0000:00:12.1
[   18.444175] hub 4-0:1.0: USB hub found
[   18.444182] hub 4-0:1.0: 3 ports detected
[   18.444272] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   18.444279] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[   18.444307] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe9f8000
[   18.504051] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   18.504054] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.504056] usb usb5: Product: OHCI Host Controller
[   18.504057] usb usb5: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ohci_hcd
[   18.504059] usb usb5: SerialNumber: 0000:00:13.0
[   18.504181] hub 5-0:1.0: USB hub found
[   18.504188] hub 5-0:1.0: 3 ports detected
[   18.504282] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   18.504289] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[   18.504311] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe9f9000
[   18.564060] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   18.564063] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.564065] usb usb6: Product: OHCI Host Controller
[   18.564067] usb usb6: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ohci_hcd
[   18.564069] usb usb6: SerialNumber: 0000:00:13.1
[   18.564185] hub 6-0:1.0: USB hub found
[   18.564193] hub 6-0:1.0: 3 ports detected
[   18.564282] ohci_hcd 0000:00:14.5: OHCI Host Controller
[   18.564289] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[   18.564310] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe9fb000
[   18.624055] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   18.624057] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.624059] usb usb7: Product: OHCI Host Controller
[   18.624061] usb usb7: Manufacturer: Linux 3.2.0-0.bpo.4-amd64 ohci_hcd
[   18.624063] usb usb7: SerialNumber: 0000:00:14.5
[   18.624180] hub 7-0:1.0: USB hub found
[   18.624188] hub 7-0:1.0: 2 ports detected
[   18.724042] usb 3-1: new low-speed USB device number 2 using ohci_hcd
[   18.894135] usb 3-1: New USB device found, idVendor=046a, idProduct=0011
[   18.894138] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   18.901331] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input2
[   18.901392] generic-usb 0003:046A:0011.0003: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
[   21.734327] ata3.00: 250069680 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[   21.819083] ata3.00: configured for UDMA/133
[   21.870395] scsi 2:0:0:0: Direct-Access     ATA      PLEXTOR PX-128M3 1.01 PQ: 0 ANSI: 5
[   21.976493] sd 2:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[   22.066257] sd 2:0:0:0: [sda] Write Protect is off
[   22.123731] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.232630]  sda: sda1
[   22.261258] sd 2:0:0:0: [sda] Attached SCSI disk
[   22.457430] md: raid1 personality registered for level 1
[   22.526484] md: md0 stopped.
[   22.561579] md: bind<sda1>
[   22.595224] bio: create slab <bio-1> at 1
[   22.643441] md/raid1:md0: active with 1 out of 1 mirrors
[   22.707118] md0: detected capacity change from 0 to 59997347840
[   22.779527]  md0: unknown partition table
[   23.051722] EXT4-fs (md0): INFO: recovery required on readonly filesystem
[   23.133124] EXT4-fs (md0): write access will be enabled during recovery
[   23.223514] EXT4-fs (md0): recovery complete
[   23.274939] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
[   23.543610] udev[382]: starting version 164
[   23.614108] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[   23.713018] ACPI: Power Button [PWRB]
[   23.757287] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   23.846004] ACPI: Power Button [PWRF]
[   23.890118] MCE: In-kernel MCE decoding enabled.
[   23.890315] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   24.024909] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   24.114424] EDAC MC: Ver: 2.1.0
[   24.116872] udev[462]: renamed network interface eth1 to eth4
[   24.221271] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[   24.297636] SP5100 TCO timer: mmio address 0xfec000f0 already in use
[   24.374888] AMD64 EDAC driver v3.4.0
[   24.417875] EDAC amd64: DRAM ECC enabled.
[   24.424700] udev[456]: renamed network interface eth2 to eth5
[   24.534892] EDAC amd64: F15h detected (node 0).
[   24.589308] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   24.591665] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   24.722909] EDAC amd64: MC: 2:     0MB 3:     0MB
[   24.779354] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   24.835843] EDAC amd64: MC: 6:     0MB 7:     0MB
[   24.892289] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   24.948778] EDAC amd64: MC: 2:     0MB 3:     0MB
[   25.005265] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   25.061753] EDAC amd64: MC: 6:     0MB 7:     0MB
[   25.118202] EDAC amd64: using x4 syndromes.
[   25.168439] EDAC amd64: MCT channel count: 2
[   25.219737] EDAC amd64: CS0: Registered DDR3 RAM
[   25.275179] EDAC amd64: CS4: Registered DDR3 RAM
[   25.330650] EDAC MC0: Giving out device to 'amd64_edac' 'F15h': DEV 0000:00:18.2
[   25.419487] EDAC amd64: DRAM ECC enabled.
[   25.467612] EDAC amd64: F15h detected (node 1).
[   25.472702] udev[457]: renamed network interface eth0 to eth3
[   25.590940] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   25.647405] EDAC amd64: MC: 2:     0MB 3:     0MB
[   25.703921] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   25.760356] EDAC amd64: MC: 6:     0MB 7:     0MB
[   25.816826] EDAC amd64: MC: 0:  4096MB 1:     0MB
[   25.873301] EDAC amd64: MC: 2:     0MB 3:     0MB
[   25.873328] powernow-k8: Found 2 AMD Opteron(tm) Processor 4274 HE               (16 cpu cores) (version 2.20.00)
[   26.052789] powernow-k8: Core Performance Boosting: on.
[   26.052792] Error: Driver 'pcspkr' is already registered, aborting...
[   26.052800] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   26.052806] EDAC amd64: MC: 6:     0MB 7:     0MB
[   26.052808] EDAC amd64: using x4 syndromes.
[   26.052809] EDAC amd64: MCT channel count: 2
[   26.052844] EDAC amd64: CS0: Registered DDR3 RAM
[   26.052846] EDAC amd64: CS4: Registered DDR3 RAM
[   26.052874] EDAC MC1: Giving out device to 'amd64_edac' 'F15h': DEV 0000:00:19.2
[   26.052941] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   26.741654] powernow-k8:    0 : pstate 0 (2500 MHz)
[   26.800195] powernow-k8:    1 : pstate 1 (2200 MHz)
[   26.858640] powernow-k8:    2 : pstate 2 (1900 MHz)
[   26.917092] powernow-k8:    3 : pstate 3 (1600 MHz)
[   26.975543] powernow-k8:    4 : pstate 4 (1400 MHz)
[   27.035315] powernow-k8:    0 : pstate 0 (2500 MHz)
[   27.093804] powernow-k8:    1 : pstate 1 (2200 MHz)
[   27.152257] powernow-k8:    2 : pstate 2 (1900 MHz)
[   27.210704] powernow-k8:    3 : pstate 3 (1600 MHz)
[   27.269159] powernow-k8:    4 : pstate 4 (1400 MHz)
[   27.615450] EXT4-fs (md0): re-mounted. Opts: (null)
[   27.704233] EXT4-fs (md0): re-mounted. Opts: errors=remount-ro
[   27.797655] loop: module loaded
[   28.488558] wackamole uses obsolete (PF_INET,SOCK_PACKET)
[   28.522761] sshd (1344): /proc/1344/oom_adj is deprecated, please use /proc/1344/oom_score_adj instead.
[   50.316044] usb 1-2: new high-speed USB device number 5 using ehci_hcd
[   50.525227] usb 1-2: New USB device found, idVendor=058f, idProduct=6366
[   50.605572] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   50.691148] usb 1-2: Product: Flash Card Reader/Writer
[   50.752838] usb 1-2: Manufacturer: Generic
[   50.802000] usb 1-2: SerialNumber: 058F63666438
[   50.863001] usbcore: registered new interface driver uas
[   50.928979] Initializing USB Mass Storage driver...
[   50.987623] scsi8 : usb-storage 1-2:1.0
[   51.033753] usbcore: registered new interface driver usb-storage
[   51.105777] USB Mass Storage support registered.
[   52.032771] scsi 8:0:0:0: Direct-Access     Multiple Card  Reader     1.00 PQ: 0 ANSI: 0
[   52.607284] sd 8:0:0:0: [sdb] 31358976 512-byte logical blocks: (16.0 GB/14.9 GiB)
[   52.699022] sd 8:0:0:0: [sdb] Write Protect is off
[   52.757380] sd 8:0:0:0: [sdb] No Caching mode page present
[   52.823176] sd 8:0:0:0: [sdb] Assuming drive cache: write through
[   52.899608] sd 8:0:0:0: [sdb] No Caching mode page present
[   52.965461] sd 8:0:0:0: [sdb] Assuming drive cache: write through
[   53.040026]  sdb: sdb1
[   53.071080] sd 8:0:0:0: [sdb] No Caching mode page present
[   53.136874] sd 8:0:0:0: [sdb] Assuming drive cache: write through
[   53.209995] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[   60.801969] FAT-fs (sdb1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[  198.600349] usb 1-2: USB disconnect, device number 5
[ 2384.088003] INFO: rcu_sched detected stalls on CPUs/tasks: { 0 1 2 3 4 5 6 7} (detected by 13, t=15002 jiffies)
[ 2384.088006] sending NMI to all CPUs:
[ 2384.252677] NMI backtrace for cpu 10
[ 2384.256004] CPU 10 
[ 2384.256004] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2384.256004] 
[ 2384.256004] Pid: 2176, comm: mprime Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2384.256004] RIP: 0033:[<0000000001d3bcf1>]  [<0000000001d3bcf1>] 0x1d3bcf0
[ 2384.256004] RSP: 002b:00007f45e44106e0  EFLAGS: 00000282
[ 2384.256004] RAX: 0000000080000191 RBX: 00000000031fd300 RCX: 00000000053ecf80
[ 2384.256004] RDX: 0000000000000000 RSI: 00000000053d8fc0 RDI: 00000000031fd240
[ 2384.256004] RBP: 00000000031fd600 R08: 00000000053ceb00 R09: 0000000000000000
[ 2384.256004] R10: 0000000000000000 R11: 0000000002780000 R12: 0000000004e4f080
[ 2384.256004] R13: 00007f45e4410810 R14: 00000000027ac680 R15: 0000000000d527bf
[ 2384.256004] FS:  00007f45e4412700(0000) GS:ffff88081fc80000(0000) knlGS:0000000000000000
[ 2384.256004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2384.256004] CR2: 00000000055ef000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2384.256004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2384.256004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2384.256004] Process mprime (pid: 2176, threadinfo ffff88080eb02000, task ffff88080eaff120)
[ 2384.256004] 
[ 2384.256004] Call Trace:
[ 2384.256004] NMI backtrace for cpu 11
[ 2384.256004] CPU 11 
[ 2384.256004] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2384.256004] 
[ 2384.256004] Pid: 2177, comm: mprime Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2384.256004] RIP: 0033:[<0000000001d3bf7c>]  [<0000000001d3bf7c>] 0x1d3bf7b
[ 2384.256004] RSP: 002b:00007f45e340e6e0  EFLAGS: 00000202
[ 2384.256004] RAX: 00000000000001a2 RBX: 00000000029be600 RCX: 0000000002fd2fc0
[ 2384.256004] RDX: 0000000000000000 RSI: 0000000002fc0700 RDI: 00000000029be200
[ 2384.256004] RBP: 00000000029be200 R08: 0000000002fb4300 R09: 0000000000000000
[ 2384.256004] R10: 0000000000000000 R11: 000000000279e000 R12: 0000000002a34880
[ 2384.256004] R13: 00007f45e340e810 R14: 00000000027abd00 R15: 0000000000d527bf
[ 2384.256004] FS:  00007f45e3410700(0000) GS:ffff88081fcc0000(0000) knlGS:0000000000000000
[ 2384.256004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2384.256004] CR2: 0000000009d3e000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2384.256004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2384.256004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2384.256004] Process mprime (pid: 2177, threadinfo ffff88080e69e000, task ffff88080eafea30)
[ 2384.256004] 
[ 2384.256004] Call Trace:
[ 2384.088006] NMI backtrace for cpu 13
[ 2384.088006] CPU 13 
[ 2384.088006] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2384.088006] 
[ 2384.088006] Pid: 2179, comm: mprime Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2384.088006] RIP: 0010:[<ffffffff810292ad>]  [<ffffffff810292ad>] native_apic_mem_read+0x8/0x9
[ 2384.088006] RSP: 0018:ffff88081fd43da0  EFLAGS: 00000092
[ 2384.088006] RAX: 0000000000000400 RBX: 0000000000000000 RCX: 000000000000000e
[ 2384.088006] RDX: 000000000000000e RSI: 0000000000000200 RDI: 0000000000000300
[ 2384.088006] RBP: 000000000000dc00 R08: 0000000000000000 R09: ffffffff8168e940
[ 2384.088006] R10: ffff88041f81b000 R11: ffff88041f81b000 R12: 0000000000000002
[ 2384.088006] R13: 0000000000000400 R14: ffffffff8168e940 R15: 000000000000000e
[ 2384.088006] FS:  00007f45e240e700(0000) GS:ffff88081fd40000(0000) knlGS:0000000000000000
[ 2384.088006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2384.088006] CR2: 000000000a2f5000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2384.088006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2384.088006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2384.088006] Process mprime (pid: 2179, threadinfo ffff88080df80000, task ffff88080ecdb160)
[ 2384.088006] Stack:
[ 2384.088006]  ffffffff81025d8e 0000000000000000 0000000000000092 000000000000dc00
[ 2384.088006]  ffffffff81026031 ffff88081fd40026 ffff88081fd43e28 ffff88081fd43de8
[ 2384.088006]  0000000000000000 ffffffff81620080 ffffffff81620180 0000000000000008
[ 2384.088006] Call Trace:
[ 2384.088006]  <IRQ> 
[ 2384.088006]  [<ffffffff81025d8e>] ? native_safe_apic_wait_icr_idle+0x1a/0x40
[ 2384.088006]  [<ffffffff81026031>] ? default_send_IPI_mask_sequence_phys+0x5c/0xc7
[ 2384.088006]  [<ffffffff810260fb>] ? arch_trigger_all_cpu_backtrace+0x4a/0x7f
[ 2384.088006]  [<ffffffff8109d506>] ? __rcu_pending+0x21a/0x353
[ 2384.088006]  [<ffffffff81070734>] ? tick_nohz_handler+0xd0/0xd0
[ 2384.088006]  [<ffffffff8109d75c>] ? rcu_check_callbacks+0xc8/0x104
[ 2384.088006]  [<ffffffff81070734>] ? tick_nohz_handler+0xd0/0xd0
[ 2384.088006]  [<ffffffff810557c5>] ? update_process_times+0x31/0x63
[ 2384.088006]  [<ffffffff8107079e>] ? tick_sched_timer+0x6a/0x90
[ 2384.088006]  [<ffffffff81066af6>] ? __run_hrtimer+0xb1/0x13c
[ 2384.088006]  [<ffffffff81066db8>] ? hrtimer_interrupt+0xd6/0x1bc
[ 2384.088006]  [<ffffffff81025d62>] ? smp_apic_timer_interrupt+0x80/0x92
[ 2384.088006]  [<ffffffff8136dc5e>] ? apic_timer_interrupt+0x6e/0x80
[ 2384.088006]  <EOI> 
[ 2384.088006]  [<ffffffff81032f92>] ? ___pte_free_tlb+0x21/0x57
[ 2384.088006]  [<ffffffff81033bfa>] ? native_flush_tlb_others+0xa7/0xe8
[ 2384.088006]  [<ffffffff81033c07>] ? native_flush_tlb_others+0xb4/0xe8
[ 2384.088006]  [<ffffffff81033d92>] ? flush_tlb_mm+0x69/0x6f
[ 2384.088006]  [<ffffffff810da68c>] ? tlb_flush_mmu+0x1c/0x50
[ 2384.088006]  [<ffffffff810daee2>] ? tlb_finish_mmu+0xe/0x32
[ 2384.088006]  [<ffffffff810def28>] ? unmap_region+0xe7/0xf9
[ 2384.088006]  [<ffffffff810dfdeb>] ? do_munmap+0x281/0x2eb
[ 2384.088006]  [<ffffffff810e083b>] ? sys_brk+0xa6/0xfc
[ 2384.088006]  [<ffffffff8136d192>] ? system_call_fastpath+0x16/0x1b
[ 2384.088006] Code: 44 0f ab 0a 48 c7 c7 f0 47 66 81 e8 e5 79 32 00 b8 01 00 00 00 5a c3 90 90 90 89 ff 89 b7 00 b0 5f ff c3 89 ff 8b 87 00 b0 5f ff <c3> 48 8b 07 25 ff 00 00 00 c3 48 8b 15 ba db 3d 00 48 8b 07 23 
[ 2384.088006] Call Trace:
[ 2384.088006]  <IRQ>  [<ffffffff81025d8e>] ? native_safe_apic_wait_icr_idle+0x1a/0x40
[ 2384.088006]  [<ffffffff81026031>] ? default_send_IPI_mask_sequence_phys+0x5c/0xc7
[ 2384.088006]  [<ffffffff810260fb>] ? arch_trigger_all_cpu_backtrace+0x4a/0x7f
[ 2384.088006]  [<ffffffff8109d506>] ? __rcu_pending+0x21a/0x353
[ 2384.088006]  [<ffffffff81070734>] ? tick_nohz_handler+0xd0/0xd0
[ 2384.088006]  [<ffffffff8109d75c>] ? rcu_check_callbacks+0xc8/0x104
[ 2384.088006]  [<ffffffff81070734>] ? tick_nohz_handler+0xd0/0xd0
[ 2384.088006]  [<ffffffff810557c5>] ? update_process_times+0x31/0x63
[ 2384.088006]  [<ffffffff8107079e>] ? tick_sched_timer+0x6a/0x90
[ 2384.088006]  [<ffffffff81066af6>] ? __run_hrtimer+0xb1/0x13c
[ 2384.088006]  [<ffffffff81066db8>] ? hrtimer_interrupt+0xd6/0x1bc
[ 2384.088006]  [<ffffffff81025d62>] ? smp_apic_timer_interrupt+0x80/0x92
[ 2384.088006]  [<ffffffff8136dc5e>] ? apic_timer_interrupt+0x6e/0x80
[ 2384.088006]  <EOI>  [<ffffffff81032f92>] ? ___pte_free_tlb+0x21/0x57
[ 2384.088006]  [<ffffffff81033bfa>] ? native_flush_tlb_others+0xa7/0xe8
[ 2384.088006]  [<ffffffff81033c07>] ? native_flush_tlb_others+0xb4/0xe8
[ 2384.088006]  [<ffffffff81033d92>] ? flush_tlb_mm+0x69/0x6f
[ 2384.088006]  [<ffffffff810da68c>] ? tlb_flush_mmu+0x1c/0x50
[ 2384.088006]  [<ffffffff810daee2>] ? tlb_finish_mmu+0xe/0x32
[ 2384.088006]  [<ffffffff810def28>] ? unmap_region+0xe7/0xf9
[ 2384.088006]  [<ffffffff810dfdeb>] ? do_munmap+0x281/0x2eb
[ 2384.088006]  [<ffffffff810e083b>] ? sys_brk+0xa6/0xfc
[ 2384.088006]  [<ffffffff8136d192>] ? system_call_fastpath+0x16/0x1b
[ 2384.076010] NMI backtrace for cpu 12
[ 2384.076010] CPU 12 
[ 2384.076010] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2384.076010] 
[ 2384.076010] Pid: 0, comm: swapper/12 Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2384.076010] RIP: 0010:[<ffffffff8102c988>]  [<ffffffff8102c988>] native_safe_halt+0x2/0x3
[ 2384.076010] RSP: 0018:ffff88040f9e7ef0  EFLAGS: 00000246
[ 2384.076010] RAX: 0000000000000000 RBX: ffff88040f9e6010 RCX: 0000000000000000
[ 2384.076010] RDX: 0000000000000000 RSI: 000000000000000c RDI: 0000000000000001
[ 2384.076010] RBP: ffffffff8168e940 R08: 0000000000000000 R09: 0000000000000000
[ 2384.076010] R10: ffff88081fd53f40 R11: 0000000000000246 R12: 0000000000000000
[ 2384.076010] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2384.076010] FS:  00007f45e2c0f700(0000) GS:ffff88081fd00000(0000) knlGS:0000000000000000
[ 2384.076010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2384.076010] CR2: 0000000008663000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2384.076010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2384.076010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2384.076010] Process swapper/12 (pid: 0, threadinfo ffff88040f9e6000, task ffff88040f9d0300)
[ 2384.076010] Stack:
[ 2384.076010]  ffffffff810150b7 0000000000000000 ffffffff8100ddec 0000000000000000
[ 2384.076010]  8b74d94ecf01e26d 0000000000000000 000000000000000c 0000000000000000
[ 2384.076010]  ffffffff8136033a 0000000000000000 f9a18dd705693554 0000000050000000
[ 2384.076010] Call Trace:
[ 2384.076010]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2384.076010]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2384.076010]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2384.076010] Code: 48 c7 c7 c0 36 01 00 65 48 03 3c 25 c0 db 00 00 5e e9 f5 07 00 00 48 83 ec 08 5f eb df 90 90 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 0f 06 c3 0f 20 c0 c3 0f 22 c7 c3 0f 20 d0 c3 0f 22 d7 
[ 2384.076010] Call Trace:
[ 2384.076010]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2384.076010]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2384.076010]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2384.256012] NMI backtrace for cpu 8
[ 2384.256012] CPU 8 
[ 2384.256012] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2384.256012] 
[ 2384.256012] Pid: 0, comm: swapper/8 Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2384.256012] RIP: 0010:[<ffffffff8102c988>]  [<ffffffff8102c988>] native_safe_halt+0x2/0x3
[ 2384.256012] RSP: 0018:ffff88040f9c9ef0  EFLAGS: 00000246
[ 2384.256012] RAX: 0000000000000000 RBX: ffff88040f9c8010 RCX: 0000000000000000
[ 2384.256012] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000001
[ 2384.256012] RBP: ffffffff8168e940 R08: 0000000000000000 R09: 0000000000000000
[ 2384.256012] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
[ 2384.256012] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2384.256012] FS:  00007f2297fff700(0000) GS:ffff88081fc00000(0000) knlGS:0000000000000000
[ 2384.256012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2384.256012] CR2: 00007f22a2f6000c CR3: 000000040e4f8000 CR4: 00000000000406e0
[ 2384.256012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2384.256012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2384.256012] Process swapper/8 (pid: 0, threadinfo ffff88040f9c8000, task ffff88040f99c2c0)
[ 2384.256012] Stack:
[ 2384.256012]  ffffffff810150b7 0000000000000000 ffffffff8100ddec 0000000000000000
[ 2384.256012]  aa43d2cb2144ee2b 0000000000000000 0000000000000008 0000000000000000
[ 2384.256012]  ffffffff8136033a 0000000000000000 c9510c5570bdafd3 0000000050000000
[ 2384.256012] Call Trace:
[ 2384.256012]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2384.256012]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2384.256012]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2384.256012] Code: 48 c7 c7 c0 36 01 00 65 48 03 3c 25 c0 db 00 00 5e e9 f5 07 00 00 48 83 ec 08 5f eb df 90 90 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 0f 06 c3 0f 20 c0 c3 0f 22 c7 c3 0f 20 d0 c3 0f 22 d7 
[ 2384.256012] Call Trace:
[ 2384.256012]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2384.256012]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2384.256012]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2384.256012] NMI backtrace for cpu 9
[ 2400.417809] CPU 9 
[ 2400.417809] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2400.417809] 
[ 2400.417809] Pid: 0, comm: swapper/9 Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2400.417809] RIP: 0010:[<ffffffff8102c988>]  [<ffffffff8102c988>] native_safe_halt+0x2/0x3
[ 2400.417809] RSP: 0018:ffff88040f9d3ef0  EFLAGS: 00000246
[ 2400.417809] RAX: 0000000000000000 RBX: ffff88040f9d2010 RCX: 0000000000000000
[ 2400.417809] RDX: 0000000000000000 RSI: 0000000000000009 RDI: 0000000000000001
[ 2400.417809] RBP: ffffffff8168e940 R08: 0000000000000000 R09: 0000000000000000
[ 2400.417809] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
[ 2400.417809] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2400.417809] FS:  00007f229c3ff700(0000) GS:ffff88081fc40000(0000) knlGS:0000000000000000
[ 2400.417809] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2400.417809] CR2: 0000000006cca000 CR3: 000000040e4f8000 CR4: 00000000000406e0
[ 2400.417809] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2400.417809] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2400.417809] Process swapper/9 (pid: 0, threadinfo ffff88040f9d2000, task ffff88040f9d17d0)
[ 2400.417809] Stack:
[ 2400.417809]  ffffffff810150b7 0000000000000000 ffffffff8100ddec 0000000000000000
[ 2400.417809]  c650a8245c51bf48 0000000000000000 0000000000000009 0000000000000000
[ 2400.417809]  ffffffff8136033a 0000000000000000 d51ee7d93051ce12 0000000050000000
[ 2400.417809] Call Trace:
[ 2400.417809]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2400.417809]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2400.417809]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2400.417809] Code: 48 c7 c7 c0 36 01 00 65 48 03 3c 25 c0 db 00 00 5e e9 f5 07 00 00 48 83 ec 08 5f eb df 90 90 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 0f 06 c3 0f 20 c0 c3 0f 22 c7 c3 0f 20 d0 c3 0f 22 d7 
[ 2400.417809] Call Trace:
[ 2400.417809]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2400.417809]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2400.417809]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2385.132003] NMI backtrace for cpu 14
[ 2385.132003] CPU 14 
[ 2385.132003] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2385.132003] 
[ 2385.132003] Pid: 2180, comm: mprime Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2385.132003] RIP: 0033:[<0000000001400081>]  [<0000000001400081>] 0x1400080
[ 2385.132003] RSP: 002b:00007f45e1c0b6f0  EFLAGS: 00000282
[ 2385.132003] RAX: 00000000a0000085 RBX: 0000000002774000 RCX: 0000000004e21500
[ 2385.132003] RDX: 0000000004dae200 RSI: 0000000004e19240 RDI: 0000000004daea80
[ 2385.132003] RBP: 0000000004daf800 R08: 00000000000003d0 R09: 00007f45e1c0b810
[ 2385.132003] R10: 0000000000000001 R11: 0000000002774000 R12: 00000000091d2880
[ 2385.132003] R13: 00007f45e1c0b810 R14: 00000000027aac40 R15: 0000000000d7ffff
[ 2385.132003] FS:  00007f45e1c0d700(0000) GS:ffff88081fd80000(0000) knlGS:0000000000000000
[ 2385.132003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2385.132003] CR2: 0000000009788000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2385.132003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2385.132003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2385.132003] Process mprime (pid: 2180, threadinfo ffff88080e166000, task ffff88080ecdaa70)
[ 2385.132003] 
[ 2385.132003] Call Trace:
[ 2394.396001] NMI backtrace for cpu 15
[ 2394.396001] CPU 15 
[ 2394.396001] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2394.396001] 
[ 2394.396001] Pid: 0, comm: swapper/15 Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2394.396001] RIP: 0010:[<ffffffff8102c988>]  [<ffffffff8102c988>] native_safe_halt+0x2/0x3
[ 2394.396001] RSP: 0018:ffff88040f9ffef0  EFLAGS: 00000246
[ 2394.396001] RAX: 0000000000000000 RBX: ffff88040f9fe010 RCX: 0000000000000000
[ 2394.396001] RDX: 0000000000000000 RSI: 000000000000000f RDI: 0000000000000001
[ 2394.396001] RBP: ffffffff8168e940 R08: 0000000000000000 R09: 0000000000000000
[ 2394.396001] R10: ffff88081fd53f40 R11: 0000000000000246 R12: 0000000000000000
[ 2394.396001] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2394.396001] FS:  00007f45dec07700(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
[ 2394.396001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2394.396001] CR2: 00007f45d9bf9000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2394.396001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2394.396001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2394.396001] Process swapper/15 (pid: 0, threadinfo ffff88040f9fe000, task ffff88040f9f0a30)
[ 2394.396001] Stack:
[ 2394.396001]  ffffffff810150b7 0000000000000000 ffffffff8100ddec ffffffff81367b60
[ 2394.396001]  209993fbc6227a02 0000000000000286 000000000000000f 0000000000000000
[ 2394.396001]  ffffffff8136033a 0000000000000000 8ac5875bdea8c2ee 0000000050000000
[ 2394.396001] Call Trace:
[ 2394.396001]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2394.396001]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2394.396001]  [<ffffffff81367b60>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[ 2394.396001]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2394.396001] Code: 48 c7 c7 c0 36 01 00 65 48 03 3c 25 c0 db 00 00 5e e9 f5 07 00 00 48 83 ec 08 5f eb df 90 90 9c 58 c3 57 9d c3 fa c3 fb c3 fb f4 <c3> f4 c3 0f 06 c3 0f 20 c0 c3 0f 22 c7 c3 0f 20 d0 c3 0f 22 d7 
[ 2394.396001] Call Trace:
[ 2394.396001]  [<ffffffff810150b7>] ? default_idle+0x4b/0x84
[ 2394.396001]  [<ffffffff8100ddec>] ? cpu_idle+0xb9/0xef
[ 2394.396001]  [<ffffffff81367b60>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[ 2394.396001]  [<ffffffff8136033a>] ? start_secondary+0x1db/0x1e1
[ 2429.600102] BUG: soft lockup - CPU#13 stuck for 23s! [mprime:2179]
[ 2429.604011] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2429.604011] CPU 13 
[ 2429.604011] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2429.604011] 
[ 2429.604011] Pid: 2179, comm: mprime Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2429.604011] RIP: 0010:[<ffffffff81033bfa>]  [<ffffffff81033bfa>] native_flush_tlb_others+0xa7/0xe8
[ 2429.604011] RSP: 0018:ffff88080df81da8  EFLAGS: 00000246
[ 2429.604011] RAX: 0000000000000000 RBX: ffffffff81032f92 RCX: 00000000000000ff
[ 2429.604011] RDX: ffffffff8176d020 RSI: 0000000000000200 RDI: ffffffff8176d018
[ 2429.604011] RBP: ffffffff8176d000 R08: 0000000000000000 R09: 0000000000000008
[ 2429.604011] R10: 0000000000000008 R11: ffff88080df81e58 R12: ffffffff810e2cf9
[ 2429.604011] R13: 0000000000000000 R14: ffff88080e244c38 R15: 000000080a761067
[ 2429.604011] FS:  00007f45e240e700(0000) GS:ffff88081fd40000(0000) knlGS:0000000000000000
[ 2429.604011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2429.604011] CR2: 000000000a2f5000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2429.604011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2429.604011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2429.604011] Process mprime (pid: 2179, threadinfo ffff88080df80000, task ffff88080ecdb160)
[ 2429.604011] Stack:
[ 2429.604011]  00007f0000000000 ffff88080ec7e840 ffff88080ec7eb00 ffff88080ec7e840
[ 2429.604011]  ffff88080e244c38 000000000a317000 00000000097aa000 ffffffff81033d92
[ 2429.604011]  0000000000000000 ffff88080df81e58 ffff88080d8e26b8 ffffffff810da68c
[ 2429.604011] Call Trace:
[ 2429.604011]  [<ffffffff81033d92>] ? flush_tlb_mm+0x69/0x6f
[ 2429.604011]  [<ffffffff810da68c>] ? tlb_flush_mmu+0x1c/0x50
[ 2429.604011]  [<ffffffff810daee2>] ? tlb_finish_mmu+0xe/0x32
[ 2429.604011]  [<ffffffff810def28>] ? unmap_region+0xe7/0xf9
[ 2429.604011]  [<ffffffff810dfdeb>] ? do_munmap+0x281/0x2eb
[ 2429.604011]  [<ffffffff810e083b>] ? sys_brk+0xa6/0xfc
[ 2429.604011]  [<ffffffff8136d192>] ? system_call_fastpath+0x16/0x1b
[ 2429.604011] Code: 4c 89 bb 88 c5 76 81 e8 14 2f 19 00 85 c0 74 2c 48 8b 05 32 a9 65 00 41 8d b5 cf 00 00 00 4c 89 e7 ff 90 d0 00 00 00 eb 02 f3 90 <be> 00 02 00 00 4c 89 e7 e8 d1 2c 19 00 85 c0 74 ed 83 3d 66 be 
[ 2429.604011] Call Trace:
[ 2429.604011]  [<ffffffff81033d92>] ? flush_tlb_mm+0x69/0x6f
[ 2429.604011]  [<ffffffff810da68c>] ? tlb_flush_mmu+0x1c/0x50
[ 2429.604011]  [<ffffffff810daee2>] ? tlb_finish_mmu+0xe/0x32
[ 2429.604011]  [<ffffffff810def28>] ? unmap_region+0xe7/0xf9
[ 2429.604011]  [<ffffffff810dfdeb>] ? do_munmap+0x281/0x2eb
[ 2429.604011]  [<ffffffff810e083b>] ? sys_brk+0xa6/0xfc
[ 2429.604011]  [<ffffffff8136d192>] ? system_call_fastpath+0x16/0x1b
[ 2457.600101] BUG: soft lockup - CPU#13 stuck for 22s! [mprime:2179]
[ 2457.604011] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2457.604011] CPU 13 
[ 2457.604011] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage uas cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats loop powernow_k8 mperf snd_pcm crc32c_intel snd_timer ghash_clmulni_intel snd aesni_intel soundcore amd64_edac_mod cryptd psmouse sp5100_tco snd_page_alloc aes_x86_64 tpm_tis edac_core i2c_piix4 tpm pcspkr k10temp serio_raw tpm_bios i2c_core edac_mce_amd evdev joydev fam15h_power aes_generic processor button thermal_sys ext4 mbcache jbd2 crc16 raid1 md_mod sd_mod crc_t10dif usbhid hid ata_generic ohci_hcd ahci libahci pata_atiixp libata ehci_hcd usbcore igb scsi_mod e1000e usb_common dca [last unloaded: scsi_wait_scan]
[ 2457.604011] 
[ 2457.604011] Pid: 2179, comm: mprime Not tainted 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.32-1~bpo60+1 empty empty/S8228
[ 2457.604011] RIP: 0010:[<ffffffff81033bfa>]  [<ffffffff81033bfa>] native_flush_tlb_others+0xa7/0xe8
[ 2457.604011] RSP: 0018:ffff88080df81da8  EFLAGS: 00000246
[ 2457.604011] RAX: 0000000000000000 RBX: ffffffff81032f92 RCX: 00000000000000ff
[ 2457.604011] RDX: ffffffff8176d020 RSI: 0000000000000200 RDI: ffffffff8176d018
[ 2457.604011] RBP: ffffffff8176d000 R08: 0000000000000000 R09: 0000000000000008
[ 2457.604011] R10: 0000000000000008 R11: ffff88080df81e58 R12: ffffffff810e2cf9
[ 2457.604011] R13: 0000000000000000 R14: ffff88080e244c38 R15: 000000080a761067
[ 2457.604011] FS:  00007f45e240e700(0000) GS:ffff88081fd40000(0000) knlGS:0000000000000000
[ 2457.604011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2457.604011] CR2: 000000000a2f5000 CR3: 000000080e4e5000 CR4: 00000000000406e0
[ 2457.604011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2457.604011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2457.604011] Process mprime (pid: 2179, threadinfo ffff88080df80000, task ffff88080ecdb160)
[ 2457.604011] Stack:
[ 2457.604011]  00007f0000000000 ffff88080ec7e840 ffff88080ec7eb00 ffff88080ec7e840
[ 2457.604011]  ffff88080e244c38 000000000a317000 00000000097aa000 ffffffff81033d92
[ 2457.604011]  0000000000000000 ffff88080df81e58 ffff88080d8e26b8 ffffffff810da68c
[ 2457.604011] Call Trace:
[ 2457.604011]  [<ffffffff81033d92>] ? flush_tlb_mm+0x69/0x6f
[ 2457.604011]  [<ffffffff810da68c>] ? tlb_flush_mmu+0x1c/0x50
[ 2457.604011]  [<ffffffff810daee2>] ? tlb_finish_mmu+0xe/0x32
[ 2457.604011]  [<ffffffff810def28>] ? unmap_region+0xe7/0xf9
[ 2457.604011]  [<ffffffff810dfdeb>] ? do_munmap+0x281/0x2eb
[ 2457.604011]  [<ffffffff810e083b>] ? sys_brk+0xa6/0xfc
[ 2457.604011]  [<ffffffff8136d192>] ? system_call_fastpath+0x16/0x1b
[ 2457.604011] Code: 4c 89 bb 88 c5 76 81 e8 14 2f 19 00 85 c0 74 2c 48 8b 05 32 a9 65 00 41 8d b5 cf 00 00 00 4c 89 e7 ff 90 d0 00 00 00 eb 02 f3 90 <be> 00 02 00 00 4c 89 e7 e8 d1 2c 19 00 85 c0 74 ed 83 3d 66 be 
[ 2457.604011] Call Trace:
[ 2457.604011]  [<ffffffff81033d92>] ? flush_tlb_mm+0x69/0x6f
[ 2457.604011]  [<ffffffff810da68c>] ? tlb_flush_mmu+0x1c/0x50
[ 2457.604011]  [<ffffffff810daee2>] ? tlb_finish_mmu+0xe/0x32
[ 2457.604011]  [<ffffffff810def28>] ? unmap_region+0xe7/0xf9
[ 2457.604011]  [<ffffffff810dfdeb>] ? do_munmap+0x281/0x2eb
[ 2457.604011]  [<ffffffff810e083b>] ? sys_brk+0xa6/0xfc
[ 2457.604011]  [<ffffffff8136d192>] ? system_call_fastpath+0x16/0x1b
[...]

--------------040604050201000703070408--
