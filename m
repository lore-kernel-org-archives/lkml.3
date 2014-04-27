Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaD0RL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:11:27 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:22044 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbaD0RLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:11:23 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH 1/2] staging/rtl8192e: Erroneous return codes (types and values)
Date: Sun, 27 Apr 2014 19:11:15 +0200
Message-Id: <1398618676-31095-1-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function returns a bool, that is supposed to be false when something
goes wrong. It's assumed this way by its lone calling function (which is
SetRFPowerState8190(), line 1445 of rtl8192e/rtl8192e/r8192E_phy.c)

Despite of this, this procedure returns non-null enumerations values or
negative codes instead. This patch fixes this.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
I submit this patch as a result for Task #16 of the Eudyptula Challenge.

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index c01abc2..a6f2b2b 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -3030,7 +3030,7 @@ bool NicIFEnableNIC(struct net_device *dev)
 		RT_TRACE(COMP_ERR, "ERR!!! %s(): Driver is already down!\n",
 			 __func__);
 		priv->bdisable_nic = false;
-		return RT_STATUS_FAILURE;
+		return false;
 	}
 
 	RT_TRACE(COMP_PS, "===========>%s()\n", __func__);
@@ -3040,7 +3040,7 @@ bool NicIFEnableNIC(struct net_device *dev)
 		RT_TRACE(COMP_ERR, "ERR!!! %s(): initialization is failed!\n",
 			 __func__);
 		priv->bdisable_nic = false;
-		return -1;
+		return false;
 	}
 	RT_TRACE(COMP_INIT, "start adapter finished\n");
 	RT_CLEAR_PS_LEVEL(pPSC, RT_RF_OFF_LEVL_HALT_NIC);
