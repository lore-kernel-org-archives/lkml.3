Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3B1OqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3B1OqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/139] USB: DWC3: Generate interrupt on each TRB as default option
Date: Thu, 28 Feb 2013 14:42:37 +0000
Message-Id: <1362062689-2567-8-git-send-email-luis.henriques@canonical.com>
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

commit 206dd69a62a06197b308fa0decfd0b649fcc2811 upstream.

Currently in case of isoc, interrupt is programmed after each
TRB_NUM/4 ie 8th TRB. A TRB is programmed against each submitted
request from gadget. If we do not want to limit the minimum number of
necessary request to be submitted from gadget then we must receive
interrupt on each TRB submission. There can be such situation with a
gadget working with ping-pong buffer.

If a gadget does not want to receive interrupt after each request
completion then it may set no_interrupt flag.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1f53210..edfff45 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -744,8 +744,7 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 	case USB_ENDPOINT_XFER_ISOC:
 		trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS_FIRST;
 
-		/* IOC every DWC3_TRB_NUM / 4 so we can refill */
-		if (!(cur_slot % (DWC3_TRB_NUM / 4)))
+		if (!req->request.no_interrupt)
 			trb->ctrl |= DWC3_TRB_CTRL_IOC;
 		break;
 
-- 
1.8.1.2

