Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3LQRxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:53:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:45910 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3LQRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:53:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,502,1384300800"; 
   d="scan'208";a="83165815"
Date: Tue, 17 Dec 2013 17:53:13 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] allow xenfb initialization for hvm guests
Message-ID: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
Given that no Xen toolstacks configure a xenfb backend for x86 HVM
guests, they are not affected.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index cd005c2..02e1c01 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -692,7 +692,7 @@ static DEFINE_XENBUS_DRIVER(xenfb, ,
 
 static int __init xenfb_init(void)
 {
-	if (!xen_pv_domain())
+	if (!xen_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
