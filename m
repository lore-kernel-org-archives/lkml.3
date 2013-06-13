Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab3FMS3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:29:00 -0400
Received: from etezian.org ([198.101.225.253]:56442 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab3FMS26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:58 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 14:28:58 EDT
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 18/19] bh1770glc: Corrected proximity sensor rates
Date: Thu, 13 Jun 2013 20:20:52 +0200
Message-Id: <257954505f9a875db81b40d53b4e3db3a900616c.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

The rate table of the proximity sensor has included
one incorrect value that is not supported by the HW.
This value is now corrected from 25Hz to 20Hz. The
corresponding rate in the time table is corrected to
50ms accordingly.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 526cdb6..ef1ab49 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -177,10 +177,10 @@ static const char reg_vleds[] = "Vleds";
 
 /*
  * Supported stand alone rates in ms from chip data sheet
- * {10, 20, 30, 40, 70, 100, 200, 500, 1000, 2000};
+ * {10, 20, 30, 50, 70, 100, 200, 500, 1000, 2000};
  */
-static const s16 prox_rates_hz[] = {100, 50, 33, 25, 14, 10, 5, 2};
-static const s16 prox_rates_ms[] = {10, 20, 30, 40, 70, 100, 200, 500};
+static const s16 prox_rates_hz[] = {100, 50, 33, 20, 14, 10, 5, 2};
+static const s16 prox_rates_ms[] = {10, 20, 30, 50, 70, 100, 200, 500};
 
 /* Supported IR-led currents in mA */
 static const u8 prox_curr_ma[] = {5, 10, 20, 50, 100, 150, 200};
-- 
1.7.10.4

