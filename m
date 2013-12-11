Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3LKFFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:05:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7890 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab3LKFFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:05:09 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] usb: phy: Initilize the spinlock in notifier
Date: Wed, 11 Dec 2013 13:05:07 +0800
Message-ID: <1386738308-19773-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-11_01:2013-12-10,2013-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312100250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to initilize every spinlock before use it.
So lets initilize the spinlock in notifier when add a new phy device.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/phy/phy.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 1b74523..479ceb8 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -367,6 +367,8 @@ int usb_add_phy_dev(struct usb_phy *x)
 		return -EINVAL;
 	}
 
+	spin_lock_init(&x->notifier.lock);
+
 	spin_lock_irqsave(&phy_lock, flags);
 	list_for_each_entry(phy_bind, &phy_bind_list, list)
 		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
-- 
1.7.9.5

