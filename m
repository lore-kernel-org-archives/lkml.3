Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206Ab3DIUNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:13:35 -0400
Received: from 8bytes.org ([85.214.48.195]:36417 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036Ab3DIUNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/9] AMD IOMMU cleanups, fixes and IVRS bug workarounds
Date: Tue,  9 Apr 2013 22:12:55 +0200
Message-Id: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:31 2013
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766b23672059926541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set contains some cleanups and patches for the
AMD IOMM driver. The most important part is a workaround
that can be used to get interrupt remapping working even the
the IVRS table provided by the BIOS is broken.


	Joerg

Joerg Roedel (9):
  iommu/amd: Remove map_sg_no_iommu()
  iommu/amd: Use AMD specific data structure for irq remapping
  iommu/amd: Properly initialize irq-table lock
  iommu/amd: Move add_special_device() to __init
  iommu/amd: Extend IVRS special device data structure
  iommu/amd: Add early maps for ioapic and hpet
  iommu/amd: Add ioapic and hpet ivrs override
  iommu/amd: Don't report firmware bugs with cmd-line ivrs overrides
  iommu/amd: Document ivrs_ioapic and ivrs_hpet parameters

 Documentation/kernel-parameters.txt |   14 ++++
 drivers/iommu/amd_iommu.c           |   79 +++++++-----------
 drivers/iommu/amd_iommu_init.c      |  151 +++++++++++++++++++++++++++++++----
 drivers/iommu/amd_iommu_types.h     |    1 +
 4 files changed, 182 insertions(+), 63 deletions(-)

-- 
1.7.9.5


