Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3HBKWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:22:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3HBKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:22:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/23] 3.0.89-stable review
Date: Fri,  2 Aug 2013 18:23:13 +0800
Message-Id: <20130802102036.180660415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.89 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug  4 10:19:28 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.89-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.89-rc1

Wanpeng Li <liwanp@linux.vnet.ibm.com>
    mm/memory-hotplug: fix lowmem count overflow when offline pages

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix race in RX VQ processing

Michael S. Tsirkin <mst@redhat.com>
    virtio: support unlocked queue poll

David Vrabel <david.vrabel@citrix.com>
    xen/evtchn: avoid a deadlock when unbinding an event channel

Al Viro <viro@zeniv.linux.org.uk>
    livelock avoidance in sget()

Rick Farina (Zero_Chaos) <zerochaos@gentoo.org>
    USB: serial: ftdi_sio: add more RT Systems ftdi devices

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: initialize more atom interpretor elements to 0

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: improve dac adjust heuristics for legacy pdac

Mark Kettenis <kettenis@openbsd.org>
    drm/radeon: fix combios tables on older cards

Toshi Kani <toshi.kani@hp.com>
    ACPI / memhotplug: Fix a stale pointer in error path

Anton Blanchard <anton@samba.org>
    powerpc/modules: Module CRC relocation fix causes perf issues

Tejun Heo <tj@kernel.org>
    libata: make it clear that sata_inic162x is experimental

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

William Gulland <wgulland@google.com>
    usb: Clear both buffers when clearing a control transfer TT buffer.

Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
    USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix dynamic-id matching

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Avoid NULL pointer deref when host dies.

Oleksij Rempel <linux@rempel-privat.de>
    xhci: fix null pointer dereference on ring_doorbell_for_active_rings

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Fix irqs-off tag display in syscall tracing

Saurav Kashyap <saurav.kashyap@qlogic.com>
    SCSI: qla2xxx: Properly set the tagging for commands.

Ewan D. Milne <emilne@redhat.com>
    SCSI: sd: fix crash when UA received on DIF enabled device

Chih-Chung Chang <chihchung@chromium.org>
    ASoC: max98088 - fix element type of the register cache.

Ren Bigcren <bigcren.ren@sonymobile.com>
    USB: storage: Add MicroVault Flash Drive to unusual_devs


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/powerpc/include/asm/module.h       |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S       |   3 -
 drivers/acpi/acpi_memhotplug.c          |   1 +
 drivers/ata/Kconfig                     |   2 +-
 drivers/ata/sata_inic162x.c             |  14 +++
 drivers/gpu/drm/radeon/atom.c           |   5 ++
 drivers/gpu/drm/radeon/radeon_combios.c | 151 ++++++++++----------------------
 drivers/net/virtio_net.c                |   5 +-
 drivers/scsi/qla2xxx/qla_iocb.c         |  11 ++-
 drivers/scsi/sd.c                       |  22 ++---
 drivers/staging/comedi/comedi_fops.c    |   7 +-
 drivers/usb/core/hub.c                  |   9 ++
 drivers/usb/host/xhci-ring.c            |   2 +-
 drivers/usb/host/xhci.c                 |   6 +-
 drivers/usb/misc/sisusbvga/sisusb.c     |   1 +
 drivers/usb/serial/ftdi_sio.c           |  31 ++++++-
 drivers/usb/serial/ftdi_sio_ids.h       |  34 +++++--
 drivers/usb/serial/ti_usb_3410_5052.c   |   2 +-
 drivers/usb/storage/unusual_devs.h      |   7 ++
 drivers/virtio/virtio_ring.c            |  59 +++++++++++--
 drivers/xen/evtchn.c                    |  21 +----
 fs/super.c                              |  25 +++---
 include/linux/virtio.h                  |   4 +
 kernel/trace/trace_syscalls.c           |   3 +
 mm/page_alloc.c                         |   4 +
 sound/soc/codecs/max98088.c             |   2 +-
 27 files changed, 249 insertions(+), 191 deletions(-)


