Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaKJKAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:00:05 -0500
Received: from ozlabs.org ([103.22.144.67]:40125 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaKJJ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:59:59 -0500
Date: Mon, 10 Nov 2014 20:59:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Nov 10
Message-ID: <20141110205945.51af32a6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4xYq5UN6ASMmwyPN9cBQlEo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4xYq5UN6ASMmwyPN9cBQlEo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141106:

New tree: nios2

The slave-dma tree gained a build failure so I used the version from
next-20141106.

The mmc-uh tree gained a conflict against the arm-soc tree.

The tiny tree gained conflicts against Linus' and the net-next trees.

The driver-core tree gained conflicts against the pm, mfd, l2-mtd,
sound-asoc and wireless-next trees.

The tty tree gained conflicts against the tip and tty.current trees.

The usb-gadget tree gained a conflict against the driver-core tree.

The char-misc tree gained a conflict agsinst the staging tree.

The scsi tree gained a build failure so I used teh version from
next-20141106.

The pinctrl tree gained conflicts against the arm-soc and driver-core
trees.

The tiny tree gained a build failure for which I reverted a commit.

The akpm-current tree gained conflicts against the driver-core and tiny
trees and still had its build failures for which I applied two patches.

Non-merge commits (relative to Linus' tree): 5350
 5611 files changed, 164785 insertions(+), 151258 deletions(-)

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

I am currently merging 228 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (0b0c7dbd9864 Merge tag 'driver-core-3.18-rc4' of git=
://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (9ff0bb5ba606 ARM: 8180/1: mm: implement no-highm=
em fast path in kmap_atomic_pfn())
Merging m68k-current/for-linus (f7bbd12a4b7e m68k: Wire up bpf)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/fixes (8a97577a5967 Merge branch 'for-linus' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux)
Merging sparc/master (ab5c780913bc sparc64: Do irq_{enter,exit}() around ge=
neric_smp_call_function*().)
Merging net/master (436c2a5036b6 asix: Do full reset during ax88772_bind)
Merging ipsec/master (d10845fc85b2 Merge branch 'gso_encap_fixes')
Merging sound-current/for-linus (b4565913460c ALSA: hda_intel: Add DeviceID=
s for Sunrise Point-LP)
Merging pci-current/for-linus (32f638fc11db PCI: Don't oops on virtual buse=
s in acpi_pci_get_bridge_handle())
Merging wireless/master (0c9a67c8f1d2 Merge tag 'mac80211-for-john-2014-11-=
04' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (cd3d9ea142c9 tiny: rename EN=
ABLE_DEV_COREDUMP to ALLOW_DEV_COREDUMP)
Merging tty.current/tty-linus (c4dc304677e8 tty: Fix pty master poll() afte=
r slave closes v2)
Merging usb.current/usb-linus (1910195423e7 USB: Update default usb-storage=
 delay_use value in kernel-parameters.txt)
Merging usb-gadget-fixes/fixes (9599815de61d usb: dwc2: gadget: fix enumera=
tion issues)
Merging usb-serial-fixes/usb-linus (e681286de221 USB: opticon: fix non-atom=
ic allocation in write path)
Merging staging.current/staging-linus (bce20b239662 Merge tag 'iio-fixes-fo=
r-3.18b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (0df1f2487d2f Linux 3.18-rc3)
Merging input-current/for-linus (4ab8f7f320f9 Input: alps - ignore potentia=
l bare packets when device is out of sync)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (24c65bc7037e hwrng: pseries - port to new re=
ad API and fix stack corruption)
Merging ide/master (7546e52b5e3d Drivers: ide: Remove typedef atiixp_ide_ti=
ming)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (a87fa1d81a9f of: Fix overflow =
bug in string property parsing functions)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (7069a97a1415 selftests/net: move test out of=
 Makefile into a shell script)
Merging drm-intel-fixes/for-linux-next-fixes (dc54e76d12f2 drm/i915: Fix ob=
j->map_and_fenceable across tiling changes)
Merging asm-generic/master (f3670394c29f Revert "x86/efi: Fixup GOT in all =
boot code paths")
Merging arc/for-next (996bad6cb351 ARC: add power management options)
Merging arm/for-next (9ff0bb5ba606 ARM: 8180/1: mm: implement no-highmem fa=
st path in kmap_atomic_pfn())
Merging arm-perf/for-next/perf (af66abfe2ec8 arm: perf: fold hotplug notifi=
er into arm_pmu)
Merging arm-soc/for-next (4f527b7aa4f9 Merge branch 'next/cleanup' into for=
-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (bb3adf0f4627 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (e173c7d26265 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (15f1f2b1a7a4 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (08f54ce396b7 Merge branches 'heads/defconfig-for-v3.1=
9', 'heads/soc-for-v3.19', 'heads/dt-for-v3.19', 'heads/dt-cleanups-for-v3.=
19' and 'heads/clocks-for-v3.19' into next)
Merging samsung/for-next (9f1d8572e33f Merge branch 'v3.19-next/non-critica=
l-fixes' into for-next)
Merging sunxi/sunxi/for-next (ee2398b7d8ef Merge branch 'sunxi/dt-for-3.19'=
 into sunxi/for-next)
Merging tegra/for-next (dc0609225b1d Merge branch for-3.19/defconfig into f=
or-next)
Merging arm64/for-next/core (302cd37c417d arm64: kvm: eliminate literal poo=
l entries)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0f33be009b89 Linux 3.17-rc6)
Merging m68k/for-next (bcf8eb09b564 nubus: Remove superfluous interrupt dis=
able/restore)
Merging m68knommu/for-next (cac7f2429872 Linux 3.18-rc2)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (a4f174dee4ae microblaze: Wire up bpf syscall)
Merging mips/mips-for-linux-next (f91f9858176d Merge branch '3.18-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (1b9e67a57ac6 nios2: Build infrastructure)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (5e40d331bd72 Merge branch 'next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging powerpc-mpe/next (6609ed14de75 powerpc/gamecube/wii: delete unneede=
d test before of_node_put)
Merging fsl/next (cb0446c1b625 Revert "powerpc/fsl_msi: spread msi ints acr=
oss different MSIRs")
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (eaf785d51dc6 s390/cpum_sf: Remove initialization of =
PMU event index)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (01f7ae056916 arch: tile: kernel: signal.c: Use __copy_=
from/to_user() instead of __get/put_user())
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (66acb0216d5a Merge tag 'xtensa-for-next-20141021-1=
' of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (a43bb39b5c71 btrfs: Fix compile error when CONFIG_SECUR=
ITY is not set.)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (6212096bb0a1 [CIFS] Update modinfo cifs version for =
cifs.ko)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (831115af5ca3 eCryptfs: Remove unnecessary casts when=
 parsing packet lengths)
Merging ext3/for_next (3c9cafe05ff0 fs, jbd: use a more generic hash functi=
on)
Merging ext4/dev (ae9e9c6aeea6 ext4: make ext4_ext_convert_to_initialized()=
 return proper number of blocks)
Merging f2fs/dev (502e9547c8a1 f2fs: do not skip any writes under memory pr=
essure)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (1a8550332a7f GFS2: If we use up our block reservation,=
 request more next time)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (6debb30deb5e NFS: SEEK is an NFS v4.2 feature)
Merging nfsd/nfsd-next (a9d378bc93a7 OOPS)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (002758992693 xfs: track bulkstat progress by agino)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (e6310028a4db Merge tag 'trace-seq-file-cleanup' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into for-ne=
xt)
Merging pci/next (f114040e3ea6 Linux 3.18-rc1)
Merging hid/for-next (db08e0754efb Merge branch 'for-3.19/wacom' into for-n=
ext)
Merging i2c/i2c/for-next (e4df3a0b6228 i2c: core: Dispose OF IRQ mapping at=
 client removal time)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (efe8271c1e1b hwmon: (iio_hwmon) Add suppo=
rt for humidity sensors)
Merging v4l-dvb/master (0da19d032fb1 Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (e9f717fb534c Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (f9ca5ab832e7 libata-scsi: Update SATL for ZAC driv=
es)
Merging pm/linux-next (af497d221353 Merge branch 'pm-clk' into linux-next)
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6ceaf58abe25 Merge branch 'int340x-thermal' of .git i=
nto next)
Merging thermal-soc/next (57c5792054d1 Merge branch 'work-linus' into work-=
next)
Merging ieee1394/for-next (19583ca584d6 Linux 3.16)
Merging dlm/next (c07127b48c63 dlm: fix missing endian conversion of rcom_s=
tatus flags)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (6d80f45f502e dmaengine: xilinx: vdma: icg should be=
 difference of stride and hsize)
$ git reset --hard HEAD^
Merging next-20141106 version of slave-dma
Merging net-next/master (c0560b9c5233 dccp: Convert DCCP_WARN to net_warn_r=
atelimited)
Merging ipsec-next/master (f293a5e33e08 xfrm: add XFRMA_REPLAY_VAL attribut=
e to SA messages)
Merging wireless-next/master (bf515fb11ab5 Merge tag 'mac80211-next-for-joh=
n-2014-11-04' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac802=
11-next)
Merging bluetooth/master (f7cb96f105fb mac802154: protect address changes v=
ia ioctl)
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (89cf38dd536a mtd: cfi_cmdset_0001.c: fix resume for LH2=
8F640BF chips)
Merging l2-mtd/master (096916610f41 fsl_ifc: Support all 8 IFC chip selects)
Merging crypto/master (49783d0f5421 crypto: caam - fix error reporting)
Merging drm/drm-next (041df3573d0c Merge tag 'drm-intel-next-2014-10-24' of=
 git://anongit.freedesktop.org/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
Merging drm-panel/drm/panel/for-next (d85a1609e62c drm/panel: s6e8aa0: Fix =
build warnings on 64-bit)
Merging drm-intel/for-linux-next (0b5492d6b532 drm/i915: Add gen to the gpu=
 hang ecode)
Merging drm-tegra/drm/tegra/for-next (8ed05f485498 drm/tegra: Depend on COM=
MON_CLK)
Merging drm-misc/topic/core-stuff (babc94936b7a drm/edid: add #defines and =
helpers for ELD)
Merging sound/for-next (d4b8fc66f770 ALSA: usb-audio: Allow multiple entrie=
s for the same iface in composite quirk)
Merging sound-asoc/for-next (bf70486e96a2 Merge remote-tracking branch 'aso=
c/topic/wm971x' into asoc-next)
Merging modules/modules-next (d3051b489aa8 modules, lock around setting of =
MODULE_STATE_UNFORMED)
Merging virtio/virtio-next (1bbc26062754 virtio-rng: refactor probe error h=
andling)
Merging input/next (02b6a58b83b2 Input: touchscreen - use __maybe_unused in=
stead of ifdef around suspend/resume)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (0f6ea1801d84 Merge branch 'for-3.19/drivers' into f=
or-next)
Merging device-mapper/for-next (a501e2c1b95f dm bio prison: introduce suppo=
rt for locking ranges of blocks)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (5f4e20567705 mmc: sdhci: Add HS400 support to SDHCI dr=
iver)
CONFLICT (modify/delete): arch/arm/mach-at91/at91sam9g45_devices.c deleted =
in HEAD and modified in mmc-uh/next. Version mmc-uh/next of arch/arm/mach-a=
t91/at91sam9g45_devices.c left in tree.
$ git rm -f arch/arm/mach-at91/at91sam9g45_devices.c
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (b395f75eabb3 lib/raid6: Add log level to printks)
Merging mfd/for-mfd-next (4a288f1edf33 mfd: tc6393xb: Fail ohci suspend if =
full state restore is required)
Merging backlight/for-backlight-next (0df1f2487d2f Linux 3.18-rc3)
Merging battery/master (cdaf3e15385d power: charger-manager: Fix accessing =
invalidated power supply after charger unbind)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (816764859a53 m501fb: don't return zero on failu=
re path in sm501fb_probe())
Merging regulator/for-next (030848b97658 Merge remote-tracking branches 're=
gulator/topic/s2mpa01', 'regulator/topic/s2mps11', 'regulator/topic/sky8145=
2', 'regulator/topic/stub' and 'regulator/topic/suspend' into regulator-nex=
t)
Merging security/next (594081ee7145 integrity: do zero padding of the key i=
d)
Merging integrity/next (c2426d2ad502 ima: added support for new kernel cmdl=
ine parameter ima_template_fmt)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8ae1a57f54af watchdog: s3c2410_wdt: Fix the mask b=
it offset for Exynos7)
CONFLICT (content): Merge conflict in drivers/watchdog/s3c2410_wdt.c
Merging iommu/next (5988c921b747 Merge branches 'arm/omap', 'arm/msm', 'arm=
/rockchip' and 'arm/renesas' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (93899a679fd6 vfio-pci: Fix remove path locking)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (6c8030e8782f Merge branch 'docs-3.19' into docs-=
next)
Merging trivial/for-next (be278e980d95 clocksource: Fix 'clcoksource' typo =
in comment)
Merging audit/next (915f389d9c52 audit: add Paul Moore to the MAINTAINERS e=
ntry)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (43c0767e17ac of/platform: Move platform=
 devices under /sys/devices/platform)
Merging dt-rh/for-next (d22e9131187d of: add vendor prefix for Chipidea)
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (bd65fbdc290a Merge remote-tracking branches 'spi/topi=
c/atmel', 'spi/topic/dw', 'spi/topic/fsl-dspi', 'spi/topic/gpio' and 'spi/t=
opic/spidev' into spi-next)
Merging tip/auto-latest (a22ffa49e2ff Merge branch 'x86/vdso')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (d0585cd815fa sb_edac: Claim a different PCI device)
Merging edac-amd/for-next (f5b10c45ef80 amd64_edac: Build module on x86-32)
Merging irqchip/irqchip/for-next (317dfacb3af2 Merge branch 'irqchip/mvebu'=
 into irqchip/for-next)
Merging tiny/tiny/next (5aa428555cbf Merge branch 'tiny/tlb' into tiny/next)
CONFLICT (content): Merge conflict in net/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
Merging ftrace/for-next (70c738a64478 Merge branch 'trace/ftrace/testing' i=
nto trace/for-next)
Merging rcu/rcu/next (f120000b06ab Merge branch 'torture.2014.10.28d' into =
HEAD)
CONFLICT (content): Merge conflict in drivers/md/dm.c
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (ce1a5e60a62f kvm: x86: add trace event for pvclock =
updates)
Merging kvm-arm/next (f62c95fd4041 Merge tag 'kvm-s390-next-20141028' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD)
Merging kvm-ppc/kvm-ppc-next (8d0eff638564 KVM: PPC: Pass enum to kvmppc_ge=
t_last_inst)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (63401a5dca18 Merge branch 'hypercall_cache_flus=
h_v5' into xentip-linux-next-7)
Merging percpu/for-next (56e4dea81a55 percpu: Convert remaining __get_cpu_v=
ar uses in 3.18-rcX)
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (a4c724d0723b platform: hp_accel: add a i8042 =
filter to remove HPQ6000 data from kb bus stream)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (46f6c620e8a1 Merge remote-tracking branches 'regma=
p/topic/cache' and 'regmap/topic/headers' into regmap-next)
Merging hsi/for-next (a26a42508157 HSI: remove deprecated IRQF_DISABLED)
Merging leds/for-next (33faa112cef4 leds: implement sysfs interface locking=
 mechanism)
Merging ipmi/for-next (ef4a48c51321 Merge tag 'locks-v3.18-1' of git://git.=
samba.org/jlayton/linux)
Merging driver-core/driver-core-next (1f648f88cea7 coccinelle: api: add spa=
tch to prevent unnecessary .owner)
CONFLICT (content): Merge conflict in sound/soc/intel/sst-haswell-pcm.c
CONFLICT (modify/delete): drivers/net/ieee802154/fakehard.c deleted in HEAD=
 and modified in driver-core/driver-core-next. Version driver-core/driver-c=
ore-next of drivers/net/ieee802154/fakehard.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/devices/docg3.c
CONFLICT (content): Merge conflRecorded preimage for 'drivers/input/keyboar=
d/gpio_keys_polled.c'
CONFLICT (content): Merge conflict in drivers/leds/leds-gpio.c
CONFLICT (content): Merge conflict in drivers/input/keyboard/gpio_keys_poll=
ed.c
$ git rm -f drivers/net/ieee802154/fakehard.c
Merging tty/tty-next (98267d33e2da serial: pl011: Add device tree support f=
or RX DMA polling)
CONFLICT (content): Merge conflict in drivers/tty/serial/8250/8250_mtk.c
CONFLICT (content): Merge conflict in drivers/tty/n_tty.c
Merging usb/usb-next (35a27eab6f94 usb: Remove __init from early_dbgp_init(=
) prototype)
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
Merging usb-gadget/next (c3761a79c14d usb: dwc2: allow dwc2 to get built wh=
en USB_GADGET=3Dm)
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/otg_fsm.c
Merging usb-serial/usb-next (679315e5fae1 USB: serial: add Google simple se=
rial SubClass support)
Merging staging/staging-next (d48037f9169f staging: rtl8188eu: unneeded NUL=
L check)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_imon.c
CONFLICT (modify/delete): drivers/staging/media/lirc/lirc_igorplugusb.c del=
eted in HEAD and modified in staging/staging-next. Version staging/staging-=
next of drivers/staging/media/lirc/lirc_igorplugusb.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/n=
amei.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/l=
lite_lib.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/f=
ile.c
$ git rm -f drivers/staging/media/lirc/lirc_igorplugusb.c
Merging char-misc/char-misc-next (184901a06a36 ARM: removing support for et=
b/etm in "arch/arm/kernel/")
CONFLICT (content): Merge conflict in drivers/Makefile
Merging cgroup/for-next (cea74465e27b cpuset: lock vs unlock typo)
Merging scsi/for-next (ed312a9192b6 bnx2fc: fix an error code in _bnx2fc_cr=
eate())
$ git reset --hard HEAD^
Merging next-20141106 version of scsi
Merging target-updates/for-next (cac7f2429872 Linux 3.18-rc2)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (3cbfc571a0e5 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-rockchip.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/ste-nomadik-stn8815=
.dtsi
Applying: pinctrl: nomadik: fix up for binding changes
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (2071d0968e56 Documentation: gpio: guidelines for bin=
dings)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (e2e08970100d pwm: atmel: Fix calculation of prescale =
value)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (d832d743385d ktest: Don't bother with bisect good o=
r bad on replay)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (98d147f50eb0 clk: pxa clocks build system fix)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (d3785cf42979 Merge ../aio-fixes)
Merging llvmlinux/for-next (ec25a590c29c arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
Merging kselftest/next (49296470830a selftests/timers: change test to use k=
sft framework)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
$ git am -3 ../patches/0001-Revert-kernel-time-Compile-out-NTP-support.patch
Applying: Revert "kernel: time: Compile out NTP support"
Merging akpm-current/current (f87854f250cb ipc/shm.c: fix overly aggressive=
 shmdt() when calls span multiple segments)
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/storage/debug.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-omap.c
Applying: mm: convert i_mmap_mutex to rwsem fix
Applying: mm/slab: Always predeclare slab_free()
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: slab: fix cpuset check in fallback_alloc
Applying: slub: fix cpuset check in get_any_partial
Applying: mm/cma: make kmemleak ignore CMA regions
Applying: mm: cma: split cma-reserved in dmesg log
Applying: fs: proc: include cma info in proc/meminfo
Applying: lib/show_mem.c: adds cma reserved information
Applying: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (01d8d48e4b2f mm: add strictlimit knob)

--Sig_/4xYq5UN6ASMmwyPN9cBQlEo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYIycAAoJEMDTa8Ir7ZwVAVQQAICSbiYJ92h7IVQ9VOpeVw/D
sQdUraOBA07plV/DWDoHpOMDXxWXxFEVL6PAhu2hyW7sSRtmB2NyzZddf27Av6SB
/NYossC9IsBirI8f8Yd0r2xCSSDQX4mrcu2fK7J9nis3NHqfukiZ6qgySCzDWD2K
dGjTykR4Q9di3Duz/a7pbGF6W9SPdGXX6OazyRu4o3LkBJYRKw8OAt2uCXaUzr2p
lMuNREFd3xJHOJYFpSvHiBiJ2pkRcuHSvPsoTSHApPiGsdXKOHC0RQi6kS+TAE+v
mNyoQ9aD8YR1bKQVQ75pLf0gaP3co6hV9QORjpkHrowyLyDtwMBZnD66MQfQIr9q
0ZxOJc/gvdJB5UTWVb8UNL2nplCn+ihdf8SLdCgXo/I542GWAZMCUr4o4gYI2y3Y
+8rk4db53XUGgTCYbybq81Ek1zd/must22Qe3HnFVdMzE+uNeDnlAoCsLyIXnJuG
ulSmpt2eDBVPkyx+CjHurOpNCBt7Yi9TVX01bi6KU7Zoo0PC0HLPPMFEGXgLRDRX
6bcBYPOdQDJMKY+ooFH7OBtoYFURZZGPEuuxfxj+8STrLP1AQpUs+b0SACudT3Mv
9kXFjImMS+h7fXjyyDKfM2OsE2TSj6VgNihNdaNhixW5S9DG2dczfC5/U+a3kKhN
72O2FCw6q6KPiRQe8t+m
=CXH/
-----END PGP SIGNATURE-----

--Sig_/4xYq5UN6ASMmwyPN9cBQlEo--
