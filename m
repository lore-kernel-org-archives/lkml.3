Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab3EFVMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:12:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3EFUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Braun <michael-dev@fami-braun.de>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 029/115] usb: remove redundant tdi_reset
Date: Mon,  6 May 2013 13:44:25 -0700
Message-Id: <20130506203058.550819534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhou Liu <Shengzhou.Liu@freescale.com>

commit 61ac6ac8d662ac7ac67c864954d39d1b19948354 upstream.

We remove the redundant tdi_reset in ehci_setup since there
is already it in ehci_reset.
It was observed that the duplicated tdi_reset was causing
the PHY_CLK_VALID bit unstable.

Reported-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -670,9 +670,6 @@ int ehci_setup(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
-	if (ehci_is_TDI(ehci))
-		tdi_reset(ehci);
-
 	ehci_reset(ehci);
 
 	return 0;


