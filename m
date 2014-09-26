Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaIZLK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:10:26 -0400
Received: from ozlabs.org ([103.22.144.67]:56580 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaIZLKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:10:22 -0400
Date: Fri, 26 Sep 2014 21:10:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 26
Message-ID: <20140926211014.6491e1ee@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vlVuSFyIdXKECOYAs5UOdMI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vlVuSFyIdXKECOYAs5UOdMI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

There will be no linux-next release on Monday.

This has not been a good day :-(

Changes since 20140925:

The arm-soc tree gained a conflict against the arm tree and a build
failure for which I reverted 6 commits.

The asm-generic tree gained a build failure for which I applied a patch.

The pci tree gained a conflict against the asm-generic tree.

The tip tree gained a conflict against the arm-soc tree.

The watchdog tree gained a build failure for which I reverted a commit.

The tiny tree gained a conflict against the tip tree.

The tty tree lost its build failure.

The cgroup tree gained a conflict against the kbuild tree.

The scsi tree gained a build failure for which I reverted a commit.

The llvmlinux tree gained a conflict against the arm tree.

The akpm-current tree gained a build failure for which I applied a
fix patch.

The akpm tree gained a conflict against the battery tree and lost several
patches that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 8137
 7042 files changed, 286419 insertions(+), 153468 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" and checkout or reset to the new
master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 227 trees (counting Linus' and 32 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (f4cb707e7ad9 Merge tag 'pm+acpi-3.17-rc7' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (5ca918e5e3f9 ARM: 8165/1: alignment: don't break=
 misaligned NEON load/store)
Merging m68k-current/for-linus (4ed7800987b1 m68k: Wire up memfd_create)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/for-linus (7d59deb50aaf powerpc: Wire up sys_secc=
omp(), sys_getrandom() and sys_memfd_create())
Merging sparc/master (c21c4ab0d692 sparc64: Move request_irq() from ldc_bin=
d() to ldc_alloc())
Merging net/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec/master (b8c203b2d2fc xfrm: Generate queueing routes only from=
 route lookup functions)
Merging sound-current/for-linus (e76bf634870e ALSA: snd-usb-caiaq: Fix LED =
commands for Kore controller)
Merging pci-current/for-linus (7cbeb9f90db8 PCI: pciehp: Fix pcie_wait_cmd(=
) timeout)
Merging wireless/master (f8adaf0ae978 brcmfmac: Fix off by one bug in brcmf=
_count_20mhz_channels())
Merging driver-core.current/driver-core-linus (9e82bf014195 Linux 3.17-rc5)
Merging tty.current/tty-linus (9e82bf014195 Linux 3.17-rc5)
Merging usb.current/usb-linus (0f33be009b89 Linux 3.17-rc6)
Merging usb-gadget-fixes/fixes (0b93a4c838fa usb: dwc3: fix TRB completion =
when multiple TRBs are started)
Merging usb-serial-fixes/usb-linus (dee80ad12d2b USB: cp210x: add support f=
or Seluxit USB dongle)
Merging staging.current/staging-linus (0f33be009b89 Linux 3.17-rc6)
Merging char-misc.current/char-misc-linus (9e82bf014195 Linux 3.17-rc5)
Merging input-current/for-linus (3049683eafdb Input: i8042 - fix Asus X450L=
CP touchpad detection)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (7da4b29d496b crypto: aesni - disable "by8" A=
VX CTR optimization)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (9aacd602f024 of/fdt: fix memor=
y range check)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (ce6a144a0d01 selftests/memfd: Run test on al=
l architectures)
Merging drm-intel-fixes/for-linux-next-fixes (c84db7701087 drm/i915/hdmi: f=
ix hdmi audio state readout)
Merging asm-generic/master (da0feaefa546 microblaze: io: remove dummy relax=
ed accessor macros)
Merging arc/for-next (d702f35b6615 ARC: Update order of registers in KGDB t=
o match GDB 7.5)
Merging arm/for-next (74d12bf5d8c5 Merge branches 'fiq' (early part), 'fixe=
s' and 'misc' into for-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (dae70fdf798a arm-soc: document merges)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
[master 0743a53e8c62] Revert "ARM: dts: hix5hd2: add wdg node"
[master f12ea7fd44c2] Revert "ARM: dts: hix5hd2: add gpio node"
[master 46348a99125e] Revert "ARM: dts: hix5hd2: add sata node"
[master 1633940e9ea3] Revert "ARM: dts: hix5hd2: add usb node"
[master 324e487c4105] Revert "ARM: dts: hix5hd2: add mmc node"
[master 021311e2a745] Revert "ARM: dts: hix5hd2: add gmac node"
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8d4f3361e05c Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (2b2244a3e7c3 ARM: dts: imx6: make gpt per clock c=
an be from OSC)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (65a3bb88bb33 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (cc38f02b87ef Merge branches 'heads/dt-for-v3.18' and =
'heads/soc-for-v3.18' into next)
Merging samsung/for-next (99ec9c837f35 Merge branch 'v3.18-next/defconfig-s=
amsung' into for-next)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging sunxi/sunxi/for-next (429823087fec Merge branches 'sunxi/dt-for-3.1=
8' and 'sunxi/drivers-for-3.18' into sunxi/for-next)
Merging tegra/for-next (5599b9197647 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (1059c6bf8534 arm64: debug: don't re-enable deb=
ug exceptions on return from el1_dbg)
CONFLICT (content): Merge conflict in Documentation/networking/filter.txt
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0f33be009b89 Linux 3.17-rc6)
Merging m68k/for-next (9aa59cacdf22 m68k/atari - stram: Add missing #includ=
e <linux/ioport.h>)
Merging m68knommu/for-next (016371190da6 m68knommu: add missing ioport_map(=
) and ioport_unmap())
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (554336c714f4 microblaze: Use empty asm-generic/lin=
kage.h)
Merging mips/mips-for-linux-next (4b050ba7a66c MIPS: pgtable.h: Implement t=
he pgprot_writecombine function for MIPS)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (0f33be009b89 Linux 3.17-rc6)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging powerpc-mpe/next (be70ac29dadc powerpc: Enable DCACHE_WORD_ACCESS o=
n ppc64le)
Merging fsl/next (cb0446c1b625 Revert "powerpc/fsl_msi: spread msi ints acr=
oss different MSIRs")
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (9745ce668710 s390/topology: call set_sched_topology =
early)
Merging sparc-next/master (619df5d2870b Merge tag 'microblaze-3.17-rc5' of =
git://git.monstr.eu/linux-2.6-microblaze)
Merging tile/master (9c29b2aea7fa tile gxio: use better string copy primiti=
ve)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (f2589bff1ce8 xtensa/uapi: Add definition of TIOC[S=
G]RS485)
Merging btrfs/next (1d52c78afbbf Btrfs: try not to ENOSPC on log replay)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (1a76430d0198 [SMB3] Allow conversion of characters i=
n Mac remap range (part 2))
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (52362810bec8 ocfs2: Don't use MAXQUOTAS value)
Merging ext4/dev (f6e63f908099 ext4: fold ext4_nojournal_sops into ext4_sop=
s)
Merging f2fs/dev (9a41533c77ae f2fs: refactor flush_nat_entries to remove c=
ostly reorganizing ops)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (00a158be8383 GFS2: fix bad inode i_goal values during =
block allocation)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (d829b8a990a1 Merge branch 'bugfixes' into linux-nex=
t)
Merging nfsd/nfsd-next (b9b21b60626b nfsd: introduce nfsd4_callback_ops)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (b91671bb23a7 UBI: Fix livelock in produce_free_pe=
b())
Merging xfs/for-next (33044dc408e6 Merge branch 'xfs-misc-fixes-for-3.18-2'=
 into for-next)
Merging file-locks/linux-next (c68f11db3d2f locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
CONFLICT (content): Merge conflict in fs/locks.c
Merging vfs/for-next (bb4623448d40 vfs: move getname() from callers to do_m=
ount())
Merging pci/next (2256b421da38 Merge branch 'pci/host-generic' into next)
CONFLICT (content): Merge conflict in include/asm-generic/io.h
Merging hid/for-next (38807cbe3585 Merge branch 'for-3.18/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (5422762b6b25 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (7ad8966f4f0a Merge tag 'mfd-hwmon-leds-wa=
tchdog-v3.18' into hwmon-next)
Merging v4l-dvb/master (84c2c24cbe49 Merge branch 'topic/devel-3.17-rc6' in=
to to_next)
Merging kbuild/for-next (03d5356ee6d0 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (ec489eb8e027 Merge branch 'for-3.18' into for-next)
Merging pm/linux-next (f25d178daf92 Merge branch 'pm-cpuidle' into linux-ne=
xt)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-ape6evm-=
reference.c
CONFLICT (content): Merge conflict in arch/arm/configs/mvebu_v7_defconfig
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (dd634666793e Merge branches 'eduardo-soc' and 'bang-b=
ang-governor' of .git into next)
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (7102fc6e82d3 Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (4daaab4f0c2b Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3xxx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188-radxarock.dts
Merging ipsec-next/master (689f1c9de2ab ipsec: Remove obsolete MAX_AH_AUTH_=
LEN)
Merging wireless-next/master (7a0a260a0f6f ath9k: enable ext channel pulse =
detection)
Merging bluetooth/master (565766b087a6 Bluetooth: Rename sco_param_wideband=
 table to esco_param_msbc)
Merging infiniband/for-next (3bdad2d13fa6 Merge branches 'core', 'ipoib', '=
iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (6d178ef2fd5e mtd: nand: Move ELM driver and rename a=
s omap_elm)
Merging crypto/master (26c3af6c1580 crypto: qat - Removed unneeded partial =
state)
Merging drm/drm-next (d743ecf36063 drm/doc: Fixup drm_irq kerneldoc include=
s.)
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (d37cf5f7e1b3 drm/i915/bdw: Cleanup pre pr=
od workarounds)
Merging drm-tegra/drm/tegra/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging sound/for-next (7a7686bd0d15 ALSA: ctxfi: sparse warning)
Merging sound-asoc/for-next (6757e1a035d3 Merge remote-tracking branches 'a=
soc/topic/wm8978' and 'asoc/topic/wm8994' into asoc-next)
Merging modules/modules-next (184c3fc3f52f moduleparam: Resolve missing-fie=
ld-initializer warning)
Merging virtio/virtio-next (7ec62d421bdf Merge branch 'for_linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging input/next (042e1c79166b Input: soc_button_array - convert to platf=
orm bus)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (661930bb37cd Merge branch 'for-3.18/core' into for-=
next)
Merging device-mapper/for-next (396d5fa8e65a dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (517bf80fe744 mmc: rtsx_pci: Set power related cap2 mac=
ros)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (b8cb6b4c121e md/raid1: fix_read_error should act on al=
l non-faulty devices.)
Merging mfd/for-mfd-next (420795acbd11 mfd: twl4030-power: Use 'ti,system-p=
ower-controller' as alternative way to support system power off)
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (6a91e854442c power: max14577: Fix circular config S=
YSFS dependency)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (30296f61159e video: fbdev: use %*ph specifier t=
o dump small buffers)
Merging regulator/for-next (af14afaa4b64 Merge remote-tracking branch 'regu=
lator/topic/voltage-ev' into regulator-next)
Merging security/next (35e1efd25a9e Merge tag 'keys-next-20140922' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into next)
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging integrity/next (1b68bdf9cded ima: detect violations for mmaped file=
s)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (64c81d80f86b Merge commit 'mfd-hwmon-leds-watchdog=
-v3.18')
[master e622413d4bee] Revert "ARM: meson: add watchdog driver"
Merging iommu/next (4badea29d17e Merge branches 'arm/exynos', 'arm/omap', '=
arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (9b936c960f22 drivers/vfio: Enable VFIO if EEH is not sup=
ported)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (00703e0b7990 Documentation: remove obsolete pcmci=
a-cs from Changes)
CONFLICT (content): Merge conflict in block/blk-core.c
Merging audit/master (9eab339b197a audit: get comm using lock to avoid race=
 in string printing)
CONFLICT (content): Merge conflict in arch/arm64/kernel/ptrace.c
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a9ecdc0fdc54 of/irq: Fix lookup to use =
'interrupts-extended' property first)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging mailbox/mailbox-for-next (29de0a1d6aa4 dt: mailbox: add generic bin=
dings)
Merging spi/for-next (e7c255187ea6 Merge remote-tracking branches 'spi/topi=
c/sh-msiof', 'spi/topic/sirf' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (141306a4fe87 Merge branch 'x86/vdso')
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdm.c deleted in HEA=
D and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/blockl=
ayout/blocklayoutdm.c left in tree.
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdev.c deleted in HE=
AD and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/block=
layout/blocklayoutdev.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_64.S
CONFLICT (modify/delete): arch/arm/mach-omap2/irq.c deleted in HEAD and mod=
ified in tip/auto-latest. Version tip/auto-latest of arch/arm/mach-omap2/ir=
q.c left in tree.
$ git rm -f fs/nfs/blocklayout/blocklayoutdev.c fs/nfs/blocklayout/blocklay=
outdm.c arch/arm/mach-omap2/irq.c
Applying: pnfs: merge fixup for sched cleanup of set_current_state(TASK_RUN=
NING)
Applying: arm: omap: irq: fixup for new handle_domain_irq method
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (7981a28f1ab5 amd64_edac: Modify usage of amd64_r=
ead_dct_pci_cfg())
Merging irqchip/irqchip/for-next (1633cd9aed67 Merge branch 'irqchip/gic' i=
nto irqchip/for-next)
Merging tiny/tiny/next (d45461ff03ad Merge branches 'tiny/bloat-o-meter-no-=
SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x=
86-boot-compressed-use-yn' into tiny/next)
CONFLICT (content): Merge conflict in arch/x86/boot/compressed/Makefile
Merging ftrace/for-next (7cbfb5eed983 Merge branch 'trace/ftrace/testing' i=
nto trace/for-next)
Merging rcu/rcu/next (dd56af42bd82 rcu: Eliminate deadlock between CPU hotp=
lug and expedited grace periods)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (00c027db0cc4 Merge tag 'signed-kvm-ppc-next' of git=
://github.com/agraf/linux-2.6 into kvm-next)
Merging kvm-arm/next (a98f26f18380 arm/arm64: KVM: vgic: make number of irq=
s a configurable attribute)
CONFLICT (content): Merge conflict in virt/kvm/eventfd.c
Merging kvm-ppc/kvm-ppc-next (8d0eff638564 KVM: PPC: Pass enum to kvmppc_ge=
t_last_inst)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (59119fad2954 xen-scsifront: don't deadlock if t=
he ring becomes full)
Merging percpu/for-next (92f4f5286667 Merge branch 'for-3.18' into for-next)
CONFLICT (content): Merge conflict in fs/ext4/super.c
Applying: percpu_counter: fix for ext4 updates
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (557b45497145 eeepc-laptop: clean up control f=
low in *_rfkill_notifier)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (402dd4061206 Merge remote-tracking branch 'regmap/=
topic/cache' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (0a2b4a843d32 Merge tag 'mfd-hwmon-leds-watchdog-v3.1=
8' into devel)
Merging ipmi/for-next (662d15871626 ipmi: Clear drvdata when interface is r=
emoved)
Merging driver-core/driver-core-next (bef59c5024be devres: Improve devm_kas=
printf()/kvasprintf() support)
Merging tty/tty-next (cc952e7017fa tty: Fix width of unsigned long bitfield=
 padding)
Merging usb/usb-next (0cfbd328d60f usb: Add LED triggers for USB activity)
CONFLICT (content): Merge conflict in drivers/usb/gadget/function/f_fs.c
Merging usb-gadget/next (72a65a0d19c1 Revert "usb: gadget: composite: deque=
ue cdev->req before free its buffer")
Merging usb-serial/usb-next (f8c0e057b489 USB: serial: remove zte_ev driver)
Merging staging/staging-next (368c75b98bdf staging: rtl8188eu: odm.h: Remov=
e unused struct dyn_primary_cca)
Merging char-misc/char-misc-next (046c7911b224 Drivers: hv: vmbus: Enable i=
nterrupt driven flow control)
Merging cgroup/for-next (8898e152c02a Merge branch 'for-3.17-fixes' into fo=
r-next)
CONFLICT (content): Merge conflict in scripts/tags.sh
Merging scsi/for-next (d58fed1e1b70 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
[master 0a87e9437bf1] Revert "ipr: don't log error messages when applicatio=
ns issues illegal requests"
Merging target-updates/for-next (c435285df112 target: fix unused shift in c=
ore_scsi3_pri_report_capabilities)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (d3d6f7a8ad05 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (8c3270e13eb1 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (e2e08970100d pwm: atmel: Fix calculation of prescale =
value)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (fee9d3e61d04 ktest: add ability to skip during BISE=
CT_MANUAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (a52ae5a755d9 Merge branch 'clk-fixes' into clk-next)
Merging random/dev (13aa93c70e71 random: add and use memzero_explicit() for=
 clearing data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (668044a5d632 aio: Make it possible to remap aio ring)
Merging llvmlinux/for-next (7d4cd0ef629a arm64: LLVMLinux: Fix inline arm64=
 assembly for use with clang)
CONFLICT (content): Merge conflict in arch/arm/kernel/return_address.c
CONFLICT (content): Merge conflict in Makefile
Merging rd-docs/master (9e8e26907954 Documentation: remove networking/.giti=
gnore)
CONFLICT (content): Merge conflict in Documentation/networking/timestamping=
/Makefile
Merging kselftest/next (69e273c0b0a3 Linux 3.17-rc3)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
Applying: sparc: io: fix for asm-generic: io: implement relaxed accessor ma=
cros as conditional wrappers
Merging akpm-current/current (77f1caf6149f scripts/sortextable: suppress wa=
rning: `relocs_size' may be used uninitialized)
CONFLICT (content): Merge conflict in drivers/clk/Kconfig
Applying: signal.h: using BUILD_BUG requires including bug.h
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: arch/x86/kernel/cpu/common.c: fix unused symbol warning
Applying: lib/string.c: remove duplicated function
Applying: lib: string: Make all calls to strnicmp into calls to strncasecmp
Applying: ARM: replace strnicmp with strncasecmp
Applying: block: replace strnicmp with strncasecmp
Applying: netfilter: replace strnicmp with strncasecmp
Applying: video: fbdev: replace strnicmp with strncasecmp
Applying: cifs: replace strnicmp with strncasecmp
Applying: ocfs2: replace strnicmp with strncasecmp
Applying: isofs: replace strnicmp with strncasecmp
Applying: batman-adv: replace strnicmp with strncasecmp
Applying: scsi: replace strnicmp with strncasecmp
Applying: ib_srpt: replace strnicmp with strncasecmp
Applying: input: edt-ft5x06: replace strnicmp with strncasecmp
Applying: altera-stapl: replace strnicmp with strncasecmp
Applying: thinkpad_acpi: replace strnicmp with strncasecmp
Applying: PNP: replace strnicmp with strncasecmp
Applying: s390/cio: replace strnicmp with strncasecmp
Applying: staging: r8188eu: replace strnicmp with strncasecmp
Applying: thermal: replace strnicmp with strncasecmp
Applying: kdb: replace strnicmp with strncasecmp
Applying: fs: check bh blocknr earlier when searching lru
Applying: arch/x86/mm/numa.c: fix boot failure when all nodes are hotplugga=
ble
Applying: mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggabl=
e-checkpatch-fixes
Applying: include/linux: remove strict_strto* definitions
Applying: lib / string_helpers: move documentation to c-file
Applying: lib / string_helpers: refactoring the test suite
Applying: lib / string_helpers: introduce string_escape_mem()
Applying: lib-string_helpers-introduce-string_escape_mem-fix
Applying: lib/vsprintf: add %*pE[achnops] format specifier
Applying: lib-vsprintf-add-%pe-format-specifier-fix
Applying: wireless: libertas: print esaped string via %*pE
Applying: wireless: ipw2x00: print SSID via %*pE
Applying: wireless: hostap: proc: print properly escaped SSID
Applying: wireless-hostap-proc-print-properly-escaped-ssid-fix
Applying: wireless-hostap-proc-print-properly-escaped-ssid-fix-2
Applying: lib80211: remove unused print_ssid()
Applying: staging: wlan-ng: use %*pEhp to print SN
Applying: staging: rtl8192e: use %*pEn to escape buffer
Applying: staging: rtl8192u: use %*pEn to escape buffer
Applying: kernel/watchdog.c: control hard lockup detection default
Applying: watchdog-control-hard-lockup-detection-default-fix
Applying: watchdog, nmi: Fix compile issues on sparc
Applying: kvm: ensure hard lockup detection is disabled by default
Applying: kernel: add support for kernel restart handler call chain
Applying: power/restart: call machine_restart instead of arm_pm_restart
Applying: arm64: support restart through restart handler call chain
Applying: arm: support restart through restart handler call chain
Applying: watchdog: moxart: register restart handler with kernel restart ha=
ndler
Applying: watchdog: alim7101: register restart handler with kernel restart =
handler
Applying: watchdog: sunxi: register restart handler with kernel restart han=
dler
Applying: arm/arm64: unexport restart handlers
Applying: watchdog: s3c2410: add restart handler
Applying: clk: samsung: register restart handlers for s3c2412 and s3c2443
Applying: clk: rockchip: add restart handler
Applying: frv: remove unused declarations of __start___ex_table and __stop_=
__ex_table
Applying: ia64: remove duplicate declarations of __per_cpu_start[] and __pe=
r_cpu_end[]
Applying: kernel/param: consolidate __{start,stop}___param[] in <linux/modu=
leparam.h>
Applying: mm: softdirty: enable write notifications on VMAs after VM_SOFTDI=
RTY cleared
CONFLICT (content): Merge conflict in include/asm-generic/pgtable.h
Applying: mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirt=
y-cleared-fix
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: skip cluster allocation on fallocated region
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (4f37af16a063 mm: add strictlimit knob)

--Sig_/vlVuSFyIdXKECOYAs5UOdMI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJUmaAAoJEMDTa8Ir7ZwV1xgP/0mBi6Sx9mrGgFhfJsvzip/z
SqVNbQztQ4M/aOkZARMfnYk+yP3OhXRO1oqz3+MOPOB2m6b1zaZMIStmOdMZQLGs
U+1n1dJBDN7IscrccwCpnabSoLhggkt6wj4KGOIig4mI/tXo9tiaoxnNxu5z2lbz
pqL1fNb/uQ3P0hO2YFmr9RhKVyIiVRbyQh86qeT6lgllgJsmaE+r6/8deiwVwyo+
iYVpqoJkV81KA8BHibX1RAPiS3Sit2D0oW5mg4qun+kY8TxRBlxrE+aGJb13hY3B
lDPqrB5EZEdxZClMZUSZdy3bIiVRU2JRqEoM2FEXhPE1DHHDJNJRgp/nM1w3LScI
j1Dz/zfZwYsWESZkKgB/32A4b6cENXQXKsB85rdmAkeI2kTJRZWhW7x+t6gJ5Yhg
3cY7r3j+nfyJvskjW8Jc845juulmyy3oh0gko0c5BoO3kTIw0yD3qXXgrtNjfFVk
BG7MXBmV4KPl5DdHKc0lI8aMVqinVPfyDuIRrE7CcVCcOnr0zYghK25znlPC1QPR
bJ5YPUdax6LsFxzyNcFPgXh8v61skAR9V/CigTtalHCeRb2atbSLqvhNsTSMnLoY
R0Z+S9IaoMKqfdDZQFJClm8p+5A4AQ1YSt8qYexC723zjTR9jfGkxKwxu/MUhLJ4
B7HMmpY6HU9VBvf/QscZ
=uHeF
-----END PGP SIGNATURE-----

--Sig_/vlVuSFyIdXKECOYAs5UOdMI--
