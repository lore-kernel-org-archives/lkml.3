Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3LNMTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:19:22 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57451 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3LNMTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:19:21 -0500
Date: Sat, 14 Dec 2013 17:49:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        linux-driver@qlogic.com, netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH v2 3/9] drivers: net: Mark functions as static in
 qlcnic_83xx_hw.c
Message-ID: <96780e5cbd998e41b64872661e7e4072a29912c6.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function qlcnic_83xx_clear_legacy_intr_mask(),
qlcnic_83xx_set_legacy_intr_mask() and
qlcnic_83xx_enable_legacy_msix_mbx_intr() in qlcnic_83xx_hw.c as static
because they are not used outside this file.

Thus, it also removes the following warnings
in ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:

drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:318:13: warning: no previous prototype for ‘qlcnic_83xx_clear_legacy_intr_mask’ [-Wmissing-prototypes]
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:323:13: warning: no previous prototype for ‘qlcnic_83xx_set_legacy_intr_mask’ [-Wmissing-prototypes]
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:343:13: warning: no previous prototype for ‘qlcnic_83xx_enable_legacy_msix_mbx_intr’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index b1cb0ff..d0c2cd4 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -315,12 +315,12 @@ int qlcnic_83xx_setup_intr(struct qlcnic_adapter *adapter)
 	return 0;
 }
 
-inline void qlcnic_83xx_clear_legacy_intr_mask(struct qlcnic_adapter *adapter)
+static inline void qlcnic_83xx_clear_legacy_intr_mask(struct qlcnic_adapter *adapter)
 {
 	writel(0, adapter->tgt_mask_reg);
 }
 
-inline void qlcnic_83xx_set_legacy_intr_mask(struct qlcnic_adapter *adapter)
+static inline void qlcnic_83xx_set_legacy_intr_mask(struct qlcnic_adapter *adapter)
 {
 	if (adapter->tgt_mask_reg)
 		writel(1, adapter->tgt_mask_reg);
@@ -340,7 +340,7 @@ void qlcnic_83xx_disable_intr(struct qlcnic_adapter *adapter,
 	writel(1, sds_ring->crb_intr_mask);
 }
 
-inline void qlcnic_83xx_enable_legacy_msix_mbx_intr(struct qlcnic_adapter
+static inline void qlcnic_83xx_enable_legacy_msix_mbx_intr(struct qlcnic_adapter
 						    *adapter)
 {
 	u32 mask;
-- 
1.7.9.5

