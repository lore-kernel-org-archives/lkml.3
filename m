Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3JKGwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:52:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:60963 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab3JKGwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:52:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="409271592"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org, bhelgaas@google.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ACPI/PCI: Parse PCI root bridge's ACPI resource via ACPI resource functions
Date: Fri, 11 Oct 2013 14:52:04 +0800
Message-Id: <1381474332-11328-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

This patchset is to add memory prefecth flag setting and address
translation support in the ACPI resource function. Convert x86/iad64
PCI root bridge's ACPI resource to generic resource via ACPI resource
functions.

PATCH 3 is to add new function acpi_dev_resource_address_space_full()
to meet requirement that ACPI address space info is still needed after
being converted to generic resource.


Lan Tianyu (5):
  ACPI/Resource: Add memory prefetch check support
  ACPI/Resource: Add address translation support
  ACPI: Add new acpi_dev_resource_address_space_full() function
  X86/PCI/ACPI: Rework setup_resource() via functions ACPI resource
    functions
  IA64/PCI/ACPI: Rework PCI root bridge ACPI resource conversion

 arch/ia64/pci/pci.c     | 36 ++++++++++++----------
 arch/x86/pci/acpi.c     | 81 ++++++++-----------------------------------------
 drivers/acpi/resource.c | 54 ++++++++++++++++++++++++---------
 include/linux/acpi.h    |  3 ++
 4 files changed, 74 insertions(+), 100 deletions(-)

-- 
1.8.2.1

