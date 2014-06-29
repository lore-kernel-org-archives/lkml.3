Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaF2Dz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 23:55:26 -0400
Received: from mail001.aei.ca ([206.123.6.130]:45164 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaF2DzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 23:55:24 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
Date: Sat, 28 Jun 2014 23:55:19 -0400
Message-ID: <3945293.Jtp4nyZMfX@grover>
Organization: me
User-Agent: KMail/4.13.2 (Linux/3.16.0-1-git; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1602327.OGkKxHtt2b@grover>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch> <1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch> <1602327.OGkKxHtt2b@grover>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 June 2014 15:28:22 Ed Tomlinson wrote:

Resend without html krud which causes list to bounce the message.

> Hi
> 
> This commit ( a4de05268e674e8ed31df6348269e22d6c6a1803 ) hangs my boot with 3.16-git.  Reverting it lets the boot proceed. 
> 
> I have an i7 with a built-in i915 and an pcie r7 260x.  The R7 is the primary console.  The i915 is initialized
> but does not have a physical display attached.
> 
> With the patch applied the boot stops at the messages:
> 
> [drm] Memory usable by graphics device = 2048M
> [drm] Replacing VGA console driver
> 
> and I need to interrupt or power off the box to get it back.
> 
> (I did not notice messages about the R7 but they could have easily been missed - this box does not have a serial console)
> 
> Without the patch I get:
> 
> Jun 28 14:53:54 localhost kernel: [    2.075351] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> Jun 28 14:53:54 localhost kernel: [    2.075796] [drm] Initialized drm 1.1.0 20060810
> Jun 28 14:53:54 localhost kernel: [    2.075958] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077289] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077299] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077307] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077315] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077325] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077335] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077342] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x17
> Jun 28 14:53:54 localhost kernel: [    2.077378] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> Jun 28 14:53:54 localhost kernel: [    2.079726] input: PC Speaker as /devices/platform/pcspkr/input/input4
> Jun 28 14:53:54 localhost kernel: [    2.083930] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
> Jun 28 14:53:54 localhost kernel: [    2.084787] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140424/utaddress-258)
> Jun 28 14:53:54 localhost kernel: [    2.084788] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> Jun 28 14:53:54 localhost kernel: [    2.084894] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> Jun 28 14:53:54 localhost kernel: [    2.084905] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.096721] iTCO_vendor_support: vendor-support=0
> Jun 28 14:53:54 localhost kernel: [    2.096780] AVX2 version of gcm_enc/dec engaged.
> Jun 28 14:53:54 localhost kernel: [    2.098512] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> Jun 28 14:53:54 localhost kernel: [    2.099042] iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
> Jun 28 14:53:54 localhost kernel: [    2.099561] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> Jun 28 14:53:54 localhost kernel: [    2.100401] [drm] radeon kernel modesetting enabled.
> Jun 28 14:53:54 localhost kernel: [    2.100918] checking generic (e0000000 300000) vs hw (e0000000 10000000)
> Jun 28 14:53:54 localhost kernel: [    2.100919] fb: switching to radeondrmfb from simple
> Jun 28 14:53:54 localhost kernel: [    2.101372] Console: switching to colour dummy device 80x25
> Jun 28 14:53:54 localhost kernel: [    2.101527] [drm] initializing kernel modesetting (BONAIRE 0x1002:0x6658 0x174B:0xE253).
> Jun 28 14:53:54 localhost kernel: [    2.101534] [drm] register mmio base: 0xF0800000
> Jun 28 14:53:54 localhost kernel: [    2.101535] [drm] register mmio size: 262144
> Jun 28 14:53:54 localhost kernel: [    2.101540] [drm] doorbell mmio base: 0xF0000000
> Jun 28 14:53:54 localhost kernel: [    2.101541] [drm] doorbell mmio size: 8388608
> Jun 28 14:53:54 localhost kernel: [    2.101579] ATOM BIOS: Bonaire
> Jun 28 14:53:54 localhost kernel: [    2.101627] radeon 0000:01:00.0: VRAM: 2048M 0x0000000000000000 - 0x000000007FFFFFFF (2048M used)
> Jun 28 14:53:54 localhost kernel: [    2.101629] radeon 0000:01:00.0: GTT: 1024M 0x0000000080000000 - 0x00000000BFFFFFFF
> Jun 28 14:53:54 localhost kernel: [    2.101630] [drm] Detected VRAM RAM=2048M, BAR=256M
> Jun 28 14:53:54 localhost kernel: [    2.101631] [drm] RAM width 128bits DDR
> Jun 28 14:53:54 localhost kernel: [    2.101659] [TTM] Zone  kernel: Available graphics memory: 8145364 kiB
> Jun 28 14:53:54 localhost kernel: [    2.101660] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> Jun 28 14:53:54 localhost kernel: [    2.101662] [TTM] Initializing pool allocator
> Jun 28 14:53:54 localhost kernel: [    2.101664] [TTM] Initializing DMA pool allocator
> Jun 28 14:53:54 localhost kernel: [    2.101674] [drm] radeon: 2048M of VRAM memory ready
> Jun 28 14:53:54 localhost kernel: [    2.101675] [drm] radeon: 1024M of GTT memory ready.
> Jun 28 14:53:54 localhost kernel: [    2.101681] [drm] Loading BONAIRE Microcode
> Jun 28 14:53:54 localhost kernel: [    2.109479] [drm] radeon/BONAIRE_mc2.bin: 31792 bytes
> Jun 28 14:53:54 localhost kernel: [    2.110510] [drm] Internal thermal controller with fan control
> Jun 28 14:53:54 localhost kernel: [    2.110648] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
> Jun 28 14:53:54 localhost kernel: [    2.118508] [drm] radeon: dpm initialized
> Jun 28 14:53:54 localhost kernel: [    2.122133] [drm] Found VCE firmware/feedback version 40.2.2 / 15!
> Jun 28 14:53:54 localhost kernel: [    2.122140] [drm] GART: num cpu pages 262144, num gpu pages 262144
> Jun 28 14:53:54 localhost kernel: [    2.122540] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
> Jun 28 14:53:54 localhost kernel: [    2.122544] [drm] PCIE gen 3 link speeds already enabled
> Jun 28 14:53:54 localhost kernel: [    2.126118] Adding 5779452k swap on /dev/sdc2.  Priority:-1 extents:1 across:5779452k FS
> Jun 28 14:53:54 localhost kernel: [    2.133031] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: discard
> Jun 28 14:53:54 localhost kernel: [    2.136552] [drm] PCIE GART of 1024M enabled (table at 0x000000000078B000).
> Jun 28 14:53:54 localhost kernel: [    2.136670] radeon 0000:01:00.0: WB enabled
> Jun 28 14:53:54 localhost kernel: [    2.136697] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff8802683e6c00
> Jun 28 14:53:54 localhost kernel: [    2.136699] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff8802683e6c04
> Jun 28 14:53:54 localhost kernel: [    2.136701] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff8802683e6c08
> Jun 28 14:53:54 localhost kernel: [    2.136703] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff8802683e6c0c
> Jun 28 14:53:54 localhost kernel: [    2.136705] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff8802683e6c10
> Jun 28 14:53:54 localhost kernel: [    2.137230] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90007936c98
> Jun 28 14:53:54 localhost kernel: [    2.137293] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff8802683e6c18
> Jun 28 14:53:54 localhost kernel: [    2.137296] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff8802683e6c1c
> Jun 28 14:53:54 localhost kernel: [    2.137298] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> Jun 28 14:53:54 localhost kernel: [    2.137299] [drm] Driver supports precise vblank timestamp query.
> Jun 28 14:53:54 localhost kernel: [    2.137325] radeon 0000:01:00.0: irq 45 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.137331] radeon 0000:01:00.0: radeon: using MSI.
> Jun 28 14:53:54 localhost kernel: [    2.137357] [drm] radeon: irq initialized.
> Jun 28 14:53:54 localhost kernel: [    2.139870] [drm] ring test on 0 succeeded in 3 usecs
> Jun 28 14:53:54 localhost kernel: [    2.139938] [drm] ring test on 1 succeeded in 3 usecs
> Jun 28 14:53:54 localhost kernel: [    2.139950] [drm] ring test on 2 succeeded in 3 usecs
> Jun 28 14:53:54 localhost kernel: [    2.140110] [drm] ring test on 3 succeeded in 2 usecs
> Jun 28 14:53:54 localhost kernel: [    2.140116] [drm] ring test on 4 succeeded in 1 usecs
> Jun 28 14:53:54 localhost kernel: [    2.142659] Adding 5779452k swap on /dev/sdb2.  Priority:-2 extents:1 across:5779452k FS
> Jun 28 14:53:54 localhost kernel: [    2.152066] usb 1-7: new full-speed USB device number 6 using xhci_hcd
> Jun 28 14:53:54 localhost kernel: [    2.185418] raid6: sse2x1   13222 MB/s
> Jun 28 14:53:54 localhost kernel: [    2.196219] [drm] ring test on 5 succeeded in 1 usecs
> Jun 28 14:53:54 localhost kernel: [    2.216257] [drm] UVD initialized successfully.
> Jun 28 14:53:54 localhost kernel: [    2.242145] raid6: sse2x2   17003 MB/s
> Jun 28 14:53:54 localhost kernel: [    2.259077] e1000e 0000:00:19.0 eth0: registered PHC clock
> Jun 28 14:53:54 localhost kernel: [    2.259080] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) bc:5f:f4:fc:fa:91
> Jun 28 14:53:54 localhost kernel: [    2.259081] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> Jun 28 14:53:54 localhost kernel: [    2.259119] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
> Jun 28 14:53:54 localhost kernel: [    2.262208] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.265424] nct6775: Found NCT6776D/F or compatible chip at 0x2e:0x290
> Jun 28 14:53:54 localhost kernel: [    2.286592] sound hdaudioC0D0: ALC1150: SKU not ready 0x00000000
> Jun 28 14:53:54 localhost kernel: [    2.286961] sound hdaudioC0D0: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
> Jun 28 14:53:54 localhost kernel: [    2.286963] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> Jun 28 14:53:54 localhost kernel: [    2.286965] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
> Jun 28 14:53:54 localhost kernel: [    2.286966] sound hdaudioC0D0:    mono: mono_out=0x0
> Jun 28 14:53:54 localhost kernel: [    2.286967] sound hdaudioC0D0:    dig-out=0x1e/0x0
> Jun 28 14:53:54 localhost kernel: [    2.286968] sound hdaudioC0D0:    inputs:
> Jun 28 14:53:54 localhost kernel: [    2.286970] sound hdaudioC0D0:      Front Mic=0x19
> Jun 28 14:53:54 localhost kernel: [    2.286971] sound hdaudioC0D0:      Rear Mic=0x18
> Jun 28 14:53:54 localhost kernel: [    2.286972] sound hdaudioC0D0:      Line=0x1a
> Jun 28 14:53:54 localhost kernel: [    2.297632] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/hdaudioC0D0/input5
> Jun 28 14:53:54 localhost kernel: [    2.297798] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
> Jun 28 14:53:54 localhost kernel: [    2.297835] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
> Jun 28 14:53:54 localhost kernel: [    2.297869] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> Jun 28 14:53:54 localhost kernel: [    2.297905] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> Jun 28 14:53:54 localhost kernel: [    2.297940] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> Jun 28 14:53:54 localhost kernel: [    2.297973] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> Jun 28 14:53:54 localhost kernel: [    2.298005] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> Jun 28 14:53:54 localhost kernel: [    2.298888] raid6: sse2x4   18101 MB/s
> Jun 28 14:53:54 localhost kernel: [    2.306396] zram: unknown parameter '#32' ignored
> Jun 28 14:53:54 localhost kernel: [    2.306399] zram: unknown parameter 'is' ignored
> Jun 28 14:53:54 localhost kernel: [    2.306400] zram: unknown parameter 'max' ignored
> Jun 28 14:53:54 localhost kernel: [    2.306401] zram: unknown parameter 'zram' ignored
> Jun 28 14:53:54 localhost kernel: [    2.306402] zram: unknown parameter 'devices' ignored
> Jun 28 14:53:54 localhost kernel: [    2.312100] zram: Created 32 device(s) ...
> Jun 28 14:53:54 localhost kernel: [    2.327478] [drm] ring test on 6 succeeded in 22 usecs
> Jun 28 14:53:54 localhost kernel: [    2.327492] [drm] ring test on 7 succeeded in 4 usecs
> Jun 28 14:53:54 localhost kernel: [    2.327493] [drm] VCE initialized successfully.
> Jun 28 14:53:54 localhost kernel: [    2.327763] [drm] ib test on ring 0 succeeded in 0 usecs
> Jun 28 14:53:54 localhost kernel: [    2.327925] [drm] ib test on ring 1 succeeded in 0 usecs
> Jun 28 14:53:54 localhost kernel: [    2.328079] [drm] ib test on ring 2 succeeded in 0 usecs
> Jun 28 14:53:54 localhost kernel: [    2.328237] [drm] ib test on ring 3 succeeded in 0 usecs
> Jun 28 14:53:54 localhost kernel: [    2.328394] [drm] ib test on ring 4 succeeded in 0 usecs
> Jun 28 14:53:54 localhost kernel: [    2.328707] usb 1-7: ep 0x85 - rounding interval to 64 microframes, ep desc says 80 microframes
> Jun 28 14:53:54 localhost kernel: [    2.340997] Adding 254540k swap on /dev/zram0.  Priority:32767 extents:1 across:254540k SSFS
> Jun 28 14:53:54 localhost kernel: [    2.341054] Adding 254540k swap on /dev/zram1.  Priority:32767 extents:1 across:254540k SSFS
> Jun 28 14:53:54 localhost kernel: [    2.341110] Adding 254540k swap on /dev/zram2.  Priority:32767 extents:1 across:254540k SSFS
> Jun 28 14:53:54 localhost kernel: [    2.341162] Adding 254540k swap on /dev/zram3.  Priority:32767 extents:1 across:254540k SSFS
> Jun 28 14:53:54 localhost kernel: [    2.343872] [drm] ib test on ring 5 succeeded
> Jun 28 14:53:54 localhost kernel: [    2.355627] raid6: avx2x1   16273 MB/s
> Jun 28 14:53:54 localhost kernel: [    2.364832] [drm] ib test on ring 6 succeeded
> Jun 28 14:53:54 localhost kernel: [    2.365591] [drm] ib test on ring 7 succeeded
> Jun 28 14:53:54 localhost kernel: [    2.366015] [drm] Radeon Display Connectors
> Jun 28 14:53:54 localhost kernel: [    2.366018] [drm] Connector 0:
> Jun 28 14:53:54 localhost kernel: [    2.366019] [drm]   DP-1
> Jun 28 14:53:54 localhost kernel: [    2.366020] [drm]   HPD2
> Jun 28 14:53:54 localhost kernel: [    2.366022] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
> Jun 28 14:53:54 localhost kernel: [    2.366024] [drm]   Encoders:
> Jun 28 14:53:54 localhost kernel: [    2.366026] [drm]     DFP1: INTERNAL_UNIPHY2
> Jun 28 14:53:54 localhost kernel: [    2.366027] [drm] Connector 1:
> Jun 28 14:53:54 localhost kernel: [    2.366028] [drm]   HDMI-A-1
> Jun 28 14:53:54 localhost kernel: [    2.366030] [drm]   HPD3
> Jun 28 14:53:54 localhost kernel: [    2.366032] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
> Jun 28 14:53:54 localhost kernel: [    2.366033] [drm]   Encoders:
> Jun 28 14:53:54 localhost kernel: [    2.366035] [drm]     DFP2: INTERNAL_UNIPHY2
> Jun 28 14:53:54 localhost kernel: [    2.366036] [drm] Connector 2:
> Jun 28 14:53:54 localhost kernel: [    2.366037] [drm]   DVI-D-1
> Jun 28 14:53:54 localhost kernel: [    2.366039] [drm]   HPD1
> Jun 28 14:53:54 localhost kernel: [    2.366041] [drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
> Jun 28 14:53:54 localhost kernel: [    2.366043] [drm]   Encoders:
> Jun 28 14:53:54 localhost kernel: [    2.366044] [drm]     DFP3: INTERNAL_UNIPHY1
> Jun 28 14:53:54 localhost kernel: [    2.366045] [drm] Connector 3:
> Jun 28 14:53:54 localhost kernel: [    2.366046] [drm]   DVI-I-1
> Jun 28 14:53:54 localhost kernel: [    2.366048] [drm]   HPD6
> Jun 28 14:53:54 localhost kernel: [    2.366049] [drm]   DDC: 0x6580 0x6580 0x6584 0x6584 0x6588 0x6588 0x658c 0x658c
> Jun 28 14:53:54 localhost kernel: [    2.366051] [drm]   Encoders:
> Jun 28 14:53:54 localhost kernel: [    2.366052] [drm]     DFP4: INTERNAL_UNIPHY
> Jun 28 14:53:54 localhost kernel: [    2.366053] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> Jun 28 14:53:54 localhost kernel: [    2.412356] raid6: avx2x2   20798 MB/s
> Jun 28 14:53:54 localhost kernel: [    2.412358] Switched to clocksource tsc
> Jun 28 14:53:54 localhost kernel: [    2.439066] usb 1-8: new low-speed USB device number 7 using xhci_hcd
> Jun 28 14:53:54 localhost kernel: [    2.442481] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.464181] [drm] fb mappable at 0xE098E000
> Jun 28 14:53:54 localhost kernel: [    2.464183] [drm] vram apper at 0xE0000000
> Jun 28 14:53:54 localhost kernel: [    2.464184] [drm] size 9216000
> Jun 28 14:53:54 localhost kernel: [    2.464185] [drm] fb depth is 24
> Jun 28 14:53:54 localhost kernel: [    2.464186] [drm]    pitch is 7680
> Jun 28 14:53:54 localhost kernel: [    2.464227] fbcon: radeondrmfb (fb0) is primary device
> Jun 28 14:53:54 localhost kernel: [    2.469074] raid6: avx2x4   24141 MB/s
> Jun 28 14:53:54 localhost kernel: [    2.469074] raid6: using algorithm avx2x4 (24141 MB/s)
> Jun 28 14:53:54 localhost kernel: [    2.469075] raid6: using avx2x2 recovery algorithm
> Jun 28 14:53:54 localhost kernel: [    2.469466] xor: automatically using best checksumming function:
> Jun 28 14:53:54 localhost kernel: [    2.484840] Console: switching to colour frame buffer device 240x75
> Jun 28 14:53:54 localhost kernel: [    2.487822] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
> Jun 28 14:53:54 localhost kernel: [    2.487836] radeon 0000:01:00.0: registered panic notifier
> Jun 28 14:53:54 localhost kernel: [    2.502444]    avx       : 41036.400 MB/sec
> Jun 28 14:53:54 localhost kernel: [    2.510424] Btrfs loaded
> Jun 28 14:53:54 localhost kernel: [    2.510765] BTRFS: device fsid 9d4254aa-6715-4fa8-986a-1af0d51768ad devid 1 transid 303773 /dev/sdc1
> Jun 28 14:53:54 localhost kernel: [    2.510907] BTRFS: device fsid 9d4254aa-6715-4fa8-986a-1af0d51768ad devid 2 transid 303773 /dev/sdb1
> Jun 28 14:53:54 localhost kernel: [    2.513700] [drm] Initialized radeon 2.39.0 20080528 for 0000:01:00.0 on minor 0
> Jun 28 14:53:54 localhost kernel: [    2.513800] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
> Jun 28 14:53:54 localhost kernel: [    2.513878] snd_hda_intel 0000:01:00.1: irq 48 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.513971] [drm] Memory usable by graphics device = 2048M
> Jun 28 14:53:54 localhost kernel: [    2.520123] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
> Jun 28 14:53:54 localhost kernel: [    2.520184] input: HD-Audio Generic HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
> Jun 28 14:53:54 localhost kernel: [    2.520258] input: HD-Audio Generic HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
> Jun 28 14:53:54 localhost kernel: [    2.520368] input: HD-Audio Generic HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
> Jun 28 14:53:54 localhost kernel: [    2.520440] input: HD-Audio Generic HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
> Jun 28 14:53:54 localhost kernel: [    2.521215] input: HD-Audio Generic HDMI/DP,pcm=11 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
> Jun 28 14:53:54 localhost kernel: [    2.532558] i915 0000:00:02.0: irq 49 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.532565] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> Jun 28 14:53:54 localhost kernel: [    2.532580] [drm] Driver supports precise vblank timestamp query.
> Jun 28 14:53:54 localhost kernel: [    2.532607] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> Jun 28 14:53:54 localhost kernel: [    2.545934] e1000e 0000:00:19.0: irq 50 for MSI/MSI-X
> Jun 28 14:53:54 localhost kernel: [    2.546018] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> Jun 28 14:53:54 localhost kernel: [    2.619122] usb 1-8: ep 0x81 - rounding interval to 512 microframes, ep desc says 800 microframes
> Jun 28 14:53:54 localhost kernel: [    2.759949] i915 0000:00:02.0: fb1: inteldrmfb frame buffer device
> Jun 28 14:53:54 localhost kernel: [    2.760226] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 1
> Jun 28 14:53:54 localhost kernel: [    2.779511] usb 1-14: new high-speed USB device number 8 using xhci_hcd
> 
> I am willing to try patches.
> 
> Please fix or revert this commit.
> 
> Thanks,
> Ed Tomlinson
> 
> 
> On Thursday 05 June 2014 16:58:28 Daniel Vetter wrote:
> > Touching the VGA resources on an IVB EFI machine causes hard hangs when
> > we then kick out the efifb. Ouch.
> > 
> > Apparently this also prevents unclaimed register errors on hsw and
> > hard machine hangs on my i855gm when trying to unbind fbcon.
> > 
> > Also, we want this to make I915_FBDEV=n safe.
> > 
> > v2: Rebase and pimp commit message.
> > 
> > v3: We also need to unregister the vga console, otherwise the unbind
> > of the fb console before module unload might resurrect it again.
> > 
> > v4: Ignore errors when the vga console is already unregistered - this
> > can happen when e.g. reloading i915.ko.
> > 
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=67813
> > Cc: David Herrmann <dh.herrmann@gmail.com>
> > Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: linux-fbdev@vger.kernel.org
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk> (v1)
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/i915/i915_dma.c  | 43 +++++++++++++++++++++++++++++++++++++++-
> >  drivers/video/console/dummycon.c |  1 +
> >  drivers/video/console/vgacon.c   |  1 +
> >  3 files changed, 44 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> > index 27fe65ac5940..bcb66ddd649e 100644
> > --- a/drivers/gpu/drm/i915/i915_dma.c
> > +++ b/drivers/gpu/drm/i915/i915_dma.c
> > @@ -36,6 +36,8 @@
> >  #include "i915_drv.h"
> >  #include "i915_trace.h"
> >  #include <linux/pci.h>
> > +#include <linux/console.h>
> > +#include <linux/vt.h>
> >  #include <linux/vgaarb.h>
> >  #include <linux/acpi.h>
> >  #include <linux/pnp.h>
> > @@ -1449,6 +1451,38 @@ static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
> >  }
> >  #endif
> >  
> > +#if !defined(CONFIG_VGA_CONSOLE)
> > +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> > +{
> > +	return 0;
> > +}
> > +#elif !defined(CONFIG_DUMMY_CONSOLE)
> > +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> > +{
> > +	return -ENODEV;
> > +}
> > +#else
> > +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> > +{
> > +	int ret;
> > +
> > +	DRM_INFO("Replacing VGA console driver\n");
> > +
> > +	console_lock();
> > +	ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> > +	if (ret == 0) {
> > +		ret = do_unregister_con_driver(&vga_con);
> > +
> > +		/* Ignore "already unregistered". */
> > +		if (ret == -ENODEV)
> > +			ret = 0;
> > +	}
> > +	console_unlock();
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> >  static void i915_dump_device_info(struct drm_i915_private *dev_priv)
> >  {
> >  	const struct intel_device_info *info = &dev_priv->info;
> > @@ -1622,8 +1656,15 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
> >  	if (ret)
> >  		goto out_regs;
> >  
> > -	if (drm_core_check_feature(dev, DRIVER_MODESET))
> > +	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> > +		ret = i915_kick_out_vgacon(dev_priv);
> > +		if (ret) {
> > +			DRM_ERROR("failed to remove conflicting VGA console\n");
> > +			goto out_gtt;
> > +		}
> > +
> >  		i915_kick_out_firmware_fb(dev_priv);
> > +	}
> >  
> >  	pci_set_master(dev->pdev);
> >  
> > diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
> > index b63860f7beab..40bec8d64b0a 100644
> > --- a/drivers/video/console/dummycon.c
> > +++ b/drivers/video/console/dummycon.c
> > @@ -77,3 +77,4 @@ const struct consw dummy_con = {
> >      .con_set_palette =	DUMMY,
> >      .con_scrolldelta =	DUMMY,
> >  };
> > +EXPORT_SYMBOL_GPL(dummy_con);
> > diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
> > index 9d8feac67637..84acd6223dc5 100644
> > --- a/drivers/video/console/vgacon.c
> > +++ b/drivers/video/console/vgacon.c
> > @@ -1440,5 +1440,6 @@ const struct consw vga_con = {
> >  	.con_build_attr = vgacon_build_attr,
> >  	.con_invert_region = vgacon_invert_region,
> >  };
> > +EXPORT_SYMBOL(vga_con);
> >  
> >  MODULE_LICENSE("GPL");
> > 
> 

