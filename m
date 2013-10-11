Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3JKMUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:20:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:23105 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3JKMUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:20:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1080,1371106800"; 
   d="scan'208";a="409417785"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org, bhelgaas@google.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Resend PATCH 0/5] ACPI/PCI: Parse PCI root bridge's ACPI resource via ACPI resource functions
Date: Fri, 11 Oct 2013 20:18:56 +0800
Message-Id: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

[Patch 1~2 and 4~5 of previous version weren't sent to maillist. So resend the patchset]

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

