Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaETVSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:18:35 -0400
Received: from 8bytes.org ([85.214.48.195]:56070 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaETVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:18:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jay.Cornwall@amd.com
Subject: [PATCH 0/5] AMD IOMMUv2 Cleanups and Fixes
Date: Tue, 20 May 2014 23:18:21 +0200
Message-Id: <1400620706-21031-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 20 23:18:30 2014
X-DSPAM-Confidence: 0.9978
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537bc6a620861302596618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a small patch-set with some clean-ups for the AMD IOMMUv2
driver. The most important change is the conversion to use the
mmu_notifier release call-back instead of the task_exit notifier to get
notified when a MM dies. Please review.

Thanks,

	Joerg

Diffstat:

 drivers/iommu/amd_iommu_v2.c |  184 +++++++++++++++++-------------------------

Shortlog:

Joerg Roedel (5):
      iommu/amd: Don't access IOMMUv2 state_table directly
      iommu/amd: Convert IOMMUv2 state_table into state_list
      iommu/amd: Implement mmu_notifier_release call-back
      iommu/amd: Remove IOMMUv2 pasid_state_list
      iommu/amd: Handle parallel invalidate_range_start/end calls correctly

 1 file changed, 74 insertions(+), 110 deletions(-)

