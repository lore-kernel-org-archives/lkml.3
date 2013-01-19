Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3ASBRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:17:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:56189 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab3ASBRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/33] 3.7.4-stable review
Date: Fri, 18 Jan 2013 17:16:25 -0800
Message-Id: <20130119010345.885772698@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.7.4 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jan 21 01:01:55 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.4-rc1

Jiri Slaby <jslaby@suse.cz>
    pty: return EINVAL for TIOCGPTN for BSD ptys

Steffen Trumtrar <s.trumtrar@pengutronix.de>
    mxs: uart: fix setting RTS from software

Ben Hutchings <ben@decadent.org.uk>
    staging: vt6656: Fix inconsistent structure packing

Tormod Volden <debian.tormod@gmail.com>
    staging: wlan-ng: Fix clamping of returned SSID length

Stephen Hurd <shurd@broadcom.com>
    8250/16?50: Add support for Broadcom TruManage redirected serial port

Maxime Ripard <maxime.ripard@free-electrons.com>
    tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    tty: serial: vt8500: fix return value check in vt8500_serial_probe()

chao bi <chao.bi@intel.com>
    serial:ifx6x60:Delete SPI timer when shut down port

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on ONDA MT8205 4G LTE

Bjørn Mork <bjorn@mork.no>
    USB: option: add TP-LINK HSUPA Modem MA180

Wolfgang Frisch <wfpub@roembden.net>
    USB: io_ti: Fix NULL dereference in chase_port()

Andrew Cooper <andrew.cooper3@citrix.com>
    xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.

Matt Wilson <msw@amazon.com>
    xen/grant-table: correctly initialize grant table version 1

Stefan Assmann <sassmann@kpanic.de>
    igb: release already assigned MSI-X interrupts if setup fails

Tom Mingarelli <thomas.mingarelli@hp.com>
    intel-iommu: Prevent devices with RMRRs from being placed into SI Domain

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Add link_magic for fabric allow_link destination target_items

Ilija Hadzic <ihadzic@research.bell-labs.com>
    drm/radeon: fix a bogus kfree

Ilija Hadzic <ihadzic@research.bell-labs.com>
    drm/radeon: fix NULL pointer dereference in UMS mode

Fabio Estevam <fabio.estevam@freescale.com>
    usb: chipidea: Allow disabling streaming not only in udc mode

Eric Sandeen <sandeen@redhat.com>
    ext4: init pagevec in ext4_da_block_invalidatepages

David Henningsson <david.henningsson@canonical.com>
    ALSA: usb - fix race in creation of M-Audio Fast track pro driver

Jesse Barnes <jbarnes@virtuousgeek.org>
    x86/Sandy Bridge: reserve pages when integrated graphics is present

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/time: fix sched_clock() overflow

Roland Dreier <roland@purestorage.com>
    target: Release se_cmd when LUN lookup fails for TMR

Roland Dreier <roland@purestorage.com>
    target: Fix use-after-free in LUN RESET handling

Roland Dreier <roland@purestorage.com>
    target: Fix missing CMD_T_ACTIVE bit regression for pending WRITEs

Mark Rustad <mark.d.rustad@intel.com>
    tcm_fc: Do not report target role when target is not defined

Mark Rustad <mark.d.rustad@intel.com>
    tcm_fc: Do not indicate retry capability to initiators

Hannes Reinecke <hare@suse.de>
    target: use correct sense code for LUN communication failure

Will Deacon <will.deacon@arm.com>
    arm64: mm: only wrprotect clean ptes if they are present

Luciano Coelho <coelho@ti.com>
    firmware: make sure the fw file size is not 0

Thomas Schwinge <thomas@codesourcery.com>
    sh: Fix FDPIC binary loader

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi - Work around "alsactl restore" errors


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/arm64/include/asm/pgtable.h             | 16 +++++-----
 arch/s390/include/asm/timex.h                | 28 +++++++++++++++++
 arch/s390/kernel/time.c                      |  2 +-
 arch/s390/kvm/interrupt.c                    |  2 +-
 arch/sh/include/asm/elf.h                    |  4 +--
 arch/x86/kernel/entry_32.S                   |  1 -
 arch/x86/kernel/setup.c                      | 78 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/firmware_class.c                |  2 +-
 drivers/gpu/drm/radeon/r600_cs.c             |  6 ++--
 drivers/gpu/drm/radeon/radeon_cs.c           |  5 +--
 drivers/iommu/intel-iommu.c                  | 31 +++++++++++++++++++
 drivers/net/ethernet/intel/igb/igb_main.c    | 22 +++++++++----
 drivers/staging/vt6656/bssdb.h               |  1 -
 drivers/staging/vt6656/int.h                 |  1 -
 drivers/staging/vt6656/iocmd.h               | 33 ++++++++++----------
 drivers/staging/vt6656/iowpa.h               |  8 ++---
 drivers/staging/wlan-ng/prism2mgmt.c         |  2 +-
 drivers/target/target_core_device.c          |  1 +
 drivers/target/target_core_fabric_configfs.c | 12 ++++++++
 drivers/target/target_core_tpg.c             |  1 +
 drivers/target/target_core_transport.c       | 11 ++++---
 drivers/target/tcm_fc/tfc_sess.c             | 12 ++++++--
 drivers/tty/pty.c                            |  2 ++
 drivers/tty/serial/8250/8250.c               | 11 +++++++
 drivers/tty/serial/8250/8250.h               |  1 +
 drivers/tty/serial/8250/8250_dw.c            |  2 +-
 drivers/tty/serial/8250/8250_pci.c           | 38 +++++++++++++++++++++++
 drivers/tty/serial/ifx6x60.c                 |  1 +
 drivers/tty/serial/mxs-auart.c               |  4 ++-
 drivers/tty/serial/vt8500_serial.c           |  2 +-
 drivers/usb/chipidea/host.c                  |  3 ++
 drivers/usb/serial/io_ti.c                   |  3 ++
 drivers/usb/serial/option.c                  |  9 +++++-
 drivers/xen/grant-table.c                    | 48 +++++++++++++++++------------
 fs/ext4/inode.c                              |  2 ++
 include/target/target_core_base.h            |  4 +++
 include/uapi/linux/serial_core.h             |  4 ++-
 sound/pci/hda/patch_hdmi.c                   |  2 +-
 sound/usb/quirks.c                           |  8 +++--
 40 files changed, 342 insertions(+), 85 deletions(-)


