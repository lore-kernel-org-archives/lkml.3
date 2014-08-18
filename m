Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaHRJd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHRJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.15 stable review
Date: Mon, 18 Aug 2014 10:31:01 +0100
Message-Id: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.15 stable kernel.

PLEASE NOTE:

  This will be the LAST 3.11.y.z extended stable kernel release.

This version contains 137 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.15 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/x86/x86_64/mm.txt                 |   2 +
 Makefile                                        |   2 +
 arch/arm/mm/idmap.c                             |   7 +
 arch/parisc/include/uapi/asm/signal.h           |   2 -
 arch/powerpc/perf/core-book3s.c                 |   6 +-
 arch/s390/kernel/ptrace.c                       |   9 +-
 arch/sparc/include/asm/pgtable_64.h             |   6 +-
 arch/sparc/include/asm/tlbflush_64.h            |  12 +-
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
 arch/x86/boot/header.S                          |  26 ++-
 arch/x86/boot/tools/build.c                     |  37 ++++-
 arch/x86/include/asm/espfix.h                   |  16 ++
 arch/x86/include/asm/irqflags.h                 |   2 +-
 arch/x86/include/asm/pgtable_64_types.h         |   2 +
 arch/x86/include/asm/setup.h                    |   2 +
 arch/x86/kernel/Makefile                        |   1 +
 arch/x86/kernel/cpu/perf_event_intel.c          |   9 +
 arch/x86/kernel/entry_32.S                      |  21 ++-
 arch/x86/kernel/entry_64.S                      |  77 ++++++++-
 arch/x86/kernel/espfix_64.c                     | 208 +++++++++++++++++++++++
 arch/x86/kernel/ldt.c                           |  10 +-
 arch/x86/kernel/paravirt_patch_64.c             |   2 -
 arch/x86/kernel/smpboot.c                       |   7 +
 arch/x86/mm/dump_pagetables.c                   |  40 +++--
 arch/x86/vdso/vdso32-setup.c                    |   8 -
 block/blk-cgroup.c                              |   7 +
 block/blk-tag.c                                 |  33 +---
 block/compat_ioctl.c                            |   1 +
 crypto/af_alg.c                                 |   2 +
 drivers/ata/ahci.c                              |   1 +
 drivers/ata/libata-core.c                       |  12 +-
 drivers/bluetooth/hci_h5.c                      |   1 +
 drivers/gpu/drm/qxl/qxl_irq.c                   |   3 +
 drivers/gpu/drm/radeon/atombios_encoders.c      |  10 +-
 drivers/gpu/drm/radeon/cik.c                    |   1 +
 drivers/gpu/drm/radeon/evergreen.c              |   1 +
 drivers/gpu/drm/radeon/r600.c                   |   1 +
 drivers/gpu/drm/radeon/radeon_display.c         |   5 +
 drivers/gpu/drm/radeon/si.c                     |   1 +
 drivers/hv/hv_kvp.c                             |  16 +-
 drivers/hv/hv_util.c                            |   2 +-
 drivers/hwmon/adt7470.c                         |   6 +-
 drivers/hwmon/da9052-hwmon.c                    |   2 +-
 drivers/hwmon/da9055-hwmon.c                    |   2 +-
 drivers/hwmon/smsc47m192.c                      |   4 +-
 drivers/iio/industrialio-buffer.c               |   2 +-
 drivers/input/input.c                           |   6 +-
 drivers/irqchip/irq-gic.c                       |   6 +-
 drivers/md/dm-cache-metadata.c                  |   9 +
 drivers/md/dm-cache-target.c                    |  13 +-
 drivers/md/dm-thin-metadata.c                   |   9 +
 drivers/media/dvb-frontends/tda10071.c          |   6 +-
 drivers/media/usb/gspca/pac7302.c               |   1 +
 drivers/media/usb/hdpvr/hdpvr-video.c           |   6 +-
 drivers/net/can/c_can/c_can_platform.c          |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h     |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |  12 +-
 drivers/net/ethernet/emulex/benet/be_main.c     |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c       |   2 +
 drivers/net/ethernet/marvell/mvneta.c           | 211 +++++++++++++-----------
 drivers/net/ethernet/sun/sunvnet.c              |  20 ++-
 drivers/net/macvlan.c                           |   1 +
 drivers/net/ppp/pppoe.c                         |   2 +-
 drivers/net/ppp/pptp.c                          |   2 +-
 drivers/net/usb/qmi_wwan.c                      |   3 +
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  12 --
 drivers/net/wireless/mwifiex/main.c             |   1 +
 drivers/rapidio/devices/tsi721_dma.c            |   8 +-
 drivers/sbus/char/bbc_envctrl.c                 |   6 +
 drivers/sbus/char/bbc_i2c.c                     |  11 +-
 drivers/scsi/scsi_lib.c                         |   8 +
 drivers/staging/vt6655/bssdb.c                  |   2 +-
 drivers/staging/vt6655/device_main.c            |   7 +-
 drivers/tty/serial/sunsab.c                     |   9 +
 drivers/usb/chipidea/udc.c                      |   4 +-
 drivers/usb/core/hub.c                          |  19 +++
 drivers/xen/manage.c                            |   5 +-
 fs/coredump.c                                   |   2 +-
 fs/fuse/dir.c                                   |   7 +-
 fs/fuse/inode.c                                 |  20 ++-
 fs/namei.c                                      | 183 ++++++++++++++++++++
 fs/namespace.c                                  |   2 +-
 include/linux/libata.h                          |   1 +
 include/linux/namei.h                           |   1 +
 include/linux/printk.h                          |   6 +-
 include/net/inetpeer.h                          |  16 +-
 include/net/ip.h                                |  31 ++--
 include/net/ipv6.h                              |  11 +-
 include/net/secure_seq.h                        |   2 -
 include/net/sock.h                              |  16 +-
 init/main.c                                     |   4 +
 kernel/power/process.c                          |   1 +
 kernel/printk/printk.c                          |   2 +-
 kernel/sched/core.c                             |   2 +-
 kernel/sched/debug.c                            |   2 +-
 kernel/sched/rt.c                               |   2 +-
 kernel/time/alarmtimer.c                        |  20 ++-
 kernel/time/clockevents.c                       |  10 +-
 kernel/trace/ftrace.c                           |   4 +-
 kernel/trace/ring_buffer.c                      |   4 -
 kernel/trace/trace.c                            |  20 ++-
 kernel/trace/trace_clock.c                      |   9 +-
 lib/btree.c                                     |   1 +
 mm/kmemleak.c                                   |   4 +-
 mm/page_alloc.c                                 |  16 +-
 mm/shmem.c                                      | 104 ++++++++++--
 mm/slab_common.c                                |   2 +
 mm/vmalloc.c                                    |  14 +-
 net/8021q/vlan_core.c                           |   5 +-
 net/appletalk/ddp.c                             |   3 -
 net/compat.c                                    |   9 +-
 net/core/dst.c                                  |  16 +-
 net/core/iovec.c                                |  10 +-
 net/core/secure_seq.c                           |  25 ---
 net/core/skbuff.c                               |   2 +-
 net/dns_resolver/dns_query.c                    |   4 +-
 net/ipv4/icmp.c                                 |   2 -
 net/ipv4/igmp.c                                 |  14 +-
 net/ipv4/inetpeer.c                             |  18 --
 net/ipv4/ip_options.c                           |   4 +
 net/ipv4/ip_output.c                            |   7 +-
 net/ipv4/ip_tunnel.c                            |  12 +-
 net/ipv4/ip_tunnel_core.c                       |   2 +-
 net/ipv4/ipmr.c                                 |   2 +-
 net/ipv4/raw.c                                  |   2 +-
 net/ipv4/route.c                                |  84 ++++++----
 net/ipv4/tcp.c                                  |   3 +-
 net/ipv4/tcp_input.c                            |  10 +-
 net/ipv4/tcp_output.c                           |   6 +-
 net/ipv4/tcp_vegas.c                            |   3 +-
 net/ipv4/tcp_veno.c                             |   2 +-
 net/ipv4/xfrm4_mode_tunnel.c                    |   2 +-
 net/ipv6/addrconf.c                             |  14 +-
 net/ipv6/ip6_output.c                           |  17 ++
 net/ipv6/output_core.c                          |  24 ---
 net/l2tp/l2tp_ppp.c                             |   4 +-
 net/mac80211/tx.c                               |  26 +--
 net/netfilter/ipvs/ip_vs_xmit.c                 |   2 +-
 net/netlink/af_netlink.c                        |   4 +-
 net/sctp/associola.c                            |   1 +
 net/sctp/output.c                               |   2 +-
 net/sctp/sysctl.c                               |   3 +-
 net/sctp/ulpevent.c                             | 122 ++------------
 net/tipc/bcast.c                                |   1 +
 net/wireless/trace.h                            |   3 +-
 154 files changed, 1519 insertions(+), 697 deletions(-)

Abbas Raza (1):
      usb: chipidea: udc: Disable auto ZLP generation on ep0

Alex Deucher (2):
      drm/radeon: avoid leaking edid data
      drm/radeon: set default bl level to something reasonable

Alexandre Bounine (1):
      rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue

Anand Avati (1):
      fuse: ignore entry-timeout on LOOKUP_REVAL

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference

Andrey Utkin (2):
      appletalk: Fix socket referencing in skb
      arch/sparc/math-emu/math_32.c: drop stray break operator

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Anssi Hannula (1):
      dm cache: fix race affecting dirty block count

Antti Palosaari (1):
      [media] tda10071: force modulation to QPSK on DVB-S

Axel Lin (2):
      hwmon: (da9052) Don't use dash in the name attribute
      hwmon: (da9055) Don't use dash in the name attribute

Ben Hutchings (1):
      dns_resolver: Null-terminate the right string

Ben Pfaff (1):
      netlink: Fix handling of error from netlink_dump().

Bernd Wachter (1):
      net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Bjørn Mork (1):
      net: qmi_wwan: add two Sierra Wireless/Netgear devices

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

Catalin Marinas (1):
      mm: kmemleak: avoid false negatives on vmalloc'ed objects

Christian König (1):
      drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Christoph Lameter (1):
      slab_common: Do not check for duplicate slab names

Christoph Paasch (3):
      tcp: Fix divide by zero when pushing during tcp-repair
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christoph Schulz (1):
      net: pppoe: use correct channel MTU when using Multilink PPP

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

Daniel Borkmann (3):
      net: sctp: check proc_dointvec result in proc_sctp_do_auth
      net: sctp: fix information leaks in ulpevent layer
      net: sctp: inherit auth_capable on INIT collisions

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

David S. Miller (8):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fault addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

David Vrabel (1):
      xen/manage: fix potential deadlock when resuming the console

Dmitry Kravkov (1):
      bnx2x: fix crash during TSO tunneling

Dmitry Popov (1):
      ip_tunnel: fix ip_tunnel_lookup

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Edward Allcutt (1):
      ipv4: icmp: Fix pMTU handling for rare case

Eliad Peller (1):
      cfg80211: fix mic_failure tracing

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't enable CTS to self

Eric Dumazet (8):
      ipv4: fix dst race in sk_dst_get()
      ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
      net: fix sparse warning in sk_dst_set()
      bnx2x: fix possible panic under memory stress
      ipv4: fix buffer overflow in ip_options_compile()
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Gao feng (1):
      ipv6: reallocate addrconf router for ipv6 address when lo device up

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

George Cherian (1):
      can: c_can_platform: Fix raminit, use devm_ioremap() instead of devm_ioremap_resource()

Guenter Roeck (2):
      hwmon: (adt7470) Fix writes to temperature limit registers
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hans Verkuil (1):
      [media] hdpvr: fix two audio bugs

Hans de Goede (1):
      [media] gspca_pac7302: Add new usb-id for Genius i-Look 317

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched

James Bottomley (1):
      scsi: handle flush errors properly

Jan Kara (1):
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks

Jason Wang (1):
      drm/qxl: return IRQ_NONE if it was not our irq

Jeff Layton (1):
      vfs: allow umount to handle mountpoints without revalidating them

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

John David Anglin (1):
      parisc: Remove SA_RESTORER define

John Stultz (2):
      alarmtimer: Fix bug where relative alarm timers were treated as absolute
      printk: rename printk_sched to printk_deferred

Jon Paul Maloy (1):
      tipc: clear 'next'-pointer of message fragments before reassembly

K. Y. Srinivasan (1):
      Drivers: hv: util: Fix a bug in the KVP code

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than 32

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Konstantin Khlebnikov (1):
      ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory layout

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Li RongQing (1):
      8021q: fix a potential memory leak

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance()  in scheduler

Loic Poulain (1):
      Bluetooth: Ignore H5 non-link packets in non-active state

Malcolm Priestley (2):
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
      staging: vt6655: Fix disassociated messages every 10 seconds

Manuel Schölling (1):
      dns_resolver: assure that dns_query() result is null-terminated

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation

Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

Michael Ellerman (1):
      powerpc/perf: Fix MMCR2 handling for EBB

Mike Snitzer (2):
      dm thin metadata: do not allow the data block size to change
      dm cache metadata: do not allow the data block size to change

Miklos Szeredi (2):
      fuse: timeout comparison fix
      fuse: handle large user and group ID

Mikulas Patocka (2):
      slab_common: fix the check for duplicate slab names
      block: provide compat ioctl for BLKZEROOUT

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Minfei Huang (1):
      lib/btree.c: fix leak of whole btree nodes

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Sasha Levin (2):
      net/l2tp: don't fall back on UDP [get|set]sockopt
      iovec: make sure the caller actually wants anything in memcpy_fromiovecend

Silesh C V (1):
      coredump: fix the setting of PF_DUMPCORE

Sowmini Varadhan (2):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()
      sparc64: ldc_connect() should not return EINVAL when handshake is in progress.

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down

Steven Rostedt (Red Hat) (1):
      tracing: Fix graph tracer with stack tracer on other archs

Suresh Reddy (1):
      be2net: set EQ DB clear-intr bit in be_open()

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Takashi Iwai (1):
      PM / sleep: Fix request_firmware() error at resume

Tejun Heo (2):
      blkcg: don't call into policy draining if root_blkg is already gone
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Thomas Fitzsimmons (1):
      net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Petazzoni (1):
      net: mvneta: fix operation in 10 Mbit/s mode

Tomasz Figa (1):
      irqchip: gic: Fix core ID calculation when topology is read from DT

Tony Luck (1):
      tracing: Fix wraparound problems in "uptime" trace clock

Vasily Averin (1):
      fs: umount on symlink leaks mnt count

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().

Yuchung Cheng (1):
      tcp: fix false undo corner cases

dingtianhong (1):
      igmp: fix the problem when mc leave group

willy tarreau (5):
      net: mvneta: increase the 64-bit rx/tx stats out of the hot path
      net: mvneta: use per_cpu stats to fix an SMP lock up
      net: mvneta: do not schedule in mvneta_tx_timeout
      net: mvneta: add missing bit descriptions for interrupt masks and causes
      net: mvneta: replace Tx timer with a real interrupt

zhangwei(Jovi) (2):
      tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
      tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
