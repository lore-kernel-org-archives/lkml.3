Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3AXD1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:27:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44109 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3AXD1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:27:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: =?UTF-8?q?=5B=203=2E5=2Ey=2Ez=20extended=20stable=20=5D=20Linux=203=2E5=2E7=2E4=20stable=20review?=
Date: Thu, 24 Jan 2013 01:26:12 -0200
Message-Id: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the review cycle for the 3.5.7.4 release of stable patches.
This new release contains 74 patches. Proposed patches are posted as a
response to this message. The same patches are also available at the
following repository:

git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y-review

If there are any problems, or if anything is missing, please answer to
this or to any of the followup patches. Note that any answer should be
made at maximum in 3 days, after that the final release of 3.5.7.4 will be
made.

For more information about the 3.5.y.z extended stable tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Included below are the diffstat and shortlog for this release.

-Herton

-- 
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h     |    3 +
 arch/arm/mach-pxa/pxa27x.c                      |    4 +-
 arch/s390/include/asm/timex.h                   |   28 ++++
 arch/s390/kernel/time.c                         |    2 +-
 arch/s390/kvm/interrupt.c                       |    2 +-
 arch/sh/include/asm/elf.h                       |    4 +-
 arch/x86/kernel/setup.c                         |   78 +++++++++++
 drivers/gpu/drm/i915/i915_gem.c                 |    7 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c              |    2 +-
 drivers/gpu/drm/nouveau/nv10_fence.c            |    3 +
 drivers/gpu/drm/radeon/r600_cs.c                |    6 +-
 drivers/gpu/drm/radeon/radeon_cs.c              |    5 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    8 ++
 drivers/gpu/drm/udl/udl_connector.c             |   17 ++-
 drivers/iommu/intel-iommu.c                     |   31 +++++
 drivers/net/ethernet/intel/igb/igb_main.c       |   22 ++-
 drivers/net/wireless/b43/b43.h                  |    5 +
 drivers/net/wireless/b43/main.c                 |   54 ++++++--
 drivers/net/wireless/b43/main.h                 |    5 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c        |   21 ++-
 drivers/net/wireless/rt2x00/rt2800usb.c         |    1 +
 drivers/platform/x86/samsung-laptop.c           |   10 ++
 drivers/platform/x86/sony-laptop.c              |   15 +-
 drivers/regulator/max8997.c                     |   36 +++--
 drivers/regulator/max8998.c                     |  167 +++++++----------------
 drivers/scsi/sd.c                               |   13 +-
 drivers/staging/comedi/comedi_fops.c            |    3 +
 drivers/staging/comedi/drivers/comedi_test.c    |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c      |   16 +--
 drivers/staging/rtl8712/usb_intf.c              |    2 +
 drivers/staging/speakup/synth.c                 |    4 +-
 drivers/target/target_core_transport.c          |    9 +-
 drivers/target/tcm_fc/tfc_sess.c                |   12 +-
 drivers/usb/chipidea/host.c                     |    3 +
 drivers/usb/class/cdc-acm.c                     |    6 +
 drivers/usb/core/hub.c                          |  120 ++++++++++++----
 drivers/usb/core/quirks.c                       |    3 +
 drivers/usb/gadget/dummy_hcd.c                  |    9 +-
 drivers/usb/host/xhci-hub.c                     |   38 +++++-
 drivers/usb/host/xhci-mem.c                     |    2 +
 drivers/usb/host/xhci-ring.c                    |    9 ++
 drivers/usb/host/xhci.c                         |   10 ++
 drivers/usb/musb/musb_core.c                    |    5 +-
 drivers/usb/serial/ftdi_sio.c                   |    2 +
 drivers/usb/serial/ftdi_sio_ids.h               |    6 +
 drivers/usb/serial/io_ti.c                      |    3 +
 drivers/usb/serial/option.c                     |   18 ++-
 include/linux/audit.h                           |    4 +-
 kernel/auditsc.c                                |   14 +-
 mm/bootmem.c                                    |   24 +++-
 mm/compaction.c                                 |    6 +-
 mm/page_alloc.c                                 |    2 +-
 net/mac80211/ibss.c                             |    9 +-
 net/mac80211/ieee80211_i.h                      |   11 +-
 net/mac80211/mlme.c                             |   73 +++++++---
 net/mac80211/scan.c                             |   47 +++----
 net/mac80211/sta_info.c                         |    2 +-
 net/sunrpc/sched.c                              |    3 +-
 net/sunrpc/xprt.c                               |   12 +-
 sound/arm/pxa2xx-ac97-lib.c                     |   26 +++-
 sound/pci/hda/patch_conexant.c                  |   16 ---
 sound/soc/codecs/wm2000.c                       |    4 +-
 sound/soc/codecs/wm2200.c                       |    8 +-
 sound/soc/codecs/wm5100.c                       |    6 -
 sound/soc/soc-pcm.c                             |    1 +
 sound/usb/quirks.c                              |    8 +-
 66 files changed, 747 insertions(+), 360 deletions(-)

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam

Axel Lin (6):
      ASoC: wm2200: Fix setting dai format in wm2200_set_fmt
      regulator: max8997: Use uV in voltage_map_desc
      regulator: max8998: Convert to regulator_list_voltage_linear()
      regulator: max8998: Convert to set_voltage_sel and regulator_map_voltage_linear
      regulator: max8998: Use uV in voltage_map_desc
      regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel

Bing Zhao (1):
      mwifiex: check wait_event_interruptible return value

Bjørn Mork (2):
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II

Chris Wilson (1):
      drm/i915; Only increment the user-pin-count after successfully pinning the bo

David Henningsson (2):
      Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"
      ALSA: usb - fix race in creation of M-Audio Fast track pro driver

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Fabio Estevam (1):
      usb: chipidea: Allow disabling streaming not only in udc mode

Hannes Reinecke (1):
      target: use correct sense code for LUN communication failure

Hans de Goede (3):
      udldrmfb: Fix EDID not working with monitors with EDID extension blocks
      udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack
      udldrmfb: udl_get_edid: drop unneeded i--

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow

Ian Abbott (2):
      staging: comedi: prevent auto-unconfig of manually configured devices
      staging: comedi: comedi_test: fix race when cancelling command

Ilija Hadzic (2):
      drm/radeon: fix NULL pointer dereference in UMS mode
      drm/radeon: fix a bogus kfree

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue

Jean-Christian de Rivaz (1):
      Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Jerome Glisse (1):
      radeon/kms: force rn50 chip to always report connected on analog output

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Joel D. Diaz (1):
      [SCSI] sd: Reshuffle init_sd to avoid crash

Johannes Berg (2):
      mac80211: use del_timer_sync for final sta cleanup timer deletion
      mac80211: fix dtim_period in hidden SSID AP association

Kees Cook (1):
      audit: create explicit AUDIT_SECCOMP event type

Larry Finger (2):
      staging: r8712u: Add new device ID
      b43: Fix firmware loading when driver is built into the kernel

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation

Maia Kozheva (1):
      rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi adapter

Marcin Slusarz (2):
      drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards
      drm/nv17-50: restore fence buffer on resume

Mark Brown (3):
      ASoC: wm2200: Remove DSP B and left justified AIF modes
      ASoC: wm5100: Remove DSP B and left justified formats
      ASoC: wm2000: Fix sense of speech clarity enable

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
      tcm_fc: Do not report target role when target is not defined

Mattia Dongili (1):
      sony-laptop: fix SNC buffer calls when SN06 returns Integers

Max Filippov (1):
      mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment

Mike Dunn (2):
      ALSA: pxa27x: fix ac97 cold reset
      ALSA: pxa27x: fix ac97 warm reset

Nickolai Zeldovich (1):
      staging: speakup: avoid out-of-range access in synth_init()

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Patrick Lai (1):
      ASoC: pcm: allow backend hardware to be freed in pause state

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Roland Dreier (2):
      target: Fix use-after-free in LUN RESET handling
      target: Release se_cmd when LUN lookup fails for TMR

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

Sarah Sharp (8):
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.
      USB: Handle auto-transition from hot to warm reset.
      USB: Ignore xHCI Reset Device status.
      USB: Allow USB 3.0 ports to be disabled.
      USB: Increase reset timeout.
      USB: Ignore port state until reset completes.
      USB: Handle warm reset failure on empty port.
      xhci: Avoid "dead ports", add roothub port polling.

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again

Seth Forshee (1):
      samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Stanislaw Gruszka (1):
      mac80211: fix ibss scanning

Stefan Assmann (1):
      igb: release already assigned MSI-X interrupts if setup fails

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Domain

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Trond Myklebust (1):
      SUNRPC: Ensure we release the socket write lock if the rpc_task exits early

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

Éric Piel (1):
      staging: comedi: fix minimum AO period for NI 625x and NI 628x
