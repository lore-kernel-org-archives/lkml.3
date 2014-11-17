Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaKQBLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:11:33 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:45371 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaKQBLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:11:31 -0500
MIME-Version: 1.0
Date: Sun, 16 Nov 2014 17:11:29 -0800
X-Google-Sender-Auth: vVOIJXeVL2fNS2OFfB5qoAHnJTM
Message-ID: <CA+55aFy9MGC8hKTaW1frLAwh=U8xxUcSWGE=NCjV5m6z+TeJiA@mail.gmail.com>
Subject: Linux 3.18-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. We had a very calm -rc4, and I wish I could say that things
continued to calm down, but...  Yeah, rc5 is clearly bigger than rc4
was. Oh well.

It's not like it's entirely out of line, though - rc4 was unusually
small. And the changes aren't particularly odd or scary: about 55%
drivers (networking, gpu, cypto, thermal, sound), 15% arch updates
(xtensa, x86, arm[64], parsic, sparc), and the rest is a mostly a mix
of netwoorking, filesystem, VM, documentation and tracing updates.
The changes tend to be fairly small and clear, and about a third are
marked for stable.

So we still have a few pending issues, but things look fairly normal.
We've still got a few weeks to go before final, and the more you can
test, the better off we'll be.

         Linus

---

Abhilash Kesavan (1):
      cpufreq: cpufreq-dt: Fix arguments in clock failure error message

Adam Lee (1):
      ACPI / blacklist: blacklist Win8 OSI for Dell Vostro 3546

Adel Gadllah (1):
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 0103

Alex Deucher (3):
      drm/radeon: make sure mode init is complete in bandwidth_update
      drm/radeon: use gart for DMA IB tests
      drm/radeon: add missing crtc unlock when setting up the MC

Alexander Kochetkov (2):
      net/smsc911x: Fix rare soft reset timeout issue due to PHY power-down mode
      net/smsc911x: Fix delays in the PHY enable/disable routines

Alexandre Courbot (1):
      drm/gk20a/fb: fix setting of large page size bit

Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andrew Lunn (2):
      ARM: mvebu: armada xp: Generalize use of i2c quirk
      net: dsa: slave: Fix autoneg for phys on switch MDIO bus

Anish Bhatt (4):
      cxgbi: add maintainer for cxgb3i/cxgb4i
      cxgb4i: send abort_rpl correctly
      cxgb4 : Fix bug in DCB app deletion
      cxgb4 : dcb open-lldp interop fixes

Anna Schumaker (1):
      NFS: SEEK is an NFS v4.2 feature

Antoine Tenart (1):
      ahci: fix AHCI parameters not taken into account

Aravind Gopalakrishnan (1):
      hwmon: (fam15h_power) Fix NB device ID for F16h M30h

Bai Ping (1):
      thermal: imx: correct driver load sequence for cpu cooling

Bartlomiej Zolnierkiewicz (1):
      thermal: exynos: use correct offset for TMU_CONTROL register on Exynos5260

Benjamin Tissoires (1):
      HID: core: cleanup .claimed field on disconnect

Boris Ostrovsky (1):
      x86/core, x86/xen/smp: Use 'die_complete' completion when taking CPU down

Borislav Petkov (3):
      x86, microcode, AMD: Fix early ucode loading on 32-bit
      x86, microcode: Fix accessing dis_ucode_ldr on 32-bit
      x86, microcode, AMD: Fix ucode patch stashing on 32-bit

Brian Hill (1):
      net: phy: Correctly handle MII ioctl which changes autonegotiation.

Charles Keepax (1):
      asix: Do full reset during ax88772_bind

Chen Gang (2):
      drivers: net: ethernet: xilinx: xilinx_emaclite: Compatible with
'xlnx, xps-ethernetlite-2.00.b' for QEMU using
      drivers: net: ethernet: xilinx: xilinx_emaclite: revert the
original commit "1db3ddff1602edf2390b7667dcbaa0f71512e3ea"

Chris Wilson (1):
      drm/i915: Fix obj->map_and_fenceable across tiling changes

Christoph Hellwig (3):
      scsi: only re-lock door after EH on devices that were reset
      scsi: call device handler for failed TUR command
      pnfs/blocklayout: serialize GETDEVICEINFO calls

Cornelia Huck (1):
      virtio_console: move early VQ enablement

Cristian Stoica (1):
      crypto: caam - fix missing dma unmap on error path

Daniel Baluta (1):
      MAINTAINERS: add IIO include files

Daniel Borkmann (3):
      net: sctp: fix NULL pointer dereference in af->from_addr_param
on malformed packet
      net: sctp: fix memory leak in auth key management
      ixgbe: phy: fix uninitialized status in ixgbe_setup_phy_link_tnx

Daniel Thompson (1):
      param: fix crash on bad kernel arguments

Dave Airlie (1):
      drm/radeon: add locking around atombios scratch space usage

David S. Miller (4):
      sunhme: Add DMA mapping error checks.
      sparc64: Fix crashes in schizo_pcierr_intr_other().
      sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().
      sparc64: Fix constraints on swab helpers.

Devin Ryles (1):
      ALSA: hda_intel: Add DeviceIDs for Sunrise Point-LP

Dmitry Eremin-Solenikov (1):
      PM / sleep: Fix entering suspend-to-IDLE if no freeze_oops is set

Ebru Akagunduz (1):
      power: ab8500_fg.c: use 64-bit time types

Edward Cree (1):
      sfc: don't BUG_ON efx->max_channels == 0 in probe

Eli Cohen (2):
      net/mlx5_core: Fix race in create EQ
      net/mlx5_core: Fix race on driver load

Emmanuel Grumbach (2):
      iwlwifi: mvm: initialize the cur_ucode upon boot
      iwlwifi: fix RFkill while calibrating

Enric Balletbo i Serra (1):
      smsc911x: power-up phydev before doing a software reset.

Eric Dumazet (1):
      ipv6: fix IPV6_PKTINFO with v4 mapped

Evgeniy Dushistov (1):
      ARM: orion: Fix for certain sequence of request_irq can cause irq storm

Fabrice Gasnier (2):
      stmmac: fix stmmac_tx_avail should be called with TX locked
      stmmac: release tx lock, in case of dma mapping error.

Felipe Balbi (1):
      MAINTAINERS: add more files under OMAP SUPPORT

Felix Fietkau (1):
      mac80211: flush keys for AP mode on ieee80211_do_stop

Florian Fainelli (4):
      net: systemport: fix DMA allocation/freeing sizes
      net: systemport: do not crash freeing an unitialized TX ring
      net: bcmgenet: connect and disconnect from the PHY state machine
      net: bcmgenet: apply MII configuration in bcmgenet_open()

Geert Uytterhoeven (1):
      cpufreq: Avoid crash in resume on SMP without OPP

Giedrius Statkevicius (2):
      platform: hp_accel: add a i8042 filter to remove HPQ6000 data
from kb bus stream
      platform: hp_accel: Add SERIO_I8042 as a dependency since it now
includes i8042.h/serio.h

Giuseppe CAVALLARO (3):
      stmmac: fix lock in stmmac_set_rx_mode
      stmmac: fix concurrency in eee initialization.
      stmmac: fix atomicity in pm routines

Govindarajulu Varadarajan (2):
      enic: handle error condition properly in enic_rq_indicate_buf
      enic: update desc properly in rx_copybreak

Greg Kurz (1):
      hwrng: pseries - port to new read API and fix stack corruption

Gregory Fong (1):
      bridge: include in6.h in if_bridge.h for struct in6_addr

Guenter Roeck (1):
      netfilter: nft_reject_bridge: Fix powerpc build error

Hariprasad Shenai (3):
      cxgb4vf: Move fl_starv_thres into adapter->sge data structure
      cxgb4/cxgb4vf: For T5 use Packing and Padding Boundaries for SGE
DMA transfers
      cxgb4vf: FL Starvation Threshold needs to be larger than the
SGE's Egress Congestion Threshold

Heiner Kallweit (1):
      imx: thermal: imx_get_temp might be called before sensor clock is prepared

Heinz Mauelshagen (2):
      dm raid: ensure superblock's size matches device's logical block size
      dm raid: fix inaccessible superblocks causing oops in
configure_discard_support

Helge Deller (4):
      parisc: Wire up bpf syscall
      parisc: Use BUILD_BUG() instead of undefined functions
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls
      parisc: Avoid using CONFIG_64BIT in userspace exported headers

Herbert Xu (4):
      tun: Fix csum_start with VLAN acceleration
      tun: Fix TUN_PKT_STRIP setting
      macvtap: Fix csum_start when VLAN tags are present
      lib: rhashtable - Remove weird non-ASCII characters from comments

Hiroaki SHIMODA (1):
      netlink: Properly unbind in error conditions.

Ilya Dryomov (4):
      libceph: do not crash on large auth tickets
      libceph: unlink from o_linger_requests when clearing r_osd
      libceph: clear r_req_lru_item in __unregister_linger_request()
      libceph: change from BUG to WARN for __remove_osd() asserts

Imre Deak (1):
      drm/i915: vlv: fix gunit HW state corruption during S4 suspend

Inki Dae (4):
      drm/exynos: resolve infinite loop issue on multi-platform
      drm/exynos: resolve infinite loop issue on non multi-platform
      drm/exynos: g2d: fix null pointer dereference
      drm/exynos: fix possible infinite loop issue

Iyappan Subramanian (3):
      dtb: xgene: fix: Backward compatibility with older firmware
      drivers: net: xgene: Backward compatibility with older firmware
      drivers: net: xgene: fix: Use separate resources

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH

Jammy Zhou (1):
      drm/radeon: set correct CE ram size for CIK

Jan Kara (4):
      block: Fix computation of merged request priority
      nfs: Remove bogus assignment
      nfs: Fix use of uninitialized variable in nfs_getattr()
      fanotify: fix notification of groups with inode & mount marks

Jani Nikula (1):
      drm/i915: safeguard against too high minimum brightness

Jeff Layton (1):
      sunrpc: fix sleeping under rcu_read_lock in gss_stringify_acceptor

Jesse Gross (3):
      geneve: Set GSO type on transmit.
      geneve: Unregister pernet subsys on module unload.
      udptunnel: Add SKB_GSO_UDP_TUNNEL during gro_complete.

Jiang Liu (1):
      megaraid_sas: fix bug in handling return value of pci_enable_msix_range()

Joe Thornber (2):
      dm thin: grab a virtual cell before looking up the mapping
      dm btree: fix a recursion depth bug in btree walking code

Johan Hovold (1):
      mfd: viperboard: Fix platform-device id collision

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Joonsoo Kim (7):
      mm/compaction: skip the range until proper target pageblock is met
      mm/page_alloc: fix incorrect isolation behavior by rechecking migratetype
      mm/page_alloc: add freepage on isolate pageblock to correct buddy list
      mm/page_alloc: move freepage counting logic to __free_one_page()
      mm/page_alloc: restrict max order of merging on isolated pageblock
      mm/slab: fix unalignment problem on Malta with EVA due to slab merge
      mm/debug-pagealloc: correct freepage accounting and order resetting

Junjie Mao (2):
      mac80211_hwsim: release driver when ieee80211_register_hw fails
      x86, kaslr: Prevent .bss from overlaping initrd

Kailang Yang (1):
      ALSA: hda/realtek - Change EAPD to verb control

Kamil Debski (1):
      hwmon: (pwm-fan) Fix suspend/resume behavior

Karl Beldan (1):
      net: mv643xx_eth: reclaim TX skbs only when released by the HW

Keerthy (3):
      ARM: dts: AM43x-EPOS-EVM: Fix DCDC3 voltage
      ARM: dts: AM437x-GP-EVM: Fix DCDC3 voltage
      ARM: dts: AM437x-SK-EVM: Fix DCDC3 voltage

Kirill A. Shutemov (1):
      kernel: use the gnu89 standard explicitly

Koji Matsuoka (1):
      ata: sata_rcar: Add r8a7793 device support

Krzysztof Kozlowski (8):
      power: bq2415x_charger: Properly handle ENODEV from
power_supply_get_by_phandle
      power: bq2415x_charger: Fix memory leak on DTS parsing error
      power_supply: Add no_thermal property to prevent recursive get_temp calls
      power: charger-manager: Avoid recursive thermal get_temp call
      power: charger-manager: Fix accessing invalidated power supply
after fuel gauge unbind
      power: charger-manager: Fix accessing invalidated power supply
after charger unbind
      mfd: max77693: Use proper regmap for handling MUIC interrupts
      mfd: max77693: Fix always masked MUIC interrupts

Kyle McMartin (1):
      arm64: __clear_user: handle exceptions on strb

Linus Torvalds (2):
      x86-64: make csum_partial_copy_from_user() error handling consistent
      Linux 3.18-rc5

Linus Walleij (2):
      smc91x: retrieve IRQ and trigger flags in a modern way
      mfd: stmpe: Fix STMPE24xx GPMR LSB

Loganaden Velvindron (1):
      net: Add missing descriptions for fwmark_reflect for ipv4 and ipv6.

Lothar Waßmann (1):
      net: fec: fix regression on i.MX28 introduced by rx_copybreak support

Luciano Coelho (2):
      mac80211: use secondary channel offset IE also beacons during CSA
      mac80211: schedule the actual switch of the station before CSA count 0

Manish Chopra (1):
      netxen: Fix link event handling.

Marcelo Leitner (2):
      tcp: zero retrans_stamp if all retrans were acked
      vxlan: Do not reuse sockets for a different address family

Mark Rutland (1):
      arm64: efi: Fix stub cache maintenance

Maurizio Lombardi (1):
      bnx2fc: fix tgt spinlock locking

Max Filippov (7):
      xtensa: implement pgprot_noncached
      xtensa: ISS: add BLOCK dependency to BLK_DEV_SIMDISK
      xtensa: add seccomp, getrandom, and memfd_create syscalls
      xtensa: xtfpga: only select ethoc when ethernet is available
      xtensa: re-wire umount syscall to sys_oldumount
      xtensa: xtfpga: add generic KC705 board config
      xtensa: xtfpga: add lx200 SMP DTS and defconfig

Michael Ellerman (1):
      hwmon: (ibmpowernv) Quieten when probing finds no device

Michal Nazarewicz (1):
      mm: alloc_contig_range: demote pages busy message from warn to info

Miklos Szeredi (1):
      audit: keep inode pinned

Mikulas Patocka (1):
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Min-Hua Chen (1):
      arm64: Fix data type for physical address

Ming Lei (1):
      block: blk-merge: fix blk_recount_segments()

Mugunthan V N (1):
      drivers: net: cpsw: remove cpsw_ale_stop from cpsw_ale_destroy

Nadav Amit (1):
      KVM: x86: Fix uninitialized op->type for some immediate values

Nathan Lynch (1):
      ARM: 8198/1: make kuser helpers depend on MMU

Neil Zhang (1):
      arm64: ARCH_PFN_OFFSET should be unsigned long

NeilBrown (2):
      Input: twl4030-pwrbutton - ensure a wakeup event is recorded.
      md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Nimrod Andy (1):
      net: fec: fix suspend broken on multiple MACs sillicons

Nishanth Menon (1):
      MAINTAINERS: Update entry for omap related .dts files to cover new SoCs

Or Gerlitz (1):
      net/mlx4_en: Advertize encapsulation offloads features only when
VXLAN tunnel is set

Pali Rohár (3):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      Input: alps - ignore bad data on Dell Latitudes E6440 and E7440

Paul Mackerras (1):
      Fix thinko in iov_iter_single_seg_count

Pavitra Kumar (1):
      dm stripe: fix potential for leak in stripe_ctr error path

Peng Tao (1):
      nfs: fix pnfs direct write memory leak

Peter Rosin (1):
      ARM: at91/dt: Fix sama5d3x typos

Rabin Vincent (2):
      tracing: Do not busy wait in buffer splice
      tracing: Do not risk busy looping in buffer splice

Rasmus Villemoes (1):
      include/linux/socket.h: Fix comment

Ricardo Ribalda Delgado (1):
      xtensa/uapi: Add definition of TIOC[SG]RS485

Richard Cochran (1):
      net: ptp: fix time stamp matching logic for VLAN packets.

Richard Guy Briggs (2):
      audit: AUDIT_FEATURE_CHANGE message format missing delimiting space
      selinux: convert WARN_ONCE() to printk() in selinux_nlmsg_perm()

Rodrigo Vivi (1):
      drm/i915: Disable caches for Global GTT.

Roger Quadros (2):
      ARM: dts: am335x-evm: Fix 5th NAND partition's name
      pinctrl: dra: dt-bindings: Fix output pull up/down

Roy Spliet (1):
      drm/nouveau/nv50/disp: Fix modeset on G94

Ryo Munakata (1):
      net/9p: remove a comment about pref member which doesn't exist

Sebastian Ott (1):
      KVM: s390: virtio_ccw: remove unused variable

Shuah Khan (1):
      selftests/net: psock_fanout seg faults in sock_fanout_read_ring()

Simon Horman (1):
      ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Stefan Wahren (1):
      net: qualcomm: Fix dependency

Steffen Klassert (4):
      ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
      vti6: Use vti6_dev_init as the ndo_init function.
      sit: Use ipip6_tunnel_init as the ndo_init function.
      gre6: Move the setting of dev->iflink into the ndo_init functions.

Sudip Mukherjee (1):
      net: mvpp2: fix possible memory leak

Tadeusz Struk (2):
      crypto: qat - Prevent dma mapping zero length assoc data
      crypto: qat - Enforce valid numa configuration

Takashi Iwai (4):
      Input: synaptics - add min/max quirk for Lenovo T440s
      ALSA: usb-audio: Fix memory leak in FTU quirk
      net: ppp: Don't call bpf_prog_create() in ppp_lock
      ALSA: hda - Add mute LED control for Lenovo Ideapad Z560

Tang Chen (2):
      mem-hotplug: reset node managed pages when hot-adding a new pgdat
      mem-hotplug: reset node present pages when hot-adding a new pgdat

Tejun Heo (4):
      Revert "AHCI: Do not acquire ata_host::lock from single IRQ handler"
      Revert "AHCI: Optimize single IRQ interrupt processing"
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks
      blk-mq: make mq_queue_reinit_notify() freeze queues in parallel

Thierry Reding (2):
      mfd: rtsx: Fix build warnings for !PM
      drm/tegra: dc: Add missing call to drm_vblank_on()

Tony Battersby (1):
      scsi: Fix more error handling in SCSI_IOCTL_SEND_COMMAND

Tony Lindgren (1):
      mfd: twl4030-power: Fix poweroff with PM configuration enabled

Trond Myklebust (8):
      NFSv4: Ensure nfs_atomic_open set the dentry verifier on ENOENT
      Revert "NFS: remove BUG possibility in nfs4_open_and_get_state"
      Revert "NFS: nfs4_do_open should add negative results to the dcache."
      NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired
      NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust
NFS_DELEGATED_STATE
      NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return
      NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are revoked
      NFS: Don't try to reclaim delegation open state if recovery failed

Ulf Hansson (2):
      PM / Domains: Change prototype for the attach and detach callbacks
      PM / Domains: Fix initial default state of the need_restore flag

Ulrik De Bie (5):
      Input: elantech - use elantech_report_trackpoint for hardware v4 too
      Input: elantech - fix crc_enabled for Fujitsu H730
      Input: elantech - report the middle button of the touchpad
      Input: elantech - provide a sysfs knob for crc_enabled
      Input: elantech - update the documentation

Vlastimil Babka (1):
      mm, compaction: prevent infinite loop in compact_zone

Weijie Yang (1):
      zram: avoid kunmap_atomic() of a NULL pointer

Weston Andros Adamson (1):
      nfs: remove spurious WARN_ON_ONCE in write path

Will Deacon (1):
      ARM: 8191/1: decompressor: ensure I-side picks up relocated code

William Cohen (1):
      Correct the race condition in aarch64_insn_patch_text_sync()

Xie XiuQi (1):
      kernel/panic.c: update comments for print_tainted

Yan, Zheng (1):
      ceph: fix flush tid comparision

lan,Tianyu (1):
      Thermal/int3403: Fix thermal hysteresis unit conversion

stephen hemminger (1):
      uapi: add missing network related headers to kbuild

wenxiong@linux.vnet.ibm.com (1):
      scsi: TUR path is down after adapter gets reset with multipath
