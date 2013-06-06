Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3FFVms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:42:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FFVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:42:46 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=3wEne4glExa0v6dgobkA:9 a=QEXdDO2ut3YA:10 a=pBaJOaUkyDGOdmIM:21 a=8p9fmMYI8ieLrcZk:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370554964.9844.51.camel@gandalf.local.home>
Subject: Linux 3.6.11.5
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Date: Thu, 06 Jun 2013 17:42:44 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.5 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.5.xz

thanks,

-- Steve

 Makefile                                     |    2 +-
 arch/arm/include/asm/cmpxchg.h               |    8 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h |    1 +
 arch/arm/mach-exynos/pmu.c                   |    5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 +-
 arch/parisc/Makefile                         |   24 ++--
 arch/parisc/kernel/entry.S                   |  169 ++++++++++++++------------
 arch/powerpc/include/asm/rtas.h              |    2 +
 arch/powerpc/kernel/machine_kexec_64.c       |    4 +
 arch/powerpc/kernel/rtas.c                   |  113 +++++++++++++++++
 arch/powerpc/platforms/pseries/suspend.c     |   22 ++++
 arch/tile/Kconfig                            |   14 ++-
 arch/tile/include/hv/hypervisor.h            |   27 +++-
 arch/tile/kernel/head_32.S                   |    2 +-
 arch/tile/kernel/head_64.S                   |   12 +-
 arch/x86/kvm/vmx.c                           |    6 +
 arch/x86/xen/enlighten.c                     |   15 +++
 drivers/acpi/acpica/exfldio.c                |   14 ++-
 drivers/acpi/ec.c                            |    4 +-
 drivers/block/drbd/drbd_receiver.c           |    1 -
 drivers/char/ipmi/ipmi_bt_sm.c               |    4 +-
 drivers/char/ipmi/ipmi_devintf.c             |   14 ++-
 drivers/dma/pch_dma.c                        |    2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c       |   69 +++++++----
 drivers/gpu/drm/radeon/evergreen.c           |    4 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c          |    2 +-
 drivers/gpu/drm/radeon/si.c                  |    4 +-
 drivers/hwmon/abituguru.c                    |   16 ++-
 drivers/i2c/busses/i2c-designware-core.c     |   14 ++-
 drivers/i2c/busses/i2c-designware-core.h     |    2 +
 drivers/md/dm-bufio.c                        |   26 +++-
 drivers/md/dm-snap.c                         |    1 +
 drivers/md/dm-stripe.c                       |   11 +-
 drivers/net/ethernet/3com/3c509.c            |    2 +
 drivers/net/ethernet/3com/3c59x.c            |   27 ++--
 drivers/net/ethernet/sfc/mcdi.c              |    2 +-
 drivers/net/ethernet/tile/tilegx.c           |    2 +-
 drivers/net/macvlan.c                        |    7 +-
 drivers/net/wireless/ath/ath9k/main.c        |    6 +-
 drivers/net/wireless/b43/dma.c               |   19 +++
 drivers/net/wireless/b43/dma.h               |    4 +-
 drivers/net/wireless/b43/main.c              |   43 +++----
 drivers/net/wireless/mwifiex/cfg80211.c      |    3 -
 drivers/net/wireless/mwifiex/cmdevt.c        |    1 +
 drivers/net/wireless/mwifiex/main.c          |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 +---
 drivers/platform/x86/hp_accel.c              |    3 +-
 drivers/rtc/rtc-pcf2123.c                    |    1 +
 drivers/scsi/sd.c                            |   20 +++
 drivers/scsi/sd.h                            |    1 +
 drivers/target/iscsi/iscsi_target_erl1.c     |    7 +-
 drivers/target/target_core_transport.c       |   11 +-
 drivers/watchdog/watchdog_dev.c              |    3 +-
 fs/btrfs/ioctl.c                             |   10 +-
 fs/ext4/mballoc.c                            |    6 +-
 include/linux/audit.h                        |    2 +-
 include/linux/if_cablemodem.h                |   12 +-
 include/linux/kref.h                         |   33 +++++
 include/linux/virtio_console.h               |    2 +-
 include/net/sock.h                           |   12 ++
 include/net/tcp.h                            |    1 +
 kernel/kmod.c                                |    5 +
 kernel/time/tick-sched.c                     |    2 +-
 kernel/timer.c                               |    2 +-
 kernel/trace/trace_events_filter.c           |    4 +
 net/8021q/vlan_dev.c                         |    2 +-
 net/bridge/br_stp_timer.c                    |    2 +-
 net/core/dev.c                               |    2 +-
 net/core/ethtool.c                           |    2 +-
 net/core/sock.c                              |   12 --
 net/ipv6/tcp_ipv6.c                          |   12 ++
 net/ipv6/udp.c                               |   13 +-
 net/ipv6/udp_impl.h                          |    2 +
 net/ipv6/udplite.c                           |    2 +-
 net/ipv6/xfrm6_policy.c                      |    4 +-
 net/mac802154/mac802154.h                    |    2 +-
 net/packet/af_packet.c                       |   53 ++++----
 net/sched/act_ipt.c                          |   33 ++++-
 sound/pci/hda/hda_codec.c                    |    3 +
 sound/soc/codecs/wm8994.c                    |    1 +
 81 files changed, 731 insertions(+), 309 deletions(-)
---------------------------
Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Anton Blanchard (2):
      audit: Syscall rules are not applied to existing processes on non-x86
      powerpc/kexec: Fix kexec when using VMX optimised memcpy

Ben Hutchings (1):
      sfc: Fix naming of MTD partitions for FPGA bitfiles

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Bjørn Mork (1):
      net: vlan,ethtool: netdev_features_t is more than 32 bit

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operation

Chen Gang (2):
      net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow

Chris Metcalf (1):
      tile: support new Tilera hypervisor

Christopher Harvey (2):
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
      drm/mgag200: Fix framebuffer base address programming

Cong Wang (1):
      xfrm6: release dev before returning error

Dan Carpenter (1):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

Eric Dumazet (2):
      tcp: force a dst refcount when prequeue packet
      ipv6: do not clear pinet6 field

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Guenter Roeck (1):
      watchdog: Fix race condition in registration code

Helge Deller (1):
      parisc: make default cross compiler search more robust (v3)

Inderpal Singh (1):
      ARM: EXYNOS5: Fix kernel dump in AFTR idle mode

Jaccon Bastiaansen (1):
      ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

James Bottomley (1):
      sd: fix array cache flushing bug causing performance problems

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path

Joern Engel (1):
      target: close target_put_sess_cmd() vs. core_tmr_abort_task() race

John David Anglin (2):
      parisc: only re-enable interrupts if we need to schedule or deliver signals when returning to userspace
      parisc: fix SMP races when updating PTE and TLB entries in entry.S

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

Konrad Rzeszutek Wilk (1):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them

Mike Frysinger (1):
      parisc: fix NATIVE set up in build

Mike Snitzer (1):
      dm stripe: fix regression in stripe_width calculation

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock

Niels Ole Salscheider (1):
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path != NULL

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver unload
      3c59x: fix PCI resource management

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Steven Rostedt (Red Hat) (2):
      tracing: Fix leaks of filter preds
      Linux 3.6.11.5

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Wang YanQing (1):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer

Wei Yongjun (3):
      dm snapshot: fix error return code in snapshot_ctr
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()
      hwmon: fix error return code in abituguru_probe()

stephen hemminger (1):
      bridge: fix race with topology change timer

----


