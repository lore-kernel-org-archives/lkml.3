Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaACAOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:14:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23651 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaACAHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/10] IOMMU: irq-remapping and dmar hotplug support
Date: Thu,  2 Jan 2014 16:08:07 -0800
Message-Id: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During pci root bus hot-add, ioapic and iommu need to be parsed at first.
Using acpi_pci_driver->add to do that.

The patches need to apply after for-x86-irq

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-iommu-3.14

-v2: refreshed after 3.13-rc6

Yinghai Lu (10):
  IOMMU: Update dmar units devices list during hotplug
  IOMMU: Fix tboot force iommu logic
  IOMMU: Don't clean handler data before free_irq()
  IOMMU: iommu_unique_seq_id()
  ACPI: Add acpi_run_dsm()
  IOMMU: Separate free_dmar_iommu from free_iommu
  IOMMU: Add init_dmar_one()
  IOMMU: Add intel_enable_irq_remapping_one()
  IOMMU: Add dmar_parse_one_drhd()
  IOMMU: Add intel iommu irq-remapping and dmar hotplug support

 drivers/acpi/bus.c                  |  77 +++++++
 drivers/acpi/pci_root.c             |   2 +
 drivers/iommu/dmar.c                | 414 ++++++++++++++++++++++++++++++++++--
 drivers/iommu/intel-iommu.c         | 162 +++++++++++---
 drivers/iommu/intel_irq_remapping.c | 167 ++++++++++++++-
 include/linux/acpi.h                |  10 +
 include/linux/dmar.h                |  53 ++++-
 include/linux/pci-acpi.h            |   8 +
 8 files changed, 836 insertions(+), 57 deletions(-)

-- 
1.8.4

