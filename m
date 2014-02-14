Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaBNIws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:52:48 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:63547 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaBNIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:52:45 -0500
Message-ID: <52FDD955.4000701@gmail.com>
Date: Fri, 14 Feb 2014 09:52:37 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: linux-ide@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Joerg Roedel <joro@8bytes.org>,
        Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Gerard Roudier <groudier@club-internet.fr>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: [dma-debug.c - DMA-API] exceeded overlapping =?UTF-8?B?4oCmICYgcw==?=
 =?UTF-8?B?eW01M2M4eHgg4oCmIHRyaWVzIHRvIGZyZWUgRE1BIOKApg==?=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ahoy!

Perhaps this is already solved, but I made ​​the effort to test & record
all of this, therefore here you are. :)

https://bugzilla.redhat.com/show_bug.cgi?id=1062833

0.
VirtIO disk - virtio-pc OK:
- lspci-knn-3.14.0-0.rc2.git2.1.fc21.x86_64-virtio-pc-virtio-disk-OK
https://bugzilla.redhat.com/attachment.cgi?id=863135
- dmesg-3.14.0-0.rc2.git2.1.fc21.x86_64-virtio-pc-virtio-disk-OK
https://bugzilla.redhat.com/attachment.cgi?id=863136


1.
IDE disk - ata_piix:
- lspci-knn-3.14.0-0.rc2.git2.1.fc21.x86_64-ata_piix-ide-disk
https://bugzilla.redhat.com/attachment.cgi?id=863137
- dmesg-3.14.0-0.rc2.git2.1.fc21.x86_64-ata_piix-ide-disk
"WARNING: CPU: 0 PID: 1328 at lib/dma-debug.c:491
add_dma_entry+0x127/0x130()"
"DMA-API: exceeded 7 overlapping mappings of pfn 2137"
https://bugzilla.redhat.com/attachment.cgi?id=863138


2.
SATA disk - ahci:
- lspci-knn-3.14.0-0.rc2.git2.1.fc21.x86_64-ahci-sata-disk
https://bugzilla.redhat.com/attachment.cgi?id=863139
- dmesg-3.14.0-0.rc2.git2.1.fc21.x86_64-ahci-sata-disk
"WARNING: CPU: 0 PID: 1543 at lib/dma-debug.c:491
add_dma_entry+0x127/0x130()"
"DMA-API: exceeded 7 overlapping mappings of pfn 2137"
https://bugzilla.redhat.com/attachment.cgi?id=863140


3.
SCSI disk - sym53c8xx:
- lspci-knn-3.14.0-0.rc2.git2.1.fc21.x86_64-sym53c8xx-scsi-disk
https://bugzilla.redhat.com/attachment.cgi?id=863151
- dmesg-3.14.0-0.rc2.git2.1.fc21.x86_64-sym53c8xx-scsi-disk
"WARNING: CPU: 1 PID: 1514 at lib/dma-debug.c:491
add_dma_entry+0x127/0x130()"
"DMA-API: exceeded 7 overlapping mappings of pfn 2137"
~~
"WARNING: CPU: 1 PID: 1514 at lib/dma-debug.c:1041
check_unmap+0x8b7/0x9b0()"
"sym53c8xx 0000:00:07.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000002137000] [size=512 bytes]"
https://bugzilla.redhat.com/attachment.cgi?id=863152


4.
VirtIO SCSI disk - 'virtio-scsi' & sym53c8xx:
- lspci-knn-3.14.0-0.rc2.git2.1.fc21.x86_64-sym53c8xx-virtio-scsi-disk
https://bugzilla.redhat.com/attachment.cgi?id=863153
- dmesg-3.14.0-0.rc2.git2.1.fc21.x86_64-sym53c8xx-virtio-scsi-disk
"WARNING: CPU: 0 PID: 1530 at lib/dma-debug.c:491
add_dma_entry+0x127/0x130()"
"DMA-API: exceeded 7 overlapping mappings of pfn 2137"
~~
"WARNING: CPU: 0 PID: 1530 at lib/dma-debug.c:1041
check_unmap+0x8b7/0x9b0()"
"sym53c8xx 0000:00:07.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000002137000] [size=512 bytes]"
https://bugzilla.redhat.com/attachment.cgi?id=863154


5.
USB disk - usb-storage:
- lspci-knn-3.14.0-0.rc2.git2.1.fc21.x86_64-usb-storage-usb-disk
https://bugzilla.redhat.com/attachment.cgi?id=863156
- lsusb-3.14.0-0.rc2.git2.1.fc21.x86_64-usb-storage-usb-disk
https://bugzilla.redhat.com/attachment.cgi?id=863157
- lsusb-t-3.14.0-0.rc2.git2.1.fc21.x86_64-usb-storage-usb-disk
https://bugzilla.redhat.com/attachment.cgi?id=863158
- dmesg-3.14.0-0.rc2.git2.1.fc21.x86_64-usb-storage-usb-disk
"WARNING: CPU: 0 PID: 415 at lib/dma-debug.c:491
add_dma_entry+0x127/0x130()"
"DMA-API: exceeded 7 overlapping mappings of pfn 2137"
https://bugzilla.redhat.com/attachment.cgi?id=863159


Tested with:
http://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/x86_64/os/images/
boot.iso                                         13-Feb-2014 15:45  362M

checkisomd5:
boot.iso:   434371185df324e28ff5652891ae4ea8
Fragment sums: 5a3e92cebf4721fcfad3e317bff6ac4ec9df98fedd9f53c3c3f2ed55c337
Fragment count: 20
Press [Esc] to abort check.
Checking: 100.0%

The media check is complete, the result is: PASS.

It is OK to use this media.

sha256sum:
2b6aac6e9b55c5f49f251340a4c28e091998f9fe3a6bdba7542f0f9b2d69ba8c  boot.iso


poma


