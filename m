Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3CDKOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:14:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3CDKOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:14:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [3.5.y.z extended stable] Linux 3.5.7.7
Date: Mon,  4 Mar 2013 10:14:16 +0000
Message-Id: <1362392057-20421-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.7 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.6 release are
shown below.

-Luis

-- 
 Makefile                                         |   2 +-
 arch/arm/kernel/sched_clock.c                    |   4 +-
 arch/arm/mach-imx/clk-imx25.c                    |   3 +
 arch/arm/mach-pxa/include/mach/smemc.h           |   1 +
 arch/arm/mach-pxa/smemc.c                        |  15 ++-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S |  12 +-
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S |   4 +-
 arch/arm/mach-s3c24xx/pm-h1940.S                 |   2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S            |  12 +-
 arch/arm/mach-s3c24xx/sleep-s3c2412.S            |  12 +-
 arch/arm/mach-versatile/core.c                   |  15 ++-
 arch/arm/mach-versatile/pci.c                    |  11 +-
 arch/arm/plat-samsung/include/plat/debug-macro.S |  18 +--
 arch/parisc/include/asm/pgtable.h                |  13 +-
 arch/parisc/kernel/cache.c                       |  18 +++
 arch/powerpc/Kconfig                             |   4 +
 arch/powerpc/include/asm/eeh.h                   |   4 +
 arch/powerpc/kernel/machine_kexec_64.c           |   5 +
 arch/powerpc/kernel/of_platform.c                |   3 +
 arch/powerpc/kernel/pci-common.c                 |   7 +-
 arch/powerpc/lib/Makefile                        |   4 +-
 arch/powerpc/platforms/pseries/eeh.c             |  24 +++-
 arch/s390/kvm/kvm-s390.c                         |   8 ++
 arch/sparc/mm/tsb.c                              |   2 +-
 arch/x86/Kconfig                                 |   4 -
 arch/x86/include/asm/mmzone_32.h                 |   6 -
 arch/x86/kernel/cpu/mshyperv.c                   |   3 +-
 arch/x86/kernel/step.c                           |  53 +++++---
 arch/x86/mm/numa.c                               |  32 ++---
 arch/x86/mm/numa_32.c                            | 161 -----------------------
 arch/x86/mm/numa_internal.h                      |   6 -
 arch/x86/platform/efi/efi.c                      |   5 +-
 arch/x86/power/hibernate_32.c                    |   2 -
 arch/x86/xen/spinlock.c                          |   1 -
 arch/x86/xen/xen-asm_32.S                        |  14 +-
 drivers/acpi/sleep.c                             |   8 ++
 drivers/base/bus.c                               |   4 +-
 drivers/base/dd.c                                |   2 +
 drivers/block/sunvdc.c                           |   2 +-
 drivers/dca/dca-core.c                           |   5 +
 drivers/gpio/gpio-ich.c                          |   1 +
 drivers/gpu/drm/drm_crtc.c                       |   3 +-
 drivers/gpu/drm/drm_edid.c                       |   6 +-
 drivers/gpu/drm/drm_usb.c                        |   2 +-
 drivers/gpu/drm/i915/i915_debugfs.c              |  12 +-
 drivers/gpu/drm/i915/i915_reg.h                  |   2 +
 drivers/gpu/drm/i915/intel_display.c             |  15 ++-
 drivers/gpu/drm/radeon/atombios_crtc.c           |   6 +-
 drivers/gpu/drm/radeon/r600_hdmi.c               |   1 -
 drivers/gpu/drm/udl/udl_drv.h                    |   2 +
 drivers/gpu/drm/udl/udl_fb.c                     |  48 ++++++-
 drivers/hid/hid-wiimote-ext.c                    |   8 +-
 drivers/iommu/intel-iommu.c                      |   8 +-
 drivers/media/rc/rc-main.c                       |   4 +-
 drivers/media/video/v4l2-device.c                |  30 ++---
 drivers/mmc/host/sdhci-esdhc-imx.c               |  19 +--
 drivers/net/ethernet/intel/igb/igb_main.c        |   8 +-
 drivers/net/wireless/b43/dma.h                   |   2 +-
 drivers/net/wireless/b43/main.c                  |   3 +-
 drivers/net/wireless/p54/p54usb.c                |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |   9 +-
 drivers/net/wireless/rtlwifi/usb.c               |  49 ++++---
 drivers/net/wireless/rtlwifi/usb.h               |   3 +-
 drivers/net/xen-netback/interface.c              |   3 +-
 drivers/net/xen-netback/netback.c                |   8 +-
 drivers/pcmcia/vrc4171_card.c                    |   1 +
 drivers/power/ab8500_btemp.c                     |   2 +-
 drivers/power/abx500_chargalg.c                  |   2 +-
 drivers/pps/clients/pps-ldisc.c                  |  10 +-
 drivers/pps/pps.c                                |  47 ++++++-
 drivers/s390/kvm/kvm_virtio.c                    |  38 ++++--
 drivers/staging/comedi/comedi_fops.c             |  13 +-
 drivers/staging/comedi/drivers/ni_labpc.c        |  35 ++---
 drivers/staging/vt6656/usbpipe.c                 |  28 ++--
 drivers/target/target_core_device.c              |  13 +-
 drivers/target/target_core_fabric_configfs.c     |  12 +-
 drivers/target/target_core_internal.h            |   2 +-
 drivers/target/target_core_tpg.c                 |  10 +-
 drivers/tty/n_gsm.c                              |  42 +++++-
 drivers/tty/serial/imx.c                         |  11 +-
 drivers/tty/tty_ioctl.c                          |   4 +-
 drivers/tty/vt/vt.c                              | 136 +++++++++++++------
 drivers/usb/dwc3/gadget.c                        |  17 +--
 drivers/usb/host/ehci-omap.c                     |  10 +-
 drivers/usb/serial/ftdi_sio.c                    |  20 ++-
 drivers/usb/serial/mct_u232.c                    |  22 ++--
 drivers/usb/serial/option.c                      |  16 ++-
 drivers/usb/serial/quatech2.c                    |  18 ++-
 drivers/usb/serial/sierra.c                      |   8 +-
 drivers/usb/serial/ssu100.c                      |  19 ++-
 drivers/usb/serial/usb-serial.c                  |  14 +-
 drivers/usb/serial/usb_wwan.c                    |   8 +-
 drivers/usb/storage/initializers.c               |   4 +-
 drivers/usb/storage/unusual_cypress.h            |   2 +-
 drivers/video/backlight/adp8860_bl.c             |   2 +-
 drivers/video/backlight/adp8870_bl.c             |   2 +-
 drivers/video/console/fbcon.c                    |  47 ++++++-
 drivers/video/console/vgacon.c                   |  22 +++-
 drivers/video/fbmem.c                            |   9 +-
 drivers/video/fbsysfs.c                          |   3 +
 drivers/video/fsl-diu-fb.c                       |   6 +-
 drivers/xen/evtchn.c                             |  10 ++
 drivers/xen/xen-pciback/pciback_ops.c            |  14 +-
 fs/block_dev.c                                   |   1 +
 fs/direct-io.c                                   |   2 +-
 fs/ext4/balloc.c                                 |  13 +-
 fs/ext4/extents.c                                |  25 ++--
 fs/ext4/indirect.c                               |   9 +-
 fs/ext4/inode.c                                  |  11 +-
 fs/ext4/mballoc.c                                |   6 +-
 fs/ext4/mmp.c                                    |   2 +
 fs/ext4/page-io.c                                |  10 +-
 fs/ext4/resize.c                                 |   8 +-
 fs/ext4/xattr.c                                  |  10 +-
 fs/lockd/clntproc.c                              |   3 +
 fs/nfs/blocklayout/blocklayout.c                 |   1 +
 fs/nfs/nfs4proc.c                                |   3 +-
 fs/nfs/objlayout/objio_osd.c                     |   1 +
 fs/notify/inotify/inotify_user.c                 |   4 -
 fs/ocfs2/aops.c                                  |   2 +-
 fs/ocfs2/dlmglue.c                               |   5 +-
 fs/ubifs/orphan.c                                |  12 +-
 fs/ubifs/ubifs.h                                 |   6 +-
 include/linux/console.h                          |   2 +
 include/linux/idr.h                              |  11 ++
 include/linux/if_vlan.h                          |   6 +-
 include/linux/mmu_notifier.h                     |   1 +
 include/linux/pps_kernel.h                       |  17 ++-
 include/linux/quota.h                            |   1 +
 include/linux/usb/audio.h                        |   6 +-
 include/linux/vt_kern.h                          |   3 +
 include/net/inet6_hashtables.h                   |   8 +-
 include/net/inet_sock.h                          |   1 +
 include/net/ipv6.h                               |  12 ++
 include/net/sock.h                               |   2 +-
 kernel/cgroup.c                                  |   8 ++
 kernel/cpuset.c                                  |  12 +-
 kernel/futex.c                                   |   2 -
 kernel/futex_compat.c                            |   2 -
 kernel/hrtimer.c                                 |  36 ++---
 kernel/irq/spurious.c                            |   7 +-
 kernel/posix-cpu-timers.c                        |  23 +++-
 kernel/posix-timers.c                            |   7 +
 kernel/timeconst.pl                              |   6 +-
 kernel/trace/ftrace.c                            |  46 +++++--
 mm/fadvise.c                                     |  18 ++-
 mm/mmu_notifier.c                                | 147 ++++++++++++---------
 mm/shmem.c                                       |  10 +-
 net/bridge/br_stp_bpdu.c                         |   2 +
 net/core/datagram.c                              |   2 +-
 net/core/sock_diag.c                             |   3 +
 net/ipv4/af_inet.c                               |   9 +-
 net/ipv4/ping.c                                  |   4 +-
 sound/drivers/aloop.c                            |   5 +-
 sound/pci/ali5451/ali5451.c                      |   2 +-
 sound/pci/hda/patch_hdmi.c                       |   7 +-
 sound/pci/hda/patch_realtek.c                    |   1 +
 sound/pci/rme32.c                                |   2 +-
 sound/soc/codecs/wm2200.c                        |   4 +-
 sound/usb/quirks-table.h                         |   2 +-
 tools/perf/Makefile                              |   4 +-
 tools/perf/util/parse-events.y                   |   1 -
 tools/perf/util/pmu.y                            |   1 -
 163 files changed, 1236 insertions(+), 785 deletions(-)

Adam Thomas (2):
      UBIFS: fix use of freed ubifs_orphan objects
      UBIFS: fix double free of ubifs_orphan objects

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Alex Deucher (2):
      drm/radeon/dce6: fix display powergating
      drm/radeon: remove overzealous warning in hdmi handling

Alexander Duyck (1):
      igb: Remove artificial restriction on RQDPC stat reading

Anatolij Gustschin (1):
      drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp

Andrea Arcangeli (1):
      mm: mmu_notifier: make the mmu_notifier srcu static

Arnd Bergmann (1):
      ARM: samsung: fix assembly syntax for new gas

Ben Widawsky (1):
      drm/i915: Fix CAGF for HSW

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bjørn Mork (3):
      USB: option: add and update Alcatel modems
      USB: option: add Yota / Megafon M100-1 4g modem
      USB: option: add Huawei "ACM" devices using protocol = vendor

Chris Rattray (1):
      ASoC: wm2200: correct IN2L and IN3L digital mute

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support

Cong Wang (1):
      vlan: adjust vlan_set_encap_proto() for its callers

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.

Dan Carpenter (1):
      rc: unlock on error in show_protocols()

Daniel Vetter (3):
      Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
      drm/i915: inverted brightness quirk for Acer Aspire 4736Z
      intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets

Dave Airlie (5):
      vgacon/vt: clear buffer attributes when we load a 512 character font (v2)
      fbcon: don't lose the console font across generic->chip driver switch
      drm/usb: bind driver to correct device
      drm/udl: make usage as a console safer
      drm/udl: disable fb_defio by default

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Henningsson (1):
      ALSA: hda - hdmi: ELD shouldn't be valid after unplug

David Herrmann (1):
      HID: wiimote: fix nunchuck button parser

David S. Miller (2):
      sunvdc: Fix off-by-one in generic_request().
      sparc64: Fix gfp_flags setting in tsb_grow().

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

Denis Efremov (2):
      ALSA: rme32.c irq enabling after spin_lock_irq
      ALSA: ali5451: remove irq enabling in pointer callback

Dirkjan Bussink (1):
      tty: Prevent deadlock in n_gsm driver

Eric Dumazet (2):
      ipv6: use a stronger hash for tcp
      net: fix infinite loop in __skb_recv_datagram()

Eryu Guan (1):
      ext4: check bh in ext4_read_block_bitmap()

Fernando Luis Vázquez Cao (1):
      ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB with ALC889

George Spelvin (3):
      pps: Add pps_lookup_dev() function
      pps: Use pps_lookup_dev to reduce ldisc coupling
      pps: Fix a use-after free bug when unregistering a source.

Grant Likely (1):
      drivercore: Fix ordering between deferred_probe and exiting initcalls

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

H. Peter Anvin (3):
      x86-32, mm: Remove reference to resume_map_numa_kva()
      x86-32, mm: Remove reference to alloc_remap()
      timeconst.pl: Eliminate Perl warning

Ian Abbott (4):
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
      staging: comedi: check s->async for poll(), read() and write()
      staging: comedi: ni_labpc: set up command4 register *after* command3
      staging: comedi: ni_labpc: correct differential channel sequence for AI commands

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register

Jan Beulich (2):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Jan Kara (3):
      ext4: fix possible use-after-free with AIO
      fs: Fix possible use-after-free with AIO
      ocfs2: fix possible use-after-free with AIO

Jani Nikula (1):
      drm/i915: add missing \n to UTS_RELEASE in the error_state

Jean Delvare (2):
      pcmcia/vrc4171: Add missing spinlock init
      gpio/ich: Add missing spinlock init

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL

Johan Hovold (1):
      USB: serial: fix null-pointer dereferences on disconnect

John David Anglin (1):
      Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Joonsoo Kim (1):
      ARM: 7643/1: sched: correct update_sched_clock()

Joseph Salisbury (1):
      ACPI: Add DMI entry for Sony VGN-FW41E_H

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed

Jussi Kivilinna (1):
      rtlwifi: usb: allocate URB control message setup_packet and data buffer separately

Larry Finger (4):
      rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
      rtlwifi: rtl8192cu: Add new USB ID
      b43: Increase number of RX DMA slots
      b43: Fix lockdep splat on module unload

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume

Laurent Pinchart (1):
      v4l: Reset subdev v4l2_dev field to NULL if registration fails

Lee Jones (1):
      ab8500-chargalg: Only root should have write permission on sysfs file

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Li Wei (1):
      ipv4: fix a bug in ping_err().

Li Zefan (2):
      cgroup: fix exit() vs rmdir() race
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race

Linus Walleij (1):
      ARM: 7635/1: versatile: fix the PCI IRQ regression

Luis Henriques (1):
      Linux 3.5.7.7

Lukas Czerner (2):
      ext4: fix xattr block allocation/release with bigalloc
      ext4: fix free clusters calculation in bigalloc filesystem

MITSUNARI Shigeo (1):
      fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Malcolm Priestley (1):
      staging: vt6656: Fix URB submitted while active warning.

Mathias Krause (1):
      sock_diag: Fix out-of-bounds access to sock_diag_handlers[]

Matt Fleming (1):
      x86, efi: Make "noefi" really disable EFI runtime serivces

Mel Gorman (1):
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages

Mika Kuoppala (1):
      drm/i915: disable shared panel fitter for pipe

Nicholas Bellinger (2):
      target: Fix lookup of dynamic NodeACLs during cached demo-mode operation
      target: Add missing mapped_lun bounds checking during make_mappedlun setup

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised

Oleg Nesterov (3):
      tty: set_termios/set_termiox should not return -EINTR
      ptrace/x86: Introduce set_task_blockstep() helper
      ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic

Patrik Jakobsson (1):
      drm/i915: Set i9xx sdvo clock limits according to specifications

Paulo Zanoni (1):
      drm: don't add inferred modes for monitors that don't support them

Pawel Moll (1):
      ALSA: usb: Fix Processing Unit Descriptor parsers

Phileas Fogg (1):
      powerpc/kexec: Disable hard IRQ before kexec

Philipp Reisner (1):
      idr: idr_for_each_entry() macro

Pratyush Anand (3):
      USB: DWC3: Generate interrupt on each TRB as default option
      usb: dwc3: gadget: fix skip LINK_TRB on ISOC
      usb: dwc3: gadget: req->queued must be forced to false in cleanup

Rajanikanth H.V (1):
      ab8500_btemp: Demote initcall sequence

Robin Holt (1):
      mmu_notifier_unregister NULL Pointer deref and multiple ->release() callouts

Roger Quadros (2):
      USB: ehci-omap: Don't free gpios that we didn't request
      USB: ehci-omap: Fix autoloading of module

Sagi Grimberg (1):
      mm: mmu_notifier: have mmu_notifiers use a global SRCU so they may safely schedule

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: fix host version read

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Steffen Trumtrar (1):
      ARM: i.MX25: clk: parent per5_clk to AHB clock

Stephen Hemminger (1):
      bridge: set priority of STP packets

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers

Suzuki K. Poulose (1):
      uprobes/powerpc: Add dependency on single step emulation

Takashi Iwai (3):
      ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
      ALSA: aloop: Fix Oops while PM resume
      fb: Yet another band-aid for fixing lockdep mess

Tejun Heo (1):
      posix-timer: Don't call idr_find() with out-of-range ID

Thadeu Lima de Souza Cascardo (1):
      powerpc/eeh: Fix crash when adding a device in a slot with DDW

Theodore Ts'o (2):
      ext4: return ENOMEM if sb_getblk() fails
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format

Thomas Gleixner (3):
      genirq: Avoid deadlock in spurious handling
      serial: imx: Fix recursive locking bug
      futex: Revert "futex: Mark get_robust_list as deprecated"

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust (1):
      NLM: Ensure that we resend all pending blocking locks after a reclaim

Ville Syrjälä (2):
      drm: Fill depth/bits_per_pixel for C8 format
      drm: Use C8 instead of RGB332 when determining the format from depth/bpp

Vinson Lee (1):
      perf tools: Fix build with bison 2.3 and older.

Wei Liu (1):
      xen: close evtchn port if binding to irq fails

Weston Andros Adamson (1):
      NFSv4.1: Don't decode skipped layoutgets

Ying Xue (1):
      net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

fanchaoting (1):
      umount oops when remove blocklayoutdriver first

fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct

