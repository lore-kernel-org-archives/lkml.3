Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaFWHyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:54:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59760 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaFWHyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:54:00 -0400
X-AuditID: cbfee61b-f79f86d00000144c-d3-53a7dd170517
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 08/11] usb: dwc2/gadget: do not call disconnect method in pullup
Date: Mon, 23 Jun 2014 09:51:27 +0200
Message-id: <1403509890-14103-9-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3xu8uDDf4ulLWY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVcebmQZaCeWwVV5qusjQwLmLtYuTkkBAwkbi//DiULSZx
	4d56NhBbSGA6o8TOryVdjFxAdjuTxK3pE8ASbAI6Elu+T2AEsUUEBCTWv7jEDlLELHCCUaLj
	/wWwImGBAIk7fY/YQWwWAVWJJY87WEBsXgFXiROTl7NBbJOTOHlsMthmTgE3ifU3F7JDbHaV
	WHR6GvsERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLD65n0DsZVDRaHGAU4GJV4
	eDXclgcLsSaWFVfmHmKU4GBWEuFtbAAK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCe
	WJKanZpakFoEk2Xi4JRqYFzu9/5F79pZdU7ZOS7C+56/+508M5d9znFuvZMlSfZ1qU95773+
	Gv7vsYal55EfTF84HhUXWCwLfCfabPDTOHLxwcbjU2+dkCju3Jq0WvX9+9NvnynudLR89m/u
	7Z1eyi/6faceVM/YbZRyVEPz1757XY13FzSo2a5YkK4zS3FxyPWO1YGG8/SVWIozEg21mIuK
	EwFRdr8tKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This leads to potential spinlock recursion in composite framework, other
udc drivers also don't call it directly from pullup method.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 2220882..def4900 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2945,7 +2945,6 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 		s3c_hsotg_phy_enable(hsotg);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		s3c_hsotg_disconnect(hsotg);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
-- 
1.9.1

