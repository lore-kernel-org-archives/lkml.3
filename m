Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaACTDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:03:03 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45304 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaACTDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:03:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,599,1384300800"; 
   d="scan'208";a="89628673"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>, <boris.ostrovsky@oracle.com>,
        <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <linux-fbdev@vger.kernel.org>
Subject: [PATCH v2] allow xenfb initialization for hvm guests
Date: Fri, 3 Jan 2014 19:02:09 +0000
Message-ID: <1388775730-2984-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
Given that no Xen toolstacks configure a xenfb backend for x86 HVM
guests, they are not affected.

Please note that at this time QEMU needs few outstanding fixes to
provide xenfb on ARM:

http://marc.info/?l=qemu-devel&m=138739419700837&w=2

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: David Vrabel <david.vrabel@citrix.com>
CC: boris.ostrovsky@oracle.com
CC: plagnioj@jcrosoft.com
CC: tomi.valkeinen@ti.com
CC: linux-fbdev@vger.kernel.org
CC: konrad.wilk@oracle.com
---
 drivers/video/xen-fbfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.7.10.4

