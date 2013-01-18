Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3ARKPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:15:32 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:52523 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3ARKP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:15:29 -0500
MIME-Version: 1.0
Date: Fri, 18 Jan 2013 15:45:29 +0530
Message-ID: <CACk2A5ZgB1XmYBjs+83+oXVOMKPbHSUF6hh8ZgJAeSu+OLz_iA@mail.gmail.com>
Subject: Kernel Hangs after unplugging ext3 mounted pendrive from pc which
 uses MIPS processor with linux-2.6.36 kernel running on it.
From: vishnu vardhan <vardhanraj4143@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Summary:

Kernel Hangs after unplugging ext3 mounted pendrive from pc which uses
MIPS processor with linux-2.6.36 kernel running on it.

Full Description of the issue:

I have a Device which uses MIPS processor with linux-2.6.36 kernel on
that.I have ETRON usb host controller which supports usb 3.0 connected
to MIPS.When I plugin a EXT3 formatted pendrive in the usb port and
after it has been mounted, if I unplug it without safely removing, Iam
getting a kernel panic message and device is hanged and is no more
alive.But It works fine with FAT,EXT2 formatted pendrives.

Keyword:kernel

Kernel Information:
cat /proc/version#
Linux version 2.6.36 (gcc version 4.3.3 (crosstool-NG-1.5.1) #1 Thu
Jan 17 12:01:25 EST 2013

kernel version :
linux 2.6.36

Oops:
root@HomeCloud-3:/# usb 3-1: new high speed USB device number 4 using xhci_hcd
xhci_hcd 0000:00:00.0: WARN: short transfer on control ep
xhci_hcd 0000:00:00.0: WARN: short transfer on control ep
xhci_hcd 0000:00:00.0: WARN: short transfer on control ep
xhci_hcd 0000:00:00.0: WARN: short transfer on control ep
usb 3-1: New USB device found, idVendor=1ec9, idProduct=0001
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-1: Product: Swivel cricket
usb 3-1: Manufacturer: MBIL
usb 3-1: SerialNumber: 30B31600858E5A48
scsi4 : usb-storage 3-1:1.0
scsi 4:0:0:0: Direct-Access     MBIL     Swivel cricket   PMAP PQ: 0 ANSI: 0 CCS
sd 4:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: [sdb] 7634944 512-byte logical blocks: (3.90 GB/3.64 GiB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 < sdb5 >
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] Attached SCSI removable disk
FAT: utf8 is not a recommended IO charset for FAT filesystems,
filesystem will be case sensitive!
FAT: bogus number of reserved sectors
VFS: Can't find a valid FAT filesystem on dev sdb1.
FAT: utf8 is not a recommended IO charset for FAT filesystems,
filesystem will be case sensitive!
FAT: bogus number of reserved sectors
VFS: Can't find a valid FAT filesystem on dev sdb1.
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb5): using internal journal
EXT3-fs (sdb5): recovery complete
EXT3-fs (sdb5): mounted filesystem with writeback data mode
usb 3-1: USB disconnect, device number 4
Kernel bug detected[#1]:
Cpu 0
$ 0   : 00000000 00962b34 00000001 92c6371c
$ 4   : 906c1214 9e4901e4 0000af01 0000af00
$ 8   : 532f2303 00000020 00000000 00000000
$12   : 00000005 90650000 90549afc 00000001
$16   : 00000018 9e68fe68 906c1200 fffffffe
$20   : 0000002f 906c1a0c 906c1c0c 906c1e0c
$24   : 90549b04 90052aec
$28   : 9e68c000 9e68fe58 00200200 900781e0
Hi    : 0019e616
Lo    : 9846da7e
epc   : 900781d0 cascade+0x7c/0xbc
    Tainted: P
ra    : 900781e0 cascade+0x8c/0xbc
Status: 1100f802    KERNEL EXL
Cause : 00800034
PrId  : 0001974c (MIPS 74Kc)
Modules linked in: xcode4drv ufsd(P) hw_ctrl [last unloaded: xcode4drv]
Process afpd (pid: 2455, threadinfo=9e68c000, task=98641850, tls=2ba8b470)
Stack : 9e68fe78 9e37ec90 00000000 00000000 986d3e68 9e1181e4 906c1200 00000000
        9e68fea0 00000001 90650000 9007872c 00000040 00000000 00000000 00000003
        00000001 00000002 905beaf8 00962f38 906c200c 900520c8 00000000 906c10a8
        00000004 00000001 00000100 0000000a 906c0000 9064a1f0 906c10a4 90072ebc
        9064c394 00000003 00962f4c 00962f68 00000008 00962dd0 00000000 00962de0
        ...
Call Trace:
[<900781d0>] cascade+0x7c/0xbc
[<9007872c>] run_timer_softirq+0x188/0x210
[<90072ebc>] __do_softirq+0xb0/0x15c
[<90072fd4>] do_softirq+0x6c/0x74
[<9004002c>] ret_from_irq+0x0/0x4


Code: 00531024  02421026  0002102b <00028036> 00602821  0c01df93
02402021  02001821  1611fff5
Kernel panic - not syncing: Fatal exception in interrupt

Regards,
Vishnu.R
