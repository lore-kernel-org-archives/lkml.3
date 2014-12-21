Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaLUSuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:50:15 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56786 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLUSrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:47:25 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Amir Vadai <amirv@mellanox.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        David Miller <davem@davemloft.net>, Frank Li <Frank.Li@freescale.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Matthew Vick <matthew.vick@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH net-next 07/11] net: igb: convert to timecounter adjtime.
Date: Sun, 21 Dec 2014 19:47:02 +0100
Message-Id: <bb15b44a539ec6da39812229b5fb0718bd6859f0.1418504889.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1418504883.git.richardcochran@gmail.com>
References: <cover.1418504883.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver to use the new and improved method
for adjusting the offset of a timecounter.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 794c139..1d27f2d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -256,14 +256,9 @@ static int igb_ptp_adjtime_82576(struct ptp_clock_info *ptp, s64 delta)
 	struct igb_adapter *igb = container_of(ptp, struct igb_adapter,
 					       ptp_caps);
 	unsigned long flags;
-	s64 now;
 
 	spin_lock_irqsave(&igb->tmreg_lock, flags);
-
-	now = timecounter_read(&igb->tc);
-	now += delta;
-	timecounter_init(&igb->tc, &igb->cc, now);
-
+	timecounter_adjtime(&igb->tc, delta);
 	spin_unlock_irqrestore(&igb->tmreg_lock, flags);
 
 	return 0;
-- 
1.7.10.4

