Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3GAUYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:24:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3GAUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/26] 3.9.9-stable review
Date: Mon,  1 Jul 2013 13:09:55 -0700
Message-Id: <20130701200729.872850414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.9.9 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul  3 20:05:42 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.9-rc1

Phil Oester <kernel@linuxace.com>
    netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment handling

Johannes Berg <johannes.berg@intel.com>
    mac80211: work around broken APs not including HT info

Marc Kleine-Budde <mkl@pengutronix.de>
    can: usb_8dev: unregister netdev before free()ing

Tang Yuantian <yuantian.tang@freescale.com>
    of/base: release the node correctly in of_parse_phandle_with_args()

Aaron Lu <aaron.lu@intel.com>
    libata-acpi: add back ACPI based hotplug functionality

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: fix a horrid bug

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: prepare to fix a horrid bug

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Fix fetching bus for single-dev-PE

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algboss - Hold ref count on larval

Stephane Eranian <eranian@google.com>
    perf: Disable monitoring on setuid processes for regular users

Neil Horman <nhorman@tuxdriver.com>
    iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: fix RT5390 & RT3290 TX power settings regression

Gavin Shan <shangw@linux.vnet.ibm.com>
    net/tg3: Avoid delay during MMIO access

Zefan Li <lizefan@huawei.com>
    dlci: validate the net device in dlci_del()

Zefan Li <lizefan@huawei.com>
    dlci: acquire rtnl_lock before calling __dev_get_by_name()

Ben Hutchings <ben@decadent.org.uk>
    s390/irq: Only define synchronize_irq() on SMP

Ben Hutchings <ben@decadent.org.uk>
    s390/pci: Implement IRQ functions if !PCI

Nikolay Martynov <mar.kolya@gmail.com>
    iwlwifi: dvm: fix chain noise calibration

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_htc: Handle IDLE state transition properly

Oleg Nesterov <oleg@redhat.com>
    hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Oleg Nesterov <oleg@redhat.com>
    hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)

Jaganath Kanakkassery <jaganath.k@samsung.com>
    Bluetooth: Fix invalid length check in l2cap_information_rsp()

Anderson Lizardo <anderson.lizardo@openbossa.org>
    Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Simon Baatz <gmbnomis@gmail.com>
    ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Simon Baatz <gmbnomis@gmail.com>
    ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page

Michael Holzheu <holzheu@linux.vnet.ibm.com>
    s390/ipl: Fix FCP WWPN and LUN format strings for read


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/arm/include/asm/cacheflush.h              |  4 +-
 arch/arm/mm/flush.c                            | 33 ++++++++++
 arch/arm/mm/nommu.c                            |  6 ++
 arch/powerpc/platforms/pseries/eeh_pe.c        |  3 +-
 arch/s390/kernel/ipl.c                         |  8 +--
 arch/s390/kernel/irq.c                         | 66 +++++++++++++++++++
 arch/s390/pci/pci.c                            | 33 ----------
 arch/x86/include/asm/irq_remapping.h           |  3 +
 arch/x86/kernel/early-quirks.c                 | 20 ++++++
 crypto/algboss.c                               | 15 ++---
 crypto/api.c                                   |  6 --
 crypto/internal.h                              |  6 ++
 drivers/ata/libata-acpi.c                      | 36 ++++++++++-
 drivers/ata/libata-core.c                      |  2 +
 drivers/ata/libata.h                           |  2 +
 drivers/iommu/intel_irq_remapping.c            | 10 +++
 drivers/iommu/irq_remapping.c                  |  6 ++
 drivers/iommu/irq_remapping.h                  |  2 +
 drivers/net/can/usb/usb_8dev.c                 |  5 +-
 drivers/net/ethernet/broadcom/tg3.c            | 36 +++++++++++
 drivers/net/wan/dlci.c                         | 26 ++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c        |  2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c        | 29 +++++----
 drivers/of/base.c                              |  4 +-
 fs/exec.c                                      | 16 ++---
 fs/ubifs/dir.c                                 | 54 +++++++++++-----
 kernel/events/hw_breakpoint.c                  |  6 +-
 net/bluetooth/l2cap_core.c                     |  5 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  2 +-
 net/mac80211/ieee80211_i.h                     |  4 +-
 net/mac80211/mlme.c                            | 87 +++++++++++++++++++++++---
 net/mac80211/util.c                            |  6 +-
 34 files changed, 432 insertions(+), 117 deletions(-)


