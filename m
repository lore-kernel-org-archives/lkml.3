Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaLUSsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:48:40 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46797 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaLUSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:47:31 -0500
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
Subject: [PATCH net-next 10/11] net: cpts: convert to timecounter adjtime.
Date: Sun, 21 Dec 2014 19:47:05 +0100
Message-Id: <90dc7fc7d7550d5164474ca9995628f50989dbb2.1418504889.git.richardcochran@gmail.com>
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
 drivers/net/ethernet/ti/cpts.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 4a4388b..fbe42cb 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -157,14 +157,11 @@ static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 static int cpts_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	s64 now;
 	unsigned long flags;
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
 
 	spin_lock_irqsave(&cpts->lock, flags);
-	now = timecounter_read(&cpts->tc);
-	now += delta;
-	timecounter_init(&cpts->tc, &cpts->cc, now);
+	timecounter_adjtime(&cpts->tc, delta);
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	return 0;
-- 
1.7.10.4

