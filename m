Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3IKF0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:26:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3IKF0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:26:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=SqyXAaTVKZ0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4zM_Y1h-aoAA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=2nGFSOxoDzZR1yMmh2EA:9 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042907.257669497@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>
Subject: [090/251] usb: dwc3: gadget: dont prevent gadget from being probed if we fail
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0090-usb-dwc3-gadget-don-t-prevent-gadget-from-being-prob.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

[ Upstream commit cdcedd6981194e511cc206887db661d016069d68 ]

In case we fail our ->udc_start() callback, we
should be ready to accept another modprobe following
the failed one.

We had forgotten to clear dwc->gadget_driver back
to NULL and, because of that, we were preventing
gadget driver modprobe from being retried.

Cc: <stable@vger.kernel.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8212dbb..234305a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1558,6 +1558,7 @@ err1:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 
 err0:
+	dwc->gadget_driver = NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;
-- 
1.7.10.4


