Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBXID1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:03:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45666 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbaBXIDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:24 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Date: Mon, 24 Feb 2014 16:03:12 +0800
Message-ID: <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-23_03:2014-02-21,2014-02-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402230265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware zlt will try to send the zero length packet automatically
when the data transferd is multiple times of max packet, this will
cause issues on Windows.
So let's disable HW zlt by default.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/mv_udc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index ebc0dfd..657ac5c 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -89,7 +89,7 @@ static void ep0_reset(struct mv_udc *udc)
 		/* configure ep0 endpoint capabilities in dQH */
 		ep->dqh->max_packet_length =
 			(EP0_MAX_PKT_SIZE << EP_QUEUE_HEAD_MAX_PKT_LEN_POS)
-			| EP_QUEUE_HEAD_IOS;
+			| EP_QUEUE_HEAD_IOS | EP_QUEUE_HEAD_ZLT_SEL;
 
 		ep->dqh->next_dtd_ptr = EP_QUEUE_HEAD_NEXT_TERMINATE;
 
-- 
1.7.9.5

