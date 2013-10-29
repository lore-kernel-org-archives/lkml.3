Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3J2RyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:54:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:53415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604Ab3J2RyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:54:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400545348"
From: David Cohen <david.a.cohen@linux.intel.com>
To: cjb@laptop.org, adrian.hunter@intel.com, gregkh@linuxfoundation.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuanxiao.dong@intel.com, David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 0/2] mmc: sdhci: Workaround Intel Merrifield issue for HS200
Date: Tue, 29 Oct 2013 10:58:25 -0700
Message-Id: <1383069507-27574-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

SDHCI used to work well on Intel Merrifield until this patch was applied:

commit 156e14b126ffb6f040bc6f1aff3c51077e42a744
Author: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Date:   Wed Jun 12 08:16:38 2013 +0200

    mmc: sdhci: fix caps2 for HS200
    
    Although the HC supports HS200 (eMMC) the caps2 are always zero; this
    means there's no way to use the super speed mode (when init the card).
    
    If the HC support SDR104, for SD3.0, so it also supports HS200 for eMMC
    and this patch just sets the MMC_CAP2_HS200 in the host caps2 field.

Looks like there is a hw issue with unknown root cause so far.

Is it acceptable to have the quirk I'm proposing to workaround the issue?

Br, David Cohen

---
David Cohen (2):
  mmc: sdhci: add quirk for broken HS200 support
  mmc: sdhci-pci: add broken HS200 quirk for Intel Merrifield

 drivers/mmc/host/sdhci-pci.c | 1 +
 drivers/mmc/host/sdhci.c     | 3 ++-
 include/linux/mmc/sdhci.h    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

-- 
1.8.4.rc3

