Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3EVNUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:20:46 -0400
Received: from sauhun.de ([89.238.76.85]:55348 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3EVNTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:19:54 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 2/3] drivers/usb/host: remove leftover release_mem_region
Date: Wed, 22 May 2013 15:21:25 +0200
Message-Id: <1369228886-3527-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369228886-3527-1-git-send-email-wsa@the-dreams.de>
References: <1369228886-3527-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting this driver to devm_ioremap_resource, the removal of this now
unneeded function has been forgotten.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/usb/host/ohci-nxp.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index f303cb0..f1db7eb 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -351,7 +351,6 @@ static int usb_hcd_nxp_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 	nxp_stop_hc();
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	clk_disable(usb_pll_clk);
 	clk_put(usb_pll_clk);
-- 
1.7.10.4

