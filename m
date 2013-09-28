Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3I1Jk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 05:40:27 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48891 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3I1JkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 05:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <m2siwps45q.fsf@linux-m68k.org>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
 <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
 <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
 <20130927150156.GE26069@arm.com> <CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
 <m2wqm1s6f5.fsf@linux-m68k.org> <CALkWK0nzk6s-C97ze4Ev8gY6fwPbf-qRCfCDvDDE56HFxvzw0A@mail.gmail.com>
 <m2siwps45q.fsf@linux-m68k.org>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sat, 28 Sep 2013 15:09:42 +0530
Message-ID: <CALkWK0=ii-usQ17qpwDMwCbJAPhDTghz6j8J7JEeZ5Uwnn-awQ@mail.gmail.com>
Subject: Re: [QUERY] Building and testing Aarch64
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Ramkumar Ramachandra <artagnon@gmail.com> writes:
>> Is there a bug in the Kconfig dependency tree? Sounds like VIRTIO_MMIO
>> requires some vga (?) drivers to be compiled in as well.

I hit this bug when I do `make menuconfig` directly (which
configuration does it start out with?). When I `make defconfig`
(picking up arch/arm64/configs/defconfig), and then enable VIRTIO_MMIO
in the menuconfig, it builds fine.

> I don't have any VGA option enabled.  You should use a serial console
> with CONFIG_SERIAL_AMBA_PL011_CONSOLE.

arch/arm64/configs/defconfig:676 already builds this feature in.

Unfortunately, even with VIRTIO_MMIO built in, I get the same error:

  VFS: Cannot open root device "vda" or unknown-block(0,0): error -6
  Please append a correct "root=" boot option; here are the available
partitions:
  Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

Any hints on how to proceed from here? What is your kernel
configuration (are you using arch/arm64/configs/defconfig)? Is
root=/dev/vda part of your kernel arguments?

How is this supposed to work? When I pass the rootfs-file as the
--block-device, it's supposed to see the file as the block device
/dev/vda (what determines this?), mount it, and finally get devtmpfs
to populate the /dev, right? The transcript from the working
linux-system.axf (with raring-rootfs) looks like:

[    4.977788]  vda: unknown partition table
[    4.997392] mtdoops: mtd device (mtddev=name/number) must be supplied
[    5.001787] smc91x: not found (-19).
[    5.011141] mousedev: PS/2 mouse device common for all mice
[    5.020830] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18)
initialised: dm-devel@redhat.com
[    5.027396] TCP: cubic registered
[    5.027456] Initializing XFRM netlink socket
[    5.027885] NET: Registered protocol family 17
[    5.028207] NET: Registered protocol family 15
[    5.047665] EXT3-fs (vda): error: couldn't mount because of
unsupported optional features (240)
[    5.050214] EXT2-fs (vda): error: couldn't mount because of
unsupported optional features (244)
[    5.095085] EXT4-fs (vda): recovery complete
[    5.096307] EXT4-fs (vda): mounted filesystem with ordered data
mode. Opts: (null)
[    5.096723] VFS: Mounted root (ext4 filesystem) on device 254:0.
[    5.098965] devtmpfs: mounted

What am I missing?
