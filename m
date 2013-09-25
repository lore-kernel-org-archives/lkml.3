Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3IYBda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:33:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3IYAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 12/40] usb: ehci-mxc: check for pdata before dereferencing
Date: Tue, 24 Sep 2013 17:11:44 -0700
Message-Id: <20130925001043.285548685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit f375fc520d4df0cd9fcb570f33c103c6c0311f9e upstream.

Commit 7e8d5cd93fac ("USB: Add EHCI support for MX27 and MX31 based
boards") introduced code that could potentially lead to a NULL pointer
dereference on driver removal.

Fix this by checking for the value of pdata before dereferencing it.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-mxc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -298,7 +298,7 @@ static int __exit ehci_mxc_drv_remove(st
 	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
-	if (pdata->otg)
+	if (pdata && pdata->otg)
 		usb_phy_shutdown(pdata->otg);
 
 	usb_remove_hcd(hcd);


