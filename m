Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3CGOSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:18:17 -0500
Received: from ioctl.codeblau.de ([80.190.240.67]:58489 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753478Ab3CGOSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:18:15 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 09:18:15 EST
Date: Thu, 7 Mar 2013 15:11:33 +0100
From: felix-linuxkernel@fefe.de
To: linux-kernel@vger.kernel.org
Subject: blank screen on LVDS when switching to radeon with vga switcheroo
Message-ID: <20130307141133.GA7633@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a HP Envy 14 laptop, which has switchable graphics between:

00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)
01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Madison [Radeon HD 5000M Series] (rev ff)

This used to work (I'm not using it very often, so I don't know which kernel
version broke it), and I think it caused total kernel hang in 3.0 till 3.3 or
so.  Not it "works" in the sense that when a HDMI cable is connected, I get a
picture on the connected monitor.  But the primary display output, LVDS-2, stays black.

Here's the relevant dmesg parts:

agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 32768K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 40 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT1] (battery absent)
[drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 200x56
i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
i915 0000:00:02.0: registered panic notifier
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
acpi device:01: registered as cooling_device5
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
acpi device:0a: registered as cooling_device6
ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/LNXVIDEO:01/input/input4
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
radeon 0000:01:00.0: enabling device (0000 -> 0003)
[drm] initializing kernel modesetting (REDWOOD 0x1002:0x68C1 0x103C:0x1436).
[drm] register mmio base: 0xC4400000
[drm] register mmio size: 131072
vga_switcheroo: enabled
ATPX version 1
ATOM BIOS: MADISON
radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
mtrr: no more MTRRs available
[drm] Detected VRAM RAM=1024M, BAR=256M
[drm] RAM width 128bits DDR
[TTM] Zone  kernel: Available graphics memory: 3980934 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 1024M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
radeon 0000:01:00.0: irq 45 for MSI/MSI-X
radeon 0000:01:00.0: radeon: using MSI.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] probing gen 2 caps for device 8086:45 = 1/0
[drm] Loading REDWOOD Microcode
[drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
radeon 0000:01:00.0: WB enabled
radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff880251324c00
radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff880251324c0c
radeon 0000:01:00.0: enabling bus mastering
[drm] ring test on 0 succeeded in 1 usecs
[drm] ring test on 3 succeeded in 1 usecs
[drm] ib test on ring 0 succeeded in 0 usecs
[drm] ib test on ring 3 succeeded in 0 usecs
[drm] radeon atom DIG backlight initialized
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   LVDS-2
[drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
[drm]   Encoders:
[drm]     LCD1: INTERNAL_UNIPHY
[drm] Connector 1:
[drm]   DP-1
[drm]   HPD2
[drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY1
[drm] Connector 2:
[drm]   HDMI-A-1
[drm]   HPD1
[drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[drm]   Encoders:
[drm]     DFP2: INTERNAL_UNIPHY1
[drm] Internal thermal controller with fan control
[drm] radeon: power management initialized
[drm] fb mappable at 0xA0142000
[drm] vram apper at 0xA0000000
[drm] size 5787648
[drm] fb depth is 24
[drm]    pitch is 6400
radeon 0000:01:00.0: fb1: radeondrmfb frame buffer device
[drm] Initialized radeon 2.29.0 20080528 for 0000:01:00.0 on minor 1

When I start the intel framebuffer, the display is also black, but I
found out that that is just the brightness set to 0, so I wrote a little
too that writes to /sys/class/backlight/acpi_video0/brightness to set a
sensible brightness.

When the radeon screen stayed black, I assumed the same problem, so I
changed my tool to also write to
/sys/class/backlight/acpi_video1/brightness, but this does not help.

Do you have any suggestion on how to fix this?

Felix
