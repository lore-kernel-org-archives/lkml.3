Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3KUAWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:22:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:57746 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3KUAWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:22:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="412103104"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] NTB: Document HW errata
Date: Wed, 20 Nov 2013 17:21:28 -0700
Message-Id: <1384993290-10107-8-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment describing the necessary ordering of modifications to the
NTB Limit and Base registers.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index fa97948..391c377 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -689,6 +689,12 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			 */
 			writeq(ndev->mw[1].bar_sz + 0x1000, ndev->reg_base +
 			       SNB_PBAR4LMT_OFFSET);
+			/* HW errata on the Limit registers.  They can only be
+			 * written when the base register is 4GB aligned and
+			 * < 32bit.  This should already be the case based on the
+			 * driver defaults, but write the Limit registers first
+			 * just in case.
+			 */
 		} else {
 			ndev->limits.max_mw = SNB_MAX_MW;
 
@@ -707,6 +713,12 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			 * something silly
 			 */
 			writeq(0, ndev->reg_base + SNB_PBAR4LMT_OFFSET);
+			/* HW errata on the Limit registers.  They can only be
+			 * written when the base register is 4GB aligned and
+			 * < 32bit.  This should already be the case based on the
+			 * driver defaults, but write the Limit registers first
+			 * just in case.
+			 */
 		}
 
 		/* The Xeon errata workaround requires setting SBAR Base
-- 
1.7.9.5

