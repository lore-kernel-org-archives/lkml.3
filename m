Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3KHCQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3KHCQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.13 stable review
Date: Thu,  7 Nov 2013 18:14:15 -0800
Message-Id: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.13 stable kernel.

This version contains 91 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.13 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/networking/ip-sysctl.txt       |   9 ++
 arch/parisc/kernel/head.S                    |   4 +
 arch/um/kernel/exitcode.c                    |   4 +-
 arch/xtensa/kernel/signal.c                  |   2 +-
 drivers/acpi/acpica/exoparg1.c               |  48 +++++++--
 drivers/acpi/acpica/exstore.c                | 151 ++++++++++++++++++---------
 drivers/ata/libata-eh.c                      |   6 +-
 drivers/clk/versatile/clk-icst.c             |   2 +-
 drivers/connector/cn_proc.c                  |  17 +++
 drivers/connector/connector.c                |   7 +-
 drivers/firmware/dmi_scan.c                  |  12 ++-
 drivers/gpu/drm/drm_drv.c                    |   9 +-
 drivers/gpu/drm/i915/intel_lvds.c            |  32 ++++++
 drivers/gpu/drm/radeon/atombios_encoders.c   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |  17 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c     |   2 +-
 drivers/md/md.c                              |   5 +-
 drivers/md/raid1.c                           |   1 +
 drivers/md/raid10.c                          |   1 +
 drivers/md/raid5.c                           |  20 ++++
 drivers/net/can/dev.c                        |  10 +-
 drivers/net/can/flexcan.c                    |   4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c   |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c       |   3 +-
 drivers/net/ppp/ppp_generic.c                |   3 +-
 drivers/net/virtio_net.c                     |   8 ++
 drivers/net/vxlan.c                          |   2 +-
 drivers/net/wan/farsync.c                    |   1 +
 drivers/net/wan/wanxl.c                      |   1 +
 drivers/net/wireless/ath/ath9k/main.c        |  22 ++--
 drivers/net/wireless/mwifiex/main.c          |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   3 +-
 drivers/net/xen-netback/common.h             |   1 +
 drivers/net/xen-netback/interface.c          |  12 ++-
 drivers/net/xen-netback/xenbus.c             |  17 ++-
 drivers/scsi/aacraid/linit.c                 |   2 +
 drivers/staging/bcm/Bcmchar.c                |   1 +
 drivers/staging/ozwpan/ozcdev.c              |   3 +
 drivers/staging/sb105x/sb_pci_mp.c           |   2 +-
 drivers/staging/wlags49_h2/wl_priv.c         |   9 +-
 drivers/target/target_core_pscsi.c           |   8 +-
 drivers/uio/uio.c                            |  16 ++-
 drivers/vhost/tcm_vhost.c                    |   2 +-
 drivers/video/au1100fb.c                     |  26 +----
 drivers/video/au1200fb.c                     |  25 +----
 fs/ecryptfs/keystore.c                       |   8 +-
 fs/jfs/jfs_inode.c                           |   3 +-
 include/linux/mod_devicetable.h              |   6 +-
 include/linux/skbuff.h                       |  15 +++
 include/net/cipso_ipv4.h                     |   6 +-
 include/net/dst.h                            |  12 +++
 include/net/sock.h                           |   2 +
 include/net/tcp.h                            |   1 +
 include/uapi/drm/drm_mode.h                  |   2 +
 lib/scatterlist.c                            |   3 +-
 mm/huge_memory.c                             |  79 ++++++++------
 mm/memory.c                                  |  53 ++++------
 mm/migrate.c                                 | 112 ++++++++++----------
 mm/mprotect.c                                |   2 +-
 net/8021q/vlan_netlink.c                     |   2 +-
 net/bridge/br_stp_if.c                       |   2 +-
 net/compat.c                                 |   2 +
 net/core/secure_seq.c                        |   2 +
 net/core/sock.c                              |   1 +
 net/ipv4/ah4.c                               |   3 +-
 net/ipv4/inet_hashtables.c                   |   2 +-
 net/ipv4/ip_fragment.c                       |   2 +-
 net/ipv4/ip_output.c                         |   2 +-
 net/ipv4/ip_vti.c                            |  14 ++-
 net/ipv4/route.c                             |   2 +-
 net/ipv4/sysctl_net_ipv4.c                   |  10 ++
 net/ipv4/tcp.c                               |  28 ++++-
 net/ipv4/tcp_input.c                         |  40 ++++++-
 net/ipv4/tcp_output.c                        |  30 ++++--
 net/ipv4/xfrm4_input.c                       |   2 +-
 net/ipv4/xfrm4_mode_tunnel.c                 |   4 +-
 net/ipv6/ah6.c                               |   3 +-
 net/ipv6/inet6_hashtables.c                  |   2 +-
 net/ipv6/ip6_output.c                        |   2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c      |   2 +-
 net/ipv6/reassembly.c                        |   2 +-
 net/ipv6/xfrm6_mode_tunnel.c                 |   4 +-
 net/l2tp/l2tp_core.c                         |  36 +++++--
 net/l2tp/l2tp_core.h                         |   3 +
 net/l2tp/l2tp_ppp.c                          |   4 +
 net/mac80211/cfg.c                           |   2 +-
 net/mac80211/ieee80211_i.h                   |   3 +
 net/mac80211/rx.c                            |   3 +
 net/mac80211/scan.c                          |  19 ++++
 net/mac80211/status.c                        |   3 +
 net/mac80211/tx.c                            |   3 +-
 net/mac80211/util.c                          |   4 +
 net/sched/act_ipt.c                          |   6 +-
 net/sched/act_pedit.c                        |   3 +-
 net/sctp/output.c                            |   3 +-
 net/socket.c                                 |  24 ++++-
 net/unix/af_unix.c                           |  10 ++
 net/unix/diag.c                              |   1 +
 net/wireless/ibss.c                          |   3 +
 net/wireless/radiotap.c                      |   7 +-
 scripts/kallsyms.c                           |  12 ++-
 scripts/link-vmlinux.sh                      |   2 +
 sound/core/pcm.c                             |   4 +
 sound/pci/hda/hda_codec.c                    |   4 +-
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/soc/codecs/wm_hubs.c                   |   1 +
 sound/soc/soc-dapm.c                         |   2 +-
 107 files changed, 803 insertions(+), 371 deletions(-)

Alex Deucher (1):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Amitkumar Karwar (1):
      mwifiex: fix SDIO interrupt lost issue

Baruch Siach (1):
      xtensa: don't use alternate signal stack on threads

Bian Yu (1):
      md: avoid deadlock when md_set_badblocks.

Bob Moore (4):
      ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
      ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.
      ACPICA: Return error if DerefOf resolves to a null package element.
      ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a field.

Bruno Randolf (1):
      cfg80211: fix warning when using WEXT for IBSS

Chris Wilson (3):
      drm: Prevent overwriting from userspace underallocating core ioctl structs
      drm: Pad drm_mode_get_connector to 64-bit boundary
      drm/i915: quirk away phantom LVDS on Intel's D510MO mainboard

Christophe Gouault (1):
      vti: get rid of nf mark rule in prerouting

Dan Carpenter (7):
      net: heap overflow in __audit_sockaddr()
      uml: check length in exitcode_proc_write()
      staging: ozwpan: prevent overflow in oz_cdev_write()
      aacraid: missing capable() check in compat ioctl
      staging: wlags49_h2: buffer overflow setting station name
      Staging: bcm: info leak in ioctl
      Staging: sb105x: info leak in mp_get_count()

Daniel Borkmann (1):
      net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Dave Kleikamp (1):
      jfs: fix error path in ialloc

David S. Miller (1):
      l2tp: Fix build warning with ipv6 disabled.

Emmanuel Grumbach (1):
      mac80211: correctly close cancelled scans

Eric Dumazet (6):
      tcp: TSO packets automatic sizing
      tcp: TSQ can use a dynamic limit
      tcp: must unclone packets before mangling them
      tcp: do not forget FIN in tcp_shifted_skb()
      net: do not call sock_put() on TIMEWAIT sockets
      l2tp: must disable bh before calling l2tp_xmit_skb()

Fabio Estevam (1):
      net: secure_seq: Fix warning when CONFIG_IPV6 and CONFIG_INET are not selected

Fan Du (1):
      sctp: Use software crc32 checksum when xfrm transform will happen.

Felix Fietkau (4):
      mac80211: drop spoofed packets in ad-hoc mode
      mac80211: use sta_info_get_bss() for nl80211 tx and client probing
      mac80211: update sta->last_rx on acked tx frames
      ath9k: fix tx queue scheduling after channel changes

François Cachereul (1):
      l2tp: fix kernel panic when using IPv4-mapped IPv6 addresses

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

Gwendal Grignou (1):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Hannes Frederic Sowa (1):
      inet: fix possible memory corruption with UDP_CORK and UFO

Helge Deller (1):
      parisc: Do not crash 64bit SMP kernels on machines with >= 4GB RAM

Hugh Dickins (1):
      mm: numa: cleanup flow of transhuge page migration

Jani Nikula (2):
      dmi: add support for exact DMI matches in addition to substring matching
      drm/i915: quirk away phantom LVDS on Intel's D525MW mainboard

Jason Wang (1):
      virtio-net: don't respond to cpu hotplug notifier if we're not ready

Jiri Benc (1):
      ipv4: fix ineffective source address selection

Johannes Berg (2):
      wireless: radiotap: fix parsing buffer overrun
      mac80211: fix crash if bitrate calculation goes wrong

Jonathan Austin (1):
      clk: fixup argument order when setting VCO parameters

Kamal Mostafa (1):
      vxlan: fix ip_select_ident skb parameter

Linus Torvalds (1):
      Fix a few incorrectly checked [io_]remap_pfn_range() calls

Lukasz Dorau (1):
      md: Fix skipping recovery for read-only arrays.

Marc Kleine-Budde (3):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()
      can: flexcan: fix mx28 detection by rearanging OF match table

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Mark Cave-Ayland (1):
      rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Mathias Krause (3):
      proc connector: fix info leaks
      unix_diag: fix info leak
      connector: use nlmsg_len() to check message length

Mel Gorman (5):
      mm: Wait for THP migrations to complete during NUMA hinting faults
      mm: Prevent parallel splits during THP migration
      mm: numa: Sanitize task_numa_fault() callsites
      mm: Close races between THP migration and PMD numa clearing
      mm: Account for a THP NUMA hinting update as one PTE update

Ming Lei (2):
      lib/scatterlist.c: don't flush_kernel_dcache_page on slab page
      scripts/kallsyms: filter symbols not in kernel address space

Nicholas Bellinger (1):
      vhost/scsi: Fix incorrect usage of get_user_pages_fast write parameter

Paul Durrant (1):
      xen-netback: Don't destroy the netdev until the vif is shut down

Pravin B Shelar (1):
      net: Add skb_unclone() helper function.

Rob Pearce (1):
      drm/i915: No LVDS hardware on Intel D410PT and D425KT

Russell King (1):
      ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Salva Peiró (2):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl

Sebastian Hesselbarth (2):
      net: mv643xx_eth: update statistics timer from timer context only
      net: mv643xx_eth: fix orphaned statistics timer crash

Seif Mazareeb (1):
      net: fix cipso packet validation when !NETLABEL

Shaohua Li (2):
      raid5: set bio bi_vcnt 0 for discard request
      raid5: avoid finding "discard" stripe

Takashi Iwai (4):
      ALSA: hda - Fix unbalanced runtime PM refcount after S3/S4
      ASoC: dapm: Fix source list debugfs outputs
      ALSA: hda - Add a fixup for ASUS N76VZ
      ASoC: wm_hubs: Add missing break in hp_supply_event()

Thomas Hellstrom (2):
      drm/vmwgfx: Don't put resources with invalid id's on lru list
      drm/vmwgfx: Don't kill clients on VT switch

Vlad Yasevich (3):
      bridge: Correctly clamp MAX forward_delay when enabling STP
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.

Wei Yongjun (1):
      target/pscsi: fix return value check

stephen hemminger (2):
      ipv6: fix warning in xfrm6_mode_tunnel_input
      ip: fix warning in xfrm4_mode_tunnel_input
