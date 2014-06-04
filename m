Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaFDXuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:50:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaFDXX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 000/103] 3.10.42-stable review
Date: Wed,  4 Jun 2014 16:24:23 -0700
Message-Id: <20140604232546.704156131@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.42 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun  6 23:24:52 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.42-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.42-rc1

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    media: V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    media: V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space

Antti Palosaari <crope@iki.fi>
    media: fc2580: fix tuning failure on 32-bit arch

Alex Williamson <alex.williamson@redhat.com>
    iommu/amd: Fix interrupt remapping for aliased devices

Chunwei Chen <tuxoko@gmail.com>
    libceph: fix corruption when using page_count 0 page in rbd

Guenter Roeck <linux@roeck-us.net>
    powerpc: Fix 64 bit builds with binutils 2.24

Harald Freudenberger <freude@linux.vnet.ibm.com>
    crypto: s390 - fix aes,des ctr mode concurrency finding.

Horia Geanta <horia.geanta@freescale.com>
    crypto: caam - add allocation failure handling in SPRINTFCAT macro

Olof Johansson <olof@lixom.net>
    i2c: s3c2410: resume race fix

Du, Wenkai <wenkai.du@intel.com>
    i2c: designware: Mask all interrupts during i2c controller enable

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bail out on zero length transfers

Hans de Goede <hdegoede@redhat.com>
    ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX

Levente Kurusa <levex@linux.com>
    libata: clean up ZPODD when a port is detached

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: fix cpu hotplug crash by removing per-cpu structure

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix crash when forking inside a transaction

Andy Grover <agrover@redhat.com>
    target: Don't allow setting WC emulation if device doesn't support

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix iscsit_accept_np and rdma_cm racy flow

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix wrong connection requests list addition

Marcel Apfelbaum <marcel.a@redhat.com>
    PCI: shpchp: Check bridge's secondary (not primary) bus speed

Arnd Bergmann <arnd@arndb.de>
    genirq: Provide irq_force_affinity fallback for non-SMP

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64, modify_ldt: Make support for 16-bit segments a runtime option

James Hogan <james.hogan@imgtec.com>
    metag: Reduce maximum stack size to 256MB

Mikulas Patocka <mpatocka@redhat.com>
    metag: fix memory barriers

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: restore the non-persistent data path

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: revoke foreign access for grants not mapped by the backend

Jianyu Zhan <nasa4836@gmail.com>
    percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    bus: mvebu-mbus: allow several windows with the same target/attribute

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: make rescuer_thread() empty wq->maydays list before exiting

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: fix a possible race condition between rescuer and pwq-release

Daeseok Youn <daeseok.youn@gmail.com>
    workqueue: fix bugs in wq_update_unbound_numa() failure path

J. Bruce Fields <bfields@redhat.com>
    nfsd4: remove lockowner when removing lock stateid

J. Bruce Fields <bfields@redhat.com>
    nfsd4: warn on finding lockowner without stateid's

Kinglong Mee <kinglongmee@gmail.com>
    NFSD: Call ->set_acl with a NULL ACL structure if no entries

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSd: call rpc_destroy_wait_queue() from free_client()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSd: Move default initialisers from create_client() to alloc_client()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - T540p - unify with other LEN0034 models

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for the ThinkPad W540

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - fix touchpad initialization on Gigabyte U2442

Sheng-Liang Song <ssl@chromium.org>
    Input: atkbd - fix keyboard not working on some LG laptops

Romain Izard <romain.izard.pro@gmail.com>
    trace: module: Maintain a valid user count

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts

Chew, Kean ho <kean.ho.chew@intel.com>
    i2c: i801: enable Intel BayTrail SMBUS

James Ralston <james.d.ralston@intel.com>
    i2c: i801: Add Device IDs for Intel Wildcat Point-LP PCH

Salva Peiró <speiro@ai2.upv.es>
    media: media-device: fix infoleak in ioctl media_enum_entities()

Dan Carpenter <dan.carpenter@oracle.com>
    clk: vexpress: NULL dereference on error path

Tim Chen <tim.c.chen@linux.intel.com>
    crypto: crypto_wq - Fix late crypto work queue initialization

Geert Uytterhoeven <geert+renesas@glider.be>
    Documentation: Update stable address in Chinese and Japanese translations

Emil Goode <emilgoode@gmail.com>
    brcmsmac: fix deadlock on missing firmware

Russell King <rmk+kernel@arm.linux.org.uk>
    leds: leds-pwm: properly clean up after probe failure

Martin Peres <martin.peres@labri.fr>
    drm/nouveau/pm/fan: drop the fan lock in fan_update() before rescheduling

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ben Hutchings <ben@decadent.org.uk>
    rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Liu Hua <sdu.liu@huawei.com>
    ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Sascha Hauer <s.hauer@pengutronix.de>
    ARM: dts: i.MX53: Fix ipu register space size

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    omap3isp: Defer probe when the IOMMU is not available

Christoph Hellwig <hch@lst.de>
    posix_acl: handle NULL ACL in posix_acl_equiv_mode

Mohammed Habibulla <moch@chromium.org>
    Bluetooth: Add support for Lite-on [04ca:3007]

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix redundant encryption request for reauthentication

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix triggering BR/EDR L2CAP Connect too early

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: fix beaconing on USB

Daniele Forsi <dforsi@gmail.com>
    USB: Nokia 5300 should be treated as unusual dev

Victor A. Santos <victoraur.santos@gmail.com>
    USB: Nokia 305 should be treated as unusual dev

Daniele Forsi <dforsi@gmail.com>
    usb: storage: shuttle_usbat: fix discs being detected twice

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add a number of Dell devices

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: fix problem with global suspend on ATI controllers

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    usb: gadget: at91-udc: fix irq and iomem resource retrieval

Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
    fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Atilla Filiz <atilla.filiz@essensium.com>
    iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference

Thierry Reding <treding@nvidia.com>
    drm/tegra: Remove gratuitous pad field

Leo Liu <leo.liu@amd.com>
    drm/radeon: check buffer relocation offset

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix ATPX detection on non-VGA GPUs

Egbert Eich <eich@suse.de>
    drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

NeilBrown <neilb@suse.de>
    md: avoid possible spinning md thread at shutdown.

Viresh Kumar <viresh.kumar@linaro.org>
    hrtimer: Set expiry time before switch_hrtimer_base()

Leon Ma <xindong.ma@intel.com>
    hrtimer: Prevent remote enqueue of leftmost timers

Stuart Hayes <stuart.w.hayes@gmail.com>
    hrtimer: Prevent all reprogramming if hang detected

Grant Likely <grant.likely@linaro.org>
    drivercore: deferral race condition fix

Josef Gajdusek <atx@atx.name>
    hwmon: (emc1403) Support full range of known chip revision numbers

Josef Gajdusek <atx@atx.name>
    hwmon: (emc1403) fix inverted store_hyst()

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix on-channel remain-on-channel

Chen Yucong <slaoub@gmail.com>
    hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
    x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm, thp: close race between mremap() and split_huge_page()

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix suspend vs. authentication race

Corey Minyard <cminyard@mvista.com>
    ipmi: Reset the KCS timeout when starting error recovery

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    ipmi: Fix a race restarting the timer

Jiri Bohac <jbohac@suse.cz>
    timer: Prevent overflow in apply_slack

Stephen Warren <swarren@nvidia.com>
    gpu: host1x: handle the correct # of syncpt regs

Loic Poulain <loic.poulain@intel.com>
    8250_core: Fix unwanted TX chars write

Loic Poulain <loic.poulain@intel.com>
    serial: 8250: Fix thread unsafe __dma_tx_complete function

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make fixup_user_fault() check the vma access rights too

Vincent Stehlé <vincent.stehle@laposte.net>
    topology: Fix compilation warning when not in SMP

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    pata_at91: fix ata_host_activate() failure handling

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    clocksource: Exynos_mct: Register clock event after request_irq()

Thomas Gleixner <tglx@linutronix.de>
    genirq: Allow forcing cpu affinity of interrupts

Thomas Gleixner <tglx@linutronix.de>
    irqchip: Gic: Support forced affinity setting

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/module: Hardcode ftrace_module_init() call into load_module()

Leif Lindholm <leif.lindholm@linaro.org>
    mips: dts: Fix missing device_type="memory" property in memory nodes

Thomas Gleixner <tglx@linutronix.de>
    futex: Prevent attaching to kernel threads

Thomas Gleixner <tglx@linutronix.de>
    futex: Add another early deadlock detection check


-------------

Diffstat:

 Documentation/i2c/busses/i2c-i801                  |   2 +
 Documentation/input/elantech.txt                   |   5 +-
 Documentation/ja_JP/HOWTO                          |   2 +-
 Documentation/ja_JP/stable_kernel_rules.txt        |   6 +-
 Documentation/zh_CN/HOWTO                          |   2 +-
 Documentation/zh_CN/stable_kernel_rules.txt        |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx53.dtsi                       |   2 +-
 arch/arm/kernel/crash_dump.c                       |   2 +-
 arch/metag/include/asm/barrier.h                   |   3 +
 arch/metag/include/asm/processor.h                 |   2 +
 arch/mips/cavium-octeon/octeon-irq.c               |   2 +-
 arch/mips/lantiq/dts/easy50712.dts                 |   1 +
 arch/mips/ralink/dts/mt7620a_eval.dts              |   1 +
 arch/mips/ralink/dts/rt2880_eval.dts               |   1 +
 arch/mips/ralink/dts/rt3052_eval.dts               |   1 +
 arch/mips/ralink/dts/rt3883_eval.dts               |   1 +
 arch/parisc/include/asm/processor.h                |   2 +
 arch/powerpc/Makefile                              |   4 +-
 arch/powerpc/include/asm/ppc_asm.h                 |   7 +-
 arch/powerpc/kernel/process.c                      |  10 ++
 arch/s390/crypto/aes_s390.c                        |   3 +
 arch/s390/crypto/des_s390.c                        |   3 +
 arch/x86/include/asm/hugetlb.h                     |   1 +
 arch/x86/kernel/ldt.c                              |   4 +-
 arch/x86/vdso/vdso32-setup.c                       |   8 ++
 crypto/crypto_wq.c                                 |   2 +-
 drivers/acpi/blacklist.c                           |  13 +++
 drivers/ata/libata-core.c                          |   9 ++
 drivers/ata/pata_at91.c                            |  11 +-
 drivers/base/dd.c                                  |  17 +++
 drivers/base/topology.c                            |   3 +-
 drivers/block/xen-blkfront.c                       | 125 +++++++++++++++------
 drivers/bluetooth/ath3k.c                          |   2 +
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bus/mvebu-mbus.c                           |   6 -
 drivers/char/ipmi/ipmi_kcs_sm.c                    |   5 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  46 +++++---
 drivers/clk/versatile/clk-vexpress-osc.c           |   2 +-
 drivers/clocksource/exynos_mct.c                   |   4 +-
 drivers/crypto/caam/error.c                        |  10 +-
 drivers/gpu/drm/i915/intel_display.c               |  26 +++--
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |  19 +++-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   3 -
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |   7 ++
 drivers/gpu/drm/radeon/radeon_uvd.c                |   4 +
 drivers/gpu/host1x/hw/intr_hw.c                    |   4 +-
 drivers/hv/connection.c                            |   6 +
 drivers/hwmon/emc1403.c                            |   4 +-
 drivers/i2c/busses/Kconfig                         |   2 +
 drivers/i2c/busses/i2c-designware-core.c           |   3 +
 drivers/i2c/busses/i2c-i801.c                      |   6 +
 drivers/i2c/busses/i2c-rcar.c                      |   9 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   7 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  27 ++---
 drivers/infiniband/ulp/isert/ib_isert.h            |   2 +-
 drivers/input/keyboard/atkbd.c                     |  29 ++++-
 drivers/input/mouse/elantech.c                     |  26 ++++-
 drivers/input/mouse/elantech.h                     |   1 +
 drivers/input/mouse/synaptics.c                    |  10 +-
 drivers/iommu/amd_iommu.c                          |   2 +-
 drivers/irqchip/irq-gic.c                          |   8 +-
 drivers/leds/leds-pwm.c                            |  23 ++--
 drivers/md/dm-crypt.c                              |  61 ++--------
 drivers/md/md.c                                    |   3 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/media-device.c                       |   1 +
 drivers/media/platform/omap3isp/isp.c              |   2 +
 drivers/media/tuners/fc2580.c                      |   6 +-
 drivers/media/tuners/fc2580_priv.h                 |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  12 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  14 +--
 drivers/net/wireless/rt2x00/rt2x00mac.c            |  22 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   2 +-
 drivers/pci/hotplug/shpchp_ctrl.c                  |   4 +-
 drivers/target/target_core_device.c                |   8 +-
 drivers/tty/serial/8250/8250_core.c                |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |   9 +-
 drivers/usb/gadget/at91_udc.c                      |  10 --
 drivers/usb/host/ehci-fsl.c                        |   3 +-
 drivers/usb/host/ohci-hub.c                        |  18 +++
 drivers/usb/host/ohci-pci.c                        |   1 +
 drivers/usb/host/ohci.h                            |   2 +
 drivers/usb/serial/qcserial.c                      |  15 +++
 drivers/usb/storage/shuttle_usbat.c                |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  14 +++
 fs/exec.c                                          |   6 +-
 fs/nfsd/nfs4acl.c                                  |  17 +--
 fs/nfsd/nfs4state.c                                |  40 ++++---
 fs/posix_acl.c                                     |   6 +
 include/linux/ftrace.h                             |   2 +
 include/linux/hyperv.h                             |   7 +-
 include/linux/interrupt.h                          |  40 ++++++-
 include/linux/irq.h                                |   3 +-
 include/trace/events/module.h                      |   2 +-
 include/uapi/drm/tegra_drm.h                       |   1 -
 kernel/futex.c                                     |  52 ++++++---
 kernel/hrtimer.c                                   |  30 ++++-
 kernel/irq/manage.c                                |  17 +--
 kernel/module.c                                    |   3 +
 kernel/timer.c                                     |   2 +-
 kernel/trace/ftrace.c                              |  27 +----
 kernel/workqueue.c                                 |  36 +++++-
 mm/memory-failure.c                                |  15 +--
 mm/memory.c                                        |   5 +
 mm/mremap.c                                        |   9 +-
 mm/percpu.c                                        |   2 +-
 net/bluetooth/hci_conn.c                           |   9 +-
 net/bluetooth/hci_event.c                          |   6 +
 net/ceph/messenger.c                               |  20 +++-
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/mlme.c                                |  26 +++++
 net/mac80211/offchannel.c                          |  25 +++--
 net/mac80211/pm.c                                  |  14 ++-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/soc/codecs/wm8962.c                          |  15 ++-
 sound/soc/codecs/wm8962.h                          |   4 +
 sound/usb/card.h                                   |   1 +
 sound/usb/endpoint.c                               |  15 ++-
 120 files changed, 875 insertions(+), 368 deletions(-)


