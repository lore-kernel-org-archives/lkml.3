Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaBXIEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:04:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10583 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbaBXID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:27 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 1/6] usb: gadget: mv_udc: remove redundant pull up in udc_start
Date: Mon, 24 Feb 2014 16:03:11 +0800
Message-ID: <1393228996-14787-2-git-send-email-zhangwm@marvell.com>
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

Romove redundant pull up in udc_start since function udc_bind_to_driver
in udc-core.c will do it for us.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/mv_udc_core.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index fcff3a5..ebc0dfd 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -1365,9 +1365,6 @@ static int mv_udc_start(struct usb_gadget *gadget,
 		}
 	}
 
-	/* pullup is always on */
-	mv_udc_pullup(&udc->gadget, 1);
-
 	/* When boot with cable attached, there will be no vbus irq occurred */
 	if (udc->qwork)
 		queue_work(udc->qwork, &udc->vbus_work);
-- 
1.7.9.5

