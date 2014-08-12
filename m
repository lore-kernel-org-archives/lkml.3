Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaHLJGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:06:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:23534 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaHLJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:06:41 -0400
X-IronPort-AV: E=Sophos;i="5.01,847,1400025600"; 
   d="scan'208";a="161525432"
Date: Tue, 12 Aug 2014 10:05:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Dave Scott <Dave.Scott@eu.citrix.com>, <linux-kernel@vger.kernel.org>,
        <jslaby@suse.cz>, <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>
Subject: [PATCH RESEND] xen_hvc: no reason to write the type key on
 xenstore
Message-ID: <alpine.DEB.2.02.1408121003570.2293@kaball.uk.xensource.com>
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
