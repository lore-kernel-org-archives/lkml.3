Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3FDVTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:19:38 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58676 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3FDVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:19:35 -0400
X-Originating-IP: 83.160.107.163
Date: Tue, 4 Jun 2013 23:19:30 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Javier Martinez Canillas <javier@dowhile0.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kevin McNeely <kev@cypress.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cyttsp: Fix swap of mfg_stat and mfg_cmd registers
Message-ID: <20130604211930.GF3618@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kevin McNeely <kev@cypress.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The command and status register in the driver were swapped with
respect to the order specified in the datasheet (CY8CTMA140).
Confirmed with Cypress that the order in the datasheet is correct.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/input/touchscreen/cyttsp_core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/cyttsp_core.h b/drivers/input/touchscreen/cyttsp_core.h
index 1aa3c69..f1ebde3 100644
--- a/drivers/input/touchscreen/cyttsp_core.h
+++ b/drivers/input/touchscreen/cyttsp_core.h
@@ -67,8 +67,8 @@ struct cyttsp_xydata {
 /* TTSP System Information interface definition */
 struct cyttsp_sysinfo_data {
 	u8 hst_mode;
-	u8 mfg_cmd;
 	u8 mfg_stat;
+	u8 mfg_cmd;
 	u8 cid[3];
 	u8 tt_undef1;
 	u8 uid[8];
-- 
1.7.10.4

