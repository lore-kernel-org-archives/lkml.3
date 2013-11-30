Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3K3Nc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:32:58 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36460 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3K3Nc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:32:56 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Nov 2013 08:32:56 EST
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION] 3.13-rc2: locks up hard on trying to transfer a file to mmc based internal SD card slot
Date: Sat, 30 Nov 2013 14:26:59 +0100
Message-ID: <86618305.vq7XZUDJDg@merkaba>
User-Agent: KMail/4.11.3 (Linux/3.12.0-tp520; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Just does that on a ThinkPad T520 with:

merkaba:~> lspci -nn | grep MMC
0d:00.0 System peripheral [0880]: Ricoh Co Ltd PCIe SDXC/MMC Host Controller 
[1180:e823] (rev 08)

Mouse pointer freezes, no Ctrl-Alt-F1.


merkaba:~> fdisk -l /dev/mmcblk0

Disk /dev/mmcblk0: 31.4 GB, 31439454208 bytes
255 heads, 63 sectors/track, 3822 cylinders, total 61405184 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

        Device Boot      Start         End      Blocks   Id  System
/dev/mmcblk0p1            8192    61405183    30698496    c  W95 FAT32 (LBA


merkaba:/sys/block/mmcblk0#2> grep . * 2>/dev/null
alignment_offset:0
capability:10
dev:179:0
discard_alignment:0
ext_range:8
force_ro:0
inflight:       0        0
range:8
removable:0
ro:0
size:61405184
stat:     176       33     1672      102        0        0        0        0        
0      102      102
uevent:MAJOR=179
uevent:MINOR=0
uevent:DEVNAME=mmcblk0
uevent:DEVTYPE=disk


I do not want to take the time to diagnose this further, especially as its one 
of those nasty "I just lock up and I don´t tell you what went wrong" kind of 
bugs. Thats just not a nice way to tell that there has been an error.


If there is any five or ten minute information gathering task, I am willing to 
provide more information, but right now there is no chance on Earth that I 
will be bisecting while having a long list of more interesting things to do 
than that.


Thus for now I just use 3.12 kernel again. Maybe I will try with some rc5 or 
so again.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
