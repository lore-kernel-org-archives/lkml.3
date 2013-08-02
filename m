Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3HBK6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:58:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab3HBKHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:07:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/99] 3.10.5-stable review
Date: Fri,  2 Aug 2013 18:07:13 +0800
Message-Id: <20130802100225.478715166@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.5 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug  4 10:00:45 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.5-rc1

Yinghai Lu <yinghai@kernel.org>
    x86: Fix /proc/mtrr with base/size more than 44bits

Xiong Zhang <xiong.y.zhang@intel.com>
    drm/i915: Correct obj->mm_list link to dev_priv->dev_priv->mm.inactive_list

Michael Witten <mfwitten@gmail.com>
    perf tools: Revert regression in configuration of Python support

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix iscsit_sequence_cmd reject handling for iser

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix iscsit_add_reject* usage for iser

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    radeon kms: do not flush uninitialized hotplug work

David Vrabel <david.vrabel@citrix.com>
    xen/evtchn: avoid a deadlock when unbinding an event channel

Al Viro <viro@zeniv.linux.org.uk>
    livelock avoidance in sget()

Gianluca Anzolin <gianluca@sottospazio.it>
    tty_port: Fix refcounting leak in tty_port_tty_hangup()

Oleg Nesterov <oleg@redhat.com>
    mm: mempolicy: fix mbind_range() && vma_adjust() interaction

Rong Wang <Rong.Wang@csr.com>
    usb: gadget: udc-core: fix the typo of udc state attribute

Rick Farina (Zero_Chaos) <zerochaos@gentoo.org>
    USB: serial: ftdi_sio: add more RT Systems ftdi devices

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Initialize power-setting callback for USB devices

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: initialize more atom interpretor elements to 0

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix audio dto programming on DCE4+

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm/nouveau: fix semaphore dmabuf obj

Ben Widawsky <ben@bwidawsk.net>
    drm/i915: fix missed hunk after GT access breakage

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix up gt init sequence fallout

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Serialize almost all register access

Kamal Mostafa <kamal@canonical.com>
    drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: correctly restore fences with objects attached

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix dereferencing invalid connectors in is_crtc_connector_off()

Konstantin Khlebnikov <khlebnikov@openvz.org>
    drm/i915: fix long-standing SNB regression in power consumption after resume v2

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix incoherence with fence updates on Sandybridge+

Guenter Roeck <linux@roeck-us.net>
    Partially revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix write-read race with multiple rings

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: improve dac adjust heuristics for legacy pdac

Mark Kettenis <kettenis@openbsd.org>
    drm/radeon: fix combios tables on older cards

Ondrej Zary <linux@rainbow-software.org>
    drm/radeon: Another card with wrong primary dac adj

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian issues with DP handling (v3)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: allow selection of alignment in the sub-allocator

Christian König <christian.koenig@amd.com>
    drm/radeon: fix UVD fence emit

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/hdmi: make sure we have an afmt block assigned

Mikulas Patocka <mpatocka@redhat.com>
    dm verity: fix inability to use a few specific devices sizes

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: set noio flag to avoid __vmalloc deadlock

Hannes Reinecke <hare@suse.de>
    dm mpath: fix ioctl deadlock when no paths

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / video: ignore BIOS initial backlight value for Fujitsu E753

Toshi Kani <toshi.kani@hp.com>
    ACPI / memhotplug: Fix a stale pointer in error path

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / scan: Do not try to attach scan handlers to devices having them

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / scan: Always call acpi_bus_scan() for bus check notifications

Daniel Mack <zonque@gmail.com>
    regmap: cache: bail in regmap_async_complete() for bus-less maps

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: balloon: Do not post pressure status if interrupted

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: balloon: Fix a bug in the hot-add code

K. Y. Srinivasan <kys@microsoft.com>
    Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration

Harshula Jayasuriya <harshula@redhat.com>
    nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file

Anton Blanchard <anton@samba.org>
    powerpc/modules: Module CRC relocation fix causes perf issues

Vakul Garg <vakul@freescale.com>
    crypto: caam - Fixed the memory out of bound overwrite issue

Dan Carpenter <dan.carpenter@oracle.com>
    svcrdma: underflow issue in decode_write_list()

Tejun Heo <tj@kernel.org>
    libata: make it clear that sata_inic162x is experimental

Youquan Song <youquan.song@intel.com>
    ata: Fix DVD not dectected at some platform with Wellsburg PCH

NeilBrown <neilb@suse.de>
    md/raid10: remove use-after-free bug.

NeilBrown <neilb@suse.de>
    md/raid5: fix interaction of 'replace' and 'recovery'.

NeilBrown <neilb@suse.de>
    md/raid1: fix bio handling problems in process_checks()

NeilBrown <neilb@suse.de>
    md: Remove recent change which allows devices to skip recovery.

Kees Cook <keescook@chromium.org>
    x86: make sure IDT is page aligned

H. Peter Anvin <hpa@linux.intel.com>
    x86, suspend: Handle CPUs which fail to #GP on RDMSR

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/blkback: Check device permissions before allowing OP_DISCARD

Jan Beulich <JBeulich@suse.com>
    xen-netfront: pull on receive skb may need to happen earlier

Josef Bacik <jbacik@fusionio.com>
    Btrfs: re-add root to dead root list if we stop dropping it

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix lock leak when resuming snapshot deletion

Stefan Behrens <sbehrens@giantdisaster.de>
    Btrfs: fix wrong write offset when replacing a device

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq / intel_pstate: Change to scale off of max P-state

Karlis Ogsts <karlis.ogsts@sonymobile.com>
    staging: android: logger: Correct write offset reset on error

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: fix a race between do_cmd_ioctl() and read/write

Alan Stern <stern@rowland.harvard.edu>
    USB: global suspend and remote wakeup don't mix

William Gulland <wgulland@google.com>
    usb: Clear both buffers when clearing a control transfer TT buffer.

Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
    USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix dynamic-id matching

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Huang Rui <ray.huang@amd.com>
    usb: dwc3: fix wrong bit mask in dwc3_event_type

Ruchika Kharwar <ruchika@ti.com>
    usb: dwc3: fix the error returned with usb3_phy failure

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix memory leak in open

Roger Quadros <rogerq@ti.com>
    USB: EHCI: Fix resume signalling on remote wakeup

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Avoid NULL pointer deref when host dies.

Oleksij Rempel <linux@rempel-privat.de>
    xhci: fix null pointer dereference on ring_doorbell_for_active_rings

George Cherian <george.cherian@ti.com>
    usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Remove locking trace_types_lock from tracing_reset_all_online_cpus()

Oleg Nesterov <oleg@redhat.com>
    tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()

Alexander Z Lam <azl@google.com>
    tracing: Miscellaneous fixes for trace_array ref counting

Alexander Z Lam <azl@google.com>
    tracing: Fix error handling to ensure instances can always be removed

Saurav Kashyap <saurav.kashyap@qlogic.com>
    SCSI: qla2xxx: Properly set the tagging for commands.

Ewan D. Milne <emilne@redhat.com>
    SCSI: sd: fix crash when UA received on DIF enabled device

Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    SCSI: isci: Fix a race condition in the SSP task management path

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: 7722/1: zImage: Convert 32bits memory size and address from ATAG to 64bits DTB

Nicolin Chen <b42378@freescale.com>
    ASoC: wm8962: Remove remaining direct register cache accesses

Richard Zhao <rizhao@nvidia.com>
    ASoC: tegra: correct playback_dma_data setup

Chih-Chung Chang <chihchung@chromium.org>
    ASoC: max98088 - fix element type of the register cache.

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL

Clemens Ladisch <clemens@ladisch.de>
    firewire: fix libdc1394/FlyCap2 iso event regression

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Guess what, it's two more Dell headset mic quirks

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Yet another Dell headset mic quirk

Ren Bigcren <bigcren.ren@sonymobile.com>
    USB: storage: Add MicroVault Flash Drive to unusual_devs

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ISCSI_OP_SCSI_TMFUNC handling for iser

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix session reset bug with RDMA_CM_EVENT_DISCONNECTED

Joern Engel <joern@logfs.org>
    iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix isert_put_reject payload buffer post

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm/boot/compressed/atags_to_fdt.c      |  44 +++-
 arch/powerpc/include/asm/module.h            |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S            |   3 -
 arch/x86/kernel/acpi/sleep.c                 |  18 +-
 arch/x86/kernel/cpu/mtrr/generic.c           |  21 +-
 arch/x86/kernel/cpu/mtrr/main.c              |  16 +-
 arch/x86/kernel/head_64.S                    |   2 +-
 drivers/acpi/acpi_memhotplug.c               |   1 +
 drivers/acpi/scan.c                          |  13 +-
 drivers/acpi/video.c                         |   8 +
 drivers/ata/Kconfig                          |   2 +-
 drivers/ata/ata_piix.c                       |   2 +-
 drivers/ata/sata_inic162x.c                  |  14 ++
 drivers/base/regmap/regmap.c                 |   2 +-
 drivers/block/xen-blkback/blkback.c          |  13 +-
 drivers/cpufreq/intel_pstate.c               |  12 +-
 drivers/crypto/caam/caamhash.c               |   2 +-
 drivers/firewire/core-cdev.c                 |   3 +
 drivers/firewire/ohci.c                      |  10 +-
 drivers/gpu/drm/i915/i915_dma.c              |  17 +-
 drivers/gpu/drm/i915/i915_drv.c              |  13 +-
 drivers/gpu/drm/i915/i915_drv.h              |   4 +-
 drivers/gpu/drm/i915/i915_gem.c              |  54 ++++-
 drivers/gpu/drm/i915/intel_display.c         |  39 +++-
 drivers/gpu/drm/i915/intel_panel.c           |   3 +-
 drivers/gpu/drm/i915/intel_pm.c              |  45 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.c      |   9 +-
 drivers/gpu/drm/nouveau/nv17_fence.c         |   2 +-
 drivers/gpu/drm/nouveau/nv50_fence.c         |  14 +-
 drivers/gpu/drm/radeon/atom.c                |   5 +
 drivers/gpu/drm/radeon/atombios_dp.c         |  43 +++-
 drivers/gpu/drm/radeon/evergreen_hdmi.c      |   8 +-
 drivers/gpu/drm/radeon/r600.c                |   2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c           |   6 +
 drivers/gpu/drm/radeon/radeon.h              |   1 +
 drivers/gpu/drm/radeon/radeon_combios.c      | 159 +++++---------
 drivers/gpu/drm/radeon/radeon_gart.c         |   1 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c      |   9 +-
 drivers/gpu/drm/radeon/radeon_object.h       |   2 +-
 drivers/gpu/drm/radeon/radeon_ring.c         |   1 +
 drivers/gpu/drm/radeon/radeon_sa.c           |   7 +-
 drivers/hv/hv_balloon.c                      |  21 +-
 drivers/infiniband/ulp/isert/ib_isert.c      | 119 +++++++---
 drivers/infiniband/ulp/isert/ib_isert.h      |   1 +
 drivers/md/dm-ioctl.c                        |   3 +
 drivers/md/dm-mpath.c                        |   8 +-
 drivers/md/dm-verity.c                       |   5 +-
 drivers/md/dm.c                              |   9 +-
 drivers/md/md.c                              |  14 --
 drivers/md/raid1.c                           |  53 +++--
 drivers/md/raid10.c                          |   8 +-
 drivers/md/raid5.c                           |  15 +-
 drivers/md/raid5.h                           |   1 +
 drivers/net/wireless/rtlwifi/pci.c           |  13 --
 drivers/net/wireless/rtlwifi/ps.c            |  12 +
 drivers/net/wireless/rtlwifi/ps.h            |   1 +
 drivers/net/wireless/rtlwifi/usb.c           |   2 +
 drivers/net/xen-netfront.c                   |  31 ++-
 drivers/scsi/isci/task.c                     |   9 +-
 drivers/scsi/qla2xxx/qla_iocb.c              |  11 +-
 drivers/scsi/sd.c                            |  22 +-
 drivers/staging/android/logger.c             |   4 +-
 drivers/staging/comedi/comedi_fops.c         |  32 ++-
 drivers/target/iscsi/iscsi_target.c          | 313 ++++++++++++---------------
 drivers/target/iscsi/iscsi_target.h          |   2 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   2 +-
 drivers/target/iscsi/iscsi_target_core.h     |   4 +-
 drivers/target/iscsi/iscsi_target_erl0.c     |   8 +-
 drivers/target/iscsi/iscsi_target_erl1.c     |  26 +--
 drivers/target/iscsi/iscsi_target_util.c     |  27 ++-
 drivers/target/iscsi/iscsi_target_util.h     |   3 +-
 drivers/tty/tty_port.c                       |   5 +-
 drivers/usb/core/hub.c                       |  48 +++-
 drivers/usb/core/hub.h                       |   3 +
 drivers/usb/dwc3/core.c                      |   2 +-
 drivers/usb/dwc3/core.h                      |   4 +-
 drivers/usb/dwc3/gadget.c                    |   1 +
 drivers/usb/gadget/udc-core.c                |   2 +-
 drivers/usb/host/ehci-hub.c                  |   1 +
 drivers/usb/host/xhci-pci.c                  |   1 -
 drivers/usb/host/xhci-ring.c                 |   2 +-
 drivers/usb/host/xhci.c                      |  13 +-
 drivers/usb/misc/sisusbvga/sisusb.c          |   1 +
 drivers/usb/serial/ftdi_sio.c                |  31 ++-
 drivers/usb/serial/ftdi_sio_ids.h            |  34 ++-
 drivers/usb/serial/mos7840.c                 |  25 ++-
 drivers/usb/serial/ti_usb_3410_5052.c        |   2 +-
 drivers/usb/storage/unusual_devs.h           |   7 +
 drivers/xen/evtchn.c                         |  21 +-
 fs/btrfs/extent-tree.c                       |  13 ++
 fs/btrfs/scrub.c                             |   2 +-
 fs/nfsd/vfs.c                                |   5 +-
 fs/super.c                                   |  25 +--
 include/linux/firewire.h                     |   1 +
 include/target/iscsi/iscsi_transport.h       |   9 +-
 include/uapi/linux/firewire-cdev.h           |   4 +-
 kernel/trace/trace.c                         |  33 ++-
 kernel/trace/trace_events.c                  |  21 +-
 mm/memory.c                                  |   9 +-
 mm/mempolicy.c                               |   6 +-
 mm/mmap.c                                    |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c       |  20 +-
 sound/pci/hda/patch_realtek.c                |   3 +
 sound/soc/codecs/max98088.c                  |   2 +-
 sound/soc/codecs/sgtl5000.c                  |   2 +-
 sound/soc/codecs/wm8962.c                    |  24 +-
 sound/soc/tegra/tegra20_ac97.c               |   6 +-
 sound/soc/tegra/tegra20_spdif.c              |   4 +-
 tools/hv/hv_kvp_daemon.c                     |   5 +-
 tools/perf/config/utilities.mak              |   2 +-
 111 files changed, 1121 insertions(+), 698 deletions(-)


