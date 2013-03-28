Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3C1KSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:18:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3C1KR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:17:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [3.5.y.z extended stable] Linux 3.5.7.9
Date: Thu, 28 Mar 2013 10:17:50 +0000
Message-Id: <1364465871-24594-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.9 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.8 release are
shown below.

-Luis

-- 
 .../devicetree/bindings/tty/serial/of-serial.txt   |   3 +
 Makefile                                           |   2 +-
 arch/arm/include/asm/signal.h                      |   1 +
 arch/arm/mach-at91/include/mach/at91_rtc.h         |   1 -
 arch/avr32/include/asm/signal.h                    |   1 +
 arch/cris/include/asm/signal.h                     |   1 +
 arch/h8300/include/asm/signal.h                    |   1 +
 arch/m32r/include/asm/signal.h                     |   1 +
 arch/m68k/include/asm/signal.h                     |   1 +
 arch/mn10300/include/asm/signal.h                  |   1 +
 arch/powerpc/include/asm/signal.h                  |   1 +
 arch/powerpc/kernel/cputable.c                     |   2 +-
 arch/powerpc/mm/hash_utils_64.c                    |   2 +
 arch/s390/include/asm/signal.h                     |   1 +
 arch/s390/include/asm/tlbflush.h                   |   2 -
 arch/s390/kernel/entry.S                           |   3 +-
 arch/s390/kernel/entry64.S                         |   5 +-
 arch/sparc/include/asm/signal.h                    |   1 +
 arch/x86/include/asm/signal.h                      |   2 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  10 +
 arch/x86/lib/usercopy_64.c                         |   4 +-
 arch/x86/power/cpu.c                               |   2 +
 arch/xtensa/include/asm/signal.h                   |   1 +
 drivers/ata/ahci.c                                 |  32 ++
 drivers/block/loop.c                               |  24 +-
 drivers/char/hw_random/virtio-rng.c                |  13 +-
 drivers/connector/cn_proc.c                        |  10 +-
 drivers/gpu/drm/drm_edid.c                         |   3 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  11 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  10 +-
 drivers/gpu/drm/radeon/ni.c                        |  32 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |  16 +-
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-sony.c                             |  18 +-
 drivers/hwmon/lineage-pem.c                        |   2 +
 drivers/hwmon/pmbus/ltc2978.c                      |  14 +-
 drivers/hwmon/sht15.c                              |   2 +-
 drivers/i2c/busses/i2c-tegra.c                     |  13 +-
 drivers/md/dm-bufio.c                              |   2 +
 drivers/md/dm-thin.c                               |   4 +-
 drivers/md/dm-verity.c                             |  39 ++-
 drivers/md/persistent-data/dm-btree-remove.c       |  46 +--
 drivers/net/bonding/bond_main.c                    |   6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |   3 +-
 drivers/net/ethernet/broadcom/tg3.c                |   8 +
 drivers/net/ethernet/sfc/bitfield.h                |  22 +-
 drivers/net/ethernet/sfc/efx.c                     |  21 +-
 drivers/net/ethernet/sfc/efx.h                     |  13 +
 drivers/net/ethernet/sfc/falcon.c                  |  37 ++-
 drivers/net/ethernet/sfc/mcdi.c                    |  33 +-
 drivers/net/ethernet/sfc/mcdi.h                    |   6 +-
 drivers/net/ethernet/sfc/net_driver.h              |  14 +-
 drivers/net/ethernet/sfc/nic.c                     |  65 +++-
 drivers/net/ethernet/sfc/nic.h                     |   2 +
 drivers/net/ethernet/sfc/rx.c                      |  25 +-
 drivers/net/ethernet/sfc/selftest.c                |  64 +---
 drivers/net/ethernet/sfc/siena.c                   |  44 ++-
 drivers/net/ethernet/sfc/siena_sriov.c             |  13 +-
 drivers/net/macvlan.c                              |   1 +
 drivers/net/netconsole.c                           |  20 +-
 drivers/net/tun.c                                  |   2 +
 drivers/net/wireless/mwifiex/join.c                |   7 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   2 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  89 +++---
 drivers/rtc/rtc-at91rm9200.c                       |  50 +--
 drivers/staging/vt6656/main_usb.c                  |   4 -
 drivers/target/iscsi/iscsi_target_auth.c           |   5 +-
 drivers/target/target_core_file.h                  |   2 +-
 drivers/tty/pty.c                                  |   1 -
 drivers/tty/serial/8250/8250.c                     |  21 ++
 drivers/tty/serial/8250/8250_pci.c                 |  21 +-
 drivers/tty/serial/Kconfig                         |   2 +-
 drivers/tty/serial/of_serial.c                     |   6 +
 drivers/tty/serial/sunsu.c                         |  21 +-
 drivers/usb/class/cdc-acm.c                        |   3 +-
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/core/hcd-pci.c                         |  23 +-
 drivers/usb/gadget/g_ffs.c                         |   4 +-
 drivers/usb/gadget/udc-core.c                      |   2 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/host/xhci.h                            |   4 +-
 drivers/usb/serial/cp210x.c                        |  20 ++
 drivers/usb/serial/garmin_gps.c                    |   7 +-
 drivers/usb/serial/io_ti.c                         |   1 +
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/serial/qcaux.c                         |   1 +
 drivers/usb/serial/usb-serial.c                    |   3 +-
 drivers/usb/storage/initializers.c                 |  76 +----
 drivers/usb/storage/initializers.h                 |   4 +-
 drivers/usb/storage/unusual_devs.h                 | 336 ++++++++++++++++++++-
 drivers/vhost/net.c                                |   3 +-
 drivers/video/atmel_lcdfb.c                        |  22 +-
 drivers/w1/w1.c                                    |   3 +-
 fs/block_dev.c                                     |   4 +-
 fs/btrfs/volumes.c                                 |   6 +
 fs/cifs/asn1.c                                     |  53 +---
 fs/cifs/cifsfs.c                                   |  24 ++
 fs/cifs/cifsfs.h                                   |   4 +
 fs/cifs/file.c                                     |   6 +-
 fs/ext3/super.c                                    |   4 +-
 fs/ext4/ext4.h                                     |   6 +-
 fs/ext4/extents.c                                  |   6 +-
 fs/ext4/ialloc.c                                   |   4 +-
 fs/ext4/inode.c                                    |   3 +-
 fs/ext4/mballoc.c                                  |  12 +-
 fs/ext4/resize.c                                   |   4 +-
 fs/ext4/super.c                                    |   4 +-
 fs/isofs/export.c                                  |   1 +
 fs/jbd2/transaction.c                              |  15 +-
 fs/proc/inode.c                                    |  12 +-
 fs/udf/namei.c                                     |   1 +
 include/asm-generic/signal.h                       |   4 +
 include/drm/drm_pciids.h                           |  13 +-
 include/linux/perf_event.h                         |   6 +
 include/linux/serial_core.h                        |   5 +-
 include/linux/skbuff.h                             |   7 +-
 include/net/inet_frag.h                            |   9 +
 include/net/ip_fib.h                               |  12 +-
 include/video/atmel_lcdc.h                         |   1 +
 kernel/signal.c                                    |   3 +
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.c                               |   9 +-
 mm/hugetlb.c                                       |   8 +-
 mm/memory_hotplug.c                                |  15 +-
 net/core/dev.c                                     |   1 +
 net/core/rtnetlink.c                               |   3 +-
 net/dcb/dcbnl.c                                    |   8 +
 net/ieee802154/6lowpan.h                           |   2 +-
 net/ipv4/inet_fragment.c                           |  20 +-
 net/ipv4/ip_fragment.c                             |  11 +-
 net/ipv4/ip_options.c                              |   5 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_output.c                              |   1 -
 net/ipv6/ip6_input.c                               |   3 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  11 +-
 net/ipv6/reassembly.c                              |   8 +-
 net/ipv6/route.c                                   |   3 +-
 net/l2tp/l2tp_ppp.c                                |   1 +
 net/netlabel/netlabel_unlabeled.c                  |  27 +-
 net/rds/message.c                                  |   3 +
 net/sctp/associola.c                               |   2 +-
 net/sctp/sm_statefuns.c                            |   2 +-
 security/keys/keyctl.c                             |   4 +-
 security/selinux/xfrm.c                            |   2 +-
 sound/core/seq/seq_timer.c                         |   8 +-
 sound/pci/hda/hda_codec.c                          |   2 +-
 sound/pci/hda/patch_conexant.c                     |   8 +-
 sound/usb/mixer.c                                  |  16 +-
 tools/hv/hv_kvp_daemon.c                           |   8 +-
 152 files changed, 1339 insertions(+), 610 deletions(-)

Alan Cox (1):
      key: Fix resource leak

Alan Stern (1):
      usb: gadget: udc-core: fix a regression during gadget driver unbinding

Alex Deucher (4):
      drm/radeon: fix backend map setup on 1 RB trinity boards
      drm/radeon/benchmark: make sure bo blit copy exists before using it
      drm/radeon: add support for Richland APUs
      drm/radeon: add Richland pci ids

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

Andrew Morton (1):
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Andrzej Pietrasiewicz (1):
      usb: gadget: ffs: fix enable multiple instances

Andy Grover (1):
      target/iscsi: Fix mutual CHAP auth on big-endian arches

Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan]_attributes

Ben Hutchings (17):
      hwmon: (sht15) Fix memory leak if regulator_enable() fails
      sfc: Disable VF queues during register self-test
      sfc: Really disable flow control while flushing
      sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
      sfc: Add parentheses around use of bitfield macro arguments
      sfc: Fix MCDI structure field lookup
      sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
      sfc: Correctly initialise reset_method in siena_test_chip()
      sfc: Fix timekeeping in efx_mcdi_poll()
      sfc: Properly sync RX DMA buffer when it is not the last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
      sfc: Correct efx_rx_buffer::page_offset when EFX_PAGE_IP_ALIGN != 0
      sfc: Detach net device when stopping queues for reconfiguration
      sfc: Only use TX push if a single descriptor is to be written
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer
      vfs,proc: guarantee unique inodes in /proc

Benjamin Herrenschmidt (2):
      powerpc: Fix STAB initialization
      powerpc: Fix cputable entry for 970MP rev 1.0

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

Bjørn Mork (2):
      USB: option: add Huawei E5331
      USB: storage: fix Huawei mode switching regression

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8

Cong Wang (1):
      rds: limit the size allocated by rds_message_alloc()

Cristian Bercaru (1):
      bridging: fix rx_handlers return code

Dan Carpenter (1):
      selinux: use GFP_ATOMIC under spin_lock

Dan Williams (1):
      qcaux: add Franklin U600

Daniel Mack (2):
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Pieczko (2):
      sfc: Work-around flush timeout when flushes have completed
      sfc: lock TX queues when calling netif_device_detach()

David Rientjes (1):
      perf,x86: fix link failure for non-Intel configs

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Eric Dumazet (2):
      tun: add a missing nf_reset() in tun_net_xmit()
      tcp: fix skb_availroom()

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Fernando Luis Vázquez Cao (2):
      HID: add support for Sony RF receiver with USB product id 0x0374
      HID: clean up quirk for Sony RF receivers

Guenter Roeck (1):
      hwmon: (pmbus/ltc2978) Fix temperature reporting

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Guo Chao (3):
      block: use i_size_write() in bd_set_size()
      loopdev: fix a deadlock
      loopdev: remove an user triggerable oops

Hannes Frederic Sowa (2):
      ipv6: stop multicast forwarding to process interface scoped addresses
      inet: limit length of fragment queue hash table bucket lists

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts

Heiko Carstens (1):
      s390/mm: fix flush_tlb_kernel_range()

James Ralston (2):
      ahci: Add Device IDs for Intel Lynx Point-LP PCH
      ahci: Add Device IDs for Intel Wellsburg PCH

Jan Kara (1):
      jbd2: fix use after free in jbd2_journal_dirty_metadata()

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Jiang Liu (1):
      mm/hotplug: correctly add new zone to all other nodes' zone lists

Jiri Slaby (1):
      TTY: do not reset master's packet mode

Joe Thornber (1):
      dm thin: fix discard corruption

Johan Hovold (5):
      atmel_lcdfb: fix 16-bpp modes on older SOCs
      USB: cdc-acm: fix device unregistration
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters
      USB: serial: fix interface refcounting

Julia Lemire (1):
      drm/mgag200: Bug fix: Modified pll algorithm for EH project

Kees Cook (4):
      signal: always clear sa_restorer on execve
      proc connector: reject unprivileged listener bumps
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Lars-Peter Clausen (1):
      ext3: Fix format string issues

Laxman Dewangan (1):
      i2c: tegra: check the clk_prepare_enable() return value

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port

Lingzhu Xiang (1):
      rt2x00: error in configurations with mesh support disabled

Linus Torvalds (1):
      perf,x86: fix wrmsr_on_cpu() warning on suspend/resume

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=2

Luis Henriques (1):
      Linux 3.5.7.9

Maciej Żenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Martin Schwidefsky (1):
      s390: critical section cleanup vs. machine checks

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo objects are gone

Mathias Krause (4):
      rtnl: fix info leak on RTM_GETLINK request for VF devices
      dcbnl: fix various netlink info leaks
      udf: avoid info leak on export
      isofs: avoid info leak on export

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Mikulas Patocka (1):
      dm verity: avoid deadlock

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving receiver fast path

Nicholas Bellinger (1):
      target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os

Nicolas Ferre (1):
      drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Paul Bolle (1):
      tty: serial: fix typo "ARCH_S5P6450"

Paul Moore (2):
      netlabel: correctly list all the static label mappings
      netlabel: fix build problems when CONFIG_IPV6=n

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Seth Heasley (1):
      ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs

Stephane Eranian (1):
      perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

Steven Rostedt (Red Hat) (3):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()
      tracing: Keep overwrite in sync between regular and snapshot buffers

Takashi Iwai (3):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()
      ALSA: hda/cirrus - Fix the digital beep registration
      ALSA: hda - Fix typo in checking IEC958 emphasis bit

Theodore Ts'o (2):
      ext4: use atomic64_t for the per-flexbg free_clusters count
      ext4: fix data=journal fast mount/umount hang

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=ttySY" cmdline option

Tomas Hozza (1):
      tools: hv: Netlink source address validation allows DoS

Torsten Duwe (2):
      KMS: fix EDID detailed timing vsync parsing
      KMS: fix EDID detailed timing frame rate

Veaceslav Falico (2):
      netconsole: don't call __netpoll_cleanup() while atomic
      bonding: don't call update_speed_duplex() under spinlocks

Vlad Yasevich (3):
      macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.
      sctp: Use correct sideffect command in duplicate cookie handling
      rtnetlink: Mask the rta_type when range checking

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to find the matched transport

YOSHIFUJI Hideaki / 吉藤英明 (1):
      6lowpan: Fix endianness issue in is_addr_link_local().

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_extent()

