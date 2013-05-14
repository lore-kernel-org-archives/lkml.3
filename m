Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3ENMzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:55:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54977 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701Ab3ENMze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:55:34 -0400
Message-ID: <1368536100.4304.69.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.45
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Tue, 14 May 2013 13:55:00 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Rs2jQyV5GZwkj5Z2nOfU"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rs2jQyV5GZwkj5Z2nOfU
Content-Type: multipart/mixed; boundary="=-syv4yOKw9/zvqFhpOW11"


--=-syv4yOKw9/zvqFhpOW11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.45 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.44 is attached to this message.

Ben.

------------

 Makefile                                        |    2 +-
 arch/arm/mach-u300/include/mach/u300-regs.h     |    2 +-
 arch/ia64/include/asm/futex.h                   |    5 +-
 arch/ia64/include/asm/mca.h                     |    1 +
 arch/ia64/kernel/irq.c                          |    8 ++
 arch/ia64/kernel/mca.c                          |   37 ++++---
 arch/ia64/kvm/vtlb.c                            |    2 +-
 arch/powerpc/kernel/head_64.S                   |    1 +
 arch/powerpc/mm/numa.c                          |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |    1 +
 arch/s390/include/asm/pgtable.h                 |    4 +
 arch/sparc/include/asm/pgtable_64.h             |    1 +
 arch/sparc/include/asm/system_64.h              |    3 +-
 arch/sparc/include/asm/tlbflush_64.h            |   37 +++++--
 arch/sparc/kernel/smp_64.c                      |   41 +++++++-
 arch/sparc/mm/tlb.c                             |   39 +++++++-
 arch/sparc/mm/tsb.c                             |   57 ++++++++---
 arch/sparc/mm/ultra.S                           |  119 ++++++++++++++++++-=
----
 arch/x86/kernel/cpu/perf_event_intel.c          |   15 ++-
 arch/x86/mm/init.c                              |    5 +
 arch/x86/xen/enlighten.c                        |    5 +-
 arch/x86/xen/smp.c                              |    2 +
 arch/x86/xen/time.c                             |    6 +-
 crypto/algif_hash.c                             |    2 +
 crypto/algif_skcipher.c                         |    1 +
 drivers/acpi/pci_root.c                         |    4 +-
 drivers/char/hpet.c                             |   14 +--
 drivers/gpu/drm/i915/i915_dma.c                 |   81 +++++++--------
 drivers/gpu/drm/i915/i915_drv.h                 |    1 +
 drivers/gpu/drm/i915/i915_gem.c                 |   16 +++
 drivers/gpu/drm/i915/intel_display.c            |    3 +
 drivers/gpu/drm/i915/intel_dp.c                 |    5 -
 drivers/gpu/drm/i915/intel_dvo.c                |   13 ++-
 drivers/gpu/drm/i915/intel_lvds.c               |   10 +-
 drivers/gpu/drm/i915/intel_panel.c              |    7 +-
 drivers/gpu/drm/radeon/atom.c                   |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c          |    3 +
 drivers/gpu/drm/radeon/evergreen.c              |   10 ++
 drivers/gpu/drm/radeon/r600_hdmi.c              |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |   21 ++--
 drivers/gpu/drm/radeon/radeon_kms.c             |    4 +
 drivers/gpu/drm/radeon/radeon_pm.c              |    6 +-
 drivers/i2c/busses/i2c-xiic.c                   |    6 +-
 drivers/md/md.c                                 |    9 +-
 drivers/net/bonding/bond_main.c                 |   10 ++
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c    |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |   12 +++
 drivers/net/ethernet/realtek/r8169.c            |   22 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c      |    5 +-
 drivers/net/wireless/mwifiex/pcie.c             |    4 +-
 drivers/pci/pci.c                               |   12 +--
 drivers/rtc/rtc-cmos.c                          |    4 +-
 drivers/s390/char/sclp_cmd.c                    |    4 +-
 drivers/tty/pty.c                               |    3 +
 drivers/tty/serial/serial_core.c                |    4 +
 drivers/tty/tty_io.c                            |   16 ++-
 drivers/usb/core/devio.c                        |    2 +
 drivers/usb/misc/appledisplay.c                 |    1 +
 drivers/usb/serial/ftdi_sio.c                   |   23 +++--
 drivers/usb/serial/ftdi_sio_ids.h               |    4 +-
 drivers/usb/serial/option.c                     |    8 ++
 drivers/usb/storage/cypress_atacb.c             |   16 ++-
 drivers/video/console/fbcon.c                   |    2 +
 drivers/video/fbmem.c                           |   40 +++-----
 fs/aio.c                                        |    2 +-
 fs/dcache.c                                     |    4 +-
 fs/ext4/Kconfig                                 |    3 +-
 fs/ext4/fsync.c                                 |    3 +-
 fs/ext4/inode.c                                 |    3 +-
 fs/fscache/stats.c                              |    2 +-
 fs/jbd2/commit.c                                |   50 +++++-----
 fs/jbd2/journal.c                               |   31 ++++++
 fs/lockd/clntlock.c                             |    3 +
 fs/lockd/clntproc.c                             |    3 -
 fs/nfsd/nfs4proc.c                              |    8 +-
 fs/nfsd/nfs4state.c                             |    8 +-
 fs/nfsd/nfs4xdr.c                               |   19 +---
 fs/notify/inotify/inotify_user.c                |    6 +-
 fs/sysfs/dir.c                                  |   15 ++-
 include/linux/ipc_namespace.h                   |    2 +-
 include/linux/jbd2.h                            |    2 +
 include/linux/mm.h                              |    2 +
 include/linux/netdevice.h                       |    2 +-
 include/linux/skbuff.h                          |    7 ++
 ipc/shm.c                                       |    2 +-
 kernel/audit_tree.c                             |    2 +-
 kernel/cgroup.c                                 |    2 +-
 kernel/events/core.c                            |    3 +-
 kernel/hrtimer.c                                |    6 ++
 kernel/time/tick-broadcast.c                    |    4 +
 kernel/time/tick-common.c                       |    1 +
 kernel/trace/ftrace.c                           |    5 +-
 kernel/trace/trace.c                            |   65 ++++++-------
 kernel/trace/trace_selftest.c                   |    9 +-
 kernel/trace/trace_stack.c                      |   76 +++++++++++++--
 kernel/trace/trace_stat.c                       |    2 +
 mm/memory.c                                     |   47 +++++++++
 net/atm/common.c                                |    2 +
 net/ax25/af_ax25.c                              |    1 +
 net/bluetooth/af_bluetooth.c                    |    4 +-
 net/bluetooth/rfcomm/sock.c                     |    1 +
 net/caif/caif_socket.c                          |    2 +
 net/core/dev.c                                  |    1 +
 net/core/dev_addr_lists.c                       |    6 +-
 net/core/rtnetlink.c                            |    4 +-
 net/ipv4/esp4.c                                 |    6 +-
 net/ipv4/ip_fragment.c                          |   15 ++-
 net/ipv4/syncookies.c                           |    4 +-
 net/ipv4/tcp_input.c                            |   65 ++++++-------
 net/ipv6/addrconf.c                             |   27 +++++
 net/ipv6/reassembly.c                           |   13 ++-
 net/irda/af_irda.c                              |    2 +
 net/iucv/af_iucv.c                              |    2 +
 net/llc/af_llc.c                                |    2 +
 net/netrom/af_netrom.c                          |    1 +
 net/rose/af_rose.c                              |    1 +
 net/sched/sch_cbq.c                             |    5 +-
 net/sctp/auth.c                                 |    2 +-
 net/tipc/socket.c                               |    7 ++
 net/unix/af_unix.c                              |    2 +-
 net/wireless/reg.c                              |    2 +-
 sound/core/pcm_native.c                         |   12 +--
 sound/soc/codecs/max98088.c                     |    2 +-
 sound/usb/card.c                                |    4 +-
 sound/usb/card.h                                |    1 +
 sound/usb/endpoint.c                            |    3 +-
 sound/usb/midi.c                                |   13 +--
 sound/usb/quirks.c                              |    1 +
 sound/usb/stream.c                              |    8 ++
 131 files changed, 1010 insertions(+), 429 deletions(-)

Adrian Thomasset (2):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Alex Deucher (8):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon: use frac fb div on RS780/RS880
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: fix handling of v6 power tables

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after  loopback down-up

Ben Hutchings (1):
      Linux 3.2.45

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display

Benjamin Poirier (1):
      ixgbe: add missing rtnl_lock in PM resume path

Bj=C3=B8rn Mork (1):
      USB: option: add a D-Link DWM-156 variant

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in aud=
it_trim_trees()

Chris Wilson (2):
      drm/i915: Workaround incoherence between fences and LLC across multip=
le CPUs
      drm/i915: Fix detection of base of stolen memory

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices

Daniel Borkmann (1):
      net: sctp: sctp_auth_key_put: use kzfree instead of  kfree

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

David M=C3=BCller (ELSOFT AG) (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

David S. Miller (1):
      sparc64: Fix race in TLB batch processing.

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Dmitry Monakhov (1):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_=
callback

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under  synflood

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send zeroed LQ cmd

Eric Dumazet (2):
      tcp: call tcp_replace_ts_recent() from tcp_ack()
      net: drop dst before queueing fragments

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce  all messages

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Greg Thelen (1):
      fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of  wrong ip leng=
th fields

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl=
 ep

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments

J. Bruce Fields (1):
      nfsd4: don't close read-write opens too soon

Jacob Keller (1):
      ixgbe: fix EICR write in ixgbe_msix_other

Jani Nikula (1):
      drm/i915: ensure single initialization and cleanup of backlight devic=
e

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
      TTY: fix atime/mtime regression

Johannes Berg (1):
      wireless: regulatory: fix channel disabling race condition

Konrad Rzeszutek Wilk (3):
      xen/smp: Fix leakage of timer interrupt line for every CPU online/off=
line.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for ever=
y CPU online/offline
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.

Li Zefan (1):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()

Linus Torvalds (6):
      tty: fix up atime/mtime mess, take three
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h
      vm: add vm_iomap_memory() helper function
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert HPET mmap to vm_iomap_memory() helper

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug

Mathias Krause (12):
      crypto: algif - suppress sending source address information in recvms=
g
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in  rfcomm_sock_re=
cvmsg()
      caif: Fix missing msg_namelen update in  caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in  irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in  iucv_sock_recvmsg()
      llc: Fix missing msg_namelen update in  llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in  recv_msg/recv_stream

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header  length

Mika Kuoppala (1):
      fbcon: when font is freed, clear also vc_font.data

Ming Lei (1):
      sysfs: fix use after free in case of concurrent read/write and readdi=
r

Namhyung Kim (3):
      tracing: Fix off-by-one on allocating stat->pages
      tracing: Reset ftrace_graph_filter_enabled if count is zero
      tracing: Check return value of tracing_init_dentry()

NeilBrown (1):
      md: bad block list should default to disabled.

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

Rafael J. Wysocki (1):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x

Stephan Schreiber (2):
      Wrong asm register contraints in the futex implementation
      Wrong asm register contraints in the kvm implementation

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO

Steven Rostedt (Red Hat) (4):
      tracing: Use stack of calling function for stack tracer
      tracing: Fix stack tracer with fentry use
      tracing: Remove most or all of stack tracer stack size from stack_max=
_size
      tracing: Fix ftrace_dump()

Takashi Iwai (1):
      ALSA: usb-audio: Fix autopm error during probing

Theodore Ts'o (2):
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG

Thomas Gleixner (1):
      clockevents: Set dummy handler on CPU_DEAD shutdown

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Tony Luck (1):
      Fix initialization of CMCI/CMCP interrupts

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB

Trond Myklebust (1):
      LOCKD: Ensure that nlmclnt_block resets block->b_status after a serve=
r reboot

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree

Vasily Averin (1):
      cbq: incorrect processing of high limits

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works  properly.

Wei Yongjun (3):
      perf: Fix error return code
      esp4: fix error return code in esp_output()
      netrom: fix invalid use of sizeof in nr_recvmsg()

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls

Yogesh Ashok Powar (2):
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
      mwifiex: Call pci_release_region after calling pci_disable_device

Zhao Hongjiang (2):
      aio: fix possible invalid memory access when DEBUG is enabled
      inotify: invalid mask should return a error number but not set it

fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error

fran=C3=A7ois romieu (1):
      r8169: fix vlan tag read ordering.

jerry.hoemann@hp.com (1):
      x86/mm: account for PGDIR_SIZE alignment

nikolay@redhat.com (2):
      bonding: fix bonding_masters race condition in bond  unloading
      bonding: IFF_BONDING is not stripped on enslave  failure


--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-syv4yOKw9/zvqFhpOW11
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.45.patch"
Content-Disposition: attachment; filename="linux-3.2.45.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDU2Njc1MGMuLjkwNzJmZWUg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDQ0DQorU1VCTEVWRUwg
PSA0NQ0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLXUzMDAvaW5jbHVkZS9tYWNoL3UzMDAtcmVncy5o
IGIvYXJjaC9hcm0vbWFjaC11MzAwL2luY2x1ZGUvbWFjaC91MzAwLXJlZ3MuaA0KaW5kZXggMDM1
ZmRjOS4uYThiNzFmMiAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21hY2gtdTMwMC9pbmNsdWRlL21h
Y2gvdTMwMC1yZWdzLmgNCisrKyBiL2FyY2gvYXJtL21hY2gtdTMwMC9pbmNsdWRlL21hY2gvdTMw
MC1yZWdzLmgNCkBAIC0xMDIsNyArMTAyLDcgQEANCiANCiAjaWZkZWYgQ09ORklHX01BQ0hfVTMw
MF9CUzMzNQ0KIC8qIEZhc3QgVUFSVDEgb24gVTMzNSBvbmx5ICovDQotI2RlZmluZSBVMzAwX1VB
UlQxX0JBU0UJCQkoVTMwMF9TTE9XX1BFUl9QSFlTX0JBU0UrMHg3MDAwKQ0KKyNkZWZpbmUgVTMw
MF9VQVJUMV9CQVNFCQkJKFUzMDBfRkFTVF9QRVJfUEhZU19CQVNFKzB4NzAwMCkNCiAjZW5kaWYN
CiANCiAvKg0KZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9pbmNsdWRlL2FzbS9mdXRleC5oIGIvYXJj
aC9pYTY0L2luY2x1ZGUvYXNtL2Z1dGV4LmgNCmluZGV4IDIxYWIzNzYuLjFiZDE0ZDUgMTAwNjQ0
DQotLS0gYS9hcmNoL2lhNjQvaW5jbHVkZS9hc20vZnV0ZXguaA0KKysrIGIvYXJjaC9pYTY0L2lu
Y2x1ZGUvYXNtL2Z1dGV4LmgNCkBAIC0xMDcsMTYgKzEwNywxNSBAQCBmdXRleF9hdG9taWNfY21w
eGNoZ19pbmF0b21pYyh1MzIgKnV2YWwsIHUzMiBfX3VzZXIgKnVhZGRyLA0KIAkJcmV0dXJuIC1F
RkFVTFQ7DQogDQogCXsNCi0JCXJlZ2lzdGVyIHVuc2lnbmVkIGxvbmcgcjggX19hc20gKCJyOCIp
Ow0KKwkJcmVnaXN0ZXIgdW5zaWduZWQgbG9uZyByOCBfX2FzbSAoInI4IikgPSAwOw0KIAkJdW5z
aWduZWQgbG9uZyBwcmV2Ow0KIAkJX19hc21fXyBfX3ZvbGF0aWxlX18oDQogCQkJIgltZjs7CQkJ
CQlcbiINCi0JCQkiCW1vdiAlMD1yMAkJCQlcbiINCiAJCQkiCW1vdiBhci5jY3Y9JTQ7OwkJCQlc
biINCiAJCQkiWzE6XQljbXB4Y2hnNC5hY3EgJTE9WyUyXSwlMyxhci5jY3YJCVxuIg0KIAkJCSIJ
LnhkYXRhNCBcIl9fZXhfdGFibGVcIiwgMWItLiwgMmYtLglcbiINCiAJCQkiWzI6XSINCi0JCQk6
ICI9ciIgKHI4KSwgIj1yIiAocHJldikNCisJCQk6ICIrciIgKHI4KSwgIj0mciIgKHByZXYpDQog
CQkJOiAiciIgKHVhZGRyKSwgInIiIChuZXd2YWwpLA0KIAkJCSAgInJPIiAoKGxvbmcpICh1bnNp
Z25lZCkgb2xkdmFsKQ0KIAkJCTogIm1lbW9yeSIpOw0KZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9p
bmNsdWRlL2FzbS9tY2EuaCBiL2FyY2gvaWE2NC9pbmNsdWRlL2FzbS9tY2EuaA0KaW5kZXggNDNm
OTZhYi4uOGM3MDk2MSAxMDA2NDQNCi0tLSBhL2FyY2gvaWE2NC9pbmNsdWRlL2FzbS9tY2EuaA0K
KysrIGIvYXJjaC9pYTY0L2luY2x1ZGUvYXNtL21jYS5oDQpAQCAtMTQzLDYgKzE0Myw3IEBAIGV4
dGVybiB1bnNpZ25lZCBsb25nIF9fcGVyX2NwdV9tY2FbTlJfQ1BVU107DQogZXh0ZXJuIGludCBj
cGVfdmVjdG9yOw0KIGV4dGVybiBpbnQgaWE2NF9jcGVfaXJxOw0KIGV4dGVybiB2b2lkIGlhNjRf
bWNhX2luaXQodm9pZCk7DQorZXh0ZXJuIHZvaWQgaWE2NF9tY2FfaXJxX2luaXQodm9pZCk7DQog
ZXh0ZXJuIHZvaWQgaWE2NF9tY2FfY3B1X2luaXQodm9pZCAqKTsNCiBleHRlcm4gdm9pZCBpYTY0
X29zX21jYV9kaXNwYXRjaCh2b2lkKTsNCiBleHRlcm4gdm9pZCBpYTY0X29zX21jYV9kaXNwYXRj
aF9lbmQodm9pZCk7DQpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2tlcm5lbC9pcnEuYyBiL2FyY2gv
aWE2NC9rZXJuZWwvaXJxLmMNCmluZGV4IGFkNjk2MDYuLmYyYzQxODI4IDEwMDY0NA0KLS0tIGEv
YXJjaC9pYTY0L2tlcm5lbC9pcnEuYw0KKysrIGIvYXJjaC9pYTY0L2tlcm5lbC9pcnEuYw0KQEAg
LTIzLDYgKzIzLDggQEANCiAjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+DQogI2luY2x1ZGUg
PGxpbnV4L2tlcm5lbF9zdGF0Lmg+DQogDQorI2luY2x1ZGUgPGFzbS9tY2EuaD4NCisNCiAvKg0K
ICAqICd3aGF0IHNob3VsZCB3ZSBkbyBpZiB3ZSBnZXQgYSBodyBpcnEgZXZlbnQgb24gYW4gaWxs
ZWdhbCB2ZWN0b3InLg0KICAqIGVhY2ggYXJjaGl0ZWN0dXJlIGhhcyB0byBhbnN3ZXIgdGhpcyB0
aGVtc2VsdmVzLg0KQEAgLTgzLDYgKzg1LDEyIEBAIGJvb2wgaXNfYWZmaW5pdHlfbWFza192YWxp
ZChjb25zdCBzdHJ1Y3QgY3B1bWFzayAqY3B1bWFzaykNCiANCiAjZW5kaWYgLyogQ09ORklHX1NN
UCAqLw0KIA0KK2ludCBfX2luaXQgYXJjaF9lYXJseV9pcnFfaW5pdCh2b2lkKQ0KK3sNCisJaWE2
NF9tY2FfaXJxX2luaXQoKTsNCisJcmV0dXJuIDA7DQorfQ0KKw0KICNpZmRlZiBDT05GSUdfSE9U
UExVR19DUFUNCiB1bnNpZ25lZCBpbnQgdmVjdG9yc19pbl9taWdyYXRpb25bTlJfSVJRU107DQog
DQpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2tlcm5lbC9tY2EuYyBiL2FyY2gvaWE2NC9rZXJuZWwv
bWNhLmMNCmluZGV4IDg0ZmI0MDUuLjliOTczMDMgMTAwNjQ0DQotLS0gYS9hcmNoL2lhNjQva2Vy
bmVsL21jYS5jDQorKysgYi9hcmNoL2lhNjQva2VybmVsL21jYS5jDQpAQCAtMjA3MSwyMiArMjA3
MSwxNiBAQCBpYTY0X21jYV9pbml0KHZvaWQpDQogCXByaW50ayhLRVJOX0lORk8gIk1DQSByZWxh
dGVkIGluaXRpYWxpemF0aW9uIGRvbmVcbiIpOw0KIH0NCiANCisNCiAvKg0KLSAqIGlhNjRfbWNh
X2xhdGVfaW5pdA0KLSAqDQotICoJT3Bwb3J0dW5pdHkgdG8gc2V0dXAgdGhpbmdzIHRoYXQgcmVx
dWlyZSBpbml0aWFsaXphdGlvbiBsYXRlcg0KLSAqCXRoYW4gaWE2NF9tY2FfaW5pdC4gIFNldHVw
IGEgdGltZXIgdG8gcG9sbCBmb3IgQ1BFcyBpZiB0aGUNCi0gKglwbGF0Zm9ybSBkb2Vzbid0IHN1
cHBvcnQgYW4gaW50ZXJydXB0IGRyaXZlbiBtZWNoYW5pc20uDQotICoNCi0gKiAgSW5wdXRzICA6
ICAgTm9uZQ0KLSAqICBPdXRwdXRzIDogICBTdGF0dXMNCisgKiBUaGVzZSBwaWVjZXMgY2Fubm90
IGJlIGRvbmUgaW4gaWE2NF9tY2FfaW5pdCgpIGJlY2F1c2UgaXQgaXMgY2FsbGVkIGJlZm9yZQ0K
KyAqIGVhcmx5X2lycV9pbml0KCkgd2hpY2ggd291bGQgd2lwZSBvdXQgb3VyIHBlcmNwdSBpcnEg
cmVnaXN0cmF0aW9ucy4gQnV0IHdlDQorICogY2Fubm90IGxlYXZlIHRoZW0gdW50aWwgaWE2NF9t
Y2FfbGF0ZV9pbml0KCkgYmVjYXVzZSBieSB0aGVuIGFsbCB0aGUgb3RoZXINCisgKiBwcm9jZXNz
b3JzIGhhdmUgYmVlbiBicm91Z2h0IG9ubGluZSBhbmQgaGF2ZSBzZXQgdGhlaXIgb3duIENNQyB2
ZWN0b3JzIHRvDQorICogcG9pbnQgYXQgYSBub24tZXhpc3RhbnQgYWN0aW9uLiBDYWxsZWQgZnJv
bSBhcmNoX2Vhcmx5X2lycV9pbml0KCkuDQogICovDQotc3RhdGljIGludCBfX2luaXQNCi1pYTY0
X21jYV9sYXRlX2luaXQodm9pZCkNCit2b2lkIF9faW5pdCBpYTY0X21jYV9pcnFfaW5pdCh2b2lk
KQ0KIHsNCi0JaWYgKCFtY2FfaW5pdCkNCi0JCXJldHVybiAwOw0KLQ0KIAkvKg0KIAkgKiAgQ29u
ZmlndXJlIHRoZSBDTUNJL1AgdmVjdG9yIGFuZCBoYW5kbGVyLiBJbnRlcnJ1cHRzIGZvciBDTUMg
YXJlDQogCSAqICBwZXItcHJvY2Vzc29yLCBzbyBBUCBDTUMgaW50ZXJydXB0cyBhcmUgc2V0dXAg
aW4gc21wX2NhbGxpbigpIChzbXBib290LmMpLg0KQEAgLTIxMDUsNiArMjA5OSwyMyBAQCBpYTY0
X21jYV9sYXRlX2luaXQodm9pZCkNCiAJLyogU2V0dXAgdGhlIENQRUkvUCBoYW5kbGVyICovDQog
CXJlZ2lzdGVyX3BlcmNwdV9pcnEoSUE2NF9DUEVQX1ZFQ1RPUiwgJm1jYV9jcGVwX2lycWFjdGlv
bik7DQogI2VuZGlmDQorfQ0KKw0KKy8qDQorICogaWE2NF9tY2FfbGF0ZV9pbml0DQorICoNCisg
KglPcHBvcnR1bml0eSB0byBzZXR1cCB0aGluZ3MgdGhhdCByZXF1aXJlIGluaXRpYWxpemF0aW9u
IGxhdGVyDQorICoJdGhhbiBpYTY0X21jYV9pbml0LiAgU2V0dXAgYSB0aW1lciB0byBwb2xsIGZv
ciBDUEVzIGlmIHRoZQ0KKyAqCXBsYXRmb3JtIGRvZXNuJ3Qgc3VwcG9ydCBhbiBpbnRlcnJ1cHQg
ZHJpdmVuIG1lY2hhbmlzbS4NCisgKg0KKyAqICBJbnB1dHMgIDogICBOb25lDQorICogIE91dHB1
dHMgOiAgIFN0YXR1cw0KKyAqLw0KK3N0YXRpYyBpbnQgX19pbml0DQoraWE2NF9tY2FfbGF0ZV9p
bml0KHZvaWQpDQorew0KKwlpZiAoIW1jYV9pbml0KQ0KKwkJcmV0dXJuIDA7DQogDQogCXJlZ2lz
dGVyX2hvdGNwdV9ub3RpZmllcigmbWNhX2NwdV9ub3RpZmllcik7DQogDQpkaWZmIC0tZ2l0IGEv
YXJjaC9pYTY0L2t2bS92dGxiLmMgYi9hcmNoL2lhNjQva3ZtL3Z0bGIuYw0KaW5kZXggNDMzMmY3
ZS4uYTc4NjlmOCAxMDA2NDQNCi0tLSBhL2FyY2gvaWE2NC9rdm0vdnRsYi5jDQorKysgYi9hcmNo
L2lhNjQva3ZtL3Z0bGIuYw0KQEAgLTI1Niw3ICsyNTYsNyBAQCB1NjQgZ3Vlc3RfdmhwdF9sb29r
dXAodTY0IGloYSwgdTY0ICpwdGUpDQogCQkJInNybHouZDs7Ig0KIAkJCSJzc20gcHNyLmk7OyIN
CiAJCQkic3Jsei5kOzsiDQotCQkJOiAiPXIiKHJldCkgOiAiciIoaWhhKSwgInIiKHB0ZSk6Im1l
bW9yeSIpOw0KKwkJCTogIj0mciIocmV0KSA6ICJyIihpaGEpLCAiciIocHRlKSA6ICJtZW1vcnki
KTsNCiANCiAJcmV0dXJuIHJldDsNCiB9DQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5l
bC9oZWFkXzY0LlMgYi9hcmNoL3Bvd2VycGMva2VybmVsL2hlYWRfNjQuUw0KaW5kZXggY2RmNmIz
Zi4uMmM0OTIyNyAxMDA2NDQNCi0tLSBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvaGVhZF82NC5TDQor
KysgYi9hcmNoL3Bvd2VycGMva2VybmVsL2hlYWRfNjQuUw0KQEAgLTUwMiw2ICs1MDIsNyBAQCBf
R0xPQkFMKGNvcHlfYW5kX2ZsdXNoKQ0KIAlzeW5jDQogCWFkZGkJcjUscjUsOA0KIAlhZGRpCXI2
LHI2LDgNCisJaXN5bmMNCiAJYmxyDQogDQogLmFsaWduIDgNCmRpZmYgLS1naXQgYS9hcmNoL3Bv
d2VycGMvbW0vbnVtYS5jIGIvYXJjaC9wb3dlcnBjL21tL251bWEuYw0KaW5kZXggYjIyYTgzYS4u
MjQ1MjNkYyAxMDA2NDQNCi0tLSBhL2FyY2gvcG93ZXJwYy9tbS9udW1hLmMNCisrKyBiL2FyY2gv
cG93ZXJwYy9tbS9udW1hLmMNCkBAIC0yMjEsNyArMjIxLDcgQEAgaW50IF9fbm9kZV9kaXN0YW5j
ZShpbnQgYSwgaW50IGIpDQogCWludCBkaXN0YW5jZSA9IExPQ0FMX0RJU1RBTkNFOw0KIA0KIAlp
ZiAoIWZvcm0xX2FmZmluaXR5KQ0KLQkJcmV0dXJuIGRpc3RhbmNlOw0KKwkJcmV0dXJuICgoYSA9
PSBiKSA/IExPQ0FMX0RJU1RBTkNFIDogUkVNT1RFX0RJU1RBTkNFKTsNCiANCiAJZm9yIChpID0g
MDsgaSA8IGRpc3RhbmNlX3JlZl9wb2ludHNfZGVwdGg7IGkrKykgew0KIAkJaWYgKGRpc3RhbmNl
X2xvb2t1cF90YWJsZVthXVtpXSA9PSBkaXN0YW5jZV9sb29rdXBfdGFibGVbYl1baV0pDQpkaWZm
IC0tZ2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9jZWxsL3NwdWZzL2lub2RlLmMgYi9hcmNo
L3Bvd2VycGMvcGxhdGZvcm1zL2NlbGwvc3B1ZnMvaW5vZGUuYw0KaW5kZXggZTQ4MWY2Yi4uNzBl
YzRlOSAxMDA2NDQNCi0tLSBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2VsbC9zcHVmcy9pbm9k
ZS5jDQorKysgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2NlbGwvc3B1ZnMvaW5vZGUuYw0KQEAg
LTEwMCw2ICsxMDAsNyBAQCBzcHVmc19uZXdfaW5vZGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwg
aW50IG1vZGUpDQogCWlmICghaW5vZGUpDQogCQlnb3RvIG91dDsNCiANCisJaW5vZGUtPmlfaW5v
ID0gZ2V0X25leHRfaW5vKCk7DQogCWlub2RlLT5pX21vZGUgPSBtb2RlOw0KIAlpbm9kZS0+aV91
aWQgPSBjdXJyZW50X2ZzdWlkKCk7DQogCWlub2RlLT5pX2dpZCA9IGN1cnJlbnRfZnNnaWQoKTsN
CmRpZmYgLS1naXQgYS9hcmNoL3MzOTAvaW5jbHVkZS9hc20vcGd0YWJsZS5oIGIvYXJjaC9zMzkw
L2luY2x1ZGUvYXNtL3BndGFibGUuaA0KaW5kZXggNGYyODlmZi4uNWFhZjBiZiAxMDA2NDQNCi0t
LSBhL2FyY2gvczM5MC9pbmNsdWRlL2FzbS9wZ3RhYmxlLmgNCisrKyBiL2FyY2gvczM5MC9pbmNs
dWRlL2FzbS9wZ3RhYmxlLmgNCkBAIC02Nyw2ICs2NywxMCBAQCBzdGF0aWMgaW5saW5lIGludCBp
c196ZXJvX3Bmbih1bnNpZ25lZCBsb25nIHBmbikNCiANCiAjZGVmaW5lIG15X3plcm9fcGZuKGFk
ZHIpCXBhZ2VfdG9fcGZuKFpFUk9fUEFHRShhZGRyKSkNCiANCisvKiBUT0RPOiBzMzkwIGNhbm5v
dCBzdXBwb3J0IGlvX3JlbWFwX3Bmbl9yYW5nZS4uLiAqLw0KKyNkZWZpbmUgaW9fcmVtYXBfcGZu
X3JhbmdlKHZtYSwgdmFkZHIsIHBmbiwgc2l6ZSwgcHJvdCkgCSAgICAgICBcDQorCXJlbWFwX3Bm
bl9yYW5nZSh2bWEsIHZhZGRyLCBwZm4sIHNpemUsIHByb3QpDQorDQogI2VuZGlmIC8qICFfX0FT
U0VNQkxZX18gKi8NCiANCiAvKg0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20v
cGd0YWJsZV82NC5oIGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9wZ3RhYmxlXzY0LmgNCmluZGV4
IDM4ZWJiMmMuLmRkYmJlYTMgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL2luY2x1ZGUvYXNtL3Bn
dGFibGVfNjQuaA0KKysrIGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9wZ3RhYmxlXzY0LmgNCkBA
IC03ODEsNiArNzgxLDcgQEAgc3RhdGljIGlubGluZSBpbnQgaW9fcmVtYXBfcGZuX3JhbmdlKHN0
cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0KIAlyZXR1cm4gcmVtYXBfcGZuX3JhbmdlKHZtYSwg
ZnJvbSwgcGh5c19iYXNlID4+IFBBR0VfU0hJRlQsIHNpemUsIHByb3QpOw0KIH0NCiANCisjaW5j
bHVkZSA8YXNtL3RsYmZsdXNoLmg+DQogI2luY2x1ZGUgPGFzbS1nZW5lcmljL3BndGFibGUuaD4N
CiANCiAvKiBXZSBwcm92aWRlIG91ciBvd24gZ2V0X3VubWFwcGVkX2FyZWEgdG8gY29wZSB3aXRo
IFZBIGhvbGVzIGFuZA0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vc3lzdGVt
XzY0LmggYi9hcmNoL3NwYXJjL2luY2x1ZGUvYXNtL3N5c3RlbV82NC5oDQppbmRleCAxMGJjYWJj
Li5mODU2YzdmIDEwMDY0NA0KLS0tIGEvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9zeXN0ZW1fNjQu
aA0KKysrIGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9zeXN0ZW1fNjQuaA0KQEAgLTE0MCw4ICsx
NDAsNyBAQCBkbyB7CQkJCQkJXA0KIAkgKiBhbmQgMiBzdG9yZXMgaW4gdGhpcyBjcml0aWNhbCBj
b2RlIHBhdGguICAtRGF2ZU0NCiAJICovDQogI2RlZmluZSBzd2l0Y2hfdG8ocHJldiwgbmV4dCwg
bGFzdCkJCQkJCVwNCi1kbyB7CWZsdXNoX3RsYl9wZW5kaW5nKCk7CQkJCQkJXA0KLQlzYXZlX2Fu
ZF9jbGVhcl9mcHUoKTsJCQkJCQlcDQorZG8gewlzYXZlX2FuZF9jbGVhcl9mcHUoKTsJCQkJCQlc
DQogCS8qIElmIHlvdSBhcmUgdGVtcHRlZCB0byBjb25kaXRpb25hbGl6ZSB0aGUgZm9sbG93aW5n
ICovCVwNCiAJLyogc28gdGhhdCBBU0kgaXMgb25seSB3cml0dGVuIGlmIGl0IGNoYW5nZXMsIHRo
aW5rIGFnYWluLiAqLwlcDQogCV9fYXNtX18gX192b2xhdGlsZV9fKCJ3ciAlJWcwLCAlMCwgJSVh
c2kiCQkJXA0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vdGxiZmx1c2hfNjQu
aCBiL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vdGxiZmx1c2hfNjQuaA0KaW5kZXggMmVmNDYzNC4u
ZjBkNmE5NyAxMDA2NDQNCi0tLSBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vdGxiZmx1c2hfNjQu
aA0KKysrIGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS90bGJmbHVzaF82NC5oDQpAQCAtMTEsMjQg
KzExLDQwIEBADQogc3RydWN0IHRsYl9iYXRjaCB7DQogCXN0cnVjdCBtbV9zdHJ1Y3QgKm1tOw0K
IAl1bnNpZ25lZCBsb25nIHRsYl9ucjsNCisJdW5zaWduZWQgbG9uZyBhY3RpdmU7DQogCXVuc2ln
bmVkIGxvbmcgdmFkZHJzW1RMQl9CQVRDSF9OUl07DQogfTsNCiANCiBleHRlcm4gdm9pZCBmbHVz
aF90c2Jfa2VybmVsX3JhbmdlKHVuc2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5k
KTsNCiBleHRlcm4gdm9pZCBmbHVzaF90c2JfdXNlcihzdHJ1Y3QgdGxiX2JhdGNoICp0Yik7DQor
ZXh0ZXJuIHZvaWQgZmx1c2hfdHNiX3VzZXJfcGFnZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgdW5z
aWduZWQgbG9uZyB2YWRkcik7DQogDQogLyogVExCIGZsdXNoIG9wZXJhdGlvbnMuICovDQogDQot
ZXh0ZXJuIHZvaWQgZmx1c2hfdGxiX3BlbmRpbmcodm9pZCk7DQorc3RhdGljIGlubGluZSB2b2lk
IGZsdXNoX3RsYl9tbShzdHJ1Y3QgbW1fc3RydWN0ICptbSkNCit7DQorfQ0KKw0KK3N0YXRpYyBp
bmxpbmUgdm9pZCBmbHVzaF90bGJfcGFnZShzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwNCisJ
CQkJICB1bnNpZ25lZCBsb25nIHZtYWRkcikNCit7DQorfQ0KKw0KK3N0YXRpYyBpbmxpbmUgdm9p
ZCBmbHVzaF90bGJfcmFuZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsDQorCQkJCSAgIHVu
c2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kKQ0KK3sNCit9DQorDQorI2RlZmlu
ZSBfX0hBVkVfQVJDSF9FTlRFUl9MQVpZX01NVV9NT0RFDQogDQotI2RlZmluZSBmbHVzaF90bGJf
cmFuZ2Uodm1hLHN0YXJ0LGVuZCkJXA0KLQlkbyB7ICh2b2lkKShzdGFydCk7IGZsdXNoX3RsYl9w
ZW5kaW5nKCk7IH0gd2hpbGUgKDApDQotI2RlZmluZSBmbHVzaF90bGJfcGFnZSh2bWEsYWRkcikJ
Zmx1c2hfdGxiX3BlbmRpbmcoKQ0KLSNkZWZpbmUgZmx1c2hfdGxiX21tKG1tKQkJZmx1c2hfdGxi
X3BlbmRpbmcoKQ0KK2V4dGVybiB2b2lkIGZsdXNoX3RsYl9wZW5kaW5nKHZvaWQpOw0KK2V4dGVy
biB2b2lkIGFyY2hfZW50ZXJfbGF6eV9tbXVfbW9kZSh2b2lkKTsNCitleHRlcm4gdm9pZCBhcmNo
X2xlYXZlX2xhenlfbW11X21vZGUodm9pZCk7DQorI2RlZmluZSBhcmNoX2ZsdXNoX2xhenlfbW11
X21vZGUoKSAgICAgIGRvIHt9IHdoaWxlICgwKQ0KIA0KIC8qIExvY2FsIGNwdSBvbmx5LiAgKi8N
CiBleHRlcm4gdm9pZCBfX2ZsdXNoX3RsYl9hbGwodm9pZCk7DQotDQorZXh0ZXJuIHZvaWQgX19m
bHVzaF90bGJfcGFnZSh1bnNpZ25lZCBsb25nIGNvbnRleHQsIHVuc2lnbmVkIGxvbmcgdmFkZHIp
Ow0KIGV4dGVybiB2b2lkIF9fZmx1c2hfdGxiX2tlcm5lbF9yYW5nZSh1bnNpZ25lZCBsb25nIHN0
YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCk7DQogDQogI2lmbmRlZiBDT05GSUdfU01QDQpAQCAtMzgs
MTUgKzU0LDI0IEBAIGRvIHsJZmx1c2hfdHNiX2tlcm5lbF9yYW5nZShzdGFydCxlbmQpOyBcDQog
CV9fZmx1c2hfdGxiX2tlcm5lbF9yYW5nZShzdGFydCxlbmQpOyBcDQogfSB3aGlsZSAoMCkNCiAN
CitzdGF0aWMgaW5saW5lIHZvaWQgZ2xvYmFsX2ZsdXNoX3RsYl9wYWdlKHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tLCB1bnNpZ25lZCBsb25nIHZhZGRyKQ0KK3sNCisJX19mbHVzaF90bGJfcGFnZShDVFhf
SFdCSVRTKG1tLT5jb250ZXh0KSwgdmFkZHIpOw0KK30NCisNCiAjZWxzZSAvKiBDT05GSUdfU01Q
ICovDQogDQogZXh0ZXJuIHZvaWQgc21wX2ZsdXNoX3RsYl9rZXJuZWxfcmFuZ2UodW5zaWduZWQg
bG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyBlbmQpOw0KK2V4dGVybiB2b2lkIHNtcF9mbHVzaF90
bGJfcGFnZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgdW5zaWduZWQgbG9uZyB2YWRkcik7DQogDQog
I2RlZmluZSBmbHVzaF90bGJfa2VybmVsX3JhbmdlKHN0YXJ0LCBlbmQpIFwNCiBkbyB7CWZsdXNo
X3RzYl9rZXJuZWxfcmFuZ2Uoc3RhcnQsZW5kKTsgXA0KIAlzbXBfZmx1c2hfdGxiX2tlcm5lbF9y
YW5nZShzdGFydCwgZW5kKTsgXA0KIH0gd2hpbGUgKDApDQogDQorI2RlZmluZSBnbG9iYWxfZmx1
c2hfdGxiX3BhZ2UobW0sIHZhZGRyKSBcDQorCXNtcF9mbHVzaF90bGJfcGFnZShtbSwgdmFkZHIp
DQorDQogI2VuZGlmIC8qICEgQ09ORklHX1NNUCAqLw0KIA0KICNlbmRpZiAvKiBfU1BBUkM2NF9U
TEJGTFVTSF9IICovDQpkaWZmIC0tZ2l0IGEvYXJjaC9zcGFyYy9rZXJuZWwvc21wXzY0LmMgYi9h
cmNoL3NwYXJjL2tlcm5lbC9zbXBfNjQuYw0KaW5kZXggNzU2MDc3Mi4uZTIxZDNjMGQgMTAwNjQ0
DQotLS0gYS9hcmNoL3NwYXJjL2tlcm5lbC9zbXBfNjQuYw0KKysrIGIvYXJjaC9zcGFyYy9rZXJu
ZWwvc21wXzY0LmMNCkBAIC04NTYsNyArODU2LDcgQEAgdm9pZCBzbXBfdHNiX3N5bmMoc3RydWN0
IG1tX3N0cnVjdCAqbW0pDQogfQ0KIA0KIGV4dGVybiB1bnNpZ25lZCBsb25nIHhjYWxsX2ZsdXNo
X3RsYl9tbTsNCi1leHRlcm4gdW5zaWduZWQgbG9uZyB4Y2FsbF9mbHVzaF90bGJfcGVuZGluZzsN
CitleHRlcm4gdW5zaWduZWQgbG9uZyB4Y2FsbF9mbHVzaF90bGJfcGFnZTsNCiBleHRlcm4gdW5z
aWduZWQgbG9uZyB4Y2FsbF9mbHVzaF90bGJfa2VybmVsX3JhbmdlOw0KIGV4dGVybiB1bnNpZ25l
ZCBsb25nIHhjYWxsX2ZldGNoX2dsb2JfcmVnczsNCiBleHRlcm4gdW5zaWduZWQgbG9uZyB4Y2Fs
bF9yZWNlaXZlX3NpZ25hbDsNCkBAIC0xMDcwLDIzICsxMDcwLDU2IEBAIGxvY2FsX2ZsdXNoX2Fu
ZF9vdXQ6DQogCXB1dF9jcHUoKTsNCiB9DQogDQorc3RydWN0IHRsYl9wZW5kaW5nX2luZm8gew0K
Kwl1bnNpZ25lZCBsb25nIGN0eDsNCisJdW5zaWduZWQgbG9uZyBucjsNCisJdW5zaWduZWQgbG9u
ZyAqdmFkZHJzOw0KK307DQorDQorc3RhdGljIHZvaWQgdGxiX3BlbmRpbmdfZnVuYyh2b2lkICpp
bmZvKQ0KK3sNCisJc3RydWN0IHRsYl9wZW5kaW5nX2luZm8gKnQgPSBpbmZvOw0KKw0KKwlfX2Zs
dXNoX3RsYl9wZW5kaW5nKHQtPmN0eCwgdC0+bnIsIHQtPnZhZGRycyk7DQorfQ0KKw0KIHZvaWQg
c21wX2ZsdXNoX3RsYl9wZW5kaW5nKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCB1bnNpZ25lZCBsb25n
IG5yLCB1bnNpZ25lZCBsb25nICp2YWRkcnMpDQogew0KIAl1MzIgY3R4ID0gQ1RYX0hXQklUUyht
bS0+Y29udGV4dCk7DQorCXN0cnVjdCB0bGJfcGVuZGluZ19pbmZvIGluZm87DQogCWludCBjcHUg
PSBnZXRfY3B1KCk7DQogDQorCWluZm8uY3R4ID0gY3R4Ow0KKwlpbmZvLm5yID0gbnI7DQorCWlu
Zm8udmFkZHJzID0gdmFkZHJzOw0KKw0KIAlpZiAobW0gPT0gY3VycmVudC0+bW0gJiYgYXRvbWlj
X3JlYWQoJm1tLT5tbV91c2VycykgPT0gMSkNCiAJCWNwdW1hc2tfY29weShtbV9jcHVtYXNrKG1t
KSwgY3B1bWFza19vZihjcHUpKTsNCiAJZWxzZQ0KLQkJc21wX2Nyb3NzX2NhbGxfbWFza2VkKCZ4
Y2FsbF9mbHVzaF90bGJfcGVuZGluZywNCi0JCQkJICAgICAgY3R4LCBuciwgKHVuc2lnbmVkIGxv
bmcpIHZhZGRycywNCi0JCQkJICAgICAgbW1fY3B1bWFzayhtbSkpOw0KKwkJc21wX2NhbGxfZnVu
Y3Rpb25fbWFueShtbV9jcHVtYXNrKG1tKSwgdGxiX3BlbmRpbmdfZnVuYywNCisJCQkJICAgICAg
ICZpbmZvLCAxKTsNCiANCiAJX19mbHVzaF90bGJfcGVuZGluZyhjdHgsIG5yLCB2YWRkcnMpOw0K
IA0KIAlwdXRfY3B1KCk7DQogfQ0KIA0KK3ZvaWQgc21wX2ZsdXNoX3RsYl9wYWdlKHN0cnVjdCBt
bV9zdHJ1Y3QgKm1tLCB1bnNpZ25lZCBsb25nIHZhZGRyKQ0KK3sNCisJdW5zaWduZWQgbG9uZyBj
b250ZXh0ID0gQ1RYX0hXQklUUyhtbS0+Y29udGV4dCk7DQorCWludCBjcHUgPSBnZXRfY3B1KCk7
DQorDQorCWlmIChtbSA9PSBjdXJyZW50LT5tbSAmJiBhdG9taWNfcmVhZCgmbW0tPm1tX3VzZXJz
KSA9PSAxKQ0KKwkJY3B1bWFza19jb3B5KG1tX2NwdW1hc2sobW0pLCBjcHVtYXNrX29mKGNwdSkp
Ow0KKwllbHNlDQorCQlzbXBfY3Jvc3NfY2FsbF9tYXNrZWQoJnhjYWxsX2ZsdXNoX3RsYl9wYWdl
LA0KKwkJCQkgICAgICBjb250ZXh0LCB2YWRkciwgMCwNCisJCQkJICAgICAgbW1fY3B1bWFzayht
bSkpOw0KKwlfX2ZsdXNoX3RsYl9wYWdlKGNvbnRleHQsIHZhZGRyKTsNCisNCisJcHV0X2NwdSgp
Ow0KK30NCisNCiB2b2lkIHNtcF9mbHVzaF90bGJfa2VybmVsX3JhbmdlKHVuc2lnbmVkIGxvbmcg
c3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kKQ0KIHsNCiAJc3RhcnQgJj0gUEFHRV9NQVNLOw0KZGlm
ZiAtLWdpdCBhL2FyY2gvc3BhcmMvbW0vdGxiLmMgYi9hcmNoL3NwYXJjL21tL3RsYi5jDQppbmRl
eCBiMWYyNzljLi5hZmQwMjFlIDEwMDY0NA0KLS0tIGEvYXJjaC9zcGFyYy9tbS90bGIuYw0KKysr
IGIvYXJjaC9zcGFyYy9tbS90bGIuYw0KQEAgLTI0LDExICsyNCwxNyBAQCBzdGF0aWMgREVGSU5F
X1BFUl9DUFUoc3RydWN0IHRsYl9iYXRjaCwgdGxiX2JhdGNoKTsNCiB2b2lkIGZsdXNoX3RsYl9w
ZW5kaW5nKHZvaWQpDQogew0KIAlzdHJ1Y3QgdGxiX2JhdGNoICp0YiA9ICZnZXRfY3B1X3Zhcih0
bGJfYmF0Y2gpOw0KKwlzdHJ1Y3QgbW1fc3RydWN0ICptbSA9IHRiLT5tbTsNCiANCi0JaWYgKHRi
LT50bGJfbnIpIHsNCi0JCWZsdXNoX3RzYl91c2VyKHRiKTsNCisJaWYgKCF0Yi0+dGxiX25yKQ0K
KwkJZ290byBvdXQ7DQogDQotCQlpZiAoQ1RYX1ZBTElEKHRiLT5tbS0+Y29udGV4dCkpIHsNCisJ
Zmx1c2hfdHNiX3VzZXIodGIpOw0KKw0KKwlpZiAoQ1RYX1ZBTElEKG1tLT5jb250ZXh0KSkgew0K
KwkJaWYgKHRiLT50bGJfbnIgPT0gMSkgew0KKwkJCWdsb2JhbF9mbHVzaF90bGJfcGFnZShtbSwg
dGItPnZhZGRyc1swXSk7DQorCQl9IGVsc2Ugew0KICNpZmRlZiBDT05GSUdfU01QDQogCQkJc21w
X2ZsdXNoX3RsYl9wZW5kaW5nKHRiLT5tbSwgdGItPnRsYl9uciwNCiAJCQkJCSAgICAgICZ0Yi0+
dmFkZHJzWzBdKTsNCkBAIC0zNywxMiArNDMsMzAgQEAgdm9pZCBmbHVzaF90bGJfcGVuZGluZyh2
b2lkKQ0KIAkJCQkJICAgIHRiLT50bGJfbnIsICZ0Yi0+dmFkZHJzWzBdKTsNCiAjZW5kaWYNCiAJ
CX0NCi0JCXRiLT50bGJfbnIgPSAwOw0KIAl9DQogDQorCXRiLT50bGJfbnIgPSAwOw0KKw0KK291
dDoNCiAJcHV0X2NwdV92YXIodGxiX2JhdGNoKTsNCiB9DQogDQordm9pZCBhcmNoX2VudGVyX2xh
enlfbW11X21vZGUodm9pZCkNCit7DQorCXN0cnVjdCB0bGJfYmF0Y2ggKnRiID0gJl9fZ2V0X2Nw
dV92YXIodGxiX2JhdGNoKTsNCisNCisJdGItPmFjdGl2ZSA9IDE7DQorfQ0KKw0KK3ZvaWQgYXJj
aF9sZWF2ZV9sYXp5X21tdV9tb2RlKHZvaWQpDQorew0KKwlzdHJ1Y3QgdGxiX2JhdGNoICp0YiA9
ICZfX2dldF9jcHVfdmFyKHRsYl9iYXRjaCk7DQorDQorCWlmICh0Yi0+dGxiX25yKQ0KKwkJZmx1
c2hfdGxiX3BlbmRpbmcoKTsNCisJdGItPmFjdGl2ZSA9IDA7DQorfQ0KKw0KIHZvaWQgdGxiX2Jh
dGNoX2FkZChzdHJ1Y3QgbW1fc3RydWN0ICptbSwgdW5zaWduZWQgbG9uZyB2YWRkciwNCiAJCSAg
IHB0ZV90ICpwdGVwLCBwdGVfdCBvcmlnLCBpbnQgZnVsbG1tKQ0KIHsNCkBAIC05MCw2ICsxMTQs
MTIgQEAgbm9fY2FjaGVfZmx1c2g6DQogCQluciA9IDA7DQogCX0NCiANCisJaWYgKCF0Yi0+YWN0
aXZlKSB7DQorCQlnbG9iYWxfZmx1c2hfdGxiX3BhZ2UobW0sIHZhZGRyKTsNCisJCWZsdXNoX3Rz
Yl91c2VyX3BhZ2UobW0sIHZhZGRyKTsNCisJCWdvdG8gb3V0Ow0KKwl9DQorDQogCWlmIChuciA9
PSAwKQ0KIAkJdGItPm1tID0gbW07DQogDQpAQCAtOTgsNSArMTI4LDYgQEAgbm9fY2FjaGVfZmx1
c2g6DQogCWlmIChuciA+PSBUTEJfQkFUQ0hfTlIpDQogCQlmbHVzaF90bGJfcGVuZGluZygpOw0K
IA0KK291dDoNCiAJcHV0X2NwdV92YXIodGxiX2JhdGNoKTsNCiB9DQpkaWZmIC0tZ2l0IGEvYXJj
aC9zcGFyYy9tbS90c2IuYyBiL2FyY2gvc3BhcmMvbW0vdHNiLmMNCmluZGV4IDUzNjQxMmQuLjNl
YmNhYzcgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL21tL3RzYi5jDQorKysgYi9hcmNoL3NwYXJj
L21tL3RzYi5jDQpAQCAtOCwxMSArOCwxMCBAQA0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQog
I2luY2x1ZGUgPGFzbS9zeXN0ZW0uaD4NCiAjaW5jbHVkZSA8YXNtL3BhZ2UuaD4NCi0jaW5jbHVk
ZSA8YXNtL3RsYmZsdXNoLmg+DQotI2luY2x1ZGUgPGFzbS90bGIuaD4NCi0jaW5jbHVkZSA8YXNt
L21tdV9jb250ZXh0Lmg+DQogI2luY2x1ZGUgPGFzbS9wZ3RhYmxlLmg+DQorI2luY2x1ZGUgPGFz
bS9tbXVfY29udGV4dC5oPg0KICNpbmNsdWRlIDxhc20vdHNiLmg+DQorI2luY2x1ZGUgPGFzbS90
bGIuaD4NCiAjaW5jbHVkZSA8YXNtL29wbGliLmg+DQogDQogZXh0ZXJuIHN0cnVjdCB0c2Igc3dh
cHBlcl90c2JbS0VSTkVMX1RTQl9ORU5UUklFU107DQpAQCAtNDcsMjMgKzQ2LDI3IEBAIHZvaWQg
Zmx1c2hfdHNiX2tlcm5lbF9yYW5nZSh1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNpZ25lZCBsb25n
IGVuZCkNCiAJfQ0KIH0NCiANCi1zdGF0aWMgdm9pZCBfX2ZsdXNoX3RzYl9vbmUoc3RydWN0IHRs
Yl9iYXRjaCAqdGIsIHVuc2lnbmVkIGxvbmcgaGFzaF9zaGlmdCwNCi0JCQkgICAgdW5zaWduZWQg
bG9uZyB0c2IsIHVuc2lnbmVkIGxvbmcgbmVudHJpZXMpDQorc3RhdGljIHZvaWQgX19mbHVzaF90
c2Jfb25lX2VudHJ5KHVuc2lnbmVkIGxvbmcgdHNiLCB1bnNpZ25lZCBsb25nIHYsDQorCQkJCSAg
dW5zaWduZWQgbG9uZyBoYXNoX3NoaWZ0LA0KKwkJCQkgIHVuc2lnbmVkIGxvbmcgbmVudHJpZXMp
DQogew0KLQl1bnNpZ25lZCBsb25nIGk7DQorCXVuc2lnbmVkIGxvbmcgdGFnLCBlbnQsIGhhc2g7
DQogDQotCWZvciAoaSA9IDA7IGkgPCB0Yi0+dGxiX25yOyBpKyspIHsNCi0JCXVuc2lnbmVkIGxv
bmcgdiA9IHRiLT52YWRkcnNbaV07DQotCQl1bnNpZ25lZCBsb25nIHRhZywgZW50LCBoYXNoOw0K
Kwl2ICY9IH4weDFVTDsNCisJaGFzaCA9IHRzYl9oYXNoKHYsIGhhc2hfc2hpZnQsIG5lbnRyaWVz
KTsNCisJZW50ID0gdHNiICsgKGhhc2ggKiBzaXplb2Yoc3RydWN0IHRzYikpOw0KKwl0YWcgPSAo
diA+PiAyMlVMKTsNCiANCi0JCXYgJj0gfjB4MVVMOw0KKwl0c2JfZmx1c2goZW50LCB0YWcpOw0K
K30NCiANCi0JCWhhc2ggPSB0c2JfaGFzaCh2LCBoYXNoX3NoaWZ0LCBuZW50cmllcyk7DQotCQll
bnQgPSB0c2IgKyAoaGFzaCAqIHNpemVvZihzdHJ1Y3QgdHNiKSk7DQotCQl0YWcgPSAodiA+PiAy
MlVMKTsNCitzdGF0aWMgdm9pZCBfX2ZsdXNoX3RzYl9vbmUoc3RydWN0IHRsYl9iYXRjaCAqdGIs
IHVuc2lnbmVkIGxvbmcgaGFzaF9zaGlmdCwNCisJCQkgICAgdW5zaWduZWQgbG9uZyB0c2IsIHVu
c2lnbmVkIGxvbmcgbmVudHJpZXMpDQorew0KKwl1bnNpZ25lZCBsb25nIGk7DQogDQotCQl0c2Jf
Zmx1c2goZW50LCB0YWcpOw0KLQl9DQorCWZvciAoaSA9IDA7IGkgPCB0Yi0+dGxiX25yOyBpKysp
DQorCQlfX2ZsdXNoX3RzYl9vbmVfZW50cnkodHNiLCB0Yi0+dmFkZHJzW2ldLCBoYXNoX3NoaWZ0
LCBuZW50cmllcyk7DQogfQ0KIA0KIHZvaWQgZmx1c2hfdHNiX3VzZXIoc3RydWN0IHRsYl9iYXRj
aCAqdGIpDQpAQCAtOTEsNiArOTQsMzAgQEAgdm9pZCBmbHVzaF90c2JfdXNlcihzdHJ1Y3QgdGxi
X2JhdGNoICp0YikNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmbW0tPmNvbnRleHQubG9jaywg
ZmxhZ3MpOw0KIH0NCiANCit2b2lkIGZsdXNoX3RzYl91c2VyX3BhZ2Uoc3RydWN0IG1tX3N0cnVj
dCAqbW0sIHVuc2lnbmVkIGxvbmcgdmFkZHIpDQorew0KKwl1bnNpZ25lZCBsb25nIG5lbnRyaWVz
LCBiYXNlLCBmbGFnczsNCisNCisJc3Bpbl9sb2NrX2lycXNhdmUoJm1tLT5jb250ZXh0LmxvY2ss
IGZsYWdzKTsNCisNCisJYmFzZSA9ICh1bnNpZ25lZCBsb25nKSBtbS0+Y29udGV4dC50c2JfYmxv
Y2tbTU1fVFNCX0JBU0VdLnRzYjsNCisJbmVudHJpZXMgPSBtbS0+Y29udGV4dC50c2JfYmxvY2tb
TU1fVFNCX0JBU0VdLnRzYl9uZW50cmllczsNCisJaWYgKHRsYl90eXBlID09IGNoZWV0YWhfcGx1
cyB8fCB0bGJfdHlwZSA9PSBoeXBlcnZpc29yKQ0KKwkJYmFzZSA9IF9fcGEoYmFzZSk7DQorCV9f
Zmx1c2hfdHNiX29uZV9lbnRyeShiYXNlLCB2YWRkciwgUEFHRV9TSElGVCwgbmVudHJpZXMpOw0K
Kw0KKyNpZiBkZWZpbmVkKENPTkZJR19IVUdFVExCX1BBR0UpIHx8IGRlZmluZWQoQ09ORklHX1RS
QU5TUEFSRU5UX0hVR0VQQUdFKQ0KKwlpZiAobW0tPmNvbnRleHQudHNiX2Jsb2NrW01NX1RTQl9I
VUdFXS50c2IpIHsNCisJCWJhc2UgPSAodW5zaWduZWQgbG9uZykgbW0tPmNvbnRleHQudHNiX2Js
b2NrW01NX1RTQl9IVUdFXS50c2I7DQorCQluZW50cmllcyA9IG1tLT5jb250ZXh0LnRzYl9ibG9j
a1tNTV9UU0JfSFVHRV0udHNiX25lbnRyaWVzOw0KKwkJaWYgKHRsYl90eXBlID09IGNoZWV0YWhf
cGx1cyB8fCB0bGJfdHlwZSA9PSBoeXBlcnZpc29yKQ0KKwkJCWJhc2UgPSBfX3BhKGJhc2UpOw0K
KwkJX19mbHVzaF90c2Jfb25lX2VudHJ5KGJhc2UsIHZhZGRyLCBIUEFHRV9TSElGVCwgbmVudHJp
ZXMpOw0KKwl9DQorI2VuZGlmDQorCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1tLT5jb250ZXh0
LmxvY2ssIGZsYWdzKTsNCit9DQorDQogI2lmIGRlZmluZWQoQ09ORklHX1NQQVJDNjRfUEFHRV9T
SVpFXzhLQikNCiAjZGVmaW5lIEhWX1BHU1pfSURYX0JBU0UJSFZfUEdTWl9JRFhfOEsNCiAjZGVm
aW5lIEhWX1BHU1pfTUFTS19CQVNFCUhWX1BHU1pfTUFTS184Sw0KZGlmZiAtLWdpdCBhL2FyY2gv
c3BhcmMvbW0vdWx0cmEuUyBiL2FyY2gvc3BhcmMvbW0vdWx0cmEuUw0KaW5kZXggODc0MTYyYS4u
ZGQxMGNhYSAxMDA2NDQNCi0tLSBhL2FyY2gvc3BhcmMvbW0vdWx0cmEuUw0KKysrIGIvYXJjaC9z
cGFyYy9tbS91bHRyYS5TDQpAQCAtNTMsNiArNTMsMzMgQEAgX19mbHVzaF90bGJfbW06CQkvKiAx
OCBpbnNucyAqLw0KIAlub3ANCiANCiAJLmFsaWduCQkzMg0KKwkuZ2xvYmwJCV9fZmx1c2hfdGxi
X3BhZ2UNCitfX2ZsdXNoX3RsYl9wYWdlOgkvKiAyMiBpbnNucyAqLw0KKwkvKiAlbzAgPSBjb250
ZXh0LCAlbzEgPSB2YWRkciAqLw0KKwlyZHByCQklcHN0YXRlLCAlZzcNCisJYW5kbgkJJWc3LCBQ
U1RBVEVfSUUsICVnMg0KKwl3cnByCQklZzIsICVwc3RhdGUNCisJbW92CQlTRUNPTkRBUllfQ09O
VEVYVCwgJW80DQorCWxkeGEJCVslbzRdIEFTSV9ETU1VLCAlZzINCisJc3R4YQkJJW8wLCBbJW80
XSBBU0lfRE1NVQ0KKwlhbmRjYwkJJW8xLCAxLCAlZzANCisJYW5kbgkJJW8xLCAxLCAlbzMNCisJ
YmUscG4JCSVpY2MsIDFmDQorCSBvcgkJJW8zLCAweDEwLCAlbzMNCisJc3R4YQkJJWcwLCBbJW8z
XSBBU0lfSU1NVV9ERU1BUA0KKzE6CXN0eGEJCSVnMCwgWyVvM10gQVNJX0RNTVVfREVNQVANCisJ
bWVtYmFyCQkjU3luYw0KKwlzdHhhCQklZzIsIFslbzRdIEFTSV9ETU1VDQorCXNldGhpCQklaGko
S0VSTkJBU0UpLCAlbzQNCisJZmx1c2gJCSVvNA0KKwlyZXRsDQorCSB3cnByCQklZzcsIDB4MCwg
JXBzdGF0ZQ0KKwlub3ANCisJbm9wDQorCW5vcA0KKwlub3ANCisNCisJLmFsaWduCQkzMg0KIAku
Z2xvYmwJCV9fZmx1c2hfdGxiX3BlbmRpbmcNCiBfX2ZsdXNoX3RsYl9wZW5kaW5nOgkvKiAyNiBp
bnNucyAqLw0KIAkvKiAlbzAgPSBjb250ZXh0LCAlbzEgPSBuciwgJW8yID0gdmFkZHJzW10gKi8N
CkBAIC0yMDMsNiArMjMwLDMxIEBAIF9fY2hlZXRhaF9mbHVzaF90bGJfbW06IC8qIDE5IGluc25z
ICovDQogCXJldGwNCiAJIHdycHIJCSVnNywgMHgwLCAlcHN0YXRlDQogDQorX19jaGVldGFoX2Zs
dXNoX3RsYl9wYWdlOgkvKiAyMiBpbnNucyAqLw0KKwkvKiAlbzAgPSBjb250ZXh0LCAlbzEgPSB2
YWRkciAqLw0KKwlyZHByCQklcHN0YXRlLCAlZzcNCisJYW5kbgkJJWc3LCBQU1RBVEVfSUUsICVn
Mg0KKwl3cnByCQklZzIsIDB4MCwgJXBzdGF0ZQ0KKwl3cnByCQklZzAsIDEsICV0bA0KKwltb3YJ
CVBSSU1BUllfQ09OVEVYVCwgJW80DQorCWxkeGEJCVslbzRdIEFTSV9ETU1VLCAlZzINCisJc3Js
eAkJJWcyLCBDVFhfUEdTWjFfTlVDX1NISUZULCAlbzMNCisJc2xseAkJJW8zLCBDVFhfUEdTWjFf
TlVDX1NISUZULCAlbzMNCisJb3IJCSVvMCwgJW8zLCAlbzAJLyogUHJlc2VydmUgbnVjbGV1cyBw
YWdlIHNpemUgZmllbGRzICovDQorCXN0eGEJCSVvMCwgWyVvNF0gQVNJX0RNTVUNCisJYW5kY2MJ
CSVvMSwgMSwgJWcwDQorCWJlLHBuCQklaWNjLCAxZg0KKwkgYW5kbgkJJW8xLCAxLCAlbzMNCisJ
c3R4YQkJJWcwLCBbJW8zXSBBU0lfSU1NVV9ERU1BUA0KKzE6CXN0eGEJCSVnMCwgWyVvM10gQVNJ
X0RNTVVfREVNQVANCisJbWVtYmFyCQkjU3luYw0KKwlzdHhhCQklZzIsIFslbzRdIEFTSV9ETU1V
DQorCXNldGhpCQklaGkoS0VSTkJBU0UpLCAlbzQNCisJZmx1c2gJCSVvNA0KKwl3cnByCQklZzAs
IDAsICV0bA0KKwlyZXRsDQorCSB3cnByCQklZzcsIDB4MCwgJXBzdGF0ZQ0KKw0KIF9fY2hlZXRh
aF9mbHVzaF90bGJfcGVuZGluZzoJLyogMjcgaW5zbnMgKi8NCiAJLyogJW8wID0gY29udGV4dCwg
JW8xID0gbnIsICVvMiA9IHZhZGRyc1tdICovDQogCXJkcHIJCSVwc3RhdGUsICVnNw0KQEAgLTI2
OSw2ICszMjEsMjAgQEAgX19oeXBlcnZpc29yX2ZsdXNoX3RsYl9tbTogLyogMTAgaW5zbnMgKi8N
CiAJcmV0bA0KIAkgbm9wDQogDQorX19oeXBlcnZpc29yX2ZsdXNoX3RsYl9wYWdlOiAvKiAxMSBp
bnNucyAqLw0KKwkvKiAlbzAgPSBjb250ZXh0LCAlbzEgPSB2YWRkciAqLw0KKwltb3YJCSVvMCwg
JWcyDQorCW1vdgkJJW8xLCAlbzAgICAgICAgICAgICAgIC8qIEFSRzA6IHZhZGRyICsgSU1NVS1i
aXQgKi8NCisJbW92CQklZzIsICVvMQkgICAgICAvKiBBUkcxOiBtbXUgY29udGV4dCAqLw0KKwlt
b3YJCUhWX01NVV9BTEwsICVvMgkgICAgICAvKiBBUkcyOiBmbGFncyAqLw0KKwlzcmx4CQklbzAs
IFBBR0VfU0hJRlQsICVvMA0KKwlzbGx4CQklbzAsIFBBR0VfU0hJRlQsICVvMA0KKwl0YQkJSFZf
TU1VX1VOTUFQX0FERFJfVFJBUA0KKwlicm56LHBuCQklbzAsIF9faHlwZXJ2aXNvcl90bGJfdGww
X2Vycm9yDQorCSBtb3YJCUhWX01NVV9VTk1BUF9BRERSX1RSQVAsICVvMQ0KKwlyZXRsDQorCSBu
b3ANCisNCiBfX2h5cGVydmlzb3JfZmx1c2hfdGxiX3BlbmRpbmc6IC8qIDE2IGluc25zICovDQog
CS8qICVvMCA9IGNvbnRleHQsICVvMSA9IG5yLCAlbzIgPSB2YWRkcnNbXSAqLw0KIAlzbGx4CQkl
bzEsIDMsICVnMQ0KQEAgLTMzOSw2ICs0MDUsMTMgQEAgY2hlZXRhaF9wYXRjaF9jYWNoZXRsYm9w
czoNCiAJY2FsbAkJdGxiX3BhdGNoX29uZQ0KIAkgbW92CQkxOSwgJW8yDQogDQorCXNldGhpCQkl
aGkoX19mbHVzaF90bGJfcGFnZSksICVvMA0KKwlvcgkJJW8wLCAlbG8oX19mbHVzaF90bGJfcGFn
ZSksICVvMA0KKwlzZXRoaQkJJWhpKF9fY2hlZXRhaF9mbHVzaF90bGJfcGFnZSksICVvMQ0KKwlv
cgkJJW8xLCAlbG8oX19jaGVldGFoX2ZsdXNoX3RsYl9wYWdlKSwgJW8xDQorCWNhbGwJCXRsYl9w
YXRjaF9vbmUNCisJIG1vdgkJMjIsICVvMg0KKw0KIAlzZXRoaQkJJWhpKF9fZmx1c2hfdGxiX3Bl
bmRpbmcpLCAlbzANCiAJb3IJCSVvMCwgJWxvKF9fZmx1c2hfdGxiX3BlbmRpbmcpLCAlbzANCiAJ
c2V0aGkJCSVoaShfX2NoZWV0YWhfZmx1c2hfdGxiX3BlbmRpbmcpLCAlbzENCkBAIC0zOTcsMTAg
KzQ3MCw5IEBAIHhjYWxsX2ZsdXNoX3RsYl9tbToJLyogMjEgaW5zbnMgKi8NCiAJbm9wDQogCW5v
cA0KIA0KLQkuZ2xvYmwJCXhjYWxsX2ZsdXNoX3RsYl9wZW5kaW5nDQoteGNhbGxfZmx1c2hfdGxi
X3BlbmRpbmc6CS8qIDIxIGluc25zICovDQotCS8qICVnNT1jb250ZXh0LCAlZzE9bnIsICVnNz12
YWRkcnNbXSAqLw0KLQlzbGx4CQklZzEsIDMsICVnMQ0KKwkuZ2xvYmwJCXhjYWxsX2ZsdXNoX3Rs
Yl9wYWdlDQoreGNhbGxfZmx1c2hfdGxiX3BhZ2U6CS8qIDE3IGluc25zICovDQorCS8qICVnNT1j
b250ZXh0LCAlZzE9dmFkZHIgKi8NCiAJbW92CQlQUklNQVJZX0NPTlRFWFQsICVnNA0KIAlsZHhh
CQlbJWc0XSBBU0lfRE1NVSwgJWcyDQogCXNybHgJCSVnMiwgQ1RYX1BHU1oxX05VQ19TSElGVCwg
JWc0DQpAQCAtNDA4LDIwICs0ODAsMTYgQEAgeGNhbGxfZmx1c2hfdGxiX3BlbmRpbmc6CS8qIDIx
IGluc25zICovDQogCW9yCQklZzUsICVnNCwgJWc1DQogCW1vdgkJUFJJTUFSWV9DT05URVhULCAl
ZzQNCiAJc3R4YQkJJWc1LCBbJWc0XSBBU0lfRE1NVQ0KLTE6CXN1YgkJJWcxLCAoMSA8PCAzKSwg
JWcxDQotCWxkeAkJWyVnNyArICVnMV0sICVnNQ0KLQlhbmRjYwkJJWc1LCAweDEsICVnMA0KKwlh
bmRjYwkJJWcxLCAweDEsICVnMA0KIAliZSxwbgkJJWljYywgMmYNCi0NCi0JIGFuZG4JCSVnNSwg
MHgxLCAlZzUNCisJIGFuZG4JCSVnMSwgMHgxLCAlZzUNCiAJc3R4YQkJJWcwLCBbJWc1XSBBU0lf
SU1NVV9ERU1BUA0KIDI6CXN0eGEJCSVnMCwgWyVnNV0gQVNJX0RNTVVfREVNQVANCiAJbWVtYmFy
CQkjU3luYw0KLQlicm56LHB0CQklZzEsIDFiDQotCSBub3ANCiAJc3R4YQkJJWcyLCBbJWc0XSBB
U0lfRE1NVQ0KIAlyZXRyeQ0KIAlub3ANCisJbm9wDQogDQogCS5nbG9ibAkJeGNhbGxfZmx1c2hf
dGxiX2tlcm5lbF9yYW5nZQ0KIHhjYWxsX2ZsdXNoX3RsYl9rZXJuZWxfcmFuZ2U6CS8qIDI1IGlu
c25zICovDQpAQCAtNTk2LDE1ICs2NjQsMTMgQEAgX19oeXBlcnZpc29yX3hjYWxsX2ZsdXNoX3Rs
Yl9tbTogLyogMjEgaW5zbnMgKi8NCiAJbWVtYmFyCQkjU3luYw0KIAlyZXRyeQ0KIA0KLQkuZ2xv
YmwJCV9faHlwZXJ2aXNvcl94Y2FsbF9mbHVzaF90bGJfcGVuZGluZw0KLV9faHlwZXJ2aXNvcl94
Y2FsbF9mbHVzaF90bGJfcGVuZGluZzogLyogMjEgaW5zbnMgKi8NCi0JLyogJWc1PWN0eCwgJWcx
PW5yLCAlZzc9dmFkZHJzW10sICVnMiwlZzMsJWc0LGc2PXNjcmF0Y2ggKi8NCi0Jc2xseAkJJWcx
LCAzLCAlZzENCisJLmdsb2JsCQlfX2h5cGVydmlzb3JfeGNhbGxfZmx1c2hfdGxiX3BhZ2UNCitf
X2h5cGVydmlzb3JfeGNhbGxfZmx1c2hfdGxiX3BhZ2U6IC8qIDE3IGluc25zICovDQorCS8qICVn
NT1jdHgsICVnMT12YWRkciAqLw0KIAltb3YJCSVvMCwgJWcyDQogCW1vdgkJJW8xLCAlZzMNCiAJ
bW92CQklbzIsICVnNA0KLTE6CXN1YgkJJWcxLCAoMSA8PCAzKSwgJWcxDQotCWxkeAkJWyVnNyAr
ICVnMV0sICVvMAkvKiBBUkcwOiB2aXJ0dWFsIGFkZHJlc3MgKi8NCisJbW92CQklZzEsICVvMAkg
ICAgICAgIC8qIEFSRzA6IHZpcnR1YWwgYWRkcmVzcyAqLw0KIAltb3YJCSVnNSwgJW8xCQkvKiBB
UkcxOiBtbXUgY29udGV4dCAqLw0KIAltb3YJCUhWX01NVV9BTEwsICVvMgkJLyogQVJHMjogZmxh
Z3MgKi8NCiAJc3JseAkJJW8wLCBQQUdFX1NISUZULCAlbzANCkBAIC02MTMsOCArNjc5LDYgQEAg
X19oeXBlcnZpc29yX3hjYWxsX2ZsdXNoX3RsYl9wZW5kaW5nOiAvKiAyMSBpbnNucyAqLw0KIAlt
b3YJCUhWX01NVV9VTk1BUF9BRERSX1RSQVAsICVnNg0KIAlicm56LGEscG4JJW8wLCBfX2h5cGVy
dmlzb3JfdGxiX3hjYWxsX2Vycm9yDQogCSBtb3YJCSVvMCwgJWc1DQotCWJybnoscHQJCSVnMSwg
MWINCi0JIG5vcA0KIAltb3YJCSVnMiwgJW8wDQogCW1vdgkJJWczLCAlbzENCiAJbW92CQklZzQs
ICVvMg0KQEAgLTY5Nyw2ICs3NjEsMTMgQEAgaHlwZXJ2aXNvcl9wYXRjaF9jYWNoZXRsYm9wczoN
CiAJY2FsbAkJdGxiX3BhdGNoX29uZQ0KIAkgbW92CQkxMCwgJW8yDQogDQorCXNldGhpCQklaGko
X19mbHVzaF90bGJfcGFnZSksICVvMA0KKwlvcgkJJW8wLCAlbG8oX19mbHVzaF90bGJfcGFnZSks
ICVvMA0KKwlzZXRoaQkJJWhpKF9faHlwZXJ2aXNvcl9mbHVzaF90bGJfcGFnZSksICVvMQ0KKwlv
cgkJJW8xLCAlbG8oX19oeXBlcnZpc29yX2ZsdXNoX3RsYl9wYWdlKSwgJW8xDQorCWNhbGwJCXRs
Yl9wYXRjaF9vbmUNCisJIG1vdgkJMTEsICVvMg0KKw0KIAlzZXRoaQkJJWhpKF9fZmx1c2hfdGxi
X3BlbmRpbmcpLCAlbzANCiAJb3IJCSVvMCwgJWxvKF9fZmx1c2hfdGxiX3BlbmRpbmcpLCAlbzAN
CiAJc2V0aGkJCSVoaShfX2h5cGVydmlzb3JfZmx1c2hfdGxiX3BlbmRpbmcpLCAlbzENCkBAIC03
MjgsMTIgKzc5OSwxMiBAQCBoeXBlcnZpc29yX3BhdGNoX2NhY2hldGxib3BzOg0KIAljYWxsCQl0
bGJfcGF0Y2hfb25lDQogCSBtb3YJCTIxLCAlbzINCiANCi0Jc2V0aGkJCSVoaSh4Y2FsbF9mbHVz
aF90bGJfcGVuZGluZyksICVvMA0KLQlvcgkJJW8wLCAlbG8oeGNhbGxfZmx1c2hfdGxiX3BlbmRp
bmcpLCAlbzANCi0Jc2V0aGkJCSVoaShfX2h5cGVydmlzb3JfeGNhbGxfZmx1c2hfdGxiX3BlbmRp
bmcpLCAlbzENCi0Jb3IJCSVvMSwgJWxvKF9faHlwZXJ2aXNvcl94Y2FsbF9mbHVzaF90bGJfcGVu
ZGluZyksICVvMQ0KKwlzZXRoaQkJJWhpKHhjYWxsX2ZsdXNoX3RsYl9wYWdlKSwgJW8wDQorCW9y
CQklbzAsICVsbyh4Y2FsbF9mbHVzaF90bGJfcGFnZSksICVvMA0KKwlzZXRoaQkJJWhpKF9faHlw
ZXJ2aXNvcl94Y2FsbF9mbHVzaF90bGJfcGFnZSksICVvMQ0KKwlvcgkJJW8xLCAlbG8oX19oeXBl
cnZpc29yX3hjYWxsX2ZsdXNoX3RsYl9wYWdlKSwgJW8xDQogCWNhbGwJCXRsYl9wYXRjaF9vbmUN
Ci0JIG1vdgkJMjEsICVvMg0KKwkgbW92CQkxNywgJW8yDQogDQogCXNldGhpCQklaGkoeGNhbGxf
Zmx1c2hfdGxiX2tlcm5lbF9yYW5nZSksICVvMA0KIAlvcgkJJW8wLCAlbG8oeGNhbGxfZmx1c2hf
dGxiX2tlcm5lbF9yYW5nZSksICVvMA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUv
cGVyZl9ldmVudF9pbnRlbC5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVs
LmMNCmluZGV4IDk1N2MyMTYuLjRiYjEyZjcgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L3BlcmZfZXZlbnRfaW50ZWwuYw0KKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2
ZW50X2ludGVsLmMNCkBAIC0xMzAsOCArMTMwLDE0IEBAIHN0YXRpYyBzdHJ1Y3QgZXZlbnRfY29u
c3RyYWludCBpbnRlbF9nZW5fZXZlbnRfY29uc3RyYWludHNbXSBfX3JlYWRfbW9zdGx5ID0NCiB9
Ow0KIA0KIHN0YXRpYyBzdHJ1Y3QgZXh0cmFfcmVnIGludGVsX3NuYl9leHRyYV9yZWdzW10gX19y
ZWFkX21vc3RseSA9IHsNCi0JSU5URUxfRVZFTlRfRVhUUkFfUkVHKDB4YjcsIE1TUl9PRkZDT1JF
X1JTUF8wLCAweDNmZmZmZmZmZmZ1bGwsIFJTUF8wKSwNCi0JSU5URUxfRVZFTlRfRVhUUkFfUkVH
KDB4YmIsIE1TUl9PRkZDT1JFX1JTUF8xLCAweDNmZmZmZmZmZmZ1bGwsIFJTUF8xKSwNCisJSU5U
RUxfRVZFTlRfRVhUUkFfUkVHKDB4YjcsIE1TUl9PRkZDT1JFX1JTUF8wLCAweDNmODA3ZjhmZmZ1
bGwsIFJTUF8wKSwNCisJSU5URUxfRVZFTlRfRVhUUkFfUkVHKDB4YmIsIE1TUl9PRkZDT1JFX1JT
UF8xLCAweDNmODA3ZjhmZmZ1bGwsIFJTUF8xKSwNCisJRVZFTlRfRVhUUkFfRU5EDQorfTsNCisN
CitzdGF0aWMgc3RydWN0IGV4dHJhX3JlZyBpbnRlbF9zbmJlcF9leHRyYV9yZWdzW10gX19yZWFk
X21vc3RseSA9IHsNCisJSU5URUxfRVZFTlRfRVhUUkFfUkVHKDB4YjcsIE1TUl9PRkZDT1JFX1JT
UF8wLCAweDNmZmZmZjhmZmZ1bGwsIFJTUF8wKSwNCisJSU5URUxfRVZFTlRfRVhUUkFfUkVHKDB4
YmIsIE1TUl9PRkZDT1JFX1JTUF8xLCAweDNmZmZmZjhmZmZ1bGwsIFJTUF8xKSwNCiAJRVZFTlRf
RVhUUkFfRU5EDQogfTsNCiANCkBAIC0xNzExLDcgKzE3MTcsMTAgQEAgX19pbml0IGludCBpbnRl
bF9wbXVfaW5pdCh2b2lkKQ0KIA0KIAkJeDg2X3BtdS5ldmVudF9jb25zdHJhaW50cyA9IGludGVs
X3NuYl9ldmVudF9jb25zdHJhaW50czsNCiAJCXg4Nl9wbXUucGVic19jb25zdHJhaW50cyA9IGlu
dGVsX3NuYl9wZWJzX2V2ZW50X2NvbnN0cmFpbnRzOw0KLQkJeDg2X3BtdS5leHRyYV9yZWdzID0g
aW50ZWxfc25iX2V4dHJhX3JlZ3M7DQorCQlpZiAoYm9vdF9jcHVfZGF0YS54ODZfbW9kZWwgPT0g
NDUpDQorCQkJeDg2X3BtdS5leHRyYV9yZWdzID0gaW50ZWxfc25iZXBfZXh0cmFfcmVnczsNCisJ
CWVsc2UNCisJCQl4ODZfcG11LmV4dHJhX3JlZ3MgPSBpbnRlbF9zbmJfZXh0cmFfcmVnczsNCiAJ
CS8qIGFsbCBleHRyYSByZWdzIGFyZSBwZXItY3B1IHdoZW4gSFQgaXMgb24gKi8NCiAJCXg4Nl9w
bXUuZXJfZmxhZ3MgfD0gRVJGX0hBU19SU1BfMTsNCiAJCXg4Nl9wbXUuZXJfZmxhZ3MgfD0gRVJG
X05PX0hUX1NIQVJJTkc7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvbW0vaW5pdC5jIGIvYXJjaC94
ODYvbW0vaW5pdC5jDQppbmRleCAzNGE3ZjQwLi5hNGNjYTA2IDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYvbW0vaW5pdC5jDQorKysgYi9hcmNoL3g4Ni9tbS9pbml0LmMNCkBAIC00NCwxMSArNDQsMTUg
QEAgc3RhdGljIHZvaWQgX19pbml0IGZpbmRfZWFybHlfdGFibGVfc3BhY2Uoc3RydWN0IG1hcF9y
YW5nZSAqbXIsIGludCBucl9yYW5nZSkNCiAJaW50IGk7DQogCXVuc2lnbmVkIGxvbmcgcHVkcyA9
IDAsIHBtZHMgPSAwLCBwdGVzID0gMCwgdGFibGVzOw0KIAl1bnNpZ25lZCBsb25nIHN0YXJ0ID0g
MCwgZ29vZF9lbmQ7DQorCXVuc2lnbmVkIGxvbmcgcGdkX2V4dHJhID0gMDsNCiAJcGh5c19hZGRy
X3QgYmFzZTsNCiANCiAJZm9yIChpID0gMDsgaSA8IG5yX3JhbmdlOyBpKyspIHsNCiAJCXVuc2ln
bmVkIGxvbmcgcmFuZ2UsIGV4dHJhOw0KIA0KKwkJaWYgKChtcltpXS5lbmQgPj4gUEdESVJfU0hJ
RlQpIC0gKG1yW2ldLnN0YXJ0ID4+IFBHRElSX1NISUZUKSkNCisJCQlwZ2RfZXh0cmErKzsNCisN
CiAJCXJhbmdlID0gbXJbaV0uZW5kIC0gbXJbaV0uc3RhcnQ7DQogCQlwdWRzICs9IChyYW5nZSAr
IFBVRF9TSVpFIC0gMSkgPj4gUFVEX1NISUZUOw0KIA0KQEAgLTczLDYgKzc3LDcgQEAgc3RhdGlj
IHZvaWQgX19pbml0IGZpbmRfZWFybHlfdGFibGVfc3BhY2Uoc3RydWN0IG1hcF9yYW5nZSAqbXIs
IGludCBucl9yYW5nZSkNCiAJdGFibGVzID0gcm91bmR1cChwdWRzICogc2l6ZW9mKHB1ZF90KSwg
UEFHRV9TSVpFKTsNCiAJdGFibGVzICs9IHJvdW5kdXAocG1kcyAqIHNpemVvZihwbWRfdCksIFBB
R0VfU0laRSk7DQogCXRhYmxlcyArPSByb3VuZHVwKHB0ZXMgKiBzaXplb2YocHRlX3QpLCBQQUdF
X1NJWkUpOw0KKwl0YWJsZXMgKz0gKHBnZF9leHRyYSAqIFBBR0VfU0laRSk7DQogDQogI2lmZGVm
IENPTkZJR19YODZfMzINCiAJLyogZm9yIGZpeG1hcCAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L3hlbi9lbmxpZ2h0ZW4uYyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYw0KaW5kZXggNjliOWVm
Ni4uMDQ0ZjVkOSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYw0KKysrIGIv
YXJjaC94ODYveGVuL2VubGlnaHRlbi5jDQpAQCAtMTM5MSw4ICsxMzkxLDExIEBAIHN0YXRpYyBp
bnQgX19jcHVpbml0IHhlbl9odm1fY3B1X25vdGlmeShzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnNl
bGYsDQogCXN3aXRjaCAoYWN0aW9uKSB7DQogCWNhc2UgQ1BVX1VQX1BSRVBBUkU6DQogCQl4ZW5f
dmNwdV9zZXR1cChjcHUpOw0KLQkJaWYgKHhlbl9oYXZlX3ZlY3Rvcl9jYWxsYmFjaykNCisJCWlm
ICh4ZW5faGF2ZV92ZWN0b3JfY2FsbGJhY2spIHsNCiAJCQl4ZW5faW5pdF9sb2NrX2NwdShjcHUp
Ow0KKwkJCWlmICh4ZW5fZmVhdHVyZShYRU5GRUFUX2h2bV9zYWZlX3B2Y2xvY2spKQ0KKwkJCQl4
ZW5fc2V0dXBfdGltZXIoY3B1KTsNCisJCX0NCiAJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJYnJl
YWs7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVuL3NtcC5jIGIvYXJjaC94ODYveGVuL3NtcC5j
DQppbmRleCA5YTIzZmZmLi42ZTRkNWRjIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYveGVuL3NtcC5j
DQorKysgYi9hcmNoL3g4Ni94ZW4vc21wLmMNCkBAIC01NjMsNiArNTYzLDggQEAgc3RhdGljIHZv
aWQgeGVuX2h2bV9jcHVfZGllKHVuc2lnbmVkIGludCBjcHUpDQogCXVuYmluZF9mcm9tX2lycWhh
bmRsZXIocGVyX2NwdSh4ZW5fY2FsbGZ1bmNfaXJxLCBjcHUpLCBOVUxMKTsNCiAJdW5iaW5kX2Zy
b21faXJxaGFuZGxlcihwZXJfY3B1KHhlbl9kZWJ1Z19pcnEsIGNwdSksIE5VTEwpOw0KIAl1bmJp
bmRfZnJvbV9pcnFoYW5kbGVyKHBlcl9jcHUoeGVuX2NhbGxmdW5jc2luZ2xlX2lycSwgY3B1KSwg
TlVMTCk7DQorCXhlbl91bmluaXRfbG9ja19jcHUoY3B1KTsNCisJeGVuX3RlYXJkb3duX3RpbWVy
KGNwdSk7DQogCW5hdGl2ZV9jcHVfZGllKGNwdSk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L3hlbi90aW1lLmMgYi9hcmNoL3g4Ni94ZW4vdGltZS5jDQppbmRleCAwMjk2YTk1Li4wNTRj
YzAxIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYveGVuL3RpbWUuYw0KKysrIGIvYXJjaC94ODYveGVu
L3RpbWUuYw0KQEAgLTQ5Nyw3ICs0OTcsMTEgQEAgc3RhdGljIHZvaWQgeGVuX2h2bV9zZXR1cF9j
cHVfY2xvY2tldmVudHModm9pZCkNCiB7DQogCWludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7
DQogCXhlbl9zZXR1cF9ydW5zdGF0ZV9pbmZvKGNwdSk7DQotCXhlbl9zZXR1cF90aW1lcihjcHUp
Ow0KKwkvKg0KKwkgKiB4ZW5fc2V0dXBfdGltZXIoY3B1KSAtIHNucHJpbnRmIGlzIGJhZCBpbiBh
dG9taWMgY29udGV4dC4gSGVuY2UNCisJICogZG9pbmcgaXQgeGVuX2h2bV9jcHVfbm90aWZ5ICh3
aGljaCBnZXRzIGNhbGxlZCBieSBzbXBfaW5pdCBkdXJpbmcNCisJICogZWFybHkgYm9vdHVwIGFu
ZCBhbHNvIGR1cmluZyBDUFUgaG90cGx1ZyBldmVudHMpLg0KKwkgKi8NCiAJeGVuX3NldHVwX2Nw
dV9jbG9ja2V2ZW50cygpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9jcnlwdG8vYWxnaWZfaGFzaC5j
IGIvY3J5cHRvL2FsZ2lmX2hhc2guYw0KaW5kZXggZWY1MzU2Yy4uMDI2MjIxMCAxMDA2NDQNCi0t
LSBhL2NyeXB0by9hbGdpZl9oYXNoLmMNCisrKyBiL2NyeXB0by9hbGdpZl9oYXNoLmMNCkBAIC0x
NjEsNiArMTYxLDggQEAgc3RhdGljIGludCBoYXNoX3JlY3Ztc2coc3RydWN0IGtpb2NiICp1bnVz
ZWQsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWVsc2UgaWYgKGxlbiA8IGRzKQ0KIAkJbXNnLT5t
c2dfZmxhZ3MgfD0gTVNHX1RSVU5DOw0KIA0KKwltc2ctPm1zZ19uYW1lbGVuID0gMDsNCisNCiAJ
bG9ja19zb2NrKHNrKTsNCiAJaWYgKGN0eC0+bW9yZSkgew0KIAkJY3R4LT5tb3JlID0gMDsNCmRp
ZmYgLS1naXQgYS9jcnlwdG8vYWxnaWZfc2tjaXBoZXIuYyBiL2NyeXB0by9hbGdpZl9za2NpcGhl
ci5jDQppbmRleCA2YTZkZmMwLi5hMWM0ZjBhIDEwMDY0NA0KLS0tIGEvY3J5cHRvL2FsZ2lmX3Nr
Y2lwaGVyLmMNCisrKyBiL2NyeXB0by9hbGdpZl9za2NpcGhlci5jDQpAQCAtNDMyLDYgKzQzMiw3
IEBAIHN0YXRpYyBpbnQgc2tjaXBoZXJfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKnVudXNlZCwgc3Ry
dWN0IHNvY2tldCAqc29jaywNCiAJbG9uZyBjb3BpZWQgPSAwOw0KIA0KIAlsb2NrX3NvY2soc2sp
Ow0KKwltc2ctPm1zZ19uYW1lbGVuID0gMDsNCiAJZm9yIChpb3YgPSBtc2ctPm1zZ19pb3YsIGlv
dmxlbiA9IG1zZy0+bXNnX2lvdmxlbjsgaW92bGVuID4gMDsNCiAJICAgICBpb3ZsZW4tLSwgaW92
KyspIHsNCiAJCXVuc2lnbmVkIGxvbmcgc2VnbGVuID0gaW92LT5pb3ZfbGVuOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvYWNwaS9wY2lfcm9vdC5jIGIvZHJpdmVycy9hY3BpL3BjaV9yb290LmMNCmlu
ZGV4IDdhZmY2MzEuLjViMGYwNzUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2FjcGkvcGNpX3Jvb3Qu
Yw0KKysrIGIvZHJpdmVycy9hY3BpL3BjaV9yb290LmMNCkBAIC0yNDcsOCArMjQ3LDggQEAgc3Rh
dGljIGFjcGlfc3RhdHVzIGFjcGlfcGNpX3F1ZXJ5X29zYyhzdHJ1Y3QgYWNwaV9wY2lfcm9vdCAq
cm9vdCwNCiAJCSpjb250cm9sICY9IE9TQ19QQ0lfQ09OVFJPTF9NQVNLUzsNCiAJCWNhcGJ1ZltP
U0NfQ09OVFJPTF9UWVBFXSA9ICpjb250cm9sIHwgcm9vdC0+b3NjX2NvbnRyb2xfc2V0Ow0KIAl9
IGVsc2Ugew0KLQkJLyogUnVuIF9PU0MgcXVlcnkgZm9yIGFsbCBwb3NzaWJsZSBjb250cm9scy4g
Ki8NCi0JCWNhcGJ1ZltPU0NfQ09OVFJPTF9UWVBFXSA9IE9TQ19QQ0lfQ09OVFJPTF9NQVNLUzsN
CisJCS8qIFJ1biBfT1NDIHF1ZXJ5IG9ubHkgd2l0aCBleGlzdGluZyBjb250cm9scy4gKi8NCisJ
CWNhcGJ1ZltPU0NfQ09OVFJPTF9UWVBFXSA9IHJvb3QtPm9zY19jb250cm9sX3NldDsNCiAJfQ0K
IA0KIAlzdGF0dXMgPSBhY3BpX3BjaV9ydW5fb3NjKHJvb3QtPmRldmljZS0+aGFuZGxlLCBjYXBi
dWYsICZyZXN1bHQpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9ocGV0LmMgYi9kcml2ZXJz
L2NoYXIvaHBldC5jDQppbmRleCAwODMzODk2Li4xNGQ0OWU0IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9jaGFyL2hwZXQuYw0KKysrIGIvZHJpdmVycy9jaGFyL2hwZXQuYw0KQEAgLTM3NCwyNiArMzc0
LDE0IEBAIHN0YXRpYyBpbnQgaHBldF9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKnZtYSkNCiAJc3RydWN0IGhwZXRfZGV2ICpkZXZwOw0KIAl1bnNpZ25lZCBs
b25nIGFkZHI7DQogDQotCWlmICgoKHZtYS0+dm1fZW5kIC0gdm1hLT52bV9zdGFydCkgIT0gUEFH
RV9TSVpFKSB8fCB2bWEtPnZtX3Bnb2ZmKQ0KLQkJcmV0dXJuIC1FSU5WQUw7DQotDQogCWRldnAg
PSBmaWxlLT5wcml2YXRlX2RhdGE7DQogCWFkZHIgPSBkZXZwLT5oZF9ocGV0cy0+aHBfaHBldF9w
aHlzOw0KIA0KIAlpZiAoYWRkciAmIChQQUdFX1NJWkUgLSAxKSkNCiAJCXJldHVybiAtRU5PU1lT
Ow0KIA0KLQl2bWEtPnZtX2ZsYWdzIHw9IFZNX0lPOw0KIAl2bWEtPnZtX3BhZ2VfcHJvdCA9IHBn
cHJvdF9ub25jYWNoZWQodm1hLT52bV9wYWdlX3Byb3QpOw0KLQ0KLQlpZiAoaW9fcmVtYXBfcGZu
X3JhbmdlKHZtYSwgdm1hLT52bV9zdGFydCwgYWRkciA+PiBQQUdFX1NISUZULA0KLQkJCQkJUEFH
RV9TSVpFLCB2bWEtPnZtX3BhZ2VfcHJvdCkpIHsNCi0JCXByaW50ayhLRVJOX0VSUiAiJXM6IGlv
X3JlbWFwX3Bmbl9yYW5nZSBmYWlsZWRcbiIsDQotCQkJX19mdW5jX18pOw0KLQkJcmV0dXJuIC1F
QUdBSU47DQotCX0NCi0NCi0JcmV0dXJuIDA7DQorCXJldHVybiB2bV9pb21hcF9tZW1vcnkodm1h
LCBhZGRyLCBQQUdFX1NJWkUpOw0KICNlbHNlDQogCXJldHVybiAtRU5PU1lTOw0KICNlbmRpZg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZG1hLmMgYi9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pOTE1X2RtYS5jDQppbmRleCBjYTY3MzM4Li5jNzdmYzY3IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kbWEuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJt
L2k5MTUvaTkxNV9kbWEuYw0KQEAgLTEwMDcsNTYgKzEwMDcsNTAgQEAgaW50ZWxfdGVhcmRvd25f
bWNoYmFyKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogCQlyZWxlYXNlX3Jlc291cmNlKCZkZXZf
cHJpdi0+bWNoX3Jlcyk7DQogfQ0KIA0KLSNkZWZpbmUgUFRFX0FERFJFU1NfTUFTSwkJMHhmZmZm
ZjAwMA0KLSNkZWZpbmUgUFRFX0FERFJFU1NfTUFTS19ISUdICQkweDAwMDAwMGYwIC8qIGk5MTUr
ICovDQotI2RlZmluZSBQVEVfTUFQUElOR19UWVBFX1VOQ0FDSEVECSgwIDw8IDEpDQotI2RlZmlu
ZSBQVEVfTUFQUElOR19UWVBFX0RDQUNIRQkJKDEgPDwgMSkgLyogaTgzMCBvbmx5ICovDQotI2Rl
ZmluZSBQVEVfTUFQUElOR19UWVBFX0NBQ0hFRAkJKDMgPDwgMSkNCi0jZGVmaW5lIFBURV9NQVBQ
SU5HX1RZUEVfTUFTSwkJKDMgPDwgMSkNCi0jZGVmaW5lIFBURV9WQUxJRAkJCSgxIDw8IDApDQot
DQotLyoqDQotICogaTkxNV9zdG9sZW5fdG9fcGh5cyAtIHRha2UgYW4gb2Zmc2V0IGludG8gc3Rv
bGVuIG1lbW9yeSBhbmQgdHVybiBpdCBpbnRvDQotICogICAgICAgICAgICAgICAgICAgICAgIGEg
cGh5c2ljYWwgb25lDQotICogQGRldjogZHJtIGRldmljZQ0KLSAqIEBvZmZzZXQ6IGFkZHJlc3Mg
dG8gdHJhbnNsYXRlDQotICoNCi0gKiBTb21lIGNoaXAgZnVuY3Rpb25zIHJlcXVpcmUgYWxsb2Nh
dGlvbnMgZnJvbSBzdG9sZW4gc3BhY2UgYW5kIG5lZWQgdGhlDQotICogcGh5c2ljYWwgYWRkcmVz
cyBvZiB0aGUgbWVtb3J5IGluIHF1ZXN0aW9uLg0KLSAqLw0KLXN0YXRpYyB1bnNpZ25lZCBsb25n
IGk5MTVfc3RvbGVuX3RvX3BoeXMoc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdTMyIG9mZnNldCkN
CitzdGF0aWMgdW5zaWduZWQgbG9uZyBpOTE1X3N0b2xlbl90b19waHlzaWNhbChzdHJ1Y3QgZHJt
X2RldmljZSAqZGV2KQ0KIHsNCiAJc3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmRldl9wcml2ID0g
ZGV2LT5kZXZfcHJpdmF0ZTsNCiAJc3RydWN0IHBjaV9kZXYgKnBkZXYgPSBkZXZfcHJpdi0+YnJp
ZGdlX2RldjsNCiAJdTMyIGJhc2U7DQogDQotI2lmIDANCiAJLyogT24gdGhlIG1hY2hpbmVzIEkg
aGF2ZSB0ZXN0ZWQgdGhlIEdyYXBoaWNzIEJhc2Ugb2YgU3RvbGVuIE1lbW9yeQ0KLQkgKiBpcyB1
bnJlbGlhYmxlLCBzbyBjb21wdXRlIHRoZSBiYXNlIGJ5IHN1YnRyYWN0aW5nIHRoZSBzdG9sZW4g
bWVtb3J5DQotCSAqIGZyb20gdGhlIFRvcCBvZiBMb3cgVXNhYmxlIERSQU0gd2hpY2ggaXMgd2hl
cmUgdGhlIEJJT1MgcGxhY2VzDQotCSAqIHRoZSBncmFwaGljcyBzdG9sZW4gbWVtb3J5Lg0KKwkg
KiBpcyB1bnJlbGlhYmxlLCBzbyBvbiB0aG9zZSBjb21wdXRlIHRoZSBiYXNlIGJ5IHN1YnRyYWN0
aW5nIHRoZQ0KKwkgKiBzdG9sZW4gbWVtb3J5IGZyb20gdGhlIFRvcCBvZiBMb3cgVXNhYmxlIERS
QU0gd2hpY2ggaXMgd2hlcmUgdGhlDQorCSAqIEJJT1MgcGxhY2VzIHRoZSBncmFwaGljcyBzdG9s
ZW4gbWVtb3J5Lg0KKwkgKg0KKwkgKiBPbiBnZW4yLCB0aGUgbGF5b3V0IGlzIHNsaWdodGx5IGRp
ZmZlcmVudCB3aXRoIHRoZSBHcmFwaGljcyBTZWdtZW50DQorCSAqIGltbWVkaWF0ZWx5IGZvbGxv
d2luZyBUb3Agb2YgTWVtb3J5IChvciBUb3Agb2YgVXNhYmxlIERSQU0pLiBOb3RlDQorCSAqIGl0
IGFwcGVhcnMgdGhhdCBUT1VEIGlzIG9ubHkgcmVwb3J0ZWQgYnkgODY1Zywgc28gd2UganVzdCB1
c2UgdGhlDQorCSAqIHRvcCBvZiBtZW1vcnkgYXMgZGV0ZXJtaW5lZCBieSB0aGUgZTgyMCBwcm9i
ZS4NCisJICoNCisJICogWFhYIGdlbjIgcmVxdWlyZXMgYW4gdW5hdmFpbGFibGUgc3ltYm9sIGFu
ZCA5NDVnbSBmYWlscyB3aXRoDQorCSAqIGl0cyB2YWx1ZSBvZiBUT0xVRC4NCiAJICovDQotCWlm
IChJTlRFTF9JTkZPKGRldiktPmdlbiA+IDMgfHwgSVNfRzMzKGRldikpIHsNCi0JCS8qIHRvcCAz
MmJpdHMgYXJlIHJlc2VydmVkID0gMCAqLw0KKwliYXNlID0gMDsNCisJaWYgKElOVEVMX0lORk8o
ZGV2KS0+Z2VuID49IDYpIHsNCisJCS8qIFJlYWQgQmFzZSBEYXRhIG9mIFN0b2xlbiBNZW1vcnkg
UmVnaXN0ZXIgKEJEU00pIGRpcmVjdGx5Lg0KKwkJICogTm90ZSB0aGF0IHRoZXJlIGlzIGFsc28g
YSBNQ0hCQVIgbWlyb3IgYXQgMHgxMDgwYzAgb3INCisJCSAqIHdlIGNvdWxkIHVzZSBkZXZpY2Ug
MjoweDVjIGluc3RlYWQuDQorCQkqLw0KKwkJcGNpX3JlYWRfY29uZmlnX2R3b3JkKHBkZXYsIDB4
QjAsICZiYXNlKTsNCisJCWJhc2UgJj0gfjQwOTU7IC8qIGxvd2VyIGJpdHMgdXNlZCBmb3IgbG9j
a2luZyByZWdpc3RlciAqLw0KKwl9IGVsc2UgaWYgKElOVEVMX0lORk8oZGV2KS0+Z2VuID4gMyB8
fCBJU19HMzMoZGV2KSkgew0KKwkJLyogUmVhZCBHcmFwaGljcyBCYXNlIG9mIFN0b2xlbiBNZW1v
cnkgZGlyZWN0bHkgKi8NCiAJCXBjaV9yZWFkX2NvbmZpZ19kd29yZChwZGV2LCAweEE0LCAmYmFz
ZSk7DQotCX0gZWxzZSB7DQotCQkvKiBYWFggcHJlc3VtZSA4eHggaXMgdGhlIHNhbWUgYXMgaTkx
NSAqLw0KLQkJcGNpX2J1c19yZWFkX2NvbmZpZ19kd29yZChwZGV2LT5idXMsIDIsIDB4NUMsICZi
YXNlKTsNCi0JfQ0KLSNlbHNlDQotCWlmIChJTlRFTF9JTkZPKGRldiktPmdlbiA+IDMgfHwgSVNf
RzMzKGRldikpIHsNCi0JCXUxNiB2YWw7DQotCQlwY2lfcmVhZF9jb25maWdfd29yZChwZGV2LCAw
eGIwLCAmdmFsKTsNCi0JCWJhc2UgPSB2YWwgPj4gNCA8PCAyMDsNCi0JfSBlbHNlIHsNCisjaWYg
MA0KKwl9IGVsc2UgaWYgKElTX0dFTjMoZGV2KSkgew0KIAkJdTggdmFsOw0KKwkJLyogU3RvbGVu
IGlzIGltbWVkaWF0ZWx5IGJlbG93IFRvcCBvZiBMb3cgVXNhYmxlIERSQU0gKi8NCiAJCXBjaV9y
ZWFkX2NvbmZpZ19ieXRlKHBkZXYsIDB4OWMsICZ2YWwpOw0KIAkJYmFzZSA9IHZhbCA+PiAzIDw8
IDI3Ow0KLQl9DQotCWJhc2UgLT0gZGV2X3ByaXYtPm1tLmd0dC0+c3RvbGVuX3NpemU7DQorCQli
YXNlIC09IGRldl9wcml2LT5tbS5ndHQtPnN0b2xlbl9zaXplOw0KKwl9IGVsc2Ugew0KKwkJLyog
U3RvbGVuIGlzIGltbWVkaWF0ZWx5IGFib3ZlIFRvcCBvZiBNZW1vcnkgKi8NCisJCWJhc2UgPSBt
YXhfbG93X3Bmbl9tYXBwZWQgPDwgUEFHRV9TSElGVDsNCiAjZW5kaWYNCisJfQ0KIA0KLQlyZXR1
cm4gYmFzZSArIG9mZnNldDsNCisJcmV0dXJuIGJhc2U7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGk5
MTVfd2Fybl9zdG9sZW4oc3RydWN0IGRybV9kZXZpY2UgKmRldikNCkBAIC0xMDgxLDcgKzEwNzUs
NyBAQCBzdGF0aWMgdm9pZCBpOTE1X3NldHVwX2NvbXByZXNzaW9uKHN0cnVjdCBkcm1fZGV2aWNl
ICpkZXYsIGludCBzaXplKQ0KIAlpZiAoIWNvbXByZXNzZWRfZmIpDQogCQlnb3RvIGVycjsNCiAN
Ci0JY2ZiX2Jhc2UgPSBpOTE1X3N0b2xlbl90b19waHlzKGRldiwgY29tcHJlc3NlZF9mYi0+c3Rh
cnQpOw0KKwljZmJfYmFzZSA9IGRldl9wcml2LT5tbS5zdG9sZW5fYmFzZSArIGNvbXByZXNzZWRf
ZmItPnN0YXJ0Ow0KIAlpZiAoIWNmYl9iYXNlKQ0KIAkJZ290byBlcnJfZmI7DQogDQpAQCAtMTA5
NCw3ICsxMDg4LDcgQEAgc3RhdGljIHZvaWQgaTkxNV9zZXR1cF9jb21wcmVzc2lvbihzdHJ1Y3Qg
ZHJtX2RldmljZSAqZGV2LCBpbnQgc2l6ZSkNCiAJCWlmICghY29tcHJlc3NlZF9sbGIpDQogCQkJ
Z290byBlcnJfZmI7DQogDQotCQlsbF9iYXNlID0gaTkxNV9zdG9sZW5fdG9fcGh5cyhkZXYsIGNv
bXByZXNzZWRfbGxiLT5zdGFydCk7DQorCQlsbF9iYXNlID0gZGV2X3ByaXYtPm1tLnN0b2xlbl9i
YXNlICsgY29tcHJlc3NlZF9sbGItPnN0YXJ0Ow0KIAkJaWYgKCFsbF9iYXNlKQ0KIAkJCWdvdG8g
ZXJyX2xsYjsNCiAJfQ0KQEAgLTExMTMsNyArMTEwNyw3IEBAIHN0YXRpYyB2b2lkIGk5MTVfc2V0
dXBfY29tcHJlc3Npb24oc3RydWN0IGRybV9kZXZpY2UgKmRldiwgaW50IHNpemUpDQogCX0NCiAN
CiAJRFJNX0RFQlVHX0tNUygiRkJDIGJhc2UgMHglMDhseCwgbGwgYmFzZSAweCUwOGx4LCBzaXpl
ICVkTVxuIiwNCi0JCSAgICAgIGNmYl9iYXNlLCBsbF9iYXNlLCBzaXplID4+IDIwKTsNCisJCSAg
ICAgIChsb25nKWNmYl9iYXNlLCAobG9uZylsbF9iYXNlLCBzaXplID4+IDIwKTsNCiAJcmV0dXJu
Ow0KIA0KIGVycl9sbGI6DQpAQCAtMTE4Nyw2ICsxMTgxLDEzIEBAIHN0YXRpYyBpbnQgaTkxNV9s
b2FkX2dlbV9pbml0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogCWd0dF9zaXplID0gZGV2X3By
aXYtPm1tLmd0dC0+Z3R0X3RvdGFsX2VudHJpZXMgPDwgUEFHRV9TSElGVDsNCiAJbWFwcGFibGVf
c2l6ZSA9IGRldl9wcml2LT5tbS5ndHQtPmd0dF9tYXBwYWJsZV9lbnRyaWVzIDw8IFBBR0VfU0hJ
RlQ7DQogDQorCWRldl9wcml2LT5tbS5zdG9sZW5fYmFzZSA9IGk5MTVfc3RvbGVuX3RvX3BoeXNp
Y2FsKGRldik7DQorCWlmIChkZXZfcHJpdi0+bW0uc3RvbGVuX2Jhc2UgPT0gMCkNCisJCXJldHVy
biAwOw0KKw0KKwlEUk1fREVCVUdfS01TKCJmb3VuZCAlZCBieXRlcyBvZiBzdG9sZW4gbWVtb3J5
IGF0ICUwOGx4XG4iLA0KKwkJICAgICAgZGV2X3ByaXYtPm1tLmd0dC0+c3RvbGVuX3NpemUsIGRl
dl9wcml2LT5tbS5zdG9sZW5fYmFzZSk7DQorDQogCS8qIEJhc2ljIG1lbXJhbmdlIGFsbG9jYXRv
ciBmb3Igc3RvbGVuIHNwYWNlICovDQogCWRybV9tbV9pbml0KCZkZXZfcHJpdi0+bW0uc3RvbGVu
LCAwLCBwcmVhbGxvY19zaXplKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9pOTE1X2Rydi5oIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaA0KaW5kZXggMTQ0
ZDM3Yy4uMjBjZDI5NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2
LmgNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmgNCkBAIC01ODEsNiArNTgx
LDcgQEAgdHlwZWRlZiBzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSB7DQogCQl1bnNpZ25lZCBsb25n
IGd0dF9zdGFydDsNCiAJCXVuc2lnbmVkIGxvbmcgZ3R0X21hcHBhYmxlX2VuZDsNCiAJCXVuc2ln
bmVkIGxvbmcgZ3R0X2VuZDsNCisJCXVuc2lnbmVkIGxvbmcgc3RvbGVuX2Jhc2U7IC8qIGxpbWl0
ZWQgdG8gbG93IG1lbW9yeSAoMzItYml0KSAqLw0KIA0KIAkJc3RydWN0IGlvX21hcHBpbmcgKmd0
dF9tYXBwaW5nOw0KIAkJaW50IGd0dF9tdHJyOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2k5MTVfZ2VtLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2dlbS5jDQppbmRl
eCBiMDE4NmI4Li4yODY1YjQ0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkx
NV9nZW0uYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW0uYw0KQEAgLTI1MjAs
NiArMjUyMCwxMSBAQCBpOTE1X2ZpbmRfZmVuY2VfcmVnKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYs
DQogCXJldHVybiBhdmFpbDsNCiB9DQogDQorc3RhdGljIHZvaWQgaTkxNV9nZW1fd3JpdGVfZmVu
Y2VfX2lwaSh2b2lkICpkYXRhKQ0KK3sNCisJd2JpbnZkKCk7DQorfQ0KKw0KIC8qKg0KICAqIGk5
MTVfZ2VtX29iamVjdF9nZXRfZmVuY2UgLSBzZXQgdXAgYSBmZW5jZSByZWcgZm9yIGFuIG9iamVj
dA0KICAqIEBvYmo6IG9iamVjdCB0byBtYXAgdGhyb3VnaCBhIGZlbmNlIHJlZw0KQEAgLTI2NDAs
NiArMjY0NSwxNyBAQCB1cGRhdGU6DQogCXN3aXRjaCAoSU5URUxfSU5GTyhkZXYpLT5nZW4pIHsN
CiAJY2FzZSA3Og0KIAljYXNlIDY6DQorCQkvKiBJbiBvcmRlciB0byBmdWxseSBzZXJpYWxpemUg
YWNjZXNzIHRvIHRoZSBmZW5jZWQgcmVnaW9uIGFuZA0KKwkJICogdGhlIHVwZGF0ZSB0byB0aGUg
ZmVuY2UgcmVnaXN0ZXIgd2UgbmVlZCB0byB0YWtlIGV4dHJlbWUNCisJCSAqIG1lYXN1cmVzIG9u
IFNOQisuIEluIHRoZW9yeSwgdGhlIHdyaXRlIHRvIHRoZSBmZW5jZSByZWdpc3Rlcg0KKwkJICog
Zmx1c2hlcyBhbGwgbWVtb3J5IHRyYW5zYWN0aW9ucyBiZWZvcmUsIGFuZCBjb3VwbGVkIHdpdGgg
dGhlDQorCQkgKiBtYigpIHBsYWNlZCBhcm91bmQgdGhlIHJlZ2lzdGVyIHdyaXRlIHdlIHNlcmlh
bGlzZSBhbGwgbWVtb3J5DQorCQkgKiBvcGVyYXRpb25zIHdpdGggcmVzcGVjdCB0byB0aGUgY2hh
bmdlcyBpbiB0aGUgdGlsZXIuIFlldCwgb24NCisJCSAqIFNOQisgd2UgbmVlZCB0byB0YWtlIGEg
c3RlcCBmdXJ0aGVyIGFuZCBlbWl0IGFuIGV4cGxpY2l0IHdiaW52ZCgpDQorCQkgKiBvbiBlYWNo
IHByb2Nlc3NvciBpbiBvcmRlciB0byBtYW51YWxseSBmbHVzaCBhbGwgbWVtb3J5DQorCQkgKiB0
cmFuc2FjdGlvbnMgYmVmb3JlIHVwZGF0aW5nIHRoZSBmZW5jZSByZWdpc3Rlci4NCisJCSAqLw0K
KwkJb25fZWFjaF9jcHUoaTkxNV9nZW1fd3JpdGVfZmVuY2VfX2lwaSwgTlVMTCwgMSk7DQogCQly
ZXQgPSBzYW5keWJyaWRnZV93cml0ZV9mZW5jZV9yZWcob2JqLCBwaXBlbGluZWQpOw0KIAkJYnJl
YWs7DQogCWNhc2UgNToNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9k
aXNwbGF5LmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMNCmluZGV4IDg5
N2NhMDYuLmNmYmI4OTMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9k
aXNwbGF5LmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KQEAg
LTkwOTMsNiArOTA5Myw5IEBAIHZvaWQgaW50ZWxfbW9kZXNldF9jbGVhbnVwKHN0cnVjdCBkcm1f
ZGV2aWNlICpkZXYpDQogCWRlbF90aW1lcl9zeW5jKCZkZXZfcHJpdi0+aWRsZV90aW1lcik7DQog
CWNhbmNlbF93b3JrX3N5bmMoJmRldl9wcml2LT5pZGxlX3dvcmspOw0KIA0KKwkvKiBkZXN0cm95
IGJhY2tsaWdodCwgaWYgYW55LCBiZWZvcmUgdGhlIGNvbm5lY3RvcnMgKi8NCisJaW50ZWxfcGFu
ZWxfZGVzdHJveV9iYWNrbGlnaHQoZGV2KTsNCisNCiAJZHJtX21vZGVfY29uZmlnX2NsZWFudXAo
ZGV2KTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHAu
YyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2RwLmMNCmluZGV4IGM4ZWNhYWIuLmEwN2Nj
YWIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kcC5jDQorKysgYi9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kcC5jDQpAQCAtMjI3NCwxMSArMjI3NCw2IEBAIGRv
bmU6DQogc3RhdGljIHZvaWQNCiBpbnRlbF9kcF9kZXN0cm95KHN0cnVjdCBkcm1fY29ubmVjdG9y
ICpjb25uZWN0b3IpDQogew0KLQlzdHJ1Y3QgZHJtX2RldmljZSAqZGV2ID0gY29ubmVjdG9yLT5k
ZXY7DQotDQotCWlmIChpbnRlbF9kcGRfaXNfZWRwKGRldikpDQotCQlpbnRlbF9wYW5lbF9kZXN0
cm95X2JhY2tsaWdodChkZXYpOw0KLQ0KIAlkcm1fc3lzZnNfY29ubmVjdG9yX3JlbW92ZShjb25u
ZWN0b3IpOw0KIAlkcm1fY29ubmVjdG9yX2NsZWFudXAoY29ubmVjdG9yKTsNCiAJa2ZyZWUoY29u
bmVjdG9yKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kdm8uYyBi
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2R2by5jDQppbmRleCA2ZWRhMWI1Li44YWM5MWI4
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHZvLmMNCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2R2by5jDQpAQCAtMzcxLDYgKzM3MSw3IEBAIHZvaWQg
aW50ZWxfZHZvX2luaXQoc3RydWN0IGRybV9kZXZpY2UgKmRldikNCiAJCWNvbnN0IHN0cnVjdCBp
bnRlbF9kdm9fZGV2aWNlICpkdm8gPSAmaW50ZWxfZHZvX2RldmljZXNbaV07DQogCQlzdHJ1Y3Qg
aTJjX2FkYXB0ZXIgKmkyYzsNCiAJCWludCBncGlvOw0KKwkJYm9vbCBkdm9pbml0Ow0KIA0KIAkJ
LyogQWxsb3cgdGhlIEkyQyBkcml2ZXIgaW5mbyB0byBzcGVjaWZ5IHRoZSBHUElPIHRvIGJlIHVz
ZWQgaW4NCiAJCSAqIHNwZWNpYWwgY2FzZXMsIGJ1dCBvdGhlcndpc2UgZGVmYXVsdCB0byB3aGF0
J3MgZGVmaW5lZA0KQEAgLTM5MCw3ICszOTEsMTcgQEAgdm9pZCBpbnRlbF9kdm9faW5pdChzdHJ1
Y3QgZHJtX2RldmljZSAqZGV2KQ0KIAkJaTJjID0gJmRldl9wcml2LT5nbWJ1c1tncGlvXS5hZGFw
dGVyOw0KIA0KIAkJaW50ZWxfZHZvLT5kZXYgPSAqZHZvOw0KLQkJaWYgKCFkdm8tPmRldl9vcHMt
PmluaXQoJmludGVsX2R2by0+ZGV2LCBpMmMpKQ0KKw0KKwkJLyogR01CVVMgTkFLIGhhbmRsaW5n
IHNlZW1zIHRvIGJlIHVuc3RhYmxlLCBoZW5jZSBsZXQgdGhlDQorCQkgKiB0cmFuc21pdHRlciBk
ZXRlY3Rpb24gcnVuIGluIGJpdCBiYW5naW5nIG1vZGUgZm9yIG5vdy4NCisJCSAqLw0KKwkJaW50
ZWxfZ21idXNfZm9yY2VfYml0KGkyYywgdHJ1ZSk7DQorDQorCQlkdm9pbml0ID0gZHZvLT5kZXZf
b3BzLT5pbml0KCZpbnRlbF9kdm8tPmRldiwgaTJjKTsNCisNCisJCWludGVsX2dtYnVzX2ZvcmNl
X2JpdChpMmMsIGZhbHNlKTsNCisNCisJCWlmICghZHZvaW5pdCkNCiAJCQljb250aW51ZTsNCiAN
CiAJCWludGVsX2VuY29kZXItPnR5cGUgPSBJTlRFTF9PVVRQVVRfRFZPOw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2x2ZHMuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1
L2ludGVsX2x2ZHMuYw0KaW5kZXggNjYwMWQyMS4uODc2YmFjMCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2ludGVsX2x2ZHMuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUv
aW50ZWxfbHZkcy5jDQpAQCAtNTUzLDggKzU1Myw2IEBAIHN0YXRpYyB2b2lkIGludGVsX2x2ZHNf
ZGVzdHJveShzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yKQ0KIAlzdHJ1Y3QgZHJtX2Rl
dmljZSAqZGV2ID0gY29ubmVjdG9yLT5kZXY7DQogCXN0cnVjdCBkcm1faTkxNV9wcml2YXRlICpk
ZXZfcHJpdiA9IGRldi0+ZGV2X3ByaXZhdGU7DQogDQotCWludGVsX3BhbmVsX2Rlc3Ryb3lfYmFj
a2xpZ2h0KGRldik7DQotDQogCWlmIChkZXZfcHJpdi0+bGlkX25vdGlmaWVyLm5vdGlmaWVyX2Nh
bGwpDQogCQlhY3BpX2xpZF9ub3RpZmllcl91bnJlZ2lzdGVyKCZkZXZfcHJpdi0+bGlkX25vdGlm
aWVyKTsNCiAJZHJtX3N5c2ZzX2Nvbm5lY3Rvcl9yZW1vdmUoY29ubmVjdG9yKTsNCkBAIC03ODgs
NiArNzg2LDE0IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCBpbnRlbF9ub19s
dmRzW10gPSB7DQogCQkJRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJYN1NQQS1IIiksDQog
CQl9LA0KIAl9LA0KKwl7DQorCQkuY2FsbGJhY2sgPSBpbnRlbF9ub19sdmRzX2RtaV9jYWxsYmFj
aywNCisJCS5pZGVudCA9ICJGdWppdHN1IEVzcHJpbW8gUTkwMCIsDQorCQkubWF0Y2hlcyA9IHsN
CisJCQlETUlfTUFUQ0goRE1JX1NZU19WRU5ET1IsICJGVUpJVFNVIiksDQorCQkJRE1JX01BVENI
KERNSV9QUk9EVUNUX05BTUUsICJFU1BSSU1PIFE5MDAiKSwNCisJCX0sDQorCX0sDQogDQogCXsg
fQkvKiB0ZXJtaW5hdGluZyBlbnRyeSAqLw0KIH07DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvaW50ZWxfcGFuZWwuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3BhbmVs
LmMNCmluZGV4IDcyYjg5NDkuLjA0Y2IzNGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0v
aTkxNS9pbnRlbF9wYW5lbC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9wYW5l
bC5jDQpAQCAtMzYxLDYgKzM2MSw5IEBAIGludCBpbnRlbF9wYW5lbF9zZXR1cF9iYWNrbGlnaHQo
c3RydWN0IGRybV9kZXZpY2UgKmRldikNCiANCiAJaW50ZWxfcGFuZWxfaW5pdF9iYWNrbGlnaHQo
ZGV2KTsNCiANCisJaWYgKFdBUk5fT04oZGV2X3ByaXYtPmJhY2tsaWdodCkpDQorCQlyZXR1cm4g
LUVOT0RFVjsNCisNCiAJaWYgKGRldl9wcml2LT5pbnRfbHZkc19jb25uZWN0b3IpDQogCQljb25u
ZWN0b3IgPSBkZXZfcHJpdi0+aW50X2x2ZHNfY29ubmVjdG9yOw0KIAllbHNlIGlmIChkZXZfcHJp
di0+aW50X2VkcF9jb25uZWN0b3IpDQpAQCAtMzg4LDggKzM5MSwxMCBAQCBpbnQgaW50ZWxfcGFu
ZWxfc2V0dXBfYmFja2xpZ2h0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogdm9pZCBpbnRlbF9w
YW5lbF9kZXN0cm95X2JhY2tsaWdodChzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQ0KIHsNCiAJc3Ry
dWN0IGRybV9pOTE1X3ByaXZhdGUgKmRldl9wcml2ID0gZGV2LT5kZXZfcHJpdmF0ZTsNCi0JaWYg
KGRldl9wcml2LT5iYWNrbGlnaHQpDQorCWlmIChkZXZfcHJpdi0+YmFja2xpZ2h0KSB7DQogCQli
YWNrbGlnaHRfZGV2aWNlX3VucmVnaXN0ZXIoZGV2X3ByaXYtPmJhY2tsaWdodCk7DQorCQlkZXZf
cHJpdi0+YmFja2xpZ2h0ID0gTlVMTDsNCisJfQ0KIH0NCiAjZWxzZQ0KIGludCBpbnRlbF9wYW5l
bF9zZXR1cF9iYWNrbGlnaHQoc3RydWN0IGRybV9kZXZpY2UgKmRldikNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b20uYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRv
bS5jDQppbmRleCAzYTA1Y2RiLi5kOTY5ZjNjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9hdG9tLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbS5jDQpAQCAt
MTM4NywxMCArMTM4NywxMCBAQCBpbnQgYXRvbV9hbGxvY2F0ZV9mYl9zY3JhdGNoKHN0cnVjdCBh
dG9tX2NvbnRleHQgKmN0eCkNCiAJCWZpcm13YXJlX3VzYWdlID0gKHN0cnVjdCBfQVRPTV9WUkFN
X1VTQUdFX0JZX0ZJUk1XQVJFICopKGN0eC0+YmlvcyArIGRhdGFfb2Zmc2V0KTsNCiANCiAJCURS
TV9ERUJVRygiYXRvbSBmaXJtd2FyZSByZXF1ZXN0ZWQgJTA4eCAlZGtiXG4iLA0KLQkJCSAgZmly
bXdhcmVfdXNhZ2UtPmFzRmlybXdhcmVWcmFtUmVzZXJ2ZUluZm9bMF0udWxTdGFydEFkZHJVc2Vk
QnlGaXJtd2FyZSwNCi0JCQkgIGZpcm13YXJlX3VzYWdlLT5hc0Zpcm13YXJlVnJhbVJlc2VydmVJ
bmZvWzBdLnVzRmlybXdhcmVVc2VJbktiKTsNCisJCQkgIGxlMzJfdG9fY3B1KGZpcm13YXJlX3Vz
YWdlLT5hc0Zpcm13YXJlVnJhbVJlc2VydmVJbmZvWzBdLnVsU3RhcnRBZGRyVXNlZEJ5RmlybXdh
cmUpLA0KKwkJCSAgbGUxNl90b19jcHUoZmlybXdhcmVfdXNhZ2UtPmFzRmlybXdhcmVWcmFtUmVz
ZXJ2ZUluZm9bMF0udXNGaXJtd2FyZVVzZUluS2IpKTsNCiANCi0JCXVzYWdlX2J5dGVzID0gZmly
bXdhcmVfdXNhZ2UtPmFzRmlybXdhcmVWcmFtUmVzZXJ2ZUluZm9bMF0udXNGaXJtd2FyZVVzZUlu
S2IgKiAxMDI0Ow0KKwkJdXNhZ2VfYnl0ZXMgPSBsZTE2X3RvX2NwdShmaXJtd2FyZV91c2FnZS0+
YXNGaXJtd2FyZVZyYW1SZXNlcnZlSW5mb1swXS51c0Zpcm13YXJlVXNlSW5LYikgKiAxMDI0Ow0K
IAl9DQogCWN0eC0+c2NyYXRjaF9zaXplX2J5dGVzID0gMDsNCiAJaWYgKHVzYWdlX2J5dGVzID09
IDApDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMg
Yi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYw0KaW5kZXggYTI1ZDA4YS4u
MDM4NTcwYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0
Yy5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYw0KQEAgLTU0
NCw2ICs1NDQsOSBAQCBzdGF0aWMgdTMyIGF0b21iaW9zX2FkanVzdF9wbGwoc3RydWN0IGRybV9j
cnRjICpjcnRjLA0KIAkJLyogdXNlIGZyYWMgZmIgZGl2IG9uIEFQVXMgKi8NCiAJCWlmIChBU0lD
X0lTX0RDRTQxKHJkZXYpKQ0KIAkJCXBsbC0+ZmxhZ3MgfD0gUkFERU9OX1BMTF9VU0VfRlJBQ19G
Ql9ESVY7DQorCQkvKiB1c2UgZnJhYyBmYiBkaXYgb24gUlM3ODAvUlM4ODAgKi8NCisJCWlmICgo
cmRldi0+ZmFtaWx5ID09IENISVBfUlM3ODApIHx8IChyZGV2LT5mYW1pbHkgPT0gQ0hJUF9SUzg4
MCkpDQorCQkJcGxsLT5mbGFncyB8PSBSQURFT05fUExMX1VTRV9GUkFDX0ZCX0RJVjsNCiAJCWlm
IChBU0lDX0lTX0RDRTMyKHJkZXYpICYmIG1vZGUtPmNsb2NrID4gMTY1MDAwKQ0KIAkJCXBsbC0+
ZmxhZ3MgfD0gUkFERU9OX1BMTF9VU0VfRlJBQ19GQl9ESVY7DQogCX0gZWxzZSB7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYyBiL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vZXZlcmdyZWVuLmMNCmluZGV4IDYwZDEzZmUuLjA0OTVhNTAgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jDQorKysgYi9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL2V2ZXJncmVlbi5jDQpAQCAtNDEyLDYgKzQxMiwxNiBAQCB2b2lkIGV2ZXJncmVl
bl9ocGRfaW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiANCiAJbGlzdF9mb3JfZWFj
aF9lbnRyeShjb25uZWN0b3IsICZkZXYtPm1vZGVfY29uZmlnLmNvbm5lY3Rvcl9saXN0LCBoZWFk
KSB7DQogCQlzdHJ1Y3QgcmFkZW9uX2Nvbm5lY3RvciAqcmFkZW9uX2Nvbm5lY3RvciA9IHRvX3Jh
ZGVvbl9jb25uZWN0b3IoY29ubmVjdG9yKTsNCisNCisJCWlmIChjb25uZWN0b3ItPmNvbm5lY3Rv
cl90eXBlID09IERSTV9NT0RFX0NPTk5FQ1RPUl9lRFAgfHwNCisJCSAgICBjb25uZWN0b3ItPmNv
bm5lY3Rvcl90eXBlID09IERSTV9NT0RFX0NPTk5FQ1RPUl9MVkRTKSB7DQorCQkJLyogZG9uJ3Qg
dHJ5IHRvIGVuYWJsZSBocGQgb24gZURQIG9yIExWRFMgYXZvaWQgYnJlYWtpbmcgdGhlDQorCQkJ
ICogYXV4IGRwIGNoYW5uZWwgb24gaW1hYyBhbmQgaGVscCAoYnV0IG5vdCBjb21wbGV0ZWx5IGZp
eCkNCisJCQkgKiBodHRwczovL2J1Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcuY2dpP2lkPTcy
NjE0Mw0KKwkJCSAqIGFsc28gYXZvaWQgaW50ZXJydXB0IHN0b3JtcyBkdXJpbmcgZHBtcy4NCisJ
CQkgKi8NCisJCQljb250aW51ZTsNCisJCX0NCiAJCXN3aXRjaCAocmFkZW9uX2Nvbm5lY3Rvci0+
aHBkLmhwZCkgew0KIAkJY2FzZSBSQURFT05fSFBEXzE6DQogCQkJV1JFRzMyKERDX0hQRDFfQ09O
VFJPTCwgdG1wKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDBfaGRt
aS5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwX2hkbWkuYw0KaW5kZXggYzQ1ZDkyMS4u
NTdhODI1ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMF9oZG1pLmMN
CisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMF9oZG1pLmMNCkBAIC01MDYsNyArNTA2
LDcgQEAgdm9pZCByNjAwX2hkbWlfZW5hYmxlKHN0cnVjdCBkcm1fZW5jb2RlciAqZW5jb2RlcikN
CiAJb2Zmc2V0ID0gcmFkZW9uX2VuY29kZXItPmhkbWlfb2Zmc2V0Ow0KIAlpZiAoQVNJQ19JU19E
Q0UzMihyZGV2KSAmJiAhQVNJQ19JU19EQ0U0KHJkZXYpKSB7DQogCQlXUkVHMzJfUChyYWRlb25f
ZW5jb2Rlci0+aGRtaV9jb25maWdfb2Zmc2V0ICsgMHg0LCAweDEsIH4weDEpOw0KLQl9IGVsc2Ug
aWYgKHJkZXYtPmZhbWlseSA+PSBDSElQX1I2MDAgJiYgIUFTSUNfSVNfRENFMyhyZGV2KSkgew0K
Kwl9IGVsc2UgaWYgKEFTSUNfSVNfRENFMihyZGV2KSAmJiAhQVNJQ19JU19EQ0UzKHJkZXYpKSB7
DQogCQlzd2l0Y2ggKHJhZGVvbl9lbmNvZGVyLT5lbmNvZGVyX2lkKSB7DQogCQljYXNlIEVOQ09E
RVJfT0JKRUNUX0lEX0lOVEVSTkFMX0tMRFNDUF9UTURTMToNCiAJCQlXUkVHMzJfUChBVklWT19U
TURTQV9DTlRMLCAweDQsIH4weDQpOw0KQEAgLTU3Miw3ICs1NzIsNyBAQCB2b2lkIHI2MDBfaGRt
aV9kaXNhYmxlKHN0cnVjdCBkcm1fZW5jb2RlciAqZW5jb2RlcikNCiANCiAJaWYgKEFTSUNfSVNf
RENFMzIocmRldikgJiYgIUFTSUNfSVNfRENFNChyZGV2KSkgew0KIAkJV1JFRzMyX1AocmFkZW9u
X2VuY29kZXItPmhkbWlfY29uZmlnX29mZnNldCArIDB4NCwgMCwgfjB4MSk7DQotCX0gZWxzZSBp
ZiAocmRldi0+ZmFtaWx5ID49IENISVBfUjYwMCAmJiAhQVNJQ19JU19EQ0UzKHJkZXYpKSB7DQor
CX0gZWxzZSBpZiAoQVNJQ19JU19EQ0UyKHJkZXYpICYmICFBU0lDX0lTX0RDRTMocmRldikpIHsN
CiAJCXN3aXRjaCAocmFkZW9uX2VuY29kZXItPmVuY29kZXJfaWQpIHsNCiAJCWNhc2UgRU5DT0RF
Ul9PQkpFQ1RfSURfSU5URVJOQUxfS0xEU0NQX1RNRFMxOg0KIAkJCVdSRUczMl9QKEFWSVZPX1RN
RFNBX0NOVEwsIDAsIH4weDQpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cmFkZW9uX2F0b21iaW9zLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hdG9tYmlv
cy5jDQppbmRleCAzODU4NWM1Li4zODNiMzhlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9yYWRlb25fYXRvbWJpb3MuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
YWRlb25fYXRvbWJpb3MuYw0KQEAgLTE5ODksNiArMTk4OSw4IEBAIHN0YXRpYyBpbnQgcmFkZW9u
X2F0b21iaW9zX3BhcnNlX3Bvd2VyX3RhYmxlXzFfMyhzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRl
dikNCiAJbnVtX21vZGVzID0gcG93ZXJfaW5mby0+aW5mby51Y051bU9mUG93ZXJNb2RlRW50cmll
czsNCiAJaWYgKG51bV9tb2RlcyA+IEFUT01fTUFYX05VTUJFUk9GX1BPV0VSX0JMT0NLKQ0KIAkJ
bnVtX21vZGVzID0gQVRPTV9NQVhfTlVNQkVST0ZfUE9XRVJfQkxPQ0s7DQorCWlmIChudW1fbW9k
ZXMgPT0gMCkNCisJCXJldHVybiBzdGF0ZV9pbmRleDsNCiAJcmRldi0+cG0ucG93ZXJfc3RhdGUg
PSBremFsbG9jKHNpemVvZihzdHJ1Y3QgcmFkZW9uX3Bvd2VyX3N0YXRlKSAqIG51bV9tb2Rlcywg
R0ZQX0tFUk5FTCk7DQogCWlmICghcmRldi0+cG0ucG93ZXJfc3RhdGUpDQogCQlyZXR1cm4gc3Rh
dGVfaW5kZXg7DQpAQCAtMjM2MSw2ICsyMzYzLDggQEAgc3RhdGljIGludCByYWRlb25fYXRvbWJp
b3NfcGFyc2VfcG93ZXJfdGFibGVfNF81KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAlw
b3dlcl9pbmZvID0gKHVuaW9uIHBvd2VyX2luZm8gKikobW9kZV9pbmZvLT5hdG9tX2NvbnRleHQt
PmJpb3MgKyBkYXRhX29mZnNldCk7DQogDQogCXJhZGVvbl9hdG9tYmlvc19hZGRfcHBsaWJfdGhl
cm1hbF9jb250cm9sbGVyKHJkZXYsICZwb3dlcl9pbmZvLT5wcGxpYi5zVGhlcm1hbENvbnRyb2xs
ZXIpOw0KKwlpZiAocG93ZXJfaW5mby0+cHBsaWIudWNOdW1TdGF0ZXMgPT0gMCkNCisJCXJldHVy
biBzdGF0ZV9pbmRleDsNCiAJcmRldi0+cG0ucG93ZXJfc3RhdGUgPSBremFsbG9jKHNpemVvZihz
dHJ1Y3QgcmFkZW9uX3Bvd2VyX3N0YXRlKSAqDQogCQkJCSAgICAgICBwb3dlcl9pbmZvLT5wcGxp
Yi51Y051bVN0YXRlcywgR0ZQX0tFUk5FTCk7DQogCWlmICghcmRldi0+cG0ucG93ZXJfc3RhdGUp
DQpAQCAtMjQ0Myw2ICsyNDQ3LDcgQEAgc3RhdGljIGludCByYWRlb25fYXRvbWJpb3NfcGFyc2Vf
cG93ZXJfdGFibGVfNihzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJaW50IGluZGV4ID0g
R2V0SW5kZXhJbnRvTWFzdGVyVGFibGUoREFUQSwgUG93ZXJQbGF5SW5mbyk7DQogICAgICAgICB1
MTYgZGF0YV9vZmZzZXQ7DQogCXU4IGZyZXYsIGNyZXY7DQorCXU4ICpwb3dlcl9zdGF0ZV9vZmZz
ZXQ7DQogDQogCWlmICghYXRvbV9wYXJzZV9kYXRhX2hlYWRlcihtb2RlX2luZm8tPmF0b21fY29u
dGV4dCwgaW5kZXgsIE5VTEwsDQogCQkJCSAgICZmcmV2LCAmY3JldiwgJmRhdGFfb2Zmc2V0KSkN
CkBAIC0yNDU5LDE1ICsyNDY0LDE3IEBAIHN0YXRpYyBpbnQgcmFkZW9uX2F0b21iaW9zX3BhcnNl
X3Bvd2VyX3RhYmxlXzYoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQogCW5vbl9jbG9ja19p
bmZvX2FycmF5ID0gKHN0cnVjdCBOb25DbG9ja0luZm9BcnJheSAqKQ0KIAkJKG1vZGVfaW5mby0+
YXRvbV9jb250ZXh0LT5iaW9zICsgZGF0YV9vZmZzZXQgKw0KIAkJIGxlMTZfdG9fY3B1KHBvd2Vy
X2luZm8tPnBwbGliLnVzTm9uQ2xvY2tJbmZvQXJyYXlPZmZzZXQpKTsNCisJaWYgKHN0YXRlX2Fy
cmF5LT51Y051bUVudHJpZXMgPT0gMCkNCisJCXJldHVybiBzdGF0ZV9pbmRleDsNCiAJcmRldi0+
cG0ucG93ZXJfc3RhdGUgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgcmFkZW9uX3Bvd2VyX3N0YXRl
KSAqDQogCQkJCSAgICAgICBzdGF0ZV9hcnJheS0+dWNOdW1FbnRyaWVzLCBHRlBfS0VSTkVMKTsN
CiAJaWYgKCFyZGV2LT5wbS5wb3dlcl9zdGF0ZSkNCiAJCXJldHVybiBzdGF0ZV9pbmRleDsNCisJ
cG93ZXJfc3RhdGVfb2Zmc2V0ID0gKHU4ICopc3RhdGVfYXJyYXktPnN0YXRlczsNCiAJZm9yIChp
ID0gMDsgaSA8IHN0YXRlX2FycmF5LT51Y051bUVudHJpZXM7IGkrKykgew0KIAkJbW9kZV9pbmRl
eCA9IDA7DQotCQlwb3dlcl9zdGF0ZSA9ICh1bmlvbiBwcGxpYl9wb3dlcl9zdGF0ZSAqKSZzdGF0
ZV9hcnJheS0+c3RhdGVzW2ldOw0KLQkJLyogWFhYIHRoaXMgbWlnaHQgYmUgYW4gaW5hZ3VhIGJ1
Zy4uLiAqLw0KLQkJbm9uX2Nsb2NrX2FycmF5X2luZGV4ID0gaTsgLyogcG93ZXJfc3RhdGUtPnYy
Lm5vbkNsb2NrSW5mb0luZGV4ICovDQorCQlwb3dlcl9zdGF0ZSA9ICh1bmlvbiBwcGxpYl9wb3dl
cl9zdGF0ZSAqKXBvd2VyX3N0YXRlX29mZnNldDsNCisJCW5vbl9jbG9ja19hcnJheV9pbmRleCA9
IHBvd2VyX3N0YXRlLT52Mi5ub25DbG9ja0luZm9JbmRleDsNCiAJCW5vbl9jbG9ja19pbmZvID0g
KHN0cnVjdCBfQVRPTV9QUExJQl9OT05DTE9DS19JTkZPICopDQogCQkJJm5vbl9jbG9ja19pbmZv
X2FycmF5LT5ub25DbG9ja0luZm9bbm9uX2Nsb2NrX2FycmF5X2luZGV4XTsNCiAJCXJkZXYtPnBt
LnBvd2VyX3N0YXRlW2ldLmNsb2NrX2luZm8gPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgcmFkZW9u
X3BtX2Nsb2NrX2luZm8pICoNCkBAIC0yNDc5LDkgKzI0ODYsNiBAQCBzdGF0aWMgaW50IHJhZGVv
bl9hdG9tYmlvc19wYXJzZV9wb3dlcl90YWJsZV82KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2
KQ0KIAkJaWYgKHBvd2VyX3N0YXRlLT52Mi51Y051bURQTUxldmVscykgew0KIAkJCWZvciAoaiA9
IDA7IGogPCBwb3dlcl9zdGF0ZS0+djIudWNOdW1EUE1MZXZlbHM7IGorKykgew0KIAkJCQljbG9j
a19hcnJheV9pbmRleCA9IHBvd2VyX3N0YXRlLT52Mi5jbG9ja0luZm9JbmRleFtqXTsNCi0JCQkJ
LyogWFhYIHRoaXMgbWlnaHQgYmUgYW4gaW5hZ3VhIGJ1Zy4uLiAqLw0KLQkJCQlpZiAoY2xvY2tf
YXJyYXlfaW5kZXggPj0gY2xvY2tfaW5mb19hcnJheS0+dWNOdW1FbnRyaWVzKQ0KLQkJCQkJY29u
dGludWU7DQogCQkJCWNsb2NrX2luZm8gPSAodW5pb24gcHBsaWJfY2xvY2tfaW5mbyAqKQ0KIAkJ
CQkJJmNsb2NrX2luZm9fYXJyYXktPmNsb2NrSW5mb1tjbG9ja19hcnJheV9pbmRleF07DQogCQkJ
CXZhbGlkID0gcmFkZW9uX2F0b21iaW9zX3BhcnNlX3BwbGliX2Nsb2NrX2luZm8ocmRldiwNCkBA
IC0yNTAzLDYgKzI1MDcsNyBAQCBzdGF0aWMgaW50IHJhZGVvbl9hdG9tYmlvc19wYXJzZV9wb3dl
cl90YWJsZV82KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAkJCQkJCQkJICAgbm9uX2Ns
b2NrX2luZm8pOw0KIAkJCXN0YXRlX2luZGV4Kys7DQogCQl9DQorCQlwb3dlcl9zdGF0ZV9vZmZz
ZXQgKz0gMiArIHBvd2VyX3N0YXRlLT52Mi51Y051bURQTUxldmVsczsNCiAJfQ0KIAkvKiBpZiBt
dWx0aXBsZSBjbG9jayBtb2RlcywgbWFyayB0aGUgbG93ZXN0IGFzIG5vIGRpc3BsYXkgKi8NCiAJ
Zm9yIChpID0gMDsgaSA8IHN0YXRlX2luZGV4OyBpKyspIHsNCkBAIC0yNTQ5LDcgKzI1NTQsOSBA
QCB2b2lkIHJhZGVvbl9hdG9tYmlvc19nZXRfcG93ZXJfbW9kZXMoc3RydWN0IHJhZGVvbl9kZXZp
Y2UgKnJkZXYpDQogCQlkZWZhdWx0Og0KIAkJCWJyZWFrOw0KIAkJfQ0KLQl9IGVsc2Ugew0KKwl9
DQorDQorCWlmIChzdGF0ZV9pbmRleCA9PSAwKSB7DQogCQlyZGV2LT5wbS5wb3dlcl9zdGF0ZSA9
IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCByYWRlb25fcG93ZXJfc3RhdGUpLCBHRlBfS0VSTkVMKTsN
CiAJCWlmIChyZGV2LT5wbS5wb3dlcl9zdGF0ZSkgew0KIAkJCXJkZXYtPnBtLnBvd2VyX3N0YXRl
WzBdLmNsb2NrX2luZm8gPQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uX2ttcy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fa21zLmMNCmluZGV4IGJl
MmMxMjIuLjRiYjllMjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVv
bl9rbXMuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fa21zLmMNCkBAIC0z
OSw4ICszOSwxMiBAQCBpbnQgcmFkZW9uX2RyaXZlcl91bmxvYWRfa21zKHN0cnVjdCBkcm1fZGV2
aWNlICpkZXYpDQogDQogCWlmIChyZGV2ID09IE5VTEwpDQogCQlyZXR1cm4gMDsNCisJaWYgKHJk
ZXYtPnJtbWlvID09IE5VTEwpDQorCQlnb3RvIGRvbmVfZnJlZTsNCiAJcmFkZW9uX21vZGVzZXRf
ZmluaShyZGV2KTsNCiAJcmFkZW9uX2RldmljZV9maW5pKHJkZXYpOw0KKw0KK2RvbmVfZnJlZToN
CiAJa2ZyZWUocmRldik7DQogCWRldi0+ZGV2X3ByaXZhdGUgPSBOVUxMOw0KIAlyZXR1cm4gMDsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9wbS5jIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fcG0uYw0KaW5kZXggZWJkNmM1MS4uZDU4ZWNjYiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX3BtLmMNCisrKyBiL2RyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX3BtLmMNCkBAIC04NjMsNyArODYzLDExIEBAIHN0YXRp
YyBpbnQgcmFkZW9uX2RlYnVnZnNfcG1faW5mbyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKmRh
dGEpDQogCXN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2ID0gZGV2LT5kZXZfcHJpdmF0ZTsNCiAN
CiAJc2VxX3ByaW50ZihtLCAiZGVmYXVsdCBlbmdpbmUgY2xvY2s6ICV1MCBrSHpcbiIsIHJkZXYt
PnBtLmRlZmF1bHRfc2Nsayk7DQotCXNlcV9wcmludGYobSwgImN1cnJlbnQgZW5naW5lIGNsb2Nr
OiAldTAga0h6XG4iLCByYWRlb25fZ2V0X2VuZ2luZV9jbG9jayhyZGV2KSk7DQorCS8qIHJhZGVv
bl9nZXRfZW5naW5lX2Nsb2NrIGlzIG5vdCByZWxpYWJsZSBvbiBBUFVzIHNvIGp1c3QgcHJpbnQg
dGhlIGN1cnJlbnQgY2xvY2sgKi8NCisJaWYgKChyZGV2LT5mYW1pbHkgPj0gQ0hJUF9QQUxNKSAm
JiAocmRldi0+ZmxhZ3MgJiBSQURFT05fSVNfSUdQKSkNCisJCXNlcV9wcmludGYobSwgImN1cnJl
bnQgZW5naW5lIGNsb2NrOiAldTAga0h6XG4iLCByZGV2LT5wbS5jdXJyZW50X3NjbGspOw0KKwll
bHNlDQorCQlzZXFfcHJpbnRmKG0sICJjdXJyZW50IGVuZ2luZSBjbG9jazogJXUwIGtIelxuIiwg
cmFkZW9uX2dldF9lbmdpbmVfY2xvY2socmRldikpOw0KIAlzZXFfcHJpbnRmKG0sICJkZWZhdWx0
IG1lbW9yeSBjbG9jazogJXUwIGtIelxuIiwgcmRldi0+cG0uZGVmYXVsdF9tY2xrKTsNCiAJaWYg
KHJkZXYtPmFzaWMtPmdldF9tZW1vcnlfY2xvY2spDQogCQlzZXFfcHJpbnRmKG0sICJjdXJyZW50
IG1lbW9yeSBjbG9jazogJXUwIGtIelxuIiwgcmFkZW9uX2dldF9tZW1vcnlfY2xvY2socmRldikp
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMteGlpYy5jIGIvZHJpdmVycy9p
MmMvYnVzc2VzL2kyYy14aWljLmMNCmluZGV4IDRiYjY4ZjMuLjY0ZTcwNjUgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2kyYy9idXNzZXMvaTJjLXhpaWMuYw0KKysrIGIvZHJpdmVycy9pMmMvYnVzc2Vz
L2kyYy14aWljLmMNCkBAIC0zMTEsMTAgKzMxMSw4IEBAIHN0YXRpYyB2b2lkIHhpaWNfZmlsbF90
eF9maWZvKHN0cnVjdCB4aWljX2kyYyAqaTJjKQ0KIAkJCS8qIGxhc3QgbWVzc2FnZSBpbiB0cmFu
c2ZlciAtPiBTVE9QICovDQogCQkJZGF0YSB8PSBYSUlDX1RYX0RZTl9TVE9QX01BU0s7DQogCQkJ
ZGV2X2RiZyhpMmMtPmFkYXAuZGV2LnBhcmVudCwgIiVzIFRYIFNUT1BcbiIsIF9fZnVuY19fKTsN
Ci0NCi0JCQl4aWljX3NldHJlZzE2KGkyYywgWElJQ19EVFJfUkVHX09GRlNFVCwgZGF0YSk7DQot
CQl9IGVsc2UNCi0JCQl4aWljX3NldHJlZzgoaTJjLCBYSUlDX0RUUl9SRUdfT0ZGU0VULCBkYXRh
KTsNCisJCX0NCisJCXhpaWNfc2V0cmVnMTYoaTJjLCBYSUlDX0RUUl9SRUdfT0ZGU0VULCBkYXRh
KTsNCiAJfQ0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21k
L21kLmMNCmluZGV4IDE3MDIxMzMuLjJkMDU0NGMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL21k
LmMNCisrKyBiL2RyaXZlcnMvbWQvbWQuYw0KQEAgLTE1ODgsOCArMTU4OCw4IEBAIHN0YXRpYyBp
bnQgc3VwZXJfMV9sb2FkKHN0cnVjdCBtZF9yZGV2ICpyZGV2LCBzdHJ1Y3QgbWRfcmRldiAqcmVm
ZGV2LCBpbnQgbWlub3JfDQogCQkJCQkgICAgIHNlY3RvciwgY291bnQsIDEpID09IDApDQogCQkJ
CXJldHVybiAtRUlOVkFMOw0KIAkJfQ0KLQl9IGVsc2UgaWYgKHNiLT5iYmxvZ19vZmZzZXQgPT0g
MCkNCi0JCXJkZXYtPmJhZGJsb2Nrcy5zaGlmdCA9IC0xOw0KKwl9IGVsc2UgaWYgKHNiLT5iYmxv
Z19vZmZzZXQgIT0gMCkNCisJCXJkZXYtPmJhZGJsb2Nrcy5zaGlmdCA9IDA7DQogDQogCWlmICgh
cmVmZGV2KSB7DQogCQlyZXQgPSAxOw0KQEAgLTMwNjMsNyArMzA2Myw3IEBAIGludCBtZF9yZGV2
X2luaXQoc3RydWN0IG1kX3JkZXYgKnJkZXYpDQogCSAqIGJlIHVzZWQgLSBJIHdvbmRlciBpZiB0
aGF0IG1hdHRlcnMNCiAJICovDQogCXJkZXYtPmJhZGJsb2Nrcy5jb3VudCA9IDA7DQotCXJkZXYt
PmJhZGJsb2Nrcy5zaGlmdCA9IDA7DQorCXJkZXYtPmJhZGJsb2Nrcy5zaGlmdCA9IC0xOyAvKiBk
aXNhYmxlZCB1bnRpbCBleHBsaWNpdGx5IGVuYWJsZWQgKi8NCiAJcmRldi0+YmFkYmxvY2tzLnBh
Z2UgPSBrbWFsbG9jKFBBR0VfU0laRSwgR0ZQX0tFUk5FTCk7DQogCXNlcWxvY2tfaW5pdCgmcmRl
di0+YmFkYmxvY2tzLmxvY2spOw0KIAlpZiAocmRldi0+YmFkYmxvY2tzLnBhZ2UgPT0gTlVMTCkN
CkBAIC0zMTM1LDkgKzMxMzUsNiBAQCBzdGF0aWMgc3RydWN0IG1kX3JkZXYgKm1kX2ltcG9ydF9k
ZXZpY2UoZGV2X3QgbmV3ZGV2LCBpbnQgc3VwZXJfZm9ybWF0LCBpbnQgc3VwZQ0KIAkJCWdvdG8g
YWJvcnRfZnJlZTsNCiAJCX0NCiAJfQ0KLQlpZiAoc3VwZXJfZm9ybWF0ID09IC0xKQ0KLQkJLyog
aG90LWFkZCBmb3IgMC45MCwgb3Igbm9uLXBlcnNpc3RlbnQ6IHNvIG5vIGJhZGJsb2NrcyAqLw0K
LQkJcmRldi0+YmFkYmxvY2tzLnNoaWZ0ID0gLTE7DQogDQogCXJldHVybiByZGV2Ow0KIA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgYi9kcml2ZXJzL25ldC9i
b25kaW5nL2JvbmRfbWFpbi5jDQppbmRleCBmYzA3ZjkwLi5iNDM2Yjg0IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvYm9uZGlu
Zy9ib25kX21haW4uYw0KQEAgLTE4NjYsNiArMTg2Niw3IEBAIGVycl9kZXRhY2g6DQogCXdyaXRl
X3VubG9ja19iaCgmYm9uZC0+bG9jayk7DQogDQogZXJyX2Nsb3NlOg0KKwlzbGF2ZV9kZXYtPnBy
aXZfZmxhZ3MgJj0gfklGRl9CT05ESU5HOw0KIAlkZXZfY2xvc2Uoc2xhdmVfZGV2KTsNCiANCiBl
cnJfdW5zZXRfbWFzdGVyOg0KQEAgLTQ4NTMsOSArNDg1NCwxOCBAQCBzdGF0aWMgaW50IF9fbmV0
X2luaXQgYm9uZF9uZXRfaW5pdChzdHJ1Y3QgbmV0ICpuZXQpDQogc3RhdGljIHZvaWQgX19uZXRf
ZXhpdCBib25kX25ldF9leGl0KHN0cnVjdCBuZXQgKm5ldCkNCiB7DQogCXN0cnVjdCBib25kX25l
dCAqYm4gPSBuZXRfZ2VuZXJpYyhuZXQsIGJvbmRfbmV0X2lkKTsNCisJc3RydWN0IGJvbmRpbmcg
KmJvbmQsICp0bXBfYm9uZDsNCisJTElTVF9IRUFEKGxpc3QpOw0KIA0KIAlib25kX2Rlc3Ryb3lf
c3lzZnMoYm4pOw0KIAlib25kX2Rlc3Ryb3lfcHJvY19kaXIoYm4pOw0KKw0KKwkvKiBLaWxsIG9m
ZiBhbnkgYm9uZHMgY3JlYXRlZCBhZnRlciB1bnJlZ2lzdGVyaW5nIGJvbmQgcnRubCBvcHMgKi8N
CisJcnRubF9sb2NrKCk7DQorCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShib25kLCB0bXBfYm9u
ZCwgJmJuLT5kZXZfbGlzdCwgYm9uZF9saXN0KQ0KKwkJdW5yZWdpc3Rlcl9uZXRkZXZpY2VfcXVl
dWUoYm9uZC0+ZGV2LCAmbGlzdCk7DQorCXVucmVnaXN0ZXJfbmV0ZGV2aWNlX21hbnkoJmxpc3Qp
Ow0KKwlydG5sX3VubG9jaygpOw0KIH0NCiANCiBzdGF0aWMgc3RydWN0IHBlcm5ldF9vcGVyYXRp
b25zIGJvbmRfbmV0X29wcyA9IHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9h
dGhlcm9zL2F0bDFlL2F0bDFlLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL2F0bDFl
L2F0bDFlLmgNCmluZGV4IGVkZmRmNmIuLmI1ZmQ5MzQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9hdGhlcm9zL2F0bDFlL2F0bDFlLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2F0aGVyb3MvYXRsMWUvYXRsMWUuaA0KQEAgLTE4Niw3ICsxODYsNyBAQCBzdHJ1Y3QgYXRs
MWVfdHBkX2Rlc2Mgew0KIC8qIGhvdyBhYm91dCAweDIwMDAgKi8NCiAjZGVmaW5lIE1BWF9UWF9C
VUZfTEVOICAgICAgMHgyMDAwDQogI2RlZmluZSBNQVhfVFhfQlVGX1NISUZUICAgIDEzDQotLyoj
ZGVmaW5lIE1BWF9UWF9CVUZfTEVOICAweDMwMDAgKi8NCisjZGVmaW5lIE1BWF9UU09fU0VHX1NJ
WkUgICAgMHgzYzAwDQogDQogLyogcnJzIHdvcmQgMSBiaXQgMDozMSAqLw0KICNkZWZpbmUgUlJT
X1JYX0NTVU1fTUFTSwkweEZGRkYNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9h
dGhlcm9zL2F0bDFlL2F0bDFlX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3Mv
YXRsMWUvYXRsMWVfbWFpbi5jDQppbmRleCBjNjlkYzI5Li5kZDg5M2IzIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYXRoZXJvcy9hdGwxZS9hdGwxZV9tYWluLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRsMWVfbWFpbi5jDQpAQCAtMjM1Miw2
ICsyMzUyLDcgQEAgc3RhdGljIGludCBfX2RldmluaXQgYXRsMWVfcHJvYmUoc3RydWN0IHBjaV9k
ZXYgKnBkZXYsDQogDQogCUlOSVRfV09SSygmYWRhcHRlci0+cmVzZXRfdGFzaywgYXRsMWVfcmVz
ZXRfdGFzayk7DQogCUlOSVRfV09SSygmYWRhcHRlci0+bGlua19jaGdfdGFzaywgYXRsMWVfbGlu
a19jaGdfdGFzayk7DQorCW5ldGlmX3NldF9nc29fbWF4X3NpemUobmV0ZGV2LCBNQVhfVFNPX1NF
R19TSVpFKTsNCiAJZXJyID0gcmVnaXN0ZXJfbmV0ZGV2KG5ldGRldik7DQogCWlmIChlcnIpIHsN
CiAJCW5ldGRldl9lcnIobmV0ZGV2LCAicmVnaXN0ZXIgbmV0ZGV2aWNlIGZhaWxlZFxuIik7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXJfcHRwLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhcl9wdHAuYw0KaW5kZXggZjY3
YjhhZS4uNjljM2FkZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9naWFuZmFyX3B0cC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lh
bmZhcl9wdHAuYw0KQEAgLTEyNyw3ICsxMjcsNiBAQCBzdHJ1Y3QgZ2lhbmZhcl9wdHBfcmVnaXN0
ZXJzIHsNCiANCiAjZGVmaW5lIERSSVZFUgkJImdpYW5mYXJfcHRwIg0KICNkZWZpbmUgREVGQVVM
VF9DS1NFTAkxDQotI2RlZmluZSBOX0FMQVJNCQkxIC8qIGZpcnN0IGFsYXJtIGlzIHVzZWQgaW50
ZXJuYWxseSB0byByZXNldCBmaXBlcnMgKi8NCiAjZGVmaW5lIE5fRVhUX1RTCTINCiAjZGVmaW5l
IFJFR19TSVpFCXNpemVvZihzdHJ1Y3QgZ2lhbmZhcl9wdHBfcmVnaXN0ZXJzKQ0KIA0KQEAgLTQx
MCw3ICs0MDksNyBAQCBzdGF0aWMgc3RydWN0IHB0cF9jbG9ja19pbmZvIHB0cF9naWFuZmFyX2Nh
cHMgPSB7DQogCS5vd25lcgkJPSBUSElTX01PRFVMRSwNCiAJLm5hbWUJCT0gImdpYW5mYXIgY2xv
Y2siLA0KIAkubWF4X2Fkagk9IDUxMjAwMCwNCi0JLm5fYWxhcm0JPSBOX0FMQVJNLA0KKwkubl9h
bGFybQk9IDAsDQogCS5uX2V4dF90cwk9IE5fRVhUX1RTLA0KIAkubl9wZXJfb3V0CT0gMCwNCiAJ
LnBwcwkJPSAxLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2Jl
L2l4Z2JlX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21h
aW4uYw0KaW5kZXggNDEzOTZmYS4uZDkzZWVlMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQpAQCAtMTkzNyw2ICsxOTM3LDE2IEBAIHN0YXRp
YyBpcnFyZXR1cm5fdCBpeGdiZV9tc2l4X290aGVyKGludCBpcnEsIHZvaWQgKmRhdGEpDQogCSAq
IHdpdGggdGhlIHdyaXRlIHRvIEVJQ1IuDQogCSAqLw0KIAllaWNyID0gSVhHQkVfUkVBRF9SRUco
aHcsIElYR0JFX0VJQ1MpOw0KKw0KKwkvKiBUaGUgbG93ZXIgMTZiaXRzIG9mIHRoZSBFSUNSIHJl
Z2lzdGVyIGFyZSBmb3IgdGhlIHF1ZXVlIGludGVycnVwdHMNCisJICogd2hpY2ggc2hvdWxkIGJl
IG1hc2tlZCBoZXJlIGluIG9yZGVyIHRvIG5vdCBhY2NpZGVudGx5IGNsZWFyIHRoZW0gaWYNCisJ
ICogdGhlIGJpdHMgYXJlIGhpZ2ggd2hlbiBpeGdiZV9tc2l4X290aGVyIGlzIGNhbGxlZC4gVGhl
cmUgaXMgYSByYWNlDQorCSAqIGNvbmRpdGlvbiBvdGhlcndpc2Ugd2hpY2ggcmVzdWx0cyBpbiBw
b3NzaWJsZSBwZXJmb3JtYW5jZSBsb3NzDQorCSAqIGVzcGVjaWFsbHkgaWYgdGhlIGl4Z2JlX21z
aXhfb3RoZXIgaW50ZXJydXB0IGlzIHRyaWdnZXJpbmcNCisJICogY29uc2lzdGVudGx5IChhcyBp
dCB3b3VsZCB3aGVuIFBQUyBpcyB0dXJuZWQgb24gZm9yIHRoZSBYNTQwIGRldmljZSkNCisJICov
DQorCWVpY3IgJj0gMHhGRkZGMDAwMDsNCisNCiAJSVhHQkVfV1JJVEVfUkVHKGh3LCBJWEdCRV9F
SUNSLCBlaWNyKTsNCiANCiAJaWYgKGVpY3IgJiBJWEdCRV9FSUNSX0xTQykNCkBAIC01NDA4LDcg
KzU0MTgsOSBAQCBzdGF0aWMgaW50IGl4Z2JlX3Jlc3VtZShzdHJ1Y3QgcGNpX2RldiAqcGRldikN
CiANCiAJcGNpX3dha2VfZnJvbV9kMyhwZGV2LCBmYWxzZSk7DQogDQorCXJ0bmxfbG9jaygpOw0K
IAllcnIgPSBpeGdiZV9pbml0X2ludGVycnVwdF9zY2hlbWUoYWRhcHRlcik7DQorCXJ0bmxfdW5s
b2NrKCk7DQogCWlmIChlcnIpIHsNCiAJCWVfZGV2X2VycigiQ2Fubm90IGluaXRpYWxpemUgaW50
ZXJydXB0cyBmb3IgZGV2aWNlXG4iKTsNCiAJCXJldHVybiBlcnI7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OS5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVhbHRlay9yODE2OS5jDQppbmRleCBkODEyNzkwLi5mNjk4MTgzIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZWFsdGVrL3I4MTY5LmMNCkBAIC0xNjI5LDggKzE2MjksNiBAQCBzdGF0aWMgdm9pZCBy
dGw4MTY5X3J4X3ZsYW5fdGFnKHN0cnVjdCBSeERlc2MgKmRlc2MsIHN0cnVjdCBza19idWZmICpz
a2IpDQogDQogCWlmIChvcHRzMiAmIFJ4VmxhblRhZykNCiAJCV9fdmxhbl9od2FjY2VsX3B1dF90
YWcoc2tiLCBzd2FiMTYob3B0czIgJiAweGZmZmYpKTsNCi0NCi0JZGVzYy0+b3B0czIgPSAwOw0K
IH0NCiANCiBzdGF0aWMgaW50IHJ0bDgxNjlfZ3NldF90Ymkoc3RydWN0IG5ldF9kZXZpY2UgKmRl
diwgc3RydWN0IGV0aHRvb2xfY21kICpjbWQpDQpAQCAtNTU2Niw2ICs1NTY0LDE0IEBAIHN0YXRp
YyBuZXRkZXZfdHhfdCBydGw4MTY5X3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJ
CWdvdG8gZXJyX3N0b3BfMDsNCiAJfQ0KIA0KKwkvKiA4MTY4ZXZsIGRvZXMgbm90IGF1dG9tYXRp
Y2FsbHkgcGFkIHRvIG1pbmltdW0gbGVuZ3RoLiAqLw0KKwlpZiAodW5saWtlbHkodHAtPm1hY192
ZXJzaW9uID09IFJUTF9HSUdBX01BQ19WRVJfMzQgJiYNCisJCSAgICAgc2tiLT5sZW4gPCBFVEhf
WkxFTikpIHsNCisJCWlmIChza2JfcGFkdG8oc2tiLCBFVEhfWkxFTikpDQorCQkJZ290byBlcnJf
dXBkYXRlX3N0YXRzOw0KKwkJc2tiX3B1dChza2IsIEVUSF9aTEVOIC0gc2tiLT5sZW4pOw0KKwl9
DQorDQogCWlmICh1bmxpa2VseShsZTMyX3RvX2NwdSh0eGQtPm9wdHMxKSAmIERlc2NPd24pKQ0K
IAkJZ290byBlcnJfc3RvcF8wOw0KIA0KQEAgLTU2MzMsNiArNTYzOSw3IEBAIGVycl9kbWFfMToN
CiAJcnRsODE2OV91bm1hcF90eF9za2IoZCwgdHAtPnR4X3NrYiArIGVudHJ5LCB0eGQpOw0KIGVy
cl9kbWFfMDoNCiAJZGV2X2tmcmVlX3NrYihza2IpOw0KK2Vycl91cGRhdGVfc3RhdHM6DQogCWRl
di0+c3RhdHMudHhfZHJvcHBlZCsrOw0KIAlyZXR1cm4gTkVUREVWX1RYX09LOw0KIA0KQEAgLTU4
MTQsNyArNTgyMSw2IEBAIHN0YXRpYyBpbnQgcnRsODE2OV9yeF9pbnRlcnJ1cHQoc3RydWN0IG5l
dF9kZXZpY2UgKmRldiwNCiAJCQkJcnRsODE2OV9zY2hlZHVsZV93b3JrKGRldiwgcnRsODE2OV9y
ZXNldF90YXNrKTsNCiAJCQkJZGV2LT5zdGF0cy5yeF9maWZvX2Vycm9ycysrOw0KIAkJCX0NCi0J
CQlydGw4MTY5X21hcmtfdG9fYXNpYyhkZXNjLCByeF9idWZfc3opOw0KIAkJfSBlbHNlIHsNCiAJ
CQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KIAkJCWRtYV9hZGRyX3QgYWRkciA9IGxlNjRfdG9fY3B1
KGRlc2MtPmFkZHIpOw0KQEAgLTU4MjgsMTYgKzU4MzQsMTQgQEAgc3RhdGljIGludCBydGw4MTY5
X3J4X2ludGVycnVwdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KIAkJCWlmICh1bmxpa2VseShy
dGw4MTY5X2ZyYWdtZW50ZWRfZnJhbWUoc3RhdHVzKSkpIHsNCiAJCQkJZGV2LT5zdGF0cy5yeF9k
cm9wcGVkKys7DQogCQkJCWRldi0+c3RhdHMucnhfbGVuZ3RoX2Vycm9ycysrOw0KLQkJCQlydGw4
MTY5X21hcmtfdG9fYXNpYyhkZXNjLCByeF9idWZfc3opOw0KLQkJCQljb250aW51ZTsNCisJCQkJ
Z290byByZWxlYXNlX2Rlc2NyaXB0b3I7DQogCQkJfQ0KIA0KIAkJCXNrYiA9IHJ0bDgxNjlfdHJ5
X3J4X2NvcHkodHAtPlJ4X2RhdGFidWZmW2VudHJ5XSwNCiAJCQkJCQkgIHRwLCBwa3Rfc2l6ZSwg
YWRkcik7DQotCQkJcnRsODE2OV9tYXJrX3RvX2FzaWMoZGVzYywgcnhfYnVmX3N6KTsNCiAJCQlp
ZiAoIXNrYikgew0KIAkJCQlkZXYtPnN0YXRzLnJ4X2Ryb3BwZWQrKzsNCi0JCQkJY29udGludWU7
DQorCQkJCWdvdG8gcmVsZWFzZV9kZXNjcmlwdG9yOw0KIAkJCX0NCiANCiAJCQlydGw4MTY5X3J4
X2NzdW0oc2tiLCBzdGF0dXMpOw0KQEAgLTU4NTEsNiArNTg1NSwxMCBAQCBzdGF0aWMgaW50IHJ0
bDgxNjlfcnhfaW50ZXJydXB0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQogCQkJZGV2LT5zdGF0
cy5yeF9ieXRlcyArPSBwa3Rfc2l6ZTsNCiAJCQlkZXYtPnN0YXRzLnJ4X3BhY2tldHMrKzsNCiAJ
CX0NCityZWxlYXNlX2Rlc2NyaXB0b3I6DQorCQlkZXNjLT5vcHRzMiA9IDA7DQorCQl3bWIoKTsN
CisJCXJ0bDgxNjlfbWFya190b19hc2ljKGRlc2MsIHJ4X2J1Zl9zeik7DQogCX0NCiANCiAJY291
bnQgPSBjdXJfcnggLSB0cC0+Y3VyX3J4Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2l3bHdpZmkvaXdsLWFnbi1zdGEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkv
aXdsLWFnbi1zdGEuYw0KaW5kZXggY2NmMTUyNC4uMzkzNTk5NCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1zdGEuYw0KKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXN0YS5jDQpAQCAtNTYzLDYgKzU2Myw3IEBAIHZvaWQg
aXdsX2NsZWFyX3Vjb2RlX3N0YXRpb25zKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwNCiB2b2lkIGl3
bF9yZXN0b3JlX3N0YXRpb25zKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgc3RydWN0IGl3bF9yeG9u
X2NvbnRleHQgKmN0eCkNCiB7DQogCXN0cnVjdCBpd2xfYWRkc3RhX2NtZCBzdGFfY21kOw0KKwlz
dGF0aWMgY29uc3Qgc3RydWN0IGl3bF9saW5rX3F1YWxpdHlfY21kIHplcm9fbHEgPSB7fTsNCiAJ
c3RydWN0IGl3bF9saW5rX3F1YWxpdHlfY21kIGxxOw0KIAl1bnNpZ25lZCBsb25nIGZsYWdzX3Nw
aW47DQogCWludCBpOw0KQEAgLTYwMiw3ICs2MDMsOSBAQCB2b2lkIGl3bF9yZXN0b3JlX3N0YXRp
b25zKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgc3RydWN0IGl3bF9yeG9uX2NvbnRleHQgKmN0eCkN
CiAJCQkJZWxzZQ0KIAkJCQkJbWVtY3B5KCZscSwgcHJpdi0+c3RhdGlvbnNbaV0ubHEsDQogCQkJ
CQkgICAgICAgc2l6ZW9mKHN0cnVjdCBpd2xfbGlua19xdWFsaXR5X2NtZCkpOw0KLQkJCQlzZW5k
X2xxID0gdHJ1ZTsNCisNCisJCQkJaWYgKCFtZW1jbXAoJmxxLCAmemVyb19scSwgc2l6ZW9mKGxx
KSkpDQorCQkJCQlzZW5kX2xxID0gdHJ1ZTsNCiAJCQl9DQogCQkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmcHJpdi0+c2hyZC0+c3RhX2xvY2ssDQogCQkJCQkgICAgICAgZmxhZ3Nfc3Bpbik7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9wY2llLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9td2lmaWV4L3BjaWUuYw0KaW5kZXggM2NmNGVjYy4uNjIxYjg0ZiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvcGNpZS5jDQorKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3BjaWUuYw0KQEAgLTE4MjEsOSArMTgyMSw5IEBAIHN0
YXRpYyB2b2lkIG13aWZpZXhfcGNpZV9jbGVhbnVwKHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFk
YXB0ZXIpDQogCWlmIChwZGV2KSB7DQogCQlwY2lfaW91bm1hcChwZGV2LCBjYXJkLT5wY2lfbW1h
cCk7DQogCQlwY2lfaW91bm1hcChwZGV2LCBjYXJkLT5wY2lfbW1hcDEpOw0KLQ0KLQkJcGNpX3Jl
bGVhc2VfcmVnaW9ucyhwZGV2KTsNCiAJCXBjaV9kaXNhYmxlX2RldmljZShwZGV2KTsNCisJCXBj
aV9yZWxlYXNlX3JlZ2lvbihwZGV2LCAyKTsNCisJCXBjaV9yZWxlYXNlX3JlZ2lvbihwZGV2LCAw
KTsNCiAJCXBjaV9zZXRfZHJ2ZGF0YShwZGV2LCBOVUxMKTsNCiAJfQ0KIH0NCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3BjaS9wY2kuYyBiL2RyaXZlcnMvcGNpL3BjaS5jDQppbmRleCA2ZDRhNTMxLi4z
NjNhNWM2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMNCisrKyBiL2RyaXZlcnMvcGNp
L3BjaS5jDQpAQCAtNjY0LDE1ICs2NjQsMTEgQEAgc3RhdGljIGludCBwY2lfcGxhdGZvcm1fcG93
ZXJfdHJhbnNpdGlvbihzdHJ1Y3QgcGNpX2RldiAqZGV2LCBwY2lfcG93ZXJfdCBzdGF0ZSkNCiAJ
CWVycm9yID0gcGxhdGZvcm1fcGNpX3NldF9wb3dlcl9zdGF0ZShkZXYsIHN0YXRlKTsNCiAJCWlm
ICghZXJyb3IpDQogCQkJcGNpX3VwZGF0ZV9jdXJyZW50X3N0YXRlKGRldiwgc3RhdGUpOw0KLQkJ
LyogRmFsbCBiYWNrIHRvIFBDSV9EMCBpZiBuYXRpdmUgUE0gaXMgbm90IHN1cHBvcnRlZCAqLw0K
LQkJaWYgKCFkZXYtPnBtX2NhcCkNCi0JCQlkZXYtPmN1cnJlbnRfc3RhdGUgPSBQQ0lfRDA7DQot
CX0gZWxzZSB7DQorCX0gZWxzZQ0KIAkJZXJyb3IgPSAtRU5PREVWOw0KLQkJLyogRmFsbCBiYWNr
IHRvIFBDSV9EMCBpZiBuYXRpdmUgUE0gaXMgbm90IHN1cHBvcnRlZCAqLw0KLQkJaWYgKCFkZXYt
PnBtX2NhcCkNCi0JCQlkZXYtPmN1cnJlbnRfc3RhdGUgPSBQQ0lfRDA7DQotCX0NCisNCisJaWYg
KGVycm9yICYmICFkZXYtPnBtX2NhcCkgLyogRmFsbCBiYWNrIHRvIFBDSV9EMCAqLw0KKwkJZGV2
LT5jdXJyZW50X3N0YXRlID0gUENJX0QwOw0KIA0KIAlyZXR1cm4gZXJyb3I7DQogfQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvcnRjL3J0Yy1jbW9zLmMgYi9kcml2ZXJzL3J0Yy9ydGMtY21vcy5jDQpp
bmRleCAwNWJlYjZjLi5lM2VlZDE4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ydGMvcnRjLWNtb3Mu
Yw0KKysrIGIvZHJpdmVycy9ydGMvcnRjLWNtb3MuYw0KQEAgLTgwNSw5ICs4MDUsOCBAQCBzdGF0
aWMgaW50IGNtb3Nfc3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCQkJbWFzayA9IFJUQ19J
UlFNQVNLOw0KIAkJdG1wICY9IH5tYXNrOw0KIAkJQ01PU19XUklURSh0bXAsIFJUQ19DT05UUk9M
KTsNCisJCWhwZXRfbWFza19ydGNfaXJxX2JpdChtYXNrKTsNCiANCi0JCS8qIHNodXQgZG93biBo
cGV0IGVtdWxhdGlvbiAtIHdlIGRvbid0IG5lZWQgaXQgZm9yIGFsYXJtICovDQotCQlocGV0X21h
c2tfcnRjX2lycV9iaXQoUlRDX1BJRXxSVENfQUlFfFJUQ19VSUUpOw0KIAkJY21vc19jaGVja2lu
dHIoY21vcywgdG1wKTsNCiAJfQ0KIAlzcGluX3VubG9ja19pcnEoJnJ0Y19sb2NrKTsNCkBAIC04
NzIsNiArODcxLDcgQEAgc3RhdGljIGludCBjbW9zX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYp
DQogCQkJcnRjX3VwZGF0ZV9pcnEoY21vcy0+cnRjLCAxLCBtYXNrKTsNCiAJCQl0bXAgJj0gflJU
Q19BSUU7DQogCQkJaHBldF9tYXNrX3J0Y19pcnFfYml0KFJUQ19BSUUpOw0KKwkJCWhwZXRfcnRj
X3RpbWVyX2luaXQoKTsNCiAJCX0gd2hpbGUgKG1hc2sgJiBSVENfQUlFKTsNCiAJCXNwaW5fdW5s
b2NrX2lycSgmcnRjX2xvY2spOw0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zMzkwL2NoYXIv
c2NscF9jbWQuYyBiL2RyaXZlcnMvczM5MC9jaGFyL3NjbHBfY21kLmMNCmluZGV4IDBiNTRhOTEu
LmE1NmExNWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3MzOTAvY2hhci9zY2xwX2NtZC5jDQorKysg
Yi9kcml2ZXJzL3MzOTAvY2hhci9zY2xwX2NtZC5jDQpAQCAtNTA5LDYgKzUwOSw4IEBAIHN0YXRp
YyB2b2lkIF9faW5pdCBzY2xwX2FkZF9zdGFuZGJ5X21lbW9yeSh2b2lkKQ0KIAlhZGRfbWVtb3J5
X21lcmdlZCgwKTsNCiB9DQogDQorI2RlZmluZSBNRU1fU0NUX1NJWkUgKDFVTCA8PCBTRUNUSU9O
X1NJWkVfQklUUykNCisNCiBzdGF0aWMgdm9pZCBfX2luaXQgaW5zZXJ0X2luY3JlbWVudCh1MTYg
cm4sIGludCBzdGFuZGJ5LCBpbnQgYXNzaWduZWQpDQogew0KIAlzdHJ1Y3QgbWVtb3J5X2luY3Jl
bWVudCAqaW5jciwgKm5ld19pbmNyOw0KQEAgLTUyMSw3ICs1MjMsNyBAQCBzdGF0aWMgdm9pZCBf
X2luaXQgaW5zZXJ0X2luY3JlbWVudCh1MTYgcm4sIGludCBzdGFuZGJ5LCBpbnQgYXNzaWduZWQp
DQogCW5ld19pbmNyLT5ybiA9IHJuOw0KIAluZXdfaW5jci0+c3RhbmRieSA9IHN0YW5kYnk7DQog
CWlmICghc3RhbmRieSkNCi0JCW5ld19pbmNyLT51c2Vjb3VudCA9IDE7DQorCQluZXdfaW5jci0+
dXNlY291bnQgPSByem0gPiBNRU1fU0NUX1NJWkUgPyByem0vTUVNX1NDVF9TSVpFIDogMTsNCiAJ
bGFzdF9ybiA9IDA7DQogCXByZXYgPSAmc2NscF9tZW1fbGlzdDsNCiAJbGlzdF9mb3JfZWFjaF9l
bnRyeShpbmNyLCAmc2NscF9tZW1fbGlzdCwgbGlzdCkgew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dHR5L3B0eS5jIGIvZHJpdmVycy90dHkvcHR5LmMNCmluZGV4IGQxOWI4NzkuLjQ3MzU5MjggMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3R0eS9wdHkuYw0KKysrIGIvZHJpdmVycy90dHkvcHR5LmMNCkBA
IC02NjksNiArNjY5LDkgQEAgc3RhdGljIGludCBwdG14X29wZW4oc3RydWN0IGlub2RlICppbm9k
ZSwgc3RydWN0IGZpbGUgKmZpbHApDQogDQogCW5vbnNlZWthYmxlX29wZW4oaW5vZGUsIGZpbHAp
Ow0KIA0KKwkvKiBXZSByZWZ1c2UgZnNub3RpZnkgZXZlbnRzIG9uIHB0bXgsIHNpbmNlIGl0J3Mg
YSBzaGFyZWQgcmVzb3VyY2UgKi8NCisJZmlscC0+Zl9tb2RlIHw9IEZNT0RFX05PTk9USUZZOw0K
Kw0KIAlyZXR2YWwgPSB0dHlfYWxsb2NfZmlsZShmaWxwKTsNCiAJaWYgKHJldHZhbCkNCiAJCXJl
dHVybiByZXR2YWw7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvc2VyaWFsL3NlcmlhbF9jb3Jl
LmMgYi9kcml2ZXJzL3R0eS9zZXJpYWwvc2VyaWFsX2NvcmUuYw0KaW5kZXggYWY1ZmZiOS4uNDg4
MjE0YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdHR5L3NlcmlhbC9zZXJpYWxfY29yZS5jDQorKysg
Yi9kcml2ZXJzL3R0eS9zZXJpYWwvc2VyaWFsX2NvcmUuYw0KQEAgLTE5MDEsNiArMTkwMSw4IEBA
IGludCB1YXJ0X3N1c3BlbmRfcG9ydChzdHJ1Y3QgdWFydF9kcml2ZXIgKmRydiwgc3RydWN0IHVh
cnRfcG9ydCAqdXBvcnQpDQogCQltdXRleF91bmxvY2soJnBvcnQtPm11dGV4KTsNCiAJCXJldHVy
biAwOw0KIAl9DQorCXB1dF9kZXZpY2UodHR5X2Rldik7DQorDQogCWlmIChjb25zb2xlX3N1c3Bl
bmRfZW5hYmxlZCB8fCAhdWFydF9jb25zb2xlKHVwb3J0KSkNCiAJCXVwb3J0LT5zdXNwZW5kZWQg
PSAxOw0KIA0KQEAgLTE5NjYsOSArMTk2OCwxMSBAQCBpbnQgdWFydF9yZXN1bWVfcG9ydChzdHJ1
Y3QgdWFydF9kcml2ZXIgKmRydiwgc3RydWN0IHVhcnRfcG9ydCAqdXBvcnQpDQogCQkJZGlzYWJs
ZV9pcnFfd2FrZSh1cG9ydC0+aXJxKTsNCiAJCQl1cG9ydC0+aXJxX3dha2UgPSAwOw0KIAkJfQ0K
KwkJcHV0X2RldmljZSh0dHlfZGV2KTsNCiAJCW11dGV4X3VubG9jaygmcG9ydC0+bXV0ZXgpOw0K
IAkJcmV0dXJuIDA7DQogCX0NCisJcHV0X2RldmljZSh0dHlfZGV2KTsNCiAJdXBvcnQtPnN1c3Bl
bmRlZCA9IDA7DQogDQogCS8qDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvdHR5X2lvLmMgYi9k
cml2ZXJzL3R0eS90dHlfaW8uYw0KaW5kZXggMDUwODViZS4uM2YzNWU0MiAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvdHR5L3R0eV9pby5jDQorKysgYi9kcml2ZXJzL3R0eS90dHlfaW8uYw0KQEAgLTk0
MCw2ICs5NDAsMTQgQEAgdm9pZCBzdGFydF90dHkoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSkNCiAN
CiBFWFBPUlRfU1lNQk9MKHN0YXJ0X3R0eSk7DQogDQorLyogV2UgbGltaXQgdHR5IHRpbWUgdXBk
YXRlIHZpc2liaWxpdHkgdG8gZXZlcnkgOCBzZWNvbmRzIG9yIHNvLiAqLw0KK3N0YXRpYyB2b2lk
IHR0eV91cGRhdGVfdGltZShzdHJ1Y3QgdGltZXNwZWMgKnRpbWUpDQorew0KKwl1bnNpZ25lZCBs
b25nIHNlYyA9IGdldF9zZWNvbmRzKCkgJiB+NzsNCisJaWYgKChsb25nKShzZWMgLSB0aW1lLT50
dl9zZWMpID4gMCkNCisJCXRpbWUtPnR2X3NlYyA9IHNlYzsNCit9DQorDQogLyoqDQogICoJdHR5
X3JlYWQJLQlyZWFkIG1ldGhvZCBmb3IgdHR5IGRldmljZSBmaWxlcw0KICAqCUBmaWxlOiBwb2lu
dGVyIHRvIHR0eSBmaWxlDQpAQCAtOTc2LDggKzk4NCwxMCBAQCBzdGF0aWMgc3NpemVfdCB0dHlf
cmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhciBfX3VzZXIgKmJ1Ziwgc2l6ZV90IGNvdW50LA0K
IAllbHNlDQogCQlpID0gLUVJTzsNCiAJdHR5X2xkaXNjX2RlcmVmKGxkKTsNCisNCiAJaWYgKGkg
PiAwKQ0KLQkJaW5vZGUtPmlfYXRpbWUgPSBjdXJyZW50X2ZzX3RpbWUoaW5vZGUtPmlfc2IpOw0K
KwkJdHR5X3VwZGF0ZV90aW1lKCZpbm9kZS0+aV9hdGltZSk7DQorDQogCXJldHVybiBpOw0KIH0N
CiANCkBAIC0xMDc5LDggKzEwODksOCBAQCBzdGF0aWMgaW5saW5lIHNzaXplX3QgZG9fdHR5X3dy
aXRlKA0KIAkJY29uZF9yZXNjaGVkKCk7DQogCX0NCiAJaWYgKHdyaXR0ZW4pIHsNCi0JCXN0cnVj
dCBpbm9kZSAqaW5vZGUgPSBmaWxlLT5mX3BhdGguZGVudHJ5LT5kX2lub2RlOw0KLQkJaW5vZGUt
PmlfbXRpbWUgPSBjdXJyZW50X2ZzX3RpbWUoaW5vZGUtPmlfc2IpOw0KKyAgICAgICAgICAgICAg
IHN0cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlLT5mX3BhdGguZGVudHJ5LT5kX2lub2RlOw0KKwkJ
dHR5X3VwZGF0ZV90aW1lKCZpbm9kZS0+aV9tdGltZSk7DQogCQlyZXQgPSB3cml0dGVuOw0KIAl9
DQogb3V0Og0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvZGV2aW8uYyBiL2RyaXZlcnMv
dXNiL2NvcmUvZGV2aW8uYw0KaW5kZXggYTlkZjIxOC4uMjJmNzcwYSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdXNiL2NvcmUvZGV2aW8uYw0KKysrIGIvZHJpdmVycy91c2IvY29yZS9kZXZpby5jDQpA
QCAtNjQzLDYgKzY0Myw4IEBAIHN0YXRpYyBpbnQgY2hlY2tfY3RybHJlY2lwKHN0cnVjdCBkZXZf
c3RhdGUgKnBzLCB1bnNpZ25lZCBpbnQgcmVxdWVzdHR5cGUsDQogCWluZGV4ICY9IDB4ZmY7DQog
CXN3aXRjaCAocmVxdWVzdHR5cGUgJiBVU0JfUkVDSVBfTUFTSykgew0KIAljYXNlIFVTQl9SRUNJ
UF9FTkRQT0lOVDoNCisJCWlmICgoaW5kZXggJiB+VVNCX0RJUl9JTikgPT0gMCkNCisJCQlyZXR1
cm4gMDsNCiAJCXJldCA9IGZpbmRpbnRmZXAocHMtPmRldiwgaW5kZXgpOw0KIAkJaWYgKHJldCA+
PSAwKQ0KIAkJCXJldCA9IGNoZWNraW50ZihwcywgcmV0KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9taXNjL2FwcGxlZGlzcGxheS5jIGIvZHJpdmVycy91c2IvbWlzYy9hcHBsZWRpc3BsYXku
Yw0KaW5kZXggYWMwZDc1YS4uOWY3MDAzZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL21pc2Mv
YXBwbGVkaXNwbGF5LmMNCisrKyBiL2RyaXZlcnMvdXNiL21pc2MvYXBwbGVkaXNwbGF5LmMNCkBA
IC02Myw2ICs2Myw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBhcHBsZWRp
c3BsYXlfdGFibGVbXSA9IHsNCiAJeyBBUFBMRURJU1BMQVlfREVWSUNFKDB4OTIxOSkgfSwNCiAJ
eyBBUFBMRURJU1BMQVlfREVWSUNFKDB4OTIxYykgfSwNCiAJeyBBUFBMRURJU1BMQVlfREVWSUNF
KDB4OTIxZCkgfSwNCisJeyBBUFBMRURJU1BMQVlfREVWSUNFKDB4OTIzNikgfSwNCiANCiAJLyog
VGVybWluYXRpbmcgZW50cnkgKi8NCiAJeyB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2Vy
aWFsL2Z0ZGlfc2lvLmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYw0KaW5kZXggMDYz
OTRlNWEuLjUxZDE3MTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8u
Yw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvLmMNCkBAIC0xOTUsNiArMTk1LDcg
QEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlX2NvbWJpbmVkIFtdID0gew0K
IAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfT1BFTkRDQ19USFJPVFRMRV9QSUQpIH0sDQog
CXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9PUEVORENDX0dBVEVXQVlfUElEKSB9LA0KIAl7
IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfT1BFTkRDQ19HQk1fUElEKSB9LA0KKwl7IFVTQl9E
RVZJQ0UoRlRESV9WSUQsIEZURElfT1BFTkRDQ19HQk1fQk9PU1RfUElEKSB9LA0KIAl7IFVTQl9E
RVZJQ0UoTkVXUE9SVF9WSUQsIE5FV1BPUlRfQUdJTElTX1BJRCkgfSwNCiAJeyBVU0JfREVWSUNF
KElOVEVSQklPTUVUUklDU19WSUQsIElOVEVSQklPTUVUUklDU19JT0JPQVJEX1BJRCkgfSwNCiAJ
eyBVU0JfREVWSUNFKElOVEVSQklPTUVUUklDU19WSUQsIElOVEVSQklPTUVUUklDU19NSU5JX0lP
Qk9BUkRfUElEKSB9LA0KQEAgLTg3Niw3ICs4NzcsOSBAQCBzdGF0aWMgc3RydWN0IHVzYl9kZXZp
Y2VfaWQgaWRfdGFibGVfY29tYmluZWQgW10gPSB7DQogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwg
RlRESV9ET1RFQ19QSUQpIH0sDQogCXsgVVNCX0RFVklDRShRSUhBUkRXQVJFX1ZJRCwgTUlMS1lN
SVNUT05FX0pUQUdTRVJJQUxfUElEKSwNCiAJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdf
dCkmZnRkaV9qdGFnX3F1aXJrIH0sDQotCXsgVVNCX0RFVklDRShTVF9WSUQsIFNUX1NUTUNMVDEw
MzBfUElEKSwNCisJeyBVU0JfREVWSUNFKFNUX1ZJRCwgU1RfU1RNQ0xUXzIyMzJfUElEKSwNCisJ
CS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmZnRkaV9qdGFnX3F1aXJrIH0sDQorCXsg
VVNCX0RFVklDRShTVF9WSUQsIFNUX1NUTUNMVF80MjMyX1BJRCksDQogCQkuZHJpdmVyX2luZm8g
PSAoa2VybmVsX3Vsb25nX3QpJmZ0ZGlfc3RtY2xpdGVfcXVpcmsgfSwNCiAJeyBVU0JfREVWSUNF
KEZURElfVklELCBGVERJX1JGX1IxMDYpIH0sDQogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRE
SV9ESVNUT1JURUNfSlRBR19MT0NLX1BJQ0tfUElEKSwNCkBAIC0xODE2LDggKzE4MTksMTEgQEAg
c3RhdGljIGludCBmdGRpXzh1MjIzMmNfcHJvYmUoc3RydWN0IHVzYl9zZXJpYWwgKnNlcmlhbCkN
CiB9DQogDQogLyoNCi0gKiBGaXJzdCBhbmQgc2Vjb25kIHBvcnQgb24gU1RNQ0xpdGVhZGFwdG9y
cyBpcyByZXNlcnZlZCBmb3IgSlRBRyBpbnRlcmZhY2UNCi0gKiBhbmQgdGhlIGZvcnRoIHBvcnQg
Zm9yIHBpbw0KKyAqIEZpcnN0IHR3byBwb3J0cyBvbiBKVEFHIGFkYXB0b3JzIHVzaW5nIGFuIEZU
NDIzMiBzdWNoIGFzIFNUTWljcm9lbGVjdHJvbmljcydzDQorICogU1QgTWljcm8gQ29ubmVjdCBM
aXRlIGFyZSByZXNlcnZlZCBmb3IgSlRBRyBvciBvdGhlciBub24tVUFSVCBpbnRlcmZhY2VzIGFu
ZA0KKyAqIGNhbiBiZSBhY2Nlc3NlZCBmcm9tIHVzZXJzcGFjZS4NCisgKiBUaGUgbmV4dCB0d28g
cG9ydHMgYXJlIGVuYWJsZWQgYXMgVUFSVHMgYnkgZGVmYXVsdCwgd2hlcmUgcG9ydCAyIGlzDQor
ICogYSBjb252ZW50aW9uYWwgUlMtMjMyIFVBUlQuDQogICovDQogc3RhdGljIGludCBmdGRpX3N0
bWNsaXRlX3Byb2JlKHN0cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwpDQogew0KQEAgLTE4MjYsMTIg
KzE4MzIsMTMgQEAgc3RhdGljIGludCBmdGRpX3N0bWNsaXRlX3Byb2JlKHN0cnVjdCB1c2Jfc2Vy
aWFsICpzZXJpYWwpDQogDQogCWRiZygiJXMiLCBfX2Z1bmNfXyk7DQogDQotCWlmIChpbnRlcmZh
Y2UgPT0gdWRldi0+YWN0Y29uZmlnLT5pbnRlcmZhY2VbMl0pDQotCQlyZXR1cm4gMDsNCi0NCi0J
ZGV2X2luZm8oJnVkZXYtPmRldiwgIklnbm9yaW5nIHNlcmlhbCBwb3J0IHJlc2VydmVkIGZvciBK
VEFHXG4iKTsNCisJaWYgKGludGVyZmFjZSA9PSB1ZGV2LT5hY3Rjb25maWctPmludGVyZmFjZVsw
XSB8fA0KKwkgICAgaW50ZXJmYWNlID09IHVkZXYtPmFjdGNvbmZpZy0+aW50ZXJmYWNlWzFdKSB7
DQorCQlkZXZfaW5mbygmdWRldi0+ZGV2LCAiSWdub3Jpbmcgc2VyaWFsIHBvcnQgcmVzZXJ2ZWQg
Zm9yIEpUQUdcbiIpOw0KKwkJcmV0dXJuIC1FTk9ERVY7DQorCX0NCiANCi0JcmV0dXJuIC1FTk9E
RVY7DQorCXJldHVybiAwOw0KIH0NCiANCiAvKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3Nl
cmlhbC9mdGRpX3Npb19pZHMuaCBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaA0K
aW5kZXggODA5YzAzYS4uMmY4NjAwOCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9m
dGRpX3Npb19pZHMuaA0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvX2lkcy5oDQpA
QCAtNzQsNiArNzQsNyBAQA0KICNkZWZpbmUgRlRESV9PUEVORENDX1RIUk9UVExFX1BJRAkweEJG
REENCiAjZGVmaW5lIEZURElfT1BFTkRDQ19HQVRFV0FZX1BJRAkweEJGREINCiAjZGVmaW5lIEZU
RElfT1BFTkRDQ19HQk1fUElECTB4QkZEQw0KKyNkZWZpbmUgRlRESV9PUEVORENDX0dCTV9CT09T
VF9QSUQJMHhCRkREDQogDQogLyogTlpSIFNFTSAxNisgVVNCIChodHRwOi8vd3d3Lm56ci5kZSkg
Ki8NCiAjZGVmaW5lIEZURElfTlpSX1NFTV9VU0JfUElECTB4QzFFMAkvKiBOWlIgU0VNLUxPRzE2
KyAqLw0KQEAgLTExNTAsNyArMTE1MSw4IEBADQogICogU1RNaWNyb2VsZWN0b25pY3MNCiAgKi8N
CiAjZGVmaW5lIFNUX1ZJRAkJCTB4MDQ4Mw0KLSNkZWZpbmUgU1RfU1RNQ0xUMTAzMF9QSUQJMHgz
NzQ3IC8qIFNUIE1pY3JvIENvbm5lY3QgTGl0ZSBTVE1DTFQxMDMwICovDQorI2RlZmluZSBTVF9T
VE1DTFRfMjIzMl9QSUQJMHgzNzQ2DQorI2RlZmluZSBTVF9TVE1DTFRfNDIzMl9QSUQJMHgzNzQ3
DQogDQogLyoNCiAgKiBQYXBvdWNoIHByb2R1Y3RzIChodHRwOi8vd3d3LnBhcG91Y2guY29tLykN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMgYi9kcml2ZXJzL3VzYi9z
ZXJpYWwvb3B0aW9uLmMNCmluZGV4IDQ0MTg1MzguLjg1MTNmNTEgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24u
Yw0KQEAgLTM0Nyw2ICszNDcsNyBAQCBzdGF0aWMgdm9pZCBvcHRpb25faW5zdGF0X2NhbGxiYWNr
KHN0cnVjdCB1cmIgKnVyYik7DQogLyogT2xpdmV0dGkgcHJvZHVjdHMgKi8NCiAjZGVmaW5lIE9M
SVZFVFRJX1ZFTkRPUl9JRAkJCTB4MGIzYw0KICNkZWZpbmUgT0xJVkVUVElfUFJPRFVDVF9PTElD
QVJEMTAwCQkweGMwMDANCisjZGVmaW5lIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FSRDE0NQkJMHhj
MDAzDQogDQogLyogQ2Vsb3QgcHJvZHVjdHMgKi8NCiAjZGVmaW5lIENFTE9UX1ZFTkRPUl9JRAkJ
CQkweDIxMWYNCkBAIC0xMjczLDYgKzEyNzQsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9k
ZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0KIAl7IFVTQl9ERVZJQ0UoU0lFTUVOU19WRU5ET1Jf
SUQsIENJTlRFUklPTl9QUk9EVUNUX0hDMjhfTURNTkVUKSB9LA0KIA0KIAl7IFVTQl9ERVZJQ0Uo
T0xJVkVUVElfVkVORE9SX0lELCBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQxMDApIH0sDQorCXsg
VVNCX0RFVklDRShPTElWRVRUSV9WRU5ET1JfSUQsIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FSRDE0
NSkgfSwNCiAJeyBVU0JfREVWSUNFKENFTE9UX1ZFTkRPUl9JRCwgQ0VMT1RfUFJPRFVDVF9DVDY4
ME0pIH0sIC8qIENULTY1MCBDRE1BIDQ1MCAxeEVWRE8gbW9kZW0gKi8NCiAJeyBVU0JfREVWSUNF
KE9OREFfVkVORE9SX0lELCBPTkRBX01UODI1VVApIH0sIC8qIE9OREEgTVQ4MjVVUCBtb2RlbSAq
Lw0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFNBTVNVTkdfVkVORE9SX0lELCBT
QU1TVU5HX1BST0RVQ1RfR1RfQjM3MzAsIFVTQl9DTEFTU19DRENfREFUQSwgMHgwMCwgMHgwMCkg
fSwgLyogU2Ftc3VuZyBHVC1CMzczMCBMVEUgVVNCIG1vZGVtLiovDQpAQCAtMTM1MCw2ICsxMzUy
LDEyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10gPSB7
DQogCXsgVVNCX0RFVklDRShUUExJTktfVkVORE9SX0lELCBUUExJTktfUFJPRFVDVF9NQTE4MCks
DQogCSAgLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZuZXRfaW50ZjRfYmxhY2tsaXN0
IH0sDQogCXsgVVNCX0RFVklDRShDSEFOR0hPTkdfVkVORE9SX0lELCBDSEFOR0hPTkdfUFJPRFVD
VF9DSDY5MCkgfSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTygweDIwMDEsIDB4
N2QwMSwgMHhmZiwgMHgwMiwgMHgwMSkgfSwJLyogRC1MaW5rIERXTS0xNTYgKHZhcmlhbnQpICov
DQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgyMDAxLCAweDdkMDEsIDB4ZmYs
IDB4MDAsIDB4MDApIH0sCS8qIEQtTGluayBEV00tMTU2ICh2YXJpYW50KSAqLw0KKwl7IFVTQl9E
RVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKDB4MjAwMSwgMHg3ZDAyLCAweGZmLCAweDAyLCAweDAx
KSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKDB4MjAwMSwgMHg3ZDAyLCAw
eGZmLCAweDAwLCAweDAwKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKDB4
MjAwMSwgMHg3ZDAzLCAweGZmLCAweDAyLCAweDAxKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lO
VEVSRkFDRV9JTkZPKDB4MjAwMSwgMHg3ZDAzLCAweGZmLCAweDAwLCAweDAwKSB9LA0KIAl7IH0g
LyogVGVybWluYXRpbmcgZW50cnkgKi8NCiB9Ow0KIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBv
cHRpb25faWRzKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zdG9yYWdlL2N5cHJlc3NfYXRh
Y2IuYyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvY3lwcmVzc19hdGFjYi5jDQppbmRleCBjODQ0NzE4
Li43MzQxY2UyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc3RvcmFnZS9jeXByZXNzX2F0YWNi
LmMNCisrKyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvY3lwcmVzc19hdGFjYi5jDQpAQCAtMjQ4LDE0
ICsyNDgsMjYgQEAgc3RhdGljIGludCBjeXByZXNzX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNl
ICppbnRmLA0KIHsNCiAJc3RydWN0IHVzX2RhdGEgKnVzOw0KIAlpbnQgcmVzdWx0Ow0KKwlzdHJ1
Y3QgdXNiX2RldmljZSAqZGV2aWNlOw0KIA0KIAlyZXN1bHQgPSB1c2Jfc3Rvcl9wcm9iZTEoJnVz
LCBpbnRmLCBpZCwNCiAJCQkoaWQgLSBjeXByZXNzX3VzYl9pZHMpICsgY3lwcmVzc191bnVzdWFs
X2Rldl9saXN0KTsNCiAJaWYgKHJlc3VsdCkNCiAJCXJldHVybiByZXN1bHQ7DQogDQotCXVzLT5w
cm90b2NvbF9uYW1lID0gIlRyYW5zcGFyZW50IFNDU0kgd2l0aCBDeXByZXNzIEFUQUNCIjsNCi0J
dXMtPnByb3RvX2hhbmRsZXIgPSBjeXByZXNzX2F0YWNiX3Bhc3N0aHJvdWdoOw0KKwkvKiBBbW9u
ZyBDWTdDNjgzMDAgY2hpcHMsIHRoZSBBIHJldmlzaW9uIGRvZXMgbm90IHN1cHBvcnQgQ3lwcmVz
cyBBVEFDQg0KKwkgKiBGaWx0ZXIgb3V0IHRoaXMgcmV2aXNpb24gZnJvbSBFRVBST00gZGVmYXVs
dCBkZXNjcmlwdG9yIHZhbHVlcw0KKwkgKi8NCisJZGV2aWNlID0gaW50ZXJmYWNlX3RvX3VzYmRl
dihpbnRmKTsNCisJaWYgKGRldmljZS0+ZGVzY3JpcHRvci5pTWFudWZhY3R1cmVyICE9IDB4Mzgg
fHwNCisJICAgIGRldmljZS0+ZGVzY3JpcHRvci5pUHJvZHVjdCAhPSAweDRlIHx8DQorCSAgICBk
ZXZpY2UtPmRlc2NyaXB0b3IuaVNlcmlhbE51bWJlciAhPSAweDY0KSB7DQorCQl1cy0+cHJvdG9j
b2xfbmFtZSA9ICJUcmFuc3BhcmVudCBTQ1NJIHdpdGggQ3lwcmVzcyBBVEFDQiI7DQorCQl1cy0+
cHJvdG9faGFuZGxlciA9IGN5cHJlc3NfYXRhY2JfcGFzc3Rocm91Z2g7DQorCX0gZWxzZSB7DQor
CQl1cy0+cHJvdG9jb2xfbmFtZSA9ICJUcmFuc3BhcmVudCBTQ1NJIjsNCisJCXVzLT5wcm90b19o
YW5kbGVyID0gdXNiX3N0b3JfdHJhbnNwYXJlbnRfc2NzaV9jb21tYW5kOw0KKwl9DQogDQogCXJl
c3VsdCA9IHVzYl9zdG9yX3Byb2JlMih1cyk7DQogCXJldHVybiByZXN1bHQ7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy92aWRlby9jb25zb2xlL2ZiY29uLmMgYi9kcml2ZXJzL3ZpZGVvL2NvbnNvbGUv
ZmJjb24uYw0KaW5kZXggN2EzNmRmZi4uNmI0ZmI1YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlk
ZW8vY29uc29sZS9mYmNvbi5jDQorKysgYi9kcml2ZXJzL3ZpZGVvL2NvbnNvbGUvZmJjb24uYw0K
QEAgLTEyMjksNiArMTIyOSw4IEBAIHN0YXRpYyB2b2lkIGZiY29uX2RlaW5pdChzdHJ1Y3QgdmNf
ZGF0YSAqdmMpDQogZmluaXNoZWQ6DQogDQogCWZiY29uX2ZyZWVfZm9udChwLCBmcmVlX2ZvbnQp
Ow0KKwlpZiAoZnJlZV9mb250KQ0KKwkJdmMtPnZjX2ZvbnQuZGF0YSA9IE5VTEw7DQogDQogCWlm
ICghY29uX2lzX2JvdW5kKCZmYl9jb24pKQ0KIAkJZmJjb25fZXhpdCgpOw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdmlkZW8vZmJtZW0uYyBiL2RyaXZlcnMvdmlkZW8vZmJtZW0uYw0KaW5kZXggYmFi
YmIwNy4uMGEyMjgwOCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlkZW8vZmJtZW0uYw0KKysrIGIv
ZHJpdmVycy92aWRlby9mYm1lbS5jDQpAQCAtMTM1MCwxNSArMTM1MCwxMiBAQCBmYl9tbWFwKHN0
cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKiB2bWEpDQogew0KIAlzdHJ1
Y3QgZmJfaW5mbyAqaW5mbyA9IGZpbGVfZmJfaW5mbyhmaWxlKTsNCiAJc3RydWN0IGZiX29wcyAq
ZmI7DQotCXVuc2lnbmVkIGxvbmcgb2ZmOw0KKwl1bnNpZ25lZCBsb25nIG1taW9fcGdvZmY7DQog
CXVuc2lnbmVkIGxvbmcgc3RhcnQ7DQogCXUzMiBsZW47DQogDQogCWlmICghaW5mbykNCiAJCXJl
dHVybiAtRU5PREVWOw0KLQlpZiAodm1hLT52bV9wZ29mZiA+ICh+MFVMID4+IFBBR0VfU0hJRlQp
KQ0KLQkJcmV0dXJuIC1FSU5WQUw7DQotCW9mZiA9IHZtYS0+dm1fcGdvZmYgPDwgUEFHRV9TSElG
VDsNCiAJZmIgPSBpbmZvLT5mYm9wczsNCiAJaWYgKCFmYikNCiAJCXJldHVybiAtRU5PREVWOw0K
QEAgLTEzNzAsMzMgKzEzNjcsMjQgQEAgZmJfbW1hcChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0
IHZtX2FyZWFfc3RydWN0ICogdm1hKQ0KIAkJcmV0dXJuIHJlczsNCiAJfQ0KIA0KLQkvKiBmcmFt
ZSBidWZmZXIgbWVtb3J5ICovDQorCS8qDQorCSAqIFVnaC4gVGhpcyBjYW4gYmUgZWl0aGVyIHRo
ZSBmcmFtZSBidWZmZXIgbWFwcGluZywgb3INCisJICogaWYgcGdvZmYgcG9pbnRzIHBhc3QgaXQs
IHRoZSBtbWlvIG1hcHBpbmcuDQorCSAqLw0KIAlzdGFydCA9IGluZm8tPmZpeC5zbWVtX3N0YXJ0
Ow0KLQlsZW4gPSBQQUdFX0FMSUdOKChzdGFydCAmIH5QQUdFX01BU0spICsgaW5mby0+Zml4LnNt
ZW1fbGVuKTsNCi0JaWYgKG9mZiA+PSBsZW4pIHsNCi0JCS8qIG1lbW9yeSBtYXBwZWQgaW8gKi8N
Ci0JCW9mZiAtPSBsZW47DQotCQlpZiAoaW5mby0+dmFyLmFjY2VsX2ZsYWdzKSB7DQotCQkJbXV0
ZXhfdW5sb2NrKCZpbmZvLT5tbV9sb2NrKTsNCi0JCQlyZXR1cm4gLUVJTlZBTDsNCi0JCX0NCisJ
bGVuID0gaW5mby0+Zml4LnNtZW1fbGVuOw0KKwltbWlvX3Bnb2ZmID0gUEFHRV9BTElHTigoc3Rh
cnQgJiB+UEFHRV9NQVNLKSArIGxlbikgPj4gUEFHRV9TSElGVDsNCisJaWYgKHZtYS0+dm1fcGdv
ZmYgPj0gbW1pb19wZ29mZikgew0KKwkJdm1hLT52bV9wZ29mZiAtPSBtbWlvX3Bnb2ZmOw0KIAkJ
c3RhcnQgPSBpbmZvLT5maXgubW1pb19zdGFydDsNCi0JCWxlbiA9IFBBR0VfQUxJR04oKHN0YXJ0
ICYgflBBR0VfTUFTSykgKyBpbmZvLT5maXgubW1pb19sZW4pOw0KKwkJbGVuID0gaW5mby0+Zml4
Lm1taW9fbGVuOw0KIAl9DQogCW11dGV4X3VubG9jaygmaW5mby0+bW1fbG9jayk7DQotCXN0YXJ0
ICY9IFBBR0VfTUFTSzsNCi0JaWYgKCh2bWEtPnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQgKyBvZmYp
ID4gbGVuKQ0KLQkJcmV0dXJuIC1FSU5WQUw7DQotCW9mZiArPSBzdGFydDsNCi0Jdm1hLT52bV9w
Z29mZiA9IG9mZiA+PiBQQUdFX1NISUZUOw0KLQkvKiBUaGlzIGlzIGFuIElPIG1hcCAtIHRlbGwg
bWF5ZHVtcCB0byBza2lwIHRoaXMgVk1BICovDQotCXZtYS0+dm1fZmxhZ3MgfD0gVk1fSU8gfCBW
TV9SRVNFUlZFRDsNCisNCiAJdm1hLT52bV9wYWdlX3Byb3QgPSB2bV9nZXRfcGFnZV9wcm90KHZt
YS0+dm1fZmxhZ3MpOw0KLQlmYl9wZ3Byb3RlY3QoZmlsZSwgdm1hLCBvZmYpOw0KLQlpZiAoaW9f
cmVtYXBfcGZuX3JhbmdlKHZtYSwgdm1hLT52bV9zdGFydCwgb2ZmID4+IFBBR0VfU0hJRlQsDQot
CQkJICAgICB2bWEtPnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQsIHZtYS0+dm1fcGFnZV9wcm90KSkN
Ci0JCXJldHVybiAtRUFHQUlOOw0KLQlyZXR1cm4gMDsNCisJZmJfcGdwcm90ZWN0KGZpbGUsIHZt
YSwgc3RhcnQpOw0KKw0KKwlyZXR1cm4gdm1faW9tYXBfbWVtb3J5KHZtYSwgc3RhcnQsIGxlbik7
DQogfQ0KIA0KIHN0YXRpYyBpbnQNCmRpZmYgLS1naXQgYS9mcy9haW8uYyBiL2ZzL2Fpby5jDQpp
bmRleCAzYjY1ZWU3Li44Y2RkOGVhIDEwMDY0NA0KLS0tIGEvZnMvYWlvLmMNCisrKyBiL2ZzL2Fp
by5jDQpAQCAtMTExMiw5ICsxMTEyLDkgQEAgc3RhdGljIGludCBhaW9fcmVhZF9ldnQoc3RydWN0
IGtpb2N0eCAqaW9jdHgsIHN0cnVjdCBpb19ldmVudCAqZW50KQ0KIAlzcGluX3VubG9jaygmaW5m
by0+cmluZ19sb2NrKTsNCiANCiBvdXQ6DQotCWt1bm1hcF9hdG9taWMocmluZywgS01fVVNFUjAp
Ow0KIAlkcHJpbnRrKCJsZWF2aW5nIGFpb19yZWFkX2V2dDogJWQgIGglbHUgdCVsdVxuIiwgcmV0
LA0KIAkJICh1bnNpZ25lZCBsb25nKXJpbmctPmhlYWQsICh1bnNpZ25lZCBsb25nKXJpbmctPnRh
aWwpOw0KKwlrdW5tYXBfYXRvbWljKHJpbmcsIEtNX1VTRVIwKTsNCiAJcmV0dXJuIHJldDsNCiB9
DQogDQpkaWZmIC0tZ2l0IGEvZnMvZGNhY2hlLmMgYi9mcy9kY2FjaGUuYw0KaW5kZXggZTkyM2Jm
NC4uZDMyMjkyOSAxMDA2NDQNCi0tLSBhL2ZzL2RjYWNoZS5jDQorKysgYi9mcy9kY2FjaGUuYw0K
QEAgLTExNzYsOCArMTE3NiwxMCBAQCB2b2lkIHNocmlua19kY2FjaGVfcGFyZW50KHN0cnVjdCBk
ZW50cnkgKiBwYXJlbnQpDQogCUxJU1RfSEVBRChkaXNwb3NlKTsNCiAJaW50IGZvdW5kOw0KIA0K
LQl3aGlsZSAoKGZvdW5kID0gc2VsZWN0X3BhcmVudChwYXJlbnQsICZkaXNwb3NlKSkgIT0gMCkN
CisJd2hpbGUgKChmb3VuZCA9IHNlbGVjdF9wYXJlbnQocGFyZW50LCAmZGlzcG9zZSkpICE9IDAp
IHsNCiAJCXNocmlua19kZW50cnlfbGlzdCgmZGlzcG9zZSk7DQorCQljb25kX3Jlc2NoZWQoKTsN
CisJfQ0KIH0NCiBFWFBPUlRfU1lNQk9MKHNocmlua19kY2FjaGVfcGFyZW50KTsNCiANCmRpZmYg
LS1naXQgYS9mcy9leHQ0L0tjb25maWcgYi9mcy9leHQ0L0tjb25maWcNCmluZGV4IDllZDFiYjEu
LjU0NTkxNjggMTAwNjQ0DQotLS0gYS9mcy9leHQ0L0tjb25maWcNCisrKyBiL2ZzL2V4dDQvS2Nv
bmZpZw0KQEAgLTgyLDQgKzgyLDUgQEAgY29uZmlnIEVYVDRfREVCVUcNCiAJICBFbmFibGVzIHJ1
bi10aW1lIGRlYnVnZ2luZyBzdXBwb3J0IGZvciB0aGUgZXh0NCBmaWxlc3lzdGVtLg0KIA0KIAkg
IElmIHlvdSBzZWxlY3QgWSBoZXJlLCB0aGVuIHlvdSB3aWxsIGJlIGFibGUgdG8gdHVybiBvbiBk
ZWJ1Z2dpbmcNCi0JICB3aXRoIGEgY29tbWFuZCBzdWNoIGFzICJlY2hvIDEgPiAvc3lzL2tlcm5l
bC9kZWJ1Zy9leHQ0L21iYWxsb2MtZGVidWciDQorCSAgd2l0aCBhIGNvbW1hbmQgc3VjaCBhczoN
CisJCWVjaG8gMSA+IC9zeXMvbW9kdWxlL2V4dDQvcGFyYW1ldGVycy9tYmFsbG9jX2RlYnVnDQpk
aWZmIC0tZ2l0IGEvZnMvZXh0NC9mc3luYy5jIGIvZnMvZXh0NC9mc3luYy5jDQppbmRleCBiYjZj
N2Q4Li5hOGQwM2E0IDEwMDY0NA0KLS0tIGEvZnMvZXh0NC9mc3luYy5jDQorKysgYi9mcy9leHQ0
L2ZzeW5jLmMNCkBAIC0yNjAsOCArMjYwLDcgQEAgaW50IGV4dDRfc3luY19maWxlKHN0cnVjdCBm
aWxlICpmaWxlLCBsb2ZmX3Qgc3RhcnQsIGxvZmZfdCBlbmQsIGludCBkYXRhc3luYykNCiAJaWYg
KGpvdXJuYWwtPmpfZmxhZ3MgJiBKQkQyX0JBUlJJRVIgJiYNCiAJICAgICFqYmQyX3RyYW5zX3dp
bGxfc2VuZF9kYXRhX2JhcnJpZXIoam91cm5hbCwgY29tbWl0X3RpZCkpDQogCQluZWVkc19iYXJy
aWVyID0gdHJ1ZTsNCi0JamJkMl9sb2dfc3RhcnRfY29tbWl0KGpvdXJuYWwsIGNvbW1pdF90aWQp
Ow0KLQlyZXQgPSBqYmQyX2xvZ193YWl0X2NvbW1pdChqb3VybmFsLCBjb21taXRfdGlkKTsNCisJ
cmV0ID0gamJkMl9jb21wbGV0ZV90cmFuc2FjdGlvbihqb3VybmFsLCBjb21taXRfdGlkKTsNCiAJ
aWYgKG5lZWRzX2JhcnJpZXIpDQogCQlibGtkZXZfaXNzdWVfZmx1c2goaW5vZGUtPmlfc2ItPnNf
YmRldiwgR0ZQX0tFUk5FTCwgTlVMTCk7DQogIG91dDoNCmRpZmYgLS1naXQgYS9mcy9leHQ0L2lu
b2RlLmMgYi9mcy9leHQ0L2lub2RlLmMNCmluZGV4IDMyNzBmZmQuLjAyNWI0YjYgMTAwNjQ0DQot
LS0gYS9mcy9leHQ0L2lub2RlLmMNCisrKyBiL2ZzL2V4dDQvaW5vZGUuYw0KQEAgLTE0Nyw4ICsx
NDcsNyBAQCB2b2lkIGV4dDRfZXZpY3RfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkNCiAJCQlq
b3VybmFsX3QgKmpvdXJuYWwgPSBFWFQ0X1NCKGlub2RlLT5pX3NiKS0+c19qb3VybmFsOw0KIAkJ
CXRpZF90IGNvbW1pdF90aWQgPSBFWFQ0X0koaW5vZGUpLT5pX2RhdGFzeW5jX3RpZDsNCiANCi0J
CQlqYmQyX2xvZ19zdGFydF9jb21taXQoam91cm5hbCwgY29tbWl0X3RpZCk7DQotCQkJamJkMl9s
b2dfd2FpdF9jb21taXQoam91cm5hbCwgY29tbWl0X3RpZCk7DQorCQkJamJkMl9jb21wbGV0ZV90
cmFuc2FjdGlvbihqb3VybmFsLCBjb21taXRfdGlkKTsNCiAJCQlmaWxlbWFwX3dyaXRlX2FuZF93
YWl0KCZpbm9kZS0+aV9kYXRhKTsNCiAJCX0NCiAJCXRydW5jYXRlX2lub2RlX3BhZ2VzKCZpbm9k
ZS0+aV9kYXRhLCAwKTsNCmRpZmYgLS1naXQgYS9mcy9mc2NhY2hlL3N0YXRzLmMgYi9mcy9mc2Nh
Y2hlL3N0YXRzLmMNCmluZGV4IDQ3NjUxOTAuLjczYzBiZDcgMTAwNjQ0DQotLS0gYS9mcy9mc2Nh
Y2hlL3N0YXRzLmMNCisrKyBiL2ZzL2ZzY2FjaGUvc3RhdHMuYw0KQEAgLTI3Niw1ICsyNzYsNSBA
QCBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGZzY2FjaGVfc3RhdHNfZm9wcyA9IHsNCiAJ
Lm9wZW4JCT0gZnNjYWNoZV9zdGF0c19vcGVuLA0KIAkucmVhZAkJPSBzZXFfcmVhZCwNCiAJLmxs
c2VlawkJPSBzZXFfbHNlZWssDQotCS5yZWxlYXNlCT0gc2VxX3JlbGVhc2UsDQorCS5yZWxlYXNl
ICAgICAgICA9IHNpbmdsZV9yZWxlYXNlLA0KIH07DQpkaWZmIC0tZ2l0IGEvZnMvamJkMi9jb21t
aXQuYyBiL2ZzL2piZDIvY29tbWl0LmMNCmluZGV4IGQ3NTFmMDQuLmFiOTQ2M2EgMTAwNjQ0DQot
LS0gYS9mcy9qYmQyL2NvbW1pdC5jDQorKysgYi9mcy9qYmQyL2NvbW1pdC5jDQpAQCAtMzI2LDcg
KzMyNiw3IEBAIHZvaWQgamJkMl9qb3VybmFsX2NvbW1pdF90cmFuc2FjdGlvbihqb3VybmFsX3Qg
KmpvdXJuYWwpDQogCWludCBzcGFjZV9sZWZ0ID0gMDsNCiAJaW50IGZpcnN0X3RhZyA9IDA7DQog
CWludCB0YWdfZmxhZzsNCi0JaW50IGksIHRvX2ZyZWUgPSAwOw0KKwlpbnQgaTsNCiAJaW50IHRh
Z19ieXRlcyA9IGpvdXJuYWxfdGFnX2J5dGVzKGpvdXJuYWwpOw0KIAlzdHJ1Y3QgYnVmZmVyX2hl
YWQgKmNiaCA9IE5VTEw7IC8qIEZvciB0cmFuc2FjdGlvbmFsIGNoZWNrc3VtcyAqLw0KIAlfX3Uz
MiBjcmMzMl9zdW0gPSB+MDsNCkBAIC05OTYsNyArOTk2LDcgQEAgcmVzdGFydF9sb29wOg0KIAlq
b3VybmFsLT5qX3N0YXRzLnJ1bi5yc19ibG9ja3NfbG9nZ2VkICs9IHN0YXRzLnJ1bi5yc19ibG9j
a3NfbG9nZ2VkOw0KIAlzcGluX3VubG9jaygmam91cm5hbC0+al9oaXN0b3J5X2xvY2spOw0KIA0K
LQljb21taXRfdHJhbnNhY3Rpb24tPnRfc3RhdGUgPSBUX0ZJTklTSEVEOw0KKwljb21taXRfdHJh
bnNhY3Rpb24tPnRfc3RhdGUgPSBUX0NPTU1JVF9DQUxMQkFDSzsNCiAJSl9BU1NFUlQoY29tbWl0
X3RyYW5zYWN0aW9uID09IGpvdXJuYWwtPmpfY29tbWl0dGluZ190cmFuc2FjdGlvbik7DQogCWpv
dXJuYWwtPmpfY29tbWl0X3NlcXVlbmNlID0gY29tbWl0X3RyYW5zYWN0aW9uLT50X3RpZDsNCiAJ
am91cm5hbC0+al9jb21taXR0aW5nX3RyYW5zYWN0aW9uID0gTlVMTDsNCkBAIC0xMDExLDM4ICsx
MDExLDQ0IEBAIHJlc3RhcnRfbG9vcDoNCiAJCQkJam91cm5hbC0+al9hdmVyYWdlX2NvbW1pdF90
aW1lKjMpIC8gNDsNCiAJZWxzZQ0KIAkJam91cm5hbC0+al9hdmVyYWdlX2NvbW1pdF90aW1lID0g
Y29tbWl0X3RpbWU7DQorDQogCXdyaXRlX3VubG9jaygmam91cm5hbC0+al9zdGF0ZV9sb2NrKTsN
CiANCi0JaWYgKGNvbW1pdF90cmFuc2FjdGlvbi0+dF9jaGVja3BvaW50X2xpc3QgPT0gTlVMTCAm
Jg0KLQkgICAgY29tbWl0X3RyYW5zYWN0aW9uLT50X2NoZWNrcG9pbnRfaW9fbGlzdCA9PSBOVUxM
KSB7DQotCQlfX2piZDJfam91cm5hbF9kcm9wX3RyYW5zYWN0aW9uKGpvdXJuYWwsIGNvbW1pdF90
cmFuc2FjdGlvbik7DQotCQl0b19mcmVlID0gMTsNCisJaWYgKGpvdXJuYWwtPmpfY2hlY2twb2lu
dF90cmFuc2FjdGlvbnMgPT0gTlVMTCkgew0KKwkJam91cm5hbC0+al9jaGVja3BvaW50X3RyYW5z
YWN0aW9ucyA9IGNvbW1pdF90cmFuc2FjdGlvbjsNCisJCWNvbW1pdF90cmFuc2FjdGlvbi0+dF9j
cG5leHQgPSBjb21taXRfdHJhbnNhY3Rpb247DQorCQljb21taXRfdHJhbnNhY3Rpb24tPnRfY3Bw
cmV2ID0gY29tbWl0X3RyYW5zYWN0aW9uOw0KIAl9IGVsc2Ugew0KLQkJaWYgKGpvdXJuYWwtPmpf
Y2hlY2twb2ludF90cmFuc2FjdGlvbnMgPT0gTlVMTCkgew0KLQkJCWpvdXJuYWwtPmpfY2hlY2tw
b2ludF90cmFuc2FjdGlvbnMgPSBjb21taXRfdHJhbnNhY3Rpb247DQotCQkJY29tbWl0X3RyYW5z
YWN0aW9uLT50X2NwbmV4dCA9IGNvbW1pdF90cmFuc2FjdGlvbjsNCi0JCQljb21taXRfdHJhbnNh
Y3Rpb24tPnRfY3BwcmV2ID0gY29tbWl0X3RyYW5zYWN0aW9uOw0KLQkJfSBlbHNlIHsNCi0JCQlj
b21taXRfdHJhbnNhY3Rpb24tPnRfY3BuZXh0ID0NCi0JCQkJam91cm5hbC0+al9jaGVja3BvaW50
X3RyYW5zYWN0aW9uczsNCi0JCQljb21taXRfdHJhbnNhY3Rpb24tPnRfY3BwcmV2ID0NCi0JCQkJ
Y29tbWl0X3RyYW5zYWN0aW9uLT50X2NwbmV4dC0+dF9jcHByZXY7DQotCQkJY29tbWl0X3RyYW5z
YWN0aW9uLT50X2NwbmV4dC0+dF9jcHByZXYgPQ0KLQkJCQljb21taXRfdHJhbnNhY3Rpb247DQot
CQkJY29tbWl0X3RyYW5zYWN0aW9uLT50X2NwcHJldi0+dF9jcG5leHQgPQ0KKwkJY29tbWl0X3Ry
YW5zYWN0aW9uLT50X2NwbmV4dCA9DQorCQkJam91cm5hbC0+al9jaGVja3BvaW50X3RyYW5zYWN0
aW9uczsNCisJCWNvbW1pdF90cmFuc2FjdGlvbi0+dF9jcHByZXYgPQ0KKwkJCWNvbW1pdF90cmFu
c2FjdGlvbi0+dF9jcG5leHQtPnRfY3BwcmV2Ow0KKwkJY29tbWl0X3RyYW5zYWN0aW9uLT50X2Nw
bmV4dC0+dF9jcHByZXYgPQ0KKwkJCWNvbW1pdF90cmFuc2FjdGlvbjsNCisJCWNvbW1pdF90cmFu
c2FjdGlvbi0+dF9jcHByZXYtPnRfY3BuZXh0ID0NCiAJCQkJY29tbWl0X3RyYW5zYWN0aW9uOw0K
LQkJfQ0KIAl9DQogCXNwaW5fdW5sb2NrKCZqb3VybmFsLT5qX2xpc3RfbG9jayk7DQotDQorCS8q
IERyb3AgYWxsIHNwaW5fbG9ja3MgYmVjYXVzZSBjb21taXRfY2FsbGJhY2sgbWF5IGJlIGJsb2Nr
Lg0KKwkgKiBfX2pvdXJuYWxfcmVtb3ZlX2NoZWNrcG9pbnQoKSBjYW4gbm90IGRlc3Ryb3kgdHJh
bnNhY3Rpb24NCisJICogdW5kZXIgdXMgYmVjYXVzZSBpdCBpcyBub3QgbWFya2VkIGFzIFRfRklO
SVNIRUQgeWV0ICovDQogCWlmIChqb3VybmFsLT5qX2NvbW1pdF9jYWxsYmFjaykNCiAJCWpvdXJu
YWwtPmpfY29tbWl0X2NhbGxiYWNrKGpvdXJuYWwsIGNvbW1pdF90cmFuc2FjdGlvbik7DQogDQog
CXRyYWNlX2piZDJfZW5kX2NvbW1pdChqb3VybmFsLCBjb21taXRfdHJhbnNhY3Rpb24pOw0KIAlq
YmRfZGVidWcoMSwgIkpCRDI6IGNvbW1pdCAlZCBjb21wbGV0ZSwgaGVhZCAlZFxuIiwNCiAJCSAg
am91cm5hbC0+al9jb21taXRfc2VxdWVuY2UsIGpvdXJuYWwtPmpfdGFpbF9zZXF1ZW5jZSk7DQot
CWlmICh0b19mcmVlKQ0KLQkJa2ZyZWUoY29tbWl0X3RyYW5zYWN0aW9uKTsNCiANCisJd3JpdGVf
bG9jaygmam91cm5hbC0+al9zdGF0ZV9sb2NrKTsNCisJc3Bpbl9sb2NrKCZqb3VybmFsLT5qX2xp
c3RfbG9jayk7DQorCWNvbW1pdF90cmFuc2FjdGlvbi0+dF9zdGF0ZSA9IFRfRklOSVNIRUQ7DQor
CS8qIFJlY2hlY2sgY2hlY2twb2ludCBsaXN0cyBhZnRlciBqX2xpc3RfbG9jayB3YXMgZHJvcHBl
ZCAqLw0KKwlpZiAoY29tbWl0X3RyYW5zYWN0aW9uLT50X2NoZWNrcG9pbnRfbGlzdCA9PSBOVUxM
ICYmDQorCSAgICBjb21taXRfdHJhbnNhY3Rpb24tPnRfY2hlY2twb2ludF9pb19saXN0ID09IE5V
TEwpIHsNCisJCV9famJkMl9qb3VybmFsX2Ryb3BfdHJhbnNhY3Rpb24oam91cm5hbCwgY29tbWl0
X3RyYW5zYWN0aW9uKTsNCisJCWtmcmVlKGNvbW1pdF90cmFuc2FjdGlvbik7DQorCX0NCisJc3Bp
bl91bmxvY2soJmpvdXJuYWwtPmpfbGlzdF9sb2NrKTsNCisJd3JpdGVfdW5sb2NrKCZqb3VybmFs
LT5qX3N0YXRlX2xvY2spOw0KIAl3YWtlX3VwKCZqb3VybmFsLT5qX3dhaXRfZG9uZV9jb21taXQp
Ow0KIH0NCmRpZmYgLS1naXQgYS9mcy9qYmQyL2pvdXJuYWwuYyBiL2ZzL2piZDIvam91cm5hbC5j
DQppbmRleCAwZmEwMTIzLi4xN2IwNGZjIDEwMDY0NA0KLS0tIGEvZnMvamJkMi9qb3VybmFsLmMN
CisrKyBiL2ZzL2piZDIvam91cm5hbC5jDQpAQCAtNjYzLDYgKzY2MywzNyBAQCBpbnQgamJkMl9s
b2dfd2FpdF9jb21taXQoam91cm5hbF90ICpqb3VybmFsLCB0aWRfdCB0aWQpDQogfQ0KIA0KIC8q
DQorICogV2hlbiB0aGlzIGZ1bmN0aW9uIHJldHVybnMgdGhlIHRyYW5zYWN0aW9uIGNvcnJlc3Bv
bmRpbmcgdG8gdGlkDQorICogd2lsbCBiZSBjb21wbGV0ZWQuICBJZiB0aGUgdHJhbnNhY3Rpb24g
aGFzIGN1cnJlbnRseSBydW5uaW5nLCBzdGFydA0KKyAqIGNvbW1pdHRpbmcgdGhhdCB0cmFuc2Fj
dGlvbiBiZWZvcmUgd2FpdGluZyBmb3IgaXQgdG8gY29tcGxldGUuICBJZg0KKyAqIHRoZSB0cmFu
c2FjdGlvbiBpZCBpcyBzdGFsZSwgaXQgaXMgYnkgZGVmaW5pdGlvbiBhbHJlYWR5IGNvbXBsZXRl
ZCwNCisgKiBzbyBqdXN0IHJldHVybiBTVUNDRVNTLg0KKyAqLw0KK2ludCBqYmQyX2NvbXBsZXRl
X3RyYW5zYWN0aW9uKGpvdXJuYWxfdCAqam91cm5hbCwgdGlkX3QgdGlkKQ0KK3sNCisJaW50CW5l
ZWRfdG9fd2FpdCA9IDE7DQorDQorCXJlYWRfbG9jaygmam91cm5hbC0+al9zdGF0ZV9sb2NrKTsN
CisJaWYgKGpvdXJuYWwtPmpfcnVubmluZ190cmFuc2FjdGlvbiAmJg0KKwkgICAgam91cm5hbC0+
al9ydW5uaW5nX3RyYW5zYWN0aW9uLT50X3RpZCA9PSB0aWQpIHsNCisJCWlmIChqb3VybmFsLT5q
X2NvbW1pdF9yZXF1ZXN0ICE9IHRpZCkgew0KKwkJCS8qIHRyYW5zYWN0aW9uIG5vdCB5ZXQgc3Rh
cnRlZCwgc28gcmVxdWVzdCBpdCAqLw0KKwkJCXJlYWRfdW5sb2NrKCZqb3VybmFsLT5qX3N0YXRl
X2xvY2spOw0KKwkJCWpiZDJfbG9nX3N0YXJ0X2NvbW1pdChqb3VybmFsLCB0aWQpOw0KKwkJCWdv
dG8gd2FpdF9jb21taXQ7DQorCQl9DQorCX0gZWxzZSBpZiAoIShqb3VybmFsLT5qX2NvbW1pdHRp
bmdfdHJhbnNhY3Rpb24gJiYNCisJCSAgICAgam91cm5hbC0+al9jb21taXR0aW5nX3RyYW5zYWN0
aW9uLT50X3RpZCA9PSB0aWQpKQ0KKwkJbmVlZF90b193YWl0ID0gMDsNCisJcmVhZF91bmxvY2so
JmpvdXJuYWwtPmpfc3RhdGVfbG9jayk7DQorCWlmICghbmVlZF90b193YWl0KQ0KKwkJcmV0dXJu
IDA7DQord2FpdF9jb21taXQ6DQorCXJldHVybiBqYmQyX2xvZ193YWl0X2NvbW1pdChqb3VybmFs
LCB0aWQpOw0KK30NCitFWFBPUlRfU1lNQk9MKGpiZDJfY29tcGxldGVfdHJhbnNhY3Rpb24pOw0K
Kw0KKy8qDQogICogTG9nIGJ1ZmZlciBhbGxvY2F0aW9uIHJvdXRpbmVzOg0KICAqLw0KIA0KZGlm
ZiAtLWdpdCBhL2ZzL2xvY2tkL2NsbnRsb2NrLmMgYi9mcy9sb2NrZC9jbG50bG9jay5jDQppbmRl
eCA4ZDRlYTgzLi5kZTg4OTIyIDEwMDY0NA0KLS0tIGEvZnMvbG9ja2QvY2xudGxvY2suYw0KKysr
IGIvZnMvbG9ja2QvY2xudGxvY2suYw0KQEAgLTE0MSw2ICsxNDEsOSBAQCBpbnQgbmxtY2xudF9i
bG9jayhzdHJ1Y3QgbmxtX3dhaXQgKmJsb2NrLCBzdHJ1Y3QgbmxtX3Jxc3QgKnJlcSwgbG9uZyB0
aW1lb3V0KQ0KIAkJCXRpbWVvdXQpOw0KIAlpZiAocmV0IDwgMCkNCiAJCXJldHVybiAtRVJFU1RB
UlRTWVM7DQorCS8qIFJlc2V0IHRoZSBsb2NrIHN0YXR1cyBhZnRlciBhIHNlcnZlciByZWJvb3Qg
c28gd2UgcmVzZW5kICovDQorCWlmIChibG9jay0+Yl9zdGF0dXMgPT0gbmxtX2xja19kZW5pZWRf
Z3JhY2VfcGVyaW9kKQ0KKwkJYmxvY2stPmJfc3RhdHVzID0gbmxtX2xja19ibG9ja2VkOw0KIAly
ZXEtPmFfcmVzLnN0YXR1cyA9IGJsb2NrLT5iX3N0YXR1czsNCiAJcmV0dXJuIDA7DQogfQ0KZGlm
ZiAtLWdpdCBhL2ZzL2xvY2tkL2NsbnRwcm9jLmMgYi9mcy9sb2NrZC9jbG50cHJvYy5jDQppbmRl
eCBhM2EwOTg3Li44MzkyY2I4IDEwMDY0NA0KLS0tIGEvZnMvbG9ja2QvY2xudHByb2MuYw0KKysr
IGIvZnMvbG9ja2QvY2xudHByb2MuYw0KQEAgLTU1MSw5ICs1NTEsNiBAQCBhZ2FpbjoNCiAJCXN0
YXR1cyA9IG5sbWNsbnRfYmxvY2soYmxvY2ssIHJlcSwgTkxNQ0xOVF9QT0xMX1RJTUVPVVQpOw0K
IAkJaWYgKHN0YXR1cyA8IDApDQogCQkJYnJlYWs7DQotCQkvKiBSZXNlbmQgdGhlIGJsb2NraW5n
IGxvY2sgcmVxdWVzdCBhZnRlciBhIHNlcnZlciByZWJvb3QgKi8NCi0JCWlmIChyZXNwLT5zdGF0
dXMgPT0gIG5sbV9sY2tfZGVuaWVkX2dyYWNlX3BlcmlvZCkNCi0JCQljb250aW51ZTsNCiAJCWlm
IChyZXNwLT5zdGF0dXMgIT0gbmxtX2xja19ibG9ja2VkKQ0KIAkJCWJyZWFrOw0KIAl9DQpkaWZm
IC0tZ2l0IGEvZnMvbmZzZC9uZnM0cHJvYy5jIGIvZnMvbmZzZC9uZnM0cHJvYy5jDQppbmRleCBm
ZTVjNWZiNi4uMDg5MjFiOCAxMDA2NDQNCi0tLSBhL2ZzL25mc2QvbmZzNHByb2MuYw0KKysrIGIv
ZnMvbmZzZC9uZnM0cHJvYy5jDQpAQCAtODgwLDE0ICs4ODAsMTQgQEAgbmZzZDRfd3JpdGUoc3Ry
dWN0IHN2Y19ycXN0ICpycXN0cCwgc3RydWN0IG5mc2Q0X2NvbXBvdW5kX3N0YXRlICpjc3RhdGUs
DQogDQogCW5mczRfbG9ja19zdGF0ZSgpOw0KIAlzdGF0dXMgPSBuZnM0X3ByZXByb2Nlc3Nfc3Rh
dGVpZF9vcChjc3RhdGUsIHN0YXRlaWQsIFdSX1NUQVRFLCAmZmlscCk7DQotCWlmIChmaWxwKQ0K
LQkJZ2V0X2ZpbGUoZmlscCk7DQotCW5mczRfdW5sb2NrX3N0YXRlKCk7DQotDQogCWlmIChzdGF0
dXMpIHsNCisJCW5mczRfdW5sb2NrX3N0YXRlKCk7DQogCQlkcHJpbnRrKCJORlNEOiBuZnNkNF93
cml0ZTogY291bGRuJ3QgcHJvY2VzcyBzdGF0ZWlkIVxuIik7DQogCQlyZXR1cm4gc3RhdHVzOw0K
IAl9DQorCWlmIChmaWxwKQ0KKwkJZ2V0X2ZpbGUoZmlscCk7DQorCW5mczRfdW5sb2NrX3N0YXRl
KCk7DQogDQogCWNudCA9IHdyaXRlLT53cl9idWZsZW47DQogCXdyaXRlLT53cl9ob3dfd3JpdHRl
biA9IHdyaXRlLT53cl9zdGFibGVfaG93Ow0KZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZzNHN0YXRl
LmMgYi9mcy9uZnNkL25mczRzdGF0ZS5jDQppbmRleCA3ZDE4OWRjLi40Y2VmOTlmIDEwMDY0NA0K
LS0tIGEvZnMvbmZzZC9uZnM0c3RhdGUuYw0KKysrIGIvZnMvbmZzZC9uZnM0c3RhdGUuYw0KQEAg
LTE4OCwxMyArMTg4LDcgQEAgc3RhdGljIHZvaWQgX19uZnM0X2ZpbGVfcHV0X2FjY2VzcyhzdHJ1
Y3QgbmZzNF9maWxlICpmcCwgaW50IG9mbGFnKQ0KIHsNCiAJaWYgKGF0b21pY19kZWNfYW5kX3Rl
c3QoJmZwLT5maV9hY2Nlc3Nbb2ZsYWddKSkgew0KIAkJbmZzNF9maWxlX3B1dF9mZChmcCwgb2Zs
YWcpOw0KLQkJLyoNCi0JCSAqIEl0J3MgYWxzbyBzYWZlIHRvIGdldCByaWQgb2YgdGhlIFJEV1Ig
b3BlbiAqaWYqDQotCQkgKiB3ZSBubyBsb25nZXIgaGF2ZSBuZWVkIG9mIHRoZSBvdGhlciBraW5k
IG9mIGFjY2Vzcw0KLQkJICogb3IgaWYgd2UgYWxyZWFkeSBoYXZlIHRoZSBvdGhlciBraW5kIG9m
IG9wZW46DQotCQkgKi8NCi0JCWlmIChmcC0+ZmlfZmRzWzEtb2ZsYWddDQotCQkJfHwgYXRvbWlj
X3JlYWQoJmZwLT5maV9hY2Nlc3NbMSAtIG9mbGFnXSkgPT0gMCkNCisJCWlmIChhdG9taWNfcmVh
ZCgmZnAtPmZpX2FjY2Vzc1sxIC0gb2ZsYWddKSA9PSAwKQ0KIAkJCW5mczRfZmlsZV9wdXRfZmQo
ZnAsIE9fUkRXUik7DQogCX0NCiB9DQpkaWZmIC0tZ2l0IGEvZnMvbmZzZC9uZnM0eGRyLmMgYi9m
cy9uZnNkL25mczR4ZHIuYw0KaW5kZXggMjRhZmE5Ni4uYWRlNTMxNiAxMDA2NDQNCi0tLSBhL2Zz
L25mc2QvbmZzNHhkci5jDQorKysgYi9mcy9uZnNkL25mczR4ZHIuYw0KQEAgLTM2MCwxMCArMzYw
LDcgQEAgbmZzZDRfZGVjb2RlX2ZhdHRyKHN0cnVjdCBuZnNkNF9jb21wb3VuZGFyZ3MgKmFyZ3As
IHUzMiAqYm12YWwsDQogCQkJICAgYWxsIDMyIGJpdHMgb2YgJ25zZWNvbmRzJy4gKi8NCiAJCQlS
RUFEX0JVRigxMik7DQogCQkJbGVuICs9IDEyOw0KLQkJCVJFQUQzMihkdW1teTMyKTsNCi0JCQlp
ZiAoZHVtbXkzMikNCi0JCQkJcmV0dXJuIG5mc2Vycl9pbnZhbDsNCi0JCQlSRUFEMzIoaWF0dHIt
PmlhX2F0aW1lLnR2X3NlYyk7DQorCQkJUkVBRDY0KGlhdHRyLT5pYV9hdGltZS50dl9zZWMpOw0K
IAkJCVJFQUQzMihpYXR0ci0+aWFfYXRpbWUudHZfbnNlYyk7DQogCQkJaWYgKGlhdHRyLT5pYV9h
dGltZS50dl9uc2VjID49ICh1MzIpMTAwMDAwMDAwMCkNCiAJCQkJcmV0dXJuIG5mc2Vycl9pbnZh
bDsNCkBAIC0zODYsMTAgKzM4Myw3IEBAIG5mc2Q0X2RlY29kZV9mYXR0cihzdHJ1Y3QgbmZzZDRf
Y29tcG91bmRhcmdzICphcmdwLCB1MzIgKmJtdmFsLA0KIAkJCSAgIGFsbCAzMiBiaXRzIG9mICdu
c2Vjb25kcycuICovDQogCQkJUkVBRF9CVUYoMTIpOw0KIAkJCWxlbiArPSAxMjsNCi0JCQlSRUFE
MzIoZHVtbXkzMik7DQotCQkJaWYgKGR1bW15MzIpDQotCQkJCXJldHVybiBuZnNlcnJfaW52YWw7
DQotCQkJUkVBRDMyKGlhdHRyLT5pYV9tdGltZS50dl9zZWMpOw0KKwkJCVJFQUQ2NChpYXR0ci0+
aWFfbXRpbWUudHZfc2VjKTsNCiAJCQlSRUFEMzIoaWF0dHItPmlhX210aW1lLnR2X25zZWMpOw0K
IAkJCWlmIChpYXR0ci0+aWFfbXRpbWUudHZfbnNlYyA+PSAodTMyKTEwMDAwMDAwMDApDQogCQkJ
CXJldHVybiBuZnNlcnJfaW52YWw7DQpAQCAtMjM3NCw4ICsyMzY4LDcgQEAgb3V0X2FjbDoNCiAJ
aWYgKGJtdmFsMSAmIEZBVFRSNF9XT1JEMV9USU1FX0FDQ0VTUykgew0KIAkJaWYgKChidWZsZW4g
LT0gMTIpIDwgMCkNCiAJCQlnb3RvIG91dF9yZXNvdXJjZTsNCi0JCVdSSVRFMzIoMCk7DQotCQlX
UklURTMyKHN0YXQuYXRpbWUudHZfc2VjKTsNCisJCVdSSVRFNjQoKHM2NClzdGF0LmF0aW1lLnR2
X3NlYyk7DQogCQlXUklURTMyKHN0YXQuYXRpbWUudHZfbnNlYyk7DQogCX0NCiAJaWYgKGJtdmFs
MSAmIEZBVFRSNF9XT1JEMV9USU1FX0RFTFRBKSB7DQpAQCAtMjM4OCwxNSArMjM4MSwxMyBAQCBv
dXRfYWNsOg0KIAlpZiAoYm12YWwxICYgRkFUVFI0X1dPUkQxX1RJTUVfTUVUQURBVEEpIHsNCiAJ
CWlmICgoYnVmbGVuIC09IDEyKSA8IDApDQogCQkJZ290byBvdXRfcmVzb3VyY2U7DQotCQlXUklU
RTMyKDApOw0KLQkJV1JJVEUzMihzdGF0LmN0aW1lLnR2X3NlYyk7DQorCQlXUklURTY0KChzNjQp
c3RhdC5jdGltZS50dl9zZWMpOw0KIAkJV1JJVEUzMihzdGF0LmN0aW1lLnR2X25zZWMpOw0KIAl9
DQogCWlmIChibXZhbDEgJiBGQVRUUjRfV09SRDFfVElNRV9NT0RJRlkpIHsNCiAJCWlmICgoYnVm
bGVuIC09IDEyKSA8IDApDQogCQkJZ290byBvdXRfcmVzb3VyY2U7DQotCQlXUklURTMyKDApOw0K
LQkJV1JJVEUzMihzdGF0Lm10aW1lLnR2X3NlYyk7DQorCQlXUklURTY0KChzNjQpc3RhdC5tdGlt
ZS50dl9zZWMpOw0KIAkJV1JJVEUzMihzdGF0Lm10aW1lLnR2X25zZWMpOw0KIAl9DQogCWlmIChi
bXZhbDEgJiBGQVRUUjRfV09SRDFfTU9VTlRFRF9PTl9GSUxFSUQpIHsNCmRpZmYgLS1naXQgYS9m
cy9ub3RpZnkvaW5vdGlmeS9pbm90aWZ5X3VzZXIuYyBiL2ZzL25vdGlmeS9pbm90aWZ5L2lub3Rp
ZnlfdXNlci5jDQppbmRleCA2ZjI5MmRkLi5mMjU1ZDM3IDEwMDY0NA0KLS0tIGEvZnMvbm90aWZ5
L2lub3RpZnkvaW5vdGlmeV91c2VyLmMNCisrKyBiL2ZzL25vdGlmeS9pbm90aWZ5L2lub3RpZnlf
dXNlci5jDQpAQCAtNTc3LDcgKzU3Nyw2IEBAIHN0YXRpYyBpbnQgaW5vdGlmeV91cGRhdGVfZXhp
c3Rpbmdfd2F0Y2goc3RydWN0IGZzbm90aWZ5X2dyb3VwICpncm91cCwNCiAJaW50IGFkZCA9IChh
cmcgJiBJTl9NQVNLX0FERCk7DQogCWludCByZXQ7DQogDQotCS8qIGRvbid0IGFsbG93IGludmFs
aWQgYml0czogd2UgZG9uJ3Qgd2FudCBmbGFncyBzZXQgKi8NCiAJbWFzayA9IGlub3RpZnlfYXJn
X3RvX21hc2soYXJnKTsNCiANCiAJZnNuX21hcmsgPSBmc25vdGlmeV9maW5kX2lub2RlX21hcmso
Z3JvdXAsIGlub2RlKTsNCkBAIC02MjgsNyArNjI3LDYgQEAgc3RhdGljIGludCBpbm90aWZ5X25l
d193YXRjaChzdHJ1Y3QgZnNub3RpZnlfZ3JvdXAgKmdyb3VwLA0KIAlzdHJ1Y3QgaWRyICppZHIg
PSAmZ3JvdXAtPmlub3RpZnlfZGF0YS5pZHI7DQogCXNwaW5sb2NrX3QgKmlkcl9sb2NrID0gJmdy
b3VwLT5pbm90aWZ5X2RhdGEuaWRyX2xvY2s7DQogDQotCS8qIGRvbid0IGFsbG93IGludmFsaWQg
Yml0czogd2UgZG9uJ3Qgd2FudCBmbGFncyBzZXQgKi8NCiAJbWFzayA9IGlub3RpZnlfYXJnX3Rv
X21hc2soYXJnKTsNCiANCiAJdG1wX2lfbWFyayA9IGttZW1fY2FjaGVfYWxsb2MoaW5vdGlmeV9p
bm9kZV9tYXJrX2NhY2hlcCwgR0ZQX0tFUk5FTCk7DQpAQCAtNzU3LDYgKzc1NSwxMCBAQCBTWVND
QUxMX0RFRklORTMoaW5vdGlmeV9hZGRfd2F0Y2gsIGludCwgZmQsIGNvbnN0IGNoYXIgX191c2Vy
ICosIHBhdGhuYW1lLA0KIAlpbnQgcmV0LCBmcHV0X25lZWRlZDsNCiAJdW5zaWduZWQgZmxhZ3Mg
PSAwOw0KIA0KKwkvKiBkb24ndCBhbGxvdyBpbnZhbGlkIGJpdHM6IHdlIGRvbid0IHdhbnQgZmxh
Z3Mgc2V0ICovDQorCWlmICh1bmxpa2VseSghKG1hc2sgJiBBTExfSU5PVElGWV9CSVRTKSkpDQor
CQlyZXR1cm4gLUVJTlZBTDsNCisNCiAJZmlscCA9IGZnZXRfbGlnaHQoZmQsICZmcHV0X25lZWRl
ZCk7DQogCWlmICh1bmxpa2VseSghZmlscCkpDQogCQlyZXR1cm4gLUVCQURGOw0KZGlmZiAtLWdp
dCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMNCmluZGV4IDM4OTllMjQuLmU3NTZi
YzQgMTAwNjQ0DQotLS0gYS9mcy9zeXNmcy9kaXIuYw0KKysrIGIvZnMvc3lzZnMvZGlyLmMNCkBA
IC05NzcsNiArOTc3LDcgQEAgc3RhdGljIGludCBzeXNmc19yZWFkZGlyKHN0cnVjdCBmaWxlICog
ZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRpcl90IGZpbGxkaXIpDQogCWVudW0ga29ial9uc190
eXBlIHR5cGU7DQogCWNvbnN0IHZvaWQgKm5zOw0KIAlpbm9fdCBpbm87DQorCWxvZmZfdCBvZmY7
DQogDQogCXR5cGUgPSBzeXNmc19uc190eXBlKHBhcmVudF9zZCk7DQogCW5zID0gc3lzZnNfaW5m
byhkZW50cnktPmRfc2IpLT5uc1t0eXBlXTsNCkBAIC05OTksNiArMTAwMCw3IEBAIHN0YXRpYyBp
bnQgc3lzZnNfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxk
aXJfdCBmaWxsZGlyKQ0KIAkJCXJldHVybiAwOw0KIAl9DQogCW11dGV4X2xvY2soJnN5c2ZzX211
dGV4KTsNCisJb2ZmID0gZmlscC0+Zl9wb3M7DQogCWZvciAocG9zID0gc3lzZnNfZGlyX3Bvcyhu
cywgcGFyZW50X3NkLCBmaWxwLT5mX3BvcywgcG9zKTsNCiAJICAgICBwb3M7DQogCSAgICAgcG9z
ID0gc3lzZnNfZGlyX25leHRfcG9zKG5zLCBwYXJlbnRfc2QsIGZpbHAtPmZfcG9zLCBwb3MpKSB7
DQpAQCAtMTAxMCwxOSArMTAxMiwyNCBAQCBzdGF0aWMgaW50IHN5c2ZzX3JlYWRkaXIoc3RydWN0
IGZpbGUgKiBmaWxwLCB2b2lkICogZGlyZW50LCBmaWxsZGlyX3QgZmlsbGRpcikNCiAJCWxlbiA9
IHN0cmxlbihuYW1lKTsNCiAJCWlubyA9IHBvcy0+c19pbm87DQogCQl0eXBlID0gZHRfdHlwZShw
b3MpOw0KLQkJZmlscC0+Zl9wb3MgPSBpbm87DQorCQlvZmYgPSBmaWxwLT5mX3BvcyA9IGlubzsN
CiAJCWZpbHAtPnByaXZhdGVfZGF0YSA9IHN5c2ZzX2dldChwb3MpOw0KIA0KIAkJbXV0ZXhfdW5s
b2NrKCZzeXNmc19tdXRleCk7DQotCQlyZXQgPSBmaWxsZGlyKGRpcmVudCwgbmFtZSwgbGVuLCBm
aWxwLT5mX3BvcywgaW5vLCB0eXBlKTsNCisJCXJldCA9IGZpbGxkaXIoZGlyZW50LCBuYW1lLCBs
ZW4sIG9mZiwgaW5vLCB0eXBlKTsNCiAJCW11dGV4X2xvY2soJnN5c2ZzX211dGV4KTsNCiAJCWlm
IChyZXQgPCAwKQ0KIAkJCWJyZWFrOw0KIAl9DQogCW11dGV4X3VubG9jaygmc3lzZnNfbXV0ZXgp
Ow0KLQlpZiAoKGZpbHAtPmZfcG9zID4gMSkgJiYgIXBvcykgeyAvKiBFT0YgKi8NCi0JCWZpbHAt
PmZfcG9zID0gSU5UX01BWDsNCisNCisJLyogZG9uJ3QgcmVmZXJlbmNlIGxhc3QgZW50cnkgaWYg
aXRzIHJlZmNvdW50IGlzIGRyb3BwZWQgKi8NCisJaWYgKCFwb3MpIHsNCiAJCWZpbHAtPnByaXZh
dGVfZGF0YSA9IE5VTEw7DQorDQorCQkvKiBFT0YgYW5kIG5vdCBjaGFuZ2VkIGFzIDAgb3IgMSBp
biByZWFkL3dyaXRlIHBhdGggKi8NCisJCWlmIChvZmYgPT0gZmlscC0+Zl9wb3MgJiYgb2ZmID4g
MSkNCisJCQlmaWxwLT5mX3BvcyA9IElOVF9NQVg7DQogCX0NCiAJcmV0dXJuIDA7DQogfQ0KZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIGIvaW5jbHVkZS9saW51eC9p
cGNfbmFtZXNwYWNlLmgNCmluZGV4IDhhMjk3YTUuLjQ5N2M2Y2MgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL2xpbnV4L2lwY19uYW1lc3BhY2UuaA0KKysrIGIvaW5jbHVkZS9saW51eC9pcGNfbmFtZXNw
YWNlLmgNCkBAIC00Miw4ICs0Miw4IEBAIHN0cnVjdCBpcGNfbmFtZXNwYWNlIHsNCiANCiAJc2l6
ZV90CQlzaG1fY3RsbWF4Ow0KIAlzaXplX3QJCXNobV9jdGxhbGw7DQorCXVuc2lnbmVkIGxvbmcJ
c2htX3RvdDsNCiAJaW50CQlzaG1fY3RsbW5pOw0KLQlpbnQJCXNobV90b3Q7DQogCS8qDQogCSAq
IERlZmluZXMgd2hldGhlciBJUENfUk1JRCBpcyBmb3JjZWQgZm9yIF9hbGxfIHNobSBzZWdtZW50
cyByZWdhcmRsZXNzDQogCSAqIG9mIHNobWN0bCgpDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9qYmQyLmggYi9pbmNsdWRlL2xpbnV4L2piZDIuaA0KaW5kZXggMjA5MmVhMi4uYTE1M2VkNSAx
MDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvamJkMi5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2pi
ZDIuaA0KQEAgLTQ3MCw2ICs0NzAsNyBAQCBzdHJ1Y3QgdHJhbnNhY3Rpb25fcw0KIAkJVF9DT01N
SVQsDQogCQlUX0NPTU1JVF9ERkxVU0gsDQogCQlUX0NPTU1JVF9KRkxVU0gsDQorCQlUX0NPTU1J
VF9DQUxMQkFDSywNCiAJCVRfRklOSVNIRUQNCiAJfQkJCXRfc3RhdGU7DQogDQpAQCAtMTE2NSw2
ICsxMTY2LDcgQEAgaW50IF9famJkMl9sb2dfc3RhcnRfY29tbWl0KGpvdXJuYWxfdCAqam91cm5h
bCwgdGlkX3QgdGlkKTsNCiBpbnQgamJkMl9qb3VybmFsX3N0YXJ0X2NvbW1pdChqb3VybmFsX3Qg
KmpvdXJuYWwsIHRpZF90ICp0aWQpOw0KIGludCBqYmQyX2pvdXJuYWxfZm9yY2VfY29tbWl0X25l
c3RlZChqb3VybmFsX3QgKmpvdXJuYWwpOw0KIGludCBqYmQyX2xvZ193YWl0X2NvbW1pdChqb3Vy
bmFsX3QgKmpvdXJuYWwsIHRpZF90IHRpZCk7DQoraW50IGpiZDJfY29tcGxldGVfdHJhbnNhY3Rp
b24oam91cm5hbF90ICpqb3VybmFsLCB0aWRfdCB0aWQpOw0KIGludCBqYmQyX2xvZ19kb19jaGVj
a3BvaW50KGpvdXJuYWxfdCAqam91cm5hbCk7DQogaW50IGpiZDJfdHJhbnNfd2lsbF9zZW5kX2Rh
dGFfYmFycmllcihqb3VybmFsX3QgKmpvdXJuYWwsIHRpZF90IHRpZCk7DQogDQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9tbS5oIGIvaW5jbHVkZS9saW51eC9tbS5oDQppbmRleCA0YmFhZGQx
Li5kMDQ5M2Y2IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbS5oDQorKysgYi9pbmNsdWRl
L2xpbnV4L21tLmgNCkBAIC0xNTA5LDYgKzE1MDksOCBAQCBpbnQgdm1faW5zZXJ0X3BmbihzdHJ1
Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyLA0KIAkJCXVuc2lnbmVk
IGxvbmcgcGZuKTsNCiBpbnQgdm1faW5zZXJ0X21peGVkKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAq
dm1hLCB1bnNpZ25lZCBsb25nIGFkZHIsDQogCQkJdW5zaWduZWQgbG9uZyBwZm4pOw0KK2ludCB2
bV9pb21hcF9tZW1vcnkoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHBoeXNfYWRkcl90IHN0
YXJ0LCB1bnNpZ25lZCBsb25nIGxlbik7DQorDQogDQogc3RydWN0IHBhZ2UgKmZvbGxvd19wYWdl
KHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqLCB1bnNpZ25lZCBsb25nIGFkZHJlc3MsDQogCQkJdW5z
aWduZWQgaW50IGZvbGxfZmxhZ3MpOw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbmV0ZGV2
aWNlLmggYi9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQppbmRleCAwMGNhMzJiLi44YzQzZmQx
IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KKysrIGIvaW5jbHVkZS9s
aW51eC9uZXRkZXZpY2UuaA0KQEAgLTIyNSw5ICsyMjUsOSBAQCBzdHJ1Y3QgbmV0ZGV2X2h3X2Fk
ZHIgew0KICNkZWZpbmUgTkVUREVWX0hXX0FERFJfVF9TTEFWRQkJMw0KICNkZWZpbmUgTkVUREVW
X0hXX0FERFJfVF9VTklDQVNUCTQNCiAjZGVmaW5lIE5FVERFVl9IV19BRERSX1RfTVVMVElDQVNU
CTUNCi0JYm9vbAkJCXN5bmNlZDsNCiAJYm9vbAkJCWdsb2JhbF91c2U7DQogCWludAkJCXJlZmNv
dW50Ow0KKwlpbnQJCQlzeW5jZWQ7DQogCXN0cnVjdCByY3VfaGVhZAkJcmN1X2hlYWQ7DQogfTsN
CiANCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oIGIvaW5jbHVkZS9saW51eC9z
a2J1ZmYuaA0KaW5kZXggZGE2NTg5MC4uZWZlNTBhZiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGlu
dXgvc2tidWZmLmgNCisrKyBiL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCkBAIC0yMzY3LDYgKzIz
NjcsMTMgQEAgc3RhdGljIGlubGluZSB2b2lkIG5mX3Jlc2V0KHN0cnVjdCBza19idWZmICpza2Ip
DQogI2VuZGlmDQogfQ0KIA0KK3N0YXRpYyBpbmxpbmUgdm9pZCBuZl9yZXNldF90cmFjZShzdHJ1
Y3Qgc2tfYnVmZiAqc2tiKQ0KK3sNCisjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVURklMVEVSX1hU
X1RBUkdFVF9UUkFDRSkNCisJc2tiLT5uZl90cmFjZSA9IDA7DQorI2VuZGlmDQorfQ0KKw0KIC8q
IE5vdGU6IFRoaXMgZG9lc24ndCBwdXQgYW55IGNvbm50cmFjayBhbmQgYnJpZGdlIGluZm8gaW4g
ZHN0LiAqLw0KIHN0YXRpYyBpbmxpbmUgdm9pZCBfX25mX2NvcHkoc3RydWN0IHNrX2J1ZmYgKmRz
dCwgY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNyYykNCiB7DQpkaWZmIC0tZ2l0IGEvaXBjL3NobS5j
IGIvaXBjL3NobS5jDQppbmRleCBiNzZiZTViLi4zMjZhMjBiIDEwMDY0NA0KLS0tIGEvaXBjL3No
bS5jDQorKysgYi9pcGMvc2htLmMNCkBAIC00NTAsNyArNDUwLDcgQEAgc3RhdGljIGludCBuZXdz
ZWcoc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3QgaXBjX3BhcmFtcyAqcGFyYW1zKQ0K
IAlzaXplX3Qgc2l6ZSA9IHBhcmFtcy0+dS5zaXplOw0KIAlpbnQgZXJyb3I7DQogCXN0cnVjdCBz
aG1pZF9rZXJuZWwgKnNocDsNCi0JaW50IG51bXBhZ2VzID0gKHNpemUgKyBQQUdFX1NJWkUgLTEp
ID4+IFBBR0VfU0hJRlQ7DQorCXNpemVfdCBudW1wYWdlcyA9IChzaXplICsgUEFHRV9TSVpFIC0g
MSkgPj4gUEFHRV9TSElGVDsNCiAJc3RydWN0IGZpbGUgKiBmaWxlOw0KIAljaGFyIG5hbWVbMTNd
Ow0KIAlpbnQgaWQ7DQpkaWZmIC0tZ2l0IGEva2VybmVsL2F1ZGl0X3RyZWUuYyBiL2tlcm5lbC9h
dWRpdF90cmVlLmMNCmluZGV4IDMxZmRjNDguLjBjYWYxZjggMTAwNjQ0DQotLS0gYS9rZXJuZWwv
YXVkaXRfdHJlZS5jDQorKysgYi9rZXJuZWwvYXVkaXRfdHJlZS5jDQpAQCAtNjA4LDkgKzYwOCw5
IEBAIHZvaWQgYXVkaXRfdHJpbV90cmVlcyh2b2lkKQ0KIAkJfQ0KIAkJc3Bpbl91bmxvY2soJmhh
c2hfbG9jayk7DQogCQl0cmltX21hcmtlZCh0cmVlKTsNCi0JCXB1dF90cmVlKHRyZWUpOw0KIAkJ
ZHJvcF9jb2xsZWN0ZWRfbW91bnRzKHJvb3RfbW50KTsNCiBza2lwX2l0Og0KKwkJcHV0X3RyZWUo
dHJlZSk7DQogCQltdXRleF9sb2NrKCZhdWRpdF9maWx0ZXJfbXV0ZXgpOw0KIAl9DQogCWxpc3Rf
ZGVsKCZjdXJzb3IpOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAuYyBiL2tlcm5lbC9jZ3Jv
dXAuYw0KaW5kZXggYzA3MzlmOC4uZDJhMDFmZSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9jZ3JvdXAu
Yw0KKysrIGIva2VybmVsL2Nncm91cC5jDQpAQCAtMjAyOSw3ICsyMDI5LDcgQEAgaW50IGNncm91
cF9hdHRhY2hfcHJvYyhzdHJ1Y3QgY2dyb3VwICpjZ3JwLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKmxl
YWRlcikNCiAJaWYgKCFncm91cCkNCiAJCXJldHVybiAtRU5PTUVNOw0KIAkvKiBwcmUtYWxsb2Nh
dGUgdG8gZ3VhcmFudGVlIHNwYWNlIHdoaWxlIGl0ZXJhdGluZyBpbiByY3UgcmVhZC1zaWRlLiAq
Lw0KLQlyZXR2YWwgPSBmbGV4X2FycmF5X3ByZWFsbG9jKGdyb3VwLCAwLCBncm91cF9zaXplIC0g
MSwgR0ZQX0tFUk5FTCk7DQorCXJldHZhbCA9IGZsZXhfYXJyYXlfcHJlYWxsb2MoZ3JvdXAsIDAs
IGdyb3VwX3NpemUsIEdGUF9LRVJORUwpOw0KIAlpZiAocmV0dmFsKQ0KIAkJZ290byBvdXRfZnJl
ZV9ncm91cF9saXN0Ow0KIA0KZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVudHMvY29yZS5jIGIva2Vy
bmVsL2V2ZW50cy9jb3JlLmMNCmluZGV4IDdkMWYwNWUuLjlmMjE5MTUgMTAwNjQ0DQotLS0gYS9r
ZXJuZWwvZXZlbnRzL2NvcmUuYw0KKysrIGIva2VybmVsL2V2ZW50cy9jb3JlLmMNCkBAIC01MTY0
LDcgKzUxNjQsNyBAQCBzdGF0aWMgdm9pZCBzd19wZXJmX2V2ZW50X2Rlc3Ryb3koc3RydWN0IHBl
cmZfZXZlbnQgKmV2ZW50KQ0KIA0KIHN0YXRpYyBpbnQgcGVyZl9zd2V2ZW50X2luaXQoc3RydWN0
IHBlcmZfZXZlbnQgKmV2ZW50KQ0KIHsNCi0JaW50IGV2ZW50X2lkID0gZXZlbnQtPmF0dHIuY29u
ZmlnOw0KKwl1NjQgZXZlbnRfaWQgPSBldmVudC0+YXR0ci5jb25maWc7DQogDQogCWlmIChldmVu
dC0+YXR0ci50eXBlICE9IFBFUkZfVFlQRV9TT0ZUV0FSRSkNCiAJCXJldHVybiAtRU5PRU5UOw0K
QEAgLTU3NTYsNiArNTc1Niw3IEBAIHNraXBfdHlwZToNCiAJaWYgKHBtdS0+cG11X2NwdV9jb250
ZXh0KQ0KIAkJZ290byBnb3RfY3B1X2NvbnRleHQ7DQogDQorCXJldCA9IC1FTk9NRU07DQogCXBt
dS0+cG11X2NwdV9jb250ZXh0ID0gYWxsb2NfcGVyY3B1KHN0cnVjdCBwZXJmX2NwdV9jb250ZXh0
KTsNCiAJaWYgKCFwbXUtPnBtdV9jcHVfY29udGV4dCkNCiAJCWdvdG8gZnJlZV9kZXY7DQpkaWZm
IC0tZ2l0IGEva2VybmVsL2hydGltZXIuYyBiL2tlcm5lbC9ocnRpbWVyLmMNCmluZGV4IGU0Y2Vl
OGQuLjYwZjdlMzIgMTAwNjQ0DQotLS0gYS9rZXJuZWwvaHJ0aW1lci5jDQorKysgYi9rZXJuZWwv
aHJ0aW1lci5jDQpAQCAtMjk4LDYgKzI5OCwxMCBAQCBrdGltZV90IGt0aW1lX3N1Yl9ucyhjb25z
dCBrdGltZV90IGt0LCB1NjQgbnNlYykNCiAJfSBlbHNlIHsNCiAJCXVuc2lnbmVkIGxvbmcgcmVt
ID0gZG9fZGl2KG5zZWMsIE5TRUNfUEVSX1NFQyk7DQogDQorCQkvKiBNYWtlIHN1cmUgbnNlYyBm
aXRzIGludG8gbG9uZyAqLw0KKwkJaWYgKHVubGlrZWx5KG5zZWMgPiBLVElNRV9TRUNfTUFYKSkN
CisJCQlyZXR1cm4gKGt0aW1lX3QpeyAudHY2NCA9IEtUSU1FX01BWCB9Ow0KKw0KIAkJdG1wID0g
a3RpbWVfc2V0KChsb25nKW5zZWMsIHJlbSk7DQogCX0NCiANCkBAIC0xMzA4LDYgKzEzMTIsOCBA
QCByZXRyeToNCiANCiAJCQkJZXhwaXJlcyA9IGt0aW1lX3N1YihocnRpbWVyX2dldF9leHBpcmVz
KHRpbWVyKSwNCiAJCQkJCQkgICAgYmFzZS0+b2Zmc2V0KTsNCisJCQkJaWYgKGV4cGlyZXMudHY2
NCA8IDApDQorCQkJCQlleHBpcmVzLnR2NjQgPSBLVElNRV9NQVg7DQogCQkJCWlmIChleHBpcmVz
LnR2NjQgPCBleHBpcmVzX25leHQudHY2NCkNCiAJCQkJCWV4cGlyZXNfbmV4dCA9IGV4cGlyZXM7
DQogCQkJCWJyZWFrOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpY2stYnJvYWRjYXN0LmMg
Yi9rZXJuZWwvdGltZS90aWNrLWJyb2FkY2FzdC5jDQppbmRleCBjZDA2OGIyLi5jMzUwOWZiIDEw
MDY0NA0KLS0tIGEva2VybmVsL3RpbWUvdGljay1icm9hZGNhc3QuYw0KKysrIGIva2VybmVsL3Rp
bWUvdGljay1icm9hZGNhc3QuYw0KQEAgLTY2LDYgKzY2LDggQEAgc3RhdGljIHZvaWQgdGlja19i
cm9hZGNhc3Rfc3RhcnRfcGVyaW9kaWMoc3RydWN0IGNsb2NrX2V2ZW50X2RldmljZSAqYmMpDQog
ICovDQogaW50IHRpY2tfY2hlY2tfYnJvYWRjYXN0X2RldmljZShzdHJ1Y3QgY2xvY2tfZXZlbnRf
ZGV2aWNlICpkZXYpDQogew0KKwlzdHJ1Y3QgY2xvY2tfZXZlbnRfZGV2aWNlICpjdXIgPSB0aWNr
X2Jyb2FkY2FzdF9kZXZpY2UuZXZ0ZGV2Ow0KKw0KIAlpZiAoKGRldi0+ZmVhdHVyZXMgJiBDTE9D
S19FVlRfRkVBVF9EVU1NWSkgfHwNCiAJICAgICh0aWNrX2Jyb2FkY2FzdF9kZXZpY2UuZXZ0ZGV2
ICYmDQogCSAgICAgdGlja19icm9hZGNhc3RfZGV2aWNlLmV2dGRldi0+cmF0aW5nID49IGRldi0+
cmF0aW5nKSB8fA0KQEAgLTczLDYgKzc1LDggQEAgaW50IHRpY2tfY2hlY2tfYnJvYWRjYXN0X2Rl
dmljZShzdHJ1Y3QgY2xvY2tfZXZlbnRfZGV2aWNlICpkZXYpDQogCQlyZXR1cm4gMDsNCiANCiAJ
Y2xvY2tldmVudHNfZXhjaGFuZ2VfZGV2aWNlKHRpY2tfYnJvYWRjYXN0X2RldmljZS5ldnRkZXYs
IGRldik7DQorCWlmIChjdXIpDQorCQljdXItPmV2ZW50X2hhbmRsZXIgPSBjbG9ja2V2ZW50c19o
YW5kbGVfbm9vcDsNCiAJdGlja19icm9hZGNhc3RfZGV2aWNlLmV2dGRldiA9IGRldjsNCiAJaWYg
KCFjcHVtYXNrX2VtcHR5KHRpY2tfZ2V0X2Jyb2FkY2FzdF9tYXNrKCkpKQ0KIAkJdGlja19icm9h
ZGNhc3Rfc3RhcnRfcGVyaW9kaWMoZGV2KTsNCmRpZmYgLS1naXQgYS9rZXJuZWwvdGltZS90aWNr
LWNvbW1vbi5jIGIva2VybmVsL3RpbWUvdGljay1jb21tb24uYw0KaW5kZXggZGE2YzllYy4uZWFk
NzliYyAxMDA2NDQNCi0tLSBhL2tlcm5lbC90aW1lL3RpY2stY29tbW9uLmMNCisrKyBiL2tlcm5l
bC90aW1lL3RpY2stY29tbW9uLmMNCkBAIC0zMjMsNiArMzIzLDcgQEAgc3RhdGljIHZvaWQgdGlj
a19zaHV0ZG93bih1bnNpZ25lZCBpbnQgKmNwdXApDQogCQkgKi8NCiAJCWRldi0+bW9kZSA9IENM
T0NLX0VWVF9NT0RFX1VOVVNFRDsNCiAJCWNsb2NrZXZlbnRzX2V4Y2hhbmdlX2RldmljZShkZXYs
IE5VTEwpOw0KKwkJZGV2LT5ldmVudF9oYW5kbGVyID0gY2xvY2tldmVudHNfaGFuZGxlX25vb3A7
DQogCQl0ZC0+ZXZ0ZGV2ID0gTlVMTDsNCiAJfQ0KIAlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmdGlja19kZXZpY2VfbG9jaywgZmxhZ3MpOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS9m
dHJhY2UuYyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KaW5kZXggNTUyNzIxMS4uMjRiMzc1OSAx
MDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KKysrIGIva2VybmVsL3RyYWNlL2Z0
cmFjZS5jDQpAQCAtNTU0LDcgKzU1NCw3IEBAIGludCBmdHJhY2VfcHJvZmlsZV9wYWdlc19pbml0
KHN0cnVjdCBmdHJhY2VfcHJvZmlsZV9zdGF0ICpzdGF0KQ0KIA0KIAlwYWdlcyA9IERJVl9ST1VO
RF9VUChmdW5jdGlvbnMsIFBST0ZJTEVTX1BFUl9QQUdFKTsNCiANCi0JZm9yIChpID0gMDsgaSA8
IHBhZ2VzOyBpKyspIHsNCisJZm9yIChpID0gMTsgaSA8IHBhZ2VzOyBpKyspIHsNCiAJCXBnLT5u
ZXh0ID0gKHZvaWQgKilnZXRfemVyb2VkX3BhZ2UoR0ZQX0tFUk5FTCk7DQogCQlpZiAoIXBnLT5u
ZXh0KQ0KIAkJCWdvdG8gb3V0X2ZyZWU7DQpAQCAtMzMwMyw3ICszMzAzLDggQEAgb3V0Og0KIAlp
ZiAoZmFpbCkNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KLQlmdHJhY2VfZ3JhcGhfZmlsdGVyX2Vu
YWJsZWQgPSAxOw0KKwlmdHJhY2VfZ3JhcGhfZmlsdGVyX2VuYWJsZWQgPSAhISgqaWR4KTsNCisN
CiAJcmV0dXJuIDA7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZS5jIGIv
a2VybmVsL3RyYWNlL3RyYWNlLmMNCmluZGV4IDE3ZWRiMTQuLjBlYzZjMzQgMTAwNjQ0DQotLS0g
YS9rZXJuZWwvdHJhY2UvdHJhY2UuYw0KKysrIGIva2VybmVsL3RyYWNlL3RyYWNlLmMNCkBAIC00
NTYzLDYgKzQ1NjMsOCBAQCBzdGF0aWMgX19pbml0IGludCB0cmFjZXJfaW5pdF9kZWJ1Z2ZzKHZv
aWQpDQogCXRyYWNlX2FjY2Vzc19sb2NrX2luaXQoKTsNCiANCiAJZF90cmFjZXIgPSB0cmFjaW5n
X2luaXRfZGVudHJ5KCk7DQorCWlmICghZF90cmFjZXIpDQorCQlyZXR1cm4gMDsNCiANCiAJdHJh
Y2VfY3JlYXRlX2ZpbGUoInRyYWNpbmdfZW5hYmxlZCIsIDA2NDQsIGRfdHJhY2VyLA0KIAkJCSZn
bG9iYWxfdHJhY2UsICZ0cmFjaW5nX2N0cmxfZm9wcyk7DQpAQCAtNDY5NiwzNiArNDY5OCwzMiBA
QCB2b2lkIHRyYWNlX2luaXRfZ2xvYmFsX2l0ZXIoc3RydWN0IHRyYWNlX2l0ZXJhdG9yICppdGVy
KQ0KIAlpdGVyLT5jcHVfZmlsZSA9IFRSQUNFX1BJUEVfQUxMX0NQVTsNCiB9DQogDQotc3RhdGlj
IHZvaWQNCi1fX2Z0cmFjZV9kdW1wKGJvb2wgZGlzYWJsZV90cmFjaW5nLCBlbnVtIGZ0cmFjZV9k
dW1wX21vZGUgb29wc19kdW1wX21vZGUpDQordm9pZCBmdHJhY2VfZHVtcChlbnVtIGZ0cmFjZV9k
dW1wX21vZGUgb29wc19kdW1wX21vZGUpDQogew0KLQlzdGF0aWMgYXJjaF9zcGlubG9ja190IGZ0
cmFjZV9kdW1wX2xvY2sgPQ0KLQkJKGFyY2hfc3BpbmxvY2tfdClfX0FSQ0hfU1BJTl9MT0NLX1VO
TE9DS0VEOw0KIAkvKiB1c2Ugc3RhdGljIGJlY2F1c2UgaXRlciBjYW4gYmUgYSBiaXQgYmlnIGZv
ciB0aGUgc3RhY2sgKi8NCiAJc3RhdGljIHN0cnVjdCB0cmFjZV9pdGVyYXRvciBpdGVyOw0KKwlz
dGF0aWMgYXRvbWljX3QgZHVtcF9ydW5uaW5nOw0KIAl1bnNpZ25lZCBpbnQgb2xkX3VzZXJvYmo7
DQotCXN0YXRpYyBpbnQgZHVtcF9yYW47DQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogCWludCBj
bnQgPSAwLCBjcHU7DQogDQotCS8qIG9ubHkgb25lIGR1bXAgKi8NCi0JbG9jYWxfaXJxX3NhdmUo
ZmxhZ3MpOw0KLQlhcmNoX3NwaW5fbG9jaygmZnRyYWNlX2R1bXBfbG9jayk7DQotCWlmIChkdW1w
X3JhbikNCi0JCWdvdG8gb3V0Ow0KLQ0KLQlkdW1wX3JhbiA9IDE7DQorCS8qIE9ubHkgYWxsb3cg
b25lIGR1bXAgdXNlciBhdCBhIHRpbWUuICovDQorCWlmIChhdG9taWNfaW5jX3JldHVybigmZHVt
cF9ydW5uaW5nKSAhPSAxKSB7DQorCQlhdG9taWNfZGVjKCZkdW1wX3J1bm5pbmcpOw0KKwkJcmV0
dXJuOw0KKwl9DQogDQorCS8qDQorCSAqIEFsd2F5cyB0dXJuIG9mZiB0cmFjaW5nIHdoZW4gd2Ug
ZHVtcC4NCisJICogV2UgZG9uJ3QgbmVlZCB0byBzaG93IHRyYWNlIG91dHB1dCBvZiB3aGF0IGhh
cHBlbnMNCisJICogYmV0d2VlbiBtdWx0aXBsZSBjcmFzaGVzLg0KKwkgKg0KKwkgKiBJZiB0aGUg
dXNlciBkb2VzIGEgc3lzcnEteiwgdGhlbiB0aGV5IGNhbiByZS1lbmFibGUNCisJICogdHJhY2lu
ZyB3aXRoIGVjaG8gMSA+IHRyYWNpbmdfb24uDQorCSAqLw0KIAl0cmFjaW5nX29mZigpOw0KIA0K
LQkvKiBEaWQgZnVuY3Rpb24gdHJhY2VyIGFscmVhZHkgZ2V0IGRpc2FibGVkPyAqLw0KLQlpZiAo
ZnRyYWNlX2lzX2RlYWQoKSkgew0KLQkJcHJpbnRrKCIjIFdBUk5JTkc6IEZVTkNUSU9OIFRSQUNJ
TkcgSVMgQ09SUlVQVEVEXG4iKTsNCi0JCXByaW50aygiIyAgICAgICAgICBNQVkgQkUgTUlTU0lO
RyBGVU5DVElPTiBFVkVOVFNcbiIpOw0KLQl9DQotDQotCWlmIChkaXNhYmxlX3RyYWNpbmcpDQot
CQlmdHJhY2Vfa2lsbCgpOw0KKwlsb2NhbF9pcnFfc2F2ZShmbGFncyk7DQogDQogCXRyYWNlX2lu
aXRfZ2xvYmFsX2l0ZXIoJml0ZXIpOw0KIA0KQEAgLTQ3NTgsNiArNDc1NiwxMiBAQCBfX2Z0cmFj
ZV9kdW1wKGJvb2wgZGlzYWJsZV90cmFjaW5nLCBlbnVtIGZ0cmFjZV9kdW1wX21vZGUgb29wc19k
dW1wX21vZGUpDQogDQogCXByaW50ayhLRVJOX1RSQUNFICJEdW1waW5nIGZ0cmFjZSBidWZmZXI6
XG4iKTsNCiANCisJLyogRGlkIGZ1bmN0aW9uIHRyYWNlciBhbHJlYWR5IGdldCBkaXNhYmxlZD8g
Ki8NCisJaWYgKGZ0cmFjZV9pc19kZWFkKCkpIHsNCisJCXByaW50aygiIyBXQVJOSU5HOiBGVU5D
VElPTiBUUkFDSU5HIElTIENPUlJVUFRFRFxuIik7DQorCQlwcmludGsoIiMgICAgICAgICAgTUFZ
IEJFIE1JU1NJTkcgRlVOQ1RJT04gRVZFTlRTXG4iKTsNCisJfQ0KKw0KIAkvKg0KIAkgKiBXZSBu
ZWVkIHRvIHN0b3AgYWxsIHRyYWNpbmcgb24gYWxsIENQVVMgdG8gcmVhZCB0aGUNCiAJICogdGhl
IG5leHQgYnVmZmVyLiBUaGlzIGlzIGEgYml0IGV4cGVuc2l2ZSwgYnV0IGlzDQpAQCAtNDc5Niwy
NiArNDgwMCwxNSBAQCBfX2Z0cmFjZV9kdW1wKGJvb2wgZGlzYWJsZV90cmFjaW5nLCBlbnVtIGZ0
cmFjZV9kdW1wX21vZGUgb29wc19kdW1wX21vZGUpDQogCQlwcmludGsoS0VSTl9UUkFDRSAiLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tXG4iKTsNCiANCiAgb3V0X2VuYWJsZToNCi0J
LyogUmUtZW5hYmxlIHRyYWNpbmcgaWYgcmVxdWVzdGVkICovDQotCWlmICghZGlzYWJsZV90cmFj
aW5nKSB7DQotCQl0cmFjZV9mbGFncyB8PSBvbGRfdXNlcm9iajsNCisJdHJhY2VfZmxhZ3MgfD0g
b2xkX3VzZXJvYmo7DQogDQotCQlmb3JfZWFjaF90cmFjaW5nX2NwdShjcHUpIHsNCi0JCQlhdG9t
aWNfZGVjKCZpdGVyLnRyLT5kYXRhW2NwdV0tPmRpc2FibGVkKTsNCi0JCX0NCi0JCXRyYWNpbmdf
b24oKTsNCisJZm9yX2VhY2hfdHJhY2luZ19jcHUoY3B1KSB7DQorCQlhdG9taWNfZGVjKCZpdGVy
LnRyLT5kYXRhW2NwdV0tPmRpc2FibGVkKTsNCiAJfQ0KLQ0KLSBvdXQ6DQotCWFyY2hfc3Bpbl91
bmxvY2soJmZ0cmFjZV9kdW1wX2xvY2spOw0KKyAJYXRvbWljX2RlYygmZHVtcF9ydW5uaW5nKTsN
CiAJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOw0KIH0NCi0NCi0vKiBCeSBkZWZhdWx0OiBkaXNh
YmxlIHRyYWNpbmcgYWZ0ZXIgdGhlIGR1bXAgKi8NCi12b2lkIGZ0cmFjZV9kdW1wKGVudW0gZnRy
YWNlX2R1bXBfbW9kZSBvb3BzX2R1bXBfbW9kZSkNCi17DQotCV9fZnRyYWNlX2R1bXAodHJ1ZSwg
b29wc19kdW1wX21vZGUpOw0KLX0NCitFWFBPUlRfU1lNQk9MX0dQTChmdHJhY2VfZHVtcCk7DQog
DQogX19pbml0IHN0YXRpYyBpbnQgdHJhY2VyX2FsbG9jX2J1ZmZlcnModm9pZCkNCiB7DQpkaWZm
IC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlX3NlbGZ0ZXN0LmMgYi9rZXJuZWwvdHJhY2UvdHJh
Y2Vfc2VsZnRlc3QuYw0KaW5kZXggMjg4NTQxZi4uMDlmZDk4YSAxMDA2NDQNCi0tLSBhL2tlcm5l
bC90cmFjZS90cmFjZV9zZWxmdGVzdC5jDQorKysgYi9rZXJuZWwvdHJhY2UvdHJhY2Vfc2VsZnRl
c3QuYw0KQEAgLTQ2MSw4ICs0NjEsNiBAQCB0cmFjZV9zZWxmdGVzdF9zdGFydHVwX2Z1bmN0aW9u
KHN0cnVjdCB0cmFjZXIgKnRyYWNlLCBzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyKQ0KIC8qIE1heGlt
dW0gbnVtYmVyIG9mIGZ1bmN0aW9ucyB0byB0cmFjZSBiZWZvcmUgZGlhZ25vc2luZyBhIGhhbmcg
Ki8NCiAjZGVmaW5lIEdSQVBIX01BWF9GVU5DX1RFU1QJMTAwMDAwMDAwDQogDQotc3RhdGljIHZv
aWQNCi1fX2Z0cmFjZV9kdW1wKGJvb2wgZGlzYWJsZV90cmFjaW5nLCBlbnVtIGZ0cmFjZV9kdW1w
X21vZGUgb29wc19kdW1wX21vZGUpOw0KIHN0YXRpYyB1bnNpZ25lZCBpbnQgZ3JhcGhfaGFuZ190
aHJlc2g7DQogDQogLyogV3JhcCB0aGUgcmVhbCBmdW5jdGlvbiBlbnRyeSBwcm9iZSB0byBhdm9p
ZCBwb3NzaWJsZSBoYW5naW5nICovDQpAQCAtNDcyLDggKzQ3MCwxMSBAQCBzdGF0aWMgaW50IHRy
YWNlX2dyYXBoX2VudHJ5X3dhdGNoZG9nKHN0cnVjdCBmdHJhY2VfZ3JhcGhfZW50ICp0cmFjZSkN
CiAJaWYgKHVubGlrZWx5KCsrZ3JhcGhfaGFuZ190aHJlc2ggPiBHUkFQSF9NQVhfRlVOQ19URVNU
KSkgew0KIAkJZnRyYWNlX2dyYXBoX3N0b3AoKTsNCiAJCXByaW50ayhLRVJOX1dBUk5JTkcgIkJV
RzogRnVuY3Rpb24gZ3JhcGggdHJhY2VyIGhhbmchXG4iKTsNCi0JCWlmIChmdHJhY2VfZHVtcF9v
bl9vb3BzKQ0KLQkJCV9fZnRyYWNlX2R1bXAoZmFsc2UsIERVTVBfQUxMKTsNCisJCWlmIChmdHJh
Y2VfZHVtcF9vbl9vb3BzKSB7DQorCQkJZnRyYWNlX2R1bXAoRFVNUF9BTEwpOw0KKwkJCS8qIGZ0
cmFjZV9kdW1wKCkgZGlzYWJsZXMgdHJhY2luZyAqLw0KKwkJCXRyYWNpbmdfb24oKTsNCisJCX0N
CiAJCXJldHVybiAwOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlX3N0
YWNrLmMgYi9rZXJuZWwvdHJhY2UvdHJhY2Vfc3RhY2suYw0KaW5kZXggNzc1NzViMy4uYzViMjBh
MyAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS90cmFjZV9zdGFjay5jDQorKysgYi9rZXJuZWwv
dHJhY2UvdHJhY2Vfc3RhY2suYw0KQEAgLTE3LDEzICsxNywyNCBAQA0KIA0KICNkZWZpbmUgU1RB
Q0tfVFJBQ0VfRU5UUklFUyA1MDANCiANCisjaWZkZWYgQ0NfVVNJTkdfRkVOVFJZDQorIyBkZWZp
bmUgZmVudHJ5CQkxDQorI2Vsc2UNCisjIGRlZmluZSBmZW50cnkJCTANCisjZW5kaWYNCisNCiBz
dGF0aWMgdW5zaWduZWQgbG9uZyBzdGFja19kdW1wX3RyYWNlW1NUQUNLX1RSQUNFX0VOVFJJRVMr
MV0gPQ0KIAkgeyBbMCAuLi4gKFNUQUNLX1RSQUNFX0VOVFJJRVMpXSA9IFVMT05HX01BWCB9Ow0K
IHN0YXRpYyB1bnNpZ25lZCBzdGFja19kdW1wX2luZGV4W1NUQUNLX1RSQUNFX0VOVFJJRVNdOw0K
IA0KKy8qDQorICogUmVzZXJ2ZSBvbmUgZW50cnkgZm9yIHRoZSBwYXNzZWQgaW4gaXAuIFRoaXMg
d2lsbCBhbGxvdw0KKyAqIHVzIHRvIHJlbW92ZSBtb3N0IG9yIGFsbCBvZiB0aGUgc3RhY2sgc2l6
ZSBvdmVyaGVhZA0KKyAqIGFkZGVkIGJ5IHRoZSBzdGFjayB0cmFjZXIgaXRzZWxmLg0KKyAqLw0K
IHN0YXRpYyBzdHJ1Y3Qgc3RhY2tfdHJhY2UgbWF4X3N0YWNrX3RyYWNlID0gew0KLQkubWF4X2Vu
dHJpZXMJCT0gU1RBQ0tfVFJBQ0VfRU5UUklFUywNCi0JLmVudHJpZXMJCT0gc3RhY2tfZHVtcF90
cmFjZSwNCisJLm1heF9lbnRyaWVzCQk9IFNUQUNLX1RSQUNFX0VOVFJJRVMgLSAxLA0KKwkuZW50
cmllcwkJPSAmc3RhY2tfZHVtcF90cmFjZVsxXSwNCiB9Ow0KIA0KIHN0YXRpYyB1bnNpZ25lZCBs
b25nIG1heF9zdGFja19zaXplOw0KQEAgLTM3LDI1ICs0OCwzNCBAQCBzdGF0aWMgREVGSU5FX01V
VEVYKHN0YWNrX3N5c2N0bF9tdXRleCk7DQogaW50IHN0YWNrX3RyYWNlcl9lbmFibGVkOw0KIHN0
YXRpYyBpbnQgbGFzdF9zdGFja190cmFjZXJfZW5hYmxlZDsNCiANCi1zdGF0aWMgaW5saW5lIHZv
aWQgY2hlY2tfc3RhY2sodm9pZCkNCitzdGF0aWMgaW5saW5lIHZvaWQNCitjaGVja19zdGFjayh1
bnNpZ25lZCBsb25nIGlwLCB1bnNpZ25lZCBsb25nICpzdGFjaykNCiB7DQogCXVuc2lnbmVkIGxv
bmcgdGhpc19zaXplLCBmbGFnczsNCiAJdW5zaWduZWQgbG9uZyAqcCwgKnRvcCwgKnN0YXJ0Ow0K
KwlzdGF0aWMgaW50IHRyYWNlcl9mcmFtZTsNCisJaW50IGZyYW1lX3NpemUgPSBBQ0NFU1NfT05D
RSh0cmFjZXJfZnJhbWUpOw0KIAlpbnQgaTsNCiANCi0JdGhpc19zaXplID0gKCh1bnNpZ25lZCBs
b25nKSZ0aGlzX3NpemUpICYgKFRIUkVBRF9TSVpFLTEpOw0KKwl0aGlzX3NpemUgPSAoKHVuc2ln
bmVkIGxvbmcpc3RhY2spICYgKFRIUkVBRF9TSVpFLTEpOw0KIAl0aGlzX3NpemUgPSBUSFJFQURf
U0laRSAtIHRoaXNfc2l6ZTsNCisJLyogUmVtb3ZlIHRoZSBmcmFtZSBvZiB0aGUgdHJhY2VyICov
DQorCXRoaXNfc2l6ZSAtPSBmcmFtZV9zaXplOw0KIA0KIAlpZiAodGhpc19zaXplIDw9IG1heF9z
dGFja19zaXplKQ0KIAkJcmV0dXJuOw0KIA0KIAkvKiB3ZSBkbyBub3QgaGFuZGxlIGludGVycnVw
dCBzdGFja3MgeWV0ICovDQotCWlmICghb2JqZWN0X2lzX29uX3N0YWNrKCZ0aGlzX3NpemUpKQ0K
KwlpZiAoIW9iamVjdF9pc19vbl9zdGFjayhzdGFjaykpDQogCQlyZXR1cm47DQogDQogCWxvY2Fs
X2lycV9zYXZlKGZsYWdzKTsNCiAJYXJjaF9zcGluX2xvY2soJm1heF9zdGFja19sb2NrKTsNCiAN
CisJLyogSW4gY2FzZSBhbm90aGVyIENQVSBzZXQgdGhlIHRyYWNlcl9mcmFtZSBvbiB1cyAqLw0K
KwlpZiAodW5saWtlbHkoIWZyYW1lX3NpemUpKQ0KKwkJdGhpc19zaXplIC09IHRyYWNlcl9mcmFt
ZTsNCisNCiAJLyogYSByYWNlIGNvdWxkIGhhdmUgYWxyZWFkeSB1cGRhdGVkIGl0ICovDQogCWlm
ICh0aGlzX3NpemUgPD0gbWF4X3N0YWNrX3NpemUpDQogCQlnb3RvIG91dDsNCkBAIC02OCwxMCAr
ODgsMTggQEAgc3RhdGljIGlubGluZSB2b2lkIGNoZWNrX3N0YWNrKHZvaWQpDQogCXNhdmVfc3Rh
Y2tfdHJhY2UoJm1heF9zdGFja190cmFjZSk7DQogDQogCS8qDQorCSAqIEFkZCB0aGUgcGFzc2Vk
IGluIGlwIGZyb20gdGhlIGZ1bmN0aW9uIHRyYWNlci4NCisJICogU2VhcmNoaW5nIGZvciB0aGlz
IG9uIHRoZSBzdGFjayB3aWxsIHNraXAgb3Zlcg0KKwkgKiBtb3N0IG9mIHRoZSBvdmVyaGVhZCBm
cm9tIHRoZSBzdGFjayB0cmFjZXIgaXRzZWxmLg0KKwkgKi8NCisJc3RhY2tfZHVtcF90cmFjZVsw
XSA9IGlwOw0KKwltYXhfc3RhY2tfdHJhY2UubnJfZW50cmllcysrOw0KKw0KKwkvKg0KIAkgKiBO
b3cgZmluZCB3aGVyZSBpbiB0aGUgc3RhY2sgdGhlc2UgYXJlLg0KIAkgKi8NCiAJaSA9IDA7DQot
CXN0YXJ0ID0gJnRoaXNfc2l6ZTsNCisJc3RhcnQgPSBzdGFjazsNCiAJdG9wID0gKHVuc2lnbmVk
IGxvbmcgKikNCiAJCSgoKHVuc2lnbmVkIGxvbmcpc3RhcnQgJiB+KFRIUkVBRF9TSVpFLTEpKSAr
IFRIUkVBRF9TSVpFKTsNCiANCkBAIC05NSw2ICsxMjMsMTggQEAgc3RhdGljIGlubGluZSB2b2lk
IGNoZWNrX3N0YWNrKHZvaWQpDQogCQkJCWZvdW5kID0gMTsNCiAJCQkJLyogU3RhcnQgdGhlIHNl
YXJjaCBmcm9tIGhlcmUgKi8NCiAJCQkJc3RhcnQgPSBwICsgMTsNCisJCQkJLyoNCisJCQkJICog
V2UgZG8gbm90IHdhbnQgdG8gc2hvdyB0aGUgb3ZlcmhlYWQNCisJCQkJICogb2YgdGhlIHN0YWNr
IHRyYWNlciBzdGFjayBpbiB0aGUNCisJCQkJICogbWF4IHN0YWNrLiBJZiB3ZSBoYXZlbid0IGZp
Z3VyZWQNCisJCQkJICogb3V0IHdoYXQgdGhhdCBpcywgdGhlbiBmaWd1cmUgaXQgb3V0DQorCQkJ
CSAqIG5vdy4NCisJCQkJICovDQorCQkJCWlmICh1bmxpa2VseSghdHJhY2VyX2ZyYW1lKSAmJiBp
ID09IDEpIHsNCisJCQkJCXRyYWNlcl9mcmFtZSA9IChwIC0gc3RhY2spICoNCisJCQkJCQlzaXpl
b2YodW5zaWduZWQgbG9uZyk7DQorCQkJCQltYXhfc3RhY2tfc2l6ZSAtPSB0cmFjZXJfZnJhbWU7
DQorCQkJCX0NCiAJCQl9DQogCQl9DQogDQpAQCAtMTEwLDYgKzE1MCw3IEBAIHN0YXRpYyBpbmxp
bmUgdm9pZCBjaGVja19zdGFjayh2b2lkKQ0KIHN0YXRpYyB2b2lkDQogc3RhY2tfdHJhY2VfY2Fs
bCh1bnNpZ25lZCBsb25nIGlwLCB1bnNpZ25lZCBsb25nIHBhcmVudF9pcCkNCiB7DQorCXVuc2ln
bmVkIGxvbmcgc3RhY2s7DQogCWludCBjcHU7DQogDQogCWlmICh1bmxpa2VseSghZnRyYWNlX2Vu
YWJsZWQgfHwgc3RhY2tfdHJhY2VfZGlzYWJsZWQpKQ0KQEAgLTEyMiw3ICsxNjMsMjYgQEAgc3Rh
Y2tfdHJhY2VfY2FsbCh1bnNpZ25lZCBsb25nIGlwLCB1bnNpZ25lZCBsb25nIHBhcmVudF9pcCkN
CiAJaWYgKHBlcl9jcHUodHJhY2VfYWN0aXZlLCBjcHUpKysgIT0gMCkNCiAJCWdvdG8gb3V0Ow0K
IA0KLQljaGVja19zdGFjaygpOw0KKwkvKg0KKwkgKiBXaGVuIGZlbnRyeSBpcyB1c2VkLCB0aGUg
dHJhY2VkIGZ1bmN0aW9uIGRvZXMgbm90IGdldA0KKwkgKiBpdHMgc3RhY2sgZnJhbWUgc2V0IHVw
LCBhbmQgd2UgbG9zZSB0aGUgcGFyZW50Lg0KKwkgKiBUaGUgaXAgaXMgcHJldHR5IHVzZWxlc3Mg
YmVjYXVzZSB0aGUgZnVuY3Rpb24gdHJhY2VyDQorCSAqIHdhcyBjYWxsZWQgYmVmb3JlIHRoYXQg
ZnVuY3Rpb24gc2V0IHVwIGl0cyBzdGFjayBmcmFtZS4NCisJICogSW4gdGhpcyBjYXNlLCB3ZSB1
c2UgdGhlIHBhcmVudCBpcC4NCisJICoNCisJICogQnkgYWRkaW5nIHRoZSByZXR1cm4gYWRkcmVz
cyBvZiBlaXRoZXIgdGhlIHBhcmVudCBpcA0KKwkgKiBvciB0aGUgY3VycmVudCBpcCB3ZSBjYW4g
ZGlzcmVnYXJkIG1vc3Qgb2YgdGhlIHN0YWNrIHVzYWdlDQorCSAqIGNhdXNlZCBieSB0aGUgc3Rh
Y2sgdHJhY2VyIGl0c2VsZi4NCisJICoNCisJICogVGhlIGZ1bmN0aW9uIHRyYWNlciBhbHdheXMg
cmVwb3J0cyB0aGUgYWRkcmVzcyBvZiB3aGVyZSB0aGUNCisJICogbWNvdW50IGNhbGwgd2FzLCBi
dXQgdGhlIHN0YWNrIHdpbGwgaG9sZCB0aGUgcmV0dXJuIGFkZHJlc3MuDQorCSAqLw0KKwlpZiAo
ZmVudHJ5KQ0KKwkJaXAgPSBwYXJlbnRfaXA7DQorCWVsc2UNCisJCWlwICs9IE1DT1VOVF9JTlNO
X1NJWkU7DQorDQorCWNoZWNrX3N0YWNrKGlwLCAmc3RhY2spOw0KIA0KICBvdXQ6DQogCXBlcl9j
cHUodHJhY2VfYWN0aXZlLCBjcHUpLS07DQpAQCAtMzUxLDYgKzQxMSw4IEBAIHN0YXRpYyBfX2lu
aXQgaW50IHN0YWNrX3RyYWNlX2luaXQodm9pZCkNCiAJc3RydWN0IGRlbnRyeSAqZF90cmFjZXI7
DQogDQogCWRfdHJhY2VyID0gdHJhY2luZ19pbml0X2RlbnRyeSgpOw0KKwlpZiAoIWRfdHJhY2Vy
KQ0KKwkJcmV0dXJuIDA7DQogDQogCXRyYWNlX2NyZWF0ZV9maWxlKCJzdGFja19tYXhfc2l6ZSIs
IDA2NDQsIGRfdHJhY2VyLA0KIAkJCSZtYXhfc3RhY2tfc2l6ZSwgJnN0YWNrX21heF9zaXplX2Zv
cHMpOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZV9zdGF0LmMgYi9rZXJuZWwvdHJh
Y2UvdHJhY2Vfc3RhdC5jDQppbmRleCA5NmNmZmIyLi44NDdmODhhIDEwMDY0NA0KLS0tIGEva2Vy
bmVsL3RyYWNlL3RyYWNlX3N0YXQuYw0KKysrIGIva2VybmVsL3RyYWNlL3RyYWNlX3N0YXQuYw0K
QEAgLTMwNyw2ICszMDcsOCBAQCBzdGF0aWMgaW50IHRyYWNpbmdfc3RhdF9pbml0KHZvaWQpDQog
CXN0cnVjdCBkZW50cnkgKmRfdHJhY2luZzsNCiANCiAJZF90cmFjaW5nID0gdHJhY2luZ19pbml0
X2RlbnRyeSgpOw0KKwlpZiAoIWRfdHJhY2luZykNCisJCXJldHVybiAwOw0KIA0KIAlzdGF0X2Rp
ciA9IGRlYnVnZnNfY3JlYXRlX2RpcigidHJhY2Vfc3RhdCIsIGRfdHJhY2luZyk7DQogCWlmICgh
c3RhdF9kaXIpDQpkaWZmIC0tZ2l0IGEvbW0vbWVtb3J5LmMgYi9tbS9tZW1vcnkuYw0KaW5kZXgg
NGYyYWRkMS4uZDVmOTEzYiAxMDA2NDQNCi0tLSBhL21tL21lbW9yeS5jDQorKysgYi9tbS9tZW1v
cnkuYw0KQEAgLTIzMDksNiArMjMwOSw1MyBAQCBpbnQgcmVtYXBfcGZuX3JhbmdlKHN0cnVjdCB2
bV9hcmVhX3N0cnVjdCAqdm1hLCB1bnNpZ25lZCBsb25nIGFkZHIsDQogfQ0KIEVYUE9SVF9TWU1C
T0wocmVtYXBfcGZuX3JhbmdlKTsNCiANCisvKioNCisgKiB2bV9pb21hcF9tZW1vcnkgLSByZW1h
cCBtZW1vcnkgdG8gdXNlcnNwYWNlDQorICogQHZtYTogdXNlciB2bWEgdG8gbWFwIHRvDQorICog
QHN0YXJ0OiBzdGFydCBvZiBhcmVhDQorICogQGxlbjogc2l6ZSBvZiBhcmVhDQorICoNCisgKiBU
aGlzIGlzIGEgc2ltcGxpZmllZCBpb19yZW1hcF9wZm5fcmFuZ2UoKSBmb3IgY29tbW9uIGRyaXZl
ciB1c2UuIFRoZQ0KKyAqIGRyaXZlciBqdXN0IG5lZWRzIHRvIGdpdmUgdXMgdGhlIHBoeXNpY2Fs
IG1lbW9yeSByYW5nZSB0byBiZSBtYXBwZWQsDQorICogd2UnbGwgZmlndXJlIG91dCB0aGUgcmVz
dCBmcm9tIHRoZSB2bWEgaW5mb3JtYXRpb24uDQorICoNCisgKiBOT1RFISBTb21lIGRyaXZlcnMg
bWlnaHQgd2FudCB0byB0d2VhayB2bWEtPnZtX3BhZ2VfcHJvdCBmaXJzdCB0byBnZXQNCisgKiB3
aGF0ZXZlciB3cml0ZS1jb21iaW5pbmcgZGV0YWlscyBvciBzaW1pbGFyLg0KKyAqLw0KK2ludCB2
bV9pb21hcF9tZW1vcnkoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHBoeXNfYWRkcl90IHN0
YXJ0LCB1bnNpZ25lZCBsb25nIGxlbikNCit7DQorCXVuc2lnbmVkIGxvbmcgdm1fbGVuLCBwZm4s
IHBhZ2VzOw0KKw0KKwkvKiBDaGVjayB0aGF0IHRoZSBwaHlzaWNhbCBtZW1vcnkgYXJlYSBwYXNz
ZWQgaW4gbG9va3MgdmFsaWQgKi8NCisJaWYgKHN0YXJ0ICsgbGVuIDwgc3RhcnQpDQorCQlyZXR1
cm4gLUVJTlZBTDsNCisJLyoNCisJICogWW91ICpyZWFsbHkqIHNob3VsZG4ndCBtYXAgdGhpbmdz
IHRoYXQgYXJlbid0IHBhZ2UtYWxpZ25lZCwNCisJICogYnV0IHdlJ3ZlIGhpc3RvcmljYWxseSBh
bGxvd2VkIGl0IGJlY2F1c2UgSU8gbWVtb3J5IG1pZ2h0DQorCSAqIGp1c3QgaGF2ZSBzbWFsbGVy
IGFsaWdubWVudC4NCisJICovDQorCWxlbiArPSBzdGFydCAmIH5QQUdFX01BU0s7DQorCXBmbiA9
IHN0YXJ0ID4+IFBBR0VfU0hJRlQ7DQorCXBhZ2VzID0gKGxlbiArIH5QQUdFX01BU0spID4+IFBB
R0VfU0hJRlQ7DQorCWlmIChwZm4gKyBwYWdlcyA8IHBmbikNCisJCXJldHVybiAtRUlOVkFMOw0K
Kw0KKwkvKiBXZSBzdGFydCB0aGUgbWFwcGluZyAndm1fcGdvZmYnIHBhZ2VzIGludG8gdGhlIGFy
ZWEgKi8NCisJaWYgKHZtYS0+dm1fcGdvZmYgPiBwYWdlcykNCisJCXJldHVybiAtRUlOVkFMOw0K
KwlwZm4gKz0gdm1hLT52bV9wZ29mZjsNCisJcGFnZXMgLT0gdm1hLT52bV9wZ29mZjsNCisNCisJ
LyogQ2FuIHdlIGZpdCBhbGwgb2YgdGhlIG1hcHBpbmc/ICovDQorCXZtX2xlbiA9IHZtYS0+dm1f
ZW5kIC0gdm1hLT52bV9zdGFydDsNCisJaWYgKHZtX2xlbiA+PiBQQUdFX1NISUZUID4gcGFnZXMp
DQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCisJLyogT2ssIGxldCBpdCByaXAgKi8NCisJcmV0dXJu
IGlvX3JlbWFwX3Bmbl9yYW5nZSh2bWEsIHZtYS0+dm1fc3RhcnQsIHBmbiwgdm1fbGVuLCB2bWEt
PnZtX3BhZ2VfcHJvdCk7DQorfQ0KK0VYUE9SVF9TWU1CT0wodm1faW9tYXBfbWVtb3J5KTsNCisN
CiBzdGF0aWMgaW50IGFwcGx5X3RvX3B0ZV9yYW5nZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgcG1k
X3QgKnBtZCwNCiAJCQkJICAgICB1bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgZW5k
LA0KIAkJCQkgICAgIHB0ZV9mbl90IGZuLCB2b2lkICpkYXRhKQ0KZGlmZiAtLWdpdCBhL25ldC9h
dG0vY29tbW9uLmMgYi9uZXQvYXRtL2NvbW1vbi5jDQppbmRleCAwY2EwNmU4Li40M2I2YmZlIDEw
MDY0NA0KLS0tIGEvbmV0L2F0bS9jb21tb24uYw0KKysrIGIvbmV0L2F0bS9jb21tb24uYw0KQEAg
LTUwMCw2ICs1MDAsOCBAQCBpbnQgdmNjX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1
Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQogCXN0cnVjdCBza19idWZmICpz
a2I7DQogCWludCBjb3BpZWQsIGVycm9yID0gLUVJTlZBTDsNCiANCisJbXNnLT5tc2dfbmFtZWxl
biA9IDA7DQorDQogCWlmIChzb2NrLT5zdGF0ZSAhPSBTU19DT05ORUNURUQpDQogCQlyZXR1cm4g
LUVOT1RDT05OOw0KIAlpZiAoZmxhZ3MgJiB+TVNHX0RPTlRXQUlUKQkJLyogb25seSBoYW5kbGUg
TVNHX0RPTlRXQUlUICovDQpkaWZmIC0tZ2l0IGEvbmV0L2F4MjUvYWZfYXgyNS5jIGIvbmV0L2F4
MjUvYWZfYXgyNS5jDQppbmRleCBiMDRhNmVmLi44NmFjMzdmIDEwMDY0NA0KLS0tIGEvbmV0L2F4
MjUvYWZfYXgyNS5jDQorKysgYi9uZXQvYXgyNS9hZl9heDI1LmMNCkBAIC0xNjQxLDYgKzE2NDEs
NyBAQCBzdGF0aWMgaW50IGF4MjVfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBz
b2NrZXQgKnNvY2ssDQogCQlheDI1X2FkZHJlc3Mgc3JjOw0KIAkJY29uc3QgdW5zaWduZWQgY2hh
ciAqbWFjID0gc2tiX21hY19oZWFkZXIoc2tiKTsNCiANCisJCW1lbXNldChzYXgsIDAsIHNpemVv
ZihzdHJ1Y3QgZnVsbF9zb2NrYWRkcl9heDI1KSk7DQogCQlheDI1X2FkZHJfcGFyc2UobWFjICsg
MSwgc2tiLT5kYXRhIC0gbWFjIC0gMSwgJnNyYywgTlVMTCwNCiAJCQkJJmRpZ2ksIE5VTEwsIE5V
TEwpOw0KIAkJc2F4LT5zYXgyNV9mYW1pbHkgPSBBRl9BWDI1Ow0KZGlmZiAtLWdpdCBhL25ldC9i
bHVldG9vdGgvYWZfYmx1ZXRvb3RoLmMgYi9uZXQvYmx1ZXRvb3RoL2FmX2JsdWV0b290aC5jDQpp
bmRleCAwNjIxMjRjLi44MzhmMTEzIDEwMDY0NA0KLS0tIGEvbmV0L2JsdWV0b290aC9hZl9ibHVl
dG9vdGguYw0KKysrIGIvbmV0L2JsdWV0b290aC9hZl9ibHVldG9vdGguYw0KQEAgLTI0NSw2ICsy
NDUsOCBAQCBpbnQgYnRfc29ja19yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNv
Y2tldCAqc29jaywNCiAJaWYgKGZsYWdzICYgKE1TR19PT0IpKQ0KIAkJcmV0dXJuIC1FT1BOT1RT
VVBQOw0KIA0KKwltc2ctPm1zZ19uYW1lbGVuID0gMDsNCisNCiAJc2tiID0gc2tiX3JlY3ZfZGF0
YWdyYW0oc2ssIGZsYWdzLCBub2Jsb2NrLCAmZXJyKTsNCiAJaWYgKCFza2IpIHsNCiAJCWlmIChz
ay0+c2tfc2h1dGRvd24gJiBSQ1ZfU0hVVERPV04pDQpAQCAtMjUyLDggKzI1NCw2IEBAIGludCBi
dF9zb2NrX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0K
IAkJcmV0dXJuIGVycjsNCiAJfQ0KIA0KLQltc2ctPm1zZ19uYW1lbGVuID0gMDsNCi0NCiAJY29w
aWVkID0gc2tiLT5sZW47DQogCWlmIChsZW4gPCBjb3BpZWQpIHsNCiAJCW1zZy0+bXNnX2ZsYWdz
IHw9IE1TR19UUlVOQzsNCmRpZmYgLS1naXQgYS9uZXQvYmx1ZXRvb3RoL3JmY29tbS9zb2NrLmMg
Yi9uZXQvYmx1ZXRvb3RoL3JmY29tbS9zb2NrLmMNCmluZGV4IDE0YzQ4NjQuLjgyY2UxNjQgMTAw
NjQ0DQotLS0gYS9uZXQvYmx1ZXRvb3RoL3JmY29tbS9zb2NrLmMNCisrKyBiL25ldC9ibHVldG9v
dGgvcmZjb21tL3NvY2suYw0KQEAgLTYyNyw2ICs2MjcsNyBAQCBzdGF0aWMgaW50IHJmY29tbV9z
b2NrX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIA0K
IAlpZiAodGVzdF9hbmRfY2xlYXJfYml0KFJGQ09NTV9ERUZFUl9TRVRVUCwgJmQtPmZsYWdzKSkg
ew0KIAkJcmZjb21tX2RsY19hY2NlcHQoZCk7DQorCQltc2ctPm1zZ19uYW1lbGVuID0gMDsNCiAJ
CXJldHVybiAwOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvbmV0L2NhaWYvY2FpZl9zb2NrZXQuYyBi
L25ldC9jYWlmL2NhaWZfc29ja2V0LmMNCmluZGV4IGE5ODYyODAuLjUzYThlMzcgMTAwNjQ0DQot
LS0gYS9uZXQvY2FpZi9jYWlmX3NvY2tldC5jDQorKysgYi9uZXQvY2FpZi9jYWlmX3NvY2tldC5j
DQpAQCAtMzIwLDYgKzMyMCw4IEBAIHN0YXRpYyBpbnQgY2FpZl9zZXFwa3RfcmVjdm1zZyhzdHJ1
Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWlmIChtLT5tc2dfZmxhZ3Mm
TVNHX09PQikNCiAJCWdvdG8gcmVhZF9lcnJvcjsNCiANCisJbS0+bXNnX25hbWVsZW4gPSAwOw0K
Kw0KIAlza2IgPSBza2JfcmVjdl9kYXRhZ3JhbShzaywgZmxhZ3MsIDAgLCAmcmV0KTsNCiAJaWYg
KCFza2IpDQogCQlnb3RvIHJlYWRfZXJyb3I7DQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZGV2LmMg
Yi9uZXQvY29yZS9kZXYuYw0KaW5kZXggNzIwYWVhMC4uOGU0NTViOCAxMDA2NDQNCi0tLSBhL25l
dC9jb3JlL2Rldi5jDQorKysgYi9uZXQvY29yZS9kZXYuYw0KQEAgLTE2MTksNiArMTYxOSw3IEBA
IGludCBkZXZfZm9yd2FyZF9za2Ioc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IHNrX2J1
ZmYgKnNrYikNCiAJc2tiLT5tYXJrID0gMDsNCiAJc2VjcGF0aF9yZXNldChza2IpOw0KIAluZl9y
ZXNldChza2IpOw0KKwluZl9yZXNldF90cmFjZShza2IpOw0KIAlyZXR1cm4gbmV0aWZfcngoc2ti
KTsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoZGV2X2ZvcndhcmRfc2tiKTsNCmRpZmYgLS1naXQg
YS9uZXQvY29yZS9kZXZfYWRkcl9saXN0cy5jIGIvbmV0L2NvcmUvZGV2X2FkZHJfbGlzdHMuYw0K
aW5kZXggMDM4N2RhMC4uY2QwOTQxNCAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL2Rldl9hZGRyX2xp
c3RzLmMNCisrKyBiL25ldC9jb3JlL2Rldl9hZGRyX2xpc3RzLmMNCkBAIC01Nyw3ICs1Nyw3IEBA
IHN0YXRpYyBpbnQgX19od19hZGRyX2FkZF9leChzdHJ1Y3QgbmV0ZGV2X2h3X2FkZHJfbGlzdCAq
bGlzdCwNCiAJaGEtPnR5cGUgPSBhZGRyX3R5cGU7DQogCWhhLT5yZWZjb3VudCA9IDE7DQogCWhh
LT5nbG9iYWxfdXNlID0gZ2xvYmFsOw0KLQloYS0+c3luY2VkID0gZmFsc2U7DQorCWhhLT5zeW5j
ZWQgPSAwOw0KIAlsaXN0X2FkZF90YWlsX3JjdSgmaGEtPmxpc3QsICZsaXN0LT5saXN0KTsNCiAJ
bGlzdC0+Y291bnQrKzsNCiAJcmV0dXJuIDA7DQpAQCAtMTU1LDcgKzE1NSw3IEBAIGludCBfX2h3
X2FkZHJfc3luYyhzdHJ1Y3QgbmV0ZGV2X2h3X2FkZHJfbGlzdCAqdG9fbGlzdCwNCiAJCQkJCSAg
ICBhZGRyX2xlbiwgaGEtPnR5cGUpOw0KIAkJCWlmIChlcnIpDQogCQkJCWJyZWFrOw0KLQkJCWhh
LT5zeW5jZWQgPSB0cnVlOw0KKwkJCWhhLT5zeW5jZWQrKzsNCiAJCQloYS0+cmVmY291bnQrKzsN
CiAJCX0gZWxzZSBpZiAoaGEtPnJlZmNvdW50ID09IDEpIHsNCiAJCQlfX2h3X2FkZHJfZGVsKHRv
X2xpc3QsIGhhLT5hZGRyLCBhZGRyX2xlbiwgaGEtPnR5cGUpOw0KQEAgLTE3Niw3ICsxNzYsNyBA
QCB2b2lkIF9faHdfYWRkcl91bnN5bmMoc3RydWN0IG5ldGRldl9od19hZGRyX2xpc3QgKnRvX2xp
c3QsDQogCQlpZiAoaGEtPnN5bmNlZCkgew0KIAkJCV9faHdfYWRkcl9kZWwodG9fbGlzdCwgaGEt
PmFkZHIsDQogCQkJCSAgICAgIGFkZHJfbGVuLCBoYS0+dHlwZSk7DQotCQkJaGEtPnN5bmNlZCA9
IGZhbHNlOw0KKwkJCWhhLT5zeW5jZWQtLTsNCiAJCQlfX2h3X2FkZHJfZGVsKGZyb21fbGlzdCwg
aGEtPmFkZHIsDQogCQkJCSAgICAgIGFkZHJfbGVuLCBoYS0+dHlwZSk7DQogCQl9DQpkaWZmIC0t
Z2l0IGEvbmV0L2NvcmUvcnRuZXRsaW5rLmMgYi9uZXQvY29yZS9ydG5ldGxpbmsuYw0KaW5kZXgg
M2I1ZTY4MC4uNWI3ZDVmMiAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL3J0bmV0bGluay5jDQorKysg
Yi9uZXQvY29yZS9ydG5ldGxpbmsuYw0KQEAgLTEwNjQsNyArMTA2NCw3IEBAIHN0YXRpYyBpbnQg
cnRubF9kdW1wX2lmaW5mbyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgbmV0bGlua19jYWxs
YmFjayAqY2IpDQogCXJjdV9yZWFkX2xvY2soKTsNCiAJY2ItPnNlcSA9IG5ldC0+ZGV2X2Jhc2Vf
c2VxOw0KIA0KLQlpZiAobmxtc2dfcGFyc2UoY2ItPm5saCwgc2l6ZW9mKHN0cnVjdCBydGdlbm1z
ZyksIHRiLCBJRkxBX01BWCwNCisJaWYgKG5sbXNnX3BhcnNlKGNiLT5ubGgsIHNpemVvZihzdHJ1
Y3QgaWZpbmZvbXNnKSwgdGIsIElGTEFfTUFYLA0KIAkJCWlmbGFfcG9saWN5KSA+PSAwKSB7DQog
DQogCQlpZiAodGJbSUZMQV9FWFRfTUFTS10pDQpAQCAtMTkwNyw3ICsxOTA3LDcgQEAgc3RhdGlj
IHUxNiBydG5sX2NhbGNpdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qgbmxtc2doZHIgKm5s
aCkNCiAJdTMyIGV4dF9maWx0ZXJfbWFzayA9IDA7DQogCXUxNiBtaW5faWZpbmZvX2R1bXBfc2l6
ZSA9IDA7DQogDQotCWlmIChubG1zZ19wYXJzZShubGgsIHNpemVvZihzdHJ1Y3QgcnRnZW5tc2cp
LCB0YiwgSUZMQV9NQVgsDQorCWlmIChubG1zZ19wYXJzZShubGgsIHNpemVvZihzdHJ1Y3QgaWZp
bmZvbXNnKSwgdGIsIElGTEFfTUFYLA0KIAkJCWlmbGFfcG9saWN5KSA+PSAwKSB7DQogCQlpZiAo
dGJbSUZMQV9FWFRfTUFTS10pDQogCQkJZXh0X2ZpbHRlcl9tYXNrID0gbmxhX2dldF91MzIodGJb
SUZMQV9FWFRfTUFTS10pOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2VzcDQuYyBiL25ldC9pcHY0
L2VzcDQuYw0KaW5kZXggNTMwNzg3Yi4uMjM4ZmMzYiAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L2Vz
cDQuYw0KKysrIGIvbmV0L2lwdjQvZXNwNC5jDQpAQCAtMTM3LDggKzEzNyw2IEBAIHN0YXRpYyBp
bnQgZXNwX291dHB1dChzdHJ1Y3QgeGZybV9zdGF0ZSAqeCwgc3RydWN0IHNrX2J1ZmYgKnNrYikN
CiANCiAJLyogc2tiIGlzIHB1cmUgcGF5bG9hZCB0byBlbmNyeXB0ICovDQogDQotCWVyciA9IC1F
Tk9NRU07DQotDQogCWVzcCA9IHgtPmRhdGE7DQogCWFlYWQgPSBlc3AtPmFlYWQ7DQogCWFsZW4g
PSBjcnlwdG9fYWVhZF9hdXRoc2l6ZShhZWFkKTsNCkBAIC0xNzQsOCArMTcyLDEwIEBAIHN0YXRp
YyBpbnQgZXNwX291dHB1dChzdHJ1Y3QgeGZybV9zdGF0ZSAqeCwgc3RydWN0IHNrX2J1ZmYgKnNr
YikNCiAJfQ0KIA0KIAl0bXAgPSBlc3BfYWxsb2NfdG1wKGFlYWQsIG5mcmFncyArIHNnbGlzdHMs
IHNlcWhpbGVuKTsNCi0JaWYgKCF0bXApDQorCWlmICghdG1wKSB7DQorCQllcnIgPSAtRU5PTUVN
Ow0KIAkJZ290byBlcnJvcjsNCisJfQ0KIA0KIAlzZXFoaSA9IGVzcF90bXBfc2VxaGkodG1wKTsN
CiAJaXYgPSBlc3BfdG1wX2l2KGFlYWQsIHRtcCwgc2VxaGlsZW4pOw0KZGlmZiAtLWdpdCBhL25l
dC9pcHY0L2lwX2ZyYWdtZW50LmMgYi9uZXQvaXB2NC9pcF9mcmFnbWVudC5jDQppbmRleCBiMmNm
ZTgzLi44ZjQ0MWIyIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvaXBfZnJhZ21lbnQuYw0KKysrIGIv
bmV0L2lwdjQvaXBfZnJhZ21lbnQuYw0KQEAgLTI1MSw4ICsyNTEsNyBAQCBzdGF0aWMgdm9pZCBp
cF9leHBpcmUodW5zaWduZWQgbG9uZyBhcmcpDQogCQlpZiAoIWhlYWQtPmRldikNCiAJCQlnb3Rv
IG91dF9yY3VfdW5sb2NrOw0KIA0KLQkJLyogc2tiIGRzdCBpcyBzdGFsZSwgZHJvcCBpdCwgYW5k
IHBlcmZvcm0gcm91dGUgbG9va3VwIGFnYWluICovDQotCQlza2JfZHN0X2Ryb3AoaGVhZCk7DQor
CQkvKiBza2IgaGFzIG5vIGRzdCwgcGVyZm9ybSByb3V0ZSBsb29rdXAgYWdhaW4gKi8NCiAJCWlw
aCA9IGlwX2hkcihoZWFkKTsNCiAJCWVyciA9IGlwX3JvdXRlX2lucHV0X25vcmVmKGhlYWQsIGlw
aC0+ZGFkZHIsIGlwaC0+c2FkZHIsDQogCQkJCQkgICBpcGgtPnRvcywgaGVhZC0+ZGV2KTsNCkBA
IC01MTgsOCArNTE3LDE2IEBAIGZvdW5kOg0KIAkJcXAtPnEubGFzdF9pbiB8PSBJTkVUX0ZSQUdf
RklSU1RfSU47DQogDQogCWlmIChxcC0+cS5sYXN0X2luID09IChJTkVUX0ZSQUdfRklSU1RfSU4g
fCBJTkVUX0ZSQUdfTEFTVF9JTikgJiYNCi0JICAgIHFwLT5xLm1lYXQgPT0gcXAtPnEubGVuKQ0K
LQkJcmV0dXJuIGlwX2ZyYWdfcmVhc20ocXAsIHByZXYsIGRldik7DQorCSAgICBxcC0+cS5tZWF0
ID09IHFwLT5xLmxlbikgew0KKwkJdW5zaWduZWQgbG9uZyBvcmVmZHN0ID0gc2tiLT5fc2tiX3Jl
ZmRzdDsNCisNCisJCXNrYi0+X3NrYl9yZWZkc3QgPSAwVUw7DQorCQllcnIgPSBpcF9mcmFnX3Jl
YXNtKHFwLCBwcmV2LCBkZXYpOw0KKwkJc2tiLT5fc2tiX3JlZmRzdCA9IG9yZWZkc3Q7DQorCQly
ZXR1cm4gZXJyOw0KKwl9DQorDQorCXNrYl9kc3RfZHJvcChza2IpOw0KIA0KIAl3cml0ZV9sb2Nr
KCZpcDRfZnJhZ3MubG9jayk7DQogCWxpc3RfbW92ZV90YWlsKCZxcC0+cS5scnVfbGlzdCwgJnFw
LT5xLm5ldC0+bHJ1X2xpc3QpOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L3N5bmNvb2tpZXMuYyBi
L25ldC9pcHY0L3N5bmNvb2tpZXMuYw0KaW5kZXggNzY5YzBlOS4uOGExYmVkMiAxMDA2NDQNCi0t
LSBhL25ldC9pcHY0L3N5bmNvb2tpZXMuYw0KKysrIGIvbmV0L2lwdjQvc3luY29va2llcy5jDQpA
QCAtMzQ3LDggKzM0Nyw4IEBAIHN0cnVjdCBzb2NrICpjb29raWVfdjRfY2hlY2soc3RydWN0IHNv
Y2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAkgKiBoYXNuJ3QgY2hhbmdlZCBzaW5jZSB3
ZSByZWNlaXZlZCB0aGUgb3JpZ2luYWwgc3luLCBidXQgSSBzZWUNCiAJICogbm8gZWFzeSB3YXkg
dG8gZG8gdGhpcy4NCiAJICovDQotCWZsb3dpNF9pbml0X291dHB1dCgmZmw0LCAwLCBzay0+c2tf
bWFyaywgUlRfQ09OTl9GTEFHUyhzayksDQotCQkJICAgUlRfU0NPUEVfVU5JVkVSU0UsIElQUFJP
VE9fVENQLA0KKwlmbG93aTRfaW5pdF9vdXRwdXQoJmZsNCwgc2stPnNrX2JvdW5kX2Rldl9pZiwg
c2stPnNrX21hcmssDQorCQkJICAgUlRfQ09OTl9GTEFHUyhzayksIFJUX1NDT1BFX1VOSVZFUlNF
LCBJUFBST1RPX1RDUCwNCiAJCQkgICBpbmV0X3NrX2Zsb3dpX2ZsYWdzKHNrKSwNCiAJCQkgICAo
b3B0ICYmIG9wdC0+c3JyKSA/IG9wdC0+ZmFkZHIgOiBpcmVxLT5ybXRfYWRkciwNCiAJCQkgICBp
cmVxLT5sb2NfYWRkciwgdGgtPnNvdXJjZSwgdGgtPmRlc3QpOw0KZGlmZiAtLWdpdCBhL25ldC9p
cHY0L3RjcF9pbnB1dC5jIGIvbmV0L2lwdjQvdGNwX2lucHV0LmMNCmluZGV4IDMxMjRlMTcuLjg3
MmI0MWQgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC90Y3BfaW5wdXQuYw0KKysrIGIvbmV0L2lwdjQv
dGNwX2lucHV0LmMNCkBAIC0xMTUsNiArMTE1LDcgQEAgaW50IHN5c2N0bF90Y3BfYWJjIF9fcmVh
ZF9tb3N0bHk7DQogI2RlZmluZSBGTEFHX0RTQUNLSU5HX0FDSwkweDgwMCAvKiBTQUNLIGJsb2Nr
cyBjb250YWluZWQgRC1TQUNLIGluZm8gKi8NCiAjZGVmaW5lIEZMQUdfTk9OSEVBRF9SRVRSQU5T
X0FDS0VECTB4MTAwMCAvKiBOb24taGVhZCByZXhtaXR0ZWQgZGF0YSB3YXMgQUNLZWQgKi8NCiAj
ZGVmaW5lIEZMQUdfU0FDS19SRU5FR0lORwkweDIwMDAgLyogc25kX3VuYSBhZHZhbmNlZCB0byBh
IHNhY2tlZCBzZXEgKi8NCisjZGVmaW5lIEZMQUdfVVBEQVRFX1RTX1JFQ0VOVAkweDQwMDAgLyog
dGNwX3JlcGxhY2VfdHNfcmVjZW50KCkgKi8NCiANCiAjZGVmaW5lIEZMQUdfQUNLRUQJCShGTEFH
X0RBVEFfQUNLRUR8RkxBR19TWU5fQUNLRUQpDQogI2RlZmluZSBGTEFHX05PVF9EVVAJCShGTEFH
X0RBVEF8RkxBR19XSU5fVVBEQVRFfEZMQUdfQUNLRUQpDQpAQCAtMzcyMyw2ICszNzI0LDI3IEBA
IHN0YXRpYyB2b2lkIHRjcF9zZW5kX2NoYWxsZW5nZV9hY2soc3RydWN0IHNvY2sgKnNrKQ0KIAl9
DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHRjcF9zdG9yZV90c19yZWNlbnQoc3RydWN0IHRjcF9zb2Nr
ICp0cCkNCit7DQorCXRwLT5yeF9vcHQudHNfcmVjZW50ID0gdHAtPnJ4X29wdC5yY3ZfdHN2YWw7
DQorCXRwLT5yeF9vcHQudHNfcmVjZW50X3N0YW1wID0gZ2V0X3NlY29uZHMoKTsNCit9DQorDQor
c3RhdGljIHZvaWQgdGNwX3JlcGxhY2VfdHNfcmVjZW50KHN0cnVjdCB0Y3Bfc29jayAqdHAsIHUz
MiBzZXEpDQorew0KKwlpZiAodHAtPnJ4X29wdC5zYXdfdHN0YW1wICYmICFhZnRlcihzZXEsIHRw
LT5yY3Zfd3VwKSkgew0KKwkJLyogUEFXUyBidWcgd29ya2Fyb3VuZCB3cnQuIEFDSyBmcmFtZXMs
IHRoZSBQQVdTIGRpc2NhcmQNCisJCSAqIGV4dHJhIGNoZWNrIGJlbG93IG1ha2VzIHN1cmUgdGhp
cyBjYW4gb25seSBoYXBwZW4NCisJCSAqIGZvciBwdXJlIEFDSyBmcmFtZXMuICAtRGF2ZU0NCisJ
CSAqDQorCQkgKiBOb3Qgb25seSwgYWxzbyBpdCBvY2N1cnMgZm9yIGV4cGlyZWQgdGltZXN0YW1w
cy4NCisJCSAqLw0KKw0KKwkJaWYgKHRjcF9wYXdzX2NoZWNrKCZ0cC0+cnhfb3B0LCAwKSkNCisJ
CQl0Y3Bfc3RvcmVfdHNfcmVjZW50KHRwKTsNCisJfQ0KK30NCisNCiAvKiBUaGlzIHJvdXRpbmUg
ZGVhbHMgd2l0aCBpbmNvbWluZyBhY2tzLCBidXQgbm90IG91dGdvaW5nIG9uZXMuICovDQogc3Rh
dGljIGludCB0Y3BfYWNrKHN0cnVjdCBzb2NrICpzaywgY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNr
YiwgaW50IGZsYWcpDQogew0KQEAgLTM3NzEsNiArMzc5MywxMiBAQCBzdGF0aWMgaW50IHRjcF9h
Y2soc3RydWN0IHNvY2sgKnNrLCBjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBpbnQgZmxhZykN
CiAJcHJpb3JfZmFja2V0cyA9IHRwLT5mYWNrZXRzX291dDsNCiAJcHJpb3JfaW5fZmxpZ2h0ID0g
dGNwX3BhY2tldHNfaW5fZmxpZ2h0KHRwKTsNCiANCisJLyogdHNfcmVjZW50IHVwZGF0ZSBtdXN0
IGJlIG1hZGUgYWZ0ZXIgd2UgYXJlIHN1cmUgdGhhdCB0aGUgcGFja2V0DQorCSAqIGlzIGluIHdp
bmRvdy4NCisJICovDQorCWlmIChmbGFnICYgRkxBR19VUERBVEVfVFNfUkVDRU5UKQ0KKwkJdGNw
X3JlcGxhY2VfdHNfcmVjZW50KHRwLCBUQ1BfU0tCX0NCKHNrYiktPnNlcSk7DQorDQogCWlmICgh
KGZsYWcgJiBGTEFHX1NMT1dQQVRIKSAmJiBhZnRlcihhY2ssIHByaW9yX3NuZF91bmEpKSB7DQog
CQkvKiBXaW5kb3cgaXMgY29uc3RhbnQsIHB1cmUgZm9yd2FyZCBhZHZhbmNlLg0KIAkJICogTm8g
bW9yZSBjaGVja3MgYXJlIHJlcXVpcmVkLg0KQEAgLTQwNjEsMjcgKzQwODksNiBAQCBjb25zdCB1
OCAqdGNwX3BhcnNlX21kNXNpZ19vcHRpb24oY29uc3Qgc3RydWN0IHRjcGhkciAqdGgpDQogRVhQ
T1JUX1NZTUJPTCh0Y3BfcGFyc2VfbWQ1c2lnX29wdGlvbik7DQogI2VuZGlmDQogDQotc3RhdGlj
IGlubGluZSB2b2lkIHRjcF9zdG9yZV90c19yZWNlbnQoc3RydWN0IHRjcF9zb2NrICp0cCkNCi17
DQotCXRwLT5yeF9vcHQudHNfcmVjZW50ID0gdHAtPnJ4X29wdC5yY3ZfdHN2YWw7DQotCXRwLT5y
eF9vcHQudHNfcmVjZW50X3N0YW1wID0gZ2V0X3NlY29uZHMoKTsNCi19DQotDQotc3RhdGljIGlu
bGluZSB2b2lkIHRjcF9yZXBsYWNlX3RzX3JlY2VudChzdHJ1Y3QgdGNwX3NvY2sgKnRwLCB1MzIg
c2VxKQ0KLXsNCi0JaWYgKHRwLT5yeF9vcHQuc2F3X3RzdGFtcCAmJiAhYWZ0ZXIoc2VxLCB0cC0+
cmN2X3d1cCkpIHsNCi0JCS8qIFBBV1MgYnVnIHdvcmthcm91bmQgd3J0LiBBQ0sgZnJhbWVzLCB0
aGUgUEFXUyBkaXNjYXJkDQotCQkgKiBleHRyYSBjaGVjayBiZWxvdyBtYWtlcyBzdXJlIHRoaXMg
Y2FuIG9ubHkgaGFwcGVuDQotCQkgKiBmb3IgcHVyZSBBQ0sgZnJhbWVzLiAgLURhdmVNDQotCQkg
Kg0KLQkJICogTm90IG9ubHksIGFsc28gaXQgb2NjdXJzIGZvciBleHBpcmVkIHRpbWVzdGFtcHMu
DQotCQkgKi8NCi0NCi0JCWlmICh0Y3BfcGF3c19jaGVjaygmdHAtPnJ4X29wdCwgMCkpDQotCQkJ
dGNwX3N0b3JlX3RzX3JlY2VudCh0cCk7DQotCX0NCi19DQotDQogLyogU29ycnksIFBBV1MgYXMg
c3BlY2lmaWVkIGlzIGJyb2tlbiB3cnQuIHB1cmUtQUNLcyAtRGF2ZU0NCiAgKg0KICAqIEl0IGlz
IG5vdCBmYXRhbC4gSWYgdGhpcyBBQ0sgZG9lcyBfbm90XyBjaGFuZ2UgY3JpdGljYWwgc3RhdGUg
KHNlcXMsIHdpbmRvdykNCkBAIC01NTUyLDE0ICs1NTU5LDEwIEBAIHNsb3dfcGF0aDoNCiAJCXJl
dHVybiAwOw0KIA0KIHN0ZXA1Og0KLQlpZiAodGgtPmFjayAmJiB0Y3BfYWNrKHNrLCBza2IsIEZM
QUdfU0xPV1BBVEgpIDwgMCkNCisJaWYgKHRoLT5hY2sgJiYNCisJICAgIHRjcF9hY2soc2ssIHNr
YiwgRkxBR19TTE9XUEFUSCB8IEZMQUdfVVBEQVRFX1RTX1JFQ0VOVCkgPCAwKQ0KIAkJZ290byBk
aXNjYXJkOw0KIA0KLQkvKiB0c19yZWNlbnQgdXBkYXRlIG11c3QgYmUgbWFkZSBhZnRlciB3ZSBh
cmUgc3VyZSB0aGF0IHRoZSBwYWNrZXQNCi0JICogaXMgaW4gd2luZG93Lg0KLQkgKi8NCi0JdGNw
X3JlcGxhY2VfdHNfcmVjZW50KHRwLCBUQ1BfU0tCX0NCKHNrYiktPnNlcSk7DQotDQogCXRjcF9y
Y3ZfcnR0X21lYXN1cmVfdHMoc2ssIHNrYik7DQogDQogCS8qIFByb2Nlc3MgdXJnZW50IGRhdGEu
ICovDQpAQCAtNTkyMyw3ICs1OTI2LDggQEAgaW50IHRjcF9yY3Zfc3RhdGVfcHJvY2VzcyhzdHJ1
Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsDQogDQogCS8qIHN0ZXAgNTogY2hlY2sg
dGhlIEFDSyBmaWVsZCAqLw0KIAlpZiAodGgtPmFjaykgew0KLQkJaW50IGFjY2VwdGFibGUgPSB0
Y3BfYWNrKHNrLCBza2IsIEZMQUdfU0xPV1BBVEgpID4gMDsNCisJCWludCBhY2NlcHRhYmxlID0g
dGNwX2Fjayhzaywgc2tiLCBGTEFHX1NMT1dQQVRIIHwNCisJCQkJCQkgIEZMQUdfVVBEQVRFX1RT
X1JFQ0VOVCkgPiAwOw0KIA0KIAkJc3dpdGNoIChzay0+c2tfc3RhdGUpIHsNCiAJCWNhc2UgVENQ
X1NZTl9SRUNWOg0KQEAgLTYwMzAsMTEgKzYwMzQsNiBAQCBpbnQgdGNwX3Jjdl9zdGF0ZV9wcm9j
ZXNzKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJfSBlbHNlDQogCQln
b3RvIGRpc2NhcmQ7DQogDQotCS8qIHRzX3JlY2VudCB1cGRhdGUgbXVzdCBiZSBtYWRlIGFmdGVy
IHdlIGFyZSBzdXJlIHRoYXQgdGhlIHBhY2tldA0KLQkgKiBpcyBpbiB3aW5kb3cuDQotCSAqLw0K
LQl0Y3BfcmVwbGFjZV90c19yZWNlbnQodHAsIFRDUF9TS0JfQ0Ioc2tiKS0+c2VxKTsNCi0NCiAJ
Lyogc3RlcCA2OiBjaGVjayB0aGUgVVJHIGJpdCAqLw0KIAl0Y3BfdXJnKHNrLCBza2IsIHRoKTsN
CiANCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9hZGRyY29uZi5jIGIvbmV0L2lwdjYvYWRkcmNvbmYu
Yw0KaW5kZXggODU4OWMyZC4uZDg0MDMzYiAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2FkZHJjb25m
LmMNCisrKyBiL25ldC9pcHY2L2FkZHJjb25mLmMNCkBAIC0yNDA0LDYgKzI0MDQsOSBAQCBzdGF0
aWMgdm9pZCBzaXRfYWRkX3Y0X2FkZHJzKHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYpDQogc3RhdGlj
IHZvaWQgaW5pdF9sb29wYmFjayhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIHsNCiAJc3RydWN0
IGluZXQ2X2RldiAgKmlkZXY7DQorCXN0cnVjdCBuZXRfZGV2aWNlICpzcF9kZXY7DQorCXN0cnVj
dCBpbmV0Nl9pZmFkZHIgKnNwX2lmYTsNCisJc3RydWN0IHJ0Nl9pbmZvICpzcF9ydDsNCiANCiAJ
LyogOjoxICovDQogDQpAQCAtMjQxNSw2ICsyNDE4LDMwIEBAIHN0YXRpYyB2b2lkIGluaXRfbG9v
cGJhY2soc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJfQ0KIA0KIAlhZGRfYWRkcihpZGV2LCAm
aW42YWRkcl9sb29wYmFjaywgMTI4LCBJRkFfSE9TVCk7DQorDQorCS8qIEFkZCByb3V0ZXMgdG8g
b3RoZXIgaW50ZXJmYWNlJ3MgSVB2NiBhZGRyZXNzZXMgKi8NCisJZm9yX2VhY2hfbmV0ZGV2KGRl
dl9uZXQoZGV2KSwgc3BfZGV2KSB7DQorCQlpZiAoIXN0cmNtcChzcF9kZXYtPm5hbWUsIGRldi0+
bmFtZSkpDQorCQkJY29udGludWU7DQorDQorCQlpZGV2ID0gX19pbjZfZGV2X2dldChzcF9kZXYp
Ow0KKwkJaWYgKCFpZGV2KQ0KKwkJCWNvbnRpbnVlOw0KKw0KKwkJcmVhZF9sb2NrX2JoKCZpZGV2
LT5sb2NrKTsNCisJCWxpc3RfZm9yX2VhY2hfZW50cnkoc3BfaWZhLCAmaWRldi0+YWRkcl9saXN0
LCBpZl9saXN0KSB7DQorDQorCQkJaWYgKHNwX2lmYS0+ZmxhZ3MgJiAoSUZBX0ZfREFERkFJTEVE
IHwgSUZBX0ZfVEVOVEFUSVZFKSkNCisJCQkJY29udGludWU7DQorDQorCQkJc3BfcnQgPSBhZGRy
Y29uZl9kc3RfYWxsb2MoaWRldiwgJnNwX2lmYS0+YWRkciwgMCk7DQorDQorCQkJLyogRmFpbHVy
ZSBjYXNlcyBhcmUgaWdub3JlZCAqLw0KKwkJCWlmICghSVNfRVJSKHNwX3J0KSkNCisJCQkJaXA2
X2luc19ydChzcF9ydCk7DQorCQl9DQorCQlyZWFkX3VubG9ja19iaCgmaWRldi0+bG9jayk7DQor
CX0NCiB9DQogDQogc3RhdGljIHZvaWQgYWRkcmNvbmZfYWRkX2xpbmtsb2NhbChzdHJ1Y3QgaW5l
dDZfZGV2ICppZGV2LCBjb25zdCBzdHJ1Y3QgaW42X2FkZHIgKmFkZHIpDQpkaWZmIC0tZ2l0IGEv
bmV0L2lwdjYvcmVhc3NlbWJseS5jIGIvbmV0L2lwdjYvcmVhc3NlbWJseS5jDQppbmRleCAyYjBh
NGNhLi40MTFmZTJjIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjYvcmVhc3NlbWJseS5jDQorKysgYi9u
ZXQvaXB2Ni9yZWFzc2VtYmx5LmMNCkBAIC0zODYsOCArMzg2LDE3IEBAIGZvdW5kOg0KIAl9DQog
DQogCWlmIChmcS0+cS5sYXN0X2luID09IChJTkVUX0ZSQUdfRklSU1RfSU4gfCBJTkVUX0ZSQUdf
TEFTVF9JTikgJiYNCi0JICAgIGZxLT5xLm1lYXQgPT0gZnEtPnEubGVuKQ0KLQkJcmV0dXJuIGlw
Nl9mcmFnX3JlYXNtKGZxLCBwcmV2LCBkZXYpOw0KKwkgICAgZnEtPnEubWVhdCA9PSBmcS0+cS5s
ZW4pIHsNCisJCWludCByZXM7DQorCQl1bnNpZ25lZCBsb25nIG9yZWZkc3QgPSBza2ItPl9za2Jf
cmVmZHN0Ow0KKw0KKwkJc2tiLT5fc2tiX3JlZmRzdCA9IDBVTDsNCisJCXJlcyA9IGlwNl9mcmFn
X3JlYXNtKGZxLCBwcmV2LCBkZXYpOw0KKwkJc2tiLT5fc2tiX3JlZmRzdCA9IG9yZWZkc3Q7DQor
CQlyZXR1cm4gcmVzOw0KKwl9DQorDQorCXNrYl9kc3RfZHJvcChza2IpOw0KIA0KIAl3cml0ZV9s
b2NrKCZpcDZfZnJhZ3MubG9jayk7DQogCWxpc3RfbW92ZV90YWlsKCZmcS0+cS5scnVfbGlzdCwg
JmZxLT5xLm5ldC0+bHJ1X2xpc3QpOw0KZGlmZiAtLWdpdCBhL25ldC9pcmRhL2FmX2lyZGEuYyBi
L25ldC9pcmRhL2FmX2lyZGEuYw0KaW5kZXggZjRiNDljNS4uOTE4MjFlOSAxMDA2NDQNCi0tLSBh
L25ldC9pcmRhL2FmX2lyZGEuYw0KKysrIGIvbmV0L2lyZGEvYWZfaXJkYS5jDQpAQCAtMTM4Niw2
ICsxMzg2LDggQEAgc3RhdGljIGludCBpcmRhX3JlY3Ztc2dfZGdyYW0oc3RydWN0IGtpb2NiICpp
b2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIA0KIAlJUkRBX0RFQlVHKDQsICIlcygpXG4iLCBf
X2Z1bmNfXyk7DQogDQorCW1zZy0+bXNnX25hbWVsZW4gPSAwOw0KKw0KIAlza2IgPSBza2JfcmVj
dl9kYXRhZ3JhbShzaywgZmxhZ3MgJiB+TVNHX0RPTlRXQUlULA0KIAkJCQlmbGFncyAmIE1TR19E
T05UV0FJVCwgJmVycik7DQogCWlmICghc2tiKQ0KZGlmZiAtLWdpdCBhL25ldC9pdWN2L2FmX2l1
Y3YuYyBiL25ldC9pdWN2L2FmX2l1Y3YuYw0KaW5kZXggY2Y5OGQ2Mi4uZTgzNjE0MCAxMDA2NDQN
Ci0tLSBhL25ldC9pdWN2L2FmX2l1Y3YuYw0KKysrIGIvbmV0L2l1Y3YvYWZfaXVjdi5jDQpAQCAt
MTM1Niw2ICsxMzU2LDggQEAgc3RhdGljIGludCBpdWN2X3NvY2tfcmVjdm1zZyhzdHJ1Y3Qga2lv
Y2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWludCBibGVuOw0KIAlpbnQgZXJyID0g
MDsNCiANCisJbXNnLT5tc2dfbmFtZWxlbiA9IDA7DQorDQogCWlmICgoc2stPnNrX3N0YXRlID09
IElVQ1ZfRElTQ09OTiB8fCBzay0+c2tfc3RhdGUgPT0gSVVDVl9TRVZFUkVEKSAmJg0KIAkgICAg
c2tiX3F1ZXVlX2VtcHR5KCZpdWN2LT5iYWNrbG9nX3NrYl9xKSAmJg0KIAkgICAgc2tiX3F1ZXVl
X2VtcHR5KCZzay0+c2tfcmVjZWl2ZV9xdWV1ZSkgJiYNCmRpZmYgLS1naXQgYS9uZXQvbGxjL2Fm
X2xsYy5jIGIvbmV0L2xsYy9hZl9sbGMuYw0KaW5kZXggOTlhNjBkNS4uZTU1NjVjNyAxMDA2NDQN
Ci0tLSBhL25ldC9sbGMvYWZfbGxjLmMNCisrKyBiL25ldC9sbGMvYWZfbGxjLmMNCkBAIC03MjAs
NiArNzIwLDggQEAgc3RhdGljIGludCBsbGNfdWlfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2Is
IHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWludCB0YXJnZXQ7CS8qIFJlYWQgYXQgbGVhc3QgdGhp
cyBtYW55IGJ5dGVzICovDQogCWxvbmcgdGltZW87DQogDQorCW1zZy0+bXNnX25hbWVsZW4gPSAw
Ow0KKw0KIAlsb2NrX3NvY2soc2spOw0KIAljb3BpZWQgPSAtRU5PVENPTk47DQogCWlmICh1bmxp
a2VseShzay0+c2tfdHlwZSA9PSBTT0NLX1NUUkVBTSAmJiBzay0+c2tfc3RhdGUgPT0gVENQX0xJ
U1RFTikpDQpkaWZmIC0tZ2l0IGEvbmV0L25ldHJvbS9hZl9uZXRyb20uYyBiL25ldC9uZXRyb20v
YWZfbmV0cm9tLmMNCmluZGV4IGYxNTYzODIuLjNkZjdjNWEgMTAwNjQ0DQotLS0gYS9uZXQvbmV0
cm9tL2FmX25ldHJvbS5jDQorKysgYi9uZXQvbmV0cm9tL2FmX25ldHJvbS5jDQpAQCAtMTE3OCw2
ICsxMTc4LDcgQEAgc3RhdGljIGludCBucl9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3Ry
dWN0IHNvY2tldCAqc29jaywNCiAJfQ0KIA0KIAlpZiAoc2F4ICE9IE5VTEwpIHsNCisJCW1lbXNl
dChzYXgsIDAsIHNpemVvZigqc2F4KSk7DQogCQlzYXgtPnNheDI1X2ZhbWlseSA9IEFGX05FVFJP
TTsNCiAJCXNrYl9jb3B5X2Zyb21fbGluZWFyX2RhdGFfb2Zmc2V0KHNrYiwgNywgc2F4LT5zYXgy
NV9jYWxsLmF4MjVfY2FsbCwNCiAJCQkgICAgICBBWDI1X0FERFJfTEVOKTsNCmRpZmYgLS1naXQg
YS9uZXQvcm9zZS9hZl9yb3NlLmMgYi9uZXQvcm9zZS9hZl9yb3NlLmMNCmluZGV4IGY5ZWE5MjUu
LjFmOTZmYjkgMTAwNjQ0DQotLS0gYS9uZXQvcm9zZS9hZl9yb3NlLmMNCisrKyBiL25ldC9yb3Nl
L2FmX3Jvc2UuYw0KQEAgLTEyNTgsNiArMTI1OCw3IEBAIHN0YXRpYyBpbnQgcm9zZV9yZWN2bXNn
KHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29jaywNCiAJc2tiX2NvcHlfZGF0
YWdyYW1faW92ZWMoc2tiLCAwLCBtc2ctPm1zZ19pb3YsIGNvcGllZCk7DQogDQogCWlmIChzcm9z
ZSAhPSBOVUxMKSB7DQorCQltZW1zZXQoc3Jvc2UsIDAsIG1zZy0+bXNnX25hbWVsZW4pOw0KIAkJ
c3Jvc2UtPnNyb3NlX2ZhbWlseSA9IEFGX1JPU0U7DQogCQlzcm9zZS0+c3Jvc2VfYWRkciAgID0g
cm9zZS0+ZGVzdF9hZGRyOw0KIAkJc3Jvc2UtPnNyb3NlX2NhbGwgICA9IHJvc2UtPmRlc3RfY2Fs
bDsNCmRpZmYgLS1naXQgYS9uZXQvc2NoZWQvc2NoX2NicS5jIGIvbmV0L3NjaGVkL3NjaF9jYnEu
Yw0KaW5kZXggNTk5ZjY3YS4uYjdjZGRiOSAxMDA2NDQNCi0tLSBhL25ldC9zY2hlZC9zY2hfY2Jx
LmMNCisrKyBiL25ldC9zY2hlZC9zY2hfY2JxLmMNCkBAIC05NjMsOCArOTYzLDExIEBAIGNicV9k
ZXF1ZXVlKHN0cnVjdCBRZGlzYyAqc2NoKQ0KIAkJY2JxX3VwZGF0ZShxKTsNCiAJCWlmICgoaW5j
ciAtPSBpbmNyMikgPCAwKQ0KIAkJCWluY3IgPSAwOw0KKwkJcS0+bm93ICs9IGluY3I7DQorCX0g
ZWxzZSB7DQorCQlpZiAobm93ID4gcS0+bm93KQ0KKwkJCXEtPm5vdyA9IG5vdzsNCiAJfQ0KLQlx
LT5ub3cgKz0gaW5jcjsNCiAJcS0+bm93X3J0ID0gbm93Ow0KIA0KIAlmb3IgKDs7KSB7DQpkaWZm
IC0tZ2l0IGEvbmV0L3NjdHAvYXV0aC5jIGIvbmV0L3NjdHAvYXV0aC5jDQppbmRleCBiZjgxMjA0
Li4zMzM5MjZkIDEwMDY0NA0KLS0tIGEvbmV0L3NjdHAvYXV0aC5jDQorKysgYi9uZXQvc2N0cC9h
dXRoLmMNCkBAIC03MSw3ICs3MSw3IEBAIHZvaWQgc2N0cF9hdXRoX2tleV9wdXQoc3RydWN0IHNj
dHBfYXV0aF9ieXRlcyAqa2V5KQ0KIAkJcmV0dXJuOw0KIA0KIAlpZiAoYXRvbWljX2RlY19hbmRf
dGVzdCgma2V5LT5yZWZjbnQpKSB7DQotCQlrZnJlZShrZXkpOw0KKwkJa3pmcmVlKGtleSk7DQog
CQlTQ1RQX0RCR19PQkpDTlRfREVDKGtleXMpOw0KIAl9DQogfQ0KZGlmZiAtLWdpdCBhL25ldC90
aXBjL3NvY2tldC5jIGIvbmV0L3RpcGMvc29ja2V0LmMNCmluZGV4IDQyYjgzMjQuLmZkZjM0YWYg
MTAwNjQ0DQotLS0gYS9uZXQvdGlwYy9zb2NrZXQuYw0KKysrIGIvbmV0L3RpcGMvc29ja2V0LmMN
CkBAIC04MjksNiArODI5LDcgQEAgc3RhdGljIHZvaWQgc2V0X29yaWdfYWRkcihzdHJ1Y3QgbXNn
aGRyICptLCBzdHJ1Y3QgdGlwY19tc2cgKm1zZykNCiAJaWYgKGFkZHIpIHsNCiAJCWFkZHItPmZh
bWlseSA9IEFGX1RJUEM7DQogCQlhZGRyLT5hZGRydHlwZSA9IFRJUENfQUREUl9JRDsNCisJCW1l
bXNldCgmYWRkci0+YWRkciwgMCwgc2l6ZW9mKGFkZHItPmFkZHIpKTsNCiAJCWFkZHItPmFkZHIu
aWQucmVmID0gbXNnX29yaWdwb3J0KG1zZyk7DQogCQlhZGRyLT5hZGRyLmlkLm5vZGUgPSBtc2df
b3JpZ25vZGUobXNnKTsNCiAJCWFkZHItPmFkZHIubmFtZS5kb21haW4gPSAwOwkvKiBjb3VsZCBs
ZWF2ZSB1bmluaXRpYWxpemVkICovDQpAQCAtOTQ4LDYgKzk0OSw5IEBAIHN0YXRpYyBpbnQgcmVj
dl9tc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJZ290byBl
eGl0Ow0KIAl9DQogDQorCS8qIHdpbGwgYmUgdXBkYXRlZCBpbiBzZXRfb3JpZ19hZGRyKCkgaWYg
bmVlZGVkICovDQorCW0tPm1zZ19uYW1lbGVuID0gMDsNCisNCiAJdGltZW91dCA9IHNvY2tfcmN2
dGltZW8oc2ssIGZsYWdzICYgTVNHX0RPTlRXQUlUKTsNCiByZXN0YXJ0Og0KIA0KQEAgLTEwNzQs
NiArMTA3OCw5IEBAIHN0YXRpYyBpbnQgcmVjdl9zdHJlYW0oc3RydWN0IGtpb2NiICppb2NiLCBz
dHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJZ290byBleGl0Ow0KIAl9DQogDQorCS8qIHdpbGwgYmUg
dXBkYXRlZCBpbiBzZXRfb3JpZ19hZGRyKCkgaWYgbmVlZGVkICovDQorCW0tPm1zZ19uYW1lbGVu
ID0gMDsNCisNCiAJdGFyZ2V0ID0gc29ja19yY3Zsb3dhdChzaywgZmxhZ3MgJiBNU0dfV0FJVEFM
TCwgYnVmX2xlbik7DQogCXRpbWVvdXQgPSBzb2NrX3JjdnRpbWVvKHNrLCBmbGFncyAmIE1TR19E
T05UV0FJVCk7DQogcmVzdGFydDoNCmRpZmYgLS1naXQgYS9uZXQvdW5peC9hZl91bml4LmMgYi9u
ZXQvdW5peC9hZl91bml4LmMNCmluZGV4IDE4OTc4YjYuLjU2MTE1NjMgMTAwNjQ0DQotLS0gYS9u
ZXQvdW5peC9hZl91bml4LmMNCisrKyBiL25ldC91bml4L2FmX3VuaXguYw0KQEAgLTE5NTYsNyAr
MTk1Niw3IEBAIHN0YXRpYyBpbnQgdW5peF9zdHJlYW1fcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlv
Y2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCQkJaWYgKChVTklYQ0Ioc2tiKS5waWQgICE9IHNp
b2NiLT5zY20tPnBpZCkgfHwNCiAJCQkgICAgKFVOSVhDQihza2IpLmNyZWQgIT0gc2lvY2ItPnNj
bS0+Y3JlZCkpDQogCQkJCWJyZWFrOw0KLQkJfSBlbHNlIHsNCisJCX0gZWxzZSBpZiAodGVzdF9i
aXQoU09DS19QQVNTQ1JFRCwgJnNvY2stPmZsYWdzKSkgew0KIAkJCS8qIENvcHkgY3JlZGVudGlh
bHMgKi8NCiAJCQlzY21fc2V0X2NyZWQoc2lvY2ItPnNjbSwgVU5JWENCKHNrYikucGlkLCBVTklY
Q0Ioc2tiKS5jcmVkKTsNCiAJCQljaGVja19jcmVkcyA9IDE7DQpkaWZmIC0tZ2l0IGEvbmV0L3dp
cmVsZXNzL3JlZy5jIGIvbmV0L3dpcmVsZXNzL3JlZy5jDQppbmRleCAwYjA4OTA1Li4yMTk1OGNk
IDEwMDY0NA0KLS0tIGEvbmV0L3dpcmVsZXNzL3JlZy5jDQorKysgYi9uZXQvd2lyZWxlc3MvcmVn
LmMNCkBAIC04NTMsNyArODUzLDcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX2NoYW5uZWwoc3RydWN0
IHdpcGh5ICp3aXBoeSwNCiAJCQlyZXR1cm47DQogDQogCQlSRUdfREJHX1BSSU5UKCJEaXNhYmxp
bmcgZnJlcSAlZCBNSHpcbiIsIGNoYW4tPmNlbnRlcl9mcmVxKTsNCi0JCWNoYW4tPmZsYWdzID0g
SUVFRTgwMjExX0NIQU5fRElTQUJMRUQ7DQorCQljaGFuLT5mbGFncyB8PSBJRUVFODAyMTFfQ0hB
Tl9ESVNBQkxFRDsNCiAJCXJldHVybjsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL3NvdW5kL2NvcmUv
cGNtX25hdGl2ZS5jIGIvc291bmQvY29yZS9wY21fbmF0aXZlLmMNCmluZGV4IDdhZGE0MGUuLjYz
ODYwMGIgMTAwNjQ0DQotLS0gYS9zb3VuZC9jb3JlL3BjbV9uYXRpdmUuYw0KKysrIGIvc291bmQv
Y29yZS9wY21fbmF0aXZlLmMNCkBAIC0zMjA0LDE4ICszMjA0LDEwIEBAIEVYUE9SVF9TWU1CT0xf
R1BMKHNuZF9wY21fbGliX2RlZmF1bHRfbW1hcCk7DQogaW50IHNuZF9wY21fbGliX21tYXBfaW9t
ZW0oc3RydWN0IHNuZF9wY21fc3Vic3RyZWFtICpzdWJzdHJlYW0sDQogCQkJICAgc3RydWN0IHZt
X2FyZWFfc3RydWN0ICphcmVhKQ0KIHsNCi0JbG9uZyBzaXplOw0KLQl1bnNpZ25lZCBsb25nIG9m
ZnNldDsNCisJc3RydWN0IHNuZF9wY21fcnVudGltZSAqcnVudGltZSA9IHN1YnN0cmVhbS0+cnVu
dGltZTs7DQogDQogCWFyZWEtPnZtX3BhZ2VfcHJvdCA9IHBncHJvdF9ub25jYWNoZWQoYXJlYS0+
dm1fcGFnZV9wcm90KTsNCi0JYXJlYS0+dm1fZmxhZ3MgfD0gVk1fSU87DQotCXNpemUgPSBhcmVh
LT52bV9lbmQgLSBhcmVhLT52bV9zdGFydDsNCi0Jb2Zmc2V0ID0gYXJlYS0+dm1fcGdvZmYgPDwg
UEFHRV9TSElGVDsNCi0JaWYgKGlvX3JlbWFwX3Bmbl9yYW5nZShhcmVhLCBhcmVhLT52bV9zdGFy
dCwNCi0JCQkJKHN1YnN0cmVhbS0+cnVudGltZS0+ZG1hX2FkZHIgKyBvZmZzZXQpID4+IFBBR0Vf
U0hJRlQsDQotCQkJCXNpemUsIGFyZWEtPnZtX3BhZ2VfcHJvdCkpDQotCQlyZXR1cm4gLUVBR0FJ
TjsNCi0JcmV0dXJuIDA7DQorCXJldHVybiB2bV9pb21hcF9tZW1vcnkoYXJlYSwgcnVudGltZS0+
ZG1hX2FkZHIsIHJ1bnRpbWUtPmRtYV9ieXRlcyk7DQogfQ0KIA0KIEVYUE9SVF9TWU1CT0woc25k
X3BjbV9saWJfbW1hcF9pb21lbSk7DQpkaWZmIC0tZ2l0IGEvc291bmQvc29jL2NvZGVjcy9tYXg5
ODA4OC5jIGIvc291bmQvc29jL2NvZGVjcy9tYXg5ODA4OC5jDQppbmRleCBlYmJmNjNjLi5iN2Nm
MjQ2IDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVjcy9tYXg5ODA4OC5jDQorKysgYi9zb3Vu
ZC9zb2MvY29kZWNzL21heDk4MDg4LmMNCkBAIC0yMDA3LDcgKzIwMDcsNyBAQCBzdGF0aWMgaW50
IG1heDk4MDg4X3Byb2JlKHN0cnVjdCBzbmRfc29jX2NvZGVjICpjb2RlYykNCiAgICAgICAgICAg
ICAgICAgICAgICAgIHJldCk7DQogICAgICAgICAgICAgICAgZ290byBlcnJfYWNjZXNzOw0KICAg
ICAgICB9DQotICAgICAgIGRldl9pbmZvKGNvZGVjLT5kZXYsICJyZXZpc2lvbiAlY1xuIiwgcmV0
ICsgJ0EnKTsNCisgICAgICAgZGV2X2luZm8oY29kZWMtPmRldiwgInJldmlzaW9uICVjXG4iLCBy
ZXQgLSAweDQwICsgJ0EnKTsNCiANCiAgICAgICAgc25kX3NvY193cml0ZShjb2RlYywgTTk4MDg4
X1JFR181MV9QV1JfU1lTLCBNOTgwODhfUFdSU1YpOw0KIA0KZGlmZiAtLWdpdCBhL3NvdW5kL3Vz
Yi9jYXJkLmMgYi9zb3VuZC91c2IvY2FyZC5jDQppbmRleCA1NjZhY2IzLi5hY2I3ZmFjIDEwMDY0
NA0KLS0tIGEvc291bmQvdXNiL2NhcmQuYw0KKysrIGIvc291bmQvdXNiL2NhcmQuYw0KQEAgLTYx
MSw3ICs2MTEsOSBAQCBpbnQgc25kX3VzYl9hdXRvcmVzdW1lKHN0cnVjdCBzbmRfdXNiX2F1ZGlv
ICpjaGlwKQ0KIAlpbnQgZXJyID0gLUVOT0RFVjsNCiANCiAJZG93bl9yZWFkKCZjaGlwLT5zaHV0
ZG93bl9yd3NlbSk7DQotCWlmICghY2hpcC0+c2h1dGRvd24gJiYgIWNoaXAtPnByb2JpbmcpDQor
CWlmIChjaGlwLT5wcm9iaW5nKQ0KKwkJZXJyID0gMDsNCisJZWxzZSBpZiAoIWNoaXAtPnNodXRk
b3duKQ0KIAkJZXJyID0gdXNiX2F1dG9wbV9nZXRfaW50ZXJmYWNlKGNoaXAtPnBtX2ludGYpOw0K
IAl1cF9yZWFkKCZjaGlwLT5zaHV0ZG93bl9yd3NlbSk7DQogDQpkaWZmIC0tZ2l0IGEvc291bmQv
dXNiL2NhcmQuaCBiL3NvdW5kL3VzYi9jYXJkLmgNCmluZGV4IDY2NWUyOTcuLjJiNzU1OWMgMTAw
NjQ0DQotLS0gYS9zb3VuZC91c2IvY2FyZC5oDQorKysgYi9zb3VuZC91c2IvY2FyZC5oDQpAQCAt
NzMsNiArNzMsNyBAQCBzdHJ1Y3Qgc25kX3VzYl9zdWJzdHJlYW0gew0KIAl1bnNpZ25lZCBpbnQg
ZmlsbF9tYXg6IDE7CS8qIGZpbGwgbWF4IHBhY2tldCBzaXplIGFsd2F5cyAqLw0KIAl1bnNpZ25l
ZCBpbnQgdHhmcl9xdWlyazoxOwkvKiBhbGxvdyBzdWItZnJhbWUgYWxpZ25tZW50ICovDQogCXVu
c2lnbmVkIGludCBmbXRfdHlwZTsJCS8qIFVTQiBhdWRpbyBmb3JtYXQgdHlwZSAoMS0zKSAqLw0K
Kwl1bnNpZ25lZCBpbnQgcGt0X29mZnNldF9hZGo7CS8qIEJ5dGVzIHRvIGRyb3AgZnJvbSBiZWdp
bm5pbmcgb2YgcGFja2V0cyAoZm9yIG5vbi1jb21wbGlhbnQgZGV2aWNlcykgKi8NCiANCiAJdW5z
aWduZWQgaW50IHJ1bm5pbmc6IDE7CS8qIHJ1bm5pbmcgc3RhdHVzICovDQogDQpkaWZmIC0tZ2l0
IGEvc291bmQvdXNiL2VuZHBvaW50LmMgYi9zb3VuZC91c2IvZW5kcG9pbnQuYw0KaW5kZXggOWFi
MmIzZS4uNWViZThjNCAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi9lbmRwb2ludC5jDQorKysgYi9z
b3VuZC91c2IvZW5kcG9pbnQuYw0KQEAgLTQ1OCw3ICs0NTgsNyBAQCBzdGF0aWMgaW50IHJldGly
ZV9jYXB0dXJlX3VyYihzdHJ1Y3Qgc25kX3VzYl9zdWJzdHJlYW0gKnN1YnMsDQogCXN0cmlkZSA9
IHJ1bnRpbWUtPmZyYW1lX2JpdHMgPj4gMzsNCiANCiAJZm9yIChpID0gMDsgaSA8IHVyYi0+bnVt
YmVyX29mX3BhY2tldHM7IGkrKykgew0KLQkJY3AgPSAodW5zaWduZWQgY2hhciAqKXVyYi0+dHJh
bnNmZXJfYnVmZmVyICsgdXJiLT5pc29fZnJhbWVfZGVzY1tpXS5vZmZzZXQ7DQorCQljcCA9ICh1
bnNpZ25lZCBjaGFyICopdXJiLT50cmFuc2Zlcl9idWZmZXIgKyB1cmItPmlzb19mcmFtZV9kZXNj
W2ldLm9mZnNldCArIHN1YnMtPnBrdF9vZmZzZXRfYWRqOw0KIAkJaWYgKHVyYi0+aXNvX2ZyYW1l
X2Rlc2NbaV0uc3RhdHVzICYmIHByaW50a19yYXRlbGltaXQoKSkgew0KIAkJCXNuZF9wcmludGRk
KCJmcmFtZSAlZCBhY3RpdmU6ICVkXG4iLCBpLCB1cmItPmlzb19mcmFtZV9kZXNjW2ldLnN0YXR1
cyk7DQogCQkJLy8gY29udGludWU7DQpAQCAtODk4LDYgKzg5OCw3IEBAIHZvaWQgc25kX3VzYl9p
bml0X3N1YnN0cmVhbShzdHJ1Y3Qgc25kX3VzYl9zdHJlYW0gKmFzLA0KIAlzdWJzLT5zcGVlZCA9
IHNuZF91c2JfZ2V0X3NwZWVkKHN1YnMtPmRldik7DQogCWlmIChzdWJzLT5zcGVlZCA+PSBVU0Jf
U1BFRURfSElHSCkNCiAJCXN1YnMtPm9wcy5wcmVwYXJlX3N5bmMgPSBwcmVwYXJlX2NhcHR1cmVf
c3luY191cmJfaHM7DQorCXN1YnMtPnBrdF9vZmZzZXRfYWRqID0gMDsNCiANCiAJc25kX3VzYl9z
ZXRfcGNtX29wcyhhcy0+cGNtLCBzdHJlYW0pOw0KIA0KZGlmZiAtLWdpdCBhL3NvdW5kL3VzYi9t
aWRpLmMgYi9zb3VuZC91c2IvbWlkaS5jDQppbmRleCAzNGI5YmI3Li5lNWZlZTE4IDEwMDY0NA0K
LS0tIGEvc291bmQvdXNiL21pZGkuYw0KKysrIGIvc291bmQvdXNiL21pZGkuYw0KQEAgLTEyNiw3
ICsxMjYsNiBAQCBzdHJ1Y3Qgc25kX3VzYl9taWRpIHsNCiAJCXN0cnVjdCBzbmRfdXNiX21pZGlf
aW5fZW5kcG9pbnQgKmluOw0KIAl9IGVuZHBvaW50c1tNSURJX01BWF9FTkRQT0lOVFNdOw0KIAl1
bnNpZ25lZCBsb25nIGlucHV0X3RyaWdnZXJlZDsNCi0JYm9vbCBhdXRvcG1fcmVmZXJlbmNlOw0K
IAl1bnNpZ25lZCBpbnQgb3BlbmVkWzJdOw0KIAl1bnNpZ25lZCBjaGFyIGRpc2Nvbm5lY3RlZDsN
CiAJdW5zaWduZWQgY2hhciBpbnB1dF9ydW5uaW5nOw0KQEAgLTEwNDAsNyArMTAzOSw2IEBAIHN0
YXRpYyBpbnQgc3Vic3RyZWFtX29wZW4oc3RydWN0IHNuZF9yYXdtaWRpX3N1YnN0cmVhbSAqc3Vi
c3RyZWFtLCBpbnQgZGlyLA0KIHsNCiAJc3RydWN0IHNuZF91c2JfbWlkaSogdW1pZGkgPSBzdWJz
dHJlYW0tPnJtaWRpLT5wcml2YXRlX2RhdGE7DQogCXN0cnVjdCBzbmRfa2NvbnRyb2wgKmN0bDsN
Ci0JaW50IGVycjsNCiANCiAJZG93bl9yZWFkKCZ1bWlkaS0+ZGlzY19yd3NlbSk7DQogCWlmICh1
bWlkaS0+ZGlzY29ubmVjdGVkKSB7DQpAQCAtMTA1MSwxMyArMTA0OSw2IEBAIHN0YXRpYyBpbnQg
c3Vic3RyZWFtX29wZW4oc3RydWN0IHNuZF9yYXdtaWRpX3N1YnN0cmVhbSAqc3Vic3RyZWFtLCBp
bnQgZGlyLA0KIAltdXRleF9sb2NrKCZ1bWlkaS0+bXV0ZXgpOw0KIAlpZiAob3Blbikgew0KIAkJ
aWYgKCF1bWlkaS0+b3BlbmVkWzBdICYmICF1bWlkaS0+b3BlbmVkWzFdKSB7DQotCQkJZXJyID0g
dXNiX2F1dG9wbV9nZXRfaW50ZXJmYWNlKHVtaWRpLT5pZmFjZSk7DQotCQkJdW1pZGktPmF1dG9w
bV9yZWZlcmVuY2UgPSBlcnIgPj0gMDsNCi0JCQlpZiAoZXJyIDwgMCAmJiBlcnIgIT0gLUVBQ0NF
Uykgew0KLQkJCQltdXRleF91bmxvY2soJnVtaWRpLT5tdXRleCk7DQotCQkJCXVwX3JlYWQoJnVt
aWRpLT5kaXNjX3J3c2VtKTsNCi0JCQkJcmV0dXJuIC1FSU87DQotCQkJfQ0KIAkJCWlmICh1bWlk
aS0+cm9sYW5kX2xvYWRfY3RsKSB7DQogCQkJCWN0bCA9IHVtaWRpLT5yb2xhbmRfbG9hZF9jdGw7
DQogCQkJCWN0bC0+dmRbMF0uYWNjZXNzIHw9IFNORFJWX0NUTF9FTEVNX0FDQ0VTU19JTkFDVElW
RTsNCkBAIC0xMDgwLDggKzEwNzEsNiBAQCBzdGF0aWMgaW50IHN1YnN0cmVhbV9vcGVuKHN0cnVj
dCBzbmRfcmF3bWlkaV9zdWJzdHJlYW0gKnN1YnN0cmVhbSwgaW50IGRpciwNCiAJCQkJc25kX2N0
bF9ub3RpZnkodW1pZGktPmNhcmQsDQogCQkJCSAgICAgICBTTkRSVl9DVExfRVZFTlRfTUFTS19J
TkZPLCAmY3RsLT5pZCk7DQogCQkJfQ0KLQkJCWlmICh1bWlkaS0+YXV0b3BtX3JlZmVyZW5jZSkN
Ci0JCQkJdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNlKHVtaWRpLT5pZmFjZSk7DQogCQl9DQogCX0N
CiAJbXV0ZXhfdW5sb2NrKCZ1bWlkaS0+bXV0ZXgpOw0KQEAgLTIyNTYsNiArMjI0NSw4IEBAIGlu
dCBzbmRfdXNibWlkaV9jcmVhdGUoc3RydWN0IHNuZF9jYXJkICpjYXJkLA0KIAkJcmV0dXJuIGVy
cjsNCiAJfQ0KIA0KKwl1c2JfYXV0b3BtX2dldF9pbnRlcmZhY2Vfbm9fcmVzdW1lKHVtaWRpLT5p
ZmFjZSk7DQorDQogCWxpc3RfYWRkX3RhaWwoJnVtaWRpLT5saXN0LCBtaWRpX2xpc3QpOw0KIAly
ZXR1cm4gMDsNCiB9DQpkaWZmIC0tZ2l0IGEvc291bmQvdXNiL3F1aXJrcy5jIGIvc291bmQvdXNi
L3F1aXJrcy5jDQppbmRleCBkZmJkNjVkLi40MmVlZWU4IDEwMDY0NA0KLS0tIGEvc291bmQvdXNi
L3F1aXJrcy5jDQorKysgYi9zb3VuZC91c2IvcXVpcmtzLmMNCkBAIC03NDQsNiArNzQ0LDcgQEAg
c3RhdGljIHZvaWQgc2V0X2Zvcm1hdF9lbXVfcXVpcmsoc3RydWN0IHNuZF91c2Jfc3Vic3RyZWFt
ICpzdWJzLA0KIAkJYnJlYWs7DQogCX0NCiAJc25kX2VtdXVzYl9zZXRfc2FtcGxlcmF0ZShzdWJz
LT5zdHJlYW0tPmNoaXAsIGVtdV9zYW1wbGVyYXRlX2lkKTsNCisJc3Vicy0+cGt0X29mZnNldF9h
ZGogPSAoZW11X3NhbXBsZXJhdGVfaWQgPj0gRU1VX1FVSVJLX1NSXzE3NjQwMEhaKSA/IDQgOiAw
Ow0KIH0NCiANCiB2b2lkIHNuZF91c2Jfc2V0X2Zvcm1hdF9xdWlyayhzdHJ1Y3Qgc25kX3VzYl9z
dWJzdHJlYW0gKnN1YnMsDQpkaWZmIC0tZ2l0IGEvc291bmQvdXNiL3N0cmVhbS5jIGIvc291bmQv
dXNiL3N0cmVhbS5jDQppbmRleCA1ZmY4MDEwLi4zM2EzMzViIDEwMDY0NA0KLS0tIGEvc291bmQv
dXNiL3N0cmVhbS5jDQorKysgYi9zb3VuZC91c2Ivc3RyZWFtLmMNCkBAIC0xNjgsNiArMTY4LDE0
IEBAIHN0YXRpYyBpbnQgcGFyc2VfdWFjX2VuZHBvaW50X2F0dHJpYnV0ZXMoc3RydWN0IHNuZF91
c2JfYXVkaW8gKmNoaXAsDQogCWlmICghY3NlcCAmJiBhbHRzZC0+Yk51bUVuZHBvaW50cyA+PSAy
KQ0KIAkJY3NlcCA9IHNuZF91c2JfZmluZF9kZXNjKGFsdHMtPmVuZHBvaW50WzFdLmV4dHJhLCBh
bHRzLT5lbmRwb2ludFsxXS5leHRyYWxlbiwgTlVMTCwgVVNCX0RUX0NTX0VORFBPSU5UKTsNCiAN
CisJLyoNCisJICogSWYgd2UgY2FuJ3QgbG9jYXRlIHRoZSBVU0JfRFRfQ1NfRU5EUE9JTlQgZGVz
Y3JpcHRvciBpbiB0aGUgZXh0cmENCisJICogYnl0ZXMgYWZ0ZXIgdGhlIGZpcnN0IGVuZHBvaW50
LCBnbyBzZWFyY2ggdGhlIGVudGlyZSBpbnRlcmZhY2UuDQorCSAqIFNvbWUgZGV2aWNlcyBoYXZl
IGl0IGRpcmVjdGx5ICpiZWZvcmUqIHRoZSBzdGFuZGFyZCBlbmRwb2ludC4NCisJICovDQorCWlm
ICghY3NlcCkNCisJCWNzZXAgPSBzbmRfdXNiX2ZpbmRfZGVzYyhhbHRzLT5leHRyYSwgYWx0cy0+
ZXh0cmFsZW4sIE5VTEwsIFVTQl9EVF9DU19FTkRQT0lOVCk7DQorDQogCWlmICghY3NlcCB8fCBj
c2VwLT5iTGVuZ3RoIDwgNyB8fA0KIAkgICAgY3NlcC0+YkRlc2NyaXB0b3JTdWJ0eXBlICE9IFVB
Q19FUF9HRU5FUkFMKSB7DQogCQlzbmRfcHJpbnRrKEtFUk5fV0FSTklORyAiJWQ6JXU6JWQgOiBu
byBvciBpbnZhbGlkIg0K


--=-syv4yOKw9/zvqFhpOW11--

--=-Rs2jQyV5GZwkj5Z2nOfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUZI0JOe/yOyVhhEJAQqm5Q//dX2CbNq7joTKWdadI2/6p+U3u18aBCXa
UIeebGOsozBcmvQ4iZZJ4yCbrVC1EnFkH89dvQR9lwSS/WRdhy646cdBqr2i9TLW
MDfKj/5TcCbU713gxm5i9GG4SrAcNv1ReMadU+bkn7z+FQswpdsS1jHQppdbvtNu
yKaHbCHf06/URgiYfjQC2XvxWci/YAdCQJIDyd0ZR/cJuCUiifoKqtpi2+5l9kXS
54qtaPOOTT2qhQbMvMTyKDQ1qDZdlD0CwfEVYH4OBNhEfYF/3kZyCzIkJJVd/Vt7
sIvzk0vGcyWHmYIe+PfMg+eImvuJPUW3qiARYw0WtEr9+SSByGSv2jBLKDfO2LEK
J383vGyQk4n0cMtzyzhsZ9Rccjxqfq+0MaHl29BR1TIUQ/yP+k1g3EGtp+ypoTzn
NwZXGIsVMkHd0yppoluAHB+6kijyUWLRSwANuX+f8t0GgM5PK9Kf7Lqrn9JXnW2s
AO6lngWSX5ALfUmdPALSIg8X8773Dlenz7UYPrsv2DXC1qOlO8Tal1NBF7IIvctP
K3Mm852d6vkB3H9bdQS/4WgW79ga5szrq0xBGWqyMvWrq4+oFaEkeUHwazIbJSW9
wQK4gP2oUhD8E7jdb4mbgr6SeuKjvTvZB6d8b6vj+eocqN3bRU0EXA09Kj7DWeOG
557GCdC9xs4=
=hmzH
-----END PGP SIGNATURE-----

--=-Rs2jQyV5GZwkj5Z2nOfU--
