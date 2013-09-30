Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3I3KgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:36:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3I3KL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 020/104] usb: ehci-mxc: check for pdata before dereferencing
Date: Mon, 30 Sep 2013 11:09:57 +0100
Message-Id: <1380535881-9239-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-mxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index c778ffe..7bce025 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -291,7 +291,7 @@ static int __exit ehci_mxc_drv_remove(struct platform_device *pdev)
 	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
-	if (pdata->otg)
+	if (pdata && pdata->otg)
 		usb_phy_shutdown(pdata->otg);
 
 	usb_remove_hcd(hcd);
-- 
1.8.3.2

