Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3IYAm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:42:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3IYAUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 040/117] usb: ehci-mxc: check for pdata before dereferencing
Date: Tue, 24 Sep 2013 17:18:26 -0700
Message-Id: <20130925001745.203913181@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -184,7 +184,7 @@ static int ehci_mxc_drv_remove(struct pl
 	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
-	if (pdata->otg)
+	if (pdata && pdata->otg)
 		usb_phy_shutdown(pdata->otg);
 
 	clk_disable_unprepare(priv->usbclk);


