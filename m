Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaHKLzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:55:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3850 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHKLzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:55:22 -0400
X-IronPort-AV: E=Sophos;i="5.01,841,1400025600"; 
   d="scan'208";a="160543251"
Date: Mon, 11 Aug 2014 12:54:03 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Dave Scott <Dave.Scott@eu.citrix.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen_hvc: no reason to write the type key on xenstore
Message-ID: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backend type is chosen by the toolstack. Regardless, the frontend
should not care, especially given that it cannot have an effect as the
backend is started before this code is run.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 636c9ba..b8491f5 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -402,9 +402,6 @@ static int xencons_connect_backend(struct xenbus_device *dev,
			    evtchn);
	if (ret)
		goto error_xenbus;
-	ret = xenbus_printf(xbt, dev->nodename, "type", "ioemu");
-	if (ret)
-		goto error_xenbus;
	ret = xenbus_transaction_end(xbt, 0);
	if (ret) {
		if (ret == -EAGAIN)
