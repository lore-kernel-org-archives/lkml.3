Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3DWWD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:03:59 -0400
Received: from rm-rf.ca ([97.107.129.93]:46501 "EHLO hobbes.rm-rf.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab3DWWD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:03:57 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 18:03:57 EDT
Date: Tue, 23 Apr 2013 17:54:13 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: WD My Passport SCSI commands, kernel driver?
Message-ID: <20130423215413.GB14277@rm-rf.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WD My Passport harddrives contain hardware encryption. An
unlock utility is provided for other OSes, but not for Linux.
I'd like to know if the kernel is the correct place for code
to unlock this device, and any tips on how it should be
implemented. I've reverse engineered the vendor specific
commands needed to unlock the device.

When connecting a locked drive the following is shown:

[] usb 1-1: new full-speed USB device number 2 using ohci_hcd
[] usb 1-1: New USB device found, idVendor=1058, idProduct=0748
[] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[] usb 1-1: Product: My Passport 0748
[] usb 1-1: Manufacturer: Western Digital
[] usb 1-1: SerialNumber: ________________________
[] Initializing USB Mass Storage driver...
[] scsi3 : usb-storage 1-1:1.0
[] usbcore: registered new interface driver usb-storage
[] USB Mass Storage support registered.
[] scsi 3:0:0:0: Direct-Access     WD       My Passport 0748 1019 PQ: 0 ANSI: 6
[] scsi 3:0:0:1: CD-ROM            WD       Virtual CD 0748  1019 PQ: 0 ANSI: 6
[] scsi 3:0:0:2: Enclosure         WD       SES Device       1019 PQ: 0 ANSI: 6
[] sd 3:0:0:0: Attached scsi generic sg3 type 0
[] sr2: scsi3-mmc drive: 51x/51x caddy
[] sr 3:0:0:1: Attached scsi CD-ROM sr2
[] sr 3:0:0:1: Attached scsi generic sg4 type 5
[] scsi 3:0:0:2: Attached scsi generic sg5 type 13
[] sd 3:0:0:0: [sdb] Unit Not Ready
[] sd 3:0:0:0: [sdb]  Sense Key : Data Protect [current]
[] sd 3:0:0:0: [sdb]  Add. Sense: Logical unit access not authorized
[] sd 3:0:0:0: [sdb] 3906963456 512-byte logical blocks: (2.00 TB/1.81 TiB)
[] sd 3:0:0:0: [sdb] Write Protect is off
[] sd 3:0:0:0: [sdb] Mode Sense: 47 00 10 08
[] sd 3:0:0:0: [sdb] No Caching mode page present
[] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[] sd 3:0:0:0: [sdb] Unit Not Ready
[] sd 3:0:0:0: [sdb]  Sense Key : Data Protect [current]
[] sd 3:0:0:0: [sdb]  Add. Sense: Logical unit access not authorized
[] sd 3:0:0:0: [sdb] No Caching mode page present
[] sd 3:0:0:0: [sdb] Assuming drive cache: write through

Followed by 160 read errors:

[] sd 3:0:0:0: [sdb] Unhandled sense code
[] sd 3:0:0:0: [sdb]  Result: hostbyte=invalid driverbyte=DRIVER_SENSE
[] sd 3:0:0:0: [sdb]  Sense Key : Data Protect [current]
[] sd 3:0:0:0: [sdb]  Add. Sense: Logical unit access not authorized
[] sd 3:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[] end_request: critical target error, dev sdb, sector 0
[] Buffer I/O error on device sdb, logical block 0

After sending the correct command to the device using sg_raw,
including a hash of the password, the device will unlock and
sdb will be readable.

Is this something suited to the kernel, or better as a
standalone utility? And if it's suited for the kernel are there
any examples of other drives requiring unlock commands?

Thank you,

Kenny
