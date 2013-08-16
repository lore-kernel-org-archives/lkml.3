Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3HQAau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:30:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3HPWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 002/133] usb: dwc3: gadget: don't prevent gadget from being probed if we fail
Date: Fri, 16 Aug 2013 15:32:24 -0700
Message-Id: <1376692475-28413-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index be13492..1656800 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1535,6 +1535,7 @@ err1:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 
 err0:
+	dwc->gadget_driver = NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;
-- 
1.8.1.2

