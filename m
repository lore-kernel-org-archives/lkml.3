Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3D0JqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 05:46:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57434 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3D0JqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 05:46:17 -0400
Date: Sat, 27 Apr 2013 11:46:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, castet.matthieu@free.fr,
        shaohua.li@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: 3.9.0-rc8+: warning at pnpacpi/core.c:98 pnpacpi_set_resources
Message-ID: <20130427094614.GA30336@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I got this during resume on thinkpad x60:

Machine resumed ok, but I guess something is wrong there...

								Pavel

sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully
claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully
claim to support it.
usb usb1: usb resume
ehci-pci 0000:00:1d.7: resume root hub
usb usb2: usb resume
usb usb2: wakeup_rh
hub 2-0:1.0: hub_reset_resume
hub 2-0:1.0: trying to enable port power on non-switchable hub
usb usb3: usb resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_reset_resume
hub 3-0:1.0: trying to enable port power on non-switchable hub
usb usb4: usb resume
usb usb4: wakeup_rh
hub 4-0:1.0: hub_reset_resume
hub 4-0:1.0: trying to enable port power on non-switchable hub
usb usb5: usb resume
usb usb5: wakeup_rh
hub 5-0:1.0: hub_reset_resume
hub 5-0:1.0: trying to enable port power on non-switchable hub
------------[ cut here ]------------
WARNING: at drivers/pnp/pnpacpi/core.c:98
pnpacpi_set_resources+0x130/0x140()
Hardware name: 17097HU
Modules linked in:
Pid: 27615, comm: pm-suspend Tainted: G        W    3.9.0-rc8+ #248
Call Trace:
 [<c022ca4d>] warn_slowpath_common+0x6d/0xa0
 [<c04d1db0>] ? pnpacpi_set_resources+0x130/0x140
 [<c04d1db0>] ? pnpacpi_set_resources+0x130/0x140
 [<c022ca9d>] warn_slowpath_null+0x1d/0x20
 [<c04d1db0>] pnpacpi_set_resources+0x130/0x140
 [<c048ccbe>] ? acpi_bus_set_power+0x72/0x7e
 [<c04cf196>] pnp_start_dev+0x36/0xb0
 [<c0276fda>] ? mutex_remove_waiter+0x3a/0x100
 [<c04cdc2f>] pnp_bus_resume+0x5f/0x70
 [<c05859fd>] dpm_run_callback+0x3d/0x90
 [<c04cdbd0>] ? pnp_device_shutdown+0x20/0x20
 [<c0585ae7>] device_resume+0x97/0x160
 [<c05861f1>] dpm_resume+0xe1/0x1f0
 [<c0586f2b>] dpm_resume_end+0xb/0x20
 [<c026600f>] suspend_devices_and_enter+0x13f/0x2f0
 [<c02663c1>] pm_suspend+0x201/0x240
 [<c02657bd>] state_store+0x8d/0x90
 [<c0265730>] ? wakeup_count_show+0x40/0x40
 [<c043ee80>] kobj_attr_store+0x20/0x30
 [<c0326cc9>] sysfs_write_file+0x99/0xf0
 [<c02d2a8a>] vfs_write+0x9a/0x140
 [<c0326c30>] ? sysfs_open_file+0x1e0/0x1e0
 [<c02d2bf9>] sys_write+0x49/0x80
 [<c091c2b8>] sysenter_do_call+0x12/0x31
---[ end trace 752a759b0728fd3d ]---
serial 00:09: activated
parport_pc 00:0a: activated
ata6: port disabled--ignoring
hub 1-0:1.0: hub_resume
ehci-pci 0000:00:1d.7: GetStatus port:6 status 001002 0  ACK POWER
sig=se0 CSC
hub 1-0:1.0: port 6: status 0100 change 0001
uhci_hcd 0000:00:1d.3: port 2 portsc 009b,00
hub 5-0:1.0: port 2: status 0101 change 0003
hub 1-0:1.0: port 6 status 0000.0100 after resume, -19
usb 1-6: can't resume, status -19
hub 1-0:1.0: logical disconnect on port 6
usb 5-2: finish reset-resume
usb 5-2: reset full-speed USB device number 3 using uhci_hcd
usb 5-2: ep0 maxpacket = 8
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered
out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered
out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] Starting disk
thinkpad_acpi: ACPI backlight control delay disabled
PM: resume of devices complete after 2924.037 msecs


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
