Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaLESyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:54:25 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47686 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaLESyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:54:23 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Bisected] linux-next 20141205 fails to mount ext4 fs on arm64 with CONFIG_ARM64_64K_PAGES=y
In-Reply-To: <20141205183057.GO821@e106497-lin.cambridge.arm.com>
References: <20141205183057.GO821@e106497-lin.cambridge.arm.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 05 Dec 2014 22:54:20 +0400
Message-ID: <87oari6i77.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Liviu Dudau <Liviu.Dudau@arm.com> writes:

Yes. This is my crap.
- sbi->s_group_desc[group_desc]
+ gd_bh = *rcu_dereference(sbi->s_group_desc) + group_desc;

Ted I have to admit that I'm an idiot.
I already have fix where I've fixed the typo and complain from sparse
which was reported by kbuild01. In order to prevent similar shame in future I've wrote several
tests for resize2fs and unfortunately they are failed even w/o my
patches. It is appeared that resize2fs is broken for big disks.
So feel free to drop the patch, and give me some tome to investigate the
issues. I'll back with the patch-set in 24hrs.


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> Hi Dmitry,
>
> I was testing linux-next for 20141205 today with CONFIG_ARM64_64K_PAGES=
=3Dy
> when I've got the following in my kernel log when trying to mount the ext4
> filesystem that I'm using:
>
> hub 1-1:1.0: USB hub found
> hub 1-1:1.0: 4 ports detected
> usb 1-1.2: new high-speed USB device number 3 using ehci-platform
> usb-storage 1-1.2:1.0: USB Mass Storage device detected
> scsi host0: usb-storage 1-1.2:1.0
> atkbd serio0: keyboard reset failed on 1c060000.kmi
> Waiting for root device /dev/sda3...
> usb 1-1.1: new low-speed USB device number 4 using ehci-platform
> input: USB Keyboard as /devices/platform/7ffc0000.ehci/usb1/1-1/1-1.1/1-1=
.1:1.0/0003:0DC6:3910.0001/input/input2
> hid-generic 0003:0DC6:3910.0001: input: USB HID v1.00 Keyboard [USB Keybo=
ard] on usb-7ffc0000.ehci-1.1/input0
> input: USB Keyboard as /devices/platform/7ffc0000.ehci/usb1/1-1/1-1.1/1-1=
.1:1.1/0003:0DC6:3910.0002/input/input3
> hid-generic 0003:0DC6:3910.0002: input: USB HID v1.00 Mouse [USB Keyboard=
] on usb-7ffc0000.ehci-1.1/input1
> atkbd serio1: keyboard reset failed on 1c070000.kmi
> scsi 0:0:0:0: Direct-Access     Toshiba  StorE HDD        0000 PQ: 0 ANSI=
: 4
> sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 38 00 00 00
> sd 0:0:0:0: [sda] No Caching mode page found
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1 sda2 sda3
> sd 0:0:0:0: [sda] Attached SCSI disk
> EXT3-fs (sda3): error: couldn't mount because of unsupported optional fea=
tures (240)
> EXT2-fs (sda3): error: couldn't mount because of unsupported optional fea=
tures (240)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 128 failed (15=
930!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 129 failed (54=
075!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 130 failed (42=
043!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 131 failed (18=
746!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 132 failed (19=
003!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 133 failed (42=
810!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 134 failed (53=
306!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 135 failed (15=
675!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 136 failed (54=
840!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 137 failed (15=
161!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 138 failed (19=
513!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 139 failed (41=
272!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 140 failed (41=
529!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 141 failed (20=
280!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 142 failed (14=
392!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 143 failed (54=
585!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 144 failed (44=
605!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 145 failed (17=
212!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 146 failed (13=
372!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 147 failed (55=
613!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 148 failed (55=
868!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 149 failed (14=
141!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 150 failed (16=
445!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 151 failed (44=
348!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 152 failed (17=
983!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 153 failed (43=
838!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 154 failed (56=
382!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 155 failed (12=
607!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 156 failed (12=
862!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 157 failed (57=
151!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 158 failed (43=
071!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Checksum for group 159 failed (17=
726!=3D0)
> EXT4-fs (sda3): ext4_check_descriptors: Inode bitmap for group 160 not in=
 group (block 89328390)!
> EXT4-fs (sda3): group descriptors corrupted!
> List of all partitions:
> b300         1931264 mmcblk0  driver: mmcblk
>   b301         1930240 mmcblk0p1 00000000-01
> 0800       488386584 sda  driver: sd
>   0801       125829120 sda1 00000000-01
>   0802         5242880 sda2 00000000-02
>   0803       357313560 sda3 00000000-03
> No filesystem could mount root, tried:  ext3 ext2 ext4 vfat fuseblk
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block=
(8,3)
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc7-next-20141204+ #1
>
> I've bisected the tree and I've got commit fdfe073987619ec375da8d8a2701ab=
271d1b1339
> as the culprit:
>
> This is my git bisect log:
>
> git bisect start
> # bad: [8191d07dbb16ae88cc2bc475584b9f185f02795f] Add linux-next specific=
 files for 20141205
> git bisect bad 8191d07dbb16ae88cc2bc475584b9f185f02795f
> # good: [009d0431c3914de64666bec0d350e54fdd59df6a] Linux 3.18-rc7
> git bisect good 009d0431c3914de64666bec0d350e54fdd59df6a
> # bad: [9b3388a8bfa50258aa1df91bef1705b3311a8b67] Merge remote-tracking b=
ranch 'drm/drm-next'
> git bisect bad 9b3388a8bfa50258aa1df91bef1705b3311a8b67
> # bad: [35eee2dc6bbd9a8db5c0385631f5302af9929cd5] Merge remote-tracking b=
ranch 'libata/for-next'
> git bisect bad 35eee2dc6bbd9a8db5c0385631f5302af9929cd5
> # good: [4e4a560c90bb182391e8b98c57e6a5223788b4f9] Merge remote-tracking =
branch 'tegra/for-next'
> git bisect good 4e4a560c90bb182391e8b98c57e6a5223788b4f9
> # bad: [2c238f7790667f31d511d2b44952c0b9b40799a5] Merge remote-tracking b=
ranch 'nfsd/nfsd-next'
> git bisect bad 2c238f7790667f31d511d2b44952c0b9b40799a5
> # good: [66170786651f0716db0ad418bfaaac774b4009e4] Merge remote-tracking =
branch 'nios2/nios2-next'
> git bisect good 66170786651f0716db0ad418bfaaac774b4009e4
> # good: [aa3eef6d532c04a3fba5b11cca8bf473ac8a2a09] Merge remote-tracking =
branch 'ecryptfs/next'
> git bisect good aa3eef6d532c04a3fba5b11cca8bf473ac8a2a09
> # good: [9c01503f4da3ff9c327d37249fe148ed7c188b20] f2fs: cleanup redundan=
t macro
> git bisect good 9c01503f4da3ff9c327d37249fe148ed7c188b20
> # bad: [07809818fe6493f01f8390a4a300799cdad595bd] Merge remote-tracking b=
ranch 'fscache/fscache'
> git bisect bad 07809818fe6493f01f8390a4a300799cdad595bd
> # bad: [58b33d9d920c39f0975db7d8ededc2e2ee1553c0] ext4: prevent fsreentra=
nce deadlock for inline_data
> git bisect bad 58b33d9d920c39f0975db7d8ededc2e2ee1553c0
> # good: [624d0f1dd7c80d2bac4fc3066b2ff3947f890883] ext4: cleanup flag def=
initions for extent status tree
> git bisect good 624d0f1dd7c80d2bac4fc3066b2ff3947f890883
> # good: [b003b52496b9bea9b186b127aea730b79d2a83bd] ext4: don't count exte=
rnal journal blocks as overhead
> git bisect good b003b52496b9bea9b186b127aea730b79d2a83bd
> # good: [6d75eef94272c5f0cb511c3d6e77d863c695fb0d] ext4: Remove an unnece=
ssary check for NULL before iput()
> git bisect good 6d75eef94272c5f0cb511c3d6e77d863c695fb0d
> # good: [2f2d74ef698b163a7c39bfa101af944ef0021210] ext4: forbid journal_a=
sync_commit in data=3Dordered mode
> git bisect good 2f2d74ef698b163a7c39bfa101af944ef0021210
> # bad: [fdfe073987619ec375da8d8a2701ab271d1b1339] ext4: fix potential use=
 after free during resize
> git bisect bad fdfe073987619ec375da8d8a2701ab271d1b1339
> # first bad commit: [fdfe073987619ec375da8d8a2701ab271d1b1339] ext4: fix =
potential use after free during resize
>
>
> Best regards,
> Liviu
>
>
> --=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> | I would like to |
> | fix the world,  |
> | but they're not |
> | giving me the   |
>  \ source code!  /
>   ---------------
>     =C2=AF\_(=E3=83=84)_/=C2=AF

--=-=-=--
