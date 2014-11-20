Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbaKTHrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:47:09 -0500
Received: from ozlabs.org ([103.22.144.67]:35265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664AbaKTHrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:47:04 -0500
Date: Thu, 20 Nov 2014 18:46:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Nov 20
Message-ID: <20141120184653.7c7764ac@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xCbkkyMois44Y56rcZ2Z31J"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xCbkkyMois44Y56rcZ2Z31J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141119:

The asm-generic tree lost its build failure.

The omap_dss2 tree still had its build failure for which I applied a patch.

The devicetree tree gained a conflict against the devicetree-current tree.

Non-merge commits (relative to Linus' tree): 7146
 7140 files changed, 242712 insertions(+), 180038 deletions(-)

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

I am currently merging 229 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (fc14f9c1272f Linux 3.18-rc5)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (08b964ff3c51 ARM: 8198/1: make kuser helpers dep=
end on MMU)
Merging m68k-current/for-linus (f7bbd12a4b7e m68k: Wire up bpf)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/fixes (d7ce4377494a powerpc/fsl_msi: mark the msi=
 cascade handler IRQF_NO_THREAD)
Merging sparc/master (fc14f9c1272f Linux 3.18-rc5)
Merging net/master (ee7255ada313 cxgb4i : Don't block unload/cxgb4 unload w=
hen remote closes TCP connection)
Merging ipsec/master (d10845fc85b2 Merge branch 'gso_encap_fixes')
Merging sound-current/for-linus (6676f3081f7e ALSA: hda - fix the mic mute =
led problem for Latitude E5550)
Merging pci-current/for-linus (6aa87f0986ed PCI: Support 64-bit bridge wind=
ows if we have 64-bit dma_addr_t)
Merging wireless/master (6158fb37d1b0 Merge tag 'mac80211-for-john-2014-11-=
18' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging tty.current/tty-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging usb.current/usb-linus (2aea83a484fc Merge tag 'fixes-for-v3.18-rc5'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging usb-gadget-fixes/fixes (520fe7633692 usb: dwc3: ep0: fix for dead c=
ode)
Merging usb-serial-fixes/usb-linus (75bcbf29c284 USB: ssu100: fix overrun-e=
rror reporting)
Merging staging.current/staging-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging char-misc.current/char-misc-linus (0df1f2487d2f Linux 3.18-rc3)
Merging input-current/for-linus (bce4f9e764c3 Input: synaptics - adjust min=
/max on Thinkpad E540)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (24c65bc7037e hwrng: pseries - port to new re=
ad API and fix stack corruption)
Merging ide/master (7546e52b5e3d Drivers: ide: Remove typedef atiixp_ide_ti=
ming)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (817d2001c709 of/selftest: Fix =
testing when /aliases is missing)
Merging rr-fixes/fixes (3438cf549d2f param: fix crash on bad kernel argumen=
ts)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (884716497d4c selftests/timers: change test t=
o use ksft framework)
Merging drm-intel-fixes/for-linux-next-fixes (0485c9dc24ec drm/i915: Kick f=
bdev before vgacon)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (996bad6cb351 ARC: add power management options)
Merging arm/for-next (a228da3a9fbf Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (af66abfe2ec8 arm: perf: fold hotplug notifi=
er into arm_pmu)
Merging arm-soc/for-next (6845c42f07f0 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (6298ed17a404 ARM: bcm2835: Add device tree for Ra=
spberry Pi model B+)
Merging berlin/berlin/for-next (91bcb334bf0b Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (754827b37297 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (15f1f2b1a7a4 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (2ed235fdf545 Merge branches 'heads/dt-cleanups-for-v3=
.19', 'heads/dt-clocksource-for-v3.19', 'heads/dt-fixes-for-v3.18', 'heads/=
kconfig-cleanups-for-v3.19', 'heads/clock-fixes-for-v3.18' and 'heads/runti=
me-pm-for-v3.19' into next)
Merging samsung/for-next (ff0391a59e6e Merge branch 'v3.19-samsung-defconfi=
g' into for-next)
Merging sunxi/sunxi/for-next (c600b1e73339 Merge branch 'sunxi/dt-for-3.19'=
 into sunxi/for-next)
Merging tegra/for-next (727b4fbb8f5f Merge branch for-3.19/soc into for-nex=
t)
Merging arm64/for-next/core (d6c763afab14 arm64/mm: Remove hack in mmap ran=
domize layout)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (069fb0b63722 syslog: Provide stub check_syslog_permissio=
ns)
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (93afdb4c3cce m68knommu: fix irq handler types i=
n 68360/commproc.c)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (a4f174dee4ae microblaze: Wire up bpf syscall)
Merging mips/mips-for-linux-next (298395f5f43d Merge branch '3.18-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (1f29527ec5c5 nios2: fix error handling of irq_of_=
parse_and_map)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (56c381f93d57 Merge branch 'for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging powerpc-mpe/next (16b1d26e77b1 rtc/tpo: Driver to support rtc and w=
akeup on PowerNV platform)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (4eafad7febd4 s390/kernel: add system calls for PCI m=
emory access)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (c47b15c4928c arch/tile: update MAINTAINERS email to EZ=
chip)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (c0d7aa07504a Merge tag 'xtensa-for-next-20141021-2=
' of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (a43bb39b5c71 btrfs: Fix compile error when CONFIG_SECUR=
ITY is not set.)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
Merging cifs/for-next (a8a7a807cd94 Update MAINTAINERS entry)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (831115af5ca3 eCryptfs: Remove unnecessary casts when=
 parsing packet lengths)
Merging ext3/for_next (75cbe701a425 vfs: Remove i_dquot field from inode)
Merging ext4/dev (ae9e9c6aeea6 ext4: make ext4_ext_convert_to_initialized()=
 return proper number of blocks)
Merging f2fs/dev (92dffd01790a f2fs: convert inline_data when i_size become=
s large)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (30badc954349 GFS2: Deletion of unnecessary checks befo=
re two function calls)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (fc14f9c1272f Linux 3.18-rc5)
Merging nfsd/nfsd-next (d395ac8becda sunrpc: release svc_pool_map reference=
 when serv allocation fails)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (0414b910ed35 ovl: support multiple lower =
layers)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (002758992693 xfs: track bulkstat progress by agino)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (8ce74dd60578 Merge tag 'trace-seq-file-cleanup' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into for-ne=
xt)
Merging pci/next (df08077b41ac Merge branch 'pci/msi' into next)
Merging hid/for-next (3bb5af23ef16 Merge branch 'for-3.19/elan' into for-ne=
xt)
Merging i2c/i2c/for-next (30021e3707a7 i2c: add support for Amlogic Meson I=
2C controller)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (e46066eae1df hwmon: Driver for Nuvoton NC=
T7802Y)
Merging v4l-dvb/master (117806e5eac9 Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (e9f717fb534c Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (598e9a9005ef sata_rcar: Document deprecated "renes=
as,rcar-sata")
Merging pm/linux-next (7f187f2db3f9 Merge branch 'pm-cpufreq' into linux-ne=
xt)
Merging idle/next (a8b65b07d753 tools/power turbostat: decode MSR_*_PERF_LI=
MIT_REASONS)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6ceaf58abe25 Merge branch 'int340x-thermal' of .git i=
nto next)
Merging thermal-soc/next (4027494124fd thermal: exynos: remove exynos_tmu_d=
ata.h include)
Merging ieee1394/for-next (51b04d59c274 firewire: ohci: replace vm_map_ram(=
) with vmap())
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (9d3cc3e58429 Merge branch 'topic/at_xdmac' into nex=
t)
Merging net-next/master (daaf427c6ab3 bpf: fix arraymap NULL deref and miss=
ing overflow and zero size checks)
CONFLICT (modify/delete): drivers/net/ieee802154/fakehard.c deleted in net-=
next/master and modified in HEAD. Version HEAD of drivers/net/ieee802154/fa=
kehard.c left in tree.
$ git rm -f drivers/net/ieee802154/fakehard.c
Applying: openvswitch: fix up for OVS_NLERR API change
Merging ipsec-next/master (12bfa8bdba05 xfrm: Use __xfrm_policy_link in xfr=
m_policy_insert)
Merging wireless-next/master (b4c1b7082372 ath9k_common: make sure DEBUG_FS=
 and RELAY enabled)
Merging bluetooth/master (4c79e1dd3e12 Bluetooth: btmrvl: update hs_state i=
n interrupt handler)
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (89cf38dd536a mtd: cfi_cmdset_0001.c: fix resume for LH2=
8F640BF chips)
Merging l2-mtd/master (096916610f41 fsl_ifc: Support all 8 IFC chip selects)
Merging crypto/master (aa408d601977 crypto: qat - Use memzero_explicit)
Merging drm/drm-next (d0d6c524bf1d Merge branch 'msm-next' of git://people.=
freedesktop.org/~robclark/linux into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/tegra/dc.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
Merging drm-panel/drm/panel/for-next (1976dbca047e drm/panel: Add Sharp LQ1=
01R1SX01 support)
Merging drm-intel/for-linux-next (511394ae358f drm/i915: Can i915_gem_init_=
ioctl)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (dbe03efaa34d drm/atomic_helper: Make it =
clear that commit_planes gets the old state)
Merging sound/for-next (5f217f905bc5 ALSA: firewire-lib: fix kerneldoc erro=
rs)
Merging sound-asoc/for-next (d50f83b3b545 Merge remote-tracking branches 'a=
soc/topic/wm8731', 'asoc/topic/wm8737', 'asoc/topic/wm8961', 'asoc/topic/wm=
8962' and 'asoc/topic/wm8995' into asoc-next)
Merging modules/modules-next (18eb74fa9416 params: cleanup sysfs allocation)
Merging virtio/virtio-next (5a10b7dbf904 virtio_balloon: free some memory f=
rom balloon on OOM)
Merging input/next (5447326ff7e4 Input: atkbd - correct MSC_SCAN events for=
 force_release keys)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (887022e8bd51 Merge branch 'for-3.19/drivers' into f=
or-next)
Merging device-mapper/for-next (583024d248f4 dm thin: suspend/resume active=
 thin devices when reloading thin-pool)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (925081aebfb9 mmc: dw_mmc: Add support for IMG Pistachi=
o)
CONFLICT (modify/delete): arch/arm/mach-at91/at91sam9g45_devices.c deleted =
in HEAD and modified in mmc-uh/next. Version mmc-uh/next of arch/arm/mach-a=
t91/at91sam9g45_devices.c left in tree.
$ git rm -f arch/arm/mach-at91/at91sam9g45_devices.c
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (206c5f60a3d9 Linux 3.18-rc4)
Merging mfd/for-mfd-next (0cc218060a5f mfd: tc6393xb: Prepare/unprepare clo=
cks)
CONFLICT (content): Merge conflict in drivers/mfd/viperboard.c
Merging backlight/for-backlight-next (3e0e9ce4ae9b backlight: Extend of_fin=
d_backlight_by_node stub-check to modules)
Merging battery/master (99a79565e6db power: ds2782_battery: Simplify the PM=
 hooks)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (c2acaf299df1 Merge branch '3.19/simplefb' into =
for-next)
CONFLICT (content): Merge conflict in include/linux/of.h
Applying: simplefb: make it depend on CONFIG_COMMON_CLK
Merging regulator/for-next (08e962ea7ee7 Merge remote-tracking branch 'regu=
lator/topic/suspend' into regulator-next)
Merging security/next (a6aacbde406e Merge branch 'next' of git://git.kernel=
.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next)
Merging integrity/next (6fb5032ebb1c VFS: refactor vfs_read())
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8ae1a57f54af watchdog: s3c2410_wdt: Fix the mask b=
it offset for Exynos7)
CONFLICT (content): Merge conflict in drivers/watchdog/s3c2410_wdt.c
Merging iommu/next (46fcc9a516e0 Merge branches 'arm/omap', 'arm/msm', 'arm=
/rockchip', 'arm/renesas', 'x86/vt-d', 'x86/amd' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (6c8030e8782f Merge branch 'docs-3.19' into docs-=
next)
Merging trivial/for-next (68386da82af3 zbud, zswap: change module author em=
ail)
Merging audit/next (0288d7183c41 audit: convert status version to a feature=
 bitmap)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (43c0767e17ac of/platform: Move platform=
 devices under /sys/devices/platform)
CONFLICT (content): Merge conflict in drivers/of/unittest.c
Merging dt-rh/for-next (a0e27f51ba8a documentation: pinctrl bindings: Fix t=
rivial typo 'abitrary')
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (5f894e86271f Merge remote-tracking branches 'spi/topi=
c/mxs', 'spi/topic/rockchip', 'spi/topic/sirf' and 'spi/topic/spidev' into =
spi-next)
Merging tip/auto-latest (caf0fea9e728 Merge branch 'x86/vdso')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (d0585cd815fa sb_edac: Claim a different PCI device)
Merging edac-amd/for-next (0a98babd85b2 EDAC: Delete unnecessary check befo=
re calling pci_dev_put())
Merging irqchip/irqchip/for-next (8c3bd6f6f160 Merge branch 'irqchip/urgent=
' into irqchip/for-next)
Merging tiny/tiny/next (77d8b4960de5 Merge branch 'tiny/ksize' into tiny/ne=
xt)
CONFLICT (content): Merge conflict in net/openvswitch/Kconfig
CONFLICT (content): Merge conflict in net/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
Merging ftrace/for-next (457ded5ba1b0 Merge branch 'trace/ftrace/testing' i=
nto trace/for-next)
Merging rcu/rcu/next (9ea6c5885681 Merge branches 'torture.2014.11.03a', 'c=
pu.2014.11.03a', 'doc.2014.11.13a', 'fixes.2014.11.13a', 'signal.2014.10.29=
a' and 'rt.2014.10.29a' into HEAD)
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
Merging drivers-x86/for-next (e403d4742a6e hp_accel: Add support for HP ZBo=
ok 15)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (46f6c620e8a1 Merge remote-tracking branches 'regma=
p/topic/cache' and 'regmap/topic/headers' into regmap-next)
Merging hsi/for-next (d95dc9e38810 HSI: nokia-modem: fix error handling of =
irq_of_parse_and_map)
Merging leds/for-next (7a8685accb95 leds: lp8860: Introduce TI lp8860 4 cha=
nnel LED driver)
Merging ipmi/for-next (882407763830 Change ACPI IPMI support to "default y")
CONFLICT (content): Merge conflict in arch/powerpc/platforms/powernv/opal-w=
rappers.S
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/opal.h
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
Merging usb-gadget/next (5ee80705a533 usb: dwc2: Update Kconfig to support =
dual-role)
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/dwc3/ep0.c
CONFLICT (content): Merge conflict in drivers/usb/dwc2/gadget.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/otg_fsm.c
Merging usb-serial/usb-next (e7181d005e84 USB: qcserial: Add support for HP=
 lt4112 LTE/HSPA+ Gobi 4G Modem)
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
Merging char-misc/char-misc-next (e88b1fc6a1c1 Revert "misc: always assign =
miscdevice to file->private_data in open()")
CONFLICT (content): Merge conflict in drivers/Makefile
Merging cgroup/for-next (eeecbd197151 cgroup: implement cgroup_get_e_css())
Merging scsi/for-next (2043e1fd09c1 bnx2fc: fix an error code in _bnx2fc_cr=
eate())
CONFLICT (content): Merge conflict in drivers/usb/storage/uas.c
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
Merging gpio/for-next (5cd3b5774ca1 gpio: mcp23s08: Do not free unrequested=
 interrupt)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (06e4cb6b1d5c pwm: samsung: Allow Samsung PWM driver t=
o be enabled on Exynos7)
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
CONFLICT (content): Merge conflict in include/crypto/hash.h
CONFLICT (content): Merge conflict in drivers/crypto/qat/qat_common/qat_alg=
s.c
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
Merging akpm-current/current (8af0244ab072 shmdt: use i_size_read() instead=
 of ->i_size)
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in fs/ocfs2/inode.h
CONFLICT (content): Merge conflict in drivers/usb/storage/debug.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-omap.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: slab: fix cpuset check in fallback_alloc
Applying: slub: fix cpuset check in get_any_partial
Applying: mm/cma: make kmemleak ignore CMA regions
Applying: mm: cma: split cma-reserved in dmesg log
Applying: fs: proc: include cma info in proc/meminfo
Applying: lib/show_mem.c: adds cma reserved information
Applying: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix
Applying: fallocate: create FAN_MODIFY and IN_MODIFY events
Applying: tools/testing/selftests/Makefile: alphasort the TARGETS list
Applying: fsnotify: unify inode and mount marks handling
Applying: fsnotify: remove destroy_list from fsnotify_mark
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (11729160b2d7 mm: add strictlimit knob)

--Sig_/xCbkkyMois44Y56rcZ2Z31J
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbZx0AAoJEMDTa8Ir7ZwVe18P/jP3xHKslmDAAe72H6zNf409
3p7j9FglbQ2X3CWeZ/mbIpy9NK7BNzMEeTQ3TVWAoc4q5QMYs6F/bdyj7oWEtvaV
U2IfH0CuVs7+UfBbZqYdI4LaZSBrsl7h1iJkZkDHs4Ef8LWjbbxgrv58itbIg/mz
7JfVRFaZSxbi+xyf1iUEYOzfuoiW2iQJA7op/l5Y/S+e9vTSCF4aAawq3aJTuDIM
MsiBsgEh069rVMQE2X43i01BVEQjtIV0kaTxtGmlIrfVWi0thJJkpKVQIXHHHSu6
cBVceDH36zLh/bBQzhDuKDNUu3vrdPkaDsdUTpP3OM6bX/qu+3b3Cu1gv6OB8QfG
t+90swE2Q7Wi31bCLAsOYVa/gWnNGBuipuXvjKjOFO4d+TtecpbdRopUFTZyx6cl
75MSzyu+SHyNmRgQAb1Z9zGaDcaPNxpDU7YFvYFcAGeG8cZYljfc994FdkoyouA/
1EYYkEwI/+Ru7INKlE4x0hFo7MYThOWbjCiNSREH1d9CDNld29+yP3kgeoSgP3xS
vwijL55j6gHm/bqyAtKS+PurFrBEPkFj/cBlmouVtmYwqsj9/Pnjmj7veNj0kfc9
6Xum6gq5wBzX5tMLKq6kD8Zu8GK060eWI5g9I13L9zE8AZx9HNmaCvVdFaH3VPb4
90j0sk22tMne0N06NmjP
=JV6P
-----END PGP SIGNATURE-----

--Sig_/xCbkkyMois44Y56rcZ2Z31J--
