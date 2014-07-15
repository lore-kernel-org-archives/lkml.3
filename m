Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaGORCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56153 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaGORCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:05 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Julia Lawall <Julia.Lawall@lip6.fr>, Tero Kristo <t-kristo@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 03/94] clk: ti: dra7: return error code in failure case
Date: Tue, 15 Jul 2014 20:00:18 +0300
Message-Id: <1405443709-15288-3-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add a returned error code in the MAX_APLL_WAIT_TRIES case.  Remove the
updating of the return variable r to 0 if MAX_APLL_WAIT_TRIES is not yet
reached, because r is already 0 at this point.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/ti/apll.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
index 18dbaf12..72d9727 100644
--- a/drivers/clk/ti/apll.c
+++ b/drivers/clk/ti/apll.c
@@ -77,13 +77,11 @@ static int dra7_apll_enable(struct clk_hw *hw)
 	if (i == MAX_APLL_WAIT_TRIES) {
 		pr_warn("clock: %s failed transition to '%s'\n",
 			clk_name, (state) ? "locked" : "bypassed");
-	} else {
+		r = -EBUSY;
+	} else
 		pr_debug("clock: %s transition to '%s' in %d loops\n",
 			 clk_name, (state) ? "locked" : "bypassed", i);
 
-		r = 0;
-	}
-
 	return r;
 }
 
-- 
1.7.10.4

