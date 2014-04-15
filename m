Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaDODjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:39:18 -0400
Received: from ozlabs.org ([103.22.144.67]:59307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaDODjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:39:13 -0400
Date: Tue, 15 Apr 2014 13:39:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 15
Message-Id: <20140415133906.336cdb45b7d3c31ff405437c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Apr_2014_13_39_06_+1000_bITJrKddjA4XcH/g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2014_13_39_06_+1000_bITJrKddjA4XcH/g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree still fails (more than usual) the powerpc allyesconfig build.

Changes since 20140414:

Dropped trees: akpm-current, akpm (too complex conflicts)

The powerpc tree still had its build failure.

The drm-intel tree gained a conflict against the drm-intel-fixes tree.

The sound-asoc tree gained build failures so I used the version from
next-20140414.

The spi tree gained a build failure so I used the version from
next-20140414.

Non-merge commits (relative to Linus' tree): 730
 1012 files changed, 14028 insertions(+), 12181 deletions(-)

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
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 213 trees (counting Linus' and 28 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

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
Merging origin/master (55101e2d6ce1 Merge git://git.kernel.org/pub/scm/virt=
/kvm/kvm)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (0409726a81f2 ARC: fix mmuv2 warning)
Merging arm-current/fixes (c9d347e02776 ARM: 8009/1: dcscb.c: remove call t=
o outer_flush_all())
Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3=
.14-rc1)
Merging metag-fixes/fixes (0414855fdc4a Linux 3.14-rc5)
Merging powerpc-merge/merge (cc4f265ad9a3 powerpc/powernv Adapt opal-elog a=
nd opal-dump to new sysfs_remove_file_self)
Merging sparc/master (455c6fdbd219 Linux 3.14)
Merging net/master (00cbc3dcd1e2 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/pablo/nf)
Merging ipsec/master (5596732fa8c1 xfrm: Fix crash with ipv6 IPsec tunnel a=
nd NAT.)
Merging sound-current/for-linus (5e0c18799191 ALSA: es18xx driver should us=
e udelay error)
Merging pci-current/for-linus (140ab6452c42 powerpc/PCI: Fix NULL dereferen=
ce in sys_pciconfig_iobase() list traversal)
Merging wireless/master (c0da71ff4d2c wl18xx: align event mailbox with curr=
ent fw)
Merging driver-core.current/driver-core-linus (b33ce4429938 Merge branch 'f=
or-3.15/drivers' of git://git.kernel.dk/linux-block)
Merging tty.current/tty-linus (b33ce4429938 Merge branch 'for-3.15/drivers'=
 of git://git.kernel.dk/linux-block)
Merging usb.current/usb-linus (b33ce4429938 Merge branch 'for-3.15/drivers'=
 of git://git.kernel.dk/linux-block)
Merging staging.current/staging-linus (c9eaa447e77e Linux 3.15-rc1)
Merging char-misc.current/char-misc-linus (b33ce4429938 Merge branch 'for-3=
.15/drivers' of git://git.kernel.dk/linux-block)
Merging input-current/for-linus (692d96552c9a Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (eb4a5346e777 hwrng: bcm2835 - fix oops when =
rng h/w is accessed during registration)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (1f42e5dd5065 of: Add self test=
 for of_match_node())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (b6842feb63a2 drm/i915: Allow =
user modes to exceed DVI 165MHz limit)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging arm/for-next (98f07013149d Merge branch 'devel-stable' into for-nex=
t)
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (c9eaa447e77e Linux 3.15-rc1)
Merging arm-soc/for-next (2bf73dd61a84 Merge tag 'tags/cleanup2-3.15' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (1e9dfe21eca8 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (47fc77cc704e Merge branch 'for_3.15/fixes' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (6412d6635b67 Merge branch 'mvebu/dt-fixes-non-criti=
cal' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging renesas/next (4228dd1299f3 Merge branch 'heads/fixes-for-v3.15' int=
o next)
Merging samsung/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging tegra/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging arm64/for-next/core (ebf81a938dad arm64: Fix DMA range invalidation=
 for cache line unaligned buffers)
Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
Merging m68knommu/for-next (2bf0787b4b42 m68k: fix a compiler warning when =
building for DragonBall)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (a66a626538af microblaze: Use asm-generic/io.h)
Merging mips/mips-for-linux-next (382fa82f376b Merge branch '3.15-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (ab3e55b119c9 parisc: fix epoll_pwait syscall on=
 compat kernel)
Merging powerpc/next (cd427485357c Merge remote-tracking branch 'scott/next=
' into next)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (4c0fda161346 s390/cmma: remove "cmma disable" code i=
n case of dump again)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5eb0bdf84433 arch/tile: remove unused variable 'devcap=
')
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (cfe8255f0afc xtensa: xt2000: drop redundant sysmem=
 initialization)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache r=
eaddir)
Merging cifs/for-next (a5a64da8c4e5 fs: cifs: remove unused variable.)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (021b5a00821a ext4: add fallocate mode blocking for debugg=
ing purposes)
Merging f2fs/dev (c9eaa447e77e Linux 3.15-rc1)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (f3846266f593 fuse: fix "uninitialized variable" warn=
ing)
Merging gfs2/master (c9eaa447e77e Linux 3.15-rc1)
Merging jfs/jfs-next (24e4a0f3de21 fs/jfs/jfs_inode.c: atomically set inode=
->i_flags)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (c9eaa447e77e Linux 3.15-rc1)
Merging nfsd/nfsd-next (06f9cc12caa8 nfsd4: don't create unnecessary mask a=
cl)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging ubifs/linux-next (d56030ac25d3 UBI: block: Remove __initdata from u=
biblock_param_ops)
Merging xfs/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging file-private-locks/linux-next (18a1a7a1d862 Merge git://git.kernel.=
org/pub/scm/linux/kernel/git/cmetcalf/linux-tile)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (c9eaa447e77e Linux 3.15-rc1)
Merging hid/for-next (d1443c96d663 Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (9e897e13bd46 Merge branch 'for-linus' of git://gi=
t.open-osd.org/linux-open-osd)
Merging jdelvare-hwmon/master (455c6fdbd219 Linux 3.14)
Merging hwmon-staging/hwmon-next (046f3ea7c6af hwmon: (lm77) Drop FSF maili=
ng address)
Merging v4l-dvb/master (3f52fc47bbb3 Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ac98dab39e55 Merge branch 'kbuild/lto' into kbuild=
/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (b165d8519a80 Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (19ce7f3f3110 Merge branch 'acpi-config')
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (9477165ec525 thermal: rcar-thermal: update thermal zo=
ne only when temperature changes)
Merging ieee1394/for-next (0ca49345b6f4 firewire: ohci: fix probe failure w=
ith Agere/LSI controllers)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (5fc68a6cad65 dma: edma: fix incorrect SG list handl=
ing)
Merging dmaengine/next (b9bf6d2e84b7 dma: mv_xor: Flush descriptors before =
activating a channel)
Merging net-next/master (cd6362befe4c Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net-next)
Merging ipsec-next/master (cd6362befe4c Merge git://git.kernel.org/pub/scm/=
linux/kernel/git/davem/net-next)
Merging wireless-next/master (321d03c86732 Merge branch 'misc' of git://git=
.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild)
Merging bluetooth/master (899704633969 Bluetooth: Fix redundant encryption =
request for reauthentication)
Merging infiniband/for-next (5ae2866f5264 Merge branches 'cxgb4', 'misc', '=
mlx5' and 'qib' into for-next)
Merging mtd/master (c9eaa447e77e Linux 3.15-rc1)
Merging l2-mtd/master (c9eaa447e77e Linux 3.15-rc1)
Merging crypto/master (0ea481466d1c crypto: ghash-clmulni-intel - Use u128 =
instead of be128 for internal key)
Merging drm/drm-next (c39b06951f1d DRM: armada: fix corruption while loadin=
g cursors)
Merging drm-intel/for-linux-next (d3b542fcfc72 drm/i915: Add parsing suppor=
t for new MIPI blocks in VBT)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_context=
.c
Merging drm-tegra/drm/for-next (3d1c1474386e drm/tegra: Use standard GPL v2=
 license text)
Merging sound/for-next (d700d70dfd2e Merge branch 'topic/usb-audio' into fo=
r-next)
Merging sound-asoc/for-next (b2cf99e7356c Merge remote-tracking branch 'aso=
c/topic/sta350' into asoc-next)
$ git reset --hard HEAD^
Merging next-20140414 version of sound-asoc
Merging modules/modules-next (22c9bcad859d staging: fix up speakup kobject =
mode)
Merging virtio/virtio-next (fc4324b4597c virtio-blk: base queue-depth on vi=
rtqueue ringsize or module param)
Merging input/next (e2c3ecf0ea8e Input: edt-ft5x06 - add a missing conditio=
n)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (cf81ae32fef1 Merge branch 'for-linus' into for-next)
Merging device-mapper/for-next (7eb0e608b4e1 Merge branch 'for-3.15-dm-cryp=
t' into for-next)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (c67480173f72 mmc: sdhci-acpi: Intel SDIO has broken c=
ard detect)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (34bf6ef94a83 mm: slab/slub: use page->list consisten=
tly instead of page->lru)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (e2f23b606b94 md: avoid oops on unload if some process =
is in poll or select.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (2d28ca731b9b mfd: wm5110: Correct default for =
HEADPHONE_DETECT_1)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (d754589d8044 OMAPDSS: add missing __init for ds=
s_init_ports)
CONFLICT (rename/delete): drivers/video/fbdev/sgivwfb.c deleted in HEAD and=
 renamed in omap_dss2/for-next. Version omap_dss2/for-next of drivers/video=
/fbdev/sgivwfb.c left in tree.
CONFLICT (content): Merge conflict in drivers/video/Makefile
CONFLICT (content): Merge conflict in drivers/video/Kconfig
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_reg.h"->"d=
rivers/gpu/drm/exynos/exynos_dp_reg.h" in branch "HEAD" rename "drivers/vid=
eo/exynos/exynos_dp_reg.h"->"drivers/video/fbdev/exynos/exynos_dp_reg.h" in=
 "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_reg.c"->"d=
rivers/gpu/drm/exynos/exynos_dp_reg.c" in branch "HEAD" rename "drivers/vid=
eo/exynos/exynos_dp_reg.c"->"drivers/video/fbdev/exynos/exynos_dp_reg.c" in=
 "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_core.h"->"=
drivers/gpu/drm/exynos/exynos_dp_core.h" in branch "HEAD" rename "drivers/v=
ideo/exynos/exynos_dp_core.h"->"drivers/video/fbdev/exynos/exynos_dp_core.h=
" in "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_core.c"->"=
drivers/gpu/drm/exynos/exynos_dp_core.c" in branch "HEAD" rename "drivers/v=
ideo/exynos/exynos_dp_core.c"->"drivers/video/fbdev/exynos/exynos_dp_core.c=
" in "omap_dss2/for-next"
$ git rm -f drivers/video/fbdev/exynos/exynos_dp_core.c drivers/video/fbdev=
/exynos/exynos_dp_core.h drivers/video/fbdev/exynos/exynos_dp_reg.c drivers=
/video/fbdev/exynos/exynos_dp_reg.h drivers/video/exynos/exynos_dp_core.c d=
rivers/video/exynos/exynos_dp_core.h drivers/video/exynos/exynos_dp_reg.c d=
rivers/video/exynos/exynos_dp_reg.h
$ git rm -f drivers/video/fbdev/sgivwfb.c
Applying: video: fbdev: fix up fro removal of SGI Visual Workstation
Merging regulator/for-next (33d3dd372152 Merge remote-tracking branches 're=
gulator/topic/axp20', 'regulator/topic/of', 'regulator/topic/pbias', 'regul=
ator/topic/s2mps11' and 'regulator/topic/s5m8767' into regulator-next)
Merging security/next (b13cebe70775 Merge tag 'keys-20140314' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into next)
Merging selinux/next (eee3094683fb selinux: correctly label /proc inodes in=
 use before the policy is loaded)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (c9eaa447e77e Linux 3.15-rc1)
Merging iommu/next (e172b8122254 Merge branches 'iommu/fixes', 'arm/smmu', =
'x86/amd', 'arm/omap', 'arm/shmobile' and 'x86/vt-d' into next)
Merging dwmw2-iommu/master (adeb25905c64 iommu/vt-d: fix memory leakage cau=
sed by commit ea8ea46)
Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
Merging osd/linux-next (f1f6630b53e7 MAINTAINERS: Update email address for =
bhalevy)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (c800bcd5f53f sparse: fix comment)
Merging audit/master (312103d64d0f AUDIT: make audit_is_compat depend on CO=
NFIG_AUDIT_COMPAT_GENERIC)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (d88cf7d7b424 Merge remote-tracking bran=
ch 'robh/for-next' into devicetree/next)
Merging dt-rh/for-next (f3afa2259457 DT: add vendor prefix for EBV Elektron=
ik)
Merging spi/for-next (46fe70e58844 Merge remote-tracking branches 'spi/topi=
c/sirf' and 'spi/topic/workqueue' into spi-next)
$ git reset --hard HEAD^
Merging next-20140414 version of spi
Merging tip/auto-latest (309ba7457356 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in arch/x86/kernel/early-quirks.c
Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct:=
 silence a static checker warning)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into f=
or-next)
Merging ftrace/for-next (17a280ea8111 tracing: Add missing function trigger=
s dump and cpudump to README)
Merging rcu/rcu/next (765a3f4fed70 rcu: Provide grace-period piggybacking A=
PI)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (7cbb39d4d4d5 Merge tag 'kvm-3.15-1' of git://git.ke=
rnel.org/pub/scm/virt/kvm/kvm)
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (7227fc066660 Merge branch 'kvm-ppchv-next' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-next)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (0a25e113b480 Merge branch 'devel/for-linus-3.15=
' into linux-next)
Merging percpu/for-next (5a838c3b60e3 percpu: make pcpu_alloc_chunk() use p=
cpu_mem_free() instead of kfree())
Merging workqueues/for-next (c4b75dadde82 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scen=
arios where memory allocations would fail)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (b94f4fe06dd8 Merge remote-tracking branches 'regma=
p/topic/le', 'regmap/topic/mmio' and 'regmap/topic/rbtree' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (14f5716bc23c leds: make sure we unregister a trigger=
 only once)
Merging driver-core/driver-core-next (b33ce4429938 Merge branch 'for-3.15/d=
rivers' of git://git.kernel.dk/linux-block)
Merging tty/tty-next (b33ce4429938 Merge branch 'for-3.15/drivers' of git:/=
/git.kernel.dk/linux-block)
Merging usb/usb-next (b33ce4429938 Merge branch 'for-3.15/drivers' of git:/=
/git.kernel.dk/linux-block)
Merging usb-gadget/next (4b76e14d95f7 phy: ti-pipe3: Add SATA compatible to=
 Documentation binding)
Merging staging/staging-next (c9a129966227 staging: dgap: rename and fixup =
dgap_wait_for_xxx functions)
Merging char-misc/char-misc-next (b33ce4429938 Merge branch 'for-3.15/drive=
rs' of git://git.kernel.dk/linux-block)
Merging cgroup/for-next (49957f8e2a43 cgroup: newly created dirs and files =
should be owned by the creator)
Merging scsi/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging target-updates/for-next (b076808051f2 ib_srpt: Use correct ib_sg_dm=
a primitives)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (cc17609e1855 Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (da150898c982 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (68efd7d2fb32 arm: dma-mapping: remove=
 order parameter from arm_iommu_create_mapping())
Merging pwm/for-next (2ae69a460413 pwm: pxa: Constify OF match table)
Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging userns/for-next (0d7d90f86f83 proc: Update proc_flush_task_mnt to u=
se d_invalidate)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
Merging ktest/for-next (62183dcac539 ktest: Set CLOSE_CONSOLE_SIGNAL in the=
 kvm.conf)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (e44df332f30b clk: shmobile: fix setting paretn clock =
rate)
Merging random/dev (7b878d4b48c4 random: Add arch_has_random[_seed]())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (fa8a53c39f3f aio: v4 ensure access to ctx->ring_pages i=
s correctly serialised for migration)
Merging llvmlinux/for-next (40e9963e622c Merge branch 'x86-platform-for-lin=
us' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (596d80c7ceb6 The sample wrapper currently fails on =
some Java 7 .class files.  This updates the wrapper to properly handle thos=
e files.)

--Signature=_Tue__15_Apr_2014_13_39_06_+1000_bITJrKddjA4XcH/g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTKnfAAoJEMDTa8Ir7ZwVcSMP/1Ox+JCLbZH1wyodjM628YEa
UFiEc4x8FDJ5j30n3JO5z7lPF8T2F8kkF188VV/Ags9dccFjaKfyheRysPU+v83I
RdwFciTdayJhMnblgh+1EYSvLvtiDREwcOSjVqTaxtI0PBe7TU+LX46yOkdqsaTv
ONJ4omwXdJhA45kxH868ZNrC5pZrJdNVYEAn/nvnf0mDwZIYn5jLif39vHIftGd3
sgksuvtouCeS0bSf6xIU3YHt1UVO04AwpgV1EG4Hxf0eGWczSo1dKo2LC0vNyPc6
qumrGnpGjXvXU65BZqqy8nujARa4GpkEv46iLPmdkiAwsQp3xkFHBkX/sd67p7Pg
CerhC6DUk9kFeaVkLC2islduTahtRZ/6wVfXJyBQdNBXje98C2hP3jHr7pqN8Pmc
8B3mWaNSGl0Q0iwYTWgvS2gllV8cmj3Lqy6+EGjIqhVnjlgG/AHUR3cIySdCcHxT
LMCRJOK21nbjsBFfCoMxFkVH2NnRBQnwNp8AZJtP1+O2UHkyhZaCwtYosh6Ya2Og
acxeJBpnFId1qTpEIe+uQX4/h7b5piyAXz1DDsB/M4kfCzi+LZZzR18ftrkyxnZr
RP1BURuZkemB2WeXvxfJpWd5tjNbPk9vKfcvAxYtgfYa0IvBT3fJNH9Y+iTfnO8e
XdDl1hVmVy0rduXDHXLE
=VP7C
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2014_13_39_06_+1000_bITJrKddjA4XcH/g--
