Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaD0UPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 16:15:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaD0UPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 16:15:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.22
Date: Sun, 27 Apr 2014 13:15:08 -0700
Message-Id: <1398629709-4975-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.22 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.21 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/video4linux/gspca.txt                |   1 +
 Makefile                                           |   2 +-
 arch/arm/include/asm/futex.h                       |   6 -
 arch/arm/include/asm/pgtable-2level.h              |   1 +
 arch/arm/mach-omap2/irq.c                          |   8 +
 arch/arm/mm/Kconfig                                |   3 +-
 arch/arm/mm/mmu.c                                  |  10 +
 arch/arm/mm/proc-macros.S                          |  19 +-
 arch/arm/mm/proc-v7-2level.S                       |   7 -
 arch/arm64/include/asm/pgtable.h                   |   8 +-
 arch/mips/power/hibernate.S                        |   1 +
 arch/sh/kernel/dumpstack.c                         |   2 +-
 arch/sparc/Kconfig                                 |   2 +-
 arch/sparc/include/asm/uaccess_64.h                |   4 +-
 arch/sparc/kernel/pci.c                            |   4 +-
 arch/sparc/kernel/syscalls.S                       |   4 +-
 arch/x86/include/asm/cpufeature.h                  |   4 +
 arch/x86/include/asm/xsave.h                       |  13 +-
 arch/x86/kernel/cpu/mshyperv.c                     |   6 +
 arch/x86/kernel/early-quirks.c                     |  15 +-
 arch/x86/kernel/ldt.c                              |  11 +
 block/blk-core.c                                   |   2 +-
 drivers/block/mtip32xx/mtip32xx.c                  |  25 +-
 drivers/gpio/gpio-mxs.c                            |   3 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   8 +
 drivers/gpu/drm/i915/intel_display.c               |   3 +
 drivers/gpu/drm/i915/intel_tv.c                    |   9 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   5 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |  66 ++---
 drivers/infiniband/hw/mthca/mthca_provider.c       |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c              |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  16 +-
 drivers/isdn/isdnloop/isdnloop.c                   |  23 +-
 drivers/md/dm-thin-metadata.c                      |  80 +++---
 drivers/md/dm-thin.c                               |   2 +-
 drivers/md/persistent-data/dm-block-manager.c      |  14 +-
 drivers/md/persistent-data/dm-block-manager.h      |   3 +-
 .../md/persistent-data/dm-transaction-manager.c    |   5 +-
 .../md/persistent-data/dm-transaction-manager.h    |  17 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  19 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   1 +
 drivers/media/usb/uvc/uvc_video.c                  |  20 +-
 drivers/mfd/88pm860x-core.c                        |   6 +
 drivers/mfd/Kconfig                                |   6 +-
 drivers/mfd/max77686.c                             |   4 +
 drivers/mfd/max77693.c                             |  12 +-
 drivers/mfd/max8925-i2c.c                          |   9 +
 drivers/mfd/max8997.c                              |  18 ++
 drivers/mfd/max8998.c                              |   4 +
 drivers/mfd/sec-core.c                             |   4 +
 drivers/mfd/tps65910.c                             |   4 +-
 drivers/mtd/nand/atmel_nand.c                      |   1 +
 drivers/net/usb/usbnet.c                           |  33 +--
 drivers/net/vxlan.c                                |   3 +
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/b43/phy_n.c                   |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |  27 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |  18 +-
 drivers/net/xen-netback/netback.c                  |   4 +-
 drivers/regulator/arizona-ldo1.c                   |   6 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   1 +
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/tty_io.c                               |  23 +-
 drivers/usb/core/driver.c                          |  94 ++++---
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/usb.h                             |   2 +-
 drivers/usb/dwc3/core.h                            |   6 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   8 +-
 drivers/usb/gadget/tcm_usb_gadget.c                |   2 +-
 drivers/usb/host/xhci-pci.c                        |  11 +-
 drivers/vhost/net.c                                |  20 +-
 drivers/video/aty/mach64_accel.c                   |   3 +-
 drivers/video/aty/mach64_cursor.c                  |  22 +-
 drivers/video/cfbcopyarea.c                        | 153 +++++------
 drivers/video/matrox/matroxfb_accel.c              |  38 ++-
 drivers/video/matrox/matroxfb_base.h               |   2 +
 drivers/video/tgafb.c                              | 279 +++++----------------
 drivers/virtio/virtio_balloon.c                    |   6 +
 drivers/w1/w1_netlink.c                            |  25 +-
 fs/btrfs/disk-io.c                                 |   4 +
 fs/btrfs/transaction.c                             |  14 +-
 fs/file_table.c                                    |   4 +-
 fs/jffs2/compr_rtime.c                             |   4 +-
 fs/jffs2/nodelist.h                                |   2 +-
 fs/jffs2/nodemgmt.c                                |  14 +-
 fs/lockd/svc.c                                     |   1 +
 fs/nfs/nfs4proc.c                                  |  19 +-
 fs/nfsd/nfs4proc.c                                 |   9 +-
 fs/nfsd/nfs4state.c                                |  13 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nfsd/nfsctl.c                                   |   5 +
 fs/nfsd/nfsd.h                                     |   2 +-
 fs/nfsd/vfs.c                                      |   9 +
 fs/ocfs2/buffer_head_io.c                          |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                         |  29 ++-
 fs/open.c                                          |  26 +-
 fs/reiserfs/dir.c                                  |   6 +-
 include/linux/sched.h                              |  20 +-
 include/linux/sunrpc/svcsock.h                     |   1 +
 include/linux/usb/usbnet.h                         |   2 +-
 include/net/sock.h                                 |   5 +
 include/trace/events/block.h                       |  33 ++-
 kernel/auditsc.c                                   |   6 +-
 kernel/exit.c                                      |  15 +-
 kernel/pid_namespace.c                             |   4 +-
 kernel/sysctl.c                                    |   6 +
 kernel/trace/blktrace.c                            |  20 +-
 lib/nlattr.c                                       |  10 +-
 lib/percpu_counter.c                               |   2 +-
 mm/hugetlb.c                                       |   1 +
 mm/mlock.c                                         |   2 +
 mm/rmap.c                                          |  14 +-
 net/8021q/vlan_dev.c                               |   3 +
 net/bluetooth/hci_event.c                          |   8 +-
 net/bridge/br_multicast.c                          |   6 +
 net/core/rtnetlink.c                               |  10 +-
 net/core/sock.c                                    |   5 +-
 net/ipv4/ipmr.c                                    |  13 +-
 net/ipv4/tcp_output.c                              |  11 +
 net/ipv6/addrconf.c                                |   5 +-
 net/ipv6/exthdrs_offload.c                         |   4 +-
 net/ipv6/icmp.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  18 +-
 net/ipv6/ip6mr.c                                   |  13 +-
 net/ipv6/mcast.c                                   |  11 +-
 net/ipv6/route.c                                   |   2 +-
 net/rds/iw.c                                       |   3 +-
 net/sctp/sm_make_chunk.c                           |   4 +-
 net/sctp/sm_statefuns.c                            |   5 -
 net/socket.c                                       |   4 +
 net/sunrpc/svcsock.c                               |  16 ++
 net/unix/af_unix.c                                 |  17 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/ice1712/ice1712.c                        |  15 +-
 sound/soc/codecs/cs42l51.c                         |   9 +-
 sound/soc/codecs/cs42l52.c                         |   8 +-
 sound/soc/codecs/cs42l73.c                         |   6 +-
 143 files changed, 1100 insertions(+), 775 deletions(-)

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Al Viro (1):
      don't bother with {get,put}_write_access() on non-regular files

Alan Stern (1):
      USB: unbind all interfaces before rebinding any

Alex Deucher (1):
      drm/radeon: call drm_edid_to_eld when we update the edid

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Anton Nayshtut (1):
      ipv6: Fix exthdrs offload registration.

Brian Austin (3):
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols

Catalin Marinas (3):
      arm64: Use Normal NonCacheable memory for writecombine
      arm64: Make DMA coherent and strongly ordered mappings not executable
      arm64: Do not synchronise I and D caches for special ptes

Charles Keepax (1):
      regulator: arizona-ldo1: Correct default regulator init_data

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (1):
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Dave Kleikamp (2):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."
      sparc64: don't treat 64-bit syscall return codes as 32-bit

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

David Stevens (1):
      vxlan: fix potential NULL dereference in arp_reduce()

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command

Eric Dumazet (2):
      net: unix: non blocking recvmsg() should not return -EINTR
      tcp: tcp_release_cb() should release socket ownership

Felipe Franciosi (2):
      mtip32xx: Set queue bounce limit
      mtip32xx: Unmap the DMA segments before completing the IO request

Felix Fietkau (1):
      ath9k: fix ready time of the multicast buffer queue

Fenghua Yu (2):
      x86, AVX-512: AVX-512 Feature Detection
      x86, AVX-512: Enable AVX-512 States Context Switch

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

J. Bruce Fields (6):
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: session needs room for following op to error out
      nfsd4: leave reply buffer space for failed setattr
      nfsd4: fix test_stateid error reply encoding
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

Jani Nikula (2):
      drm/i915: quirk invert brightness for Acer Aspire 5336
      drm/i915/tv: fix gen4 composite s-video tv-out

Jason Wang (1):
      x86, hyperv: Bypass the timer_irq_works() check

Jeff Layton (1):
      lockd: ensure we tear down any live sockets when socket creation fails during lockd_up

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend

Joe Thornber (2):
      dm transaction manager: fix corruption due to non-atomic transaction commit
      dm: take care to copy the space map roots before locking the superblock

Josef Bacik (1):
      Btrfs: fix deadlock with nested trans handles

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

Kamal Mostafa (1):
      Linux 3.8.13.22

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kinglong Mee (1):
      NFSD: Traverse unconfirmed client through hash-table

Krzysztof Kozlowski (9):
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail

Larry Finger (3):
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs
      rtlwifi: rtl8723ae: Fix too long disable of IRQs

Li Zefan (2):
      jffs2: remove from wait queue after schedule()
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Linus Lüssing (1):
      bridge: multicast: add sanity check for query source addresses

Linus Walleij (1):
      mfd: Include all drivers in subsystem menu

Liu Hua (1):
      hung_task: check the value of "sysctl_hung_task_timeout_sec"

Malcolm Priestley (2):
      [media] m88rs2000: add caps FE_CAN_INVERSION_AUTO
      [media] m88rs2000: prevent frontend crash on continuous transponder scans

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Fleming (1):
      sh: fix format string bug in stack tracer

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Mike Marciniszyn (1):
      ib_srpt: Use correct ib_sg_dma primitives

Mike Snitzer (1):
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (6):
      matroxfb: restore the registers M_ACCESS and M_PITCH
      framebuffer: fix cfb_copyarea
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix mode setting with fbset
      tgafb: fix data copying

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are freed.

Neil Horman (1):
      x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Nicholas Bellinger (1):
      iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Nicolas Dichtel (3):
      rtnetlink: fix fdb notification flags
      ipmr: fix mfc notification flags
      ip6mr: fix mfc notification flags

Oleg Nesterov (2):
      pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

Oleksij Rempel (1):
      [media] uvcvideo: Do not use usb_set_interface on bulk EP

Oliver Neukum (1):
      usbnet: include wait queue head in device structure

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement

Paul Gortmaker (2):
      sparc32: fix build failure for arch_jump_label_transform
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Peter Boström (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Rafał Miłecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_PHY_HDR

Richard Guy Briggs (2):
      pid: get pid_t ppid of task in init_pid_ns
      audit: convert PPIDs to the inital PID namespace.

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Stanislav Kinsbursky (1):
      nfsd: check passed socket's net matches NFSd superblock's one

Stefan Sørensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Takashi Iwai (1):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops

Trond Myklebust (1):
      NFSv4: Fix a use-after-free problem in open()

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Will Deacon (1):
      ARM: 7954/1: mm: remove remaining domain support from ARMv6

Wolfram Sang (1):
      [media] media: gspca: sn9c20x: add ID for Genius Look 1320 V2

YOSHIFUJI Hideaki / 吉藤英明 (1):
      isdnloop: Validate NUL-terminated strings from user.

Yann Droneaud (3):
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges

