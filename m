Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3G3Jdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53250 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3G3Jd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/106] usb: dwc3: gadget: don't prevent gadget from being probed if we fail
Date: Tue, 30 Jul 2013 10:31:28 +0100
Message-Id: <1375176725-5825-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3530c2b..5a7755b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1445,6 +1445,7 @@ err1:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 
 err0:
+	dwc->gadget_driver = NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;
-- 
1.8.3.2

