Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3B1OqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3B1OqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 009/139] usb: dwc3: gadget: req->queued must be forced to false in cleanup
Date: Thu, 28 Feb 2013 14:42:39 +0000
Message-Id: <1362062689-2567-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit c9fda7d6f62a6520e01652d370654c5657d3c1a1 upstream.

I am not sure, why I found it during SG debugging. But, I noticed that
even when req_queued list was empty, there were some request in
request_list having queued flag true. If I run test second time, it
first removes all request from request_list and hence busy_slot was
wrongly incremented.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 9ba53de..fae7885 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -231,6 +231,7 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 		if (((dep->busy_slot & DWC3_TRB_MASK) == DWC3_TRB_NUM - 1) &&
 				usb_endpoint_xfer_isoc(dep->endpoint.desc))
 			dep->busy_slot++;
+		req->queued = false;
 	}
 	list_del(&req->list);
 	req->trb = NULL;
-- 
1.8.1.2

