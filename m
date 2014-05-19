Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaESVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:09:29 -0400
Received: from mout.gmx.net ([212.227.17.22]:54311 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaESVJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:09:28 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] lpfc: Use time_after()
Date: Mon, 19 May 2014 23:09:22 +0200
Message-Id: <1400533762-10338-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:dVFwFdsNqaS/n56dIX+L160/HZKdrNwp2DY4YIxECU+VV7/1F8+
 JH7rh6Neyn2lOFxslTc9rTSTYvHbe/T7Z5S93n6Ibeb3dJHCdMemqmTlDVqTkTFEkS0F57h
 7um8nS0LDX6a7a47WFMf///xEicqT8z96XI+8tuejCusp0Br/gW9sZhLeOFNOhWuXk07hCz
 qxyOt9kXS0ljAFtcGvQzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_after() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 462453e..fb5351a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -380,12 +380,14 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 {
 	unsigned long flags;
 	uint32_t evt_posted;
+	unsigned long expires;
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	atomic_inc(&phba->num_rsrc_err);
 	phba->last_rsrc_error_time = jiffies;
 
-	if ((phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL) > jiffies) {
+	expires = phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL;
+	if (time_after(expires, jiffies)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
-- 
1.7.10.4

