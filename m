Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935221AbaGXXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:25:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51638 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGXXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:25:24 -0400
Date: Fri, 25 Jul 2014 01:25:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: sysfs-related WARN_ON() when experimenting with broken disk
Message-ID: <20140724232522.GA6197@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I had some soft-lockups, and then...

1 lock held by scsi_eh_4/1629:
 #0:  (&us_interface_key[i]){......}, at: [<c44f2c80>]
 device_reset+0x20/0x50
usb 1-1: USB disconnect, device number 2
sd 4:0:0:0: Device offlined - not ready after error recovery
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb]  
Result: hostbyte=0x01 driverbyte=0x00
sd 4:0:0:0: [sdb] CDB: 
cdb[0]=0x28: 28 00 00 c4 33 40 00 00 40 00
end_request: I/O error, dev sdb, sector 12858176
Buffer I/O error on device sdb, logical block 1607272
Buffer I/O error on device sdb, logical block 1607273
Buffer I/O error on device sdb, logical block 1607274
Buffer I/O error on device sdb, logical block 1607275
Buffer I/O error on device sdb, logical block 1607276
Buffer I/O error on device sdb, logical block 1607277
Buffer I/O error on device sdb, logical block 1607278
Buffer I/O error on device sdb, logical block 1607279
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb]  
Result: hostbyte=0x01 driverbyte=0x00
sd 4:0:0:0: [sdb] CDB: 
cdb[0]=0x28: 28 00 00 c4 33 80 00 00 40 00
end_request: I/O error, dev sdb, sector 12858240
Buffer I/O error on device sdb, logical block 1607280
Buffer I/O error on device sdb, logical block 1607281
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3734 at fs/sysfs/group.c:216
sysfs_remove_group+0x87/0x90()
sysfs group c4b03810 not found for kobject 'target4:0:0'
Modules linked in:
CPU: 0 PID: 3734 Comm: dd_rescue Tainted: G        W    3.14.0 #336
Hardware name:                  /DG41MJ, BIOS
MJG4110H.86A.0006.2009.1223.1155 12/23/2009
 000000d8 f3b83d68 c47dbe8b c49eb156 f3b83d98 c4037fba c49d9478
 f3b83dc4
 00000e96 c49eb156 000000d8 c4145f87 c4145f87 00000000 c4b03810
 f13cec1c
 f3b83db0 c403805e 00000009 f3b83da8 c49d9478 f3b83dc4 f3b83dd8
 c4145f87
Call Trace:
 [<c47dbe8b>] dump_stack+0x41/0x52
 [<c4037fba>] warn_slowpath_common+0x7a/0xa0
 [<c4145f87>] ? sysfs_remove_group+0x87/0x90
 [<c4145f87>] ? sysfs_remove_group+0x87/0x90
 [<c403805e>] warn_slowpath_fmt+0x2e/0x30
 [<c4145f87>] sysfs_remove_group+0x87/0x90
 [<c43dbc1d>] dpm_sysfs_remove+0x2d/0x30
 [<c43d4dec>] device_del+0x2c/0x170
 [<c43f87b7>] scsi_target_reap_usercontext+0x27/0x40
 [<c43f8790>] ? scsi_add_device+0x30/0x30
 [<c404f154>] execute_in_process_context+0x74/0x80
 [<c43f7a2c>] scsi_target_reap+0x9c/0xc0
 [<c43f9947>] scsi_device_dev_release_usercontext+0xc7/0xf0
 [<c43f9880>] ? scsi_device_dev_release+0x20/0x20
 [<c404f154>] execute_in_process_context+0x74/0x80
 [<c43f9873>] scsi_device_dev_release+0x13/0x20
 [<c43d4247>] device_release+0x27/0x90
 [<c426fcfa>] kobject_release+0x7a/0x1c0
 [<c426fd18>] ? kobject_release+0x98/0x1c0
 [<c426fe6f>] kobject_put+0x2f/0x70
 [<c426fe6f>] ? kobject_put+0x2f/0x70
 [<c43d39ff>] put_device+0xf/0x20
 [<c43ee233>] scsi_device_put+0x33/0x50
 [<c43fca3d>] scsi_disk_put+0x2d/0x50
 [<c43fdaef>] sd_release+0x2f/0x60
 [<c411c788>] __blkdev_put+0x138/0x170
 [<c411c807>] blkdev_put+0x47/0x130
 [<c411c90a>] blkdev_close+0x1a/0x20
 [<c40eddd4>] __fput+0x84/0x1e0
 [<c40edf98>] ____fput+0x8/0x10
 [<c4050419>] task_work_run+0x69/0xb0
 [<c4002332>] do_notify_resume+0x42/0x50
 [<c47e0b8a>] work_notifysig+0x24/0x2a
---[ end trace 8da1d66d9dea492b ]---
usb 1-1: new high-speed USB device number 6 using ehci-pci
usb 1-1: New USB device found, idVendor=05e3, idProduct=0702
usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=4
usb 1-1: Product: USB Mass Storage Device 
usb 1-1: Manufacturer: Genesyslog���c
usb 1-1: SerialNumber: 0000400330
usb-storage 1-1:1.0: USB Mass Storage device detected
usb-storage 1-1:1.0: Quirks match for vid 05e3 pid 0702: 520
scsi6 : usb-storage 1-1:1.0
scsi 6:0:0:0: Direct-Access     WDC WD20 0BB-00CXA0       0811 PQ: 0
ANSI: 0
sd 6:0:0:0: [sdb] 39102336 512-byte logical blocks: (20.0 GB/18.6 GiB)

Any ideas? Worth debugging?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
