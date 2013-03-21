Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3CUGiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:38:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32754 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab3CUGiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:38:46 -0400
X-AuditID: cbfee68d-b7f786d000005188-77-514aaaf3ad2d
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com
Subject: [PATCH v2] usb: xhci: Fix TRB transfer length macro used for Event TRB.
Date: Thu, 21 Mar 2013 12:06:48 +0530
Message-id: <1363847808-20512-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iEo8typctEOxxXehs1MiKV=oUD=zZSQX46YPk3cfoBU-Q@mail.gmail.com>
References: <CAFp+6iEo8typctEOxxXehs1MiKV=oUD=zZSQX46YPk3cfoBU-Q@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRsSkWvfzKq9Ag3XnBS0u75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBnNr2ayFaxUr3i84xZjA2OfQhcjJ4eEgInErWfLmSBs
	MYkL99azdTFycQgJLGWUWH3/A2MXIwdY0f4rqhDxRYwSR9uOsEI4U5gkPrx/B9bNJqAr0fR2
	FyOILSIgK3H4ym9mEJtZIFbi3Z2JLCC2sECAROv5c2BxFgFVib5ZV9hAbF4BD4kp676zQFyh
	IPHm9jOwGk6BYImNyz+A2UJAvZvnv2YCWSwhcJ9NYsb83UwQgwQkvk0+xAJxqazEpgPMEHMk
	JQ6uuMEygVF4ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAYDz971nvDsbbB6wPMSYD
	jZvILCWanA8M5rySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MOpPP7kxKXWyyiv2CZwqHxpkbSZ+PyK6n7ex7HXgWW3udxFsKbssREplZC0zts59
	lSkTWSaQ3uWR7vjxik6t3WTOPwKTgoX/Tg2s3ZJ9t2lznpHgxeUa9UwBhxd9r/0qr9Rip3zI
	8vvFp/d0awu8d+u8nu15/5vRy1AB81dvzppnMy1eNG+OiRJLcUaioRZzUXEiAN2lXDFcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAd3Pq7wCDT4+Y7K4vGsOm8WiZa3M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmNL+ayVawUr3i
	8Y5bjA2MfQpdjBwcEgImEvuvqHYxcgKZYhIX7q1n62Lk4hASWMQocbTtCCuEM4VJ4sP7d0wg
	VWwCuhJNb3cxgtgiArISh6/8ZgaxmQViJd7dmcgCYgsLBEi0nj8HFmcRUJXom3WFDcTmFfCQ
	mLLuOwvENgWJN7efgdVwCgRLbFz+AcwWAurdPP810wRG3gWMDKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxgkP9mfQOxlUNFocYBTgYlXh4OZ54BgqxJpYVV+YeYpTgYFYS4V2m5BUoxJuS
	WFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAOMwriTc0NjE3NTa1NLEwMbMkTVhJnPdgq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBkYf7gt/ttzf4Brzx0cv45j33JapujbyH5/O3WtzZPblCIk4CeXL
	S48HsR7msW796/E1eIbEQtc7jGeazwk8mXRxEo8s16X7XMzBteH/D9e+1Nkc4Pd8oXKd9vP0
	JaeYbB8sXxYQmZak920bn+zEr67/TA6fjpw/29pYp+bFu2rfPlbhfZKz1sxWYinOSDTUYi4q
	TgQAq6NQ1bkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper macro while extracting TRB transfer length from
Transfer event TRBs. Adding a macro EVENT_TRB_LEN (bits 0:23)
for the same, and use it instead of TRB_LEN (bits 0:16) in
case of event TRBs.

Signed-off-by: Vivek gautam <gautam.vivek@samsung.com>
---

Hi Sarah,

Updated the patch as suggested.
There are two 80 characters warnings although ;-)

Thanks!

 drivers/usb/host/xhci-ring.c |   24 ++++++++++++------------
 drivers/usb/host/xhci.h      |    4 ++++
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8828754..30a2489 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2027,8 +2027,8 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (event_trb != ep_ring->dequeue &&
 				event_trb != td->last_trb)
 			td->urb->actual_length =
-				td->urb->transfer_buffer_length
-				- TRB_LEN(le32_to_cpu(event->transfer_len));
+				td->urb->transfer_buffer_length -
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 		else
 			td->urb->actual_length = 0;
 
@@ -2060,7 +2060,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		/* Maybe the event was for the data stage? */
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			xhci_dbg(xhci, "Waiting for status "
 					"stage event\n");
 			return 0;
@@ -2096,7 +2096,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
 			frame->status = 0;
 			break;
 		}
@@ -2141,7 +2141,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
 		}
 		len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-			TRB_LEN(le32_to_cpu(event->transfer_len));
+			EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 
 		if (trb_comp_code != COMP_STOP_INVAL) {
 			frame->actual_length = len;
@@ -2199,7 +2199,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
 		if (event_trb != td->last_trb ||
-				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		    EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
@@ -2227,18 +2227,18 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				"%d bytes untransferred\n",
 				td->urb->ep->desc.bEndpointAddress,
 				td->urb->transfer_buffer_length,
-				TRB_LEN(le32_to_cpu(event->transfer_len)));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
 	/* Fast path - was this the last TRB in the TD for this URB? */
 	if (event_trb == td->last_trb) {
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			if (td->urb->transfer_buffer_length <
 					td->urb->actual_length) {
 				xhci_warn(xhci, "HC gave bad length "
 						"of %d bytes left\n",
-					  TRB_LEN(le32_to_cpu(event->transfer_len)));
+					  EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
 				td->urb->actual_length = 0;
 				if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 					*status = -EREMOTEIO;
@@ -2280,7 +2280,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (trb_comp_code != COMP_STOP_INVAL)
 			td->urb->actual_length +=
 				TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	}
 
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
@@ -2368,7 +2368,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
 		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
 			trb_comp_code = COMP_SHORT_TX;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index f791bd0..61f71ed 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -972,6 +972,10 @@ struct xhci_transfer_event {
 	__le32	flags;
 };
 
+/* Transfer event TRB length bit mask */
+/* bits 0:23 */
+#define	EVENT_TRB_LEN(p)		((p) & 0xffffff)
+
 /** Transfer Event bit fields **/
 #define	TRB_TO_EP_ID(p)	(((p) >> 16) & 0x1f)
 
-- 
1.7.6.5

