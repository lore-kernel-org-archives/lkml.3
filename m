Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3FMCfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:35:31 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41732 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3FMCf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:35:28 -0400
Date: Wed, 12 Jun 2013 21:35:16 -0500
From: Rob Landley <rob@landley.net>
Subject: Commit f9afbd45b0d0 broke mips r4k.
To: linux-kernel@vger.kernel.org, sanjayl@kymasys.com, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, ralf@linux-mips.org
X-Mailer: Balsa 2.4.11
Message-Id: <1371090916.2776.104@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-DO9XbtZD2xmClfVVzSRk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-DO9XbtZD2xmClfVVzSRk
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

My aboriginal linux project builds tiny linux systems to run under =20
qemu, producing as close to the same system as possible across a bunch =20
of different architectures. The above change broke the mips r4k build =20
I've been running under qemu.

Here's a toolchain and reproduction sequence:

   wget http://landley.net/aboriginal/bin/cross-compiler-mips.tar.bz2
   tar xvjf cross-compiler-mips.tar.bz2
   export PATH=3D$PWD/cross-compiler-mips/bin:$PATH
   make ARCH=3Dmips allnoconfig KCONFIG_ALLCONFIG=3Dminiconfig.mips
   make CROSS_COMPILE=3Dmips- ARCH=3Dmips

(The file miniconfig.mips is attached.)

It ends:

   CC      init/version.o
   LD      init/built-in.o
arch/mips/built-in.o: In function `local_r4k_flush_cache_page':
c-r4k.c:(.text+0xe278): undefined reference to `kvm_local_flush_tlb_all'
c-r4k.c:(.text+0xe278): relocation truncated to fit: R_MIPS_26 against =20
`kvm_local_flush_tlb_all'
arch/mips/built-in.o: In function `local_flush_tlb_range':
(.text+0xe938): undefined reference to `kvm_local_flush_tlb_all'
arch/mips/built-in.o: In function `local_flush_tlb_range':
(.text+0xe938): relocation truncated to fit: R_MIPS_26 against =20
`kvm_local_flush_tlb_all'
arch/mips/built-in.o: In function `local_flush_tlb_mm':
(.text+0xed38): undefined reference to `kvm_local_flush_tlb_all'
arch/mips/built-in.o: In function `local_flush_tlb_mm':
(.text+0xed38): relocation truncated to fit: R_MIPS_26 against =20
`kvm_local_flush_tlb_all'
kernel/built-in.o: In function `__schedule':
core.c:(.sched.text+0x16a0): undefined reference to =20
`kvm_local_flush_tlb_all'
core.c:(.sched.text+0x16a0): relocation truncated to fit: R_MIPS_26 =20
against `kvm_local_flush_tlb_all'
mm/built-in.o: In function `use_mm':
(.text+0x182c8): undefined reference to `kvm_local_flush_tlb_all'
mm/built-in.o: In function `use_mm':
(.text+0x182c8): relocation truncated to fit: R_MIPS_26 against =20
`kvm_local_flush_tlb_all'
fs/built-in.o:(.text+0x7b50): more undefined references to =20
`kvm_local_flush_tlb_all' follow
fs/built-in.o: In function `flush_old_exec':
(.text+0x7b50): relocation truncated to fit: R_MIPS_26 against =20
`kvm_local_flush_tlb_all'

Revert the above commit and it builds to the end.

Rob=

--=-DO9XbtZD2xmClfVVzSRk
Content-Type: text/plain; charset=us-ascii; name=miniconfig.mips
Content-Disposition: attachment; filename=miniconfig.mips
Content-Transfer-Encoding: quoted-printable

CONFIG_EXPERIMENTAL=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
CONFIG_PCI=3Dy
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_SCRIPT=3Dy
CONFIG_MAGIC_SYSRQ=3Dy

CONFIG_BLK_DEV=3Dy
CONFIG_BLK_DEV_LOOP=3Dy

CONFIG_IDE=3Dy
CONFIG_IDE_GD=3Dy
CONFIG_IDE_GD_ATA=3Dy
CONFIG_BLK_DEV_IDECD=3Dy

CONFIG_SCSI=3Dy
CONFIG_BLK_DEV_SD=3Dy
CONFIG_BLK_DEV_SR=3Dy
CONFIG_SCSI_LOWLEVEL=3Dy

CONFIG_NET=3Dy
CONFIG_PACKET=3Dy
CONFIG_UNIX=3Dy
CONFIG_INET=3Dy

CONFIG_NETDEVICES=3Dy
CONFIG_NET_ETHERNET=3Dy
CONFIG_NET_PCI=3Dy
CONFIG_8139CP=3Dy

CONFIG_HW_RANDOM=3Dy

CONFIG_RTC_CLASS=3Dy
CONFIG_RTC_HCTOSYS=3Dy
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_DEV=3Dy

CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_USE_FOR_EXT23=3Dy
CONFIG_TMPFS=3Dy
CONFIG_MISC_FILESYSTEMS=3Dy
CONFIG_SQUASHFS=3Dy
CONFIG_SQUASHFS_ZLIB=3Dy
CONFIG_DEVTMPFS=3Dy

CONFIG_VIRTUALIZATION=3Dy
CONFIG_VIRTIO_PCI=3Dy
CONFIG_VIRTIO_NET=3Dy
CONFIG_NET_9P=3Dy
CONFIG_NET_9P_VIRTIO=3Dy
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_9P_FS=3Dy
CONFIG_9P_FS_POSIX_ACL=3Dy

# More random (inexplicable) guard symbols added in 3.2.  TODO: write
# miniconfig expander that automatically sets guard symbols when setting a
# dependent symbol.

CONFIG_ETHERNET=3Dy
CONFIG_NET_VENDOR_INTEL=3Dy
CONFIG_NET_VENDOR_REALTEK=3Dy
CONFIG_NET_VENDOR_AMD=3Dy
CONFIG_NET_VENDOR_NATSEMI=3Dy
CONFIG_NET_VENDOR_8390=3Dy

CONFIG_MIPS_MALTA=3Dy
CONFIG_CPU_MIPS32_R2=3Dy
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
#CONFIG_PM=3Dy
CONFIG_PCNET32=3Dy
CONFIG_BLK_DEV_PIIX=3Dy

=

--=-DO9XbtZD2xmClfVVzSRk--
