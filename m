Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaBUPrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaBUPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:47:36 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jon Mason <jon.mason@intel.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 0/4] ntb: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Fri, 21 Feb 2014 16:49:28 +0100
Message-Id: <cover.1392996332.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

This is an attempt to make ntb_setup_msix() more readable ( to me :) )

The idea is to get rid of confusing branching between SNB and BWD
and split MSI-X ininialization into ntb_setup_bwd_msix() and
ntb_setup_snb_msix() - both small and straight.

Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (4):
  ntb: Fix leakage of ntb_device::msix_entries[] array
  ntb: Use pci_msix_vec_count() to obtain number of MSI-Xs
  ntb: Split ntb_setup_msix() into separate BWD/SNB routines
  ntb: Use pci_enable_msix_range() instead of pci_enable_msix()

 drivers/ntb/ntb_hw.c |  174 +++++++++++++++++++++++++++++---------------------
 drivers/ntb/ntb_hw.h |    2 -
 2 files changed, 100 insertions(+), 76 deletions(-)

-- 
1.7.7.6

