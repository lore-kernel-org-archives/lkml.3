Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3HBSTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:19:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3HBSS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:18:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.6
Date: Fri,  2 Aug 2013 11:18:51 -0700
Message-Id: <1375467532-5711-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.6 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.5 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                        |   2 +-
 arch/arm64/mm/fault.c                           |  46 +++++------
 arch/powerpc/include/asm/module.h               |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S               |   3 -
 arch/sparc/kernel/asm-offsets.c                 |   2 +
 arch/sparc/mm/hypersparc.S                      |   8 +-
 arch/sparc/mm/init_64.c                         |   9 ++-
 arch/sparc/mm/swift.S                           |   8 +-
 arch/sparc/mm/tlb.c                             |   2 +-
 arch/sparc/mm/tsunami.S                         |   6 +-
 arch/sparc/mm/viking.S                          |  10 +--
 arch/x86/kernel/acpi/sleep.c                    |  18 ++++-
 drivers/acpi/acpi_memhotplug.c                  |   1 +
 drivers/acpi/video.c                            |   8 ++
 drivers/block/xen-blkback/blkback.c             |  13 ++-
 drivers/gpu/drm/i915/i915_dma.c                 |  14 ++--
 drivers/gpu/drm/i915/i915_drv.c                 |  13 +--
 drivers/gpu/drm/i915/i915_drv.h                 |   3 +-
 drivers/gpu/drm/i915/i915_gem.c                 | 100 +++++++++++-------------
 drivers/gpu/drm/i915/intel_ddi.c                |  37 ++++-----
 drivers/gpu/drm/i915/intel_display.c            |  19 +++++
 drivers/gpu/drm/i915/intel_drv.h                |   6 +-
 drivers/gpu/drm/i915/intel_hdmi.c               |  76 +++++++++---------
 drivers/gpu/drm/i915/intel_panel.c              |   3 +-
 drivers/gpu/drm/i915/intel_pm.c                 |  39 ++++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c         |   9 +--
 drivers/gpu/drm/radeon/evergreen_hdmi.c         |   3 +
 drivers/gpu/drm/radeon/r600_hdmi.c              |   6 ++
 drivers/gpu/drm/radeon/radeon.h                 |   1 +
 drivers/gpu/drm/radeon/radeon_gart.c            |   1 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |   9 ++-
 drivers/gpu/drm/radeon/radeon_object.h          |   2 +-
 drivers/gpu/drm/radeon/radeon_ring.c            |   1 +
 drivers/gpu/drm/radeon/radeon_sa.c              |   9 ++-
 drivers/media/pci/saa7134/saa7134-alsa.c        |   2 +
 drivers/net/dummy.c                             |   4 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  50 +++++++++++-
 drivers/net/ethernet/renesas/sh_eth.c           |  17 ++--
 drivers/net/ethernet/renesas/sh_eth.h           |   2 +-
 drivers/net/ethernet/sun/sunvnet.c              |   2 +
 drivers/net/ifb.c                               |   8 +-
 drivers/net/macvtap.c                           |  72 ++++++++++-------
 drivers/net/tun.c                               |  69 ++++++++++------
 drivers/staging/line6/pcm.c                     |   5 +-
 fs/btrfs/extent-tree.c                          |  13 +++
 fs/ext4/extents.c                               |  11 +++
 include/net/addrconf.h                          |   3 +
 include/net/udp.h                               |   1 +
 include/uapi/linux/if_pppox.h                   |   4 +-
 kernel/power/autosleep.c                        |   3 +-
 net/8021q/vlan_dev.c                            |   7 ++
 net/9p/trans_common.c                           |  10 +--
 net/bridge/br_multicast.c                       |   5 +-
 net/core/neighbour.c                            |  12 +--
 net/ipv4/ip_input.c                             |   7 +-
 net/ipv4/ip_vti.c                               |   7 --
 net/ipv4/tcp_ipv4.c                             |   4 +-
 net/ipv4/udp.c                                  |   3 +-
 net/ipv6/addrconf.c                             |  31 +++++---
 net/ipv6/ip6_fib.c                              |  15 +++-
 net/ipv6/ip6_output.c                           |  24 ++++--
 net/ipv6/mcast.c                                |  18 +++--
 net/ipv6/route.c                                |   9 ++-
 net/ipv6/udp.c                                  |   7 +-
 net/key/af_key.c                                |   2 +
 net/l2tp/l2tp_ppp.c                             |   3 +-
 net/x25/af_x25.c                                |  15 ++--
 sound/arm/pxa2xx-pcm-lib.c                      |   2 +
 sound/pci/asihpi/asihpi.c                       |   3 +
 sound/pci/atiixp.c                              |   2 +
 sound/pci/atiixp_modem.c                        |   2 +
 sound/pci/hda/patch_hdmi.c                      |   2 +
 sound/soc/atmel/atmel-pcm-dma.c                 |   2 +
 sound/soc/codecs/sgtl5000.c                     |   2 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/s6000/s6000-pcm.c                     |   2 +
 sound/usb/6fire/pcm.c                           |  12 ++-
 sound/usb/misc/ua101.c                          |  14 +++-
 sound/usb/usx2y/usbusx2yaudio.c                 |   4 +
 79 files changed, 641 insertions(+), 345 deletions(-)

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda

Alex Deucher (2):
      drm/radeon/hdmi: make sure we have an afmt block assigned
      drm/radeon: allow selection of alignment in the sub-allocator

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Aydin Arik (1):
      ipv4: Fixed MD5 key lookups when adding/ removing MD5 to/ from TCP sockets.

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr

Chris Wilson (4):
      drm/i915: Fix write-read race with multiple rings
      drm/i915: Fix incoherence with fence updates on Sandybridge+
      Revert "drm/i915: Workaround incoherence between fences and LLC across multiple CPUs"
      drm/i915: Serialize almost all register access

Christian König (1):
      drm/radeon: allocate SA bo in the requested domain

Cong Wang (1):
      vti: remove duplicated code to fix a memory leak

Daniel Vetter (4):
      drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a
      drm/i915: don't setup hdmi for port D edp in ddi_init
      drm/i915: inverted brightness quirk for Acer Aspire 4736Z
      drm/i915: fix up gt init sequence fallout

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.

Dave Kleikamp (2):
      sparc: tsb must be flushed before tlb
      sunvnet: vnet_port_remove must call unregister_netdev

Eric Dumazet (4):
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst
      neighbour: fix a race in neigh_destroy()
      ipv4: set transport header earlier
      vlan: fix a race in egress prio management

Fabio Estevam (2):
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Gao feng (1):
      ipv6: don't call addrconf_dst_alloc again when enable lo

Guenter Roeck (1):
      Partially revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"

H. Peter Anvin (1):
      x86, suspend: Handle CPUs which fail to #GP on RDMSR

Hannes Frederic Sowa (4):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
      ipv6: in case of link failure remove route directly instead of letting it expire
      ipv6: only static routes qualify for equal cost multipathing

Imre Deak (1):
      drm/i915: merge {i965, sandybridge}_write_fence_reg()

Jason Wang (4):
      tuntap: correctly linearize skb when zerocopy is used
      macvtap: correctly linearize skb when zerocopy is used
      tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Josef Bacik (2):
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

Kamal Mostafa (2):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
      Linux 3.8.13.6

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check device permissions before allowing OP_DISCARD

Konstantin Khlebnikov (1):
      drm/i915: fix long-standing SNB regression in power consumption after resume v2

Lan Tianyu (1):
      ACPI / video: ignore BIOS initial backlight value for Fujitsu E753

Linus Lüssing (1):
      bridge: fix switched interval for MLD Query types

Liu ShuoX (1):
      PM / Sleep: avoid 'autosleep' in shutdown progress

Mathias Krause (1):
      af_key: fix info leaks in notify messages

Michael S. Tsirkin (1):
      macvtap: fix recovery from gup errors

Neil Horman (2):
      atl1e: fix dma mapping warnings
      atl1e: unmap partially mapped skb on dma error and free skb

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.

Paulo Zanoni (1):
      drm/i915: rename sdvox_reg to hdmi_reg on HDMI context

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption

Sergei Shtylyov (1):
      sh_eth: fix unhandled RFE interrupt

Sergey Senozhatsky (1):
      radeon kms: do not flush uninitialized hotplug work

Stéphane Marchesin (1):
      drm/i915: Preserve the DDI_A_4_LANES bit from the bios

Takashi Iwai (10):
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ASoC: atmel: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      [media] saa7134: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call

Theodore Ts'o (1):
      ext4: fix error handling in ext4_ext_truncate()

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto

Will Deacon (1):
      arm64: mm: don't treat user cache maintenance faults as writes

Xiong Zhang (1):
      drm/i915: Correct obj->mm_list link to dev_priv->dev_priv->mm.inactive_list

bob picco (1):
      sparc64 address-congruence property

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed

