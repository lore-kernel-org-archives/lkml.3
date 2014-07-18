Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbaGRLmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:42:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25752 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaGRLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:13 -0400
X-AuditID: cbfee61b-f79f86d00000144c-31-53c9079bf432
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 07/12] usb: dwc2/gadget: break infinite loop in endpoint
 disable code
Date: Fri, 18 Jul 2014 13:39:32 +0200
Message-id: <1405683577-11226-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAd3Z7CeDDRa81bGY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVserqXqaCJ6wVnQ8fMjcwPmHpYuTkkBAwkVgz7wKULSZx
	4d56ti5GLg4hgUWMEsdvnmaGcNqZJGbcnMIKUsUmoCOx5fsERhBbREBAYv2LS+wgRcwCJxgl
	Ov5fYANJCAtEScx53A1WxCKgKrHl8SSwZl4BV4n57w6wQayTkzh5bDJYnFPATaLt0X+gMziA
	trlKTPvKP4GRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4PB6Jr2DcVWDxSFGAQ5G
	JR5ei5vHg4VYE8uKK3MPMUpwMCuJ8GbfBwrxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgk
	kJ5YkpqdmlqQWgSTZeLglGpgTPsTtbqi83gXt0dn3tfc+z++bynKe+b5/vbJsstXPcqqtc5c
	eOB/K+5DlKPrT6PXO7Nc3orsYNW2uFf3wbVSJNj/kUr89ndmm/WKKpR+Zoe2dv7g4+FiF1zq
	MX/2zoU+x/VXTiica2dapu1lohJmppiZ4HNn/jPt81uYFvuviF/A2X6CoWKqEktxRqKhFnNR
	cSIA9haHRysCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch fixes possible freeze caused by infinite loop in interrupt
context.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 21d21de..2220882 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1652,6 +1652,7 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
 			dev_err(hsotg->dev,
 				"%s: timeout flushing fifo (GRSTCTL=%08x)\n",
 				__func__, val);
+			break;
 		}
 
 		udelay(1);
-- 
1.9.1

