Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaEEImv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:42:51 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63376 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaEEImp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:42:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140505171459.3ce28e8e0c4d6b107a66eb97@canb.auug.org.au>
References: <20140505171459.3ce28e8e0c4d6b107a66eb97@canb.auug.org.au>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 5 May 2014 10:42:23 +0200
X-Google-Sender-Auth: ZtRBPBpqfW0HgC5huwCoiebqcAQ
Message-ID: <CAHO5Pa0D8bxBV98feBt2qk_gb3XdTDcmaa6bD7eQv4UOdjcFrA@mail.gmail.com>
Subject: Re: linux-next: Tree for May 5
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

I don't know what the process is for clearing cruft out of linux-next
is, but there's at least one piece of cruft that probably should go:

commit d30c01a0611d54926ac860721c933edafcc91905
commit 8c013e265a8eca0ada9f1aaa6cd7590698dc7231
commit e86263c9d00efb091a5215b9e4063378828d815c
(and possibly other commits I've missed)
These relate to the user-space facing interfaces
    SFD_PER_THREAD_QUEUE_OFFSET
    SFD_RAW
    SFD_SHARED_QUEUE_OFFS
from work by Andrey Vagin (CCed) seem to be cruft that should be
dropped, since in the end, an alternative mechanism was committed to
the kernel (mainline commit 84c751bd4aebbaae995fe32279d3dba48327bad4)
I leave it to Andrey to confirm this.

Cheers,

Michael



On Mon, May 5, 2014 at 9:14 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> This tree still fails (more than usual) the powerpc allyesconfig build
> and also the celleb_defconfig.
>
> Changes since 20140502:
>
> The powerpc tree still had its build failure.
>
> The net-next tree gained a conflict against the net tree.
>
> The tip tree gained a conflict against the net-next tree.
>
> The tty tree gained a conflict against Linus' tree.
>
> Non-merge commits (relative to Linus' tree): 3899
>  3557 files changed, 127090 insertions(+), 82571 deletions(-)
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
> multi_v7_defconfig for arm. After the final fixups (if any), it is also
> built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
> allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
> defconfig.
>
> Below is a summary of the state of the merge.
>
> I am currently merging 216 trees (counting Linus' and 29 trees of patches
> pending for Linus' tree).
>
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
>
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> $ git checkout master
> $ git reset --hard stable
> Merging origin/master (164c09978ceb Merge tag 'locks-v3.15-3' of git://git.samba.org/jlayton/linux)
> Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator)
> Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
> Merging arc-current/for-curr (a798c10faf62 Linux 3.15-rc2)
> Merging arm-current/fixes (d93003e8e4e1 ARM: 8042/1: iwmmxt: allow to build iWMMXt on Marvell PJ4B)
> Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
> Merging metag-fixes/fixes (a798c10faf62 Linux 3.15-rc2)
> Merging powerpc-merge/merge (e4565362c7ad powerpc/4xx: Fix section mismatch in ppc4xx_pci.c)
> Merging sparc/master (16ce8a30e610 sparc64: Normalize NMI watchdog logging and behavior.)
> Merging net/master (f6a082fed1e6 net: sched: lock imbalance in hhf qdisc)
> Merging ipsec/master (a32452366b72 vti4: Don't count header length twice.)
> CONFLICT (content): Merge conflict in net/ipv4/ip_vti.c
> Merging sound-current/for-linus (7040b6d1febf ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data)
> Merging pci-current/for-linus (f5d3352b2751 PCI: tegra: Use new OF interrupt mapping when possible)
> Merging wireless/master (3234f5b06fc3 rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init())
> Merging driver-core.current/driver-core-linus (d1db0eea8524 Linux 3.15-rc3)
> Merging tty.current/tty-linus (62a0d8d7c2b2 tty: Fix lockless tty buffer race)
> Merging usb.current/usb-linus (6ed07d45d09b USB: Nokia 5300 should be treated as unusual dev)
> Merging usb-gadget-fixes/fixes (886c7c426d46 usb: gadget: at91-udc: fix irq and iomem resource retrieval)
> Merging staging.current/staging-linus (86281966c739 Merge tag 'iio-fixes-for-3.15b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus)
> Merging char-misc.current/char-misc-linus (d1db0eea8524 Linux 3.15-rc3)
> Merging input-current/for-linus (c16134976fb2 Input: tca8418 - fix loading this driver as a module from a device tree)
> Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" stripe)
> Merging crypto-current/master (27c5fb7a8424 crypto: caam - add allocation failure handling in SPRINTFCAT macro)
> Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
> Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
> Merging devicetree-current/devicetree/merge (58b116bce136 drivercore: deferral race condition fix)
> Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting module removal.)
> Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts before cancelling delayed works)
> Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into for-linus)
> Merging drm-intel-fixes/for-linux-next-fixes (b6842feb63a2 drm/i915: Allow user modes to exceed DVI 165MHz limit)
> Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for nommu)
> Merging arc/for-next (134aeaed08c4 ARC: Fixed spelling errors within comments)
> Merging arm/for-next (c34eb07ff897 Merge branches 'fixes' and 'misc' into for-next)
> Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: sleep: restore HYP mode configuration in cpu_resume)
> Merging arm-perf/for-next/perf (d18135c126e8 ARM: perf: add support for the Cortex-A17 PMU)
> Merging arm-soc/for-next (1fc52762e33c Merge tag 'vexpress/fixes-for-3.15' of git://git.linaro.org/people/pawel.moll/linux into fixes)
> Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
> Merging berlin/berlin/for-next (ca8965fd2af1 Merge branch 'berlin/dt' into berlin/for-next)
> Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend support)
> Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' into ep93xx-for-next)
> Merging imx-mxs/for-next (72e0a509056f Merge branch 'imx/dt' into for-next)
> Merging ixp4xx/next (19f949f52599 Linux 3.8)
> Merging keystone/next (47fc77cc704e Merge branch 'for_3.15/fixes' into next)
> Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix)
> Merging mvebu/for-next (9322fc41d2fc Merge branch 'mvebu/dt' into for-next)
> Merging renesas/next (1276447cd032 Merge branch 'dt-for-v3.16' into next)
> Merging samsung/for-next (3c27f314c676 ARM: S3C24XX: convert s3c2412 to common clock framework)
> Merging tegra/for-next (e4e426dc4736 Merge branch for-3.16/defconfig into for-next)
> Merging arm64/for-next/core (ebf81a938dad arm64: Fix DMA range invalidation for cache line unaligned buffers)
> Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
> Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by cache.h)
> Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
> Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
> Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress using big_oops_buf)
> Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
> Merging m68knommu/for-next (6c9665257d5a m68k: fix a compiler warning when building for DragonBall)
> Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
> Merging microblaze/next (a66a626538af microblaze: Use asm-generic/io.h)
> Merging mips/mips-for-linux-next (458d4f8b5328 Merge branch '3.15-fixes' into mips-for-linux-next)
> Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() signal_setup_done())
> Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs parameter from do_execve() in hpux_execve())
> Merging parisc-hd/for-next (ba6728f596a6 Merge tag 'pinctrl-v3.15-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl)
> Merging powerpc/next (5a4e58bc693f powerpc/mm: use macro PGTABLE_EADDR_SIZE instead of digital)
> Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock specs)
> Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pci bridge device node for T4/B4)
> Merging s390/features (164739eff3f9 s390/pci: add some new arch specific pci attributes)
> Merging sparc-next/master (bf6569988a48 Merge branch 'sparc32_generic_io_h')
> Merging tile/master (3af1ea5a2e8f tile: use BOOTMEM_DEFAULT instead of magic number 0 for reserve_bootmem flags)
> Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
> CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
> Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXPERIMENTAL)
> Merging xtensa/for_next (cfe8255f0afc xtensa: xt2000: drop redundant sysmem initialization)
> Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline extents's split)
> Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache readdir)
> Merging cifs/for-next (a87c9ad95667 cifs: fix actimeo=0 corner case when cifs_i->time == jiffies)
> Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
> Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
> Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
> Merging ext4/dev (26f9c9ac0a11 ext4: add fallocate mode blocking for debugging purposes)
> Merging f2fs/dev (26a7fca93f16 f2fs: deactivate inode page if the inode is evicted)
> Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded object to the fscache_object_list rb tree)
> Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
> Merging gfs2/master (5a7c6690c275 GFS2: lops.c: replace 0 by NULL for pointers)
> Merging jfs/jfs-next (24e4a0f3de21 fs/jfs/jfs_inode.c: atomically set inode->i_flags)
> Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free segment found)
> Merging nfs/linux-next (1f2edbe3fe21 NFS: Don't ignore suid/sgid bit changes after a successful write)
> Merging nfsd/nfsd-next (06f9cc12caa8 nfsd4: don't create unnecessary mask acl)
> Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
> Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages on decompress error)
> Merging v9fs/for-next (c9eaa447e77e Linux 3.15-rc1)
> Merging ubifs/linux-next (d56030ac25d3 UBI: block: Remove __initdata from ubiblock_param_ops)
> Merging xfs/for-next (b8b39d39f94c Merge branch 'xfs-free-inode-btree' into for-next)
> Merging file-private-locks/linux-next (caec4ba8ff36 fs/locks.c: replace seq_printf by seq_puts)
> Merging vfs/for-next (673b65614f0c kill generic_file_splice_write())
> CONFLICT (content): Merge conflict in fs/f2fs/file.c
> Merging pci/next (518a6a34f645 Merge branches 'pci/hotplug', 'pci/msi', 'pci/virtualization' and 'pci/misc' into next)
> Merging hid/for-next (9795762e2a7e Merge branch 'for-3.16/upstream' into for-next)
> Merging i2c/i2c/for-next (d1db0eea8524 Linux 3.15-rc3)
> Merging jdelvare-hwmon/master (c9eaa447e77e Linux 3.15-rc1)
> Merging hwmon-staging/hwmon-next (d60ba715cd76 hwmon: (vt1211) remove unnecessary OOM messages)
> Merging v4l-dvb/master (b40dfe97cc3a Merge branch 'v4l_for_linus' into to_next)
> Merging kbuild/for-next (4fc90e122992 Merge branch 'kbuild/kbuild' into kbuild/for-next)
> Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends by default settings)
> Merging libata/for-next (496ab37bfbae Merge branch 'for-3.16' into for-next)
> Merging pm/linux-next (d3b6390a653b Merge branch 'cpufreq-macros' into linux-next)
> CONFLICT (content): Merge conflict in arch/mips/loongson/lemote-2f/clock.c
> Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle' into release)
> Merging apm/for-next (158204397034 apm-emulation: add hibernation APM events to support suspend2disk)
> Merging cpupowerutils/master (f16603386b38 cpupower tools: add install target to the debug tools' makefiles)
> Merging thermal/next (9477165ec525 thermal: rcar-thermal: update thermal zone only when temperature changes)
> Merging ieee1394/for-next (0ca49345b6f4 firewire: ohci: fix probe failure with Agere/LSI controllers)
> Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
> Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotlb buffer is full' (v2))
> Merging slave-dma/next (31e85b9e28a8 Merge branch 'for-linus' into next)
> Merging dmaengine/next (b9bf6d2e84b7 dma: mv_xor: Flush descriptors before activating a channel)
> Merging net-next/master (f4a7b5eec284 Merge branch 'filter-cleanups')
> CONFLICT (content): Merge conflict in net/sched/sch_api.c
> CONFLICT (content): Merge conflict in net/sched/cls_api.c
> CONFLICT (content): Merge conflict in net/netlink/af_netlink.c
> CONFLICT (content): Merge conflict in drivers/net/ethernet/altera/altera_sgdma.c
> Merging ipsec-next/master (2e71029e2c32 xfrm: Remove useless xfrm_audit struct.)
> Merging wireless-next/master (48d11dc37977 rsi: Changing opcode for sta mode according to changes in firmware)
> Merging bluetooth/master (22e70786413e Bluetooth: Remove hci_h4 unused defines)
> Merging infiniband/for-next (7d0a73a40c5c RDMA/cxgb4: Update Kconfig to include Chelsio T5 adapter)
> Merging mtd/master (28c015a9daab mtd: davinci-nand: disable subpage write for keystone-nand)
> Merging l2-mtd/master (35fc51956b53 mtd: nand: fix a typo in a comment line)
> Merging crypto/master (9f84951fc6f3 crypto: atmel-aes - check alignment of cfb64 mode)
> CONFLICT (rename/delete): drivers/crypto/bfin_crc.h deleted in HEAD and renamed in crypto/master. Version crypto/master of drivers/crypto/bfin_crc.h left in tree.
> CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
> Merging drm/drm-next (444c9a08bf78 Merge branch 'drm-init-cleanup' of git://people.freedesktop.org/~danvet/drm into drm-next)
> Merging drm-panel/drm/panel/for-next (170ee9f98750 drm/panel: s6e8aa0: silence array overflow warning)
> Merging drm-intel/for-linux-next (e5c03ca36281 drm/i915/sdvo: Remove ->mode_set callback)
> Merging drm-tegra/drm/tegra/for-next (4b9701e02b3b drm/tegra: hdmi - Add Tegra124 support)
> Merging sound/for-next (02fd1a76bfeb ALSA: fm801: introduce fm801_ac97_is_ready()/fm801_ac97_is_valid() helpers)
> Merging sound-asoc/for-next (6709daab8ebb Merge remote-tracking branches 'asoc/topic/wm8804', 'asoc/topic/wm8955' and 'asoc/topic/wm8985' into asoc-next)
> Merging modules/modules-next (51e158c12aca param: hand arguments after -- straight to init)
> Merging virtio/virtio-next (e75279c4fb85 virtio_ccw: introduce device_lost in virtio_ccw_device)
> Merging input/next (0aa21e226149 Input: gpio-beeper - simplify GPIO handling)
> Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
> Merging block/for-next (a0b22e5237bf Merge branch 'for-3.16/core' into for-next)
> Merging device-mapper/for-next (131cd131a9ff dm cache: fix writethrough mode quiescing in cache_map)
> Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator precedence)
> Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware(), v3)
> Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usage)
> Merging mmc/mmc-next (865042c01637 mmc: Add realtek USB sdmmc host driver)
> Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
> Merging slab/for-next (34bf6ef94a83 mm: slab/slub: use page->list consistently instead of page->lru)
> Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
> Merging md/for-next (96d9fd062c6b raid5: add an option to avoid copy data from bio to stripe cache)
> Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.linaro.org/people/ljones/mfd)
> Merging mfd-lj/for-mfd-next (06ed83a1566a mfd: sec-core: Remove duplicated device type from sec_pmic_dev)
> Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dereference when there is no platform_data)
> Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
> Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup in set_par)
> Merging omap_dss2/for-next (ee3468739ed8 fbdev/fb.h: silence warning with -Wsign-compare)
> Merging regulator/for-next (01bd9b79cbec Merge remote-tracking branches 'regulator/topic/arizona', 'regulator/topic/axp20', 'regulator/topic/of', 'regulator/topic/pbias', 'regulator/topic/s2mps11', 'regulator/topic/s5m8767', 'regulator/topic/tps65090' and 'regulator/topic/tps65217' into regulator-next)
> CONFLICT (content): Merge conflict in drivers/regulator/tps65090-regulator.c
> Merging security/next (fab71a90edda security: Convert use of typedef ctl_table to struct ctl_table)
> Merging selinux/next (626b9740fa73 selinux:  Report permissive mode in avc: denied messages.)
> Merging lblnet/next (d8ec26d7f828 Linux 3.13)
> Merging watchdog/master (4a4d559006e7 watchdog: via_wdt: replace del_timer by del_timer_sync)
> Merging iommu/next (57c343bad18f Merge branches 'iommu/fixes' and 'arm/omap' into next)
> Merging dwmw2-iommu/master (5ae0566a0fff iommu/vt-d: fix bug in matching PCI devices with DRHD/RMRR descriptors)
> Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
> Merging osd/linux-next (f1f6630b53e7 MAINTAINERS: Update email address for bhalevy)
> Merging jc_docs/docs-next (5c050fb96380 docs: update the development process document)
> Merging trivial/for-next (c800bcd5f53f sparse: fix comment)
> Merging audit/master (35d0c383e526 sparc: implement is_32bit_task)
> CONFLICT (content): Merge conflict in kernel/audit.c
> CONFLICT (content): Merge conflict in arch/x86/Kconfig
> CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
> CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
> Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart syscalls)
> Merging devicetree/devicetree/next (d88cf7d7b424 Merge remote-tracking branch 'robh/for-next' into devicetree/next)
> Merging dt-rh/for-next (c3fc952d2fbe of: push struct boot_param_header and defines into powerpc)
> Merging spi/for-next (076c2bdfe8f0 Merge remote-tracking branches 'spi/topic/oom', 'spi/topic/pxa2xx', 'spi/topic/sirf' and 'spi/topic/workqueue' into spi-next)
> Merging tip/auto-latest (c3d94576af33 Merge branch 'x86/uv')
> CONFLICT (content): Merge conflict in net/ipv4/tcp_output.c
> Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct: silence a static checker warning)
> Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DEBUG)
> Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into for-next)
> Merging ftrace/for-next (b1169cc69ba9 tracing: Remove mock up poll wait function)
> Merging rcu/rcu/next (15af2a9fb5c3 rcu: Variable name changed in tree_plugin.h and used in tree.c)
> Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and singlestep exceptions)
> Merging kvm/linux-next (57b5981cd38c Merge tag 'kvm-s390-20140429' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next)
> Merging kvm-arm/next (198c74f43f0f KVM: MMU: flush tlb out of mmu lock when write-protect the sptes)
> Merging kvm-ppc/kvm-ppc-next (0f689a33ad17 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux)
> Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
> Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_work)
> Merging xen-tip/linux-next (0a25e113b480 Merge branch 'devel/for-linus-3.15' into linux-next)
> Merging percpu/for-next (4abee313c9a8 Merge branch 'for-3.16' into for-next)
> Merging workqueues/for-next (534a3fbb3f37 workqueue: simplify wq_update_unbound_numa() by jumping to use_dfl_pwq if the target cpumask equals wq's)
> Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scenarios where memory allocations would fail)
> Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister platform driver/device when module exit)
> Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that may go away)
> Merging regmap/for-next (ef298cbafb9d Merge remote-tracking branches 'regmap/topic/le', 'regmap/topic/mmio', 'regmap/topic/rbtree' and 'regmap/topic/smbus' into regmap-next)
> Merging hsi/for-next (84d93b5e6053 HSI: hsi-char: fix driver for multiport scenarios)
> Merging leds/for-next (c73bcf7cca71 leds: 88pm860x: Fix missing refcount decrement for parent of_node)
> Merging driver-core/driver-core-next (d35cc56ddfc9 Merge 3.15-rc3 into staging-next)
> Merging tty/tty-next (e26f1db9b8d7 tty/serial: fix generic earlycon option parsing)
> CONFLICT (modify/delete): arch/arm64/kernel/early_printk.c deleted in tty/tty-next and modified in HEAD. Version HEAD of arch/arm64/kernel/early_printk.c left in tree.
> $ git rm -f arch/arm64/kernel/early_printk.c
> Merging usb/usb-next (53971a86d2db Merge 3.15-rc3 into usb-next)
> Merging usb-gadget/next (427c3df684ab usb: dwc3: gadget: pretty print Generic CMDs)
> CONFLICT (modify/delete): drivers/usb/phy/phy-mv-u3d-usb.c deleted in HEAD and modified in usb-gadget/next. Version usb-gadget/next of drivers/usb/phy/phy-mv-u3d-usb.c left in tree.
> $ git rm -f drivers/usb/phy/phy-mv-u3d-usb.c
> Merging staging/staging-next (09c3fbba88b4 staging: rtl8188eu: Remove 'u8 *pbuf' from struct recv_buf)
> CONFLICT (content): Merge conflict in drivers/iio/adc/Kconfig
> Merging char-misc/char-misc-next (4f0638100fe3 misc: arm-charlcd: add DT probe support)
> Merging cgroup/for-next (4a7d478008f1 Merge branch 'for-3.15-fixes' into for-next)
> Merging scsi/for-next (1a2184c0d747 [SCSI] More USB deadlock fixes)
> Merging target-updates/for-next (b076808051f2 ib_srpt: Use correct ib_sg_dma primitives)
> Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
> Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corruption on NFS)
> Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS entries)
> Merging pinctrl/for-next (d1b2402c203b Merge branch 'devel' into for-next)
> Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
> Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize local symbols)
> Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VIRTIO)
> Merging gpio/for-next (4e6a8ae77deb Merge branch 'devel' into for-next)
> Merging dma-mapping/dma-mapping-next (59f0f119e85c arm: dma-mapping: Fix mapping size value)
> Merging pwm/for-next (093e00bb3f82 pwm: lpss: Add support for PCI devices)
> Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
> Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of BSD accounting files)
> CONFLICT (content): Merge conflict in fs/namespace.c
> CONFLICT (content): Merge conflict in fs/namei.c
> CONFLICT (content): Merge conflict in fs/dcache.c
> Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_bisect)
> Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
> Merging clk/clk-next (4fdd44dfb5bd Merge branch 'clk-fixes' into clk-next)
> Merging random/dev (7b878d4b48c4 random: Add arch_has_random[_seed]())
> Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression speedup on ARM by using unaligned access)
> Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP support.)
> Merging aio/master (fa88b6f8803c aio: cleanup: flatten kill_ioctx())
> Merging llvmlinux/for-next (4f6d454aae03 unwind_support)
> Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Parse device tree to setup idle states)
> Merging rd-docs/master (c9e7f4124daa The sum at the beginning of line "intr" includes also unnumbered interrupts. It implies that the sum at the beginning isn't the sum of the remainder of the line, not even an estimation.)
> Merging akpm-current/current (9d325a9c00bb sysrq,rcu: suppress RCU stall warnings while sysrq runs)
> CONFLICT (content): Merge conflict in arch/x86/kernel/apic/hw_nmi.c
> $ git checkout -b akpm remotes/origin/akpm/master
> Applying: drivers/gpio/gpio-zevio.c: fix build
> Applying: mm/page_io.c: work around gcc bug
> Applying: arm: convert use of typedef ctl_table to struct ctl_table
> Applying: ia64: convert use of typedef ctl_table to struct ctl_table
> Applying: tile: convert use of typedef ctl_table to struct ctl_table
> Applying: cdrom: convert use of typedef ctl_table to struct ctl_table
> Applying: random: convert use of typedef ctl_table to struct ctl_table
> Applying: parport: convert use of typedef ctl_table to struct ctl_table
> Applying: scsi: convert use of typedef ctl_table to struct ctl_table
> Applying: coda: convert use of typedef ctl_table to struct ctl_table
> Applying: fscache: convert use of typedef ctl_table to struct ctl_table
> Applying: lockd: convert use of typedef ctl_table to struct ctl_table
> Applying: nfs: convert use of typedef ctl_table to struct ctl_table
> Applying: inotify: convert use of typedef ctl_table to struct ctl_table
> Applying: ntfs: convert use of typedef ctl_table to struct ctl_table
> Applying: fs: convert use of typedef ctl_table to struct ctl_table
> Applying: key: convert use of typedef ctl_table to struct ctl_table
> Applying: ipc: convert use of typedef ctl_table to struct ctl_table
> Applying: sysctl: convert use of typedef ctl_table to struct ctl_table
> Applying: mm: convert use of typedef ctl_table to struct ctl_table
> Applying: mfd/rtc: sec/s5m: rename SEC* symbols to S5M
> Applying: rtc: s5m: remove undocumented time init on first boot
> Applying: rtc: s5m: use shorter time of register update
> Applying: rtc: s5m: support different register layout
> Applying: rtc: s5m: add support for S2MPS14 RTC
> Applying: rtc: s5m: consolidate two device type switch statements
> Applying: blackfin/ptrace: call find_vma with the mmap_sem held
> Applying: drivers/w1/w1_int.c: call put_device if device_register fails
> Applying: arm: move arm_dma_limit to setup_dma_zone
> Applying: ufs: sb mutex merge + mutex_destroy
> Applying: mm: add strictlimit knob
> Merging akpm/master (9b28e17bd84c mm: add strictlimit knob)



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
