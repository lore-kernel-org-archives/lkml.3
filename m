Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3JUIu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39381 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376Ab3JUIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Daniel Mack" <zonque@gmail.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.51749310@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 033/149] usb: ehci-mxc: check for pdata before
 dereferencing
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-mxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -296,7 +296,7 @@ static int __exit ehci_mxc_drv_remove(st
 	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
-	if (pdata->otg)
+	if (pdata && pdata->otg)
 		otg_shutdown(pdata->otg);
 
 	usb_remove_hcd(hcd);

