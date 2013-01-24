Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3AXVQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:16:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:40272 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab3AXVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 28/46] usb: dwc3: gadget: fix ep->maxburst for ep0
Date: Thu, 24 Jan 2013 13:13:06 -0800
Message-Id: <20130124211146.446746393@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit 6048e4c69d80600baba35856651056860d5d8f5a upstream.

dwc3_gadget_set_ep_config expects maxburst as incremented by 1. So, by
default initialize ep->maxburst to 1 for ep0.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1605,6 +1605,7 @@ static int __devinit dwc3_gadget_init_en
 
 		if (epnum == 0 || epnum == 1) {
 			dep->endpoint.maxpacket = 512;
+			dep->endpoint.maxburst = 1;
 			dep->endpoint.ops = &dwc3_gadget_ep0_ops;
 			if (!epnum)
 				dwc->gadget.ep0 = &dep->endpoint;


