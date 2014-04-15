Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaDOByO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:54:14 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:56235 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaDOByM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:54:12 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <kas@fi.muni.cz>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] driver/net: cosa driver uses udelay incorrectly
Date: Tue, 15 Apr 2014 09:53:11 +0800
Message-Id: <1397526791-4015-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>

In cosa driver, udelay with more than 20000 may cause __bad_udelay.
Use msleep for instead.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/net/wan/cosa.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 84734a8..83c39e2 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -1521,11 +1521,7 @@ static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 	cosa_putstatus(cosa, 0);
 	cosa_getdata8(cosa);
 	cosa_putstatus(cosa, SR_RST);
-#ifdef MODULE
 	msleep(500);
-#else
-	udelay(5*100000);
-#endif
 	/* Disable all IRQs from the card */
 	cosa_putstatus(cosa, 0);
 
-- 
1.7.10.4

