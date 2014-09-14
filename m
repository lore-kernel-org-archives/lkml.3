Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaINLfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 07:35:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36955 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbaINLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 07:34:46 -0400
Message-ID: <1410694475.3040.32.camel@decadent.org.uk>
Subject: Linux 3.2.63
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sun, 14 Sep 2014 12:34:35 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cKSaeqx0WU94BgbCqflu"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9881:80b9:b90a:1609
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cKSaeqx0WU94BgbCqflu
Content-Type: multipart/mixed; boundary="=-kcpNMI1odd/lAg3PnSWX"


--=-kcpNMI1odd/lAg3PnSWX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.63 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.62 is attached to this message.

Ben.

------------

 Documentation/sound/alsa/ALSA-Configuration.txt |   4 +-
 Documentation/stable_kernel_rules.txt           |   3 +
 Documentation/x86/x86_64/mm.txt                 |   2 +
 Makefile                                        |   4 +-
 arch/arm/kernel/entry-header.S                  |  29 ++--
 arch/arm/mach-omap2/control.c                   |   3 +-
 arch/arm/mm/abort-ev6.S                         |   6 -
 arch/arm/mm/abort-ev7.S                         |   6 -
 arch/microblaze/boot/Makefile                   |   2 +-
 arch/mips/cavium-octeon/setup.c                 |  18 +-
 arch/mips/kernel/irq-gic.c                      |   6 +-
 arch/mips/kernel/perf_event_mipsxx.c            |   5 -
 arch/mips/kernel/ptrace.c                       |   3 +-
 arch/mips/mm/c-r4k.c                            |   5 +
 arch/mips/mm/tlbex.c                            |   1 +
 arch/openrisc/kernel/head.S                     |   1 +
 arch/openrisc/kernel/init_task.c                |   1 +
 arch/openrisc/kernel/irq.c                      |   1 +
 arch/powerpc/include/asm/pte-hash64-64k.h       |  32 +++-
 arch/powerpc/kernel/pci-common.c                |   5 +-
 arch/powerpc/mm/init_64.c                       |   3 +-
 arch/powerpc/mm/numa.c                          |   2 +-
 arch/s390/Kconfig                               |   1 +
 arch/sparc/include/asm/Kbuild                   |   1 +
 arch/sparc/include/asm/pgtable_64.h             |   6 +-
 arch/sparc/include/asm/tlbflush_64.h            |  12 +-
 arch/sparc/include/asm/types.h                  |  23 ---
 arch/sparc/kernel/ldc.c                         |   2 +-
 arch/sparc/kernel/smp_64.c                      |   6 +-
 arch/sparc/kernel/sys32.S                       |   2 +-
 arch/sparc/kernel/unaligned_64.c                |  12 +-
 arch/sparc/lib/NG2memcpy.S                      |   1 +
 arch/sparc/math-emu/math_32.c                   |   2 +-
 arch/sparc/mm/fault_64.c                        | 102 ++++++------
 arch/sparc/mm/init_64.c                         |  27 +++
 arch/sparc/mm/tsb.c                             |  14 +-
 arch/x86/Kconfig                                |  25 ++-
 arch/x86/include/asm/espfix.h                   |  16 ++
 arch/x86/include/asm/irqflags.h                 |   2 +-
 arch/x86/include/asm/pgtable_64_types.h         |   2 +
 arch/x86/include/asm/setup.h                    |   2 +
 arch/x86/kernel/Makefile                        |   1 +
 arch/x86/kernel/entry_32.S                      |  12 ++
 arch/x86/kernel/entry_64.S                      |  80 ++++++++-
 arch/x86/kernel/espfix_64.c                     | 208 ++++++++++++++++++++=
++++
 arch/x86/kernel/ldt.c                           |  10 +-
 arch/x86/kernel/paravirt_patch_64.c             |   2 -
 arch/x86/kernel/resource.c                      |   8 +-
 arch/x86/kernel/smpboot.c                       |   7 +
 arch/x86/kvm/emulate.c                          |   4 +
 arch/x86/mm/dump_pagetables.c                   |  39 +++--
 arch/x86/pci/i386.c                             |   4 +
 arch/x86/vdso/vdso32-setup.c                    |   8 -
 arch/x86/xen/time.c                             |   2 +-
 block/blk-tag.c                                 |  33 +---
 crypto/af_alg.c                                 |   2 +
 drivers/acpi/ec.c                               |  17 +-
 drivers/ata/ahci.c                              |   1 +
 drivers/ata/pata_scc.c                          |  15 +-
 drivers/char/tpm/tpm.c                          |  62 ++++---
 drivers/char/tpm/tpm.h                          |   3 +
 drivers/char/tpm/tpm_tis.c                      |  31 ++++
 drivers/gpu/drm/radeon/evergreen.c              |   1 +
 drivers/gpu/drm/radeon/r600.c                   |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   4 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |  13 +-
 drivers/hid/hid-cherry.c                        |   2 +-
 drivers/hid/hid-kye.c                           |   2 +-
 drivers/hid/hid-lg.c                            |   4 +-
 drivers/hid/hid-logitech-dj.c                   |  54 +++---
 drivers/hid/hid-logitech-dj.h                   |   1 +
 drivers/hid/hid-magicmouse.c                    |  10 ++
 drivers/hid/hid-monterey.c                      |   2 +-
 drivers/hid/hid-petalynx.c                      |   2 +-
 drivers/hid/hid-picolcd.c                       |   6 +
 drivers/hid/hid-sunplus.c                       |   2 +-
 drivers/hwmon/ads1015.c                         |   4 +-
 drivers/hwmon/amc6821.c                         |  17 +-
 drivers/hwmon/gpio-fan.c                        |   2 +-
 drivers/hwmon/lm78.c                            |   2 +-
 drivers/hwmon/lm85.c                            |  14 +-
 drivers/hwmon/lm92.c                            |  13 +-
 drivers/hwmon/sis5595.c                         |   2 +-
 drivers/hwmon/smsc47m192.c                      |  10 +-
 drivers/infiniband/core/iwcm.c                  |  34 ++++
 drivers/iommu/amd_iommu.c                       |  10 +-
 drivers/iommu/intel-iommu.c                     |  40 +++--
 drivers/md/raid1.c                              |   8 +-
 drivers/md/raid10.c                             |   8 +-
 drivers/md/raid5.c                              |   2 +
 drivers/media/dvb/frontends/tda10071.c          |   6 +-
 drivers/media/video/gspca/pac7302.c             |   1 +
 drivers/mtd/ftl.c                               |   1 -
 drivers/net/macvlan.c                           |   1 +
 drivers/net/ppp/pptp.c                          |   2 +-
 drivers/net/wireless/ath/carl9170/carl9170.h    |   1 +
 drivers/net/wireless/ath/carl9170/usb.c         |  31 +++-
 drivers/sbus/char/bbc_envctrl.c                 |   6 +
 drivers/sbus/char/bbc_i2c.c                     |  11 +-
 drivers/scsi/bfa/bfa_ioc.h                      |   2 +-
 drivers/scsi/hpsa.c                             |   2 +-
 drivers/scsi/scsi_lib.c                         |   8 +
 drivers/staging/hv/storvsc_drv.c                |  12 ++
 drivers/staging/vt6655/bssdb.c                  |   2 +-
 drivers/staging/vt6655/device_main.c            |   7 +-
 drivers/tty/serial/serial_core.c                |   3 +
 drivers/tty/serial/sunsab.c                     |   9 +
 drivers/usb/core/hub.c                          |  45 ++++-
 drivers/usb/host/ohci-q.c                       |  46 ++++--
 drivers/usb/host/xhci-pci.c                     |   4 +
 drivers/usb/host/xhci-ring.c                    |  79 ++++-----
 drivers/usb/host/xhci.c                         |   3 +
 drivers/usb/misc/sisusbvga/sisusb.c             |   1 +
 drivers/usb/serial/ftdi_sio.c                   |   5 +
 drivers/usb/serial/ftdi_sio_ids.h               |  20 ++-
 drivers/usb/serial/option.c                     |   5 +
 drivers/usb/serial/pl2303.c                     |   1 +
 drivers/usb/serial/pl2303.h                     |   1 +
 drivers/usb/serial/usb-serial.c                 |  37 +++--
 drivers/usb/serial/whiteheat.c                  |   7 +-
 fs/btrfs/file-item.c                            |   2 +-
 fs/cifs/inode.c                                 |   6 +
 fs/debugfs/inode.c                              |  34 +++-
 fs/ext4/mballoc.c                               |  25 ++-
 fs/isofs/inode.c                                |  15 +-
 fs/isofs/isofs.h                                |  23 ++-
 fs/isofs/rock.c                                 |  39 +++--
 fs/namespace.c                                  |   8 +
 fs/nfs/nfs4proc.c                               |  17 +-
 fs/reiserfs/journal.c                           |  21 ++-
 include/linux/mempolicy.h                       |   2 +-
 include/linux/mount.h                           |   1 +
 include/net/inetpeer.h                          |  14 +-
 include/net/ip.h                                |  31 ++--
 include/net/ipip.h                              |   2 +-
 include/net/ipv6.h                              |   9 +-
 include/net/netlabel.h                          |   8 +-
 include/net/secure_seq.h                        |   2 -
 init/main.c                                     |   4 +
 kernel/trace/ring_buffer.c                      |  29 ++--
 mm/mempolicy.c                                  |   8 +-
 mm/page_alloc.c                                 |  16 +-
 mm/slab.c                                       |   4 +-
 mm/slub.c                                       |   2 +-
 net/bluetooth/l2cap_sock.c                      |   3 +-
 net/bluetooth/rfcomm/sock.c                     |   3 +-
 net/bluetooth/sco.c                             |   6 +-
 net/compat.c                                    |   9 +-
 net/core/iovec.c                                |  10 +-
 net/core/secure_seq.c                           |  23 ---
 net/ipv4/cipso_ipv4.c                           |   6 +-
 net/ipv4/igmp.c                                 |   4 +-
 net/ipv4/inetpeer.c                             |  18 --
 net/ipv4/ip_output.c                            |   7 +-
 net/ipv4/ipmr.c                                 |   2 +-
 net/ipv4/raw.c                                  |   2 +-
 net/ipv4/route.c                                |  78 +++++----
 net/ipv4/tcp_vegas.c                            |   3 +-
 net/ipv4/tcp_veno.c                             |   2 +-
 net/ipv4/xfrm4_mode_tunnel.c                    |   2 +-
 net/ipv6/ip6_output.c                           |  25 ++-
 net/netfilter/ipvs/ip_vs_xmit.c                 |   2 +-
 net/netlabel/netlabel_kapi.c                    |  26 ++-
 net/sctp/associola.c                            |   1 +
 net/sctp/output.c                               |   2 +-
 security/smack/smack_lsm.c                      |   2 +-
 sound/pci/Kconfig                               |   4 +-
 sound/pci/hda/patch_realtek.c                   |  17 +-
 sound/pci/oxygen/virtuoso.c                     |   2 +
 sound/pci/oxygen/xonar_pcm179x.c                |  12 +-
 sound/pci/oxygen/xonar_wm87x6.c                 |   6 +-
 sound/soc/pxa/pxa-ssp.c                         |   4 +-
 sound/soc/samsung/i2s.c                         |  16 +-
 virt/kvm/iommu.c                                |  19 ++-
 174 files changed, 1530 insertions(+), 686 deletions(-)

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Alan Stern (1):
      USB: OHCI: don't lose track of EDs when a controller dies

Alex Deucher (1):
      drm/radeon: load the lm63 driver for an lm64 thermal chip.

Alex Williamson (1):
      iommu/vt-d: Exclude devices using RMRRs from IOMMU API domains

Andi Kleen (1):
      slab/mempolicy: always use local policy from interrupt context

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference

Andrey Utkin (2):
      powerpc/mm/numa: Fix break placement
      arch/sparc/math-emu/math_32.c: drop stray break operator

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Aneesh Kumar K.V (2):
      powerpc: Fix build errors STRICT_MM_TYPECHECKS
      powerpc/mm: Use read barrier when creating real_pte

Antti Palosaari (1):
      tda10071: force modulation to QPSK on DVB-S

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset

Axel Lin (6):
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
      hwmon: (amc6821) Fix possible race condition bug
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
      hwmon: (sis5595) Prevent overflow problem when writing large limits
      hwmon: (lm92) Prevent overflow problem when writing large limits
      hwmon: (ads1015) Fix out-of-bounds array access

Ben Hutchings (2):
      bfa: Fix undefined bit shift on big-endian architectures with 32-bit =
DMA address
      Linux 3.2.63

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Christian Borntraeger (1):
      s390/locking: Reenable optimistic spinning

Christian K=C3=B6nig (1):
      drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Christoph Paasch (2):
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christoph Schulz (1):
      x86: don't exclude low BIOS area when allocating address space for no=
n-PCI cards

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

Clemens Ladisch (1):
      ALSA: virtuoso: add Xonar Essence STX II support

Dan Carpenter (1):
      netlabel: use GFP flags from caller instead of GFP_ATOMIC

Daniel Borkmann (1):
      net: sctp: inherit auth_capable on INIT collisions

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

David S. Miller (8):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fa=
ult addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

David Vrabel (1):
      x86/xen: resume timer irqs early

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Eric W. Biederman (1):
      mnt: Change the default remount atime from relatime to the existing v=
alue

Filipe Manana (1):
      Btrfs: fix csum tree corruption, duplicate and outdated checksums

Florian Fainelli (1):
      MIPS: perf: Fix build error caused by unused counters_per_cpu_to_tota=
l()

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Guenter Roeck (3):
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations
      hwmon: (lm85) Fix various errors on attribute writes
      hwmon: (lm78) Fix overflow problems seen when writing large temperatu=
re limits

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtim=
e option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit sta=
ck
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

Hans de Goede (2):
      gspca_pac7302: Add new usb-id for Genius i-Look 317
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_S=
TOP_INVAL

Huacai Chen (1):
      MIPS: tlbex: Fix a missing statement for HUGETLB

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

James Bottomley (1):
      scsi: handle flush errors properly

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Kara (2):
      reiserfs: Fix use after free in journal teardown
      isofs: Fix unbounded recursion when processing relocated directories

Jason Gunthorpe (1):
      tpm: Provide a generic means to override the chip returned timeouts

Ja=C5=A1a Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device

Jeffrey Deans (1):
      MIPS: GIC: Prevent array overrun

Jeremy Vial (1):
      ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.=
1.2 case.

Jiri Kosina (4):
      HID: logitech: perform bounds checking on device_id early enough
      HID: fix a couple of off-by-ones
      HID: magicmouse: sanity check report size in raw_event() callback
      HID: picolcd: sanity check report size in raw_event() callback

Joerg Roedel (1):
      iommu/amd: Fix cleanup_domain for mass device removal

Johan Hovold (3):
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow

Jonas Bonn (1):
      openrisc: include export.h for EXPORT_SYMBOL

K. Y. Srinivasan (1):
      Drivers: scsi: storvsc: Implement a eh_timed_out handler

Kevin Hao (1):
      mtd/ftl: fix the double free of the buffers allocated in build_maps()

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Lv Zheng (1):
      ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT is=
n't set

Malcolm Priestley (2):
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
      staging: vt6655: Fix disassociated messages every 10 seconds

Mark Rutland (2):
      ARM: 8128/1: abort: don't clear the exclusive monitors
      ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using dumm=
y strex

Mathias Nyman (1):
      xhci: rework cycle bit checking for new dequeue pointers

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-=
3601)

Michal Simek (1):
      microblaze: Fix makefile to work with latest toolchain

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Nadav Amit (1):
      KVM: x86: Inter-privilege level ret emulation is not implemeneted

NeilBrown (2):
      md/raid1,raid10: always abort recover on write error.
      md/raid6: avoid data corruption during recovery of double-degraded RA=
ID6

Oliver Neukum (1):
      usbcore: don't log on consecutive debounce failures of the same port

Patrick Riphagen (2):
      USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
      USB: serial: ftdi_sio: Add support for new Xsens devices

Paul Burton (1):
      MIPS: Prevent user from setting FCSR cause bits

Paul Moore (1):
      netlabel: fix a problem when setting bits below the previously lowest=
 bit

Pavel Shilovsky (1):
      CIFS: Fix wrong directory attributes after rename

Peter Hurley (1):
      serial: core: Preserve termios c_cflag for console resume

Pratyush Anand (1):
      USB: Fix persist resume of some SS USB devices

Ralf Baechle (1):
      MIPS: Fix accessing to per-cpu data when flushing the cache

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode=
)

Ronald Wahl (1):
      carl9170: fix sending URBs with wrong type when using full-speed

Sachin Kamat (1):
      hwmon: (amc6821) Fix return value

Sam Ravnborg (1):
      sparc: use asm-generic version of types.h

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiov=
ecend

Sergiu Giurgiu (1):
      ALSA: virtuoso: Xonar DSX support

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in =
progress.

Stefan Kristiansson (1):
      openrisc: add missing header inclusion

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Stephen M. Cameron (1):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Steve Wise (1):
      RDMA/iwcm: Use a default listen backlog if needed

Steven Rostedt (1):
      debugfs: Fix corrupted loop in debugfs_remove_recursive

Steven Rostedt (Red Hat) (2):
      ring-buffer: Up rb_iter_peek() loop count to 3
      ring-buffer: Always reset iterator to reader page

Sylwester Nawrocki (1):
      ASoC: samsung: Correct I2S DAI suspend/resume ops

Takashi Iwai (1):
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co

Tetsuo Handa (1):
      drm/ttm: Fix possible stack overflow by recursive shrinker calls.

Theodore Ts'o (1):
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa=
 struct

Trond Myklebust (1):
      NFSv4: Fix problems with close in the presence of a delegation

Vlad Yasevich (1):
      macvlan: Initialize vlan_features to turn on offload support.

Vladimir Davydov (1):
      Bluetooth: never linger on process exit

Zheng Liu (1):
      ext4: cleanup in ext4_discard_allocated_blocks()


--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-kcpNMI1odd/lAg3PnSWX
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.63.patch"
Content-Disposition: attachment; filename="linux-3.2.63.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentatio=
n/sound/alsa/ALSA-Configuration.txt
index 936699e..15806ef 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -2018,8 +2018,8 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix=
. This was removed.
   -------------------
=20
     Module for sound cards based on the Asus AV66/AV100/AV200 chips,
-    i.e., Xonar D1, DX, D2, D2X, DS, Essence ST (Deluxe), Essence STX,
-    HDAV1.3 (Deluxe), and HDAV1.3 Slim.
+    i.e., Xonar D1, DX, D2, D2X, DS, DSX, Essence ST (Deluxe),
+    Essence STX (II), HDAV1.3 (Deluxe), and HDAV1.3 Slim.
=20
     This module supports autoprobe and multiple cards.
=20
diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_k=
ernel_rules.txt
index 22bf11b..53feeac 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -29,6 +29,9 @@ Rules on what kind of patches are accepted, and which one=
s are not, into the
=20
 Procedure for submitting patches to the -stable tree:
=20
+ - If the patch covers files in net/ or drivers/net please follow netdev s=
table
+   submission guidelines as described in
+   Documentation/networking/netdev-FAQ.txt
  - Send the patch, after verifying that it follows the above rules, to
    stable@vger.kernel.org.  You must note the upstream commit ID in the
    changelog of your submission.
diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.=
txt
index d6498e3..f33a936 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -12,6 +12,8 @@ ffffc90000000000 - ffffe8ffffffffff (=3D45 bits) vmalloc/=
ioremap space
 ffffe90000000000 - ffffe9ffffffffff (=3D40 bits) hole
 ffffea0000000000 - ffffeaffffffffff (=3D40 bits) virtual memory map (1TB)
 ... unused hole ...
+ffffff0000000000 - ffffff7fffffffff (=3D39 bits) %esp fixup stacks
+... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=3D512 MB)  kernel text mapping, from=
 phys 0
 ffffffffa0000000 - fffffffffff00000 (=3D1536 MB) module mapping space
=20
diff --git a/Makefile b/Makefile
index 30a5c65..6d3f2d4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 62
+SUBLEVEL =3D 63
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
@@ -592,6 +592,8 @@ KBUILD_CFLAGS	+=3D -fomit-frame-pointer
 endif
 endif
=20
+KBUILD_CFLAGS   +=3D $(call cc-option, -fno-var-tracking-assignments)
+
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+=3D -g
 KBUILD_AFLAGS	+=3D -gdwarf-2
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.=
S
index 9a8531e..9d95a46 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -76,26 +76,21 @@
 #ifndef CONFIG_THUMB2_KERNEL
 	.macro	svc_exit, rpsr
 	msr	spsr_cxsf, \rpsr
-#if defined(CONFIG_CPU_V6)
-	ldr	r0, [sp]
-	strex	r1, r2, [sp]			@ clear the exclusive monitor
-	ldmib	sp, {r1 - pc}^			@ load r1 - pc, cpsr
-#elif defined(CONFIG_CPU_32v6K)
-	clrex					@ clear the exclusive monitor
-	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
-#else
-	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_32v6K)
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
+	sub	r0, sp, #4			@ uninhabited address
+	strex	r1, r2, [r0]			@ clear the exclusive monitor
 #endif
+	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
 	.endm
=20
 	.macro	restore_user_regs, fast =3D 0, offset =3D 0
 	ldr	r1, [sp, #\offset + S_PSR]	@ get calling cpsr
 	ldr	lr, [sp, #\offset + S_PC]!	@ get pc
 	msr	spsr_cxsf, r1			@ save in spsr_svc
-#if defined(CONFIG_CPU_V6)
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_32v6K)
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
 	strex	r1, r2, [sp]			@ clear the exclusive monitor
-#elif defined(CONFIG_CPU_32v6K)
-	clrex					@ clear the exclusive monitor
 #endif
 	.if	\fast
 	ldmdb	sp, {r1 - lr}^			@ get calling r1 - lr
@@ -123,7 +118,10 @@
 	.macro	svc_exit, rpsr
 	ldr	lr, [sp, #S_SP]			@ top of the stack
 	ldrd	r0, r1, [sp, #S_LR]		@ calling lr and pc
-	clrex					@ clear the exclusive monitor
+
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
+	strex	r2, r1, [sp, #S_LR]		@ clear the exclusive monitor
+
 	stmdb	lr!, {r0, r1, \rpsr}		@ calling lr and rfe context
 	ldmia	sp, {r0 - r12}
 	mov	sp, lr
@@ -132,13 +130,16 @@
 	.endm
=20
 	.macro	restore_user_regs, fast =3D 0, offset =3D 0
-	clrex					@ clear the exclusive monitor
 	mov	r2, sp
 	load_user_sp_lr r2, r3, \offset + S_SP	@ calling sp, lr
 	ldr	r1, [sp, #\offset + S_PSR]	@ get calling cpsr
 	ldr	lr, [sp, #\offset + S_PC]	@ get pc
 	add	sp, sp, #\offset + S_SP
 	msr	spsr_cxsf, r1			@ save in spsr_svc
+
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
+	strex	r1, r2, [sp]			@ clear the exclusive monitor
+
 	.if	\fast
 	ldmdb	sp, {r1 - r12}			@ get calling r1 - r12
 	.else
diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index e34d27f..724f823 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -282,7 +282,8 @@ void omap3_save_scratchpad_contents(void)
 		scratchpad_contents.public_restore_ptr =3D
 			virt_to_phys(omap3_restore_3630);
 	else if (omap_rev() !=3D OMAP3430_REV_ES3_0 &&
-					omap_rev() !=3D OMAP3430_REV_ES3_1)
+					omap_rev() !=3D OMAP3430_REV_ES3_1 &&
+					omap_rev() !=3D OMAP3430_REV_ES3_1_2)
 		scratchpad_contents.public_restore_ptr =3D
 			virt_to_phys(omap3_restore);
 	else
diff --git a/arch/arm/mm/abort-ev6.S b/arch/arm/mm/abort-ev6.S
index 8074199..5d777a5 100644
--- a/arch/arm/mm/abort-ev6.S
+++ b/arch/arm/mm/abort-ev6.S
@@ -17,12 +17,6 @@
  */
 	.align	5
 ENTRY(v6_early_abort)
-#ifdef CONFIG_CPU_V6
-	sub	r1, sp, #4			@ Get unused stack location
-	strex	r0, r1, [r1]			@ Clear the exclusive monitor
-#elif defined(CONFIG_CPU_32v6K)
-	clrex
-#endif
 	mrc	p15, 0, r1, c5, c0, 0		@ get FSR
 	mrc	p15, 0, r0, c6, c0, 0		@ get FAR
 /*
diff --git a/arch/arm/mm/abort-ev7.S b/arch/arm/mm/abort-ev7.S
index 7033752..4812ad0 100644
--- a/arch/arm/mm/abort-ev7.S
+++ b/arch/arm/mm/abort-ev7.S
@@ -13,12 +13,6 @@
  */
 	.align	5
 ENTRY(v7_early_abort)
-	/*
-	 * The effect of data aborts on on the exclusive access monitor are
-	 * UNPREDICTABLE. Do a CLREX to clear the state
-	 */
-	clrex
-
 	mrc	p15, 0, r1, c5, c0, 0		@ get FSR
 	mrc	p15, 0, r0, c6, c0, 0		@ get FAR
=20
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 4c4e58e..5365519 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -8,7 +8,7 @@ obj-y +=3D linked_dtb.o
=20
 targets :=3D linux.bin linux.bin.gz simpleImage.%
=20
-OBJCOPYFLAGS :=3D -O binary
+OBJCOPYFLAGS :=3D -R .note -R .comment -R .note.gnu.build-id -O binary
=20
 # Ensure system.dtb exists
 $(obj)/linked_dtb.o: $(obj)/system.dtb
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setu=
p.c
index 2d9028f..3c5f61c 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -266,6 +266,18 @@ static irqreturn_t octeon_rlm_interrupt(int cpl, void =
*dev_id)
 }
 #endif
=20
+static char __read_mostly octeon_system_type[80];
+
+static int __init init_octeon_system_type(void)
+{
+	snprintf(octeon_system_type, sizeof(octeon_system_type), "%s (%s)",
+		cvmx_board_type_to_string(octeon_bootinfo->board_type),
+		octeon_model_get_string(read_c0_prid()));
+
+	return 0;
+}
+early_initcall(init_octeon_system_type);
+
 /**
  * Return a string representing the system type
  *
@@ -273,11 +285,7 @@ static irqreturn_t octeon_rlm_interrupt(int cpl, void =
*dev_id)
  */
 const char *octeon_board_type_string(void)
 {
-	static char name[80];
-	sprintf(name, "%s (%s)",
-		cvmx_board_type_to_string(octeon_bootinfo->board_type),
-		octeon_model_get_string(read_c0_prid()));
-	return name;
+	return octeon_system_type;
 }
=20
 const char *get_system_type(void)
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 0c527f6..e132bfd 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -166,11 +166,13 @@ static void __init gic_setup_intr(unsigned int intr, =
unsigned int cpu,
 {
 	/* Setup Intr to Pin mapping */
 	if (pin & GIC_MAP_TO_NMI_MSK) {
+		int i;
+
 		GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(intr)), pin);
 		/* FIXME: hack to route NMI to all cpu's */
-		for (cpu =3D 0; cpu < NR_CPUS; cpu +=3D 32) {
+		for (i =3D 0; i < NR_CPUS; i +=3D 32) {
 			GICWRITE(GIC_REG_ADDR(SHARED,
-					  GIC_SH_MAP_TO_VPE_REG_OFF(intr, cpu)),
+					  GIC_SH_MAP_TO_VPE_REG_OFF(intr, i)),
 				 0xffffffff);
 		}
 	} else {
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_e=
vent_mipsxx.c
index 315fc0b..dc6ffe0 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -162,11 +162,6 @@ static unsigned int counters_total_to_per_cpu(unsigned=
 int counters)
 	return counters >> vpe_shift();
 }
=20
-static unsigned int counters_per_cpu_to_total(unsigned int counters)
-{
-	return counters << vpe_shift();
-}
-
 #else /* !CONFIG_MIPS_MT_SMP */
 #define vpe_id()	0
=20
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 4e6ea1f..e56c692 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -162,6 +162,7 @@ int ptrace_setfpregs(struct task_struct *child, __u32 _=
_user *data)
 		__get_user(fregs[i], i + (__u64 __user *) data);
=20
 	__get_user(child->thread.fpu.fcr31, data + 64);
+	child->thread.fpu.fcr31 &=3D ~FPU_CSR_ALL_X;
=20
 	/* FIR may not be written.  */
=20
@@ -452,7 +453,7 @@ long arch_ptrace(struct task_struct *child, long reques=
t,
 			break;
 #endif
 		case FPC_CSR:
-			child->thread.fpu.fcr31 =3D data;
+			child->thread.fpu.fcr31 =3D data & ~FPU_CSR_ALL_X;
 			break;
 		case DSP_BASE ... DSP_BASE + 5: {
 			dspreg_t *dregs;
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 7d5ac0b..fe425bb 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -12,6 +12,7 @@
 #include <linux/highmem.h>
 #include <linux/kernel.h>
 #include <linux/linkage.h>
+#include <linux/preempt.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
@@ -599,6 +600,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr,=
 unsigned long size)
 	/* Catch bad driver code */
 	BUG_ON(size =3D=3D 0);
=20
+	preempt_disable();
 	if (cpu_has_inclusive_pcaches) {
 		if (size >=3D scache_size)
 			r4k_blast_scache();
@@ -619,6 +621,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr,=
 unsigned long size)
 		R4600_HIT_CACHEOP_WAR_IMPL;
 		blast_dcache_range(addr, addr + size);
 	}
+	preempt_enable();
=20
 	bc_wback_inv(addr, size);
 	__sync();
@@ -629,6 +632,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsig=
ned long size)
 	/* Catch bad driver code */
 	BUG_ON(size =3D=3D 0);
=20
+	preempt_disable();
 	if (cpu_has_inclusive_pcaches) {
 		if (size >=3D scache_size)
 			r4k_blast_scache();
@@ -653,6 +657,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsig=
ned long size)
 		R4600_HIT_CACHEOP_WAR_IMPL;
 		blast_inv_dcache_range(addr, addr + size);
 	}
+	preempt_enable();
=20
 	bc_inv(addr, size);
 	__sync();
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index e06370f..3ee768e 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1282,6 +1282,7 @@ static void __cpuinit build_r4000_tlb_refill_handler(=
void)
 	}
 #ifdef CONFIG_HUGETLB_PAGE
 	uasm_l_tlb_huge_update(&l, p);
+	UASM_i_LW(&p, K0, 0, K1);
 	build_huge_update_entries(&p, htlb_info.huge_pte, K1);
 	build_huge_tlb_write_entry(&p, &l, &r, K0, tlb_random,
 				   htlb_info.restore_scratch);
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index c75018d..23a3019 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -19,6 +19,7 @@
 #include <linux/threads.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/serial_reg.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
diff --git a/arch/openrisc/kernel/init_task.c b/arch/openrisc/kernel/init_t=
ask.c
index 45744a38..ca53408 100644
--- a/arch/openrisc/kernel/init_task.c
+++ b/arch/openrisc/kernel/init_task.c
@@ -17,6 +17,7 @@
=20
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/export.h>
=20
 static struct signal_struct init_signals =3D INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand =3D INIT_SIGHAND(init_sighand);
diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 59b3023..4bfead2 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -23,6 +23,7 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/kernel_stat.h>
+#include <linux/export.h>
=20
 #include <linux/irqflags.h>
=20
diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/inclu=
de/asm/pte-hash64-64k.h
index 59247e8..4ac50bb 100644
--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -40,17 +40,39 @@
=20
 #ifndef __ASSEMBLY__
=20
+#include <asm/system.h> /* for smp_rmb() */
+
 /*
  * With 64K pages on hash table, we have a special PTE format that
  * uses a second "half" of the page table to encode sub-page information
  * in order to deal with 64K made of 4K HW pages. Thus we override the
  * generic accessors and iterators here
  */
-#define __real_pte(e,p) 	((real_pte_t) { \
-			(e), ((e) & _PAGE_COMBO) ? \
-				(pte_val(*((p) + PTRS_PER_PTE))) : 0 })
-#define __rpte_to_hidx(r,index)	((pte_val((r).pte) & _PAGE_COMBO) ? \
-        (((r).hidx >> ((index)<<2)) & 0xf) : ((pte_val((r).pte) >> 12) & 0=
xf))
+#define __real_pte __real_pte
+static inline real_pte_t __real_pte(pte_t pte, pte_t *ptep)
+{
+	real_pte_t rpte;
+
+	rpte.pte =3D pte;
+	rpte.hidx =3D 0;
+	if (pte_val(pte) & _PAGE_COMBO) {
+		/*
+		 * Make sure we order the hidx load against the _PAGE_COMBO
+		 * check. The store side ordering is done in __hash_page_4K
+		 */
+		smp_rmb();
+		rpte.hidx =3D pte_val(*((ptep) + PTRS_PER_PTE));
+	}
+	return rpte;
+}
+
+static inline unsigned long __rpte_to_hidx(real_pte_t rpte, unsigned long =
index)
+{
+	if ((pte_val(rpte.pte) & _PAGE_COMBO))
+		return (rpte.hidx >> (index<<2)) & 0xf;
+	return (pte_val(rpte.pte) >> 12) & 0xf;
+}
+
 #define __rpte_to_pte(r)	((r).pte)
 #define __rpte_sub_valid(rpte, index) \
 	(pte_val(rpte.pte) & (_PAGE_HPTE_SUB0 >> (index)))
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-com=
mon.c
index 458ed3b..12659ab 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -363,7 +363,6 @@ static pgprot_t __pci_mmap_set_pgprot(struct pci_dev *d=
ev, struct resource *rp,
 				      enum pci_mmap_state mmap_state,
 				      int write_combine)
 {
-	unsigned long prot =3D pgprot_val(protection);
=20
 	/* Write combine is always 0 on non-memory space mappings. On
 	 * memory space, if the user didn't pass 1, we check for a
@@ -380,9 +379,9 @@ static pgprot_t __pci_mmap_set_pgprot(struct pci_dev *d=
ev, struct resource *rp,
=20
 	/* XXX would be nice to have a way to ask for write-through */
 	if (write_combine)
-		return pgprot_noncached_wc(prot);
+		return pgprot_noncached_wc(protection);
 	else
-		return pgprot_noncached(prot);
+		return pgprot_noncached(protection);
 }
=20
 /*
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index e94b57f..75dd32e 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -218,7 +218,8 @@ static void __meminit vmemmap_create_mapping(unsigned l=
ong start,
 					     unsigned long phys)
 {
 	int  mapped =3D htab_bolt_mapping(start, start + page_size, phys,
-					PAGE_KERNEL, mmu_vmemmap_psize,
+					pgprot_val(PAGE_KERNEL),
+					mmu_vmemmap_psize,
 					mmu_kernel_ssize);
 	BUG_ON(mapped < 0);
 }
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 24523dc..f4b78a3 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -600,8 +600,8 @@ static int __cpuinit cpu_numa_callback(struct notifier_=
block *nfb,
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
-		break;
 		ret =3D NOTIFY_OK;
+		break;
 #endif
 	}
 	return ret;
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a3c40e8..aed3d91 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -119,6 +119,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_SUPPORTS_ATOMIC_RMW
=20
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 2c2e388..39a0b4f 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -21,3 +21,4 @@ generic-y +=3D div64.h
 generic-y +=3D local64.h
 generic-y +=3D irq_regs.h
 generic-y +=3D local.h
+generic-y +=3D types.h
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/p=
gtable_64.h
index ddbbea3..7ee5a1c 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -25,7 +25,8 @@
=20
 /* The kernel image occupies 0x4000000 to 0x6000000 (4MB --> 96MB).
  * The page copy blockops can use 0x6000000 to 0x8000000.
- * The TSB is mapped in the 0x8000000 to 0xa000000 range.
+ * The 8K TSB is mapped in the 0x8000000 to 0x8400000 range.
+ * The 4M TSB is mapped in the 0x8400000 to 0x8800000 range.
  * The PROM resides in an area spanning 0xf0000000 to 0x100000000.
  * The vmalloc area spans 0x100000000 to 0x200000000.
  * Since modules need to be in the lowest 32-bits of the address space,
@@ -34,7 +35,8 @@
  * 0x400000000.
  */
 #define	TLBTEMP_BASE		_AC(0x0000000006000000,UL)
-#define	TSBMAP_BASE		_AC(0x0000000008000000,UL)
+#define	TSBMAP_8K_BASE		_AC(0x0000000008000000,UL)
+#define	TSBMAP_4M_BASE		_AC(0x0000000008400000,UL)
 #define MODULES_VADDR		_AC(0x0000000010000000,UL)
 #define MODULES_LEN		_AC(0x00000000e0000000,UL)
 #define MODULES_END		_AC(0x00000000f0000000,UL)
diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/=
tlbflush_64.h
index f0d6a97..1a4bb97 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -35,6 +35,8 @@ static inline void flush_tlb_range(struct vm_area_struct =
*vma,
 {
 }
=20
+void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
 #define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
=20
 extern void flush_tlb_pending(void);
@@ -49,11 +51,6 @@ extern void __flush_tlb_kernel_range(unsigned long start=
, unsigned long end);
=20
 #ifndef CONFIG_SMP
=20
-#define flush_tlb_kernel_range(start,end) \
-do {	flush_tsb_kernel_range(start,end); \
-	__flush_tlb_kernel_range(start,end); \
-} while (0)
-
 static inline void global_flush_tlb_page(struct mm_struct *mm, unsigned lo=
ng vaddr)
 {
 	__flush_tlb_page(CTX_HWBITS(mm->context), vaddr);
@@ -64,11 +61,6 @@ static inline void global_flush_tlb_page(struct mm_struc=
t *mm, unsigned long vad
 extern void smp_flush_tlb_kernel_range(unsigned long start, unsigned long =
end);
 extern void smp_flush_tlb_page(struct mm_struct *mm, unsigned long vaddr);
=20
-#define flush_tlb_kernel_range(start, end) \
-do {	flush_tsb_kernel_range(start,end); \
-	smp_flush_tlb_kernel_range(start, end); \
-} while (0)
-
 #define global_flush_tlb_page(mm, vaddr) \
 	smp_flush_tlb_page(mm, vaddr)
=20
diff --git a/arch/sparc/include/asm/types.h b/arch/sparc/include/asm/types.=
h
deleted file mode 100644
index 91e5a03..0000000
--- a/arch/sparc/include/asm/types.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _SPARC_TYPES_H
-#define _SPARC_TYPES_H
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-
-#if defined(__sparc__)
-
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* defined(__sparc__) */
-
-#endif /* defined(_SPARC_TYPES_H) */
diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index 435e406..1beaf60 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1339,7 +1339,7 @@ int ldc_connect(struct ldc_channel *lp)
 	if (!(lp->flags & LDC_FLAG_ALLOCED_QUEUES) ||
 	    !(lp->flags & LDC_FLAG_REGISTERED_QUEUES) ||
 	    lp->hs_state !=3D LDC_HS_OPEN)
-		err =3D -EINVAL;
+		err =3D ((lp->hs_state > LDC_HS_OPEN) ? 0 : -EINVAL);
 	else
 		err =3D start_handshake(lp);
=20
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index e21d3c0d..ffd1245 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -151,7 +151,7 @@ void cpu_panic(void)
 #define NUM_ROUNDS	64	/* magic value */
 #define NUM_ITERS	5	/* likewise */
=20
-static DEFINE_SPINLOCK(itc_sync_lock);
+static DEFINE_RAW_SPINLOCK(itc_sync_lock);
 static unsigned long go[SLAVE + 1];
=20
 #define DEBUG_TICK_SYNC	0
@@ -259,7 +259,7 @@ static void smp_synchronize_one_tick(int cpu)
 	go[MASTER] =3D 0;
 	membar_safe("#StoreLoad");
=20
-	spin_lock_irqsave(&itc_sync_lock, flags);
+	raw_spin_lock_irqsave(&itc_sync_lock, flags);
 	{
 		for (i =3D 0; i < NUM_ROUNDS*NUM_ITERS; i++) {
 			while (!go[MASTER])
@@ -270,7 +270,7 @@ static void smp_synchronize_one_tick(int cpu)
 			membar_safe("#StoreLoad");
 		}
 	}
-	spin_unlock_irqrestore(&itc_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&itc_sync_lock, flags);
 }
=20
 #if defined(CONFIG_SUN_LDOMS) && defined(CONFIG_HOTPLUG_CPU)
diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index d97f3eb..085c60f 100644
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -87,7 +87,7 @@ SIGN1(sys32_io_submit, compat_sys_io_submit, %o1)
 SIGN1(sys32_mq_open, compat_sys_mq_open, %o1)
 SIGN1(sys32_select, compat_sys_select, %o0)
 SIGN1(sys32_mkdir, sys_mkdir, %o1)
-SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
+SIGN1(sys32_futex, compat_sys_futex, %o1)
 SIGN1(sys32_sysfs, compat_sys_sysfs, %o0)
 SIGN2(sys32_sendfile, compat_sys_sendfile, %o0, %o1)
 SIGN2(sys32_sendfile64, compat_sys_sendfile64, %o0, %o1)
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned=
_64.c
index 76e4ac1..1c90812 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -156,17 +156,23 @@ static unsigned long *fetch_reg_addr(unsigned int reg=
, struct pt_regs *regs)
 unsigned long compute_effective_address(struct pt_regs *regs,
 					unsigned int insn, unsigned int rd)
 {
+	int from_kernel =3D (regs->tstate & TSTATE_PRIV) !=3D 0;
 	unsigned int rs1 =3D (insn >> 14) & 0x1f;
 	unsigned int rs2 =3D insn & 0x1f;
-	int from_kernel =3D (regs->tstate & TSTATE_PRIV) !=3D 0;
+	unsigned long addr;
=20
 	if (insn & 0x2000) {
 		maybe_flush_windows(rs1, 0, rd, from_kernel);
-		return (fetch_reg(rs1, regs) + sign_extend_imm13(insn));
+		addr =3D (fetch_reg(rs1, regs) + sign_extend_imm13(insn));
 	} else {
 		maybe_flush_windows(rs1, rs2, rd, from_kernel);
-		return (fetch_reg(rs1, regs) + fetch_reg(rs2, regs));
+		addr =3D (fetch_reg(rs1, regs) + fetch_reg(rs2, regs));
 	}
+
+	if (!from_kernel && test_thread_flag(TIF_32BIT))
+		addr &=3D 0xffffffff;
+
+	return addr;
 }
=20
 /* This is just to make gcc think die_if_kernel does return... */
diff --git a/arch/sparc/lib/NG2memcpy.S b/arch/sparc/lib/NG2memcpy.S
index 0aed756..e993fc8 100644
--- a/arch/sparc/lib/NG2memcpy.S
+++ b/arch/sparc/lib/NG2memcpy.S
@@ -236,6 +236,7 @@ FUNC_NAME:	/* %o0=3Ddst, %o1=3Dsrc, %o2=3Dlen */
 	 */
 	VISEntryHalf
=20
+	membar		#Sync
 	alignaddr	%o1, %g0, %g0
=20
 	add		%o1, (64 - 1), %o4
diff --git a/arch/sparc/math-emu/math_32.c b/arch/sparc/math-emu/math_32.c
index aa4d55b..5ce8f2f 100644
--- a/arch/sparc/math-emu/math_32.c
+++ b/arch/sparc/math-emu/math_32.c
@@ -499,7 +499,7 @@ static int do_one_mathemu(u32 insn, unsigned long *pfsr=
, unsigned long *fregs)
 		case 0: fsr =3D *pfsr;
 			if (IR =3D=3D -1) IR =3D 2;
 			/* fcc is always fcc0 */
-			fsr &=3D ~0xc00; fsr |=3D (IR << 10); break;
+			fsr &=3D ~0xc00; fsr |=3D (IR << 10);
 			*pfsr =3D fsr;
 			break;
 		case 1: rd->s =3D IR; break;
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 504c062..2c0b966 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -95,38 +95,51 @@ static unsigned int get_user_insn(unsigned long tpc)
 	pte_t *ptep, pte;
 	unsigned long pa;
 	u32 insn =3D 0;
-	unsigned long pstate;
=20
-	if (pgd_none(*pgdp))
-		goto outret;
+	if (pgd_none(*pgdp) || unlikely(pgd_bad(*pgdp)))
+		goto out;
 	pudp =3D pud_offset(pgdp, tpc);
-	if (pud_none(*pudp))
-		goto outret;
-	pmdp =3D pmd_offset(pudp, tpc);
-	if (pmd_none(*pmdp))
-		goto outret;
-
-	/* This disables preemption for us as well. */
-	__asm__ __volatile__("rdpr %%pstate, %0" : "=3Dr" (pstate));
-	__asm__ __volatile__("wrpr %0, %1, %%pstate"
-				: : "r" (pstate), "i" (PSTATE_IE));
-	ptep =3D pte_offset_map(pmdp, tpc);
-	pte =3D *ptep;
-	if (!pte_present(pte))
+	if (pud_none(*pudp) || unlikely(pud_bad(*pudp)))
 		goto out;
=20
-	pa  =3D (pte_pfn(pte) << PAGE_SHIFT);
-	pa +=3D (tpc & ~PAGE_MASK);
-
-	/* Use phys bypass so we don't pollute dtlb/dcache. */
-	__asm__ __volatile__("lduwa [%1] %2, %0"
-			     : "=3Dr" (insn)
-			     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+	/* This disables preemption for us as well. */
+	local_irq_disable();
=20
+	pmdp =3D pmd_offset(pudp, tpc);
+	if (pmd_none(*pmdp) || unlikely(pmd_bad(*pmdp)))
+		goto out_irq_enable;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge(*pmdp)) {
+		if (pmd_trans_splitting(*pmdp))
+			goto out_irq_enable;
+
+		pa  =3D pmd_pfn(*pmdp) << PAGE_SHIFT;
+		pa +=3D tpc & ~HPAGE_MASK;
+
+		/* Use phys bypass so we don't pollute dtlb/dcache. */
+		__asm__ __volatile__("lduwa [%1] %2, %0"
+				     : "=3Dr" (insn)
+				     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+	} else
+#endif
+	{
+		ptep =3D pte_offset_map(pmdp, tpc);
+		pte =3D *ptep;
+		if (pte_present(pte)) {
+			pa  =3D (pte_pfn(pte) << PAGE_SHIFT);
+			pa +=3D (tpc & ~PAGE_MASK);
+
+			/* Use phys bypass so we don't pollute dtlb/dcache. */
+			__asm__ __volatile__("lduwa [%1] %2, %0"
+					     : "=3Dr" (insn)
+					     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+		}
+		pte_unmap(ptep);
+	}
+out_irq_enable:
+	local_irq_enable();
 out:
-	pte_unmap(ptep);
-	__asm__ __volatile__("wrpr %0, 0x0, %%pstate" : : "r" (pstate));
-outret:
 	return insn;
 }
=20
@@ -154,7 +167,8 @@ show_signal_msg(struct pt_regs *regs, int sig, int code=
,
 extern unsigned long compute_effective_address(struct pt_regs *, unsigned =
int, unsigned int);
=20
 static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
-			     unsigned int insn, int fault_code)
+			     unsigned long fault_addr, unsigned int insn,
+			     int fault_code)
 {
 	unsigned long addr;
 	siginfo_t info;
@@ -162,10 +176,18 @@ static void do_fault_siginfo(int code, int sig, struc=
t pt_regs *regs,
 	info.si_code =3D code;
 	info.si_signo =3D sig;
 	info.si_errno =3D 0;
-	if (fault_code & FAULT_CODE_ITLB)
+	if (fault_code & FAULT_CODE_ITLB) {
 		addr =3D regs->tpc;
-	else
-		addr =3D compute_effective_address(regs, insn, 0);
+	} else {
+		/* If we were able to probe the faulting instruction, use it
+		 * to compute a precise fault address.  Otherwise use the fault
+		 * time provided address which may only have page granularity.
+		 */
+		if (insn)
+			addr =3D compute_effective_address(regs, insn, 0);
+		else
+			addr =3D fault_addr;
+	}
 	info.si_addr =3D (void __user *) addr;
 	info.si_trapno =3D 0;
=20
@@ -240,7 +262,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *r=
egs, int si_code,
 		/* The si_code was set to make clear whether
 		 * this was a SEGV_MAPERR or SEGV_ACCERR fault.
 		 */
-		do_fault_siginfo(si_code, SIGSEGV, regs, insn, fault_code);
+		do_fault_siginfo(si_code, SIGSEGV, regs, address, insn, fault_code);
 		return;
 	}
=20
@@ -260,18 +282,6 @@ static void noinline __kprobes bogus_32bit_fault_tpc(s=
truct pt_regs *regs)
 	show_regs(regs);
 }
=20
-static void noinline __kprobes bogus_32bit_fault_address(struct pt_regs *r=
egs,
-							 unsigned long addr)
-{
-	static int times;
-
-	if (times++ < 10)
-		printk(KERN_ERR "FAULT[%s:%d]: 32-bit process "
-		       "reports 64-bit fault address [%lx]\n",
-		       current->comm, current->pid, addr);
-	show_regs(regs);
-}
-
 asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 {
 	struct mm_struct *mm =3D current->mm;
@@ -299,10 +309,8 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_r=
egs *regs)
 				goto intr_or_no_mm;
 			}
 		}
-		if (unlikely((address >> 32) !=3D 0)) {
-			bogus_32bit_fault_address(regs, address);
+		if (unlikely((address >> 32) !=3D 0))
 			goto intr_or_no_mm;
-		}
 	}
=20
 	if (regs->tstate & TSTATE_PRIV) {
@@ -492,7 +500,7 @@ do_sigbus:
 	 * Send a sigbus, regardless of whether we were in kernel
 	 * or user mode.
 	 */
-	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, insn, fault_code);
+	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, address, insn, fault_code);
=20
 	/* Kernel mode? Handle exceptions or die */
 	if (regs->tstate & TSTATE_PRIV)
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b4989f9..d2c5737 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -309,6 +309,10 @@ void update_mmu_cache(struct vm_area_struct *vma, unsi=
gned long address, pte_t *
 	tsb_index =3D MM_TSB_BASE;
 	tsb_hash_shift =3D PAGE_SHIFT;
=20
+	/* Don't insert a non-valid PTE into the TSB, we'll deadlock.  */
+	if (!(pte_val(pte) & _PAGE_VALID))
+		return;
+
 	spin_lock_irqsave(&mm->context.lock, flags);
=20
 #ifdef CONFIG_HUGETLB_PAGE
@@ -2436,3 +2440,26 @@ void __flush_tlb_all(void)
 	__asm__ __volatile__("wrpr	%0, 0, %%pstate"
 			     : : "r" (pstate));
 }
+
+#ifdef CONFIG_SMP
+#define do_flush_tlb_kernel_range	smp_flush_tlb_kernel_range
+#else
+#define do_flush_tlb_kernel_range	__flush_tlb_kernel_range
+#endif
+
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
+		if (start < LOW_OBP_ADDRESS) {
+			flush_tsb_kernel_range(start, LOW_OBP_ADDRESS);
+			do_flush_tlb_kernel_range(start, LOW_OBP_ADDRESS);
+		}
+		if (end > HI_OBP_ADDRESS) {
+			flush_tsb_kernel_range(end, HI_OBP_ADDRESS);
+			do_flush_tlb_kernel_range(end, HI_OBP_ADDRESS);
+		}
+	} else {
+		flush_tsb_kernel_range(start, end);
+		do_flush_tlb_kernel_range(start, end);
+	}
+}
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 3ebcac7..6ddf60b 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -151,7 +151,19 @@ static void setup_tsb_params(struct mm_struct *mm, uns=
igned long tsb_idx, unsign
 	mm->context.tsb_block[tsb_idx].tsb_nentries =3D
 		tsb_bytes / sizeof(struct tsb);
=20
-	base =3D TSBMAP_BASE;
+	switch (tsb_idx) {
+	case MM_TSB_BASE:
+		base =3D TSBMAP_8K_BASE;
+		break;
+#if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
+	case MM_TSB_HUGE:
+		base =3D TSBMAP_4M_BASE;
+		break;
+#endif
+	default:
+		BUG();
+	}
+
 	tte =3D pgprot_val(PAGE_KERNEL_LOCKED);
 	tsb_paddr =3D __pa(mm->context.tsb_block[tsb_idx].tsb);
 	BUG_ON(tsb_paddr & (tsb_bytes - 1UL));
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 901447e..28a1bca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -896,10 +896,27 @@ config VM86
 	default y
 	depends on X86_32
 	---help---
-	  This option is required by programs like DOSEMU to run 16-bit legacy
-	  code on X86 processors. It also may be needed by software like
-	  XFree86 to initialize some video cards via BIOS. Disabling this
-	  option saves about 6k.
+	  This option is required by programs like DOSEMU to run
+	  16-bit real mode legacy code on x86 processors. It also may
+	  be needed by software like XFree86 to initialize some video
+	  cards via BIOS. Disabling this option saves about 6K.
+
+config X86_16BIT
+	bool "Enable support for 16-bit segments" if EXPERT
+	default y
+	---help---
+	  This option is required by programs like Wine to run 16-bit
+	  protected mode legacy code on x86 processors.  Disabling
+	  this option saves about 300 bytes on i386, or around 6K text
+	  plus 16K runtime memory on x86-64,
+
+config X86_ESPFIX32
+	def_bool y
+	depends on X86_16BIT && X86_32
+
+config X86_ESPFIX64
+	def_bool y
+	depends on X86_16BIT && X86_64
=20
 config TOSHIBA
 	tristate "Toshiba Laptop support"
diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
new file mode 100644
index 0000000..99efebb
--- /dev/null
+++ b/arch/x86/include/asm/espfix.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_ESPFIX_H
+#define _ASM_X86_ESPFIX_H
+
+#ifdef CONFIG_X86_64
+
+#include <asm/percpu.h>
+
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
+
+extern void init_espfix_bsp(void);
+extern void init_espfix_ap(void);
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_ESPFIX_H */
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflag=
s.h
index bba3cf8..0a8b519 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -129,7 +129,7 @@ static inline notrace unsigned long arch_local_irq_save=
(void)
=20
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
=20
-#define INTERRUPT_RETURN	iretq
+#define INTERRUPT_RETURN	jmp native_iret
 #define USERGS_SYSRET64				\
 	swapgs;					\
 	sysretq;
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm=
/pgtable_64_types.h
index 766ea16..51817fa 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -59,5 +59,7 @@ typedef struct { pteval_t pte; } pte_t;
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#define ESPFIX_PGD_ENTRY _AC(-2, UL)
+#define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
=20
 #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9756551..8a87336 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -61,6 +61,8 @@ static inline void x86_ce4100_early_setup(void) { }
=20
 #ifndef _SETUP
=20
+#include <asm/espfix.h>
+
 /*
  * This is set up by the setup-routine at boot-time
  */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8baca3c..96efa3e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_X86_32)	+=3D sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+=3D sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+=3D syscall_64.o vsyscall_64.o
 obj-$(CONFIG_X86_64)	+=3D vsyscall_emu_64.o
+obj-$(CONFIG_X86_ESPFIX64)	+=3D espfix_64.o
 obj-y			+=3D bootflag.o e820.o
 obj-y			+=3D pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+=3D alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dd52355..0fa4f89 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -527,6 +527,7 @@ syscall_exit:
 restore_all:
 	TRACE_IRQS_IRET
 restore_all_notrace:
+#ifdef CONFIG_X86_ESPFIX32
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS, SS and CS
 	# Warning: PT_OLDSS(%esp) contains the wrong/random values if we
 	# are returning to the kernel.
@@ -537,6 +538,7 @@ restore_all_notrace:
 	cmpl $((SEGMENT_LDT << 8) | USER_RPL), %eax
 	CFI_REMEMBER_STATE
 	je ldt_ss			# returning to user-space with LDT SS
+#endif
 restore_nocheck:
 	RESTORE_REGS 4			# skip orig_eax/error_code
 irq_return:
@@ -552,6 +554,7 @@ ENTRY(iret_exc)
 	.long irq_return,iret_exc
 .previous
=20
+#ifdef CONFIG_X86_ESPFIX32
 	CFI_RESTORE_STATE
 ldt_ss:
 #ifdef CONFIG_PARAVIRT
@@ -595,6 +598,7 @@ ldt_ss:
 	lss (%esp), %esp		/* switch to espfix segment */
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
+#endif
 	CFI_ENDPROC
 ENDPROC(system_call)
=20
@@ -766,6 +770,7 @@ ENDPROC(ptregs_clone)
  * the high word of the segment base from the GDT and swiches to the
  * normal stack and adjusts ESP with the matching offset.
  */
+#ifdef CONFIG_X86_ESPFIX32
 	/* fixup the stack */
 	mov GDT_ESPFIX_SS + 4, %al /* bits 16..23 */
 	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
@@ -775,8 +780,10 @@ ENDPROC(ptregs_clone)
 	pushl_cfi %eax
 	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
+#endif
 .endm
 .macro UNWIND_ESPFIX_STACK
+#ifdef CONFIG_X86_ESPFIX32
 	movl %ss, %eax
 	/* see if on espfix stack */
 	cmpw $__ESPFIX_SS, %ax
@@ -787,6 +794,7 @@ ENDPROC(ptregs_clone)
 	/* switch to normal stack */
 	FIXUP_ESPFIX_STACK
 27:
+#endif
 .endm
=20
 /*
@@ -1323,11 +1331,13 @@ END(debug)
  */
 ENTRY(nmi)
 	RING0_INT_FRAME
+#ifdef CONFIG_X86_ESPFIX32
 	pushl_cfi %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
 	popl_cfi %eax
 	je nmi_espfix_stack
+#endif
 	cmpl $ia32_sysenter_target,(%esp)
 	je nmi_stack_fixup
 	pushl_cfi %eax
@@ -1367,6 +1377,7 @@ nmi_debug_stack_check:
 	FIX_STACK 24, nmi_stack_correct, 1
 	jmp nmi_stack_correct
=20
+#ifdef CONFIG_X86_ESPFIX32
 nmi_espfix_stack:
 	/* We have a RING0_INT_FRAME here.
 	 *
@@ -1388,6 +1399,7 @@ nmi_espfix_stack:
 	lss 12+4(%esp), %esp		# back to espfix stack
 	CFI_ADJUST_CFA_OFFSET -24
 	jmp irq_return
+#endif
 	CFI_ENDPROC
 END(nmi)
=20
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6274f5f..4b511ef 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -55,6 +55,7 @@
 #include <asm/paravirt.h>
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
+#include <asm/pgtable_types.h>
=20
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -862,17 +863,47 @@ restore_args:
 irq_return:
 	INTERRUPT_RETURN
=20
-	.section __ex_table, "a"
-	.quad irq_return, bad_iret
-	.previous
-
-#ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
+	/*
+	 * Are we returning to a stack segment from the LDT?  Note: in
+	 * 64-bit mode SS:RSP on the exception stack is always valid.
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	testb $4,(SS-RIP)(%rsp)
+	jnz native_irq_return_ldt
+#endif
+
+native_irq_return_iret:
 	iretq
=20
 	.section __ex_table,"a"
-	.quad native_iret, bad_iret
+	.quad native_irq_return_iret, bad_iret
 	.previous
+
+#ifdef CONFIG_X86_ESPFIX64
+native_irq_return_ldt:
+	pushq_cfi %rax
+	pushq_cfi %rdi
+	SWAPGS
+	movq PER_CPU_VAR(espfix_waddr),%rdi
+	movq %rax,(0*8)(%rdi)	/* RAX */
+	movq (2*8)(%rsp),%rax	/* RIP */
+	movq %rax,(1*8)(%rdi)
+	movq (3*8)(%rsp),%rax	/* CS */
+	movq %rax,(2*8)(%rdi)
+	movq (4*8)(%rsp),%rax	/* RFLAGS */
+	movq %rax,(3*8)(%rdi)
+	movq (6*8)(%rsp),%rax	/* SS */
+	movq %rax,(5*8)(%rdi)
+	movq (5*8)(%rsp),%rax	/* RSP */
+	movq %rax,(4*8)(%rdi)
+	andl $0xffff0000,%eax
+	popq_cfi %rdi
+	orq PER_CPU_VAR(espfix_stack),%rax
+	SWAPGS
+	movq %rax,%rsp
+	popq_cfi %rax
+	jmp native_irq_return_iret
 #endif
=20
 	.section .fixup,"ax"
@@ -938,9 +969,40 @@ ENTRY(retint_kernel)
 	call preempt_schedule_irq
 	jmp exit_intr
 #endif
-
 	CFI_ENDPROC
 END(common_interrupt)
+
+	/*
+	 * If IRET takes a fault on the espfix stack, then we
+	 * end up promoting it to a doublefault.  In that case,
+	 * modify the stack to make it look like we just entered
+	 * the #GP handler from user space, similar to bad_iret.
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	ALIGN
+__do_double_fault:
+	XCPT_FRAME 1 RDI+8
+	movq RSP(%rdi),%rax		/* Trap on the espfix stack? */
+	sarq $PGDIR_SHIFT,%rax
+	cmpl $ESPFIX_PGD_ENTRY,%eax
+	jne do_double_fault		/* No, just deliver the fault */
+	cmpl $__KERNEL_CS,CS(%rdi)
+	jne do_double_fault
+	movq RIP(%rdi),%rax
+	cmpq $native_irq_return_iret,%rax
+	jne do_double_fault		/* This shouldn't happen... */
+	movq PER_CPU_VAR(kernel_stack),%rax
+	subq $(6*8-KERNEL_STACK_OFFSET),%rax	/* Reset to original stack */
+	movq %rax,RSP(%rdi)
+	movq $0,(%rax)			/* Missing (lost) #GP error code */
+	movq $general_protection,RIP(%rdi)
+	retq
+	CFI_ENDPROC
+END(__do_double_fault)
+#else
+# define __do_double_fault do_double_fault
+#endif
+
 /*
  * End of kprobes section
  */
@@ -1107,7 +1169,7 @@ zeroentry overflow do_overflow
 zeroentry bounds do_bounds
 zeroentry invalid_op do_invalid_op
 zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault do_double_fault
+paranoiderrorentry double_fault __do_double_fault
 zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
 errorentry invalid_TSS do_invalid_TSS
 errorentry segment_not_present do_segment_not_present
@@ -1438,7 +1500,7 @@ error_sti:
  */
 error_kernelspace:
 	incl %ebx
-	leaq irq_return(%rip),%rcx
+	leaq native_irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
 	movl %ecx,%eax	/* zero extend */
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
new file mode 100644
index 0000000..94d857f
--- /dev/null
+++ b/arch/x86/kernel/espfix_64.c
@@ -0,0 +1,208 @@
+/* -----------------------------------------------------------------------=
 *
+ *
+ *   Copyright 2014 Intel Corporation; author: H. Peter Anvin
+ *
+ *   This program is free software; you can redistribute it and/or modify =
it
+ *   under the terms and conditions of the GNU General Public License,
+ *   version 2, as published by the Free Software Foundation.
+ *
+ *   This program is distributed in the hope it will be useful, but WITHOU=
T
+ *   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
+ *   more details.
+ *
+ * -----------------------------------------------------------------------=
 */
+
+/*
+ * The IRET instruction, when returning to a 16-bit segment, only
+ * restores the bottom 16 bits of the user space stack pointer.  This
+ * causes some 16-bit software to break, but it also leaks kernel state
+ * to user space.
+ *
+ * This works around this by creating percpu "ministacks", each of which
+ * is mapped 2^16 times 64K apart.  When we detect that the return SS is
+ * on the LDT, we copy the IRET frame to the ministack and use the
+ * relevant alias to return to userspace.  The ministacks are mapped
+ * readonly, so if the IRET fault we promote #GP to #DF which is an IST
+ * vector and thus has its own stack; we then do the fixup in the #DF
+ * handler.
+ *
+ * This file sets up the ministacks and the related page tables.  The
+ * actual ministack invocation is in entry_64.S.
+ */
+
+#include <linux/init.h>
+#include <linux/init_task.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/gfp.h>
+#include <linux/random.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/setup.h>
+#include <asm/espfix.h>
+
+/*
+ * Note: we only need 6*8 =3D 48 bytes for the espfix stack, but round
+ * it up to a cache line to avoid unnecessary sharing.
+ */
+#define ESPFIX_STACK_SIZE	(8*8UL)
+#define ESPFIX_STACKS_PER_PAGE	(PAGE_SIZE/ESPFIX_STACK_SIZE)
+
+/* There is address space for how many espfix pages? */
+#define ESPFIX_PAGE_SPACE	(1UL << (PGDIR_SHIFT-PAGE_SHIFT-16))
+
+#define ESPFIX_MAX_CPUS		(ESPFIX_STACKS_PER_PAGE * ESPFIX_PAGE_SPACE)
+#if CONFIG_NR_CPUS > ESPFIX_MAX_CPUS
+# error "Need more than one PGD for the ESPFIX hack"
+#endif
+
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZER=
O)
+
+/* This contains the *bottom* address of the espfix stack */
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
+
+/* Initialization mutex - should this be a spinlock? */
+static DEFINE_MUTEX(espfix_init_mutex);
+
+/* Page allocation bitmap - each page serves ESPFIX_STACKS_PER_PAGE CPUs *=
/
+#define ESPFIX_MAX_PAGES  DIV_ROUND_UP(CONFIG_NR_CPUS, ESPFIX_STACKS_PER_P=
AGE)
+static void *espfix_pages[ESPFIX_MAX_PAGES];
+
+static __page_aligned_bss pud_t espfix_pud_page[PTRS_PER_PUD]
+	__aligned(PAGE_SIZE);
+
+static unsigned int page_random, slot_random;
+
+/*
+ * This returns the bottom address of the espfix stack for a specific CPU.
+ * The math allows for a non-power-of-two ESPFIX_STACK_SIZE, in which case
+ * we have to account for some amount of padding at the end of each page.
+ */
+static inline unsigned long espfix_base_addr(unsigned int cpu)
+{
+	unsigned long page, slot;
+	unsigned long addr;
+
+	page =3D (cpu / ESPFIX_STACKS_PER_PAGE) ^ page_random;
+	slot =3D (cpu + slot_random) % ESPFIX_STACKS_PER_PAGE;
+	addr =3D (page << PAGE_SHIFT) + (slot * ESPFIX_STACK_SIZE);
+	addr =3D (addr & 0xffffUL) | ((addr & ~0xffffUL) << 16);
+	addr +=3D ESPFIX_BASE_ADDR;
+	return addr;
+}
+
+#define PTE_STRIDE        (65536/PAGE_SIZE)
+#define ESPFIX_PTE_CLONES (PTRS_PER_PTE/PTE_STRIDE)
+#define ESPFIX_PMD_CLONES PTRS_PER_PMD
+#define ESPFIX_PUD_CLONES (65536/(ESPFIX_PTE_CLONES*ESPFIX_PMD_CLONES))
+
+#define PGTABLE_PROT	  ((_KERNPG_TABLE & ~_PAGE_RW) | _PAGE_NX)
+
+static void init_espfix_random(void)
+{
+	unsigned long rand;
+
+	/*
+	 * This is run before the entropy pools are initialized,
+	 * but this is hopefully better than nothing.
+	 */
+	if (!arch_get_random_long(&rand)) {
+		/* The constant is an arbitrary large prime */
+		rdtscll(rand);
+		rand *=3D 0xc345c6b72fd16123UL;
+	}
+
+	slot_random =3D rand % ESPFIX_STACKS_PER_PAGE;
+	page_random =3D (rand / ESPFIX_STACKS_PER_PAGE)
+		& (ESPFIX_PAGE_SPACE - 1);
+}
+
+void __init init_espfix_bsp(void)
+{
+	pgd_t *pgd_p;
+	pteval_t ptemask;
+
+	ptemask =3D __supported_pte_mask;
+
+	/* Install the espfix pud into the kernel page directory */
+	pgd_p =3D &init_level4_pgt[pgd_index(ESPFIX_BASE_ADDR)];
+	pgd_populate(&init_mm, pgd_p, (pud_t *)espfix_pud_page);
+
+	/* Randomize the locations */
+	init_espfix_random();
+
+	/* The rest is the same as for any other processor */
+	init_espfix_ap();
+}
+
+void init_espfix_ap(void)
+{
+	unsigned int cpu, page;
+	unsigned long addr;
+	pud_t pud, *pud_p;
+	pmd_t pmd, *pmd_p;
+	pte_t pte, *pte_p;
+	int n;
+	void *stack_page;
+	pteval_t ptemask;
+
+	/* We only have to do this once... */
+	if (likely(this_cpu_read(espfix_stack)))
+		return;		/* Already initialized */
+
+	cpu =3D smp_processor_id();
+	addr =3D espfix_base_addr(cpu);
+	page =3D cpu/ESPFIX_STACKS_PER_PAGE;
+
+	/* Did another CPU already set this up? */
+	stack_page =3D ACCESS_ONCE(espfix_pages[page]);
+	if (likely(stack_page))
+		goto done;
+
+	mutex_lock(&espfix_init_mutex);
+
+	/* Did we race on the lock? */
+	stack_page =3D ACCESS_ONCE(espfix_pages[page]);
+	if (stack_page)
+		goto unlock_done;
+
+	ptemask =3D __supported_pte_mask;
+
+	pud_p =3D &espfix_pud_page[pud_index(addr)];
+	pud =3D *pud_p;
+	if (!pud_present(pud)) {
+		pmd_p =3D (pmd_t *)__get_free_page(PGALLOC_GFP);
+		pud =3D __pud(__pa(pmd_p) | (PGTABLE_PROT & ptemask));
+		paravirt_alloc_pmd(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
+		for (n =3D 0; n < ESPFIX_PUD_CLONES; n++)
+			set_pud(&pud_p[n], pud);
+	}
+
+	pmd_p =3D pmd_offset(&pud, addr);
+	pmd =3D *pmd_p;
+	if (!pmd_present(pmd)) {
+		pte_p =3D (pte_t *)__get_free_page(PGALLOC_GFP);
+		pmd =3D __pmd(__pa(pte_p) | (PGTABLE_PROT & ptemask));
+		paravirt_alloc_pte(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
+		for (n =3D 0; n < ESPFIX_PMD_CLONES; n++)
+			set_pmd(&pmd_p[n], pmd);
+	}
+
+	pte_p =3D pte_offset_kernel(&pmd, addr);
+	stack_page =3D (void *)__get_free_page(GFP_KERNEL);
+	pte =3D __pte(__pa(stack_page) | (__PAGE_KERNEL_RO & ptemask));
+	for (n =3D 0; n < ESPFIX_PTE_CLONES; n++)
+		set_pte(&pte_p[n*PTE_STRIDE], pte);
+
+	/* Job is done for this CPU and any CPU which shares this page */
+	ACCESS_ONCE(espfix_pages[page]) =3D stack_page;
+
+unlock_done:
+	mutex_unlock(&espfix_init_mutex);
+done:
+	this_cpu_write(espfix_stack, addr);
+	this_cpu_write(espfix_waddr, (unsigned long)stack_page
+		       + (addr & ~PAGE_MASK));
+}
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 3e0ccbf..0a8e65e 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -21,8 +21,6 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
=20
-int sysctl_ldt16 =3D 0;
-
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
 {
@@ -232,16 +230,10 @@ static int write_ldt(void __user *ptr, unsigned long =
bytecount, int oldmode)
 		}
 	}
=20
-	/*
-	 * On x86-64 we do not support 16-bit segments due to
-	 * IRET leaking the high bits of the kernel stack address.
-	 */
-#ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
+	if (!IS_ENABLED(CONFIG_X86_16BIT) && !ldt_info.seg_32bit) {
 		error =3D -EINVAL;
 		goto out_unlock;
 	}
-#endif
=20
 	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt=
_patch_64.c
index 3f08f34..a1da673 100644
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -6,7 +6,6 @@ DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
 DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
 DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
-DEF_NATIVE(pv_cpu_ops, iret, "iretq");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
@@ -50,7 +49,6 @@ unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
 		PATCH_SITE(pv_irq_ops, save_fl);
 		PATCH_SITE(pv_irq_ops, irq_enable);
 		PATCH_SITE(pv_irq_ops, irq_disable);
-		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
 		PATCH_SITE(pv_cpu_ops, usergs_sysret32);
 		PATCH_SITE(pv_cpu_ops, usergs_sysret64);
diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
index 2a26819..80eab01 100644
--- a/arch/x86/kernel/resource.c
+++ b/arch/x86/kernel/resource.c
@@ -37,10 +37,12 @@ static void remove_e820_regions(struct resource *avail)
=20
 void arch_remove_reservations(struct resource *avail)
 {
-	/* Trim out BIOS areas (low 1MB and high 2MB) and E820 regions */
+	/*
+	 * Trim out BIOS area (high 2MB) and E820 regions. We do not remove
+	 * the low 1MB unconditionally, as this area is needed for some ISA
+	 * cards requiring a memory range, e.g. the i82365 PCMCIA controller.
+	 */
 	if (avail->flags & IORESOURCE_MEM) {
-		if (avail->start < BIOS_END)
-			avail->start =3D BIOS_END;
 		resource_clip(avail, BIOS_ROM_BASE, BIOS_ROM_END);
=20
 		remove_e820_regions(avail);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b88eadb..6e68bd9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -266,6 +266,13 @@ notrace static void __cpuinit start_secondary(void *un=
used)
 	check_tsc_sync_target();
=20
 	/*
+	 * Enable the espfix hack for this CPU
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	init_espfix_ap();
+#endif
+
+	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
 	 * IPI recipients, and the time when the determination is made
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f5302da..638cab5 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1818,6 +1818,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	unsigned long cs;
+	int cpl =3D ctxt->ops->cpl(ctxt);
=20
 	rc =3D emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
 	if (rc !=3D X86EMUL_CONTINUE)
@@ -1827,6 +1828,9 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 	rc =3D emulate_pop(ctxt, &cs, ctxt->op_bytes);
 	if (rc !=3D X86EMUL_CONTINUE)
 		return rc;
+	/* Outer-privilege level return is not implemented */
+	if (ctxt->mode >=3D X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
+		return X86EMUL_UNHANDLEABLE;
 	rc =3D load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
 	return rc;
 }
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0002a3a..e04e677 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -30,11 +30,13 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned long current_address;
 	const struct addr_marker *marker;
+	unsigned long lines;
 };
=20
 struct addr_marker {
 	unsigned long start_address;
 	const char *name;
+	unsigned long max_lines;
 };
=20
 /* indices for address_markers; keep sync'd w/ address_markers below */
@@ -45,6 +47,7 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+	ESPFIX_START_NR,
 	HIGH_KERNEL_NR,
 	MODULES_VADDR_NR,
 	MODULES_END_NR,
@@ -67,6 +70,7 @@ static struct addr_marker address_markers[] =3D {
 	{ PAGE_OFFSET,		"Low Kernel Mapping" },
 	{ VMALLOC_START,        "vmalloc() Area" },
 	{ VMEMMAP_START,        "Vmemmap" },
+	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
@@ -163,7 +167,7 @@ static void note_page(struct seq_file *m, struct pg_sta=
te *st,
 		      pgprot_t new_prot, int level)
 {
 	pgprotval_t prot, cur;
-	static const char units[] =3D "KMGTPE";
+	static const char units[] =3D "BKMGTPE";
=20
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
@@ -178,6 +182,7 @@ static void note_page(struct seq_file *m, struct pg_sta=
te *st,
 		st->current_prot =3D new_prot;
 		st->level =3D level;
 		st->marker =3D address_markers;
+		st->lines =3D 0;
 		seq_printf(m, "---[ %s ]---\n", st->marker->name);
 	} else if (prot !=3D cur || level !=3D st->level ||
 		   st->current_address >=3D st->marker[1].start_address) {
@@ -188,17 +193,21 @@ static void note_page(struct seq_file *m, struct pg_s=
tate *st,
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%0*lx-0x%0*lx   ",
-			   width, st->start_address,
-			   width, st->current_address);
-
-		delta =3D (st->current_address - st->start_address) >> 10;
-		while (!(delta & 1023) && unit[1]) {
-			delta >>=3D 10;
-			unit++;
+		if (!st->marker->max_lines ||
+		    st->lines < st->marker->max_lines) {
+			seq_printf(m, "0x%0*lx-0x%0*lx   ",
+				   width, st->start_address,
+				   width, st->current_address);
+
+			delta =3D (st->current_address - st->start_address);
+			while (!(delta & 1023) && unit[1]) {
+				delta >>=3D 10;
+				unit++;
+			}
+			seq_printf(m, "%9lu%c ", delta, *unit);
+			printk_prot(m, st->current_prot, st->level);
 		}
-		seq_printf(m, "%9lu%c ", delta, *unit);
-		printk_prot(m, st->current_prot, st->level);
+		st->lines++;
=20
 		/*
 		 * We print markers for special areas of address space,
@@ -206,7 +215,15 @@ static void note_page(struct seq_file *m, struct pg_st=
ate *st,
 		 * This helps in the interpretation.
 		 */
 		if (st->current_address >=3D st->marker[1].start_address) {
+			if (st->marker->max_lines &&
+			    st->lines > st->marker->max_lines) {
+				unsigned long nskip =3D
+					st->lines - st->marker->max_lines;
+				seq_printf(m, "... %lu entr%s skipped ... \n",
+					   nskip, nskip =3D=3D 1 ? "y" : "ies");
+			}
 			st->marker++;
+			st->lines =3D 0;
 			seq_printf(m, "---[ %s ]---\n", st->marker->name);
 		}
=20
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 794b092..2d3c854 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -73,6 +73,10 @@ pcibios_align_resource(void *data, const struct resource=
 *res,
 			return start;
 		if (start & 0x300)
 			start =3D (start + 0x3ff) & ~0x3ff;
+	} else if (res->flags & IORESOURCE_MEM) {
+		/* The low 1MB range is reserved for ISA cards */
+		if (start < BIOS_END)
+			start =3D BIOS_END;
 	}
 	return start;
 }
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 51bdc05..468d591 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -41,7 +41,6 @@ enum {
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
-extern int sysctl_ldt16;
 #endif
=20
 /*
@@ -389,13 +388,6 @@ static ctl_table abi_table2[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec
 	},
-	{
-		.procname	=3D "ldt16",
-		.data		=3D &sysctl_ldt16,
-		.maxlen		=3D sizeof(int),
-		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec
-	},
 	{}
 };
=20
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index d50a821..1a82319 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -397,7 +397,7 @@ void xen_setup_timer(int cpu)
 	irq =3D bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
 				      IRQF_DISABLED|IRQF_PERCPU|
 				      IRQF_NOBALANCING|IRQF_TIMER|
-				      IRQF_FORCE_RESUME,
+				      IRQF_FORCE_RESUME|IRQF_EARLY_RESUME,
 				      name, NULL);
=20
 	evt =3D &per_cpu(xen_clock_events, cpu);
diff --git a/block/blk-tag.c b/block/blk-tag.c
index 4af6f5c..f606487 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -27,18 +27,15 @@ struct request *blk_queue_find_tag(struct request_queue=
 *q, int tag)
 EXPORT_SYMBOL(blk_queue_find_tag);
=20
 /**
- * __blk_free_tags - release a given set of tag maintenance info
+ * blk_free_tags - release a given set of tag maintenance info
  * @bqt:	the tag map to free
  *
- * Tries to free the specified @bqt.  Returns true if it was
- * actually freed and false if there are still references using it
+ * Drop the reference count on @bqt and frees it when the last reference
+ * is dropped.
  */
-static int __blk_free_tags(struct blk_queue_tag *bqt)
+void blk_free_tags(struct blk_queue_tag *bqt)
 {
-	int retval;
-
-	retval =3D atomic_dec_and_test(&bqt->refcnt);
-	if (retval) {
+	if (atomic_dec_and_test(&bqt->refcnt)) {
 		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
 							bqt->max_depth);
=20
@@ -50,9 +47,8 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
=20
 		kfree(bqt);
 	}
-
-	return retval;
 }
+EXPORT_SYMBOL(blk_free_tags);
=20
 /**
  * __blk_queue_free_tags - release tag maintenance info
@@ -69,28 +65,13 @@ void __blk_queue_free_tags(struct request_queue *q)
 	if (!bqt)
 		return;
=20
-	__blk_free_tags(bqt);
+	blk_free_tags(bqt);
=20
 	q->queue_tags =3D NULL;
 	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
 }
=20
 /**
- * blk_free_tags - release a given set of tag maintenance info
- * @bqt:	the tag map to free
- *
- * For externally managed @bqt frees the map.  Callers of this
- * function must guarantee to have released all the queues that
- * might have been using this tag map.
- */
-void blk_free_tags(struct blk_queue_tag *bqt)
-{
-	if (unlikely(!__blk_free_tags(bqt)))
-		BUG();
-}
-EXPORT_SYMBOL(blk_free_tags);
-
-/**
  * blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
  *
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ac33d5f..bf948e1 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
+#include <linux/security.h>
=20
 struct alg_type_list {
 	const struct af_alg_type *type;
@@ -243,6 +244,7 @@ int af_alg_accept(struct sock *sk, struct socket *newso=
ck)
=20
 	sock_init_data(newsock, sk2);
 	sock_graft(sk2, newsock);
+	security_sk_clone(sk, sk2);
=20
 	err =3D type->accept(ask->private, sk2);
 	if (err) {
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 48fd158..05df096 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -193,6 +193,8 @@ static bool advance_transaction(struct acpi_ec *ec)
 				t->rdata[t->ri++] =3D acpi_ec_read_data(ec);
 				if (t->rlen =3D=3D t->ri) {
 					t->flags |=3D ACPI_EC_COMMAND_COMPLETE;
+					if (t->command =3D=3D ACPI_EC_COMMAND_QUERY)
+						pr_debug("hardware QR_EC completion\n");
 					wakeup =3D true;
 				}
 			} else
@@ -204,7 +206,20 @@ static bool advance_transaction(struct acpi_ec *ec)
 		}
 		return wakeup;
 	} else {
-		if ((status & ACPI_EC_FLAG_IBF) =3D=3D 0) {
+		/*
+		 * There is firmware refusing to respond QR_EC when SCI_EVT
+		 * is not set, for which case, we complete the QR_EC
+		 * without issuing it to the firmware.
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=3D86211
+		 */
+		if (!(status & ACPI_EC_FLAG_SCI) &&
+		    (t->command =3D=3D ACPI_EC_COMMAND_QUERY)) {
+			t->flags |=3D ACPI_EC_COMMAND_POLL;
+			t->rdata[t->ri++] =3D 0x00;
+			t->flags |=3D ACPI_EC_COMMAND_COMPLETE;
+			pr_debug("software QR_EC completion\n");
+			wakeup =3D true;
+		} else if ((status & ACPI_EC_FLAG_IBF) =3D=3D 0) {
 			acpi_ec_write_cmd(ec, t->command);
 			t->flags |=3D ACPI_EC_COMMAND_POLL;
 		} else
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 44a4434..43b0acf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -463,6 +463,7 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
=20
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
+	{ PCI_VDEVICE(PROMISE, 0x3781), board_ahci },   /* FastTrak TX8660 ahci-m=
ode */
=20
 	/* Asmedia */
 	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index e265f83..19759d3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -586,7 +586,7 @@ static int scc_wait_after_reset(struct ata_link *link, =
unsigned int devmask,
  *	Note: Original code is ata_bus_softreset().
  */
=20
-static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int de=
vmask,
+static int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
                                       unsigned long deadline)
 {
 	struct ata_ioports *ioaddr =3D &ap->ioaddr;
@@ -600,9 +600,7 @@ static unsigned int scc_bus_softreset(struct ata_port *=
ap, unsigned int devmask,
 	udelay(20);
 	out_be32(ioaddr->ctl_addr, ap->ctl);
=20
-	scc_wait_after_reset(&ap->link, devmask, deadline);
-
-	return 0;
+	return scc_wait_after_reset(&ap->link, devmask, deadline);
 }
=20
 /**
@@ -619,7 +617,8 @@ static int scc_softreset(struct ata_link *link, unsigne=
d int *classes,
 {
 	struct ata_port *ap =3D link->ap;
 	unsigned int slave_possible =3D ap->flags & ATA_FLAG_SLAVE_POSS;
-	unsigned int devmask =3D 0, err_mask;
+	unsigned int devmask =3D 0;
+	int rc;
 	u8 err;
=20
 	DPRINTK("ENTER\n");
@@ -635,9 +634,9 @@ static int scc_softreset(struct ata_link *link, unsigne=
d int *classes,
=20
 	/* issue bus reset */
 	DPRINTK("about to softreset, devmask=3D%x\n", devmask);
-	err_mask =3D scc_bus_softreset(ap, devmask, deadline);
-	if (err_mask) {
-		ata_port_err(ap, "SRST failed (err_mask=3D0x%x)\n", err_mask);
+	rc =3D scc_bus_softreset(ap, devmask, deadline);
+	if (rc) {
+		ata_port_err(ap, "SRST failed (err_mask=3D0x%x)\n", rc);
 		return -EIO;
 	}
=20
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 0d91655..c234b9e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -533,11 +533,10 @@ EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 void tpm_get_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_cmd_t tpm_cmd;
-	struct timeout_t *timeout_cap;
+	unsigned long new_timeout[4];
+	unsigned long old_timeout[4];
 	struct duration_t *duration_cap;
 	ssize_t rc;
-	u32 timeout;
-	unsigned int scale =3D 1;
=20
 	tpm_cmd.header.in =3D tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap =3D TPM_CAP_PROP;
@@ -554,25 +553,46 @@ void tpm_get_timeouts(struct tpm_chip *chip)
 	    !=3D sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
 		return;
=20
-	timeout_cap =3D &tpm_cmd.params.getcap_out.cap.timeout;
-	/* Don't overwrite default if value is 0 */
-	timeout =3D be32_to_cpu(timeout_cap->a);
-	if (timeout && timeout < 1000) {
-		/* timeouts in msec rather usec */
-		scale =3D 1000;
-		chip->vendor.timeout_adjusted =3D true;
+	old_timeout[0] =3D be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
+	old_timeout[1] =3D be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
+	old_timeout[2] =3D be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
+	old_timeout[3] =3D be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
+	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
+
+	/*
+	 * Provide ability for vendor overrides of timeout values in case
+	 * of misreporting.
+	 */
+	if (chip->vendor.update_timeouts !=3D NULL)
+		chip->vendor.timeout_adjusted =3D
+			chip->vendor.update_timeouts(chip, new_timeout);
+
+	if (!chip->vendor.timeout_adjusted) {
+		/* Don't overwrite default if value is 0 */
+		if (new_timeout[0] !=3D 0 && new_timeout[0] < 1000) {
+			int i;
+
+			/* timeouts in msec rather usec */
+			for (i =3D 0; i !=3D ARRAY_SIZE(new_timeout); i++)
+				new_timeout[i] *=3D 1000;
+			chip->vendor.timeout_adjusted =3D true;
+		}
 	}
-	if (timeout)
-		chip->vendor.timeout_a =3D usecs_to_jiffies(timeout * scale);
-	timeout =3D be32_to_cpu(timeout_cap->b);
-	if (timeout)
-		chip->vendor.timeout_b =3D usecs_to_jiffies(timeout * scale);
-	timeout =3D be32_to_cpu(timeout_cap->c);
-	if (timeout)
-		chip->vendor.timeout_c =3D usecs_to_jiffies(timeout * scale);
-	timeout =3D be32_to_cpu(timeout_cap->d);
-	if (timeout)
-		chip->vendor.timeout_d =3D usecs_to_jiffies(timeout * scale);
+
+	/* Report adjusted timeouts */
+	if (chip->vendor.timeout_adjusted) {
+		dev_info(chip->dev,
+			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->=
%luus D %lu->%luus\n",
+			 old_timeout[0], new_timeout[0],
+			 old_timeout[1], new_timeout[1],
+			 old_timeout[2], new_timeout[2],
+			 old_timeout[3], new_timeout[3]);
+	}
+
+	chip->vendor.timeout_a =3D usecs_to_jiffies(new_timeout[0]);
+	chip->vendor.timeout_b =3D usecs_to_jiffies(new_timeout[1]);
+	chip->vendor.timeout_c =3D usecs_to_jiffies(new_timeout[2]);
+	chip->vendor.timeout_d =3D usecs_to_jiffies(new_timeout[3]);
=20
 duration:
 	tpm_cmd.header.in =3D tpm_getcap_header;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 9c4163c..befbe67 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -80,6 +80,9 @@ struct tpm_vendor_specific {
 	int (*send) (struct tpm_chip *, u8 *, size_t);
 	void (*cancel) (struct tpm_chip *);
 	u8 (*status) (struct tpm_chip *);
+	bool (*update_timeouts)(struct tpm_chip *chip,
+				unsigned long *timeout_cap);
+
 	void (*release) (struct device *);
 	struct miscdevice miscdev;
 	struct attribute_group *attr_group;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e5282..f8e94fe 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -396,6 +396,36 @@ out_err:
 	return rc;
 }
=20
+struct tis_vendor_timeout_override {
+	u32 did_vid;
+	unsigned long timeout_us[4];
+};
+
+static const struct tis_vendor_timeout_override vendor_timeout_overrides[]=
 =3D {
+	/* Atmel 3204 */
+	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
+			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
+};
+
+static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
+				    unsigned long *timeout_cap)
+{
+	int i;
+	u32 did_vid;
+
+	did_vid =3D ioread32(chip->vendor.iobase + TPM_DID_VID(0));
+
+	for (i =3D 0; i !=3D ARRAY_SIZE(vendor_timeout_overrides); i++) {
+		if (vendor_timeout_overrides[i].did_vid !=3D did_vid)
+			continue;
+		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
+		       sizeof(vendor_timeout_overrides[i].timeout_us));
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Early probing for iTPM with STS_DATA_EXPECT flaw.
  * Try sending command without itpm flag set and if that
@@ -483,6 +513,7 @@ static struct tpm_vendor_specific tpm_tis =3D {
 	.recv =3D tpm_tis_recv,
 	.send =3D tpm_tis_send,
 	.cancel =3D tpm_tis_ready,
+	.update_timeouts =3D tpm_tis_update_timeouts,
 	.req_complete_mask =3D TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val =3D TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled =3D TPM_STS_COMMAND_READY,
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index 5efba47..9b3f787 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2765,6 +2765,7 @@ static u32 evergreen_get_ih_wptr(struct radeon_device=
 *rdev)
 		tmp =3D RREG32(IH_RB_CNTL);
 		tmp |=3D IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &=3D ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index f7e3cc0..ab46a99 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3280,6 +3280,7 @@ static u32 r600_get_ih_wptr(struct radeon_device *rde=
v)
 		tmp =3D RREG32(IH_RB_CNTL);
 		tmp |=3D IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &=3D ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/rad=
eon/radeon_atombios.c
index e4e455e..6d9c32b 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1873,7 +1873,7 @@ static const char *thermal_controller_names[] =3D {
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"asc7xxx",
 };
@@ -1884,7 +1884,7 @@ static const char *pp_lib_thermal_controller_names[] =
=3D {
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"RV6xx",
 	"RV770",
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm=
_page_alloc.c
index 9e4313e..508c64c 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -398,13 +398,18 @@ static int ttm_pool_get_num_unused_pages(void)
 static int ttm_pool_mm_shrink(struct shrinker *shrink,
 			      struct shrink_control *sc)
 {
-	static atomic_t start_pool =3D ATOMIC_INIT(0);
+	static DEFINE_MUTEX(lock);
+	static unsigned start_pool;
 	unsigned i;
-	unsigned pool_offset =3D atomic_add_return(1, &start_pool);
+	unsigned pool_offset;
 	struct ttm_page_pool *pool;
 	int shrink_pages =3D sc->nr_to_scan;
=20
-	pool_offset =3D pool_offset % NUM_POOLS;
+	if (shrink_pages =3D=3D 0)
+		goto out;
+	if (!mutex_trylock(&lock))
+		return -1;
+	pool_offset =3D ++start_pool % NUM_POOLS;
 	/* select start pool in round robin fashion */
 	for (i =3D 0; i < NUM_POOLS; ++i) {
 		unsigned nr_free =3D shrink_pages;
@@ -413,6 +418,8 @@ static int ttm_pool_mm_shrink(struct shrinker *shrink,
 		pool =3D &_manager->pools[(i + pool_offset)%NUM_POOLS];
 		shrink_pages =3D ttm_page_pool_free(pool, nr_free);
 	}
+	mutex_unlock(&lock);
+out:
 	/* return estimated number of unused pages in pool */
 	return ttm_pool_get_num_unused_pages();
 }
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index 888ece6..f870bb3 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -29,7 +29,7 @@
 static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >=3D 17 && rdesc[11] =3D=3D 0x3c && rdesc[12] =3D=3D 0x02) {
+	if (*rsize >=3D 18 && rdesc[11] =3D=3D 0x3c && rdesc[12] =3D=3D 0x02) {
 		hid_info(hdev, "fixing up Cherry Cymotion report descriptor\n");
 		rdesc[11] =3D rdesc[16] =3D 0xff;
 		rdesc[12] =3D rdesc[17] =3D 0x03;
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index f2ba9ef..25dfb5f 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -26,7 +26,7 @@
 static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >=3D 74 &&
+	if (*rsize >=3D 75 &&
 		rdesc[61] =3D=3D 0x05 && rdesc[62] =3D=3D 0x08 &&
 		rdesc[63] =3D=3D 0x19 && rdesc[64] =3D=3D 0x08 &&
 		rdesc[65] =3D=3D 0x29 && rdesc[66] =3D=3D 0x0f &&
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index e7a7bd1..3ad6cd4 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -111,14 +111,14 @@ static __u8 *lg_report_fixup(struct hid_device *hdev,=
 __u8 *rdesc,
 {
 	unsigned long quirks =3D (unsigned long)hid_get_drvdata(hdev);
=20
-	if ((quirks & LG_RDESC) && *rsize >=3D 90 && rdesc[83] =3D=3D 0x26 &&
+	if ((quirks & LG_RDESC) && *rsize >=3D 91 && rdesc[83] =3D=3D 0x26 &&
 			rdesc[84] =3D=3D 0x8c && rdesc[85] =3D=3D 0x02) {
 		hid_info(hdev,
 			 "fixing up Logitech keyboard report descriptor\n");
 		rdesc[84] =3D rdesc[89] =3D 0x4d;
 		rdesc[85] =3D rdesc[90] =3D 0x10;
 	}
-	if ((quirks & LG_RDESC_REL_ABS) && *rsize >=3D 50 &&
+	if ((quirks & LG_RDESC_REL_ABS) && *rsize >=3D 51 &&
 			rdesc[32] =3D=3D 0x81 && rdesc[33] =3D=3D 0x06 &&
 			rdesc[49] =3D=3D 0x81 && rdesc[50] =3D=3D 0x06) {
 		hid_info(hdev,
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 828a0dd..488a21a 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -230,13 +230,6 @@ static void logi_dj_recv_add_djhid_device(struct dj_re=
ceiver_dev *djrcv_dev,
 		return;
 	}
=20
-	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
-	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
-		dev_err(&djrcv_hdev->dev, "%s: invalid device index:%d\n",
-			__func__, dj_report->device_index);
-		return;
-	}
-
 	if (djrcv_dev->paired_dj_devices[dj_report->device_index]) {
 		/* The device is already known. No need to reallocate it. */
 		dbg_hid("%s: device is already known\n", __func__);
@@ -686,7 +679,6 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	struct dj_receiver_dev *djrcv_dev =3D hid_get_drvdata(hdev);
 	struct dj_report *dj_report =3D (struct dj_report *) data;
 	unsigned long flags;
-	bool report_processed =3D false;
=20
 	dbg_hid("%s, size:%d\n", __func__, size);
=20
@@ -714,27 +706,41 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	 * anything else with it.
 	 */
=20
+	/* case 1) */
+	if (data[0] !=3D REPORT_ID_DJ_SHORT)
+		return false;
+
+	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
+	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
+		/*
+		 * Device index is wrong, bail out.
+		 * This driver can ignore safely the receiver notifications,
+		 * so ignore those reports too.
+		 */
+		if (dj_report->device_index !=3D DJ_RECEIVER_INDEX)
+			dev_err(&hdev->dev, "%s: invalid device index:%d\n",
+				__func__, dj_report->device_index);
+		return false;
+	}
+
 	spin_lock_irqsave(&djrcv_dev->lock, flags);
-	if (dj_report->report_id =3D=3D REPORT_ID_DJ_SHORT) {
-		switch (dj_report->report_type) {
-		case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
-		case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
-			logi_dj_recv_queue_notification(djrcv_dev, dj_report);
-			break;
-		case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
-			if (dj_report->report_params[CONNECTION_STATUS_PARAM_STATUS] =3D=3D
-			    STATUS_LINKLOSS) {
-				logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
-			}
-			break;
-		default:
-			logi_dj_recv_forward_report(djrcv_dev, dj_report);
+	switch (dj_report->report_type) {
+	case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
+	case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
+		logi_dj_recv_queue_notification(djrcv_dev, dj_report);
+		break;
+	case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
+		if (dj_report->report_params[CONNECTION_STATUS_PARAM_STATUS] =3D=3D
+		    STATUS_LINKLOSS) {
+			logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
 		}
-		report_processed =3D true;
+		break;
+	default:
+		logi_dj_recv_forward_report(djrcv_dev, dj_report);
 	}
 	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
=20
-	return report_processed;
+	return true;
 }
=20
 static int logi_dj_probe(struct hid_device *hdev,
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index 4a40003..daeb0aa 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -27,6 +27,7 @@
=20
 #define DJ_MAX_PAIRED_DEVICES			6
 #define DJ_MAX_NUMBER_NOTIFICATIONS		8
+#define DJ_RECEIVER_INDEX			0
 #define DJ_DEVICE_INDEX_MIN 			1
 #define DJ_DEVICE_INDEX_MAX 			6
=20
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 7cf3ffe..81356f6 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -308,6 +308,11 @@ static int magicmouse_raw_event(struct hid_device *hde=
v,
 		if (size < 4 || ((size - 4) % 9) !=3D 0)
 			return 0;
 		npoints =3D (size - 4) / 9;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for TRACKPAD_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches =3D 0;
 		for (ii =3D 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
@@ -331,6 +336,11 @@ static int magicmouse_raw_event(struct hid_device *hde=
v,
 		if (size < 6 || ((size - 6) % 8) !=3D 0)
 			return 0;
 		npoints =3D (size - 6) / 8;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for MOUSE_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches =3D 0;
 		for (ii =3D 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index dedf757..eb0271e 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -25,7 +25,7 @@
 static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >=3D 30 && rdesc[29] =3D=3D 0x05 && rdesc[30] =3D=3D 0x09) {
+	if (*rsize >=3D 31 && rdesc[29] =3D=3D 0x05 && rdesc[30] =3D=3D 0x09) {
 		hid_info(hdev, "fixing up button/consumer in HID report descriptor\n");
 		rdesc[30] =3D 0x0c;
 	}
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index f1ea3ff..99f317a 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -26,7 +26,7 @@
 static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >=3D 60 && rdesc[39] =3D=3D 0x2a && rdesc[40] =3D=3D 0xf5 &&
+	if (*rsize >=3D 62 && rdesc[39] =3D=3D 0x2a && rdesc[40] =3D=3D 0xf5 &&
 			rdesc[41] =3D=3D 0x00 && rdesc[59] =3D=3D 0x26 &&
 			rdesc[60] =3D=3D 0xf9 && rdesc[61] =3D=3D 0x00) {
 		hid_info(hdev, "fixing up Petalynx Maxter Remote report descriptor\n");
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 1daeaca..c952131 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -2382,6 +2382,12 @@ static int picolcd_raw_event(struct hid_device *hdev=
,
 	if (!data)
 		return 1;
=20
+	if (size > 64) {
+		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
+				size);
+		return 0;
+	}
+
 	if (report->id =3D=3D REPORT_KEY_STATE) {
 		if (data->input_keys)
 			ret =3D picolcd_raw_keypad(data, report, raw_data+1, size-1);
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index d484a00..3d6ae7b 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -25,7 +25,7 @@
 static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >=3D 107 && rdesc[104] =3D=3D 0x26 && rdesc[105] =3D=3D 0x80 &=
&
+	if (*rsize >=3D 112 && rdesc[104] =3D=3D 0x26 && rdesc[105] =3D=3D 0x80 &=
&
 			rdesc[106] =3D=3D 0x03) {
 		hid_info(hdev, "fixing up Sunplus Wireless Desktop report descriptor\n")=
;
 		rdesc[105] =3D rdesc[110] =3D 0x03;
diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index dd87ae9..2f14cad 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -186,7 +186,7 @@ static int ads1015_get_channels_config_of(struct i2c_cl=
ient *client)
 		}
=20
 		channel =3D be32_to_cpup(property);
-		if (channel > ADS1015_CHANNELS) {
+		if (channel >=3D ADS1015_CHANNELS) {
 			dev_err(&client->dev,
 				"invalid channel index %d on %s\n",
 				channel, node->full_name);
@@ -200,6 +200,7 @@ static int ads1015_get_channels_config_of(struct i2c_cl=
ient *client)
 				dev_err(&client->dev,
 					"invalid gain on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
=20
@@ -210,6 +211,7 @@ static int ads1015_get_channels_config_of(struct i2c_cl=
ient *client)
 				dev_err(&client->dev,
 					"invalid data_rate on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
=20
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 75be6c4..b7f3356 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -360,11 +360,13 @@ static ssize_t set_pwm1_enable(
 	if (config)
 		return config;
=20
+	mutex_lock(&data->update_lock);
 	config =3D i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
 	if (config < 0) {
 			dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
-			return -EIO;
+			count =3D config;
+			goto unlock;
 	}
=20
 	switch (val) {
@@ -381,14 +383,15 @@ static ssize_t set_pwm1_enable(
 		config |=3D AMC6821_CONF1_FDRC1;
 		break;
 	default:
-		return -EINVAL;
+		count =3D -EINVAL;
+		goto unlock;
 	}
-	mutex_lock(&data->update_lock);
 	if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF1, config)) {
 			dev_err(&client->dev,
 			"Configuration register write error, aborting.\n");
 			count =3D -EIO;
 	}
+unlock:
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -495,8 +498,9 @@ static ssize_t set_temp_auto_point_temp(
 		return -EINVAL;
 	}
=20
-	data->valid =3D 0;
 	mutex_lock(&data->update_lock);
+	data->valid =3D 0;
+
 	switch (ix) {
 	case 0:
 		ptemp[0] =3D SENSORS_LIMIT(val / 1000, 0,
@@ -669,13 +673,14 @@ static ssize_t set_fan1_div(
 	if (config)
 		return config;
=20
+	mutex_lock(&data->update_lock);
 	config =3D i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
 	if (config < 0) {
 		dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
-		return -EIO;
+		count =3D config;
+		goto EXIT;
 	}
-	mutex_lock(&data->update_lock);
 	switch (val) {
 	case 2:
 		config &=3D ~AMC6821_CONF4_PSPR;
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 9ba38f3..05c4f47 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -195,7 +195,7 @@ static int get_fan_speed_index(struct gpio_fan_data *fa=
n_data)
 	return -EINVAL;
 }
=20
-static int rpm_to_speed_index(struct gpio_fan_data *fan_data, int rpm)
+static int rpm_to_speed_index(struct gpio_fan_data *fan_data, unsigned lon=
g rpm)
 {
 	struct gpio_fan_speed *speed =3D fan_data->speed;
 	int i;
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index a42a7b0..5ce5d5a 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -102,7 +102,7 @@ static inline int FAN_FROM_REG(u8 val, int div)
=20
 /* TEMP: mC (-128C to +127C)
    REG: 1C/bit, two's complement */
-static inline s8 TEMP_TO_REG(int val)
+static inline s8 TEMP_TO_REG(long val)
 {
 	int nval =3D SENSORS_LIMIT(val, -128000, 127000) ;
 	return nval<0 ? (nval-500)/1000 : (nval+500)/1000;
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index da72dc1..97bfba2 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -157,7 +157,7 @@ static inline u16 FAN_TO_REG(unsigned long val)
=20
 /* Temperature is reported in .001 degC increments */
 #define TEMP_TO_REG(val)	\
-		SENSORS_LIMIT(SCALE(val, 1000, 1), -127, 127)
+		DIV_ROUND_CLOSEST(SENSORS_LIMIT((val), -127000, 127000), 1000)
 #define TEMPEXT_FROM_REG(val, ext)	\
 		SCALE(((val) << 4) + (ext), 16, 1000)
 #define TEMP_FROM_REG(val)	((val) * 1000)
@@ -190,7 +190,7 @@ static const int lm85_range_map[] =3D {
 	13300, 16000, 20000, 26600, 32000, 40000, 53300, 80000
 };
=20
-static int RANGE_TO_REG(int range)
+static int RANGE_TO_REG(long range)
 {
 	int i;
=20
@@ -212,7 +212,7 @@ static const int adm1027_freq_map[8] =3D { /* 1 Hz */
 	11, 15, 22, 29, 35, 44, 59, 88
 };
=20
-static int FREQ_TO_REG(const int *map, int freq)
+static int FREQ_TO_REG(const int *map, unsigned long freq)
 {
 	int i;
=20
@@ -443,7 +443,13 @@ static ssize_t store_vrm_reg(struct device *dev, struc=
t device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct lm85_data *data =3D dev_get_drvdata(dev);
-	data->vrm =3D simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+
+	val =3D simple_strtoul(buf, NULL, 10);
+	if (val > 255)
+		return -EINVAL;
+
+	data->vrm =3D val;
 	return count;
 }
=20
diff --git a/drivers/hwmon/lm92.c b/drivers/hwmon/lm92.c
index 8fcbd4d4..5d091fa 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -73,12 +73,9 @@ static inline int TEMP_FROM_REG(s16 reg)
 	return reg / 8 * 625 / 10;
 }
=20
-static inline s16 TEMP_TO_REG(int val)
+static inline s16 TEMP_TO_REG(long val)
 {
-	if (val <=3D -60000)
-		return -60000 * 10 / 625 * 8;
-	if (val >=3D 160000)
-		return 160000 * 10 / 625 * 8;
+	val =3D clamp_val(val, -60000, 160000);
 	return val * 10 / 625 * 8;
 }
=20
@@ -192,10 +189,12 @@ static ssize_t set_temp1_crit_hyst(struct device *dev=
, struct device_attribute *
 	struct lm92_data *data =3D i2c_get_clientdata(client);
 	long val =3D simple_strtol(buf, NULL, 10);
=20
+	val =3D clamp_val(val, -120000, 220000);
 	mutex_lock(&data->update_lock);
-	data->temp1_hyst =3D TEMP_FROM_REG(data->temp1_crit) - val;
+	 data->temp1_hyst =3D
+		TEMP_TO_REG(TEMP_FROM_REG(data->temp1_crit) - val);
 	i2c_smbus_write_word_swapped(client, LM92_REG_TEMP_HYST,
-				     TEMP_TO_REG(data->temp1_hyst));
+				     data->temp1_hyst);
 	mutex_unlock(&data->update_lock);
 	return count;
 }
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 5ab6953..029a2e1 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -149,7 +149,7 @@ static inline int TEMP_FROM_REG(s8 val)
 {
 	return val * 830 + 52120;
 }
-static inline s8 TEMP_TO_REG(int val)
+static inline s8 TEMP_TO_REG(long val)
 {
 	int nval =3D SENSORS_LIMIT(val, -54120, 157530) ;
 	return nval<0 ? (nval-5212-415)/830 : (nval-5212+415)/830;
diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index 40b2667..7d1373d 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -84,7 +84,7 @@ static inline u8 IN_TO_REG(unsigned long val, int n)
    REG: 1C/bit, two's complement */
 static inline s8 TEMP_TO_REG(int val)
 {
-	return SENSORS_LIMIT(SCALE(val, 1, 1000), -128000, 127000);
+	return SCALE(SENSORS_LIMIT(val, -128000, 127000), 1, 1000);
 }
=20
 static inline int TEMP_FROM_REG(s8 val)
@@ -349,7 +349,13 @@ static ssize_t set_vrm(struct device *dev, struct devi=
ce_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct smsc47m192_data *data =3D dev_get_drvdata(dev);
-	data->vrm =3D simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+
+	val =3D simple_strtoul(buf, NULL, 10);
+	if (val > 255)
+		return -EINVAL;
+=20
+	data->vrm =3D val;
 	return count;
 }
 static DEVICE_ATTR(vrm, S_IRUGO | S_IWUSR, show_vrm, set_vrm);
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.=
c
index 1a696f7..2882556 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -46,6 +46,7 @@
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
=20
 #include <rdma/iw_cm.h>
 #include <rdma/ib_addr.h>
@@ -65,6 +66,20 @@ struct iwcm_work {
 	struct list_head free_list;
 };
=20
+static unsigned int default_backlog =3D 256;
+
+static struct ctl_table_header *iwcm_ctl_table_hdr;
+static struct ctl_table iwcm_ctl_table[] =3D {
+	{
+		.procname	=3D "default_backlog",
+		.data		=3D &default_backlog,
+		.maxlen		=3D sizeof(default_backlog),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec,
+	},
+	{ }
+};
+
 /*
  * The following services provide a mechanism for pre-allocating iwcm_work
  * elements.  The design pre-allocates them  based on the cm_id type:
@@ -419,6 +434,9 @@ int iw_cm_listen(struct iw_cm_id *cm_id, int backlog)
=20
 	cm_id_priv =3D container_of(cm_id, struct iwcm_id_private, id);
=20
+	if (!backlog)
+		backlog =3D default_backlog;
+
 	ret =3D alloc_work_entries(cm_id_priv, backlog);
 	if (ret)
 		return ret;
@@ -1014,17 +1032,33 @@ int iw_cm_init_qp_attr(struct iw_cm_id *cm_id,
 }
 EXPORT_SYMBOL(iw_cm_init_qp_attr);
=20
+static struct ctl_path iwcm_ctl_path[] =3D {
+	{ .procname =3D "net" },
+	{ .procname =3D "iw_cm" },
+	{ }
+};
+
 static int __init iw_cm_init(void)
 {
 	iwcm_wq =3D create_singlethread_workqueue("iw_cm_wq");
 	if (!iwcm_wq)
 		return -ENOMEM;
=20
+	iwcm_ctl_table_hdr =3D register_net_sysctl_table(&init_net,
+						       iwcm_ctl_path,
+						       iwcm_ctl_table);
+	if (!iwcm_ctl_table_hdr) {
+		pr_err("iw_cm: couldn't register sysctl paths\n");
+		destroy_workqueue(iwcm_wq);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
=20
 static void __exit iw_cm_cleanup(void)
 {
+	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
 }
=20
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6cc8e67..486982f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2592,14 +2592,16 @@ free_domains:
=20
 static void cleanup_domain(struct protection_domain *domain)
 {
-	struct iommu_dev_data *dev_data, *next;
+	struct iommu_dev_data *entry;
 	unsigned long flags;
=20
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
=20
-	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
-		__detach_device(dev_data);
-		atomic_set(&dev_data->bind, 0);
+	while (!list_empty(&domain->dev_list)) {
+		entry =3D list_first_entry(&domain->dev_list,
+					 struct iommu_dev_data, list);
+		__detach_device(entry);
+		atomic_set(&entry->bind, 0);
 	}
=20
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 276ef38..e83aa8e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2318,19 +2318,34 @@ static bool device_has_rmrr(struct pci_dev *dev)
 	return false;
 }
=20
+/*
+ * There are a couple cases where we need to restrict the functionality of
+ * devices associated with RMRRs.  The first is when evaluating a device f=
or
+ * identity mapping because problems exist when devices are moved in and o=
ut
+ * of domains and their respective RMRR information is lost.  This means t=
hat
+ * a device with associated RMRRs will never be in a "passthrough" domain.
+ * The second is use of the device through the IOMMU API.  This interface
+ * expects to have full control of the IOVA space for the device.  We cann=
ot
+ * satisfy both the requirement that RMRR access is maintained and have an
+ * unencumbered IOVA space.  We also have no ability to quiesce the device=
's
+ * use of the RMRR space or even inform the IOMMU API user of the restrict=
ion.
+ * We therefore prevent devices associated with an RMRR from participating=
 in
+ * the IOMMU API, which eliminates them from device assignment.
+ *
+ * In both cases we assume that PCI USB devices with RMRRs have them large=
ly
+ * for historical reasons and that the RMRR space is not actively used pos=
t
+ * boot.  This exclusion may change if vendors begin to abuse it.
+ */
+static bool device_is_rmrr_locked(struct pci_dev *pdev)
+{
+	return device_has_rmrr(pdev) &&
+		(pdev->class >> 8) !=3D PCI_CLASS_SERIAL_USB;
+}
+
 static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 {
=20
-	/*
-	 * We want to prevent any device associated with an RMRR from
-	 * getting placed into the SI Domain. This is done because
-	 * problems exist when devices are moved in and out of domains
-	 * and their respective RMRR info is lost. We exempt USB devices
-	 * from this process due to their usage of RMRRs that are known
-	 * to not be needed after BIOS hand-off to OS.
-	 */
-	if (device_has_rmrr(pdev) &&
-	    (pdev->class >> 8) !=3D PCI_CLASS_SERIAL_USB)
+	if (device_is_rmrr_locked(pdev))
 		return 0;
=20
 	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
@@ -3981,6 +3996,11 @@ static int intel_iommu_attach_device(struct iommu_do=
main *domain,
 	struct intel_iommu *iommu;
 	int addr_width;
=20
+	if (device_is_rmrr_locked(pdev)) {
+		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platf=
orm RMRR requirement.  Contact your platform vendor.\n");
+		return -EPERM;
+	}
+
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
 		struct dmar_domain *old_domain;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c706a7b..aec029a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1233,12 +1233,12 @@ static void error(struct mddev *mddev, struct md_rd=
ev *rdev)
 		mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	} else
 		set_bit(Faulty, &rdev->flags);
+	/*
+	 * if recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT
 	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6d05e26..abac83a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1272,11 +1272,11 @@ static void error(struct mddev *mddev, struct md_rd=
ev *rdev)
 		spin_lock_irqsave(&conf->device_lock, flags);
 		mddev->degraded++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
+	/*
+	 * If recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c963c4..c293d9c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3240,6 +3240,8 @@ static void handle_stripe(struct stripe_head *sh)
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)  &&
 				     s.failed =3D=3D 0))
diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/fro=
ntends/tda10071.c
index 0c37434..ba792849 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -644,6 +644,7 @@ static int tda10071_set_frontend(struct dvb_frontend *f=
e,
 	struct dtv_frontend_properties *c =3D &fe->dtv_property_cache;
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
+	fe_modulation_t modulation;
=20
 	dbg("%s: delivery_system=3D%d modulation=3D%d frequency=3D%d " \
 		"symbol_rate=3D%d inversion=3D%d pilot=3D%d rolloff=3D%d", __func__,
@@ -677,10 +678,13 @@ static int tda10071_set_frontend(struct dvb_frontend =
*fe,
=20
 	switch (c->delivery_system) {
 	case SYS_DVBS:
+		modulation =3D QPSK;
 		rolloff =3D 0;
 		pilot =3D 2;
 		break;
 	case SYS_DVBS2:
+		modulation =3D c->modulation;
+
 		switch (c->rolloff) {
 		case ROLLOFF_20:
 			rolloff =3D 2;
@@ -722,7 +726,7 @@ static int tda10071_set_frontend(struct dvb_frontend *f=
e,
=20
 	for (i =3D 0, mode =3D 0xff; i < ARRAY_SIZE(TDA10071_MODCOD); i++) {
 		if (c->delivery_system =3D=3D TDA10071_MODCOD[i].delivery_system &&
-			c->modulation =3D=3D TDA10071_MODCOD[i].modulation &&
+			modulation =3D=3D TDA10071_MODCOD[i].modulation &&
 			c->fec_inner =3D=3D TDA10071_MODCOD[i].fec) {
 			mode =3D TDA10071_MODCOD[i].val;
 			dbg("%s: mode found=3D%02x", __func__, mode);
diff --git a/drivers/media/video/gspca/pac7302.c b/drivers/media/video/gspc=
a/pac7302.c
index 6ddc769..ae433ef 100644
--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -1190,6 +1190,7 @@ static const struct usb_device_id device_table[] =3D =
{
 	{USB_DEVICE(0x093a, 0x2620)},
 	{USB_DEVICE(0x093a, 0x2621)},
 	{USB_DEVICE(0x093a, 0x2622), .driver_info =3D FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2623), .driver_info =3D FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2624), .driver_info =3D FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2625)},
 	{USB_DEVICE(0x093a, 0x2626)},
diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index c7382bb..65fc4af 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -1074,7 +1074,6 @@ static void ftl_add_mtd(struct mtd_blktrans_ops *tr, =
struct mtd_info *mtd)
 			return;
 	}
=20
-	ftl_freepart(partition);
 	kfree(partition);
 }
=20
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index b74cdf6..fed39de 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -455,6 +455,7 @@ static int macvlan_init(struct net_device *dev)
 				  (lowerdev->state & MACVLAN_STATE_MASK);
 	dev->features 		=3D lowerdev->features & MACVLAN_FEATURES;
 	dev->features		|=3D NETIF_F_LLTX;
+	dev->vlan_features	=3D lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->gso_max_size	=3D lowerdev->gso_max_size;
 	dev->iflink		=3D lowerdev->ifindex;
 	dev->hard_header_len	=3D lowerdev->hard_header_len;
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 2b349d3..c974581 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -281,7 +281,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct s=
k_buff *skb)
 	nf_reset(skb);
=20
 	skb->ip_summed =3D CHECKSUM_NONE;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	ip_send_check(iph);
=20
 	ip_local_out(skb);
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wir=
eless/ath/carl9170/carl9170.h
index 6cfbb41..8bcf6b9 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -265,6 +265,7 @@ struct ar9170 {
 	atomic_t rx_work_urbs;
 	atomic_t rx_pool_urbs;
 	kernel_ulong_t features;
+	bool usb_ep_cmd_is_bulk;
=20
 	/* firmware settings */
 	struct completion fw_load_wait;
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless=
/ath/carl9170/usb.c
index 333b69e..5538596 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -614,9 +614,16 @@ int __carl9170_exec_cmd(struct ar9170 *ar, struct carl=
9170_cmd *cmd,
 		goto err_free;
 	}
=20
-	usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
-		AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
-		carl9170_usb_cmd_complete, ar, 1);
+	if (ar->usb_ep_cmd_is_bulk)
+		usb_fill_bulk_urb(urb, ar->udev,
+				  usb_sndbulkpipe(ar->udev, AR9170_USB_EP_CMD),
+				  cmd, cmd->hdr.len + 4,
+				  carl9170_usb_cmd_complete, ar);
+	else
+		usb_fill_int_urb(urb, ar->udev,
+				 usb_sndintpipe(ar->udev, AR9170_USB_EP_CMD),
+				 cmd, cmd->hdr.len + 4,
+				 carl9170_usb_cmd_complete, ar, 1);
=20
 	if (free_buf)
 		urb->transfer_flags |=3D URB_FREE_BUFFER;
@@ -1025,9 +1032,10 @@ static void carl9170_usb_firmware_step2(const struct=
 firmware *fw,
 static int carl9170_usb_probe(struct usb_interface *intf,
 			      const struct usb_device_id *id)
 {
+	struct usb_endpoint_descriptor *ep;
 	struct ar9170 *ar;
 	struct usb_device *udev;
-	int err;
+	int i, err;
=20
 	err =3D usb_reset_device(interface_to_usbdev(intf));
 	if (err)
@@ -1043,6 +1051,21 @@ static int carl9170_usb_probe(struct usb_interface *=
intf,
 	ar->intf =3D intf;
 	ar->features =3D id->driver_info;
=20
+	/* We need to remember the type of endpoint 4 because it differs
+	 * between high- and full-speed configuration. The high-speed
+	 * configuration specifies it as interrupt and the full-speed
+	 * configuration as bulk endpoint. This information is required
+	 * later when sending urbs to that endpoint.
+	 */
+	for (i =3D 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
+		ep =3D &intf->cur_altsetting->endpoint[i].desc;
+
+		if (usb_endpoint_num(ep) =3D=3D AR9170_USB_EP_CMD &&
+		    usb_endpoint_dir_out(ep) &&
+		    usb_endpoint_type(ep) =3D=3D USB_ENDPOINT_XFER_BULK)
+			ar->usb_ep_cmd_is_bulk =3D true;
+	}
+
 	usb_set_intfdata(intf, ar);
 	SET_IEEE80211_DEV(ar->hw, &intf->dev);
=20
diff --git a/drivers/sbus/char/bbc_envctrl.c b/drivers/sbus/char/bbc_envctr=
l.c
index 160e751..0787b97 100644
--- a/drivers/sbus/char/bbc_envctrl.c
+++ b/drivers/sbus/char/bbc_envctrl.c
@@ -452,6 +452,9 @@ static void attach_one_temp(struct bbc_i2c_bus *bp, str=
uct platform_device *op,
 	if (!tp)
 		return;
=20
+	INIT_LIST_HEAD(&tp->bp_list);
+	INIT_LIST_HEAD(&tp->glob_list);
+
 	tp->client =3D bbc_i2c_attach(bp, op);
 	if (!tp->client) {
 		kfree(tp);
@@ -497,6 +500,9 @@ static void attach_one_fan(struct bbc_i2c_bus *bp, stru=
ct platform_device *op,
 	if (!fp)
 		return;
=20
+	INIT_LIST_HEAD(&fp->bp_list);
+	INIT_LIST_HEAD(&fp->glob_list);
+
 	fp->client =3D bbc_i2c_attach(bp, op);
 	if (!fp->client) {
 		kfree(fp);
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 5426682..7179f72 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -301,13 +301,18 @@ static struct bbc_i2c_bus * __init attach_one_i2c(str=
uct platform_device *op, in
 	if (!bp)
 		return NULL;
=20
+	INIT_LIST_HEAD(&bp->temps);
+	INIT_LIST_HEAD(&bp->fans);
+
 	bp->i2c_control_regs =3D of_ioremap(&op->resource[0], 0, 0x2, "bbc_i2c_re=
gs");
 	if (!bp->i2c_control_regs)
 		goto fail;
=20
-	bp->i2c_bussel_reg =3D of_ioremap(&op->resource[1], 0, 0x1, "bbc_i2c_buss=
el");
-	if (!bp->i2c_bussel_reg)
-		goto fail;
+	if (op->num_resources =3D=3D 2) {
+		bp->i2c_bussel_reg =3D of_ioremap(&op->resource[1], 0, 0x1, "bbc_i2c_bus=
sel");
+		if (!bp->i2c_bussel_reg)
+			goto fail;
+	}
=20
 	bp->waiting =3D 0;
 	init_waitqueue_head(&bp->wq);
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 546d46b..506a3ee 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -72,7 +72,7 @@ struct bfa_sge_s {
 } while (0)
=20
 #define bfa_swap_words(_x)  (	\
-	((_x) << 32) | ((_x) >> 32))
+	((u64)(_x) << 32) | ((u64)(_x) >> 32))
=20
 #ifdef __BIG_ENDIAN
 #define bfa_sge_to_be(_x)
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5b7e1bf..603a2cb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2769,7 +2769,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *=
h, void __user *argp)
 		}
 		if (ioc->Request.Type.Direction =3D=3D XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status =3D -ENOMEM;
+				status =3D -EFAULT;
 				goto cleanup1;
 			}
 		} else
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cd4ac38..0bdc4a7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -793,6 +793,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigne=
d int good_bytes)
 			scsi_next_command(cmd);
 			return;
 		}
+	} else if (blk_rq_bytes(req) =3D=3D 0 && result && !sense_deferred) {
+		/*
+		 * Certain non BLOCK_PC requests are commands that don't
+		 * actually transfer anything (FLUSH), so cannot use
+		 * good_bytes !=3D blk_rq_bytes(req) as the signal for an error.
+		 * This sets the error explicitly for the problem case.
+		 */
+		error =3D __scsi_error_from_host_byte(cmd, result);
 	}
=20
 	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_=
drv.c
index 8960f1a..c43a9e8 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/hyperv.h>
+#include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -1129,6 +1130,16 @@ static void storvsc_command_completion(struct hv_sto=
rvsc_request *request)
 	kmem_cache_free(host_dev->request_pool, cmd_request);
 }
=20
+/*
+ * The host guarantees to respond to each command, although I/O latencies =
might
+ * be unbounded on Azure.  Reset the timer unconditionally to give the hos=
t a
+ * chance to perform EH.
+ */
+static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scm=
nd)
+{
+	return BLK_EH_RESET_TIMER;
+}
+
 static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)
 {
 	bool allowed =3D true;
@@ -1305,6 +1316,7 @@ static struct scsi_host_template scsi_driver =3D {
 	.bios_param =3D		storvsc_get_chs,
 	.queuecommand =3D		storvsc_queuecommand,
 	.eh_host_reset_handler =3D	storvsc_host_reset_handler,
+	.eh_timed_out =3D		storvsc_eh_timed_out,
 	.slave_alloc =3D		storvsc_device_alloc,
 	.slave_configure =3D	storvsc_device_configure,
 	.cmd_per_lun =3D		1,
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.=
c
index 577599e..ed4259c 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -1083,7 +1083,7 @@ start:
         pDevice->byERPFlag &=3D ~(WLAN_SET_ERP_USE_PROTECTION(1));
     }
=20
-{
+    if (pDevice->eCommandState =3D=3D WLAN_ASSOCIATE_WAIT) {
        pDevice->byReAssocCount++;
    if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass !=3D true)) { =
 //10 sec timeout
                      printk("Re-association timeout!!!\n");
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index d8dd784..d540a06 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2679,6 +2679,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
     unsigned char byData =3D 0;
     int             ii=3D 0;
 //    unsigned char byRSSI;
+    unsigned long flags;
=20
=20
     MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
@@ -2704,7 +2705,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
=20
     handled =3D 1;
     MACvIntDisable(pDevice->PortOffset);
-    spin_lock_irq(&pDevice->lock);
+
+    spin_lock_irqsave(&pDevice->lock, flags);
=20
     //Make sure current page is 0
     VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
@@ -2952,7 +2954,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
         MACvSelectPage1(pDevice->PortOffset);
     }
=20
-    spin_unlock_irq(&pDevice->lock);
+    spin_unlock_irqrestore(&pDevice->lock, flags);
+
     MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
=20
     return IRQ_RETVAL(handled);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index 488214a..d7162a2 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -225,6 +225,9 @@ static void uart_shutdown(struct tty_struct *tty, struc=
t uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
+		if (uart_console(uport) && tty)
+			uport->cons->cflag =3D tty->termios->c_cflag;
+
 		if (!tty || (tty->termios->c_cflag & HUPCL))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
=20
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b5fa2a5..5d80bb9 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -156,6 +156,15 @@ receive_chars(struct uart_sunsab_port *up,
 	    (up->port.line =3D=3D up->port.cons->index))
 		saw_console_brk =3D 1;
=20
+	if (count =3D=3D 0) {
+		if (unlikely(stat->sreg.isr1 & SAB82532_ISR1_BRK)) {
+			stat->sreg.isr0 &=3D ~(SAB82532_ISR0_PERR |
+					     SAB82532_ISR0_FERR);
+			up->port.icount.brk++;
+			uart_handle_break(&up->port);
+		}
+	}
+
 	for (i =3D 0; i < count; i++) {
 		unsigned char ch =3D buf[i], flag;
=20
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 3807294..f08732b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2651,6 +2651,43 @@ static int finish_port_resume(struct usb_device *ude=
v)
 }
=20
 /*
+ * There are some SS USB devices which take longer time for link training.
+ * XHCI specs 4.19.4 says that when Link training is successful, port
+ * sets CSC bit to 1. So if SW reads port status before successful link
+ * training, then it will not find device to be present.
+ * USB Analyzer log with such buggy devices show that in some cases
+ * device switch on the RX termination after long delay of host enabling
+ * the VBUS. In few other cases it has been seen that device fails to
+ * negotiate link training in first attempt. It has been
+ * reported till now that few devices take as long as 2000 ms to train
+ * the link after host enabling its VBUS and termination. Following
+ * routine implements a 2000 ms timeout for link training. If in a case
+ * link trains before timeout, loop will exit earlier.
+ *
+ * FIXME: If a device was connected before suspend, but was removed
+ * while system was asleep, then the loop in the following routine will
+ * only exit at timeout.
+ *
+ * This routine should only be called when persist is enabled for a SS
+ * device.
+ */
+static int wait_for_ss_port_enable(struct usb_device *udev,
+		struct usb_hub *hub, int *port1,
+		u16 *portchange, u16 *portstatus)
+{
+	int status =3D 0, delay_ms =3D 0;
+
+	while (delay_ms < 2000) {
+		if (status || *portstatus & USB_PORT_STAT_CONNECTION)
+			break;
+		msleep(20);
+		delay_ms +=3D 20;
+		status =3D hub_port_status(hub, *port1, portstatus, portchange);
+	}
+	return status;
+}
+
+/*
  * usb_port_resume - re-activate a suspended usb device's upstream port
  * @udev: device to re-activate, not a root hub
  * Context: must be able to sleep; device not locked; pm locks held
@@ -2742,6 +2779,10 @@ int usb_port_resume(struct usb_device *udev, pm_mess=
age_t msg)
=20
 	clear_bit(port1, hub->busy_bits);
=20
+	if (udev->persist_enabled && hub_is_superspeed(hub->hdev))
+		status =3D wait_for_ss_port_enable(udev, hub, &port1, &portchange,
+				&portstatus);
+
 	status =3D check_port_resume_type(udev,
 			hub, port1, status, portchange, portstatus);
 	if (status =3D=3D 0)
@@ -3354,6 +3395,7 @@ static void hub_port_connect_change(struct usb_hub *h=
ub, int port1,
 			le16_to_cpu(hub->descriptor->wHubCharacteristics);
 	struct usb_device *udev;
 	int status, i;
+	static int unreliable_port =3D -1;
=20
 	dev_dbg (hub_dev,
 		"port %d, status %04x, change %04x, %s\n",
@@ -3415,10 +3457,11 @@ static void hub_port_connect_change(struct usb_hub =
*hub, int port1,
 				USB_PORT_STAT_C_ENABLE)) {
 		status =3D hub_port_debounce(hub, port1);
 		if (status < 0) {
-			if (printk_ratelimit())
+			if (port1 !=3D unreliable_port && printk_ratelimit())
 				dev_err(hub_dev, "connect-debounce failed, "
 						"port %d disabled\n", port1);
 			portstatus &=3D ~USB_PORT_STAT_CONNECTION;
+			unreliable_port =3D port1;
 		} else {
 			portstatus =3D status;
 		}
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index e0ae777..6c43152 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -294,8 +294,7 @@ static void periodic_unlink (struct ohci_hcd *ohci, str=
uct ed *ed)
  *  - ED_OPER: when there's any request queued, the ED gets rescheduled
  *    immediately.  HC should be working on them.
  *
- *  - ED_IDLE:  when there's no TD queue. there's no reason for the HC
- *    to care about this ED; safe to disable the endpoint.
+ *  - ED_IDLE: when there's no TD queue or the HC isn't running.
  *
  * When finish_unlinks() runs later, after SOF interrupt, it will often
  * complete one or more URB unlinks before making that state change.
@@ -909,6 +908,10 @@ rescan_all:
 		int			completed, modified;
 		__hc32			*prev;
=20
+		/* Is this ED already invisible to the hardware? */
+		if (ed->state =3D=3D ED_IDLE)
+			goto ed_idle;
+
 		/* only take off EDs that the HC isn't using, accounting for
 		 * frame counter wraps and EDs with partially retired TDs
 		 */
@@ -938,12 +941,20 @@ skip_ed:
 			}
 		}
=20
+		/* ED's now officially unlinked, hc doesn't see */
+		ed->state =3D ED_IDLE;
+		if (quirk_zfmicro(ohci) && ed->type =3D=3D PIPE_INTERRUPT)
+			ohci->eds_scheduled--;
+		ed->hwHeadP &=3D ~cpu_to_hc32(ohci, ED_H);
+		ed->hwNextED =3D 0;
+		wmb();
+		ed->hwINFO &=3D ~cpu_to_hc32(ohci, ED_SKIP | ED_DEQUEUE);
+ed_idle:
+
 		/* reentrancy:  if we drop the schedule lock, someone might
 		 * have modified this list.  normally it's just prepending
 		 * entries (which we'd ignore), but paranoia won't hurt.
 		 */
-		*last =3D ed->ed_next;
-		ed->ed_next =3D NULL;
 		modified =3D 0;
=20
 		/* unlink urbs as requested, but rescan the list after
@@ -1001,19 +1012,20 @@ rescan_this:
 		if (completed && !list_empty (&ed->td_list))
 			goto rescan_this;
=20
-		/* ED's now officially unlinked, hc doesn't see */
-		ed->state =3D ED_IDLE;
-		if (quirk_zfmicro(ohci) && ed->type =3D=3D PIPE_INTERRUPT)
-			ohci->eds_scheduled--;
-		ed->hwHeadP &=3D ~cpu_to_hc32(ohci, ED_H);
-		ed->hwNextED =3D 0;
-		wmb ();
-		ed->hwINFO &=3D ~cpu_to_hc32 (ohci, ED_SKIP | ED_DEQUEUE);
-
-		/* but if there's work queued, reschedule */
-		if (!list_empty (&ed->td_list)) {
-			if (HC_IS_RUNNING(ohci_to_hcd(ohci)->state))
-				ed_schedule (ohci, ed);
+		/*
+		 * If no TDs are queued, take ED off the ed_rm_list.
+		 * Otherwise, if the HC is running, reschedule.
+		 * If not, leave it on the list for further dequeues.
+		 */
+		if (list_empty(&ed->td_list)) {
+			*last =3D ed->ed_next;
+			ed->ed_next =3D NULL;
+		} else if (HC_IS_RUNNING(ohci_to_hcd(ohci)->state)) {
+			*last =3D ed->ed_next;
+			ed->ed_next =3D NULL;
+			ed_schedule(ohci, ed);
+		} else {
+			last =3D &ed->ed_next;
 		}
=20
 		if (modified)
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 15685c3..e9ce957 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -98,6 +98,10 @@ static void xhci_pci_quirks(struct device *dev, struct x=
hci_hcd *xhci)
 	/* AMD PLL quirk */
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_AMD && usb_amd_find_chipset_info())
 		xhci->quirks |=3D XHCI_AMD_PLL_FIX;
+
+	if (pdev->vendor =3D=3D PCI_VENDOR_ID_AMD)
+		xhci->quirks |=3D XHCI_TRUST_TX_LENGTH;
+
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
 			pdev->device =3D=3D PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
 		xhci->quirks |=3D XHCI_EP_LIMIT_QUIRK;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index bc5ee84..4b6abb6 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -572,9 +572,12 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci=
,
 	struct xhci_virt_device *dev =3D xhci->devs[slot_id];
 	struct xhci_virt_ep *ep =3D &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
-	struct xhci_generic_trb *trb;
+	struct xhci_segment *new_seg;
+	union xhci_trb *new_deq;
 	dma_addr_t addr;
 	u64 hw_dequeue;
+	bool cycle_found =3D false;
+	bool td_last_trb_found =3D false;
=20
 	ep_ring =3D xhci_triad_to_transfer_ring(xhci, slot_id,
 			ep_index, stream_id);
@@ -598,44 +601,45 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhc=
i,
 		hw_dequeue =3D le64_to_cpu(ep_ctx->deq);
 	}
=20
-	/* Find virtual address and segment of hardware dequeue pointer */
-	state->new_deq_seg =3D ep_ring->deq_seg;
-	state->new_deq_ptr =3D ep_ring->dequeue;
-	while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
-			!=3D (dma_addr_t)(hw_dequeue & ~0xf)) {
-		next_trb(xhci, ep_ring, &state->new_deq_seg,
-					&state->new_deq_ptr);
-		if (state->new_deq_ptr =3D=3D ep_ring->dequeue) {
-			WARN_ON(1);
-			return;
-		}
-	}
+	new_seg =3D ep_ring->deq_seg;
+	new_deq =3D ep_ring->dequeue;
+	state->new_cycle_state =3D hw_dequeue & 0x1;
+
 	/*
-	 * Find cycle state for last_trb, starting at old cycle state of
-	 * hw_dequeue. If there is only one segment ring, find_trb_seg() will
-	 * return immediately and cannot toggle the cycle state if this search
-	 * wraps around, so add one more toggle manually in that case.
+	 * We want to find the pointer, segment and cycle state of the new trb
+	 * (the one after current TD's last_trb). We know the cycle state at
+	 * hw_dequeue, so walk the ring until both hw_dequeue and last_trb are
+	 * found.
 	 */
-	state->new_cycle_state =3D hw_dequeue & 0x1;
-	if (ep_ring->first_seg =3D=3D ep_ring->first_seg->next &&
-			cur_td->last_trb < state->new_deq_ptr)
-		state->new_cycle_state ^=3D 0x1;
-
-	state->new_deq_ptr =3D cur_td->last_trb;
-	xhci_dbg(xhci, "Finding segment containing last TRB in TD.\n");
-	state->new_deq_seg =3D find_trb_seg(state->new_deq_seg,
-			state->new_deq_ptr, &state->new_cycle_state);
-	if (!state->new_deq_seg) {
-		WARN_ON(1);
-		return;
-	}
+	do {
+		if (!cycle_found && xhci_trb_virt_to_dma(new_seg, new_deq)
+		    =3D=3D (dma_addr_t)(hw_dequeue & ~0xf)) {
+			cycle_found =3D true;
+			if (td_last_trb_found)
+				break;
+		}
+		if (new_deq =3D=3D cur_td->last_trb)
+			td_last_trb_found =3D true;
+
+		if (cycle_found &&
+		    TRB_TYPE_LINK_LE32(new_deq->generic.field[3]) &&
+		    new_deq->generic.field[3] & cpu_to_le32(LINK_TOGGLE))
+			state->new_cycle_state ^=3D 0x1;
+
+		next_trb(xhci, ep_ring, &new_seg, &new_deq);
+
+		/* Search wrapped around, bail out */
+		if (new_deq =3D=3D ep->ring->dequeue) {
+			xhci_err(xhci, "Error: Failed finding new dequeue state\n");
+			state->new_deq_seg =3D NULL;
+			state->new_deq_ptr =3D NULL;
+			return;
+		}
+
+	} while (!cycle_found || !td_last_trb_found);
=20
-	/* Increment to find next TRB after last_trb. Cycle if appropriate. */
-	trb =3D &state->new_deq_ptr->generic;
-	if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
-	    (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
-		state->new_cycle_state ^=3D 0x1;
-	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
+	state->new_deq_seg =3D new_seg;
+	state->new_deq_ptr =3D new_deq;
=20
 	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "Cycle state =3D 0x%x\n", state->new_cycle_state);
@@ -2433,7 +2437,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * last TRB of the previous TD. The command completion handle
 		 * will take care the rest.
 		 */
-		if (!event_seg && trb_comp_code =3D=3D COMP_STOP_INVAL) {
+		if (!event_seg && (trb_comp_code =3D=3D COMP_STOP ||
+				   trb_comp_code =3D=3D COMP_STOP_INVAL)) {
 			ret =3D 0;
 			goto cleanup;
 		}
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 457a7ac..4cc1804 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2819,6 +2819,9 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 			ep_index, ep->stopped_stream, ep->stopped_td,
 			&deq_state);
=20
+	if (!deq_state.new_deq_ptr || !deq_state.new_deq_seg)
+		return;
+
 	/* HW with the reset endpoint quirk will use the saved dequeue state to
 	 * issue a configure endpoint command later.
 	 */
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbv=
ga/sisusb.c
index 7af163d..f1bfd01 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3248,6 +3248,7 @@ static const struct usb_device_id sisusb_table[] =3D =
{
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
 	{ USB_DEVICE(0x0711, 0x0950) },
+	{ USB_DEVICE(0x0711, 0x5200) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d6e6205..0d34f85 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -162,6 +162,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_BM_ATOM_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NXTCAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_EV3CON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_0_PID) },
@@ -684,6 +685,8 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
 	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACTIVE_ROBOTS_PID) },
@@ -956,6 +959,8 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* ekey Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 55af915..cbcb1e6 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -42,6 +42,8 @@
 /* www.candapter.com Ewert Energy Systems CANdapter device */
 #define FTDI_CANDAPTER_PID 0x9F80 /* Product Id */
=20
+#define FTDI_BM_ATOM_NANO_PID	0xa559	/* Basic Micro ATOM Nano USB2Serial *=
/
+
 /*
  * Texas Instruments XDS100v2 JTAG / BeagleBone A3
  * http://processors.wiki.ti.com/index.php/XDS100
@@ -140,12 +142,15 @@
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */
-#define XSENS_CONVERTER_0_PID	0xD388
-#define XSENS_CONVERTER_1_PID	0xD389
+#define XSENS_VID		0x2639
+#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+#define XSENS_MTW_PID		0x0200	/* Xsens MTw */
+#define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
+#define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
 #define XSENS_CONVERTER_2_PID	0xD38A
-#define XSENS_CONVERTER_3_PID	0xD38B
-#define XSENS_CONVERTER_4_PID	0xD38C
-#define XSENS_CONVERTER_5_PID	0xD38D
+#define XSENS_CONVERTER_3_PID	0xD38B	/* Xsens USB-serial converter */
+#define XSENS_CONVERTER_4_PID	0xD38C	/* Xsens Wireless Receiver */
+#define XSENS_CONVERTER_5_PID	0xD38D	/* Xsens Awinda Station */
 #define XSENS_CONVERTER_6_PID	0xD38E
 #define XSENS_CONVERTER_7_PID	0xD38F
=20
@@ -1369,3 +1374,8 @@
 #define BRAINBOXES_US_160_6_PID		0x9006 /* US-160 16xRS232 1Mbaud Port 11 =
and 12 */
 #define BRAINBOXES_US_160_7_PID		0x9007 /* US-160 16xRS232 1Mbaud Port 13 =
and 14 */
 #define BRAINBOXES_US_160_8_PID		0x9008 /* US-160 16xRS232 1Mbaud Port 15 =
and 16 */
+
+/*
+ * ekey biometric systems GmbH (http://ekey.net/)
+ */
+#define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 7a1c91e..d8360be 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -496,6 +496,10 @@ static void option_instat_callback(struct urb *urb);
 #define INOVIA_VENDOR_ID			0x20a6
 #define INOVIA_SEW858				0x1105
=20
+/* VIA Telecom */
+#define VIATELECOM_VENDOR_ID			0x15eb
+#define VIATELECOM_PRODUCT_CDS7			0x0001
+
 /* some devices interfaces need special handling due to a number of reason=
s */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE =3D 0,
@@ -1740,6 +1744,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D=
-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D=
-Link DWM-156/C1 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
+	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 45a288c..7ba38ea 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -51,6 +51,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_ZTEK) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 42bc082..71fd9da 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -22,6 +22,7 @@
 #define PL2303_PRODUCT_ID_GPRS		0x0609
 #define PL2303_PRODUCT_ID_HCR331	0x331a
 #define PL2303_PRODUCT_ID_MOTOROLA	0x0307
+#define PL2303_PRODUCT_ID_ZTEK		0xe1f1
=20
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-seria=
l.c
index 8f76a2b..803806c 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -791,29 +791,39 @@ int usb_serial_probe(struct usb_interface *interface,
 		if (usb_endpoint_is_bulk_in(endpoint)) {
 			/* we found a bulk in endpoint */
 			dbg("found bulk in on endpoint %d", i);
-			bulk_in_endpoint[num_bulk_in] =3D endpoint;
-			++num_bulk_in;
+			if (num_bulk_in < MAX_NUM_PORTS) {
+				bulk_in_endpoint[num_bulk_in] =3D endpoint;
+				++num_bulk_in;
+			}
 		}
=20
 		if (usb_endpoint_is_bulk_out(endpoint)) {
 			/* we found a bulk out endpoint */
 			dbg("found bulk out on endpoint %d", i);
-			bulk_out_endpoint[num_bulk_out] =3D endpoint;
-			++num_bulk_out;
+			if (num_bulk_out < MAX_NUM_PORTS) {
+				bulk_out_endpoint[num_bulk_out] =3D endpoint;
+				++num_bulk_out;
+			}
 		}
=20
 		if (usb_endpoint_is_int_in(endpoint)) {
 			/* we found a interrupt in endpoint */
 			dbg("found interrupt in on endpoint %d", i);
-			interrupt_in_endpoint[num_interrupt_in] =3D endpoint;
-			++num_interrupt_in;
+			if (num_interrupt_in < MAX_NUM_PORTS) {
+				interrupt_in_endpoint[num_interrupt_in] =3D
+						endpoint;
+				++num_interrupt_in;
+			}
 		}
=20
 		if (usb_endpoint_is_int_out(endpoint)) {
 			/* we found an interrupt out endpoint */
 			dbg("found interrupt out on endpoint %d", i);
-			interrupt_out_endpoint[num_interrupt_out] =3D endpoint;
-			++num_interrupt_out;
+			if (num_interrupt_out < MAX_NUM_PORTS) {
+				interrupt_out_endpoint[num_interrupt_out] =3D
+						endpoint;
+				++num_interrupt_out;
+			}
 		}
 	}
=20
@@ -836,8 +846,10 @@ int usb_serial_probe(struct usb_interface *interface,
 				if (usb_endpoint_is_int_in(endpoint)) {
 					/* we found a interrupt in endpoint */
 					dbg("found interrupt in for Prolific device on separate interface");
-					interrupt_in_endpoint[num_interrupt_in] =3D endpoint;
-					++num_interrupt_in;
+					if (num_interrupt_in < MAX_NUM_PORTS) {
+						interrupt_in_endpoint[num_interrupt_in] =3D endpoint;
+						++num_interrupt_in;
+					}
 				}
 			}
 		}
@@ -876,6 +888,11 @@ int usb_serial_probe(struct usb_interface *interface,
 			num_ports =3D type->num_ports;
 	}
=20
+	if (num_ports > MAX_NUM_PORTS) {
+		dev_warn(&interface->dev, "too many ports requested: %d\n", num_ports);
+		num_ports =3D MAX_NUM_PORTS;
+	}
+
 	serial->num_ports =3D num_ports;
 	serial->num_bulk_in =3D num_bulk_in;
 	serial->num_bulk_out =3D num_bulk_out;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.=
c
index 0ec60cd..5481809 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1006,6 +1006,10 @@ static void command_port_read_callback(struct urb *u=
rb)
 		dbg("%s - command_info is NULL, exiting.", __func__);
 		return;
 	}
+	if (!urb->actual_length) {
+		dev_dbg(&urb->dev->dev, "%s - empty response, exiting.\n", __func__);
+		return;
+	}
 	if (status) {
 		dbg("%s - nonzero urb status: %d", __func__, status);
 		if (status !=3D -ENOENT)
@@ -1027,7 +1031,8 @@ static void command_port_read_callback(struct urb *ur=
b)
 		/* These are unsolicited reports from the firmware, hence no
 		   waiting command to wakeup */
 		dbg("%s - event received", __func__);
-	} else if (data[0] =3D=3D WHITEHEAT_GET_DTR_RTS) {
+	} else if ((data[0] =3D=3D WHITEHEAT_GET_DTR_RTS) &&
+		(urb->actual_length - 1 <=3D sizeof(command_info->result_buffer))) {
 		memcpy(command_info->result_buffer, &data[1],
 						urb->actual_length - 1);
 		command_info->command_finished =3D WHITEHEAT_CMD_COMPLETE;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c7fb3a4..d7c9b68 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -717,7 +717,7 @@ again:
 				found_next =3D 1;
 			if (ret !=3D 0)
 				goto insert;
-			slot =3D 0;
+			slot =3D path->slots[0];
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
 		if (found_key.objectid !=3D BTRFS_EXTENT_CSUM_OBJECTID ||
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 20431b4..c0c51e1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1638,6 +1638,12 @@ unlink_target:
 				    target_dentry, toName);
 	}
=20
+	/* force revalidate to go get info when needed */
+	CIFS_I(source_dir)->time =3D CIFS_I(target_dir)->time =3D 0;
+
+	source_dir->i_ctime =3D source_dir->i_mtime =3D target_dir->i_ctime =3D
+		target_dir->i_mtime =3D current_fs_time(source_dir->i_sb);
+
 cifs_rename_exit:
 	kfree(info_buf_source);
 	kfree(fromName);
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index fb001cd..01951c6b 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -380,7 +380,7 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
  */
 void debugfs_remove_recursive(struct dentry *dentry)
 {
-	struct dentry *child, *next, *parent;
+	struct dentry *child, *parent;
=20
 	if (!dentry)
 		return;
@@ -392,31 +392,49 @@ void debugfs_remove_recursive(struct dentry *dentry)
 	parent =3D dentry;
  down:
 	mutex_lock(&parent->d_inode->i_mutex);
-	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child) {
+ loop:
+	/*
+	 * The parent->d_subdirs is protected by the d_lock. Outside that
+	 * lock, the child can be unlinked and set to be freed which can
+	 * use the d_u.d_child as the rcu head and corrupt this list.
+	 */
+	spin_lock(&parent->d_lock);
+	list_for_each_entry(child, &parent->d_subdirs, d_u.d_child) {
 		if (!debugfs_positive(child))
 			continue;
=20
 		/* perhaps simple_empty(child) makes more sense */
 		if (!list_empty(&child->d_subdirs)) {
+			spin_unlock(&parent->d_lock);
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent =3D child;
 			goto down;
 		}
- up:
+
+		spin_unlock(&parent->d_lock);
+
 		if (!__debugfs_remove(child, parent))
 			simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+
+		/*
+		 * The parent->d_lock protects agaist child from unlinking
+		 * from d_subdirs. When releasing the parent->d_lock we can
+		 * no longer trust that the next pointer is valid.
+		 * Restart the loop. We'll skip this one with the
+		 * debugfs_positive() check.
+		 */
+		goto loop;
 	}
+	spin_unlock(&parent->d_lock);
=20
 	mutex_unlock(&parent->d_inode->i_mutex);
 	child =3D parent;
 	parent =3D parent->d_parent;
 	mutex_lock(&parent->d_inode->i_mutex);
=20
-	if (child !=3D dentry) {
-		next =3D list_entry(child->d_u.d_child.next, struct dentry,
-					d_u.d_child);
-		goto up;
-	}
+	if (child !=3D dentry)
+		/* go up */
+		goto loop;
=20
 	if (!__debugfs_remove(child, parent))
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7168eeb..818b43e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3128,13 +3128,28 @@ static void ext4_mb_collect_stats(struct ext4_alloc=
ation_context *ac)
 static void ext4_discard_allocated_blocks(struct ext4_allocation_context *=
ac)
 {
 	struct ext4_prealloc_space *pa =3D ac->ac_pa;
-	int len;
+	struct ext4_buddy e4b;
+	int err;
=20
-	if (pa && pa->pa_type =3D=3D MB_INODE_PA) {
-		len =3D ac->ac_b_ex.fe_len;
-		pa->pa_free +=3D len;
+	if (pa =3D=3D NULL) {
+		err =3D ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
+		if (err) {
+			/*
+			 * This should never happen since we pin the
+			 * pages in the ext4_allocation_context so
+			 * ext4_mb_load_buddy() should never fail.
+			 */
+			WARN(1, "mb_load_buddy failed (%d)", err);
+			return;
+		}
+		ext4_lock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
+			       ac->ac_f_ex.fe_len);
+		ext4_unlock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		return;
 	}
-
+	if (pa->pa_type =3D=3D MB_INODE_PA)
+		pa->pa_free +=3D ac->ac_b_ex.fe_len;
 }
=20
 /*
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a5f25a7..2f9197f 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -68,7 +68,7 @@ static void isofs_put_super(struct super_block *sb)
 	return;
 }
=20
-static int isofs_read_inode(struct inode *);
+static int isofs_read_inode(struct inode *, int relocated);
 static int isofs_statfs (struct dentry *, struct kstatfs *);
=20
 static struct kmem_cache *isofs_inode_cachep;
@@ -1263,7 +1263,7 @@ out_toomany:
 	goto out;
 }
=20
-static int isofs_read_inode(struct inode *inode)
+static int isofs_read_inode(struct inode *inode, int relocated)
 {
 	struct super_block *sb =3D inode->i_sb;
 	struct isofs_sb_info *sbi =3D ISOFS_SB(sb);
@@ -1408,7 +1408,7 @@ static int isofs_read_inode(struct inode *inode)
 	 */
=20
 	if (!high_sierra) {
-		parse_rock_ridge_inode(de, inode);
+		parse_rock_ridge_inode(de, inode, relocated);
 		/* if we want uid/gid set, override the rock ridge setting */
 		if (sbi->s_uid_set)
 			inode->i_uid =3D sbi->s_uid;
@@ -1487,9 +1487,10 @@ static int isofs_iget5_set(struct inode *ino, void *=
data)
  * offset that point to the underlying meta-data for the inode.  The
  * code below is otherwise similar to the iget() code in
  * include/linux/fs.h */
-struct inode *isofs_iget(struct super_block *sb,
-			 unsigned long block,
-			 unsigned long offset)
+struct inode *__isofs_iget(struct super_block *sb,
+			   unsigned long block,
+			   unsigned long offset,
+			   int relocated)
 {
 	unsigned long hashval;
 	struct inode *inode;
@@ -1511,7 +1512,7 @@ struct inode *isofs_iget(struct super_block *sb,
 		return ERR_PTR(-ENOMEM);
=20
 	if (inode->i_state & I_NEW) {
-		ret =3D isofs_read_inode(inode);
+		ret =3D isofs_read_inode(inode, relocated);
 		if (ret < 0) {
 			iget_failed(inode);
 			inode =3D ERR_PTR(ret);
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 7d33de8..f9c9793 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -107,7 +107,7 @@ extern int iso_date(char *, int);
=20
 struct inode;		/* To make gcc happy */
=20
-extern int parse_rock_ridge_inode(struct iso_directory_record *, struct in=
ode *);
+extern int parse_rock_ridge_inode(struct iso_directory_record *, struct in=
ode *, int relocated);
 extern int get_rock_ridge_filename(struct iso_directory_record *, char *, =
struct inode *);
 extern int isofs_name_translate(struct iso_directory_record *, char *, str=
uct inode *);
=20
@@ -118,9 +118,24 @@ extern struct dentry *isofs_lookup(struct inode *, str=
uct dentry *, struct namei
 extern struct buffer_head *isofs_bread(struct inode *, sector_t);
 extern int isofs_get_blocks(struct inode *, sector_t, struct buffer_head *=
*, unsigned long);
=20
-extern struct inode *isofs_iget(struct super_block *sb,
-                                unsigned long block,
-                                unsigned long offset);
+struct inode *__isofs_iget(struct super_block *sb,
+			   unsigned long block,
+			   unsigned long offset,
+			   int relocated);
+
+static inline struct inode *isofs_iget(struct super_block *sb,
+				       unsigned long block,
+				       unsigned long offset)
+{
+	return __isofs_iget(sb, block, offset, 0);
+}
+
+static inline struct inode *isofs_iget_reloc(struct super_block *sb,
+					     unsigned long block,
+					     unsigned long offset)
+{
+	return __isofs_iget(sb, block, offset, 1);
+}
=20
 /* Because the inode number is no longer relevant to finding the
  * underlying meta-data for an inode, we are free to choose a more
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index 70e79d0..ee62cc0 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -288,12 +288,16 @@ eio:
 	goto out;
 }
=20
+#define RR_REGARD_XA 1
+#define RR_RELOC_DE 2
+
 static int
 parse_rock_ridge_inode_internal(struct iso_directory_record *de,
-				struct inode *inode, int regard_xa)
+				struct inode *inode, int flags)
 {
 	int symlink_len =3D 0;
 	int cnt, sig;
+	unsigned int reloc_block;
 	struct inode *reloc;
 	struct rock_ridge *rr;
 	int rootflag;
@@ -305,7 +309,7 @@ parse_rock_ridge_inode_internal(struct iso_directory_re=
cord *de,
=20
 	init_rock_state(&rs, inode);
 	setup_rock_ridge(de, inode, &rs);
-	if (regard_xa) {
+	if (flags & RR_REGARD_XA) {
 		rs.chr +=3D 14;
 		rs.len -=3D 14;
 		if (rs.len < 0)
@@ -485,12 +489,22 @@ repeat:
 					"relocated directory\n");
 			goto out;
 		case SIG('C', 'L'):
-			ISOFS_I(inode)->i_first_extent =3D
-			    isonum_733(rr->u.CL.location);
-			reloc =3D
-			    isofs_iget(inode->i_sb,
-				       ISOFS_I(inode)->i_first_extent,
-				       0);
+			if (flags & RR_RELOC_DE) {
+				printk(KERN_ERR
+				       "ISOFS: Recursive directory relocation "
+				       "is not supported\n");
+				goto eio;
+			}
+			reloc_block =3D isonum_733(rr->u.CL.location);
+			if (reloc_block =3D=3D ISOFS_I(inode)->i_iget5_block &&
+			    ISOFS_I(inode)->i_iget5_offset =3D=3D 0) {
+				printk(KERN_ERR
+				       "ISOFS: Directory relocation points to "
+				       "itself\n");
+				goto eio;
+			}
+			ISOFS_I(inode)->i_first_extent =3D reloc_block;
+			reloc =3D isofs_iget_reloc(inode->i_sb, reloc_block, 0);
 			if (IS_ERR(reloc)) {
 				ret =3D PTR_ERR(reloc);
 				goto out;
@@ -637,9 +651,11 @@ static char *get_symlink_chunk(char *rpnt, struct rock=
_ridge *rr, char *plimit)
 	return rpnt;
 }
=20
-int parse_rock_ridge_inode(struct iso_directory_record *de, struct inode *=
inode)
+int parse_rock_ridge_inode(struct iso_directory_record *de, struct inode *=
inode,
+			   int relocated)
 {
-	int result =3D parse_rock_ridge_inode_internal(de, inode, 0);
+	int flags =3D relocated ? RR_RELOC_DE : 0;
+	int result =3D parse_rock_ridge_inode_internal(de, inode, flags);
=20
 	/*
 	 * if rockridge flag was reset and we didn't look for attributes
@@ -647,7 +663,8 @@ int parse_rock_ridge_inode(struct iso_directory_record =
*de, struct inode *inode)
 	 */
 	if ((ISOFS_SB(inode->i_sb)->s_rock_offset =3D=3D -1)
 	    && (ISOFS_SB(inode->i_sb)->s_rock =3D=3D 2)) {
-		result =3D parse_rock_ridge_inode_internal(de, inode, 14);
+		result =3D parse_rock_ridge_inode_internal(de, inode,
+							 flags | RR_REGARD_XA);
 	}
 	return result;
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index ca4913a..a1e663d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2333,6 +2333,14 @@ long do_mount(char *dev_name, char *dir_name, char *=
type_page,
 	if (flags & MS_RDONLY)
 		mnt_flags |=3D MNT_READONLY;
=20
+	/* The default atime for remount is preservation */
+	if ((flags & MS_REMOUNT) &&
+	    ((flags & (MS_NOATIME | MS_NODIRATIME | MS_RELATIME |
+		       MS_STRICTATIME)) =3D=3D 0)) {
+		mnt_flags &=3D ~MNT_ATIME_MASK;
+		mnt_flags |=3D path.mnt->mnt_flags & MNT_ATIME_MASK;
+	}
+
 	flags &=3D ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5aea30a..c4a2a68 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2004,24 +2004,31 @@ static void nfs4_close_prepare(struct rpc_task *tas=
k, void *data)
 {
 	struct nfs4_closedata *calldata =3D data;
 	struct nfs4_state *state =3D calldata->state;
+	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close =3D 0;
=20
 	if (nfs_wait_on_sequence(calldata->arg.seqid, task) !=3D 0)
 		return;
=20
 	task->tk_msg.rpc_proc =3D &nfs4_procedures[NFSPROC4_CLNT_OPEN_DOWNGRADE];
-	calldata->arg.fmode =3D FMODE_READ|FMODE_WRITE;
 	spin_lock(&state->owner->so_lock);
+	is_rdwr =3D test_bit(NFS_O_RDWR_STATE, &state->flags);
+	is_rdonly =3D test_bit(NFS_O_RDONLY_STATE, &state->flags);
+	is_wronly =3D test_bit(NFS_O_WRONLY_STATE, &state->flags);
+	/* Calculate the current open share mode */
+	calldata->arg.fmode =3D 0;
+	if (is_rdonly || is_rdwr)
+		calldata->arg.fmode |=3D FMODE_READ;
+	if (is_wronly || is_rdwr)
+		calldata->arg.fmode |=3D FMODE_WRITE;
 	/* Calculate the change in open mode */
 	if (state->n_rdwr =3D=3D 0) {
 		if (state->n_rdonly =3D=3D 0) {
-			call_close |=3D test_bit(NFS_O_RDONLY_STATE, &state->flags);
-			call_close |=3D test_bit(NFS_O_RDWR_STATE, &state->flags);
+			call_close |=3D is_rdonly || is_rdwr;
 			calldata->arg.fmode &=3D ~FMODE_READ;
 		}
 		if (state->n_wronly =3D=3D 0) {
-			call_close |=3D test_bit(NFS_O_WRONLY_STATE, &state->flags);
-			call_close |=3D test_bit(NFS_O_RDWR_STATE, &state->flags);
+			call_close |=3D is_wronly || is_rdwr;
 			calldata->arg.fmode &=3D ~FMODE_WRITE;
 		}
 	}
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index eb71106..938a77f 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1916,15 +1916,19 @@ static int do_journal_release(struct reiserfs_trans=
action_handle *th,
 	}
=20
 	reiserfs_mounted_fs_count--;
-	/* wait for all commits to finish */
-	cancel_delayed_work(&SB_JOURNAL(sb)->j_work);
=20
 	/*
 	 * We must release the write lock here because
 	 * the workqueue job (flush_async_commit) needs this lock
 	 */
 	reiserfs_write_unlock(sb);
-	flush_workqueue(commit_wq);
+	/*
+	 * Cancel flushing of old commits. Note that this work will not
+	 * be requeued because superblock is being shutdown and doesn't
+	 * have MS_ACTIVE set.
+	 */
+	/* wait for all commits to finish */
+	cancel_delayed_work_sync(&SB_JOURNAL(sb)->j_work);
=20
 	if (!reiserfs_mounted_fs_count) {
 		destroy_workqueue(commit_wq);
@@ -4211,8 +4215,15 @@ static int do_journal_end(struct reiserfs_transactio=
n_handle *th,
 	if (flush) {
 		flush_commit_list(sb, jl, 1);
 		flush_journal_list(sb, jl, 1);
-	} else if (!(jl->j_state & LIST_COMMIT_PENDING))
-		queue_delayed_work(commit_wq, &journal->j_work, HZ / 10);
+	} else if (!(jl->j_state & LIST_COMMIT_PENDING)) {
+		/*
+		 * Avoid queueing work when sb is being shut down. Transaction
+		 * will be flushed on journal shutdown.
+		 */
+		if (sb->s_flags & MS_ACTIVE)
+			queue_delayed_work(commit_wq,
+					   &journal->j_work, HZ / 10);
+	}
=20
 	/* if the next transaction has any chance of wrapping, flush
 	 ** transactions that might get overwritten.  If any journal lists are ve=
ry
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index f85c5ab..11670e3 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -205,7 +205,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_st=
ruct *vma,
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
-extern unsigned slab_node(struct mempolicy *policy);
+extern unsigned slab_node(void);
=20
 extern enum zone_type policy_zone;
=20
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 33fe53d..fc17c4d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -43,6 +43,7 @@ struct mnt_namespace;
  */
 #define MNT_SHARED_MASK	(MNT_UNBINDABLE)
 #define MNT_PROPAGATION_MASK	(MNT_SHARED | MNT_UNBINDABLE)
+#define MNT_ATIME_MASK (MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME )
=20
=20
 #define MNT_INTERNAL	0x4000
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index ba0ddb0..6172a44 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -47,13 +47,12 @@ struct inet_peer {
 	};
 	/*
 	 * Once inet_peer is queued for deletion (refcnt =3D=3D -1), following fi=
elds
-	 * are not available: rid, ip_id_count, tcp_ts, tcp_ts_stamp
+	 * are not available: rid, tcp_ts, tcp_ts_stamp
 	 * We can share memory with rcu_head to help keep inet_peer small.
 	 */
 	union {
 		struct {
 			atomic_t			rid;		/* Frag reception counter */
-			atomic_t			ip_id_count;	/* IP ID for the next packet */
 			__u32				tcp_ts;
 			__u32				tcp_ts_stamp;
 		};
@@ -103,7 +102,7 @@ extern bool inet_peer_xrlim_allow(struct inet_peer *pee=
r, int timeout);
 extern void inetpeer_invalidate_tree(int family);
=20
 /*
- * temporary check to make sure we dont access rid, ip_id_count, tcp_ts,
+ * temporary check to make sure we dont access rid, tcp_ts,
  * tcp_ts_stamp if no refcount is taken on inet_peer
  */
 static inline void inet_peer_refcheck(const struct inet_peer *p)
@@ -111,13 +110,4 @@ static inline void inet_peer_refcheck(const struct ine=
t_peer *p)
 	WARN_ON_ONCE(atomic_read(&p->refcnt) <=3D 0);
 }
=20
-
-/* can be called with or without local BH being disabled */
-static inline int inet_getid(struct inet_peer *p, int more)
-{
-	more++;
-	inet_peer_refcheck(p);
-	return atomic_add_return(more, &p->ip_id_count) - more;
-}
-
 #endif /* _NET_INETPEER_H */
diff --git a/include/net/ip.h b/include/net/ip.h
index b935e6c..1ee535b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -264,9 +264,10 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry=
 *dst)
 		 !(dst_metric_locked(dst, RTAX_MTU)));
 }
=20
-extern void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, in=
t more);
+u32 ip_idents_reserve(u32 hash, int segs);
+void __ip_select_ident(struct iphdr *iph, int segs);
=20
-static inline void ip_select_ident(struct sk_buff *skb, struct dst_entry *=
dst, struct sock *sk)
+static inline void ip_select_ident_segs(struct sk_buff *skb, struct sock *=
sk, int segs)
 {
 	struct iphdr *iph =3D ip_hdr(skb);
=20
@@ -276,24 +277,20 @@ static inline void ip_select_ident(struct sk_buff *sk=
b, struct dst_entry *dst, s
 		 * does not change, they drop every other packet in
 		 * a TCP stream using header compression.
 		 */
-		iph->id =3D (sk && inet_sk(sk)->inet_daddr) ?
-					htons(inet_sk(sk)->inet_id++) : 0;
-	} else
-		__ip_select_ident(iph, dst, 0);
-}
-
-static inline void ip_select_ident_more(struct sk_buff *skb, struct dst_en=
try *dst, struct sock *sk, int more)
-{
-	struct iphdr *iph =3D ip_hdr(skb);
-
-	if ((iph->frag_off & htons(IP_DF)) && !skb->local_df) {
 		if (sk && inet_sk(sk)->inet_daddr) {
 			iph->id =3D htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id +=3D 1 + more;
-		} else
+			inet_sk(sk)->inet_id +=3D segs;
+		} else {
 			iph->id =3D 0;
-	} else
-		__ip_select_ident(iph, dst, more);
+		}
+	} else {
+		__ip_select_ident(iph, segs);
+	}
+}
+
+static inline void ip_select_ident(struct sk_buff *skb, struct sock *sk)
+{
+	ip_select_ident_segs(skb, sk, 1);
 }
=20
 /*
diff --git a/include/net/ipip.h b/include/net/ipip.h
index 4dccfe3..e8ee3bb 100644
--- a/include/net/ipip.h
+++ b/include/net/ipip.h
@@ -50,7 +50,7 @@ struct ip_tunnel_prl_entry {
 	int pkt_len =3D skb->len - skb_transport_offset(skb);		\
 									\
 	skb->ip_summed =3D CHECKSUM_NONE;					\
-	ip_select_ident(skb, &rt->dst, NULL);				\
+	ip_select_ident(skb, NULL);				\
 									\
 	err =3D ip_local_out(skb);					\
 	if (likely(net_xmit_eval(err) =3D=3D 0)) {				\
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 0580673..00a2eb6 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -388,14 +388,19 @@ void ip6_frag_init(struct inet_frag_queue *q, void *a=
);
 int ip6_frag_match(struct inet_frag_queue *q, void *a);
=20
 /* more secured version of ipv6_addr_hash() */
-static inline u32 ipv6_addr_jhash(const struct in6_addr *a)
+static inline u32 __ipv6_addr_jhash(const struct in6_addr *a, const u32 in=
itval)
 {
 	u32 v =3D (__force u32)a->s6_addr32[0] ^ (__force u32)a->s6_addr32[1];
=20
 	return jhash_3words(v,
 			    (__force u32)a->s6_addr32[2],
 			    (__force u32)a->s6_addr32[3],
-			    ipv6_hash_secret);
+			    initval);
+}
+
+static inline u32 ipv6_addr_jhash(const struct in6_addr *a)
+{
+	return __ipv6_addr_jhash(a, ipv6_hash_secret);
 }
=20
 static inline int ipv6_addr_any(const struct in6_addr *a)
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index f674409..c8ba2e2 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -395,10 +395,10 @@ int netlbl_secattr_catmap_walk(struct netlbl_lsm_seca=
ttr_catmap *catmap,
 			       u32 offset);
 int netlbl_secattr_catmap_walk_rng(struct netlbl_lsm_secattr_catmap *catma=
p,
 				   u32 offset);
-int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap **catmap=
,
 				 u32 bit,
 				 gfp_t flags);
-int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap **catmap=
,
 				 u32 start,
 				 u32 end,
 				 gfp_t flags);
@@ -506,14 +506,14 @@ static inline int netlbl_secattr_catmap_walk_rng(
 	return -ENOENT;
 }
 static inline int netlbl_secattr_catmap_setbit(
-	                              struct netlbl_lsm_secattr_catmap *catmap,
+				      struct netlbl_lsm_secattr_catmap **catmap,
 				      u32 bit,
 				      gfp_t flags)
 {
 	return 0;
 }
 static inline int netlbl_secattr_catmap_setrng(
-	                              struct netlbl_lsm_secattr_catmap *catmap,
+				      struct netlbl_lsm_secattr_catmap **catmap,
 				      u32 start,
 				      u32 end,
 				      gfp_t flags)
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index c2e542b..b1c3d1c 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -3,8 +3,6 @@
=20
 #include <linux/types.h>
=20
-extern __u32 secure_ip_id(__be32 daddr);
-extern __u32 secure_ipv6_id(const __be32 daddr[4]);
 extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 d=
port);
 extern u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *d=
addr,
 				      __be16 dport);
diff --git a/init/main.c b/init/main.c
index 7474450..e937d9b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -610,6 +610,10 @@ asmlinkage void __init start_kernel(void)
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
+#ifdef CONFIG_X86_ESPFIX64
+	/* Should be run before the first non-init thread is created */
+	init_espfix_bsp();
+#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 648f25a..4babd77 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2843,21 +2843,16 @@ static void rb_iter_reset(struct ring_buffer_iter *=
iter)
 	struct ring_buffer_per_cpu *cpu_buffer =3D iter->cpu_buffer;
=20
 	/* Iterator usage is expected to have record disabled */
-	if (list_empty(&cpu_buffer->reader_page->list)) {
-		iter->head_page =3D rb_set_head_page(cpu_buffer);
-		if (unlikely(!iter->head_page))
-			return;
-		iter->head =3D iter->head_page->read;
-	} else {
-		iter->head_page =3D cpu_buffer->reader_page;
-		iter->head =3D cpu_buffer->reader_page->read;
-	}
+	iter->head_page =3D cpu_buffer->reader_page;
+	iter->head =3D cpu_buffer->reader_page->read;
+
+	iter->cache_reader_page =3D iter->head_page;
+	iter->cache_read =3D iter->head;
+
 	if (iter->head)
 		iter->read_stamp =3D cpu_buffer->read_stamp;
 	else
 		iter->read_stamp =3D iter->head_page->page->time_stamp;
-	iter->cache_reader_page =3D cpu_buffer->reader_page;
-	iter->cache_read =3D cpu_buffer->read;
 }
=20
 /**
@@ -3246,12 +3241,14 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts=
)
 		return NULL;
=20
 	/*
-	 * We repeat when a time extend is encountered.
-	 * Since the time extend is always attached to a data event,
-	 * we should never loop more than once.
-	 * (We never hit the following condition more than twice).
+	 * We repeat when a time extend is encountered or we hit
+	 * the end of the page. Since the time extend is always attached
+	 * to a data event, we should never loop more than three times.
+	 * Once for going to next page, once on time extend, and
+	 * finally once to get the event.
+	 * (We never hit the following condition more than thrice).
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 2))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3))
 		return NULL;
=20
 	if (rb_per_cpu_empty(cpu_buffer))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c9f7e6f..a72fa33 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1601,8 +1601,14 @@ static unsigned interleave_nodes(struct mempolicy *p=
olicy)
  * task can change it's policy.  The system default policy requires no
  * such protection.
  */
-unsigned slab_node(struct mempolicy *policy)
+unsigned slab_node(void)
 {
+	struct mempolicy *policy;
+
+	if (in_interrupt())
+		return numa_node_id();
+
+	policy =3D current->mempolicy;
 	if (!policy || policy->flags & MPOL_F_LOCAL)
 		return numa_node_id();
=20
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8762b2..62a7fa23 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2054,7 +2054,7 @@ static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	int alloc_flags =3D ALLOC_WMARK_MIN | ALLOC_CPUSET;
-	const gfp_t wait =3D gfp_mask & __GFP_WAIT;
+	const bool atomic =3D !(gfp_mask & (__GFP_WAIT | __GFP_NO_KSWAPD));
=20
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. *=
/
 	BUILD_BUG_ON(__GFP_HIGH !=3D (__force gfp_t) ALLOC_HIGH);
@@ -2063,20 +2063,20 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
+	 * set both ALLOC_HARDER (atomic =3D=3D true) and ALLOC_HIGH (__GFP_HIGH)=
.
 	 */
 	alloc_flags |=3D (__force int) (gfp_mask & __GFP_HIGH);
=20
-	if (!wait) {
+	if (atomic) {
 		/*
-		 * Not worth trying to allocate harder for
-		 * __GFP_NOMEMALLOC even if it can't schedule.
+		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
+		 * if it can't schedule.
 		 */
-		if  (!(gfp_mask & __GFP_NOMEMALLOC))
+		if (!(gfp_mask & __GFP_NOMEMALLOC))
 			alloc_flags |=3D ALLOC_HARDER;
 		/*
-		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
-		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
+		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
+		 * comment for __cpuset_node_allowed_softwall().
 		 */
 		alloc_flags &=3D ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
diff --git a/mm/slab.c b/mm/slab.c
index 4c3b671..aea5e42 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3270,7 +3270,7 @@ static void *alternate_node_alloc(struct kmem_cache *=
cachep, gfp_t flags)
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc =3D cpuset_slab_spread_node();
 	else if (current->mempolicy)
-		nid_alloc =3D slab_node(current->mempolicy);
+		nid_alloc =3D slab_node();
 	if (nid_alloc !=3D nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3302,7 +3302,7 @@ static void *fallback_alloc(struct kmem_cache *cache,=
 gfp_t flags)
=20
 retry_cpuset:
 	cpuset_mems_cookie =3D get_mems_allowed();
-	zonelist =3D node_zonelist(slab_node(current->mempolicy), flags);
+	zonelist =3D node_zonelist(slab_node(), flags);
=20
 retry:
 	/*
diff --git a/mm/slub.c b/mm/slub.c
index fc719f7..6a4c2fb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1608,7 +1608,7 @@ static struct page *get_any_partial(struct kmem_cache=
 *s, gfp_t flags,
=20
 	do {
 		cpuset_mems_cookie =3D get_mems_allowed();
-		zonelist =3D node_zonelist(slab_node(current->mempolicy), flags);
+		zonelist =3D node_zonelist(slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
=20
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 158887a..74e59cd 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -804,7 +804,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int=
 how)
 		sk->sk_shutdown =3D SHUTDOWN_MASK;
 		l2cap_chan_close(chan, 0);
=20
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err =3D bt_sock_wait_state(sk, BT_CLOSED,
 							sk->sk_lingertime);
 	}
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 14c4864..93a8241 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -901,7 +901,8 @@ static int rfcomm_sock_shutdown(struct socket *sock, in=
t how)
 		sk->sk_shutdown =3D SHUTDOWN_MASK;
 		__rfcomm_sock_close(sk);
=20
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err =3D bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 	}
 	release_sock(sk);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index a324b00..2e80aee7 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -774,7 +774,8 @@ static int sco_sock_shutdown(struct socket *sock, int h=
ow)
 		sco_sock_clear_timer(sk);
 		__sco_sock_close(sk);
=20
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err =3D bt_sock_wait_state(sk, BT_CLOSED,
 							sk->sk_lingertime);
 	}
@@ -794,7 +795,8 @@ static int sco_sock_release(struct socket *sock)
=20
 	sco_sock_close(sk);
=20
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime) {
+	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err =3D bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 		release_sock(sk);
diff --git a/net/compat.c b/net/compat.c
index 41724c9..759e542 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -85,7 +85,7 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct i=
ovec *kern_iov,
 {
 	int tot_len;
=20
-	if (kern_msg->msg_namelen) {
+	if (kern_msg->msg_name && kern_msg->msg_namelen) {
 		if (mode =3D=3D VERIFY_READ) {
 			int err =3D move_addr_to_kernel(kern_msg->msg_name,
 						      kern_msg->msg_namelen,
@@ -93,10 +93,11 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct=
 iovec *kern_iov,
 			if (err < 0)
 				return err;
 		}
-		if (kern_msg->msg_name)
-			kern_msg->msg_name =3D kern_address;
-	} else
+		kern_msg->msg_name =3D kern_address;
+	} else {
 		kern_msg->msg_name =3D NULL;
+		kern_msg->msg_namelen =3D 0;
+	}
=20
 	tot_len =3D iov_from_user_compat_to_kern(kern_iov,
 					  (struct compat_iovec __user *)kern_msg->msg_iov,
diff --git a/net/core/iovec.c b/net/core/iovec.c
index 139ef93..66e3f1f 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -39,7 +39,7 @@ int verify_iovec(struct msghdr *m, struct iovec *iov, str=
uct sockaddr *address,
 {
 	int size, ct, err;
=20
-	if (m->msg_namelen) {
+	if (m->msg_name && m->msg_namelen) {
 		if (mode =3D=3D VERIFY_READ) {
 			void __user *namep;
 			namep =3D (void __user __force *) m->msg_name;
@@ -48,10 +48,10 @@ int verify_iovec(struct msghdr *m, struct iovec *iov, s=
truct sockaddr *address,
 			if (err < 0)
 				return err;
 		}
-		if (m->msg_name)
-			m->msg_name =3D address;
+		m->msg_name =3D address;
 	} else {
 		m->msg_name =3D NULL;
+		m->msg_namelen =3D 0;
 	}
=20
 	size =3D m->msg_iovlen * sizeof(struct iovec);
@@ -157,6 +157,10 @@ EXPORT_SYMBOL(memcpy_fromiovec);
 int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 			int offset, int len)
 {
+	/* No data? Done! */
+	if (len =3D=3D 0)
+		return 0;
+
 	/* Skip over the finished iovecs */
 	while (offset >=3D iov->iov_len) {
 		offset -=3D iov->iov_len;
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 925991a..fd53919 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -79,29 +79,6 @@ u32 secure_ipv6_port_ephemeral(const __be32 *saddr, cons=
t __be32 *daddr,
 #endif
=20
 #ifdef CONFIG_INET
-__u32 secure_ip_id(__be32 daddr)
-{
-	u32 hash[MD5_DIGEST_WORDS];
-
-	hash[0] =3D (__force __u32) daddr;
-	hash[1] =3D net_secret[13];
-	hash[2] =3D net_secret[14];
-	hash[3] =3D net_secret[15];
-
-	md5_transform(hash, net_secret);
-
-	return hash[0];
-}
-
-__u32 secure_ipv6_id(const __be32 daddr[4])
-{
-	__u32 hash[4];
-
-	memcpy(hash, daddr, 16);
-	md5_transform(hash, net_secret);
-
-	return hash[0];
-}
=20
 __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
 				 __be16 sport, __be16 dport)
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index afaa735..dbec8b5 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -974,7 +974,7 @@ static int cipso_v4_map_cat_rbm_ntoh(const struct cipso=
_v4_doi *doi_def,
 				return -EPERM;
 			break;
 		}
-		ret_val =3D netlbl_secattr_catmap_setbit(secattr->attr.mls.cat,
+		ret_val =3D netlbl_secattr_catmap_setbit(&secattr->attr.mls.cat,
 						       host_spot,
 						       GFP_ATOMIC);
 		if (ret_val !=3D 0)
@@ -1076,7 +1076,7 @@ static int cipso_v4_map_cat_enum_ntoh(const struct ci=
pso_v4_doi *doi_def,
 	u32 iter;
=20
 	for (iter =3D 0; iter < net_cat_len; iter +=3D 2) {
-		ret_val =3D netlbl_secattr_catmap_setbit(secattr->attr.mls.cat,
+		ret_val =3D netlbl_secattr_catmap_setbit(&secattr->attr.mls.cat,
 				get_unaligned_be16(&net_cat[iter]),
 				GFP_ATOMIC);
 		if (ret_val !=3D 0)
@@ -1218,7 +1218,7 @@ static int cipso_v4_map_cat_rng_ntoh(const struct cip=
so_v4_doi *doi_def,
 		else
 			cat_low =3D 0;
=20
-		ret_val =3D netlbl_secattr_catmap_setrng(secattr->attr.mls.cat,
+		ret_val =3D netlbl_secattr_catmap_setrng(&secattr->attr.mls.cat,
 						       cat_low,
 						       cat_high,
 						       GFP_ATOMIC);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7f7e670..7fe66d9 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -342,7 +342,7 @@ static struct sk_buff *igmpv3_newpack(struct net_device=
 *dev, int size)
 	pip->saddr    =3D fl4.saddr;
 	pip->protocol =3D IPPROTO_IGMP;
 	pip->tot_len  =3D 0;	/* filled in later */
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	((u8*)&pip[1])[0] =3D IPOPT_RA;
 	((u8*)&pip[1])[1] =3D 4;
 	((u8*)&pip[1])[2] =3D 0;
@@ -683,7 +683,7 @@ static int igmp_send_report(struct in_device *in_dev, s=
truct ip_mc_list *pmc,
 	iph->daddr    =3D dst;
 	iph->saddr    =3D fl4.saddr;
 	iph->protocol =3D IPPROTO_IGMP;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	((u8*)&iph[1])[0] =3D IPOPT_RA;
 	((u8*)&iph[1])[1] =3D 4;
 	((u8*)&iph[1])[2] =3D 0;
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 58c4e696..9d74cc7 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -26,20 +26,7 @@
  *  Theory of operations.
  *  We keep one entry for each peer IP address.  The nodes contains long-l=
iving
  *  information about the peer which doesn't depend on routes.
- *  At this moment this information consists only of ID field for the next
- *  outgoing IP packet.  This field is incremented with each packet as enc=
oded
- *  in inet_getid() function (include/net/inetpeer.h).
- *  At the moment of writing this notes identifier of IP packets is genera=
ted
- *  to be unpredictable using this code only for packets subjected
- *  (actually or potentially) to defragmentation.  I.e. DF packets less th=
an
- *  PMTU in size when local fragmentation is disabled use a constant ID an=
d do
- *  not use this code (see ip_select_ident() in include/net/ip.h).
  *
- *  Route cache entries hold references to our nodes.
- *  New cache entries get references via lookup by destination IP address =
in
- *  the avl tree.  The reference is grabbed only when it's needed i.e. onl=
y
- *  when we try to output IP packet which needs an unpredictable ID (see
- *  __ip_select_ident() in net/ipv4/route.c).
  *  Nodes are removed only when reference counter goes to 0.
  *  When it's happened the node may be removed when a sufficient amount of
  *  time has been passed since its last use.  The less-recently-used entry=
 can
@@ -62,7 +49,6 @@
  *		refcnt: atomically against modifications on other CPU;
  *		   usually under some other lock to prevent node disappearing
  *		daddr: unchangeable
- *		ip_id_count: atomic value (no lock needed)
  */
=20
 static struct kmem_cache *peer_cachep __read_mostly;
@@ -488,10 +474,6 @@ relookup:
 		p->daddr =3D *daddr;
 		atomic_set(&p->refcnt, 1);
 		atomic_set(&p->rid, 0);
-		atomic_set(&p->ip_id_count,
-				(daddr->family =3D=3D AF_INET) ?
-					secure_ip_id(daddr->addr.a4) :
-					secure_ipv6_id(daddr->addr.a6));
 		p->tcp_ts_stamp =3D 0;
 		p->metrics[RTAX_LOCK-1] =3D INETPEER_METRICS_NEW;
 		p->rate_tokens =3D 0;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 16191f0..223085f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -162,7 +162,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct s=
ock *sk,
 	iph->daddr    =3D (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    =3D saddr;
 	iph->protocol =3D sk->sk_protocol;
-	ip_select_ident(skb, &rt->dst, sk);
+	ip_select_ident(skb, sk);
=20
 	if (opt && opt->opt.optlen) {
 		iph->ihl +=3D opt->opt.optlen>>2;
@@ -390,8 +390,7 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
=20
-	ip_select_ident_more(skb, &rt->dst, sk,
-			     (skb_shinfo(skb)->gso_segs ?: 1) - 1);
+	ip_select_ident_segs(skb, sk, skb_shinfo(skb)->gso_segs ?: 1);
=20
 	skb->priority =3D sk->sk_priority;
 	skb->mark =3D sk->sk_mark;
@@ -1334,7 +1333,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ihl =3D 5;
 	iph->tos =3D inet->tos;
 	iph->frag_off =3D df;
-	ip_select_ident(skb, &rt->dst, sk);
+	ip_select_ident(skb, sk);
 	iph->ttl =3D ttl;
 	iph->protocol =3D sk->sk_protocol;
 	iph->saddr =3D fl4->saddr;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 140d377..7993d16 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1579,7 +1579,7 @@ static void ip_encap(struct sk_buff *skb, __be32 sadd=
r, __be32 daddr)
 	iph->protocol	=3D	IPPROTO_IPIP;
 	iph->ihl	=3D	5;
 	iph->tot_len	=3D	htons(skb->len);
-	ip_select_ident(skb, skb_dst(skb), NULL);
+	ip_select_ident(skb, NULL);
 	ip_send_check(iph);
=20
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index cfded93..75fea1f 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -380,7 +380,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flow=
i4 *fl4,
 		iph->check   =3D 0;
 		iph->tot_len =3D htons(length);
 		if (!iph->id)
-			ip_select_ident(skb, &rt->dst, NULL);
+			ip_select_ident(skb, NULL);
=20
 		iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6526110..d361dc0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1344,46 +1344,53 @@ void rt_bind_peer(struct rtable *rt, __be32 daddr, =
int create)
 		rt->rt_peer_genid =3D rt_peer_genid();
 }
=20
-/*
- * Peer allocation may fail only in serious out-of-memory conditions.  How=
ever
- * we still can generate some output.
- * Random ID selection looks a bit dangerous because we have no chances to
- * select ID being unique in a reasonable period of time.
- * But broken packet identifier may be better than no packet at all.
+#define IP_IDENTS_SZ 2048u
+struct ip_ident_bucket {
+	atomic_t	id;
+	u32		stamp32;
+};
+
+static struct ip_ident_bucket *ip_idents __read_mostly;
+
+/* In order to protect privacy, we add a perturbation to identifiers
+ * if one generator is seldom used. This makes hard for an attacker
+ * to infer how many packets were sent between two points in time.
  */
-static void ip_select_fb_ident(struct iphdr *iph)
+u32 ip_idents_reserve(u32 hash, int segs)
 {
-	static DEFINE_SPINLOCK(ip_fb_id_lock);
-	static u32 ip_fallback_id;
-	u32 salt;
+	struct ip_ident_bucket *bucket =3D ip_idents + hash % IP_IDENTS_SZ;
+	u32 old =3D ACCESS_ONCE(bucket->stamp32);
+	u32 now =3D (u32)jiffies;
+	u32 delta =3D 0;
+
+	if (old !=3D now && cmpxchg(&bucket->stamp32, old, now) =3D=3D old) {
+		u64 x =3D random32();
+
+		x *=3D (now - old);
+		delta =3D (u32)(x >> 32);
+	}
=20
-	spin_lock_bh(&ip_fb_id_lock);
-	salt =3D secure_ip_id((__force __be32)ip_fallback_id ^ iph->daddr);
-	iph->id =3D htons(salt & 0xFFFF);
-	ip_fallback_id =3D salt;
-	spin_unlock_bh(&ip_fb_id_lock);
+	return atomic_add_return(segs + delta, &bucket->id) - segs;
 }
+EXPORT_SYMBOL(ip_idents_reserve);
=20
-void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more)
+void __ip_select_ident(struct iphdr *iph, int segs)
 {
-	struct rtable *rt =3D (struct rtable *) dst;
-
-	if (rt && !(rt->dst.flags & DST_NOPEER)) {
-		if (rt->peer =3D=3D NULL)
-			rt_bind_peer(rt, rt->rt_dst, 1);
+	static u32 ip_idents_hashrnd __read_mostly;
+	static bool hashrnd_initialized =3D false;
+	u32 hash, id;
=20
-		/* If peer is attached to destination, it is never detached,
-		   so that we need not to grab a lock to dereference it.
-		 */
-		if (rt->peer) {
-			iph->id =3D htons(inet_getid(rt->peer, more));
-			return;
-		}
-	} else if (!rt)
-		printk(KERN_DEBUG "rt_bind_peer(0) @%p\n",
-		       __builtin_return_address(0));
+	if (unlikely(!hashrnd_initialized)) {
+		hashrnd_initialized =3D true;
+		get_random_bytes(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
+	}
=20
-	ip_select_fb_ident(iph);
+	hash =3D jhash_3words((__force u32)iph->daddr,
+			    (__force u32)iph->saddr,
+			    iph->protocol,
+			    ip_idents_hashrnd);
+	id =3D ip_idents_reserve(hash, segs);
+	iph->id =3D htons(id);
 }
 EXPORT_SYMBOL(__ip_select_ident);
=20
@@ -3023,7 +3030,6 @@ static int rt_fill_info(struct net *net,
 	error =3D rt->dst.error;
 	if (peer) {
 		inet_peer_refcheck(rt->peer);
-		id =3D atomic_read(&peer->ip_id_count) & 0xffff;
 		if (peer->tcp_ts_stamp) {
 			ts =3D peer->tcp_ts;
 			tsage =3D get_seconds() - peer->tcp_ts_stamp;
@@ -3455,6 +3461,12 @@ int __init ip_rt_init(void)
 {
 	int rc =3D 0;
=20
+	ip_idents =3D kmalloc(IP_IDENTS_SZ * sizeof(*ip_idents), GFP_KERNEL);
+	if (!ip_idents)
+		panic("IP: failed to allocate ip_idents\n");
+
+	get_random_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));
+
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	ip_rt_acct =3D __alloc_percpu(256 * sizeof(struct ip_rt_acct), __alignof_=
_(struct ip_rt_acct));
 	if (!ip_rt_acct)
diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index 80fa2bf..c042e52 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -218,7 +218,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 a=
ck, u32 in_flight)
 			 * This is:
 			 *     (actual rate in segments) * baseRTT
 			 */
-			target_cwnd =3D tp->snd_cwnd * vegas->baseRTT / rtt;
+			target_cwnd =3D (u64)tp->snd_cwnd * vegas->baseRTT;
+			do_div(target_cwnd, rtt);
=20
 			/* Calculate the difference between the window we had,
 			 * and the window we would like to have. This quantity
diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index ac43cd7..b4d1858 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -144,7 +144,7 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ac=
k, u32 in_flight)
=20
 		rtt =3D veno->minrtt;
=20
-		target_cwnd =3D (tp->snd_cwnd * veno->basertt);
+		target_cwnd =3D (u64)tp->snd_cwnd * veno->basertt;
 		target_cwnd <<=3D V_PARAM_SHIFT;
 		do_div(target_cwnd, rtt);
=20
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 938553e..5531eb2 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -54,12 +54,12 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *=
x, struct sk_buff *skb)
=20
 	top_iph->frag_off =3D (flags & XFRM_STATE_NOPMTUDISC) ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
-	ip_select_ident(skb, dst->child, NULL);
=20
 	top_iph->ttl =3D ip4_dst_hoplimit(dst->child);
=20
 	top_iph->saddr =3D x->props.saddr.a4;
 	top_iph->daddr =3D x->id.daddr.a4;
+	ip_select_ident(skb, NULL);
=20
 	return 0;
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 064b5c9..46fc6a3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -600,22 +600,19 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nex=
thdr)
=20
 void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
-	static atomic_t ipv6_fragmentation_id;
-	int ident;
+	static u32 ip6_idents_hashrnd __read_mostly;
+	static bool hashrnd_initialized =3D false;
+	u32 hash, id;
=20
-	if (rt && !(rt->dst.flags & DST_NOPEER)) {
-		struct inet_peer *peer;
-
-		if (!rt->rt6i_peer)
-			rt6_bind_peer(rt, 1);
-		peer =3D rt->rt6i_peer;
-		if (peer) {
-			fhdr->identification =3D htonl(inet_getid(peer, 0));
-			return;
-		}
+	if (unlikely(!hashrnd_initialized)) {
+		hashrnd_initialized =3D true;
+		get_random_bytes(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
 	}
-	ident =3D atomic_inc_return(&ipv6_fragmentation_id);
-	fhdr->identification =3D htonl(ident);
+	hash =3D __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
+	hash =3D __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
+
+	id =3D ip_idents_reserve(hash, 1);
+	fhdr->identification =3D htonl(id);
 }
=20
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmi=
t.c
index 38c0813..cc8f8b4 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -853,7 +853,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_con=
n *cp,
 	iph->daddr		=3D	cp->daddr.ip;
 	iph->saddr		=3D	saddr;
 	iph->ttl		=3D	old_iph->ttl;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
=20
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df =3D 1;
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 824f184..bcecae0 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -523,7 +523,7 @@ int netlbl_secattr_catmap_walk_rng(struct netlbl_lsm_se=
cattr_catmap *catmap,
=20
 /**
  * netlbl_secattr_catmap_setbit - Set a bit in a LSM secattr catmap
- * @catmap: the category bitmap
+ * @catmap: pointer to the category bitmap
  * @bit: the bit to set
  * @flags: memory allocation flags
  *
@@ -532,18 +532,25 @@ int netlbl_secattr_catmap_walk_rng(struct netlbl_lsm_=
secattr_catmap *catmap,
  * negative values on failure.
  *
  */
-int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap **catmap=
,
 				 u32 bit,
 				 gfp_t flags)
 {
-	struct netlbl_lsm_secattr_catmap *iter =3D catmap;
+	struct netlbl_lsm_secattr_catmap *iter =3D *catmap;
 	u32 node_bit;
 	u32 node_idx;
=20
 	while (iter->next !=3D NULL &&
 	       bit >=3D (iter->startbit + NETLBL_CATMAP_SIZE))
 		iter =3D iter->next;
-	if (bit >=3D (iter->startbit + NETLBL_CATMAP_SIZE)) {
+	if (bit < iter->startbit) {
+		iter =3D netlbl_secattr_catmap_alloc(flags);
+		if (iter =3D=3D NULL)
+			return -ENOMEM;
+		iter->next =3D *catmap;
+		iter->startbit =3D bit & ~(NETLBL_CATMAP_SIZE - 1);
+		*catmap =3D iter;
+	} else if (bit >=3D (iter->startbit + NETLBL_CATMAP_SIZE)) {
 		iter->next =3D netlbl_secattr_catmap_alloc(flags);
 		if (iter->next =3D=3D NULL)
 			return -ENOMEM;
@@ -561,7 +568,7 @@ int netlbl_secattr_catmap_setbit(struct netlbl_lsm_seca=
ttr_catmap *catmap,
=20
 /**
  * netlbl_secattr_catmap_setrng - Set a range of bits in a LSM secattr cat=
map
- * @catmap: the category bitmap
+ * @catmap: pointer to the category bitmap
  * @start: the starting bit
  * @end: the last bit in the string
  * @flags: memory allocation flags
@@ -571,15 +578,16 @@ int netlbl_secattr_catmap_setbit(struct netlbl_lsm_se=
cattr_catmap *catmap,
  * on success, negative values on failure.
  *
  */
-int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap **catmap=
,
 				 u32 start,
 				 u32 end,
 				 gfp_t flags)
 {
 	int ret_val =3D 0;
-	struct netlbl_lsm_secattr_catmap *iter =3D catmap;
+	struct netlbl_lsm_secattr_catmap *iter =3D *catmap;
 	u32 iter_max_spot;
 	u32 spot;
+	u32 orig_spot =3D iter->startbit;
=20
 	/* XXX - This could probably be made a bit faster by combining writes
 	 * to the catmap instead of setting a single bit each time, but for
@@ -597,7 +605,9 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_seca=
ttr_catmap *catmap,
 			iter =3D iter->next;
 			iter_max_spot =3D iter->startbit + NETLBL_CATMAP_SIZE;
 		}
-		ret_val =3D netlbl_secattr_catmap_setbit(iter, spot, GFP_ATOMIC);
+		ret_val =3D netlbl_secattr_catmap_setbit(&iter, spot, flags);
+		if (iter->startbit < orig_spot)
+			*catmap =3D iter;
 	}
=20
 	return ret_val;
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 25b207b..da54d29 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1188,6 +1188,7 @@ void sctp_assoc_update(struct sctp_association *asoc,
 	asoc->c =3D new->c;
 	asoc->peer.rwnd =3D new->peer.rwnd;
 	asoc->peer.sack_needed =3D new->peer.sack_needed;
+	asoc->peer.auth_capable =3D new->peer.auth_capable;
 	asoc->peer.i =3D new->peer.i;
 	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
 			 asoc->peer.i.initial_tsn, GFP_ATOMIC);
diff --git a/net/sctp/output.c b/net/sctp/output.c
index cf3e22c..5bd9aa9 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -587,7 +587,7 @@ out:
 	return err;
 no_route:
 	kfree_skb(nskb);
-	IP_INC_STATS_BH(&init_net, IPSTATS_MIB_OUTNOROUTES);
+	IP_INC_STATS(&init_net, IPSTATS_MIB_OUTNOROUTES);
=20
 	/* FIXME: Returning the 'err' will effect all the associations
 	 * associated with a socket, although only one of the paths of the
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7db62b4..e3adb49 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1842,7 +1842,7 @@ static void smack_set_catset(char *catset, struct net=
lbl_lsm_secattr *sap)
 		for (m =3D 0x80; m !=3D 0; m >>=3D 1, cat++) {
 			if ((m & *cp) =3D=3D 0)
 				continue;
-			rc =3D netlbl_secattr_catmap_setbit(sap->attr.mls.cat,
+			rc =3D netlbl_secattr_catmap_setbit(&sap->attr.mls.cat,
 							  cat, GFP_ATOMIC);
 		}
 }
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index e7244ac..e2e4829 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -852,8 +852,8 @@ config SND_VIRTUOSO
 	select SND_JACK if INPUT=3Dy || INPUT=3DSND
 	help
 	  Say Y here to include support for sound cards based on the
-	  Asus AV66/AV100/AV200 chips, i.e., Xonar D1, DX, D2, D2X, DS,
-	  Essence ST (Deluxe), and Essence STX.
+	  Asus AV66/AV100/AV200 chips, i.e., Xonar D1, DX, D2, D2X, DS, DSX,
+	  Essence ST (Deluxe), and Essence STX (II).
 	  Support for the HDAV1.3 (Deluxe) and HDAV1.3 Slim is experimental;
 	  for the Xense, missing.
=20
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 400168e..491cdf0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -436,6 +436,8 @@ static void alc_fix_pll(struct hda_codec *codec)
 			    spec->pll_coef_idx);
 	val =3D snd_hda_codec_read(codec, spec->pll_nid, 0,
 				 AC_VERB_GET_PROC_COEF, 0);
+	if (val =3D=3D -1)
+		return;
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_COEF_INDEX,
 			    spec->pll_coef_idx);
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_PROC_COEF,
@@ -4773,6 +4775,8 @@ static int alc269_parse_auto_config(struct hda_codec =
*codec)
 static void alc269_toggle_power_output(struct hda_codec *codec, int power_=
up)
 {
 	int val =3D alc_read_coef_idx(codec, 0x04);
+	if (val =3D=3D -1)
+		return;
 	if (power_up)
 		val |=3D 1 << 11;
 	else
@@ -5184,27 +5188,30 @@ static int alc269_fill_coef(struct hda_codec *codec=
)
 	if ((alc_get_coef0(codec) & 0x00ff) =3D=3D 0x017) {
 		val =3D alc_read_coef_idx(codec, 0x04);
 		/* Power up output pin */
-		alc_write_coef_idx(codec, 0x04, val | (1<<11));
+		if (val !=3D -1)
+			alc_write_coef_idx(codec, 0x04, val | (1<<11));
 	}
=20
 	if ((alc_get_coef0(codec) & 0x00ff) =3D=3D 0x018) {
 		val =3D alc_read_coef_idx(codec, 0xd);
-		if ((val & 0x0c00) >> 10 !=3D 0x1) {
+		if (val !=3D -1 && (val & 0x0c00) >> 10 !=3D 0x1) {
 			/* Capless ramp up clock control */
 			alc_write_coef_idx(codec, 0xd, val | (1<<10));
 		}
 		val =3D alc_read_coef_idx(codec, 0x17);
-		if ((val & 0x01c0) >> 6 !=3D 0x4) {
+		if (val !=3D -1 && (val & 0x01c0) >> 6 !=3D 0x4) {
 			/* Class D power on reset */
 			alc_write_coef_idx(codec, 0x17, val | (1<<7));
 		}
 	}
=20
 	val =3D alc_read_coef_idx(codec, 0xd); /* Class D */
-	alc_write_coef_idx(codec, 0xd, val | (1<<14));
+	if (val !=3D -1)
+		alc_write_coef_idx(codec, 0xd, val | (1<<14));
=20
 	val =3D alc_read_coef_idx(codec, 0x4); /* HP */
-	alc_write_coef_idx(codec, 0x4, val | (1<<11));
+	if (val !=3D -1)
+		alc_write_coef_idx(codec, 0x4, val | (1<<11));
=20
 	return 0;
 }
diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
index 4149a0c..7edd5e4 100644
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -52,6 +52,8 @@ static DEFINE_PCI_DEVICE_TABLE(xonar_ids) =3D {
 	{ OXYGEN_PCI_SUBID(0x1043, 0x835d) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x835e) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x838e) },
+	{ OXYGEN_PCI_SUBID(0x1043, 0x8522) },
+	{ OXYGEN_PCI_SUBID(0x1043, 0x85f4) },
 	{ OXYGEN_PCI_SUBID_BROKEN_EEPROM },
 	{ }
 };
diff --git a/sound/pci/oxygen/xonar_pcm179x.c b/sound/pci/oxygen/xonar_pcm1=
79x.c
index 8433aa7..4cac06a 100644
--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -100,8 +100,8 @@
  */
=20
 /*
- * Xonar Essence ST (Deluxe)/STX
- * -----------------------------
+ * Xonar Essence ST (Deluxe)/STX (II)
+ * ----------------------------------
  *
  * CMI8788:
  *
@@ -1138,6 +1138,14 @@ int __devinit get_xonar_pcm179x_model(struct oxygen =
*chip,
 		chip->model.resume =3D xonar_stx_resume;
 		chip->model.set_dac_params =3D set_pcm1796_params;
 		break;
+	case 0x85f4:
+		chip->model =3D model_xonar_st;
+		/* TODO: daughterboard support */
+		chip->model.shortname =3D "Xonar STX II";
+		chip->model.init =3D xonar_stx_init;
+		chip->model.resume =3D xonar_stx_resume;
+		chip->model.set_dac_params =3D set_pcm1796_params;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/sound/pci/oxygen/xonar_wm87x6.c b/sound/pci/oxygen/xonar_wm87x=
6.c
index 915546a..30495b8 100644
--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -1255,7 +1255,6 @@ static void dump_wm87x6_registers(struct oxygen *chip=
,
 }
=20
 static const struct oxygen_model model_xonar_ds =3D {
-	.shortname =3D "Xonar DS",
 	.longname =3D "Asus Virtuoso 66",
 	.chip =3D "AV200",
 	.init =3D xonar_ds_init,
@@ -1325,6 +1324,11 @@ int __devinit get_xonar_wm87x6_model(struct oxygen *=
chip,
 	switch (id->subdevice) {
 	case 0x838e:
 		chip->model =3D model_xonar_ds;
+		chip->model.shortname =3D "Xonar DS";
+		break;
+	case 0x8522:
+		chip->model =3D model_xonar_ds;
+		chip->model.shortname =3D "Xonar DSX";
 		break;
 	case 0x835e:
 		chip->model =3D model_xonar_hdav_slim;
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index b583e60..72886e3 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -778,9 +778,7 @@ static int pxa_ssp_remove(struct snd_soc_dai *dai)
 			  SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |	\
 			  SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000)
=20
-#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
-			    SNDRV_PCM_FMTBIT_S24_LE |	\
-			    SNDRV_PCM_FMTBIT_S32_LE)
+#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE=
)
=20
 static struct snd_soc_dai_ops pxa_ssp_dai_ops =3D {
 	.startup	=3D pxa_ssp_startup,
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index bff42bf..ad22bd9 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -824,11 +824,9 @@ static int i2s_suspend(struct snd_soc_dai *dai)
 {
 	struct i2s_dai *i2s =3D to_info(dai);
=20
-	if (dai->active) {
-		i2s->suspend_i2smod =3D readl(i2s->addr + I2SMOD);
-		i2s->suspend_i2scon =3D readl(i2s->addr + I2SCON);
-		i2s->suspend_i2spsr =3D readl(i2s->addr + I2SPSR);
-	}
+	i2s->suspend_i2smod =3D readl(i2s->addr + I2SMOD);
+	i2s->suspend_i2scon =3D readl(i2s->addr + I2SCON);
+	i2s->suspend_i2spsr =3D readl(i2s->addr + I2SPSR);
=20
 	return 0;
 }
@@ -837,11 +835,9 @@ static int i2s_resume(struct snd_soc_dai *dai)
 {
 	struct i2s_dai *i2s =3D to_info(dai);
=20
-	if (dai->active) {
-		writel(i2s->suspend_i2scon, i2s->addr + I2SCON);
-		writel(i2s->suspend_i2smod, i2s->addr + I2SMOD);
-		writel(i2s->suspend_i2spsr, i2s->addr + I2SPSR);
-	}
+	writel(i2s->suspend_i2scon, i2s->addr + I2SCON);
+	writel(i2s->suspend_i2smod, i2s->addr + I2SMOD);
+	writel(i2s->suspend_i2spsr, i2s->addr + I2SPSR);
=20
 	return 0;
 }
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 5dbb35d..c946700 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -61,6 +61,14 @@ static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_m=
emory_slot *slot,
 	return pfn;
 }
=20
+static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npag=
es)
+{
+	unsigned long i;
+
+	for (i =3D 0; i < npages; ++i)
+		kvm_release_pfn_clean(pfn + i);
+}
+
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	gfn_t gfn, end_gfn;
@@ -121,6 +129,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_mem=
ory_slot *slot)
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=3D%llx\n", pfn);
+			kvm_unpin_pages(kvm, pfn, page_size);
 			goto unmap_pages;
 		}
=20
@@ -132,7 +141,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_mem=
ory_slot *slot)
 	return 0;
=20
 unmap_pages:
-	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn);
+	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn - slot->base_gfn);
 	return r;
 }
=20
@@ -273,14 +282,6 @@ out_unlock:
 	return r;
 }
=20
-static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npag=
es)
-{
-	unsigned long i;
-
-	for (i =3D 0; i < npages; ++i)
-		kvm_release_pfn_clean(pfn + i);
-}
-
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages)
 {
=0D
--=-kcpNMI1odd/lAg3PnSWX--

--=-cKSaeqx0WU94BgbCqflu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBV9S+e/yOyVhhEJAQrLCQ/+J56OWDWUck2EliudlIeObAQw7AV21RQ/
wGMZ/ymp/p+KRC5ZJgKo4NsKzjHibHmv8Yn5SbNCcYsL+EC3f/o4YyXQN+JywvCQ
4H3PHpOPfA9D2g5JU/1YQD7HKIFJgjux6Jh3GQYe8UY74sfDY844JNIepztlEQmf
fqAb9KN8ZuDH13UUmIc7wE3l3+kvEAYu+YA+UZGw6/14VVUuBwHoCDBlo/f6rMNh
AE46LHdQNCjCLL6kf68Mn4h4WAVVLICYRHyQbC/Ydl6RZCj+Z0omeMKt8Nb6vFy0
xV213Fv1DAG1EKznQIKo7NEyhyqkWhSGqKZMBTkkElN/8zOOjN7zhRrKKfz+31MF
+8pr33GIaLxZvWDqQADAY8MhIP50+tdCYYMUCRE+QGXyea4uRCoFvRbXd8fVvMWF
Mao6eeeRwA5rH3tzOk05wj4veqX4+mhTIyNprQn4ZTNaG08u+7PyRIdUpa7/ERj3
mcNxeOm+oLLHqcE7HFo1CJeEep+gCvdbf29DjlvpkJlNbrduYSVl4iFid8Dk2zgv
4cpflrOGysonCxdt+8LfqrbeaEw31QPOVOrUZ7Y76d7qlimIPfPJslswNTZ9aj2U
qRJEs+xl4JRk+MU8pJK5k4uWJqc9EwcspHpFxe0O4emMK3jqtkONIXK8IS6atmOZ
kqF9cAka4rU=
=gQbD
-----END PGP SIGNATURE-----

--=-cKSaeqx0WU94BgbCqflu--
