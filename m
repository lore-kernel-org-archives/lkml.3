Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaESEc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:32:59 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17570 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaESEcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:55 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474224"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Brett Rudley <brudley@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] brcmsmac: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:14 +0200
Message-Id: <1400473875-22228-13-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9417cb5..3054725 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4875,9 +4875,6 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 	uint i;
 	struct brcms_hw_band *band;
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	int callbacks;
-
-	callbacks = 0;
 
 	brcms_b_detach_dmapio(wlc_hw);
 
@@ -4901,7 +4898,7 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 		wlc_hw->sih = NULL;
 	}
 
-	return callbacks;
+	return 0;
 
 }
 

