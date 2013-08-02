Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab3HBJuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:50:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab3HBJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:50:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.18
Date: Fri,  2 Aug 2013 10:50:14 +0100
Message-Id: <1375437015-5631-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.18 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.17 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 MAINTAINERS                                     |   1 +
 Makefile                                        |   2 +-
 arch/arm/mach-shmobile/setup-emev2.c            |   8 +-
 arch/powerpc/include/asm/module.h               |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S               |   3 -
 arch/sparc/kernel/asm-offsets.c                 |   2 +
 arch/sparc/mm/hypersparc.S                      |   8 +-
 arch/sparc/mm/init_64.c                         |   9 +-
 arch/sparc/mm/swift.S                           |   8 +-
 arch/sparc/mm/tlb.c                             |   2 +-
 arch/sparc/mm/tsunami.S                         |   6 +-
 arch/sparc/mm/viking.S                          |  10 +-
 drivers/acpi/acpi_memhotplug.c                  |   1 +
 drivers/ata/ata_piix.c                          |   2 +-
 drivers/block/xen-blkback/blkback.c             |  13 +-
 drivers/gpu/drm/radeon/atombios_dp.c            |  43 ++++++-
 drivers/gpu/drm/radeon/evergreen_hdmi.c         |   3 +
 drivers/gpu/drm/radeon/r600_hdmi.c              |   6 +
 drivers/gpu/drm/radeon/radeon_combios.c         | 159 ++++++++----------------
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |   9 +-
 drivers/md/dm-mpath.c                           |   8 +-
 drivers/md/dm-verity.c                          |   5 +-
 drivers/md/dm.c                                 |   9 +-
 drivers/md/raid10.c                             |   8 +-
 drivers/md/raid5.c                              |  15 ++-
 drivers/md/raid5.h                              |   1 +
 drivers/media/dvb/dvb-core/dmxdev.c             |   8 +-
 drivers/media/video/saa7134/saa7134-alsa.c      |   2 +
 drivers/net/dummy.c                             |   4 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  50 +++++++-
 drivers/net/ethernet/renesas/sh_eth.c           |  28 +++--
 drivers/net/ethernet/renesas/sh_eth.h           |   2 +-
 drivers/net/ethernet/sun/sunvnet.c              |   2 +
 drivers/net/ifb.c                               |   8 +-
 drivers/net/macvtap.c                           |  14 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |   2 +-
 drivers/scsi/isci/task.c                        |   9 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  10 +-
 drivers/scsi/qla2xxx/qla_iocb.c                 |  11 +-
 drivers/scsi/sd.c                               |  22 ++--
 drivers/staging/android/logger.c                |   4 +-
 drivers/staging/comedi/comedi_fops.c            |  32 +++--
 drivers/staging/line6/pcm.c                     |   5 +-
 drivers/target/iscsi/iscsi_target_configfs.c    |   2 +-
 drivers/usb/core/hub.c                          |   9 ++
 drivers/usb/dwc3/core.h                         |   4 +-
 drivers/usb/dwc3/gadget.c                       |   1 +
 drivers/usb/host/ehci-hub.c                     |   1 +
 drivers/usb/host/xhci-pci.c                     |   1 -
 drivers/usb/host/xhci-ring.c                    |   2 +-
 drivers/usb/host/xhci.c                         |  13 +-
 drivers/usb/misc/sisusbvga/sisusb.c             |   1 +
 drivers/usb/serial/cp210x.c                     |   4 +
 drivers/usb/serial/mos7840.c                    |  25 ++--
 drivers/usb/serial/option.c                     |  23 ++--
 drivers/usb/serial/ti_usb_3410_5052.c           |   2 +-
 drivers/usb/storage/unusual_devs.h              |   7 ++
 fs/block_dev.c                                  |   9 +-
 fs/btrfs/extent-tree.c                          |   2 +
 fs/cifs/inode.c                                 |   5 +
 fs/ext4/mballoc.c                               |  11 +-
 fs/ext4/super.c                                 |   6 -
 fs/lockd/svclock.c                              |   4 +
 fs/nfsd/nfs4xdr.c                               |   2 +-
 fs/nfsd/vfs.c                                   |   5 +-
 fs/notify/fanotify/fanotify_user.c              |   1 +
 include/linux/if_pppox.h                        |   4 +-
 include/net/addrconf.h                          |   3 +
 include/net/udp.h                               |   1 +
 kernel/events/core.c                            |  28 ++++-
 kernel/hrtimer.c                                |  28 ++---
 kernel/power/autosleep.c                        |   3 +-
 kernel/trace/trace_syscalls.c                   |  21 +++-
 kernel/trace/trace_uprobe.c                     |   4 +-
 net/8021q/vlan_dev.c                            |   7 ++
 net/9p/trans_common.c                           |  10 +-
 net/bridge/br_multicast.c                       |   5 +-
 net/core/neighbour.c                            |  12 +-
 net/ipv4/tcp_ipv4.c                             |   4 +-
 net/ipv4/udp.c                                  |   3 +-
 net/ipv6/addrconf.c                             |  31 +++--
 net/ipv6/ip6_output.c                           |  24 ++--
 net/ipv6/mcast.c                                |  18 +--
 net/ipv6/route.c                                |   9 +-
 net/ipv6/udp.c                                  |   7 +-
 net/key/af_key.c                                |   2 +
 net/l2tp/l2tp_ppp.c                             |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c          |  20 ++-
 net/x25/af_x25.c                                |  15 +--
 sound/arm/pxa2xx-pcm-lib.c                      |   2 +
 sound/pci/asihpi/asihpi.c                       |   3 +
 sound/pci/atiixp.c                              |   2 +
 sound/pci/atiixp_modem.c                        |   2 +
 sound/pci/hda/patch_hdmi.c                      |   4 +
 sound/soc/codecs/max98088.c                     |   2 +-
 sound/soc/codecs/sgtl5000.c                     |   2 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/s6000/s6000-pcm.c                     |   2 +
 sound/usb/6fire/pcm.c                           |  14 ++-
 sound/usb/misc/ua101.c                          |  14 ++-
 sound/usb/usx2y/usbusx2yaudio.c                 |   4 +
 101 files changed, 653 insertions(+), 361 deletions(-)

Aaron Plattner (2):
      ALSA: hda - Add new GPU codec ID to snd-hda
      ALSA: hda - Add new GPU codec ID to snd-hda

Alex Deucher (3):
      drm/radeon/hdmi: make sure we have an afmt block assigned
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock

Andi Kleen (1):
      [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Aydin Arik (1):
      ipv4: Fixed MD5 key lookups when adding/ removing MD5 to/ from TCP sockets.

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Bjørn Mork (2):
      [SCSI] megaraid_sas: fix memory leak if SGL has zero length entries
      usb: option: add TP-LINK MA260

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Dan Carpenter (2):
      svcrdma: underflow issue in decode_write_list()
      fanotify: info leak in copy_event_to_user()

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.

Dave Kleikamp (2):
      sunvnet: vnet_port_remove must call unregister_netdev
      sparc: tsb must be flushed before tlb

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication

Enrico Mioso (3):
      usb: serial: option: Add ONYX 3G device support
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Eric Dumazet (3):
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst
      neighbour: fix a race in neigh_destroy()
      vlan: fix a race in egress prio management

Ewan D. Milne (1):
      [SCSI] sd: fix crash when UA received on DIF enabled device

Fabio Estevam (2):
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Gao feng (1):
      ipv6: don't call addrconf_dst_alloc again when enable lo

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0

Greg Kroah-Hartman (1):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information

Hannes Frederic Sowa (3):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
      ipv6: in case of link failure remove route directly instead of letting it expire

Hannes Reinecke (1):
      dm mpath: fix ioctl deadlock when no paths

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (2):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
      staging: comedi: fix a race between do_cmd_ioctl() and read/write

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jan Kara (1):
      writeback: Fix periodic writeback after fs mount

Jason Wang (1):
      macvtap: correctly linearize skb when zerocopy is used

Jeff Skirvin (1):
      [SCSI] isci: Fix a race condition in the SSP task management path

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario

Johan Hovold (2):
      USB: ti_usb_3410_5052: fix dynamic-id matching
      USB: mos7840: fix memory leak in open

Josef Bacik (1):
      Btrfs: fix lock leak when resuming snapshot deletion

Jóhann B. Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Jörn Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check device permissions before allowing OP_DISCARD

Linus Lüssing (1):
      bridge: fix switched interval for MLD Query types

Liu ShuoX (1):
      PM / Sleep: avoid 'autosleep' in shutdown progress

Luis Henriques (1):
      Linux 3.5.7.18

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter

Magnus Damm (1):
      ARM: shmobile: emev2 GIO3 resource fix

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Mathias Krause (1):
      af_key: fix info leaks in notify messages

Michael S. Tsirkin (1):
      macvtap: fix recovery from gup errors

Mikulas Patocka (1):
      dm verity: fix inability to use a few specific devices sizes

Neil Horman (2):
      atl1e: fix dma mapping warnings
      atl1e: unmap partially mapped skb on dma error and free skb

NeilBrown (2):
      md/raid10: remove use-after-free bug.
      md/raid5: fix interaction of 'replace' and 'recovery'.

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Roger Quadros (1):
      USB: EHCI: Fix resume signalling on remote wakeup

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption

Saurav Kashyap (1):
      [SCSI] qla2xxx: Properly set the tagging for commands.

Sergei Shtylyov (1):
      sh_eth: fix unhandled RFE interrupt

Sergey Senozhatsky (1):
      radeon kms: do not flush uninitialized hotplug work

Soeren Moch (1):
      [media] media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Steve French (1):
      [CIFS] use sensible file nlink values if unprovided

Takashi Iwai (9):
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      [media] saa7134: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call

Theodore Ts'o (2):
      ext4: don't show usrquota/grpquota twice in /proc/mounts
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

Thomas Gleixner (1):
      hrtimers: Move SMP function call to thread context

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH

bob picco (1):
      sparc64 address-congruence property

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed

zhangwei(Jovi) (2):
      uprobes: Fix return value in error handling path
      tracing: Fix irqs-off tag display in syscall tracing

