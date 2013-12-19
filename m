Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3LSIsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:48:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55803 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3LSIso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:48:44 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        linux-driver@qlogic.com, netdev@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v3=202/8=5D=20drivers=3A=20net=3A=20Mark=20functions=20as=20static=20in=20qlcnic=5F83xx=5Fhw=2Ec?=
Date: Thu, 19 Dec 2013 14:18:11 +0530
Message-Id: <e50a81d6fd512838c98cd46a0ce66262da5cf811.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

