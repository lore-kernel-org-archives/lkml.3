Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaHOJje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:39:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39741 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaHOJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:39:32 -0400
Date: Fri, 15 Aug 2014 11:38:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
        jani-nikula@linux.intel.com
Subject: 3.17-rc0: cursor on pipe A assertion failure
Message-ID: <20140815093834.GC29442@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Today X session died on me (painful :-().

I got this in dmesg, not sure if it is related. Any ideas?

Thanks,
									Pavel

Initializing cgroup subsys cpu
Linux version 3.16.0+ (pavel@duo) (gcc version 4.4.5 (Debian 4.4.5-8) ) #391 SMP Thu Aug 14 20:00:12 CEST 2014
Disabled fast string operations
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000007f6cffff] usable
BIOS-e820: [mem 0x000000007f6d0000-0x000000007f6defff] ACPI data
BIOS-e820: [mem 0x000000007f6df000-0x000000007f6fffff] ACPI NVS
BIOS-e820: [mem 0x000000007f700000-0x000000007fffffff] reserved
BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
SMBIOS 2.4 present.
DMI: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
...
ieee80211 phy0: wlan0: No probe response from AP 00:11:95:05:30:d7 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:11:95:05:30:d7
wlan0: send auth to 00:11:95:05:30:d7 (try 1/3)
wlan0: authenticated
iwl3945 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
iwl3945 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
wlan0: associate with 00:11:95:05:30:d7 (try 1/3)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x401 status=0 aid=5)
wlan0: associated
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3169 at drivers/gpu/drm/i915/intel_display.c:1234 T.2633+0x9c/0xa0()
cursor on pipe A assertion failure (expected off, current on)
Modules linked in:
CPU: 0 PID: 3169 Comm: Xorg Not tainted 3.16.0+ #391
Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
 000004d2 ddaddcac c482d33d c4aabe90 ddaddcdc c403926a c4aae20c ddaddd08
 00000c61 c4aabe90 000004d2 c43cb9ec c43cb9ec f4fe0000 00000041 00000000
 ddaddcf4 c403930e 00000009 ddaddcec c4aae20c ddaddd08 ddaddd1c c43cb9ec
Call Trace:
 [<c482d33d>] dump_stack+0x41/0x52
 [<c403926a>] warn_slowpath_common+0x7a/0xa0
 [<c43cb9ec>] ? T.2633+0x9c/0xa0
 [<c43cb9ec>] ? T.2633+0x9c/0xa0
 [<c403930e>] warn_slowpath_fmt+0x2e/0x30
 [<c43cb9ec>] T.2633+0x9c/0xa0
 [<c43cbac8>] intel_enable_pipe+0x38/0x1c0
 [<c43cc5ee>] i9xx_crtc_enable+0x36e/0x480
 [<c43c2922>] intel_crtc_control+0xf2/0x100
 [<c43c2986>] intel_crtc_update_dpms+0x56/0x70
 [<c43dd4aa>] intel_crt_dpms+0x7a/0x90
 [<c436da9d>] drm_mode_obj_set_property_ioctl+0x4ad/0x4e0
 [<c436d113>] ? drm_modeset_unlock_all+0x43/0x60
 [<c436db05>] drm_mode_connector_property_set_ioctl+0x35/0x50
 [<c4362597>] drm_ioctl+0x267/0x540
 [<c436dad0>] ? drm_mode_obj_set_property_ioctl+0x4e0/0x4e0
 [<c40703ae>] ? __lock_acquire+0x3ae/0xc80
 [<c4362330>] ? drm_getstats+0x60/0x60
 [<c4106739>] do_vfs_ioctl+0x79/0x5d0
 [<c4112cd7>] ? mntput_no_expire+0x57/0x1b0
 [<c4112c80>] ? may_umount+0xa0/0xa0
 [<c4112e49>] ? mntput+0x19/0x30
 [<c40f83f2>] ? __fput+0x112/0x1b0
 [<c4106cd7>] SyS_ioctl+0x47/0x70
 [<c483225e>] syscall_call+0x7/0x7
---[ end trace d7bbb3f10535eb0b ]---
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x1000-0x107f] has bogus alignment
yenta_cardbus 0000:15:00.0: CardBus bridge to [bus 16-17]
yenta_cardbus 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
yenta_cardbus 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
yenta_cardbus 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
yenta_cardbus 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
e1000e 0000:02:00.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
iwl3945 0000:03:00.0: no hotplug settings from platform
pcieport 0000:00:1c.2: no hotplug settings from platform
pcieport 0000:00:1c.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:15:00.1: no hotplug settings from platform
pci 0000:15:00.1: using default PCI settings
sdhci-pci 0000:15:00.2: no hotplug settings from platform
sdhci-pci 0000:15:00.2: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ahci 0000:00:1f.2: no hotplug settings from platform
ahci 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x1000-0x107f] has bogus alignment
yenta_cardbus 0000:15:00.0: CardBus bridge to [bus 16-17]
yenta_cardbus 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
yenta_cardbus 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
yenta_cardbus 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
yenta_cardbus 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
e1000e 0000:02:00.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
iwl3945 0000:03:00.0: no hotplug settings from platform
pcieport 0000:00:1c.2: no hotplug settings from platform
pcieport 0000:00:1c.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:15:00.1: no hotplug settings from platform
pci 0000:15:00.1: using default PCI settings
sdhci-pci 0000:15:00.2: no hotplug settings from platform
sdhci-pci 0000:15:00.2: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ahci 0000:00:1f.2: no hotplug settings from platform
ahci 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
pci_bus 0000:02: Allocating resources
pci_bus 0000:03: Allocating resources
pci_bus 0000:04: Allocating resources
pci_bus 0000:0c: Allocating resources
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x1000-0x107f] has bogus alignment

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
