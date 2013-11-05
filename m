Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3KEHQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:16:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36569 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3KEHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:16:27 -0500
Date: Tue, 5 Nov 2013 18:16:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 5
Message-Id: <20131105181617.228320b251ab24cce48d3b1c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_18_16_17_+1100_xKv+5QCup=7.gcCM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_18_16_17_+1100_xKv+5QCup=7.gcCM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131104:

Removed tree: bcon

The sound-asoc tree lost its build failure.

The device-mapper tree gained a build failure for which I applied a merge
fix patch.

The modules tree still produced a very large number of warnings so I used
the version from next-20131101.

The block tree lost its build failure

The staging tree gained a conflict against the block tree.

The bcon tree gained a build failure due to an interaction with the block
tree.  Since the maintainer had indicated that the tree may no longer be
linux-next material, I removed the tree.

The akpm-current tree gained conflicts against the block tree.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES - this fails its final
link) and i386, sparc, sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 211 trees (counting Linus' and 30 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (be408cd3e1fe Merge git://git.kernel.org/pub/scm/linu=
x/kernel/git/davem/net)
Merging fixes/master (fa8218def1b1 Merge tag 'regmap-v3.11-rc7' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (18e8a7387340 ARC: [plat-arcfpga] defconfig up=
date)
Merging arm-current/fixes (384b38b66947 ARM: 7873/1: vfp: clear vfp_current=
_hw_state for dying cpu)
Merging m68k-current/for-linus (55490050df0f m68k/atari: ARAnyM - Always us=
e physical addresses in NatFeat calls)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (8b5ede69d24d powerpc/irq: Don't switch to irq =
stack from softirq stack)
Merging sparc/master (6d15ee492809 Merge git://git.kernel.org/pub/scm/virt/=
kvm/kvm)
Merging net/master (be408cd3e1fe Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec/master (84502b5ef984 xfrm: Fix null pointer dereference when =
decoding sessions)
Merging sound-current/for-linus (a4461f41b94c ALSA: fix oops in snd_pcm_inf=
o() caused by ASoC DPCM)
Merging pci-current/for-linus (67d470e0e171 Revert "x86/PCI: MMCONFIG: Chec=
k earlier for MMCONFIG region at address zero")
Merging wireless/master (8ce9beac4661 drivers: net: wireless: b43: Fix poss=
ible NULL ptr dereference)
Merging driver-core.current/driver-core-linus (31d141e3a666 Linux 3.12-rc6)
Merging tty.current/tty-linus (6e757ad2c92c tty/serial: at91: fix uart/usar=
t selection for older products)
Merging usb.current/usb-linus (e1466ad5b1ae USB: serial: ftdi_sio: add id f=
or Z3X Box device)
Merging staging.current/staging-linus (31d141e3a666 Linux 3.12-rc6)
Merging char-misc.current/char-misc-linus (31d141e3a666 Linux 3.12-rc6)
Merging input-current/for-linus (5beea882e641 Input: ALPS - add support for=
 model found on Dell XT2)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging audit-current/for-linus (c158a35c8a68 audit: no leading space in au=
dit_log_d_path prefix)
Merging crypto-current/master (26052f9b9bb8 crypto: crct10dif - Add fallbac=
k for broken initrds)
Merging ide/master (64110c16e012 ide: sgiioc4: Staticize ioc4_ide_attach_on=
e())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (f6537f2f0eba scripts/kallsyms: filter symbols not i=
n kernel address space)
Merging mfd-fixes/master (d0e639c9e06d Linux 3.12-rc4)
Merging vfio-fixes/for-linus (d93b3ac0edb8 VFIO: vfio_iommu_type1: fix bug =
caused by break in nested loop)
Merging drm-intel-fixes/for-linux-next-fixes (1fbc0d789d12 drm/i915: Fix th=
e PPT fdi lane bifurcate state handling on ivb)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (72decceef59d ARC: [TB10x] Updates for GPIO and pinctr=
l)
Merging arm/for-next (17e09ac56465 Merge branches 'fixes', 'mmci' and 'sa11=
x0' into for-next)
Merging arm-perf/for-next/perf (15c03dd4859a Linux 3.12-rc3)
Merging arm-soc/for-next (c1b35c610b89 Merge branch 'next/dt' into for-next)
CONFLICT (content): Merge conflict in drivers/clk/clk-nomadik.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Kconfig
Merging bcm2835/for-next (7d132055814e Linux 3.10-rc6)
Merging cortex/for-next (59c1d32321fb ARM: new platform for Energy Micro's =
EFM32 Cortex-M3 SoCs)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (bce60c9ff4b5 Merge branches 'imx/fixes-3.13', 'im=
x/soc-3.14' and 'imx/dt-3.14' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (b91cf40516e0 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (597472bb771b Merge branch 'heads/clock' into next)
Merging samsung/for-next (d2287944920d Merge branch 'v3.13-next/samsung' in=
to for-next)
Merging tegra/for-next (1ebd0d6a0589 Merge branch for-3.13/maintainers into=
 for-next)
Merging arm64/upstream (7ade67b5984d arm64: move enabling of GIC before CPU=
s are set online)
Merging blackfin/for-linus (08b67faa23fd blackfin: Ignore generated uImages)
Merging c6x/for-linux-next (b2c32b32a212 c6x: remove unused COMMON_CLKDEV K=
config parameter)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging h8300-remove/h8300-remove (b400126add8f CREDITS: Add Yoshinori Sato=
 for h8300)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (959f58544b7f Linux 3.12-rc7)
Merging m68k/for-next (77a42796786c m68k: Remove deprecated IRQF_DISABLED)
Merging m68knommu/for-next (959f58544b7f Linux 3.12-rc7)
Merging metag/for-next (b6ef9161e43a irq-imgpdc: add ImgTec PDC irqchip dri=
ver)
Merging microblaze/next (d5d04bb48f0e Bye, bye, WfW flag)
Merging mips/mips-for-linux-next (edf7b938321e MIPS: Random whitespace clea=
n-ups)
Merging openrisc/for-upstream (6af609515d78 openrisc: remove HAVE_VIRT_TO_B=
US)
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (89bcde9f4c7f parisc: make "make install" not de=
pend on vmlinux)
Merging powerpc/next (b0c06d333505 powerpc/bpf: Support MOD operation)
Merging mpc5xxx/next (7e198197ec87 powerpc/mpc512x: remove unnecessary #if)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (106078641f32 s390/mm,tlb: correct tlb flush on page =
table upgrade)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1faf5595 Merge tag 'modules-next-for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (e823acc0a9e3 tile: remove stray blank space)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (8872366df396 xtensa: Fix broken allmodconfig build)
Merging btrfs/next (d7396f07358a Btrfs: optimize key searches in btrfs_sear=
ch_slot)
Merging ceph/master (53d028160f1a ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (81f4821f0bec SMB2/SMB3 Copy offload support (refcopy=
) phase 1)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (959f58544b7f Linux 3.12-rc7)
Merging ext3/for_next (547e662c3894 fs/ext3: use rbtree postorder iteration=
 helper instead of opencoding)
Merging ext4/dev (efbed4dc5857 ext4: add ratelimiting to ext4 messages)
Merging f2fs/dev (4bf08ff6f9f3 f2fs: remove unnecessary TestClearPageError =
when wait pages writeback)
Merging fscache/fscache (f1fe29b4a02d NFS: Use i_writecount to control whet=
her to get an fscache cookie in nfs_open())
Merging fuse/for-next (16f60ab14ce2 fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (2147dbfd059e GFS2: Use generic list_lru for quota)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (fcb63a9bd842 NFS: Fix a missing initialisation when=
 reading the SELinux label)
Merging nfsd/nfsd-next (3378b7f40d79 nfsd4: fix discarded security labels o=
n setattr)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (8ae6a7f5a3a8 squashfs: enhance parallel I/O)
Merging v9fs/for-next (94876b5bb6a8 9P: introduction of a new cache=3Dmmap =
model.)
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (10e6e65dfced xfs: be more forgiving of a v4 secondary=
 sb w/ junk in v5 fields)
CONFLICT (content): Merge conflict in fs/xfs/xfs_dir2_sf.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_dir2_readdir.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_dir2_block.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_da_format.h
Merging vfs/for-next (dc03a60dfcff do_remount(): pull touch_mnt_namespace()=
 up)
CONFLICT (content): Merge conflict in fs/nfsd/nfsfh.c
CONFLICT (content): Merge conflict in fs/9p/vfs_inode_dotl.c
CONFLICT (content): Merge conflict in fs/9p/vfs_inode.c
CONFLICT (content): Merge conflict in fs/9p/vfs_file.c
Merging pci/next (33de1b8bf6e1 Merge branch 'pci/misc' into next)
Merging hid/for-next (bdae615c84bb Merge branch 'for-3.13/roccat' into for-=
next)
Merging i2c/i2c/for-next (8a73cd4cfa15 i2c: exynos5: add High Speed I2C con=
troller driver)
Merging jdelvare-hwmon/master (0f07c1dd7545 hwmon: (lm90) Add support for T=
I TMP451)
Merging hwmon-staging/hwmon-next (26336c8a36c0 hwmon: (w83793) Clean up a s=
ignedness issue)
Merging v4l-dvb/master (5c52a0f259af Merge branch 'build_fixes' into to_nex=
t)
Merging kbuild/for-next (9fbe8e5b9724 Merge branch 'kbuild/kconfig' into kb=
uild/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (1ca953d5f992 Merge branch 'for-3.13' into for-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (de4f40f1f46d Merge branch 'pm-cpufreq-next' into lin=
ux-next)
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/opp.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
Merging idle/next (d7b0a1b0b9b1 intel_idle: Support Intel Atom Processor C2=
000 Product Family)
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (79122105c394 Merge branches 'intel_powerclamp', 'misc=
' and 'x86_pkg_temp' of .git into next)
Merging ieee1394/for-next (db9ae8fec7b1 firewire: ohci: Fix deadlock at bus=
 reset)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (a97f4a66d8ee dlm: Avoid that dlm_release_lockspace() inco=
rrectly returns -EBUSY)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (6b327a028f09 Merge branch 'for-linus' into next)
Merging dmaengine/next (4a43f394a082 dmaengine: dma_sync_wait and dma_find_=
channel undefined)
Merging net-next/master (6fcf018ae449 Merge branch 'master' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jesse/openvswitch)
CONFLICT (content): Merge conflict in arch/parisc/include/uapi/asm/socket.h
CONFLICT (modify/delete): arch/h8300/include/uapi/asm/socket.h deleted in H=
EAD and modified in net-next/master. Version net-next/master of arch/h8300/=
include/uapi/asm/socket.h left in tree.
$ git rm -f arch/h8300/include/uapi/asm/socket.h
Merging ipsec-next/master (1c5ad13f7c2b net: esp{4,6}: get rid of struct es=
p_data)
Merging wireless-next/master (01925efdf7e0 Merge branch 'master' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/brcmfm=
ac/sdio_host.h
Merging bluetooth/master (cca34b785a21 Bluetooth: Remove link type check in=
 hci_disconn_complete_evt())
Merging infiniband/for-next (a78fc816b361 Merge branches 'cma', 'ipoib', 'm=
isc', 'mlx5', 'ocrdma', 'qib' and 'srp' into for-next)
Merging mtd/master (d255c59aab2a Merge tag 'for-linus-20131025' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (5da88a315175 mtd: nand_bbt: kill NAND_BBT_SCANALLPAG=
ES)
Merging crypto/master (8ed49c7675e1 crypto: omap-aes - Fix CTR mode counter=
 length)
Merging drm/drm-next (9d6104e0174b drm/sysfs: Do not drop device reference =
twice)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ddi.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_crt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Applying: drm/i915: Resolve interaction with drm-fixes tree
Merging drm-intel/for-linux-next (3608b98d0b83 drm/i915/dvo: call ->mode_se=
t callback only when the port is running)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
CONFLICT (content): Merge conflict in MAINTAINERS
Merging sound/for-next (24eff328f65c ALSA: hda - Enable SPDIF for Acer Trav=
elMate 6293)
Merging sound-asoc/for-next (e98209dda4b1 Merge remote-tracking branch 'aso=
c/fix/ak4642' into asoc-linus)
Merging modules/modules-next (08746a65c296 init: fix in-place parameter mod=
ification regression)
$ git reset --hard HEAD^
Merging next-20131101 version of modules
Merging virtio/virtio-next (047b9b94951d virtio_net: verify if queue is bro=
ken after virtqueue_get_buf())
Merging input/next (c6d81bd7237b Input: add driver for Neonode zForce based=
 touchscreens)
Merging input-mt/for-next (ad81f0545ef0 Linux 3.11-rc1)
Merging cgroup/for-next (0d60e6cd793e Merge branch 'for-3.13' into for-next)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Merging block/for-next (b8159eb3571e Merge branch 'for-3.13/core' into for-=
next)
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in drivers/md/raid5.c
Merging aio-direct/for-next (bb6f7be48318 tmpfs: add support for read_iter =
and write_iter)
CONFLICT (content): Merge conflict in include/linux/blk_types.h
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in drivers/block/loop.c
Applying: ceph: Fix up for iov_iter changes
Merging device-mapper/for-next (55b4206003ec dm: allow remove to be deferre=
d)
Applying: dm_cache: fix up for bvec iterator abstraction
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (4d22378221bd mmc: core: Add MMC_CAP_RUNTIME_RESUME to=
 resume at runtime_resume)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (139f3f1863de Merge branch 'slab/struct-page' into fo=
r-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (555c28a5b0c1 raid1: Add some macros to make code clear=
ly.)
Merging mfd/master (5e90169c5a02 mfd: lpc_ich: Add Device IDs for Intel Wil=
dcat Point-LP PCH)
CONFLICT (content): Merge conflict in sound/soc/codecs/mc13783.c
Merging mfd-lj/for-mfd-next (6bfd1e63de34 mfd: lpc_sch: Ignore resource con=
flicts when adding mfd cells)
Merging battery/master (588bd5918bac power_supply: Fix documentation for TE=
MP_*ALERT* properties)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Applying: video: xilinxfb: Fix for "Use standard variable name convention"
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (8623ec220b9c omapdss: Add new panel driver for =
Topolly td028ttec1 LCD.)
Merging regulator/for-next (4445d0094e75 Merge remote-tracking branch 'regu=
lator/topic/tps65910' into regulator-next)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
CONFLICT (content): Merge conflict in crypto/Makefile
Merging selinux/master (42d64e1add3a selinux: correct locking in selinux_ne=
tlbl_socket_connect))
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (ec1a1a17a211 watchdog: rt2880_wdt: fix return valu=
e check in rt288x_wdt_probe())
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (e6ca48d995e4 Merge branches 'iommu/fixes', 'tracing', '=
core', 'arm/tegra' and 'x86/vt-d' into next)
Merging vfio/next (15c03dd4859a Linux 3.12-rc3)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (2bb9936beac2 doc: usb: Fix typo in Documentation/=
usb/gadget_configs.txt)
CONFLICT (content): Merge conflict in net/netfilter/xt_set.c
Merging audit/for-next (dcd6c9226715 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
CONFLICT (content): Merge conflict in drivers/pci/host/pci-mvebu.c
CONFLICT (content): Merge conflict in drivers/crypto/caam/jr.c
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/pci_v3.c
Merging dt-rh/for-next (7f60466de9a4 mips: re-order DT init scan)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/prom.h
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Merging spi/for-next (f8ce25620cdc Merge remote-tracking branch 'spi/topic/=
wr' into spi-next)
CONFLICT (content): Merge conflict in drivers/spi/spi.c
Merging tip/auto-latest (f497c33a9489 Merge branch 'x86/uaccess')
CONFLICT (modify/delete): tools/perf/config/feature-tests.mak deleted in ti=
p/auto-latest and modified in HEAD. Version HEAD of tools/perf/config/featu=
re-tests.mak left in tree.
CONFLICT (content): Merge conflict in tools/perf/config/Makefile
CONFLICT (content): Merge conflict in include/linux/wait.h
CONFLICT (content): Merge conflict in include/linux/acpi.h
CONFLICT (modify/delete): arch/h8300/include/asm/Kbuild deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/h8300/include=
/asm/Kbuild left in tree.
$ git rm -f arch/h8300/include/asm/Kbuild
$ git rm -f tools/perf/config/feature-tests.mak
Applying: tip: extra fixes for perf changes
Merging edac/linux_next (de4772c62148 edac: sb_edac.c should not require pr=
escence of IMC_DDRIO device)
Merging edac-amd/for-next (c3e511e4c4d9 amd64_edac: Remove superfluous cond=
ition check.)
Merging ftrace/for-next (29ad23b00474 ftrace: Add set_graph_notrace filter)
Merging rcu/rcu/next (4102adab9189 rcu: Move RCU-related source code to ker=
nel/rcu directory)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (81e87e267967 kvm_host: typo fix)
Merging kvm-arm/kvm-arm-next (79c648806f90 arm/arm64: KVM: PSCI: use MPIDR =
to identify a target CPU)
CONFLICT (content): Merge conflict in arch/arm/kvm/reset.c
Merging kvm-ppc/kvm-ppc-next (a78b55d1c021 kvm: powerpc: book3s: drop is_hv=
_enabled)
CONFLICT (content): Merge conflict in arch/powerpc/kernel/traps.c
CONFLICT (content): Merge conflict in arch/powerpc/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/processor.h
Merging oprofile/for-next (9b415b3a3c4e edac, highbank: Moving error inject=
ion to sysfs for edac)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (af8bdd968a7e Merge branch 'swiotlb-xen' into xe=
ntip/linux-next)
CONFLICT (content): Merge conflict in arch/arm/include/asm/dma-mapping.h
Merging percpu/for-next (90f2492cf9c8 x86: remove this_cpu_xor() implementa=
tion)
Merging workqueues/for-next (016564d41b35 workqueue: fix pool ID allocation=
 leakage and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (5c07eae979df platform/x86: panasonic-laptop=
: reuse module_acpi_driver)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (04bc9ac163a2 Merge remote-tracking branch 'regmap/=
topic/spmi' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (30dae2f98612 leds: lp55xx: handle enable pin in driv=
er)
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500.c
Merging driver-core/driver-core-next (0cae60f91494 sysfs: rename sysfs_asso=
c_lock and explain what it's about)
CONFLICT (content): Merge conflict in include/linux/netdevice.h
CONFLICT (content): Merge conflict in drivers/pci/pci-sysfs.c
CONFLICT (content): Merge conflict in drivers/pci/pci-driver.c
CONFLICT (content): Merge conflict in drivers/mmc/host/mvsdio.c
Merging tty/tty-next (80d8611dd076 serial: omap: fix missing comma)
CONFLICT (content): Merge conflict in drivers/tty/serial/imx.c
CONFLICT (content): Merge conflict in drivers/tty/serial/atmel_serial.c
Merging usb/usb-next (7d49f0bac41e USB: Maintainers change for usb serial d=
rivers)
CONFLICT (content): Merge conflict in drivers/usb/musb/davinci.c
CONFLICT (content): Merge conflict in drivers/Kconfig
CONFLICT (content): Merge conflict in arch/arm/boot/dts/omap3-evm.dts
Merging usb-gadget/next (80d7d8a768cd usb: phy: twl6030-usb: Include linux/=
of.h header)
Merging staging/staging-next (ed5d6ca0038f staging: drm/imx: fix return val=
ue check in ipu_add_subdevice_pdata())
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/l=
loop.c
Merging char-misc/char-misc-next (425792266a40 misc: mic: Fixes for randcon=
fig build errors and warnings.)
Applying: Intel MIC Host Driver: fix for sysfs_get_dirent API change
Merging scsi/for-next (2aee240c68ed Merge branch 'misc' into for-next)
Merging target-updates/for-next (2dd1d53fe004 iscsi-target: Implement demo_=
mode_discovery logic)
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (808e657c5c70 pinctrl: remove minor dead code)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (afb3690c3cbd gpio: bcm-kona: add missing .owner to s=
truct gpio_chip)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging dma-mapping/dma-mapping-next (0df651a0740c Merge branch 'parisc-3.1=
2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging pwm/for-next (702e304f198f Documentation/pwm: Fix trivial typos)
CONFLICT (modify/delete): arch/arm/mach-omap2/board-zoom-peripherals.c dele=
ted in HEAD and modified in pwm/for-next. Version pwm/for-next of arch/arm/=
mach-omap2/board-zoom-peripherals.c left in tree.
$ git rm -f arch/arm/mach-omap2/board-zoom-peripherals.c
Merging dma-buf/for-next (19e8697ba45e dma-buf: Expose buffer size to users=
pace (v2))
Merging userns/for-next (40216baa0101 vfs: Lazily remove mounts on unlinked=
 files and directories. v2)
CONFLICT (content): Merge conflict in fs/fuse/dir.c
Merging ktest/for-next (df5f7c66013c ktest: Reset grub menu cache with diff=
erent machines)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (f61027426a5b clk: of: helper for determining number o=
f parent clocks)
CONFLICT (content): Merge conflict in drivers/clk/Makefile
Merging random/dev (8aaa43c6f8dc random: don't zap entropy count in rand_in=
itialize())
CONFLICT (content): Merge conflict in drivers/char/random.c
CONFLICT (content): Merge conflict in drivers/base/core.c
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (13fd8a5dc3cf Merge branch 'aio-fix' of http://evilpiepi=
rate.org/git/linux-bcache)
Merging akpm-current/current (3cd43dcfaabf scripts/bloat-o-meter: use .star=
tswith rather than fragile slicing)
CONFLICT (content): Merge conflict in mm/bounce.c
CONFLICT (content): Merge conflict in fs/bio-integrity.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt2800pci=
.c
CONFLICT (content): Merge conflict in arch/x86/mm/init.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: net/netfilter/ipset/ip_set_hash_netnet.c: fix build with older gcc
Applying: net/netfilter/ipset/ip_set_hash_netportnet.c: fix build with olde=
r gccs
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Applying: mm: avoid increase sizeof(struct page) due to split page table lo=
ck
Applying: mm: rename USE_SPLIT_PTLOCKS to USE_SPLIT_PTE_PTLOCKS
Applying: mm: convert mm->nr_ptes to atomic_long_t
Applying: mm: introduce api for split page table lock for PMD level
Applying: mm, thp: change pmd_trans_huge_lock() to return taken lock
Applying: mm, thp: move ptl taking inside page_check_address_pmd()
Applying: mm, thp: do not access mm->pmd_huge_pte directly
Applying: mm, hugetlb: convert hugetlbfs to use split pmd lock
Applying: mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fix=
es
Applying: mm: convert the rest to new page table lock api
Applying: mm: implement split page table lock for PMD level
Applying: x86, mm: enable split page table lock for PMD level
Applying: x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes
Applying: x86: add missed pgtable_pmd_page_ctor/dtor calls for preallocated=
 pmds
Applying: cris: fix potential NULL-pointer dereference
Applying: m32r: fix potential NULL-pointer dereference
Applying: xtensa: fix potential NULL-pointer dereference
Applying: mm: allow pgtable_page_ctor() to fail
Applying: microblaze: add missing pgtable_page_ctor/dtor calls
Applying: mn10300: add missing pgtable_page_ctor/dtor calls
Applying: openrisc: add missing pgtable_page_ctor/dtor calls
Applying: alpha: handle pgtable_page_ctor() fail
Applying: arc: handle pgtable_page_ctor() fail
Applying: arm: handle pgtable_page_ctor() fail
Applying: arm64: handle pgtable_page_ctor() fail
Applying: avr32: handle pgtable_page_ctor() fail
Applying: cris: handle pgtable_page_ctor() fail
Applying: frv: handle pgtable_page_ctor() fail
Applying: hexagon: handle pgtable_page_ctor() fail
Applying: ia64: handle pgtable_page_ctor() fail
Applying: m32r: handle pgtable_page_ctor() fail
Applying: m68k: handle pgtable_page_ctor() fail
Applying: m68k-handle-pgtable_page_ctor-fail-fix
Applying: m68k-handle-pgtable_page_ctor-fail-fix-fix
Applying: metag: handle pgtable_page_ctor() fail
Applying: mips: handle pgtable_page_ctor() fail
Applying: parisc: handle pgtable_page_ctor() fail
Applying: powerpc: handle pgtable_page_ctor() fail
Applying: s390: handle pgtable_page_ctor() fail
Applying: score: handle pgtable_page_ctor() fail
Applying: sh: handle pgtable_page_ctor() fail
Applying: sparc: handle pgtable_page_ctor() fail
Applying: tile: handle pgtable_page_ctor() fail
Applying: um: handle pgtable_page_ctor() fail
Applying: unicore32: handle pgtable_page_ctor() fail
Applying: x86: handle pgtable_page_ctor() fail
Applying: xtensa: handle pgtable_page_ctor() fail
Applying: iommu/arm-smmu: handle pgtable_page_ctor() fail
Applying: xtensa: use buddy allocator for PTE table
Applying: mm: dynamically allocate page->ptl if it cannot be embedded to st=
ruct page
Applying: mm: try to detect that page->ptl is in use
Applying: mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-stru=
ct-page-fix-fix
Applying: seq_file: introduce seq_setwidth() and seq_pad()
Applying: seq_file: remove "%n" usage from seq_file users
Applying: vsprintf: ignore %n again
Applying: drivers/rtc/rtc-hid-sensor-time.c: use dev_get_platdata()
Applying: drivers/rtc/rtc-hid-sensor-time.c: enable HID input processing ea=
rly
Applying: sched: replace INIT_COMPLETION with reinit_completion
Applying: tree-wide: use reinit_completion instead of INIT_COMPLETION
Applying: tree-wide-use-reinit_completion-instead-of-init_completion-fix
Applying: sched: remove INIT_COMPLETION
Applying: drivers/w1/masters/w1-gpio.c: use dev_get_platdata()
Applying: scripts/tags.sh: remove obsolete __devinit[const|data]
Applying: revert "softirq: Add support for triggering softirq work on softi=
rqs"
Applying: kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS
Applying: kernel: provide a __smp_call_function_single stub for !CONFIG_SMP
Applying: kernel-provide-a-__smp_call_function_single-stub-for-config_smp-f=
ix
Applying: kernel: fix generic_exec_single indentation
Applying: llists: move llist_reverse_order from raid5 to llist.c
Applying: llists-move-llist_reverse_order-from-raid5-to-llistc-fix
Applying: kernel: use lockless list for smp_call_function_single
Applying: blk-mq: use __smp_call_function_single directly
Applying: sound/core/memalloc.c: use gen_pool_dma_alloc() to allocate iram =
buffer
Merging akpm/master (140eefdb357f sound/core/memalloc.c: use gen_pool_dma_a=
lloc() to allocate iram buffer)

--Signature=_Tue__5_Nov_2013_18_16_17_+1100_xKv+5QCup=7.gcCM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeJtGAAoJEMDTa8Ir7ZwVCgsP/R+ScCIJOiVYxVbIw8fLPlZS
y9DE4rccs0TOFBq2B32lJ25x1qb0a8Ff+ZeYHI5s5obdBWK1g9QaHxNXP9zgsk7I
fNwthm01FhFnjxcbHigV5+KbKtH8ynUIQcboCpH3R7mqSo8ECzEWdBxuBO/amL+H
AGv2fIvdEU+Ipt3w9XCVdaMiJiSqf2DgbCM4VZeoIu7fD0twxirXOcWpQmiBWu3/
jxsril9DuyLv+Q/cn4m6TYV2F4azarpk9DXR4LkYgr6MX53BI6a/t9ALDuB2cMnV
W5J23w8EG80F2SgCG5z3QhK93Vg4jdFztu7BCH96RJzoK66akCagCRpoIQIwcnEp
5TQUrLJJZziz8XAIWD6rC9RVfsdDCGm0O7lopYrIH+FFmFDb+a+kawxkPyjR5Gvf
ps5g29SWLTiCQL3nwMe+RZGEMzDM9URDlxitCaZT/gnS+CrkLTGbvmRRtzf2RnAi
/eqryHdKLnmu78eWhK2hGPA1bmqQUuLB8Gs9VQc3VVfwsb9op+G+Fkcu9QN+Dat5
jyUqO0Lze5Bxn28VjPeUJ2w3PF9aXsGTeZJByoaBnXrxdZfXiZvjAuaX+XWKILTP
X3Tv5PbEPgG+U0o/5ygBmmhCUhWv2XTxvdNzZzzR27rmNM/MYnb4gT7dlOgs+Pqz
5zxv/rw0yxCvC/aF377l
=pR7D
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_18_16_17_+1100_xKv+5QCup=7.gcCM--
