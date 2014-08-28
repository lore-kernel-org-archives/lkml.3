Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaH1UxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:53:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:42375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbaH1Uw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593491"
Subject: [PATCH 0/6] NTB bug fixes and hardware workarounds
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:52:57 -0700
Message-ID: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series contains various fixes and cleanup for NTB. It also
adds the split BAR support on Haswell platform and a hardware errata
workaround in order to allow interrupts to function during bi-directional
traffic under stress. 

---

Dave Jiang (6):
      ntb: Add alignment check to meet hardware requirement
      ntb: move platform detection to separate function
      ntb: conslidate reading of PPD to move platform detection earlier
      ntb: use errata flag set via DID to implement workaround
      ntb: Adding split BAR support for Haswell platforms
      ntb: workaround for high traffic hardware hang


 drivers/ntb/ntb_hw.c        |  603 +++++++++++++++++++++++++++++++++++--------
 drivers/ntb/ntb_hw.h        |   27 ++
 drivers/ntb/ntb_regs.h      |   32 ++
 drivers/ntb/ntb_transport.c |  139 ++++++----
 4 files changed, 620 insertions(+), 181 deletions(-)
