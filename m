Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3ASBTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:19:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:56749 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab3ASBTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:19:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/21] 3.4.27-stable review
Date: Fri, 18 Jan 2013 17:19:18 -0800
Message-Id: <20130119010710.897187774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.27 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jan 21 01:05:31 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.27-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.27-rc1

Ben Hutchings <ben@decadent.org.uk>
    staging: vt6656: Fix inconsistent structure packing

Tormod Volden <debian.tormod@gmail.com>
    staging: wlan-ng: Fix clamping of returned SSID length

Maxime Ripard <maxime.ripard@free-electrons.com>
    tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

chao bi <chao.bi@intel.com>
    serial:ifx6x60:Delete SPI timer when shut down port

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on ONDA MT8205 4G LTE

Bjørn Mork <bjorn@mork.no>
    USB: option: add TP-LINK HSUPA Modem MA180

Andrew Cooper <andrew.cooper3@citrix.com>
    xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.

Matt Wilson <msw@amazon.com>
    xen/grant-table: correctly initialize grant table version 1

Philipp Reisner <philipp.reisner@linbit.com>
    drbd: add missing part_round_stats to _drbd_start_io_acct

Stefan Assmann <sassmann@kpanic.de>
    igb: release already assigned MSI-X interrupts if setup fails

Tom Mingarelli <thomas.mingarelli@hp.com>
    intel-iommu: Prevent devices with RMRRs from being placed into SI Domain

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Add link_magic for fabric allow_link destination target_items

Francois Romieu <romieu@fr.zoreil.com>
    r8169: avoid NAPI scheduling delay.

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

Mark Rustad <mark.d.rustad@intel.com>
    tcm_fc: Do not report target role when target is not defined

Mark Rustad <mark.d.rustad@intel.com>
    tcm_fc: Do not indicate retry capability to initiators

Thomas Schwinge <thomas@codesourcery.com>
    sh: Fix FDPIC binary loader


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/s390/include/asm/timex.h                | 28 +++++++++++++++++
 arch/s390/kernel/time.c                      |  2 +-
 arch/s390/kvm/interrupt.c                    |  2 +-
 arch/sh/include/asm/elf.h                    |  4 +--
 arch/x86/kernel/entry_32.S                   |  1 -
 arch/x86/kernel/setup.c                      | 78 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_req.c                |  1 +
 drivers/iommu/intel-iommu.c                  | 31 +++++++++++++++++++
 drivers/net/ethernet/intel/igb/igb_main.c    | 22 +++++++++----
 drivers/net/ethernet/realtek/r8169.c         |  6 +---
 drivers/staging/vt6656/bssdb.h               |  1 -
 drivers/staging/vt6656/int.h                 |  1 -
 drivers/staging/vt6656/iocmd.h               | 33 ++++++++++----------
 drivers/staging/vt6656/iowpa.h               |  8 ++---
 drivers/staging/wlan-ng/prism2mgmt.c         |  2 +-
 drivers/target/target_core_device.c          |  1 +
 drivers/target/target_core_fabric_configfs.c | 12 ++++++++
 drivers/target/target_core_tpg.c             |  1 +
 drivers/target/target_core_transport.c       |  3 ++
 drivers/target/tcm_fc/tfc_sess.c             | 12 ++++++--
 drivers/tty/serial/8250/8250_dw.c            |  2 +-
 drivers/tty/serial/ifx6x60.c                 |  1 +
 drivers/usb/serial/option.c                  |  9 +++++-
 drivers/xen/grant-table.c                    | 48 +++++++++++++++++------------
 fs/ext4/inode.c                              |  2 ++
 include/target/target_core_base.h            |  4 +++
 sound/usb/quirks.c                           |  8 +++--
 28 files changed, 257 insertions(+), 70 deletions(-)


