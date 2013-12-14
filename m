Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3LNMR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:17:29 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59263 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3LNMR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:17:27 -0500
Date: Sat, 14 Dec 2013 17:47:13 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        linux-driver@qlogic.com, netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH v2 2/9] drivers: net: Mark functions as static in qlcnic_io.c
Message-ID: <e03d2664d5490bf7af673fc66b83a9684c8758ed.1386911123.git.rashika.kheria@gmail.com>
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

This patch marks the function qlcnic_enable_tx_intr(),
qlcnic_83xx_enable_tx_intr() and qlcnic_83xx_disable_tx_intr() in
qlcnic_io.c as static because they are not used outside this file.

Thus, it also removes the following warnings in
ethernet/qlogic/qlcnic/qlcnic_io.c:

drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:130:13: warning: no previous prototype for ‘qlcnic_enable_tx_intr’ [-Wmissing-prototypes]
drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:147:13: warning: no previous prototype for ‘qlcnic_83xx_enable_tx_intr’ [-Wmissing-prototypes]
drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:153:13: warning: no previous prototype for ‘qlcnic_83xx_disable_tx_intr’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 0149c94..ac7ffc5 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -127,7 +127,7 @@
 struct sk_buff *qlcnic_process_rxbuf(struct qlcnic_adapter *,
 				     struct qlcnic_host_rds_ring *, u16, u16);
 
-inline void qlcnic_enable_tx_intr(struct qlcnic_adapter *adapter,
+static inline void qlcnic_enable_tx_intr(struct qlcnic_adapter *adapter,
 				  struct qlcnic_host_tx_ring *tx_ring)
 {
 	if (qlcnic_check_multi_tx(adapter) &&
@@ -144,13 +144,13 @@ static inline void qlcnic_disable_tx_int(struct qlcnic_adapter *adapter,
 		writel(1, tx_ring->crb_intr_mask);
 }
 
-inline void qlcnic_83xx_enable_tx_intr(struct qlcnic_adapter *adapter,
+static inline void qlcnic_83xx_enable_tx_intr(struct qlcnic_adapter *adapter,
 				       struct qlcnic_host_tx_ring *tx_ring)
 {
 	writel(0, tx_ring->crb_intr_mask);
 }
 
-inline void qlcnic_83xx_disable_tx_intr(struct qlcnic_adapter *adapter,
+static inline void qlcnic_83xx_disable_tx_intr(struct qlcnic_adapter *adapter,
 					struct qlcnic_host_tx_ring *tx_ring)
 {
 	writel(1, tx_ring->crb_intr_mask);
-- 
1.7.9.5

