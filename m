Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaLZIaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 03:30:24 -0500
Received: from ozlabs.org ([103.22.144.67]:45404 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaLZIaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 03:30:19 -0500
Date: Fri, 26 Dec 2014 19:30:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Dec 26
Message-ID: <20141226193009.60d3f62e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bAQlOIGFbslgvk+NoaogD0F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bAQlOIGFbslgvk+NoaogD0F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

There will only be intermittent releases of linux-next between now and
Jan 5.

Changes since 20141221:

New trees: omap, omap-pending and livepatching

The rcu tree regained a build failure for which I reverted a commit.

Non-merge commits (relative to Linus' tree): 835
 853 files changed, 24131 insertions(+), 13211 deletions(-)

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

I am currently merging 234 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (08b022a9655b Merge branch 'drm-fixes' of git://peopl=
e.freedesktop.org/~airlied/linux)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (f114040e3ea6 Linux 3.18-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (3f4aa45ceea5 ARM: 8226/1: cacheflush: get rid of=
 restarting block)
Merging m68k-current/for-linus (f0b99a643e96 m68k/mm: Eliminate memset afte=
r alloc_bootmem_pages)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (b2776bf7149b Linux 3.18)
Merging sparc/master (66d0f7ec9f10 sparc32: destroy_context() and switch_mm=
() needs to disable interrupts.)
Merging net/master (4aa6118811c0 openvswitch: fix odd_ptr_err.cocci warning=
s)
Merging ipsec/master (f855691975bb xfrm6: Fix the nexthdr offset in _decode=
_session6.)
Merging sound-current/for-linus (d70a1b9893f8 ALSA: usb-audio: extend KEF X=
300A FU 10 tweak to Arcam rPAC)
Merging pci-current/for-linus (5106787a9e08 PCI: tegra: Use physical range =
for I/O mapping)
Merging wireless/master (97bf6af1f928 Linux 3.19-rc1)
Merging driver-core.current/driver-core-linus (97bf6af1f928 Linux 3.19-rc1)
Merging tty.current/tty-linus (97bf6af1f928 Linux 3.19-rc1)
Merging usb.current/usb-linus (b3ee8bdcd243 Merge tag 'fixes-for-v3.19-rc2'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging usb-gadget-fixes/fixes (6785a1034461 usb: gadget: udc: atmel: fix p=
ossible IN hang issue)
Merging usb-serial-fixes/usb-linus (97bf6af1f928 Linux 3.19-rc1)
Merging staging.current/staging-linus (97bf6af1f928 Linux 3.19-rc1)
Merging char-misc.current/char-misc-linus (97bf6af1f928 Linux 3.19-rc1)
Merging input-current/for-linus (6d32af019a45 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (7e77bdebff5c crypto: af_alg - fix backlog ha=
ndling)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (094cb98179f1 of/fdt: memblock_=
reserve /memreserve/ regions in the case of partial overlap)
Merging rr-fixes/fixes (3438cf549d2f param: fix crash on bad kernel argumen=
ts)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (6898b627aab6 selftests/exec: Use %zu to form=
at size_t)
Merging drm-intel-fixes/for-linux-next-fixes (b0616c5306b3 drm/i915: Unlock=
 panel even when LVDS is disabled)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging arm/for-next (e9f2d6d66037 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (cac7f2429872 Linux 3.18-rc2)
Merging arm-soc/for-next (d6ad36913083 clocksource: arch_timer: Only use th=
e virtual counter (CNTVCT) on arm64)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (8a73e870fc56 Merge tag 'imx-dt-3.19' into for-nex=
t)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (3ab7d497964c Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (b85311046cea Merge branch 'heads/dt-for-v3.20' into n=
ext)
Merging samsung/for-next (1eeec807bf64 Merge branch 'v3.20-next/dt-samsung-=
64' into for-next)
Merging sunxi/sunxi/for-next (ad01dbad5626 Merge branch 'sunxi/clocks-for-3=
.19' into sunxi/for-next)
Merging tegra/for-next (fa047e01365d Merge branch for-3.19/soc into for-nex=
t)
Merging arm64/for-next/core (fb59d007a0e4 arm64: mm: dump: don't skip final=
 region)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (8914d7e85780 Hexagon: fix signal delivery for d=
ebug traps)
Merging ia64/next (0fd2468fd035 Merge branch 'misc-3.19' into next)
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (0259650b4cf7 m68knommu: fix irq handler types i=
n 68360/commproc.c)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (3a8e3265179b microblaze: Fix mmap for cache cohere=
nt memory)
Merging mips/mips-for-linux-next (28320df4899b Merge branch '3.19-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (f1f2eac9124b nios2/uaccess: fix sparse errors)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (c792ede38c0e parisc: fix out-of-register compil=
er error in ldcw inline assembler function)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (d70a54e2d085 powerpc/powernv: Ignore smt-enabled =
on Power8 and later)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (fa0d0b064d55 s390/signal: add sys_sigreturn and sys_=
rt_sigreturn declarations)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (c47b15c4928c arch/tile: update MAINTAINERS email to EZ=
chip)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (1f2fdbd0078c xtensa: disable link optimization)
Merging btrfs/next (1edb647bb954 Btrfs: remove non-sense btrfs_error_discar=
d_extent() function)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
CONFLICT (content): Merge conflict in net/ceph/auth_x.c
CONFLICT (content): Merge conflict in fs/ceph/super.h
CONFLICT (content): Merge conflict in fs/ceph/super.c
CONFLICT (content): Merge conflict in fs/ceph/snap.c
Merging cifs/for-next (fdd6cc24423d Initialize salt value for negotiate con=
text)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (942080643bce eCryptfs: Remove buggy and unnecessary =
write in file name decode routine)
Merging ext3/for_next (3ee3039c5b4d udf: Reduce repeated dereferences)
Merging ext4/dev (50db71abc529 ext4: ext4_da_convert_inline_data_to_extent =
drop locked page after error)
Merging f2fs/dev (d09dd3c17a5f f2fs: fix missing cold bit during recovery)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (1c68271cf1bf fuse: use file_inode() in fuse_file_fal=
locate())
Merging gfs2/master (ec7d879c4576 GFS2: gfs2_atomic_open(): simplify the us=
e of finish_no_open())
Merging jfs/jfs-next (e1f1fe798d2f jfs: get rid of homegrown endianness hel=
pers)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (97bf6af1f928 Linux 3.19-rc1)
Merging nfsd/nfsd-next (3c0aeb6da065 nfsd: fi_delegees doesn't need to be a=
n atomic_t)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (2b7a8f36f092 ovl: add testsuite to docs)
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (efdca7aa3c41 Merge branch 'xfs-misc-fixes-for-3.20-1'=
 into for-next)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (88174fd2c8fb kill d_validate())
Merging pci/next (149792795d2b Merge branch 'pci/msi' into next)
Merging hid/for-next (3bc80f8b09bd Merge branch 'for-3.20/betop' into for-n=
ext)
Merging i2c/i2c/for-next (523c5b89640e i2c: Remove support for legacy PM)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (907a6d582459 hwmon: (tmp401) Detect TMP43=
5 on all addresses it supports)
Merging v4l-dvb/master (2ea3258b238c Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (657eeca39128 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (d325a876e2b3 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging pm/linux-next (8502544af41e Merge branch 'acpi-video')
Merging idle/next (f7c0e22f2d14 Merge branch 'turbostat' into release)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (97bf6af1f928 Linux 3.19-rc1)
Merging thermal-soc/next (d8c3cd75e77d Merge branch 'work-fixes' into work-=
next)
Merging ieee1394/for-next (d737d7da8e7e firewire: sbp2: replace card lock b=
y target lock)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (3e8ec65e62df Merge branch 'topic/rcar' into next)
Merging net-next/master (f96fe225677b Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
Merging ipsec-next/master (fbe68ee87522 vti6: Add a lookup method for tunne=
ls with wildcard endpoints.)
Merging wireless-next/master (97bf6af1f928 Linux 3.19-rc1)
Merging bluetooth/master (72e4a6bd0220 Bluetooth: Remove duplicate constant=
 for RFCOMM PSM)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (ed0215cc3b52 mtd: gpmi: Remove "We support only one =
NAND chip" from bindings doc)
Merging crypto/master (ad202c8c1563 crypto: af_alg - zeroize key data)
Merging drm/drm-next (4e0cd6811562 drm: sti: fix module compilation issue)
Merging drm-panel/drm/panel/for-next (54cbc4e298ea drm/mipi-dsi: Avoid pote=
ntial NULL pointer dereference)
Merging drm-intel/for-linux-next (5d77d9c5e177 drm/i915: add missing rpm re=
f to i915_gem_pwrite_ioctl)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (6cadd306033e drm/fb-helper: Propagate er=
rors from initial config failure)
Merging sound/for-next (d70a1b9893f8 ALSA: usb-audio: extend KEF X300A FU 1=
0 tweak to Arcam rPAC)
Merging sound-asoc/for-next (1b9f1ae8907c Merge remote-tracking branches 'a=
soc/topic/samsung' and 'asoc/topic/wm8750' into asoc-next)
Merging modules/modules-next (b0a65b0cccd4 param: do not set store func wit=
hout write perm)
Merging virtio/virtio-next (c91c2a63913b mic/host: initial virtio 1.0 suppo=
rt)
CONFLICT (content): Merge conflict in drivers/virtio/virtio_pci_common.c
Merging input/next (af6a5af8e8cc Input: add new sun4i-lradc-keys driver)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (e248d2ba0082 Merge branch 'for-3.19/drivers' into f=
or-next)
Merging device-mapper/for-next (af66c8489d6d dm table: train hybrid target =
type detection to select blk-mq if appropriate)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (2a8e76de3c17 mmc: mvsdio: don't use devm_pinctrl_get_s=
elect_default() in probe)
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (f851b60db0fd md: Check MD_RECOVERY_RUNNING as well as =
->sync_thread.)
Merging mfd/for-mfd-next (a3b63979f8a3 mfd: rtsx: Add func to split u32 int=
o register)
Merging backlight/for-backlight-next (3d6969a641d0 MAINTAINERS: Remove my n=
ame from Backlight subsystem)
Merging battery/master (02088e3ed79f power: reset: augment versatile driver=
 for integrator)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (574d54112fda Merge branches '3.19/omapdss' and =
'3.19/simplefb' into for-next)
Merging regulator/for-next (e16f66bc29f6 Merge remote-tracking branches 're=
gulator/topic/isl9305', 'regulator/topic/max14577', 'regulator/topic/mt6397=
' and 'regulator/topic/rk808' into regulator-next)
Merging security/next (b2d1965dcea1 Merge branch 'next' of git://git.infrad=
ead.org/users/pcmoore/selinux into next)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (566075875a84 selinux: Remove unused function avc_sidc=
mp())
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (2193e69bf650 watchdog: imx2_wdt: Fix the argument =
of watchdog_active())
CONFLICT (content): Merge conflict in drivers/watchdog/imx2_wdt.c
Merging iommu/next (76771c938e95 Merge branches 'arm/omap', 'arm/msm', 'arm=
/rockchip', 'arm/renesas', 'arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' int=
o next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (9b64c09bb960 kobject: grammar fix)
Merging trivial/for-next (078014dd3698 intel_ips: fix a type in error messa=
ge)
Merging audit/next (0f7e94ee40d0 Merge branch 'next' into upstream for v3.1=
9)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (c46ca3c8310b of: Delete unnecessary che=
ck before calling "of_node_put()")
Merging dt-rh/for-next (a0e27f51ba8a documentation: pinctrl bindings: Fix t=
rivial typo 'abitrary')
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (7b4f0bce21a6 Merge remote-tracking branches 'spi/topi=
c/inline', 'spi/topic/pxa2xx', 'spi/topic/sh-msiof' and 'spi/topic/st-ssc' =
into spi-next)
Merging tip/auto-latest (caa523dc2242 Merge branch 'x86/urgent')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (8c2b117fdf00 EDAC, mce_amd_inj: Fix sparse non s=
tatic symbol warning)
Merging irqchip/irqchip/for-next (5cc8f658723f Merge branch 'irqchip/irqdom=
ain-arm' into irqchip/for-next)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (d716ff71dd12 tracing: Remove taking of trace_types=
_lock in pipe files)
Merging rcu/rcu/next (e9694e74a5bf rcu: Initialize tiny RCU stall-warning t=
imeouts at boot)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (2c4aa55a6af0 Merge tag 'signed-kvm-ppc-next' of git=
://github.com/agraf/linux-2.6 into HEAD)
Merging kvm-arm/next (05971120fca4 arm/arm64: KVM: Require in-kernel vgic f=
or the arch timers)
Merging kvm-ppc/kvm-ppc-next (476ce5ef09b2 KVM: PPC: Book3S: Enable in-kern=
el XICS emulation by default)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
Merging percpu/for-next (bfaa047a9415 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging workqueues/for-next (008847f66c38 workqueue: allow rescuer thread t=
o do more work.)
Merging drivers-x86/for-next (200db647112d platform/x86/acerhdf: Still depe=
nds on THERMAL)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (270ded427d7b Merge remote-tracking branch 'regmap/=
topic/core' into regmap-next)
Merging hsi/for-next (d95dc9e38810 HSI: nokia-modem: fix error handling of =
irq_of_parse_and_map)
Merging leds/for-next (d5a570782795 leds: Don't allow brightness values gre=
ater than max_brightness)
Merging ipmi/for-next (e3fe142704f8 ipmi: Fix compile issue with isspace())
Merging driver-core/driver-core-next (97bf6af1f928 Linux 3.19-rc1)
Merging tty/tty-next (97bf6af1f928 Linux 3.19-rc1)
Merging usb/usb-next (97bf6af1f928 Linux 3.19-rc1)
Merging usb-gadget/next (ebf3992061db usb: musb: Use IS_ENABLED for tusb601=
0)
Merging usb-serial/usb-next (97bf6af1f928 Linux 3.19-rc1)
Merging staging/staging-next (97bf6af1f928 Linux 3.19-rc1)
Merging char-misc/char-misc-next (97bf6af1f928 Linux 3.19-rc1)
Merging cgroup/for-next (eeecbd197151 cgroup: implement cgroup_get_e_css())
Merging scsi/for-next (49f096fcbaec Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.19' into for-next)
Merging target-updates/for-next (ae450e246e85 target: Allow AllRegistrants =
to re-RESERVE existing reservation)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (96dfdff694ae pinctrl: rockchip: Fix enable/disabl=
e/mask/unmask)
Merging vhost/linux-next (fc30ebaedd95 vhost: relax used address alignment)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (170680abd1eb gpio: mcp23s08: fix up compilation erro=
r)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (39e046f2c1dd pwm: atmel-hlcdc: add at91sam9x5 and sam=
a5d3 errata handling)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (db86da7cb76f userns: Unbreak the unprivileged remo=
unt tests)
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (f1e9203e2366 clk: samsung: Fix Exynos 5420 pinctrl se=
tup and clock disable failure due to domain being gated)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (5f785de58873 aio: Skip timer for io_getevents if timeou=
t=3D0)
Merging llvmlinux/for-next (25d4aee23af2 arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
Merging kselftest/next (97bf6af1f928 Linux 3.19-rc1)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
Merging luto-misc/next (befbf87ddf3e x86, traps: Add ist_begin_non_atomic a=
nd ist_end_non_atomic)
CONFLICT (content): Merge conflict in kernel/rcu/tree_plugin.h
CONFLICT (content): Merge conflict in kernel/rcu/tree.h
CONFLICT (content): Merge conflict in kernel/rcu/rcutorture.c
CONFLICT (content): Merge conflict in include/linux/rcutree.h
CONFLICT (content): Merge conflict in include/linux/rcutiny.h
Merging access_once/linux-next (5de72a2247ac s390/kvm: REPLACE barrier fixu=
p with READ_ONCE)
Merging omap/for-next (b2776bf7149b Linux 3.18)
Merging omap-pending/for-next (b2776bf7149b Linux 3.18)
Merging livepatching/for-next (700a3048aaa3 livepatch: samples: fix usage e=
xample comments)
[master 6bfb06b6ab0f] Revert "srcu: Isolate srcu sections using CONFIG_SRCU"
Merging akpm-current/current (350b61c87ab5 metag: Align thread_info::superv=
isor_stack)
CONFLICT (modify/delete): mm/fremap.c deleted in akpm-current/current and m=
odified in HEAD. Version HEAD of mm/fremap.c left in tree.
CONFLICT (content): Merge conflict in fs/ocfs2/aops.c
$ git rm -f mm/fremap.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (b38b1661debd mm: add strictlimit knob)

--Sig_/bAQlOIGFbslgvk+NoaogD0F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnRyXAAoJEMDTa8Ir7ZwVNNgP/23gykBUlIUYvRlSxSpdXNiP
oTPZ4jGflr6hMOfyRsE9pZGNXIXvj2nLtD9sTUkvCMS6u4Om19eeYIt2ei+sseZp
r2/f+/D5VWlzFedqKQNRnbwddg8UqQxQ2Q/tP+k5JklIlXmCPFsx1/PtqN1gs2Ic
Fic95XUqe+U9LKxYAnNnpfCmKg15WGDYCZ91cs94zJ+rpEx2ZRLiVG0zTYx5jEGw
saoLovnA+TOHQYHcY4gGUOSEQsAhumAku/K3KCkzEIOnt8K8/Mt6b18uIhb8Du1+
5HV03pMuZuc7Zyg7eF7S+pQ8fPr5C3LLgyay5rcfmTMtD+8Ghq+lqqP1/Q7Uruvg
Fg2ZdsjE4mzQwo50SYZ4xerZZLKQmqBEjKiGsA2bNA8POVD28toETW7k81E7bDi4
Qkd5zPXaqp3S/LEd9bj59SjDq7h2z/AHPSlIhTAyynkkGpvo08Fd9WB+MRAC0Qdr
B3dvB0VfDYmWBVJpa5BN8WRyDqCfvCOnzMgu6rG3/hcgWkJTrd+be6oTAflhIC6I
q3BmcxTNHJNwdfT+WTSFC7a4jCY9JC4bWL3y2+Hkp4Xvi0X2smqOBTXePPVPhFl9
h3tjXldkMuOZFdl2hqeE2J95Mhtsdu218zdBL0V0KFvThp30P3He/JvE45P/K+8E
FXbYptiRyGNZD0OX+7rj
=vmQW
-----END PGP SIGNATURE-----

--Sig_/bAQlOIGFbslgvk+NoaogD0F--
