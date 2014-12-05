Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaLESbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:31:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51441 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaLESbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:31:03 -0500
Date: Fri, 5 Dec 2014 18:30:58 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [Bisected] linux-next 20141205 fails to mount ext4 fs on arm64 with
 CONFIG_ARM64_64K_PAGES=y
Message-ID: <20141205183057.GO821@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 05 Dec 2014 18:30:58.0898 (UTC) FILETIME=[9D5EE320:01D010B9]
X-MC-Unique: 114120518310001701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I was testing linux-next for 20141205 today with CONFIG_ARM64_64K_PAGES=y
when I've got the following in my kernel log when trying to mount the ext4
filesystem that I'm using:

hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
usb 1-1.2: new high-speed USB device number 3 using ehci-platform
usb-storage 1-1.2:1.0: USB Mass Storage device detected
scsi host0: usb-storage 1-1.2:1.0
atkbd serio0: keyboard reset failed on 1c060000.kmi
Waiting for root device /dev/sda3...
usb 1-1.1: new low-speed USB device number 4 using ehci-platform
input: USB Keyboard as /devices/platform/7ffc0000.ehci/usb1/1-1/1-1.1/1-1.1:1.0/0003:0DC6:3910.0001/input/input2
hid-generic 0003:0DC6:3910.0001: input: USB HID v1.00 Keyboard [USB Keyboard] on usb-7ffc0000.ehci-1.1/input0
input: USB Keyboard as /devices/platform/7ffc0000.ehci/usb1/1-1/1-1.1/1-1.1:1.1/0003:0DC6:3910.0002/input/input3
hid-generic 0003:0DC6:3910.0002: input: USB HID v1.00 Mouse [USB Keyboard] on usb-7ffc0000.ehci-1.1/input1
atkbd serio1: keyboard reset failed on 1c070000.kmi
scsi 0:0:0:0: Direct-Access     Toshiba  StorE HDD        0000 PQ: 0 ANSI: 4
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 38 00 00 00
sd 0:0:0:0: [sda] No Caching mode page found
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
EXT3-fs (sda3): error: couldn't mount because of unsupported optional features (240)
EXT2-fs (sda3): error: couldn't mount because of unsupported optional features (240)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 128 failed (15930!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 129 failed (54075!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 130 failed (42043!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 131 failed (18746!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 132 failed (19003!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 133 failed (42810!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 134 failed (53306!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 135 failed (15675!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 136 failed (54840!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 137 failed (15161!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 138 failed (19513!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 139 failed (41272!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 140 failed (41529!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 141 failed (20280!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 142 failed (14392!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 143 failed (54585!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 144 failed (44605!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 145 failed (17212!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 146 failed (13372!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 147 failed (55613!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 148 failed (55868!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 149 failed (14141!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 150 failed (16445!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 151 failed (44348!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 152 failed (17983!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 153 failed (43838!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 154 failed (56382!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 155 failed (12607!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 156 failed (12862!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 157 failed (57151!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 158 failed (43071!=0)
EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 159 failed (17726!=0)
EXT4-fs (sda3): ext4_check_descriptors: Inode bitmap for group 160 not in group (block 89328390)!
EXT4-fs (sda3): group descriptors corrupted!
List of all partitions:
b300         1931264 mmcblk0  driver: mmcblk
  b301         1930240 mmcblk0p1 00000000-01
0800       488386584 sda  driver: sd
  0801       125829120 sda1 00000000-01
  0802         5242880 sda2 00000000-02
  0803       357313560 sda3 00000000-03
No filesystem could mount root, tried:  ext3 ext2 ext4 vfat fuseblk
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,3)
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc7-next-20141204+ #1

I've bisected the tree and I've got commit fdfe073987619ec375da8d8a2701ab271d1b1339
as the culprit:

This is my git bisect log:

git bisect start
# bad: [8191d07dbb16ae88cc2bc475584b9f185f02795f] Add linux-next specific files for 20141205
git bisect bad 8191d07dbb16ae88cc2bc475584b9f185f02795f
# good: [009d0431c3914de64666bec0d350e54fdd59df6a] Linux 3.18-rc7
git bisect good 009d0431c3914de64666bec0d350e54fdd59df6a
# bad: [9b3388a8bfa50258aa1df91bef1705b3311a8b67] Merge remote-tracking branch 'drm/drm-next'
git bisect bad 9b3388a8bfa50258aa1df91bef1705b3311a8b67
# bad: [35eee2dc6bbd9a8db5c0385631f5302af9929cd5] Merge remote-tracking branch 'libata/for-next'
git bisect bad 35eee2dc6bbd9a8db5c0385631f5302af9929cd5
# good: [4e4a560c90bb182391e8b98c57e6a5223788b4f9] Merge remote-tracking branch 'tegra/for-next'
git bisect good 4e4a560c90bb182391e8b98c57e6a5223788b4f9
# bad: [2c238f7790667f31d511d2b44952c0b9b40799a5] Merge remote-tracking branch 'nfsd/nfsd-next'
git bisect bad 2c238f7790667f31d511d2b44952c0b9b40799a5
# good: [66170786651f0716db0ad418bfaaac774b4009e4] Merge remote-tracking branch 'nios2/nios2-next'
git bisect good 66170786651f0716db0ad418bfaaac774b4009e4
# good: [aa3eef6d532c04a3fba5b11cca8bf473ac8a2a09] Merge remote-tracking branch 'ecryptfs/next'
git bisect good aa3eef6d532c04a3fba5b11cca8bf473ac8a2a09
# good: [9c01503f4da3ff9c327d37249fe148ed7c188b20] f2fs: cleanup redundant macro
git bisect good 9c01503f4da3ff9c327d37249fe148ed7c188b20
# bad: [07809818fe6493f01f8390a4a300799cdad595bd] Merge remote-tracking branch 'fscache/fscache'
git bisect bad 07809818fe6493f01f8390a4a300799cdad595bd
# bad: [58b33d9d920c39f0975db7d8ededc2e2ee1553c0] ext4: prevent fsreentrance deadlock for inline_data
git bisect bad 58b33d9d920c39f0975db7d8ededc2e2ee1553c0
# good: [624d0f1dd7c80d2bac4fc3066b2ff3947f890883] ext4: cleanup flag definitions for extent status tree
git bisect good 624d0f1dd7c80d2bac4fc3066b2ff3947f890883
# good: [b003b52496b9bea9b186b127aea730b79d2a83bd] ext4: don't count external journal blocks as overhead
git bisect good b003b52496b9bea9b186b127aea730b79d2a83bd
# good: [6d75eef94272c5f0cb511c3d6e77d863c695fb0d] ext4: Remove an unnecessary check for NULL before iput()
git bisect good 6d75eef94272c5f0cb511c3d6e77d863c695fb0d
# good: [2f2d74ef698b163a7c39bfa101af944ef0021210] ext4: forbid journal_async_commit in data=ordered mode
git bisect good 2f2d74ef698b163a7c39bfa101af944ef0021210
# bad: [fdfe073987619ec375da8d8a2701ab271d1b1339] ext4: fix potential use after free during resize
git bisect bad fdfe073987619ec375da8d8a2701ab271d1b1339
# first bad commit: [fdfe073987619ec375da8d8a2701ab271d1b1339] ext4: fix potential use after free during resize


Best regards,
Liviu


-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

