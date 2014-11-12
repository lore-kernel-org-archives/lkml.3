Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKLGzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:55:47 -0500
Received: from ozlabs.org ([103.22.144.67]:59343 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaKLGzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:55:42 -0500
Date: Wed, 12 Nov 2014 17:55:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Nov 12
Message-ID: <20141112175533.2df3a9d6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g21D=/My6Qi_PN9F8AtxyDC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g21D=/My6Qi_PN9F8AtxyDC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141111:

The slave-dma tree lost its build failure.

The block tree lost its build failure.

The mfd tree lost its build failure.

The driver-core tree gained a conflict against the hwmon-staging tree.

The akpm-current tree still had its build failures for which I applied
two patches.

Non-merge commits (relative to Linus' tree): 5824
 6102 files changed, 186257 insertions(+), 159975 deletions(-)

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
Merging origin/master (206c5f60a3d9 Linux 3.18-rc4)
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
Merging net/master (48eb5b9c3dd2 ixgbe: phy: fix uninitialized status in ix=
gbe_setup_phy_link_tnx)
Merging ipsec/master (d10845fc85b2 Merge branch 'gso_encap_fixes')
Merging sound-current/for-linus (b4565913460c ALSA: hda_intel: Add DeviceID=
s for Sunrise Point-LP)
Merging pci-current/for-linus (32f638fc11db PCI: Don't oops on virtual buse=
s in acpi_pci_get_bridge_handle())
Merging wireless/master (4e6ce4dc7ce7 ath9k: Fix RTC_DERIVED_CLK usage)
Merging driver-core.current/driver-core-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging tty.current/tty-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging usb.current/usb-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging usb-gadget-fixes/fixes (520fe7633692 usb: dwc3: ep0: fix for dead c=
ode)
Merging usb-serial-fixes/usb-linus (ffcfe30ebd8d USB: serial: cp210x: add I=
Ds for CEL MeshConnect USB Stick)
Merging staging.current/staging-linus (206c5f60a3d9 Linux 3.18-rc4)
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
Merging rr-fixes/fixes (3438cf549d2f param: fix crash on bad kernel argumen=
ts)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (7069a97a1415 selftests/net: move test out of=
 Makefile into a shell script)
Merging drm-intel-fixes/for-linux-next-fixes (e9d784d535e4 drm/i915: Fix ob=
j->map_and_fenceable across tiling changes)
Merging asm-generic/master (f3670394c29f Revert "x86/efi: Fixup GOT in all =
boot code paths")
Merging arc/for-next (996bad6cb351 ARC: add power management options)
Merging arm/for-next (9ff0bb5ba606 ARM: 8180/1: mm: implement no-highmem fa=
st path in kmap_atomic_pfn())
Merging arm-perf/for-next/perf (af66abfe2ec8 arm: perf: fold hotplug notifi=
er into arm_pmu)
Merging arm-soc/for-next (bfcf8f9d0829 Merge branch 'next/soc' into for-nex=
t)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (bb3adf0f4627 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (e2e0f84f098d Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (15f1f2b1a7a4 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (701ad723fba9 Merge branch 'soc-for-v3.19' into next)
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
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (93afdb4c3cce m68knommu: fix irq handler types i=
n 68360/commproc.c)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (a4f174dee4ae microblaze: Wire up bpf syscall)
Merging mips/mips-for-linux-next (10103c26edd6 Merge branch '3.18-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (1b9e67a57ac6 nios2: Build infrastructure)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (d8f5457ab939 parisc: Avoid using CONFIG_64BIT i=
n userspace exported headers)
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
Merging tile/master (f47436734dc8 tile: Use the more common pr_warn instead=
 of pr_warning)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (c0d7aa07504a Merge tag 'xtensa-for-next-20141021-2=
' of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (a43bb39b5c71 btrfs: Fix compile error when CONFIG_SECUR=
ITY is not set.)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (a8a7a807cd94 Update MAINTAINERS entry)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (831115af5ca3 eCryptfs: Remove unnecessary casts when=
 parsing packet lengths)
Merging ext3/for_next (75cbe701a425 vfs: Remove i_dquot field from inode)
Merging ext4/dev (ae9e9c6aeea6 ext4: make ext4_ext_convert_to_initialized()=
 return proper number of blocks)
Merging f2fs/dev (b7e1d800031c f2fs: implement -o dirsync)
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
Merging nfsd/nfsd-next (f4d9fdee07fd OOPS)
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
Merging hid/for-next (f6f02b61f7ae Merge branch 'for-3.19/lenovo' into for-=
next)
Merging i2c/i2c/for-next (e4df3a0b6228 i2c: core: Dispose OF IRQ mapping at=
 client removal time)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (e349d9d5b3f9 hwmon: (ibmpowernv) Use plat=
form 'id_table' to probe the device)
Merging v4l-dvb/master (0da19d032fb1 Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (e9f717fb534c Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (f9ca5ab832e7 libata-scsi: Update SATL for ZAC driv=
es)
Merging pm/linux-next (8ee288b0fe61 Merge branch 'pm-cpufreq-next' into lin=
ux-next)
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6ceaf58abe25 Merge branch 'int340x-thermal' of .git i=
nto next)
Merging thermal-soc/next (208a97042d66 Merge branch 'work-fixes' into work-=
next)
Merging ieee1394/for-next (19583ca584d6 Linux 3.16)
Merging dlm/next (c07127b48c63 dlm: fix missing endian conversion of rcom_s=
tatus flags)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (9dd9c4927ee1 dma: imx-sdma: remove incorrect __init=
 annotation from sdma_init())
Merging net-next/master (09626e9d1533 net: kill netif_copy_real_num_queues(=
))
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/ixgbe/ixgb=
e_phy.c
Merging ipsec-next/master (f293a5e33e08 xfrm: add XFRMA_REPLAY_VAL attribut=
e to SA messages)
Merging wireless-next/master (4eed83a25225 mwifiex: simplify ad hoc join ca=
pability info)
Merging bluetooth/master (4e7902267708 Bluetooth: 6lowpan: Remove unnecessa=
ry RCU callback)
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (89cf38dd536a mtd: cfi_cmdset_0001.c: fix resume for LH2=
8F640BF chips)
Merging l2-mtd/master (096916610f41 fsl_ifc: Support all 8 IFC chip selects)
Merging crypto/master (49783d0f5421 crypto: caam - fix error reporting)
Merging drm/drm-next (cc7096fb6d1d drm/mode: document path property and fun=
ction to set it. (v1.1))
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
Merging drm-panel/drm/panel/for-next (d85a1609e62c drm/panel: s6e8aa0: Fix =
build warnings on 64-bit)
Merging drm-intel/for-linux-next (477f799e966d drm/i915: Plug memory leak i=
n intel_shared_dpll_start_config())
Merging drm-tegra/drm/tegra/for-next (8ed05f485498 drm/tegra: Depend on COM=
MON_CLK)
Merging drm-misc/topic/core-stuff (554c53a3f02d drm/irq: BUG_ON() -> WARN_O=
N())
Merging sound/for-next (c63fcb9b6777 ALSA: usb-audio: Add duplex mode for D=
igidesign Mbox 1 and enable mixer)
Merging sound-asoc/for-next (6bf8c152c7ce Merge remote-tracking branch 'aso=
c/topic/wm971x' into asoc-next)
Merging modules/modules-next (18eb74fa9416 params: cleanup sysfs allocation)
Merging virtio/virtio-next (5a10b7dbf904 virtio_balloon: free some memory f=
rom balloon on OOM)
Merging input/next (02b6a58b83b2 Input: touchscreen - use __maybe_unused in=
stead of ifdef around suspend/resume)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (7da8ddee3906 Merge branch 'for-3.19/core' into for-=
next)
Merging device-mapper/for-next (419a2ea07418 dm thin: suspend/resume active=
 thin devices when reloading thin-pool)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (d5b63b50a8c8 mmc: core: consistent handling of initial=
 values)
CONFLICT (modify/delete): arch/arm/mach-at91/at91sam9g45_devices.c deleted =
in HEAD and modified in mmc-uh/next. Version mmc-uh/next of arch/arm/mach-a=
t91/at91sam9g45_devices.c left in tree.
$ git rm -f arch/arm/mach-at91/at91sam9g45_devices.c
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (b395f75eabb3 lib/raid6: Add log level to printks)
Merging mfd/for-mfd-next (0cc218060a5f mfd: tc6393xb: Prepare/unprepare clo=
cks)
Merging backlight/for-backlight-next (3e0e9ce4ae9b backlight: Extend of_fin=
d_backlight_by_node stub-check to modules)
Merging battery/master (cdaf3e15385d power: charger-manager: Fix accessing =
invalidated power supply after charger unbind)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (816764859a53 m501fb: don't return zero on failu=
re path in sm501fb_probe())
Merging regulator/for-next (745dcd38d3fa Merge remote-tracking branches 're=
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
Merging spi/for-next (f9bb3ffb11fa Merge remote-tracking branch 'spi/topic/=
spidev' into spi-next)
Merging tip/auto-latest (caf0fea9e728 Merge branch 'x86/vdso')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (d0585cd815fa sb_edac: Claim a different PCI device)
Merging edac-amd/for-next (19ca5a3cc425 EDAC, pci_sysfs: remove unneccessar=
y ifdef around entire file)
Merging irqchip/irqchip/for-next (0f2f5bc596c6 Merge branch 'irqchip/mvebu'=
 into irqchip/for-next)
Merging tiny/tiny/next (768d6dbe73e5 Merge branch 'tiny/tlb' into tiny/next)
CONFLICT (content): Merge conflict in net/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
Merging ftrace/for-next (26488b372327 tracing: Add entry->next_cpu to trace=
_ctxwake_bin())
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
Merging drivers-x86/for-next (0cdbcd6d3ebe platform: hp_accel: Add SERIO_I8=
042 as a dependency since it now includes i8042.h/serio.h)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (46f6c620e8a1 Merge remote-tracking branches 'regma=
p/topic/cache' and 'regmap/topic/headers' into regmap-next)
Merging hsi/for-next (a26a42508157 HSI: remove deprecated IRQF_DISABLED)
Merging leds/for-next (33faa112cef4 leds: implement sysfs interface locking=
 mechanism)
Merging ipmi/for-next (62dfe48615c7 Change ACPI IPMI support to "default y")
Merging driver-core/driver-core-next (6386a15c445c Revert "core: platform: =
add warning if driver has no owner")
CONFLICT (content): Merge conflict in sound/soc/intel/sst-haswell-pcm.c
CONFLICT (modify/delete): drivers/net/ieee802154/fakehard.c deleted in HEAD=
 and modified in driver-core/driver-core-next. Version driver-core/driver-c=
ore-next of drivers/net/ieee802154/fakehard.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/devices/docg3.c
CONFLICT (content): Merge conflict in drivers/mfd/syscon.c
CONFLICT (content): Merge conflict in drivers/leds/leds-gpio.c
CONFLICT (content): Merge conflict in drivers/input/keyboard/gpio_keys_poll=
ed.c
CONFLICT (content): Merge conflict in drivers/hwmon/ibmpowernv.c
CONFLICT (content): Merge conflict in drivers/base/Makefile
$ git rm -f drivers/net/ieee802154/fakehard.c
Merging tty/tty-next (e4c787dac21e Revert "serial: of-serial: fetch line nu=
mber from DT")
CONFLICT (content): Merge conflict in drivers/tty/n_tty.c
Merging usb/usb-next (69b7290e51e5 Merge 3.18-rc4 into usb-next.)
Merging usb-gadget/next (7e1bbeb42927 usb: host: ohci: omap: fix build brea=
kage)
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/dwc3/ep0.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/otg_fsm.c
Merging usb-serial/usb-next (679315e5fae1 USB: serial: add Google simple se=
rial SubClass support)
Merging staging/staging-next (cc03f9bc2650 Merge 3.18-rc4 into staging-next)
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
Merging scsi/for-next (304fdeea0baf Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.19' into for-next)
Merging target-updates/for-next (cac7f2429872 Linux 3.18-rc2)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (7bc043cd6861 Merge branch 'devel' into for-next)
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
Merging akpm-current/current (f87854f250cb ipc/shm.c: fix overly aggressive=
 shmdt() when calls span multiple segments)
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in fs/ocfs2/inode.h
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
Merging akpm/master (618c4de77b17 mm: add strictlimit knob)

--Sig_/g21D=/My6Qi_PN9F8AtxyDC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYwRqAAoJEMDTa8Ir7ZwVWuYP/iWPIQWrJaTski6vNgcKudxf
7uUITM5ChgHoH8pBwmsPO/AwIXL30qJ7EsO2q662FmS0L1GIXZShc7b57pAxTDsu
stVNYEeJOAVF97SL3aWMGpy7i4Gi6SgZ8CNCLhoaGo/mT3jQKKA06rvEH/hyDDaw
hRb2ZzkuASaP7Vndj3CLvl2uufkjvTFfIh+uQJBEwixKissq9ZZ7lr5bPpMz83VB
jgaFuhLxkA3m2cQRB9zotytdtHBPtWDp9anx7TLCkftcPITyvbFKSTTj7SPy616P
EbLXZHWiSvylzeBB4/I21aq0QsjKvPIQpiYJeFe2U20RbZJMkYAAQCwAVJZQkfhm
wDCM3vBwgDY7DfarBXfy5vlL8xmsML8Jcl/r4JO7OcevLTWzxpg6WmTzZVr4tx5r
gxIqF+NUZ/vv+U9NcAZZmJN52Dxb9hJM5/V9lcv+T6X5UOp44u1mWwpJtNCULaD4
/TwY4Bwk7H8jvoNkif1x+hOQj32VhIl8zVI3W4X5rTxkhltaB+m+txdtIbupBJPi
42NX69/fTjujQKwkl7J1pt1bH7c7i7xMwMJcHwFiBRkgvqCp8wklpGIwZRDVEtKF
f4d3ChikAMvp+UTE3WOiraYUSzUG9lvLrc2wIyYDiE7fwOwQCLFu3HCw9OfdgQOe
B2kTWMQ/B38HZJdExEur
=yDjT
-----END PGP SIGNATURE-----

--Sig_/g21D=/My6Qi_PN9F8AtxyDC--
