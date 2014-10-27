Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaJ0F1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:27:06 -0400
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:45793 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752813AbaJ0FZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:4321:5007:6261:10004:10848:11026:11473:11658:11914:12438:12517:12519:12555:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rice14_4d35fa41c0c25
X-Filterd-Recvd-Size: 1552
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com
Subject: [PATCH 06/11] wm8350-core: Fix probable mask then right shift defect
Date: Sun, 26 Oct 2014 22:25:02 -0700
Message-Id: <9151d02031748dbc1637c1cc9110214617d9bcf1.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mfd/wm8350-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 4ab527f..f5124a8 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -308,7 +308,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		goto err;
 	}
 
-	mode = id2 & WM8350_CONF_STS_MASK >> 10;
+	mode = (id2 & WM8350_CONF_STS_MASK) >> 10;
 	cust_id = id2 & WM8350_CUST_ID_MASK;
 	chip_rev = (id2 & WM8350_CHIP_REV_MASK) >> 12;
 	dev_info(wm8350->dev,
-- 
2.1.2

