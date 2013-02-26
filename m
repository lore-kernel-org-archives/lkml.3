Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3BZA1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:27:36 -0500
Received: from magic.merlins.org ([209.81.13.136]:40494 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3BZA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:27:32 -0500
Date: Mon, 25 Feb 2013 16:27:31 -0800
From: Marc MERLIN <marc@merlins.org>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Cc: desnoyers@efficios.com
Subject: Reproduceable SATA lockup on 3.7.8 with SSD
Message-ID: <20130226002731.GC25875@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

I seem to have the same problem (or similar) as Mathieu Desnoyers in
https://lkml.org/lkml/2013/2/22/437

I can reliably get my SSD to drop from the SATA bus given the right workload
on linux.

How can I tell if it's linux's fault of the drive's fault?

Thanks,
Marc

----- Forwarded message from Marc MERLIN <marc@merlins.org> -----

From: Marc MERLIN <marc@merlins.org>
To: linux-ide@vger.kernel.org

Hopefully this is the right list. I know that IDE!=SATA, but I can't find
a SATA list.
Please redirect me if needed.

Hardware:
Lenovo T530, 64bit kernel and userland.
Hadware is shown below, but 2 drives, one SSD (OCZ-VERTEX4) and one HD (Hitachi HTS54101).

The SSD will lockup reliably if I do a specific mencoder command that reads MP4
files and rewrites them to another file in the same directory.

The log of what happens is shown below, the drive is eventually taken off the bus.
Once I reboot, it back, as if nothing happened.
If I do the same command on the HD, it works, but of course timings will be different
since the HD is slower.

How can I tell if it's the SSD's firmware's fault, or the linux SATA/AHCI code
that is buggy?

Thanks,
Marc

Failure log:
ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 frozen
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/00:00:00:38:13/04:00:33:00:00/40 tag 0 ncq 524288 out
         res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/00:08:00:3c:13/04:00:33:00:00/40 tag 1 ncq 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
(snipped)
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/00:e8:00:30:13/04:00:33:00:00/40 tag 29 ncq 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/00:f0:00:34:13/04:00:33:00:00/40 tag 30 ncq 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: hard resetting link
ata1: link is slow to respond, please be patient (ready=0)
ata1: COMRESET failed (errno=-16)
ata1: hard resetting link
ata1: link is slow to respond, please be patient (ready=0)
ata1: COMRESET failed (errno=-16)
ata1: hard resetting link
ata1: link is slow to respond, please be patient (ready=0)
ata1: COMRESET failed (errno=-16)
ata1: limiting SATA link speed to 3.0 Gbps
ata1: hard resetting link
ata1: COMRESET failed (errno=-16)
ata1: reset failed, giving up
ata1.00: disabled
ata1.00: device reported invalid CHS sector 0
(...)
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] CDB: 
Write(10): 2a 00 33 13 34 00 00 04 00 00
end_request: I/O error, dev sda, sector 856896512
sd 0:0:0:0: [sda] Unhandled error code


Boot shows:
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pio slum part ems sxs apst 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538100 irq 42
ata2: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538180 irq 42
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538300 irq 42
ata6: DUMMY
scsi6 : pata_legacy
ata7: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ATA-9: OCZ-VERTEX4, 1.5, max UDMA/133
ata1.00: 1000215216 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX4      1.5  PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata2.00: ATA-8: Hitachi HTS541010A9E680, JA0OA480, max UDMA/133
ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      Hitachi HTS54101 JA0O PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 1:0:0:0: [sdb] 4096-byte physical blocks
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!<6>[    1.433751] tsc: Refined TSC clocksource calibration: 2893.427 MHz
Switching to clocksource tsc
 sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: [sdb] Attached SCSI disk
ata5: SATA link down (SStatus 0 SControl 300)
scsi7 : pata_legacy
ata8: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15

----- End forwarded message -----

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
