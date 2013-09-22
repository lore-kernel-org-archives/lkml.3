Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3IVSpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:45:23 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:39747 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3IVSpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:45:01 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: nsankar@broadcom.com
Cc: jarod@wilsonet.com, davilla@4pi.com, abraham.manu@gmail.com,
        gregkh@linuxfoundation.org, amarjargal16@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 5/5] Staging: crystalhd: Fix assignment of 0/1 to bool variables
Date: Sun, 22 Sep 2013 20:44:13 +0200
Message-Id: <1379875453-20083-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 0 to false and 1 to true when assigning values to bool
variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@@
bool b;
@@
(
-b = 0
+b = false
|
-b = 1
+b = true
)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/crystalhd/crystalhd_hw.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -u -p a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -1517,7 +1517,7 @@ static void crystalhd_rx_isr(struct crys
 	uint32_t i, list_avail = 0;
 	enum BC_STATUS comp_sts = BC_STS_NO_DATA;
 	uint32_t y_err_sts, uv_err_sts, y_dn_sz = 0, uv_dn_sz = 0;
-	bool ret = 0;
+	bool ret = false;
 
 	if (!hw) {
 		BCMLOG_ERR("Invalid Arguments\n");
@@ -1852,7 +1852,7 @@ bool crystalhd_hw_interrupt(struct cryst
 {
 	uint32_t intr_sts = 0;
 	uint32_t deco_intr = 0;
-	bool rc = 0;
+	bool rc = false;
 
 	if (!adp || !hw->dev_started)
 		return rc;
@@ -1865,7 +1865,7 @@ bool crystalhd_hw_interrupt(struct cryst
 
 	if (intr_sts) {
 		/* let system know we processed interrupt..*/
-		rc = 1;
+		rc = true;
 		hw->stats.dev_interrupts++;
 	}
 
@@ -1886,7 +1886,7 @@ bool crystalhd_hw_interrupt(struct cryst
 		/* FIXME: jarod: No udelay? might this be
 		 the real reason mini pci-e cards were stalling out? */
 		bc_dec_reg_wr(adp, Stream2Host_Intr_Sts, 0);
-		rc = 1;
+		rc = true;
 	}
 
 	/* Rx interrupts */

