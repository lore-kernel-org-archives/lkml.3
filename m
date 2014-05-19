Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaESEfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:35:08 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17570 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbaESEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:53 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474219"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Henk de Groot <pe1dnn@amsat.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/13] staging: wlags49_h2: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:09 +0200
Message-Id: <1400473875-22228-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I'm not sure to understand this code.  There seem to be two cases where
ret was undefined at the point of the return (on failure of the case 0
test and in the default case).

 drivers/staging/wlags49_h2/wl_wext.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 49eeeae..3aeff81 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -159,15 +159,12 @@ static int hermes_set_tkip_keys(ltv_t *ltv, u16 key_idx, u8 *addr,
 /* Set up the LTV to clear the appropriate key */
 static int hermes_clear_tkip_keys(ltv_t *ltv, u16 key_idx, u8 *addr)
 {
-	int ret;
-
 	switch (key_idx) {
 	case 0:
 		if (!is_broadcast_ether_addr(addr)) {
 			ltv->len = 7;
 			ltv->typ = CFG_REMOVE_TKIP_MAPPED_KEY;
 			memcpy(&ltv->u.u8[0], addr, ETH_ALEN);
-			ret = 0;
 		}
 		break;
 	case 1:
@@ -178,13 +175,12 @@ static int hermes_clear_tkip_keys(ltv_t *ltv, u16 key_idx, u8 *addr)
 		ltv->typ = CFG_REMOVE_TKIP_DEFAULT_KEY;
 		ltv->u.u16[0] = cpu_to_le16(key_idx);
 
-		ret = 0;
 		break;
 	default:
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* Set the WEP keys in the wl_private structure */
@@ -3027,13 +3023,10 @@ static int wireless_set_genie(struct net_device *dev,
 			      struct iw_point *data, char *extra)
 
 {
-	int   ret = 0;
-
 	/* We can't write this to the card, but apparently this
 	 * operation needs to succeed */
-	ret = 0;
 
-	return ret;
+	return 0;
 }
 /*============================================================================*/
 

