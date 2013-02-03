Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3BCR1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:27:41 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60428 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3BCR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:27:39 -0500
Message-ID: <510E9E73.3000301@gmail.com>
Date: Sun, 03 Feb 2013 18:29:23 +0100
From: =?ISO-8859-1?Q?C=E9dric_Leporcq?= <cedl38@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: async error 262144 during suspend process - kernel 3.7.5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm encounter error during suspend to ram process. A full systemd 
startup process is used.
Computer : IBM Thinkpad T43
Linux kernel : 3.7.5

The error :
[code]
févr. 03 15:26:12 T43 kernel: dpm_run_callback(): 
scsi_bus_resume_common+0x0/0x70 [scsi_mod] returns 262144
févr. 03 15:26:12 T43 kernel: PM: Device 5:0:0:0 failed to resume async: 
error 262144[/code]

The probleme seem to be related to disque managment. I use RAID1 and lvm.

  Journalctrl  extracts:
[code]
-- Logs begin at sam. 2012-11-24 17:24:38 CET, end at dim. 2013-02-03 
15:28:59 CET. --
févr. 03 15:25:58 T43 systemd[1]: Starting Sleep.
févr. 03 15:25:58 T43 systemd[1]: Reached target Sleep.
févr. 03 15:25:58 T43 systemd[1]: Starting Suspend...
févr. 03 15:25:58 T43 systemd-sleep[1456]: Suspending system...
févr. 03 15:25:59 T43 kernel: PM: Syncing filesystems ... done.
févr. 03 15:25:59 T43 kernel: PM: Preparing system for mem sleep
févr. 03 15:26:12 T43 kernel: Freezing user space processes ... (elapsed 
0.01 seconds) done.
févr. 03 15:26:12 T43 systemd[1]: Time has been changed
févr. 03 15:26:12 T43 systemd[1]: systemd-tmpfiles-clean.timer: time 
change, recalculating next elapse.
févr. 03 15:26:12 T43 systemd-sleep[1456]: System resumed.
févr. 03 15:26:12 T43 kernel: Freezing remaining freezable tasks ... 
(elapsed 0.01 seconds) done.
févr. 03 15:26:12 T43 dhcpcd[415]: eth0: carrier lost
févr. 03 15:26:12 T43 dhcpcd[430]: eth0: carrier lost
févr. 03 15:26:12 T43 avahi-daemon[286]: Withdrawing address record for 
192.168.0.38 on eth0.
févr. 03 15:26:12 T43 avahi-daemon[286]: Leaving mDNS multicast group on 
interface eth0.IPv4 with address 192.168.0.38.
févr. 03 15:26:12 T43 avahi-daemon[286]: Interface eth0.IPv4 no longer 
relevant for mDNS.
févr. 03 15:26:12 T43 dhcpcd[454]: eth0: carrier lost
févr. 03 15:26:12 T43 udisksd[590]: Cleaning up mount point 
/run/media/cedric/ARCH_201301 (device 8:33 no longer exist)
févr. 03 15:26:12 T43 kernel: PM: Entering mem sleep
févr. 03 15:26:12 T43 kernel: Suspending console(s) (use 
no_console_suspend to debug)
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc] Stopping disk
févr. 03 15:26:12 T43 kernel: sd 1:0:0:0: [sdb] Synchronizing SCSI cache
févr. 03 15:26:12 T43 kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
févr. 03 15:26:12 T43 kernel: sd 1:0:0:0: [sdb] Stopping disk
févr. 03 15:26:12 T43 kernel: sd 0:0:0:0: [sda] Stopping disk
févr. 03 15:26:12 T43 kernel: parport_pc 00:0a: disabled
févr. 03 15:26:12 T43 kernel: serial 00:09: disabled
févr. 03 15:26:12 T43 kernel: serial 00:09: wake-up capability disabled 
by ACPI
févr. 03 15:26:12 T43 kernel: i915 0000:00:02.0: power state changed by 
ACPI to D3hot
févr. 03 15:26:12 T43 kernel: PM: suspend of devices complete after 
2246.181 msecs
févr. 03 15:26:12 T43 kernel: PM: late suspend of devices complete after 
0.304 msecs
févr. 03 15:26:12 T43 kernel: pcieport 0000:00:1c.0: wake-up capability 
enabled by ACPI
févr. 03 15:26:12 T43 kernel: ehci_hcd 0000:00:1d.7: wake-up capability 
enabled by ACPI
févr. 03 15:26:12 T43 kernel: ehci_hcd 0000:00:1d.7: power state changed 
by ACPI to D3hot
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.3: wake-up capability 
enabled by ACPI
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.1: wake-up capability 
enabled by ACPI
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.1: power state changed 
by ACPI to D2
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.0: wake-up capability 
enabled by ACPI
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.0: power state changed 
by ACPI to D2
févr. 03 15:26:12 T43 kernel: PM: noirq suspend of devices complete 
after 59.811 msecs
févr. 03 15:26:12 T43 kernel: ACPI: Preparing to enter system sleep state S3
févr. 03 15:26:12 T43 kernel: PM: Saving platform NVS memory
févr. 03 15:26:12 T43 kernel: Disabling non-boot CPUs ...
févr. 03 15:26:12 T43 kernel: Extended CMOS year: 2000
févr. 03 15:26:12 T43 kernel: ACPI: Low-level resume complete
févr. 03 15:26:12 T43 kernel: PM: Restoring platform NVS memory
févr. 03 15:26:12 T43 kernel: Extended CMOS year: 2000
févr. 03 15:26:12 T43 kernel: Force enabled HPET at resume
févr. 03 15:26:12 T43 kernel: ACPI: Waking up from system sleep state S3
févr. 03 15:26:12 T43 kernel: i915 0000:00:02.0: power state changed by 
ACPI to D0
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.0: power state changed 
by ACPI to D0
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.0: wake-up capability 
disabled by ACPI
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.1: power state changed 
by ACPI to D0
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.1: wake-up capability 
disabled by ACPI
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.3: wake-up capability 
disabled by ACPI
févr. 03 15:26:12 T43 kernel: ehci_hcd 0000:00:1d.7: power state changed 
by ACPI to D0
févr. 03 15:26:12 T43 kernel: ehci_hcd 0000:00:1d.7: wake-up capability 
disabled by ACPI
févr. 03 15:26:12 T43 kernel: PM: noirq resume of devices complete after 
2140.050 msecs
févr. 03 15:26:12 T43 kernel: PM: early resume of devices complete after 
0.366 msecs
févr. 03 15:26:12 T43 systemd[1]: Started Suspend.
févr. 03 15:26:12 T43 systemd[1]: Service sleep.target is not needed 
anymore. Stopping.
févr. 03 15:26:12 T43 systemd[1]: Stopping Sleep.
févr. 03 15:26:12 T43 systemd[1]: Stopped target Sleep.
févr. 03 15:26:12 T43 systemd[1]: Stopping Suspend.
févr. 03 15:26:12 T43 systemd[1]: Stopped target Suspend.
févr. 03 15:26:12 T43 logger[1494]: LID opened
févr. 03 15:26:12 T43 acpid[290]: client 396[0:0] has disconnected
févr. 03 15:26:12 T43 kernel: i915 0000:00:02.0: setting latency timer to 64
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.0: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: usb usb2: root hub lost power or was reset
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.1: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: usb usb3: root hub lost power or was reset
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.2: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: usb usb4: root hub lost power or was reset
févr. 03 15:26:12 T43 kernel: uhci_hcd 0000:00:1d.3: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: usb usb5: root hub lost power or was reset
févr. 03 15:26:12 T43 kernel: ehci_hcd 0000:00:1d.7: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: pci 0000:00:1e.0: setting latency timer to 64
févr. 03 15:26:12 T43 kernel: snd_intel8x0 0000:00:1e.2: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: ata_piix 0000:00:1f.2: setting latency 
timer to 64
févr. 03 15:26:12 T43 kernel: pcieport 0000:00:1c.0: wake-up capability 
disabled by ACPI
févr. 03 15:26:12 T43 kernel: tg3 0000:02:00.0 eth0: Link is down
févr. 03 15:26:12 T43 kernel: serial 00:09: activated
févr. 03 15:26:12 T43 kernel: parport_pc 00:0a: activated
févr. 03 15:26:12 T43 kernel: Extended CMOS year: 2000
févr. 03 15:26:12 T43 kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 
(SET FEATURES) succeeded
févr. 03 15:26:12 T43 kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 
(SECURITY FREEZE LOCK) filtered out
févr. 03 15:26:12 T43 kernel: ata1.00: ACPI cmd ef/03:45:00:00:00:a0 
(SET FEATURES) filtered out
févr. 03 15:26:12 T43 kernel: ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 
(SET FEATURES) filtered out
févr. 03 15:26:12 T43 kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 
(SET FEATURES) succeeded
févr. 03 15:26:12 T43 kernel: ata2.00: ACPI cmd ef/02:00:00:00:00:a0 
(SET FEATURES) succeeded
févr. 03 15:26:12 T43 kernel: ata2.00: ACPI cmd f5/00:00:00:00:00:a0 
(SECURITY FREEZE LOCK) filtered out
févr. 03 15:26:12 T43 kernel: ata2.00: ACPI cmd ef/03:45:00:00:00:a0 
(SET FEATURES) filtered out
févr. 03 15:26:12 T43 kernel: ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 
(SET FEATURES) filtered out
févr. 03 15:26:12 T43 kernel: ata1.00: configured for UDMA/100
févr. 03 15:26:12 T43 kernel: sd 0:0:0:0: [sda] Starting disk
févr. 03 15:26:12 T43 kernel: ata2.00: configured for UDMA/100
févr. 03 15:26:12 T43 kernel: sd 1:0:0:0: [sdb] Starting disk
févr. 03 15:26:12 T43 kernel: usb 3-1: reset low-speed USB device number 
2 using uhci_hcd
févr. 03 15:26:12 T43 kernel: ata6.00: disabled
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc] Starting disk
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc] START_STOP FAILED
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc]
févr. 03 15:26:12 T43 kernel: Result: hostbyte=0x04 driverbyte=0x00
févr. 03 15:26:12 T43 kernel: dpm_run_callback(): 
scsi_bus_resume_common+0x0/0x70 [scsi_mod] returns 262144
févr. 03 15:26:12 T43 kernel: PM: Device 5:0:0:0 failed to resume async: 
error 262144
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc] Stopping disk
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc] START_STOP FAILED
févr. 03 15:26:12 T43 kernel: sd 5:0:0:0: [sdc]
févr. 03 15:26:12 T43 kernel: Result: hostbyte=0x04 driverbyte=0x00
févr. 03 15:26:12 T43 kernel: pcmcia 0.0: pcmcia: registering new device 
pcmcia0.0 (IRQ: 3)
févr. 03 15:26:12 T43 kernel: PM: resume of devices complete after 
1181.313 msecs
févr. 03 15:26:12 T43 kernel: PM: Finishing wakeup.
févr. 03 15:26:12 T43 kernel: Restarting tasks ... done.
févr. 03 15:26:12 T43 kernel: video LNXVIDEO:00: Restoring backlight state
févr. 03 15:26:12 T43 kernel: scsi6 : pata_pcmcia
févr. 03 15:26:12 T43 kernel: ata7: PATA max PIO0 cmd 0x3100 ctl 0x310e 
irq 3
févr. 03 15:26:12 T43 logger[1502]: ACPI group/action undefined: 
processor / LNXCPU:00
févr. 03 15:26:12 T43 acpid[290]: client connected from 396[0:0]
févr. 03 15:26:12 T43 acpid[290]: 1 client rule loaded
févr. 03 15:26:13 T43 ifplugd[289]: Link beat lost.
févr. 03 15:26:13 T43 kernel: ata7.00: CFA: MMC/SD, 22.3.023, max PIO4
févr. 03 15:26:13 T43 kernel: ata7.00: 3862528 sectors, multi 0: LBA
févr. 03 15:26:13 T43 kernel: ata7.00: configured for PIO0
févr. 03 15:26:13 T43 kernel: scsi 6:0:0:0: Direct-Access ATA      
MMC/SD           22.3 PQ: 0 ANSI: 5
févr. 03 15:26:13 T43 kernel: sd 6:0:0:0: [sdc] 3862528 512-byte logical 
blocks: (1.97 GB/1.84 GiB)
févr. 03 15:26:13 T43 kernel: sd 6:0:0:0: [sdc] Write Protect is off
févr. 03 15:26:13 T43 kernel: sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
févr. 03 15:26:13 T43 kernel: sd 6:0:0:0: [sdc] Write cache: disabled, 
read cache: enabled, doesn't support DPO or FUA
févr. 03 15:26:13 T43 kernel:  sdc: sdc1
févr. 03 15:26:13 T43 kernel: sd 6:0:0:0: [sdc] Attached SCSI removable disk
févr. 03 15:26:14 T43 slim[301]: thunar-volman: Type de périphérique 
bloc inconnu.
févr. 03 15:26:14 T43 slim[301]: (xfdesktop:499): GLib-GIO-CRITICAL **: 
g_file_get_path: assertion `G_IS_FILE (file)' failed
févr. 03 15:26:14 T43 kernel: ISO 9660 Extensions: RRIP_1991A
[/code]
