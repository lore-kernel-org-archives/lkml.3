Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab3GaNkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:40:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47015 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759791Ab3GaNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felipe Balbi" <balbi@ti.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.713667938@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [39/84] usb: dwc3: gadget: don't prevent gadget from being probed
 if we fail
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit cdcedd6981194e511cc206887db661d016069d68 upstream.

In case we fail our ->udc_start() callback, we
should be ready to accept another modprobe following
the failed one.

We had forgotten to clear dwc->gadget_driver back
to NULL and, because of that, we were preventing
gadget driver modprobe from being retried.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1217,6 +1217,7 @@ err1:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 
 err0:
+	dwc->gadget_driver = NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;

