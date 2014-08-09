Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaHIFjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:39:15 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47755 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaHIFjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:39:11 -0400
Date: Sat, 9 Aug 2014 14:37:39 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: dgap: cleanup duplicated warning message on
 dgap_tty_init()
Message-ID: <20140809053739.GA14650@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If true_count is not same with brd->nasync, warning messages are
printed. But it has duplicated messages within if statement.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index b1253c0..51f9ebc 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1374,19 +1374,14 @@ static int dgap_tty_init(struct board_t *brd)
 		brd->nasync = brd->maxports;
 
 	if (true_count != brd->nasync) {
-		if ((brd->type == PPCM) && (true_count == 64)) {
-			pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
-				brd->name, brd->nasync, true_count);
-			pr_warn("dgap: Please make SURE the EBI cable running from the card\n");
-			pr_warn("dgap: to each EM module is plugged into EBI IN!\n");
-		} else if ((brd->type == PPCM) && (true_count == 0)) {
-			pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
-				brd->name, brd->nasync, true_count);
+		pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
+			brd->name, brd->nasync, true_count);
+
+		if ((brd->type == PPCM) &&
+		    (true_count == 64 || true_count == 0)) {
 			pr_warn("dgap: Please make SURE the EBI cable running from the card\n");
 			pr_warn("dgap: to each EM module is plugged into EBI IN!\n");
-		} else
-			pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
-				brd->name, brd->nasync, true_count);
+		}
 
 		brd->nasync = true_count;
 
-- 
1.7.1

