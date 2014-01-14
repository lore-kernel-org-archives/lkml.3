Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaANDNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:13:24 -0500
Received: from nm24.bullet.mail.gq1.yahoo.com ([98.136.217.7]:30327 "EHLO
	nm24.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbaANDNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:13:22 -0500
X-Yahoo-Newman-Id: 717869.35757.bm@smtp234.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: BdHBwJIVM1kXAfCx0TmD1n.19e_NbXHjCzJvlglhgYsB9H.
 109._qMoi1NZ9o.hyWJ9_ZT1gzwEwKp_2iEuBkBeGNMQa4BCJwgkf0LIQVbb
 R1wg9Pe_BSzgbTPjqRGtjZNRrwiswUH9dfIyJJTH0gPpiTuZSUXHuFP2iE8z
 Ri.9i3KIY8qJqazCBoVVVyjBGuxK8w_H7BKyCccMGlDKSIJs927s6vzkCRlq
 JwyZADABPZw8Vvkwcy3hgUxNYdClUvcuIKmq2IjifYqsuZ3LmsSba84uliK5
 GSmqMilcDNI4ZxBOb1jooCpDZapBI3ABm9_fHOy9nBeFR.oSDl.CHRi.OClg
 MJCpgsguF.MMgRKHLoYRNYCmclwuKo_v7Yg6Q8LPVpEotfPHVNpiFabdu0YV
 b6mDzUFJIJkMSFG2HaJ0oFcIgyU0H5d24_GhcJxkZhNb9nrP8rOhNJUYmMGe
 iEakoIQCLJHxV4MyVntltXNAbr0Df7ezBDeGPD2zcW7Y2Gaq3SgPIVmO0MFo
 Mwl5V771MRfks_6dRcCwb_h3FXJPltKv69YhFFqvwITi94nqC_PdHyQCilQX
 i0pmdm0tpljkFl2Vk8ACgLqzdvuC9uI8N4p_mC8bXJ9Ay.MVd
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.138.105.21])
        by smtp234.mail.gq1.yahoo.com with SMTP; 14 Jan 2014 03:13:21 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: remove unnecessary braces in pcl711.c
Date: Mon, 13 Jan 2014 21:13:16 -0600
Message-Id: <1389669196-15041-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for pcl711.c removes braces causing a checkpatch.pl warning.
It also removes an empty else arm of an if-else statement.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

I removed the "else" arm of this statement because it was empty, save for the "ignore" comment.  If it is instead preferred kernel style for this empty else to remain in, let me know and I will correct this patch accordingly.

 drivers/staging/comedi/drivers/pcl711.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index f0fc123..6595788 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -336,11 +336,8 @@ static int pcl711_ai_cmdtest(struct comedi_device *dev,
 	err |= cfc_check_trigger_arg_is(&cmd->convert_arg, 0);
 	err |= cfc_check_trigger_arg_is(&cmd->scan_end_arg, cmd->chanlist_len);
 
-	if (cmd->stop_src == TRIG_NONE) {
+	if (cmd->stop_src == TRIG_NONE)
 		err |= cfc_check_trigger_arg_is(&cmd->stop_arg, 0);
-	} else {
-		/* ignore */
-	}
 
 	if (err)
 		return 3;
-- 
1.8.4.2

