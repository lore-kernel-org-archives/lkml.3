Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaFCJ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:28:29 -0400
Received: from ozlabs.org ([103.22.144.67]:58874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaFCJ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:28:22 -0400
Date: Tue, 3 Jun 2014 19:28:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jun 3
Message-ID: <20140603192814.64528e15@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/G8ihyu1g1IV38N71PbsanCl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G8ihyu1g1IV38N71PbsanCl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Our build server is down today, so this linux-next will not get the
usual builds done, sorry.

Changes since 20140602:

New tree: linus-next

The mips tree gained a conflict against Linus' tree.

The net-next tree lost its build failure and gained conflicts against
the net tree.

The mmc tree still had its build failure so I used the version from
next02140522.

The vhost tree gained a build failure for which I reverted a commit.

Non-merge commits (relative to Linus' tree): 10445
 8486 files changed, 401583 insertions(+), 229658 deletions(-)

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

I am currently merging 220 trees (counting Linus' and 29 trees of patches
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
Merging origin/master (fad01e866afd Linux 3.15-rc8)
Merging linus-next/next (80081ec309c8 Merge branch 'for-3.16/drivers' of gi=
t://git.kernel.dk/linux-block into next)
Merging fixes/master (4b660a7f5c80 Linux 3.15-rc6)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (a798c10faf62 Linux 3.15-rc2)
Merging arm-current/fixes (3f8517e7937d ARM: 8063/1: bL_switcher: fix indiv=
idual online status reporting of removed CPUs)
Merging m68k-current/for-linus (e8d6dc5ad26e m68k/hp300: Convert printk to =
pr_foo())
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (8212f58a9b15 powerpc: Wire renameat2() syscall)
Merging sparc/master (8ecc1bad4c9b sparc64: fix format string mismatch in a=
rch/sparc/kernel/sysfs.c)
Merging net/master (2d7a85f4b06e netlink: Only check file credentials for i=
mplicit destinations)
Merging ipsec/master (6d004d6cc739 vti: Use the tunnel mark for lookup in t=
he error handlers.)
Merging sound-current/for-linus (192a98e280e5 ALSA: hda/realtek - Fix COEF =
widget NID for ALC260 replacer fixup)
Merging pci-current/for-linus (d0b4cc4e3270 PCI: Wrong register used to che=
ck pending traffic)
Merging wireless/master (2c316e699fa4 Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (4b660a7f5c80 Linux 3.15-rc6)
Merging tty.current/tty-linus (d6d211db37e7 Linux 3.15-rc5)
Merging usb.current/usb-linus (5dc2808c4729 xhci: delete endpoints from ban=
dwidth list before freeing whole device)
Merging usb-gadget-fixes/fixes (886c7c426d46 usb: gadget: at91-udc: fix irq=
 and iomem resource retrieval)
Merging staging.current/staging-linus (9326c5ca0982 staging: r8192e_pci: fi=
x htons error)
Merging char-misc.current/char-misc-linus (d1db0eea8524 Linux 3.15-rc3)
Merging input-current/for-linus (0f68f39c393b Input: synaptics - change min=
/max quirk table to pnp-id matching)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (3901c1124ec5 crypto: s390 - fix aes,des ctr =
mode concurrency finding.)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (4b660a7f5c80 Linux 3.15-rc6)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (c1240bd2842f drm/i915: Preven=
t negative relocation deltas from wrapping)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (35b960a30019 ARC: remove duplicate header exports)
Merging arm/for-next (960c2cdd4fa2 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (c9eaa447e77e Linux 3.15-rc1)
Merging arm-soc/for-next (c45c15204ae9 arm-soc: document new merges)
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-rockchip/rockchip.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/omap-mpuss-lowpow=
er.c
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/board-v7.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/exynos.c
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8a26730ea692 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (49a96400a142 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (0a847a5b6ebe Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (9e5ace6250ce Merge branch 'heads/fixes-for-v3.16' int=
o next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a7790-lager.dts
Merging samsung/for-next (7fa3239311b0 Merge branch 'v3.16-next/non-critica=
l-fixes' into for-next)
Merging tegra/for-next (ae3caacb703d Merge branch for-3.16/defconfig into f=
or-next)
Merging arm64/for-next/core (9358d755bd5c arm64: kernel: initialize broadca=
st hrtimer based clock event device)
Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (e8d6dc5ad26e m68k/hp300: Convert printk to pr_foo())
Merging m68knommu/for-next (83c6bdb827c9 m68knommu: Implement gpio support =
for m54xx.)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (14186fea0cb0 Merge tag 'locks-v3.15-4' of git://gi=
t.samba.org/jlayton/linux)
Merging mips/mips-for-linux-next (a1eace4ba535 MIPS: Add minimal defconfig =
for mips_paravirt)
CONFLICT (content): Merge conflict in arch/mips/mti-malta/malta-memory.c
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (26c88f930141 powerpc: Document sysfs DSCR interface)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/sections.h
Merging fsl/next (e83eb028bb98 powerpc/fsl: Add fsl,portid-mapping to coren=
et1-cf chips)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (63aef00b55d3 s390/lowcore: replace lowcore irb array=
 with a per-cpu variable)
CONFLICT (content): Merge conflict in arch/s390/pci/pci_sysfs.c
Merging sparc-next/master (311b8935ad4e Merge branch 'sparc_sparse_fixes')
CONFLICT (content): Merge conflict in arch/sparc/include/asm/pgtable_64.h
Merging tile/master (b2dfa048bae3 replace strict_strto* call with kstrto*)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d7b452a61ee7 UniCore32: Change git tree locati=
on information in MAINTAINERS)
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache r=
eaddir)
Merging cifs/for-next (663a96215159 CIFS: Fix memory leaks in SMB2_open)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (4e1ca652f912 ext4: fix wrong assert in ext4_mb_normalize_=
request())
Merging f2fs/dev (f6238a72092c MAINTAINERS: add a co-maintainer from samsun=
g for F2FS)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
Merging gfs2/master (0e48e055a7df GFS2: Prevent recovery before the local j=
ournal is set)
Merging jfs/jfs-next (e31da3f98d3b JFS: Check for NULL before calling posix=
_acl_equiv_mode())
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (b5968725f46d Push the file layout driver into a sub=
directory)
Merging nfsd/nfsd-next (da2ebce6a0f6 nfsd: make nfsd4_encode_fattr static)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (ba6a7d55634b UBIFS: fix debugging check)
Merging xfs/for-next (b70f14e1ffbb Merge branch 'xfs-feature-bit-cleanup' i=
nto for-next)
Merging file-private-locks/linux-next (62af4f1f7df4 locks: add some tracepo=
ints in the lease handling code)
Merging vfs/for-next (9bd0bc947d95 kill generic_file_splice_write())
CONFLICT (content): Merge conflict in fs/splice.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/f2fs/file.c
CONFLICT (content): Merge conflict in fs/ext4/file.c
Merging pci/next (0eeb4f2af5f7 Merge branch 'pci/iommu' into next)
Merging hid/for-next (a84823e7827c Merge branch 'for-3.16/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (eae45e5dd229 i2c: Make of_device_id array const)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (9d311eddf356 hwmon: (nct6775) Fix probe u=
nwind paths to properly unregister platform devices)
Merging v4l-dvb/master (656111f4b9cb Merge branch 'topic/omap3isp' into to_=
next)
Merging kbuild/for-next (5366c855e0d8 Merge branches 'kbuild/misc' and 'kbu=
ild/kbuild' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (fc6db7a44659 Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (d67e1cc8509b Merge branch 'pm-cpufreq-next' into lin=
ux-next)
CONFLICT (content): Merge conflict in drivers/cpufreq/exynos-cpufreq.h
CONFLICT (content): Merge conflict in drivers/cpufreq/exynos-cpufreq.c
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (63745aa72ed1 Merge branches 'armada-375-380-soc-suppo=
rt', 'eduardo-thermal-soc-fixes', 'intel-soc-dts-thermal' and 'thermal-soc-=
fixes' of .git into next)
Merging ieee1394/for-next (165d560bb267 Merge branch 'master' into for-next)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (445691d6eed7 Merge branch 'topic/shdma_fixes' into =
next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (e9d9450497f7 net: filter: fix length calculation i=
n BPF testsuite)
CONFLICT (content): Merge conflict in net/ipv6/output_core.c
CONFLICT (content): Merge conflict in include/net/inetpeer.h
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging ipsec-next/master (fc68086ce888 net/xfrm/xfrm_output.c: move EXPORT=
_SYMBOL)
Merging wireless-next/master (a715c7ddd65a wil6210: improve debug for WMI r=
eceive)
Merging bluetooth/master (8a96f3cd2287 Bluetooth: Fix L2CAP deadlock)
Merging infiniband/for-next (73b878af3514 Merge branches 'core', 'cxgb3', '=
cxgb4', 'mlx4', 'mlx5', 'qib', 'srp' and 'usnic' into for-next)
CONFLICT (content): Merge conflict in drivers/net/ethernet/mellanox/mlx4/cm=
d.c
Merging mtd/master (28c015a9daab mtd: davinci-nand: disable subpage write f=
or keystone-nand)
Merging l2-mtd/master (91f5498ebfb2 mtd: gpmi: add gpmi support for imx6sx)
Merging crypto/master (5208ed2ca165 crypto: testmgr - add aead cbc des, des=
3_ede tests)
CONFLICT (content): Merge conflict in drivers/crypto/caam/error.c
CONFLICT (rename/delete): drivers/crypto/bfin_crc.h deleted in HEAD and ren=
amed in crypto/master. Version crypto/master of drivers/crypto/bfin_crc.h l=
eft in tree.
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in crypto/crypto_user.c
Merging drm/drm-next (182407a6ed53 drm: add DP MST encoder type)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_gtt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_execbuf=
fer.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Merging drm-panel/drm/panel/for-next (02dfc65dc905 drm/panel: add support f=
or EDT ET057090DHU panel)
Merging drm-intel/for-linux-next (866997c6fc0d drm/i915: Drop unused lut ta=
bles from intel_plane)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.h
Merging drm-tegra/drm/tegra/for-next (f00e104dc165 drm/tegra: gem - Make te=
gra_bo_import() static)
Merging sound/for-next (a6975f2af8a5 ALSA: firewire-lib: Use IEC 61883-6 co=
mpliant labels for Raw Audio data)
Merging sound-asoc/for-next (b157817135fc Merge remote-tracking branches 'a=
soc/topic/wm8804', 'asoc/topic/wm8955', 'asoc/topic/wm8985' and 'asoc/topic=
/wm9713' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (a17597d3b418 virtio-rng: fixes for device regis=
tration/unregistration)
Merging input/next (61721c88b8d8 Input: omap-keypad - remove platform data =
support)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (5619516851b6 Merge branch 'for-3.16/core' into for-=
next)
Merging device-mapper/for-next (1ffafe0b8eb9 dm crypt: remove io_pending re=
fcount member from dm_crypt_io)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (06732b84b4cf mmc: sdhci-of-esdhc: Fixup compile error)
CONFLICT (content): Merge conflict in include/linux/omap-dma.h
Applying: dmaengine: omap: fix for code movement
$ git am -3 ../patches/0001-Revert-mmc-sunxi-Add-driver-for-SD-MMC-hosts-fo=
und-o.patch
Applying: Revert "mmc: sunxi: Add driver for SD/MMC hosts found on Allwinne=
r sunxi SoCs"
$ git reset --hard HEAD^
Merging next-20140522 version of mmc
Merging mmc-uh/next (8c3a05b489ef mmc: mmci: Enforce DMA configuration thro=
ugh DT)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (2ac295a544dc md: always set MD_RECOVERY_INTR when inte=
rrupting a reshape thread.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (9f9b201a97e9 mfd: tps65218: Terminate of match=
 table)
CONFLICT (add/add): Merge conflict in drivers/mmc/host/rtsx_usb_sdmmc.c
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (e1f0cbfb4603 Merge branches '3.16/fbdev', '3.16=
/fbdev-omap' and '3.16/omap-dss-dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am437x-gp-evm.dts
Merging regulator/for-next (978371cbabb4 Merge remote-tracking branch 'regu=
lator/topic/tps6586x' into regulator-next)
Merging security/next (2fd4e6698f08 Merge branch 'smack-for-3.16' of git://=
git.gitorious.org/smack-next/kernel into next)
Merging selinux/next (47dd0b76ace9 selinux: conditionally reschedule in has=
htab_insert while loading selinux policy)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (6103c763759d x86: intel-mid: add watchdog platform=
 code for Merrifield)
Merging iommu/next (c0981b863a31 Merge branches 'iommu/fixes', 'arm/omap', =
'arm/smmu', 'arm/shmobile', 'x86/amd', 'arm/exynos', 'arm/renesas', 'ppc/pa=
mu' and 'arm/msm' into next)
CONFLICT (content): Merge conflict in drivers/iommu/exynos-iommu.c
Merging dwmw2-iommu/master (5ae0566a0fff iommu/vt-d: fix bug in matching PC=
I devices with DRHD/RMRR descriptors)
Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt c=
ount)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (31789538e3ba staging: go7007: remove reference to=
 CONFIG_KMOD)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/arm=
/omap/omap.txt
Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_sysca=
ll_entry() interface)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (08cf78ed41fe of_pci_irq: kill useless v=
ariable in of_irq_parse_pci())
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/platsmp.c
Applying: of: fix bad merge of drivers/of/base.c
Merging dt-rh/for-next (728dd198aa54 Merge branch 'earlycon-dt' into for-ne=
xt)
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging spi/for-next (69e25c755722 Merge remote-tracking branch 'spi/topic/=
workqueue' into spi-next)
Merging tip/auto-latest (aec36eaab600 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in drivers/block/mtip32xx/mtip32xx.c
CONFLICT (content): Merge conflict in arch/arm64/mm/mmu.c
CONFLICT (content): Merge conflict in arch/arm64/include/asm/thread_info.h
Applying: x86,vdso: When vdso2c fails, unlink the output
Applying: x86,vdso: Fix cross-compilation from big-endian architectures
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/vf610.dtsi
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (aa2064d7dd35 EDAC: Fix MC scrub mode comparsion =
bug for correctable errors)
Merging irqchip/irqchip/for-next (3203bea71513 Documentation: add Broadcom =
STB Level-2 interrupt controller binding)
Merging ftrace/for-next (676412a37f24 Merge branch 'trace/ftrace/core' into=
 trace/for-next)
Merging rcu/rcu/next (61f38db3e3c0 rcu: Provide API to suppress stall warni=
ngs while sysrc runs)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (1f854112553a KVM: vmx: DR7 masking on task switch e=
mulation is wrong)
Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support =
for Cortex-A53)
Merging kvm-ppc/kvm-ppc-next (d8d164a9850d KVM: PPC: Book3S PR: Rework SLB =
switching code)
CONFLICT (content): Merge conflict in include/uapi/linux/kvm.h
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (77945ca73e9a x86/xen: map foreign pfns for auto=
translated guests)
Merging percpu/for-next (92a82b81ba46 Merge branch 'for-3.16' into for-next)
Merging workqueues/for-next (015af06e103f kernel/workqueue.c: pr_warning/pr=
_warn & printk/pr_info)
Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scen=
arios where memory allocations would fail)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (ef98ae45e6b3 Merge remote-tracking branch 'regmap/=
topic/smbus' into regmap-next)
Merging hsi/for-next (eafaebd987fc HSI: Introduce Nokia N900 modem driver)
Merging leds/for-next (0c9a03b68511 leds: Remove duplicated OOM message for=
 individual driver)
Merging driver-core/driver-core-next (cda43576afa6 crypto/nx/nx-842: dev_se=
t_drvdata can no longer fail)
CONFLICT (content): Merge conflict in drivers/iommu/exynos-iommu.c
Merging tty/tty-next (9ce4f8f3f454 Revert "serial: imx: remove the DMA wait=
 queue")
Merging usb/usb-next (4a95b1fce977 usb: hub_handle_remote_wakeup() only exi=
sts for CONFIG_PM=3Dy)
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
Merging staging/staging-next (7eb843aa5050 staging: skein: fix sparse warni=
ng for static declarations)
CONFLICT (content): Merge conflict in drivers/staging/rtl8821ae/core.c
Merging char-misc/char-misc-next (a100d88df1e9 hv: use correct order when f=
reeing monitor_pages)
Merging cgroup/for-next (5533e0114425 cgroup: disallow debug controller on =
the default hierarchy)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Merging scsi/for-next (68fd4d9d14cb Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.16' into for-next)
Merging scsi-core/core-for-3.16 (63ff05910d96 include/scsi/osd_protocol.h: =
remove unnecessary __constant)
Merging scsi-drivers/drivers-for-3.16 (e90b25fa40a4 mvsas: Recognise device=
/subsystem 9485/9485 as 88SE9485)
Merging target-updates/for-next (aecd533a41b0 iscsi-target: Fix CHAP_A para=
meter list handling)
CONFLICT (content): Merge conflict in drivers/scsi/virtio_scsi.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (29c7f1f53bfb pinctrl: sirf: fix a bad conflict re=
solution)
Merging vhost/linux-next (fbf97b18dc11 vhost: replace rcu with mutex)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (fc346270124a gpio: select IRQ_DOMAIN for gpiolib irq=
chip helpers)
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (39fd3f99aba3 pwm: fsl-ftm: set pwm_chip can_sleep fla=
g)
CONFLICT (content): Merge conflict in drivers/leds/leds-pwm.c
Merging dma-buf/for-next (68f965a6028f DRM: Armada: update dma_buf_export u=
se)
CONFLICT (content): Merge conflict in drivers/staging/android/sync.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_dmabuf.c
Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of=
 BSD accounting files)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (9ec2749bde1a clk: qcom: Return error pointers for uni=
mplemented clocks)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging random/dev (f9c6d4987b23 random: fix BUG_ON caused by accounting si=
mplification)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (fa88b6f8803c aio: cleanup: flatten kill_ioctx())
Merging llvmlinux/for-next (4f6d454aae03 unwind_support)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (8b1cbef71a7e These days most people use git to send=
 patches so I have added a section about that.)
$ git am -3 ../patches/0001-Revert-cpuidle-kvm-cpuidle.patch
Applying: Revert "cpuidle: kvm cpuidle"
Merging akpm-current/current (5e19bfb5fbc1 mm-compaction-properly-signal-an=
d-act-upon-lock-and-need_sched-contention-fix-2)
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in kernel/kexec.c
CONFLICT (content): Merge conflict in fs/ext4/page-io.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/topology.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/Kbuild
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: mm/page_io.c: work around gcc bug
Applying: arm: convert use of typedef ctl_table to struct ctl_table
Applying: ia64: convert use of typedef ctl_table to struct ctl_table
Applying: tile: convert use of typedef ctl_table to struct ctl_table
Applying: cdrom: convert use of typedef ctl_table to struct ctl_table
Applying: random: convert use of typedef ctl_table to struct ctl_table
Applying: parport: convert use of typedef ctl_table to struct ctl_table
Applying: scsi: convert use of typedef ctl_table to struct ctl_table
Applying: coda: convert use of typedef ctl_table to struct ctl_table
Applying: fscache: convert use of typedef ctl_table to struct ctl_table
Applying: lockd: convert use of typedef ctl_table to struct ctl_table
Applying: nfs: convert use of typedef ctl_table to struct ctl_table
Applying: inotify: convert use of typedef ctl_table to struct ctl_table
Applying: ntfs: convert use of typedef ctl_table to struct ctl_table
Applying: fs: convert use of typedef ctl_table to struct ctl_table
Applying: key: convert use of typedef ctl_table to struct ctl_table
Applying: ipc: convert use of typedef ctl_table to struct ctl_table
Applying: sysctl: convert use of typedef ctl_table to struct ctl_table
Applying: mm: convert use of typedef ctl_table to struct ctl_table
Applying: mfd/rtc: sec/s5m: rename SEC* symbols to S5M
Applying: rtc: s5m: remove undocumented time init on first boot
Applying: rtc: s5m: use shorter time of register update
Applying: rtc: s5m: support different register layout
Applying: rtc: s5m: add support for S2MPS14 RTC
Applying: rtc: s5m: consolidate two device type switch statements
Applying: blackfin/ptrace: call find_vma with the mmap_sem held
Applying: kernel/watchdog.c: print traces for all cpus on lockup detection
Applying: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
Applying: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fi=
x-2
Applying: kernel/watchdog.c: convert printk/pr_warning to pr_foo()
Applying: init/main.c: code clean-up
Applying: fs/reiserfs/bitmap.c: coding style fixes
Applying: fs/reiserfs/stree.c: remove obsolete __constant
Applying: rwsem: Support optimistic spinning
Applying: rwsem-support-optimistic-spinning-checkpatch-fixes
Applying: rwsem-support-optimistic-spinning-fix
Applying: kernel/kprobes.c: convert printk to pr_foo()
Applying: sysrq: rcu-ify __handle_sysrq
Applying: sysrq,rcu: suppress RCU stall warnings while sysrq runs
Applying: memcg, mm: introduce lowlimit reclaim
Applying: memcg-mm-introduce-lowlimit-reclaim-fix
Applying: memcg: allow setting low_limit
Applying: memcg, doc: clarify global vs. limit reclaims
Applying: memcg-doc-clarify-global-vs-limit-reclaims-fix
Applying: memcg: document memory.low_limit_in_bytes
Applying: vmscan: memcg: check whether the low limit should be ignored
Applying: vmscan: memcg: always use swappiness of the reclaimed memcg
Applying: mm/kmemleak.c: use %u to print ->checksum
Applying: mm: introduce kmemleak_update_trace()
Applying: lib/radix-tree.c: update the kmemleak stack trace for radix tree =
allocations
Applying: mm/mempool.c: update the kmemleak stack trace for mempool allocat=
ions
Applying: mm/memblock.c: call kmemleak directly from memblock_(alloc|free)
Applying: mm: memcontrol: clean up memcg zoneinfo lookup
Applying: mm: memcontrol: remove unnecessary memcg argument from soft limit=
 functions
Applying: mm: mark remap_file_pages() syscall as deprecated
Applying: mm-mark-remap_file_pages-syscall-as-deprecated-fix
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: mm-replace-remap_file_pages-syscall-with-emulation-fix
Applying: mm: remap_file_pages: initialize populate before usage
Applying: mm: remap_file_pages: grab file ref to prevent race while mmaping
Applying: memcg: deprecate memory.force_empty knob
Applying: memcg-deprecate-memoryforce_empty-knob-fix
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: zero out seek range on _fat_get_block
Applying: fat: fallback to buffered write in case of fallocated region on d=
irect IO
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: nmi: provide the option to issue an NMI back trace to every cpu b=
ut current
Applying: nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-bu=
t-current-fix
Applying: fs/dlm/config.c: convert simple_str to kstr
Applying: fs/dlm/lockspace.c: convert simple_str to kstr
Applying: fs/dlm/debug_fs.c: replace seq_printf by seq_puts
Applying: mm/kmemleak-test.c: use pr_fmt for logging
Applying: bio: modify __bio_add_page() to accept pages that don't start a n=
ew segment
Applying: bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-s=
egment-v3
Applying: MAINTAINERS: add linux-api for review of API/ABI changes
Applying: MAINTAINERS: adi-buildroot-devel is moderated
Applying: mm: convert some level-less printks to pr_*
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: ufs: sb mutex merge + mutex_destroy
Applying: mm: add strictlimit knob
Merging akpm/master (6eb98a9b96a8 mm: add strictlimit knob)

--Sig_/G8ihyu1g1IV38N71PbsanCl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjZUzAAoJEMDTa8Ir7ZwVwQ4P/3xyikWf/U/3tL7G6hNtvMwS
ce5ddWP0CUanSm7+UP6k7lYan0OlAljMrXKyPZydTRqIdd6pNTo38zK7UWyfiJeG
LK3AaOd17iGaBCRJUA3tcUUilKN+LBVu3oypw1Qk7nP6aOm3+I490Rzn9aOTCHtY
nwOF+CpmHPwMa4FZtCAYME/RT9Uu3NQ9+bp4aP9Q3djmSC1u3h8T+8lyk0Vhq6VJ
Z8WEtJoohWYrO4Q4Uualo+YDK4Vk1H5CqoBQChHw2qiKrWwKG14pSaVZfqikA74C
gxeaoqU/op9RYmd3T+gd2U53FpTVbgdfbHYat9NwQ0Tod5b4gRsqW0uh2lDG6pkQ
tdUa8/2FXfpgGYm1GGEvwQ+hAkk9qHvOx7Wl2q1Pt/TjrID15BWLds2EQ9dbczTb
WSbr7g3je1QAgxdgDCbH9eaoCiz4kGElouwKTvJAlBAPkfjj5bU4EQ/pY8ec8rqA
zV5gmOHH1WB+j/1muOC6w4IJYUEfmmekNGKjs1ZVsjLxS4RL1G7CwAtV+4vN6gOj
gWjPf+jcik1UMSflwH6hF14RQO74uw5whVTRVbzD5jqz9vho/LvgPHIgLBhAvXdF
n9XDxAJblqUfJWYjr8tFOqJciODl6Epp6uuxsPE4HwVI3GHmt36LEIMaAVNBLWKd
4QyU02x+kQGItUMJbZTA
=eOuD
-----END PGP SIGNATURE-----

--Sig_/G8ihyu1g1IV38N71PbsanCl--
