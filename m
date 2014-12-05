Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaLEXsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:48:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaLEWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 000/122] 3.17.5-stable review
Date: Fri,  5 Dec 2014 14:42:54 -0800
Message-Id: <20141205223305.514276242@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.17.5 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  7 22:32:17 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.5-rc1

bill bonaparte <programme110@gmail.com>
    netfilter: conntrack: fix race in __nf_conntrack_confirm against get_next_corpse

Paolo Bonzini <pbonzini@redhat.com>
    x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is read-only

Georgi Djakov <gdjakov@mm-sol.com>
    clk: qcom: Fix duplicate rbcpr clock name

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Ignore long hpds on eDP ports

Luciano Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands

Matti Gottlieb <matti.gottlieb@intel.com>
    iwlwifi: mvm: ROC - bug fixes around time events and locking

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/powernv: Honor the generic "no_64bit_msi" flag

Maxime COQUELIN <maxime.coquelin@st.com>
    bitops: Fix shift overflow in GENMASK macros

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: initialize sadb to NULL in the audio code

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    gpu/radeon: Set flag to indicate broken 64-bit MSI

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Ignore SURFLIVE and flip counter when the GPU gets reset

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Kick fbdev before vgacon

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: drop WaSetupGtModeTdRowDispatch:snb

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable native backlight control on pre-r6xx asics (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian swapping in vbios fetch for tdp table

James Hogan <james.hogan@imgtec.com>
    clk-divider: Fix READ_ONLY when divider > 1

Maurizio Lombardi <mlombard@redhat.com>
    bnx2fc: do not add shared skbs to the fcoe_rx_list

Boris Brezillon <boris.brezillon@free-electrons.com>
    irqchip: atmel-aic: Fix irqdomain initialization

Daniel Borkmann <dborkman@redhat.com>
    ixgbe: fix use after free adapter->state test in ixgbe_remove/ixgbe_probe

Vlad Yasevich <vyasevich@gmail.com>
    ixgbe: Correctly disable VLAN filter in promiscuous mode

Lu Baolu <baolu.lu@linux.intel.com>
    Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"

Jane Zhou <a17711@motorola.com>
    net/ping: handle protocol mismatching scenario

Arnaud Ebalard <arno@natisbad.org>
    hwmon: (g762) fix call to devm_hwmon_device_register_with_groups()

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    sound/radeon: Move 64-bit MSI quirk from arch to driver

Trond Myklebust <trond.myklebust@primarydata.com>
    nfsd: Fix slot wake up race in the nfsv4.1 callback code

Christoph Hellwig <hch@lst.de>
    nfsd: correctly define v4.2 support attributes

Liad Kaufman <liad.kaufman@intel.com>
    iwlwifi: pcie: fix prph dump length

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: do not align payload on modern H/W

Maxime Ripard <maxime.ripard@free-electrons.com>
    dmaengine: sun6i: Fix memcpy operation

Thomas Körper <thomas.koerper@esd.eu>
    can: dev: avoid calling kfree_skb() from interrupt context

Christian Sünkenberg <christian.suenkenberg@hfg-karlsruhe.de>
    scsi: add Intel Multi-Flex to scsi scan blacklist

Nicholas Bellinger <nab@linux-iscsi.org>
    vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT

Ronald Wahl <ronald.wahl@raritan.com>
    mac80211: Fix regression that triggers a kernel BUG with CCMP

Qipan Li <Qipan.Li@csr.com>
    spi: sirf: fix word width configuration

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    spi: Fix mapping from vmalloc-ed buffer to scatter list

Thor Thayer <tthayer@opensource.altera.com>
    spi: dw: Fix dynamic speed change.

Sagi Grimberg <sagig@dev.mellanox.co.il>
    iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly

Roland Dreier <roland@purestorage.com>
    target: Don't call TFO->write_pending if data_length == 0

Bart Van Assche <bvanassche@acm.org>
    srp-target: Retry when QP creation fails with ENOMEM

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Input: xpad - use proper endpoint type

Ben Sagal <bensagal@gmail.com>
    Input: synaptics - adjust min/max on Thinkpad E540

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8226/1: cacheflush: get rid of restarting block

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: 8222/1: mvebu: enable strex backoff delay

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: add missing of_node_put() call in coherency.c

Grant Likely <grant.likely@linaro.org>
    of/selftest: Fix off-by-one error in removal path

Kevin Cernekee <cernekee@gmail.com>
    of: Fix crash if an earlycon driver is not found

Bjorn Helgaas <bhelgaas@google.com>
    of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Johannes Berg <johannes.berg@intel.com>
    brcmfmac: don't include linux/unaligned/access_ok.h

Dmitry Torokhov <dtor@chromium.org>
    brcmfmac: fix error handling of irq_of_parse_and_map

Arend van Spriel <arend@broadcom.com>
    brcmfmac: fix conversion of channel width 20MHZ_NOHT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC

Chris Mason <clm@fb.com>
    btrfs: fix lockups from btrfs_clear_path_blocking

Gu Zheng <guz.fnst@cn.fujitsu.com>
    aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - One more HP machine needs to change mute led quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

Jurgen Kramer <gtmkramer@xs4all.nl>
    ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices

Alexey Khoroshilov <khoroshilov@ispras.ru>
    can: esd_usb2: fix memory leak on disconnect

Lu Baolu <baolu.lu@linux.intel.com>
    usb: xhci: rework root port wake bits if controller isn't allowed to wakeup

Mathias Nyman <mathias.nyman@linux.intel.com>
    USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Mathias Nyman <mathias.nyman@linux.intel.com>
    USB: xhci: don't start a halted endpoint before its new dequeue is set

Hans de Goede <hdegoede@redhat.com>
    USB: uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012

Hans de Goede <hdegoede@redhat.com>
    usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Troy Clark <tclark@matrixorbital.ca>
    usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Preston Fick <pffick@gmail.com>
    USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Johan Hovold <johan@kernel.org>
    USB: keyspan: fix tty line-status reporting

Johan Hovold <johan@kernel.org>
    USB: keyspan: fix overrun-error reporting

Johan Hovold <johan@kernel.org>
    USB: ssu100: fix overrun-error reporting

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Add new device ID for DLink GO-USB-N150

Axel Lin <axel.lin@ingics.com>
    iio: adc: men_z188_adc: Add terminating entry for men_z188_ids

Cristina Ciocan <cristina.ciocan@intel.com>
    iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
    powerpc/powernv: Fix the hmi event version check.

Laurent Dufour <ldufour@linux.vnet.ibm.com>
    powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE

Anton Blanchard <anton@samba.org>
    powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/pseries: Honor the generic "no_64bit_msi" flag

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    of/base: Fix PowerPC address parsing hack

Miaoqing Pan <miaoqing@qca.qualcomm.com>
    ath9k: Fix RTC_DERIVED_CLK usage

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ASoC: cs42l51: re-hook of_match_table pointer

Bard Liao <bardliao@realtek.com>
    ASoC: rt5670: correct the incorrect default values

Takashi Iwai <tiwai@suse.de>
    ASoC: dpcm: Fix race between FE/BE updates and trigger

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use

Jianqun <jay.xu@rock-chips.com>
    ASoC: rockchip-i2s: fix infinite loop in rockchip_snd_rxctrl

Andreas Färber <afaerber@suse.de>
    ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: sgtl5000: Fix SMALL_POP bit definition

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: fsi: remove unsupported PAUSE flag

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: remove unsupported PAUSE flag

Or Gerlitz <ogerlitz@mellanox.com>
    ib_isert: Add max_send_sge=2 minimum for control PDU responses

Chris Moore <Chris.Moore@Emulex.Com>
    IB/isert: Adjust CQ size to HW limits

Maxime Ripard <maxime.ripard@free-electrons.com>
    clockevent: sun4i: Fix race condition in the probe code

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    PCI/MSI: Add device flag indicating that 64-bit MSIs don't work

Yinghai Lu <yinghai@kernel.org>
    PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx4_en: Advertize encapsulation offloads features only when VXLAN tunnel is set

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx4_en: Add VXLAN ndo calls to the PF net device ops too

Jiri Bohac <jbohac@suse.cz>
    ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Mathias Krause <minipli@googlemail.com>
    pptp: fix stack info leak in pptp_getname()

Nikolay Aleksandrov <nikolay@redhat.com>
    bonding: fix curr_active_slave/carrier with loadbalance arp monitoring

Martin Hauke <mardnh@gmx.de>
    qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Alexey Khoroshilov <khoroshilov@ispras.ru>
    ieee802154: fix error handling in ieee802154fake_probe()

Panu Matilainen <pmatilai@redhat.com>
    ipv4: Fix incorrect error code when adding an unreachable route

Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>
    inetdevice: fixed signed integer overflow

David S. Miller <davem@davemloft.net>
    sparc64: Fix constraints on swab helpers.

Andy Lutomirski <luto@amacapital.net>
    uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

Kees Cook <keescook@chromium.org>
    x86, kaslr: Handle Gold linker for finding bss/brk

Kees Cook <keescook@chromium.org>
    x86, mm: Set NX across entire PMD at boot

Dave Hansen <dave.hansen@linux.intel.com>
    x86: Require exact match for 'noxsave' command line option

Andy Lutomirski <luto@amacapital.net>
    x86_64, traps: Rework bad_iret

Andy Lutomirski <luto@amacapital.net>
    x86_64, traps: Stop using IST for #SS

Andy Lutomirski <luto@amacapital.net>
    x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: Loongson: Make platform serial setup always built-in.

Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
    MIPS: tlbex: Fix potential HTW race on TLBL/M/S handlers

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line

Paul Burton <paul.burton@imgtec.com>
    MIPS: fix EVA & non-SMP non-FPU FP context signal handling

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: cpu-probe: Set the FTLB probability bit on supported cores

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: asm: uaccess: Add v1 register to clobber list on EVA

James Cowgill <James.Cowgill@imgtec.com>
    MIPS: Loongson3: Fix __node_distances undefined error

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: tlb-r4k: Add missing HTW stop/start sequences

Aaro Koskinen <aaro.koskinen@nsn.com>
    MIPS: oprofile: Fix backtrace on 64-bit kernel

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: lib: memcpy: Restore NOP on delay slot before returning to caller

James Cowgill <James.Cowgill@imgtec.com>
    MIPS: IP27: Fix __node_distances undefined error


-------------

Diffstat:

 .../bindings/interrupt-controller/interrupts.txt   |   4 -
 Makefile                                           |   4 +-
 arch/arm/include/asm/thread_info.h                 |  11 ---
 arch/arm/kernel/traps.c                            |  31 +-----
 arch/arm/mach-mvebu/coherency.c                    |   2 +
 arch/arm/mm/proc-v7.S                              |   2 -
 arch/arm/mm/proc-xscale.S                          |   4 +-
 arch/mips/include/asm/mipsregs.h                   |   2 +
 arch/mips/include/asm/r4kcache.h                   |   4 +
 arch/mips/include/asm/uaccess.h                    |   7 +-
 arch/mips/kernel/cpu-probe.c                       |  33 ++++++-
 arch/mips/kernel/signal.c                          |   8 +-
 arch/mips/lib/memcpy.S                             |   1 +
 arch/mips/loongson/common/Makefile                 |   3 +-
 arch/mips/loongson/loongson-3/numa.c               |   1 +
 arch/mips/mm/tlb-r4k.c                             |   4 +
 arch/mips/mm/tlbex.c                               |  10 +-
 arch/mips/oprofile/backtrace.c                     |   2 +-
 arch/mips/sgi-ip27/ip27-memory.c                   |   1 +
 arch/powerpc/kernel/vdso32/getcpu.S                |   4 +-
 arch/powerpc/platforms/powernv/opal-hmi.c          |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   5 +-
 arch/powerpc/platforms/powernv/pci.c               |   4 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/sparc/include/uapi/asm/swab.h                 |  12 +--
 arch/x86/include/asm/cpufeature.h                  |   1 +
 arch/x86/include/asm/kvm_para.h                    |  10 +-
 arch/x86/include/asm/page_32_types.h               |   1 -
 arch/x86/include/asm/page_64_types.h               |  11 +--
 arch/x86/include/asm/thread_info.h                 |   2 +-
 arch/x86/include/asm/traps.h                       |   1 +
 arch/x86/kernel/cpu/amd.c                          |   7 ++
 arch/x86/kernel/cpu/common.c                       |   2 +
 arch/x86/kernel/dumpstack_64.c                     |   1 -
 arch/x86/kernel/entry_64.S                         |  81 +++++-----------
 arch/x86/kernel/traps.c                            |  71 ++++++++++----
 arch/x86/mm/init_64.c                              |  11 ++-
 arch/x86/tools/calc_run_size.pl                    |  11 ++-
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/acpi/ec.c                                  |   4 +-
 drivers/clk/clk-divider.c                          |  18 ++--
 drivers/clk/qcom/mmcc-apq8084.c                    |   2 +-
 drivers/clk/rockchip/clk.c                         |   4 +-
 drivers/clocksource/sun4i_timer.c                  |  12 +--
 drivers/dma/sun6i-dma.c                            |  61 ++++++------
 drivers/gpu/drm/i915/i915_dma.c                    |  10 +-
 drivers/gpu/drm/i915/intel_display.c               |   4 +
 drivers/gpu/drm/i915/intel_dp.c                    |  12 +++
 drivers/gpu/drm/i915/intel_pm.c                    |   5 -
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |   2 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   2 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |   2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  19 +++-
 drivers/gpu/drm/radeon/radeon_encoders.c           |   3 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |  10 ++
 drivers/hwmon/g762.c                               |   6 +-
 drivers/iio/adc/men_z188_adc.c                     |   1 +
 drivers/infiniband/ulp/isert/ib_isert.c            |  44 ++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   8 ++
 drivers/input/joystick/xpad.c                      |  16 ++-
 drivers/input/mouse/synaptics.c                    |   4 +
 drivers/irqchip/irq-atmel-aic-common.c             |   6 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/can/usb/esd_usb2.c                     |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  12 ++-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  28 ++++--
 drivers/net/ieee802154/fakehard.c                  |  13 ++-
 drivers/net/ppp/pptp.c                             |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  13 +++
 drivers/net/wireless/ath/ath9k/hw.c                |  13 ---
 drivers/net/wireless/brcm80211/brcmfmac/of.c       |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |   2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   6 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h              |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  37 ++++---
 drivers/net/wireless/iwlwifi/mvm/time-event.c      |   2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   3 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  50 +++-------
 drivers/of/address.c                               |  19 +++-
 drivers/of/fdt.c                                   |   2 +-
 drivers/of/selftest.c                              |   3 +-
 drivers/pci/msi.c                                  |  26 +++++
 drivers/pci/probe.c                                |  28 +++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   7 ++
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/spi/spi-dw.c                               |   6 +-
 drivers/spi/spi-sirf.c                             |   4 +-
 drivers/spi/spi.c                                  |   6 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/target/target_core_transport.c             |   2 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-hub.c                        |   5 +-
 drivers/usb/host/xhci-pci.c                        |   2 +-
 drivers/usb/host/xhci-plat.c                       |  10 +-
 drivers/usb/host/xhci-ring.c                       |  43 +++------
 drivers/usb/host/xhci.c                            | 107 +++++++++++----------
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |  33 +++++++
 drivers/usb/serial/ftdi_sio_ids.h                  |  39 +++++++-
 drivers/usb/serial/keyspan.c                       |  97 +++++++++++--------
 drivers/usb/serial/ssu100.c                        |  11 +--
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 drivers/vhost/scsi.c                               |  24 +++++
 fs/aio.c                                           |  21 ++--
 fs/btrfs/ctree.c                                   |  14 +--
 fs/btrfs/locking.c                                 |  24 ++++-
 fs/btrfs/locking.h                                 |   2 +
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/nfsd.h                                     |   9 +-
 include/dt-bindings/clock/qcom,mmcc-apq8084.h      |   2 +-
 include/linux/bitops.h                             |   7 +-
 include/linux/clk-provider.h                       |   1 -
 include/linux/iio/events.h                         |   2 +-
 include/linux/inetdevice.h                         |   2 +-
 include/linux/pci.h                                |   1 +
 include/sound/soc-dpcm.h                           |   2 +
 kernel/events/uprobes.c                            |   1 -
 net/ipv4/fib_rules.c                               |   4 +
 net/ipv4/ping.c                                    |   2 +
 net/ipx/af_ipx.c                                   |   6 +-
 net/mac80211/aes_ccm.c                             |   3 +
 net/netfilter/nf_conntrack_core.c                  |  14 +--
 sound/pci/hda/hda_intel.c                          |  24 ++++-
 sound/pci/hda/hda_priv.h                           |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 -
 sound/soc/codecs/cs42l51-i2c.c                     |   1 +
 sound/soc/codecs/cs42l51.c                         |   4 +-
 sound/soc/codecs/cs42l51.h                         |   1 +
 sound/soc/codecs/rt5670.c                          |  28 +++---
 sound/soc/codecs/sgtl5000.c                        |   3 +-
 sound/soc/codecs/sgtl5000.h                        |   2 +-
 sound/soc/codecs/wm_adsp.c                         |   1 +
 sound/soc/rockchip/rockchip_i2s.c                  |   4 +-
 sound/soc/samsung/snow.c                           |   1 +
 sound/soc/sh/fsi.c                                 |   3 +-
 sound/soc/sh/rcar/core.c                           |   3 +-
 sound/soc/soc-pcm.c                                |  72 +++++++++++---
 sound/usb/quirks.c                                 |  14 +++
 143 files changed, 1008 insertions(+), 606 deletions(-)


