Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab3E3OoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:44:20 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:27366 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab3E3OoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:44:12 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v2 0/3] PCI/ACPI: Fix firmware first error recovery with root port in reset
Date: Thu, 30 May 2013 08:39:26 -0600
Message-Id: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes a bug on platforms that use firmware first AER.
Firmware can leave the root port in Secondary Bus Reset (SBR) and
communicate this to the OS through the "reset" bit in the flags field
of the HEST table and associated CPER records. Firmware wants to do this
so that the error is contained and the hardware is in a known state.

Without these patches, the root port stays in SBR and the device drivers
cannot recover. These patches recognize when the firmware first root port
is in SBR and bring the root port out of SBR so the devices under the root
port can recover.

The changes have been tested on systems with firmware first that set the
"reset" bit by injecting various hardware errors. The errors successfully
recover.

Changes since v1:
Fixed a typo in the comment of patch 2.
Removed incorrect setting of reset bit in patch 3.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---
Betty Dall (3):
  PCI/AER: Fix incorrect return from aer_hest_parse()
  ACPI/APEI: Force fatal AER severity when bus has been reset
  PCI/AER: Provide reset_link for firmware first root port
---
 drivers/acpi/apei/ghes.c           |   21 ++++++++++++++++++++-
 drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
 drivers/pci/pcie/aer/aerdrv_core.c |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletions(-)
