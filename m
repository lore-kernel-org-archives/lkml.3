Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3CTKUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:20:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55901 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3CTKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:20:37 -0400
X-AuditID: cbfee68d-b7f786d000005188-59-51498d730bb9
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com
Subject: [PATCH] usb: xhci: Fix TRB transfer length macro used for Event TRB.
Date: Wed, 20 Mar 2013 15:48:40 +0530
Message-id: <1363774720-13187-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWyRsSkWre41zPQ4MBXaYvLu+awWSxa1srs
	wOTxeZNcAGMUl01Kak5mWWqRvl0CV8beXbtYC7YZVDw/3MHewLhCvYuRk0NCwERiwcmZzBC2
	mMSFe+vZuhi5OIQEljJK3J08jx2mqO9GDzNEYhGjxIu/d9khnClMEou+9bGCVLEJ6Eo0vd3F
	CGKLCMhKHL7yG2wss0CsxLs7E1lAbGEBX4md/1+A1bAIqEr09p1jA7F5BTwkWv+/hDpDQeLN
	7Wdg2yQEDrBJdK/7zwrRICDxbfIhoEEcQAlZiU0HoOolJQ6uuMEygVFwASPDKkbR1ILkguKk
	9CJDveLE3OLSvHS95PzcTYzA8Dr971nvDsbbB6wPMSYDjZvILCWanA8Mz7ySeENjMyMLUxNT
	YyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MIpnc2/S184Kv/WgwcT0
	2+/gTw4nF7rM+CgesCjr7GQJlfXf6zIST/vuPDph+ho2hv5IPatnsq4Ms+VuRoi/e81lIL5c
	7cuVX4//rD21aJ+kbOocpaTUXKYXzucTJy98yddbsOrevWWFDl+kwzd+XvzwM3eIkMuz7Bft
	Fq23/+tf5a99+dQy45kSS3FGoqEWc1FxIgBkjahLRQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xgG5xr2egwdfVvBaXd81hs1i0rJXZ
	gcnj8ya5AMaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58A
	XbfMHKDRSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMvbt2sRZsM6h4
	friDvYFxhXoXIyeHhICJRN+NHmYIW0ziwr31bF2MXBxCAosYJV78vcsO4Uxhklj0rY8VpIpN
	QFei6e0uRhBbREBW4vCV32DdzAKxEu/uTGQBsYUFfCV2/n8BVsMioCrR23eODcTmFfCQaP3/
	EmqbgsSb28+YJzByL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLzPpHYwrmywOMQo
	wMGoxMP7YrZHoBBrYllxZe4hRgkOZiURXuYez0Ah3pTEyqrUovz4otKc1OJDjMlA2ycyS4km
	5wMjK68k3tDYxNzU2NTSxMLEzJI0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGPNN4+7M
	OW3kzHjnkJeg9u2omZsnpl54dbwkfPU/d0sXh7D3krf3z82c9GM/q8z/85m+jT/WlnQcy7O2
	cxHkvKqUs+sQs8UjpvKf5QennojdUxs7lUXc59SlmUdMtdZaV+xilLy3aK5NzIWZRgrntB/P
	nfd4wda5T/6sZJcLXW12+HH4J9c3Fe5KLMUZiYZazEXFiQCb3jaQogIAAA==
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
 drivers/usb/host/xhci-ring.c |   45 +++++++++++++++++++++++------------------
 drivers/usb/host/xhci.h      |    4 +++
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8828754..fe59a30 100644
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
@@ -2137,11 +2137,13 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		     cur_seg = ep_ring->deq_seg; cur_trb != event_trb;
 		     next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
 			if (!TRB_TYPE_NOOP_LE32(cur_trb->generic.field[3]) &&
-			    !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3]))
-				len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
+			    !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3])) {
+				len += EVENT_TRB_LEN(le32_to_cpu
+						(cur_trb->generic.field[2]));
+			}
 		}
-		len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-			TRB_LEN(le32_to_cpu(event->transfer_len));
+		len += EVENT_TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
+			EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 
 		if (trb_comp_code != COMP_STOP_INVAL) {
 			frame->actual_length = len;
@@ -2199,7 +2201,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
 		if (event_trb != td->last_trb ||
-				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		    EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
@@ -2225,20 +2227,21 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	if (trb_comp_code == COMP_SHORT_TX)
 		xhci_dbg(xhci, "ep %#x - asked for %d bytes, "
 				"%d bytes untransferred\n",
-				td->urb->ep->desc.bEndpointAddress,
-				td->urb->transfer_buffer_length,
-				TRB_LEN(le32_to_cpu(event->transfer_len)));
+			      td->urb->ep->desc.bEndpointAddress,
+			      td->urb->transfer_buffer_length,
+			      EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
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
+					EVENT_TRB_LEN(le32_to_cpu
+							(event->transfer_len)));
 				td->urb->actual_length = 0;
 				if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 					*status = -EREMOTEIO;
@@ -2270,17 +2273,19 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				cur_trb != event_trb;
 				next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
 			if (!TRB_TYPE_NOOP_LE32(cur_trb->generic.field[3]) &&
-			    !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3]))
+			    !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3])) {
 				td->urb->actual_length +=
-					TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
+					EVENT_TRB_LEN(le32_to_cpu
+						(cur_trb->generic.field[2]));
+		     }
 		}
 		/* If the ring didn't stop on a Link or No-op TRB, add
 		 * in the actual bytes transferred from the Normal TRB
 		 */
 		if (trb_comp_code != COMP_STOP_INVAL)
 			td->urb->actual_length +=
-				TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+			  EVENT_TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]))
+			  - EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	}
 
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
@@ -2368,7 +2373,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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

