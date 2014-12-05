Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaLEQfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:35:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43543 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaLEQfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:35:15 -0500
Date: Fri, 5 Dec 2014 16:35:11 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Message-ID: <20141205163511.GM821@e106497-lin.cambridge.arm.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
MIME-Version: 1.0
In-Reply-To: <1417707993-82290-1-git-send-email-agraf@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 05 Dec 2014 16:35:12.0583 (UTC) FILETIME=[710B5570:01D010A9]
X-MC-Unique: 114120516351310901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:46:33PM +0000, Alexander Graf wrote:
> With binutils 2.25 the default alignment for 32bit arm sections changed to
> have everything 64k aligned. Armv7 binaries built with this binutils version
> run successfully on an arm64 system.
> 
> Since effectively there is now the chance to run armv7 code on arm64 even
> with 64k page size, it doesn't make sense to block people from enabling
> CONFIG_COMPAT on those configurations.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> ---
>  arch/arm64/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9532f8d..3cf4f238 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
>  
>  config COMPAT
>  	bool "Kernel support for 32-bit EL0"
> -	depends on !ARM64_64K_PAGES
>  	select COMPAT_BINFMT_ELF
>  	select HAVE_UID16
>  	select OLD_SIGSUSPEND3
> -- 
> 1.7.12.4
> 

Hi Alexander,

For what is worth, today's linux-next (20141204) does not boot on arm64
if I select CONFIG_ARM64_64K_PAGES. ext4 filesystem fails to mount with:

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


Same filesystem (no fsck inbetween) but with a 4K pages kernel boots fine.

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

