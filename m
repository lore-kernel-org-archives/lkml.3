Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbbAWHX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:23:57 -0500
Received: from www.osadl.org ([62.245.132.105]:50579 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbAWHXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:23:55 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Surya Seetharaman <surya.seetharaman9@gmail.com>,
        Keerthimai Janarthanan <keerthimaipb@gmail.com>,
        Tina Johnson <tinajohnson.1234@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Fabio Falzoi <fabio.falzoi84@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2] staging: rts5208: use msecs_to_jiffies for timeouts
Date: Fri, 23 Jan 2015 08:15:53 +0100
Message-Id: <1421997353-12781-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only an API consolidation and should make things more readable

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

v2: typo in patch subject fixed - no change in actual patch

Converting milliseconds to jiffies by val * HZ / 1000 is technically
not wrong but msecs_to_jiffies(val) is the cleaner solution and handles
corner cases correctly.

This patch was only compile tested with x86_64_defconfig + CONFIG_STAGING=y, 
CONFIG_RTS5208=m

Patch is against 3.19.0-rc5 -next-20150122

 drivers/staging/rts5208/rtsx_transport.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_transport.c b/drivers/staging/rts5208/rtsx_transport.c
index 756a968..dab1995 100644
--- a/drivers/staging/rts5208/rtsx_transport.c
+++ b/drivers/staging/rts5208/rtsx_transport.c
@@ -271,7 +271,7 @@ int rtsx_send_cmd(struct rtsx_chip *chip, u8 card, int timeout)
 
 	/* Wait for TRANS_OK_INT */
 	timeleft = wait_for_completion_interruptible_timeout(
-		&trans_done, timeout * HZ / 1000);
+		&trans_done, msecs_to_jiffies(timeout));
 	if (timeleft <= 0) {
 		dev_dbg(rtsx_dev(chip), "chip->int_reg = 0x%x\n",
 			chip->int_reg);
@@ -431,7 +431,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	spin_unlock_irq(&rtsx->reg_lock);
 
 	timeleft = wait_for_completion_interruptible_timeout(
-		&trans_done, timeout * HZ / 1000);
+		&trans_done, msecs_to_jiffies(timeout));
 	if (timeleft <= 0) {
 		dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
 			__func__, __LINE__);
@@ -455,7 +455,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 		init_completion(&trans_done);
 		spin_unlock_irq(&rtsx->reg_lock);
 		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
+			&trans_done, msecs_to_jiffies(timeout));
 		if (timeleft <= 0) {
 			dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
 				__func__, __LINE__);
@@ -575,7 +575,7 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 		spin_unlock_irq(&rtsx->reg_lock);
 
 		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
+			&trans_done, msecs_to_jiffies(timeout));
 		if (timeleft <= 0) {
 			dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
 				__func__, __LINE__);
@@ -602,7 +602,7 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 		init_completion(&trans_done);
 		spin_unlock_irq(&rtsx->reg_lock);
 		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
+			&trans_done, msecs_to_jiffies(timeout));
 		if (timeleft <= 0) {
 			dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
 				__func__, __LINE__);
@@ -688,7 +688,7 @@ static int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf,
 
 	/* Wait for TRANS_OK_INT */
 	timeleft = wait_for_completion_interruptible_timeout(
-		&trans_done, timeout * HZ / 1000);
+		&trans_done, msecs_to_jiffies(timeout));
 	if (timeleft <= 0) {
 		dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
 			__func__, __LINE__);
-- 
1.7.10.4

