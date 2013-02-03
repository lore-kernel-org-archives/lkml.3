Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3BCO4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34366 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab3BCO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:37 -0500
Message-Id: <20130203144649.993812410@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Pratyush Anand <pratyush.anand@st.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 067/128] usb: dwc3: gadget: fix ep->maxburst for ep0
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit 6048e4c69d80600baba35856651056860d5d8f5a upstream.

dwc3_gadget_set_ep_config expects maxburst as incremented by 1. So, by
default initialize ep->maxburst to 1 for ep0.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2e43b33..2fdd767 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1605,6 +1605,7 @@ static int dwc3_gadget_init_endpoints(struct dwc3 *dwc)
 
 		if (epnum == 0 || epnum == 1) {
 			dep->endpoint.maxpacket = 512;
+			dep->endpoint.maxburst = 1;
 			dep->endpoint.ops = &dwc3_gadget_ep0_ops;
 			if (!epnum)
 				dwc->gadget.ep0 = &dep->endpoint;


