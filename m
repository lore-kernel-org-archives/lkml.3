Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaJ0F0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:26:03 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:58948 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752887AbaJ0FZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:3868:3871:4321:5007:6261:10004:10848:11026:11658:11914:12043:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: river54_4e7deb9dcb43a
X-Filterd-Recvd-Size: 1612
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Subject: [PATCH 10/11] hwa-hc: Fix probable mask then right shift defect
Date: Sun, 26 Oct 2014 22:25:06 -0700
Message-Id: <c09e2a1d219a6bdcc1d12911b186ab353d994657.1414387334.git.joe@perches.com>
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
 drivers/usb/host/hwa-hc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index d0d8fad..1db0626 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -607,7 +607,7 @@ found:
 	wa->wa_descr = wa_descr = (struct usb_wa_descriptor *) hdr;
 	if (le16_to_cpu(wa_descr->bcdWAVersion) > 0x0100)
 		dev_warn(dev, "Wire Adapter v%d.%d newer than groked v1.0\n",
-			 le16_to_cpu(wa_descr->bcdWAVersion) & 0xff00 >> 8,
+			 (le16_to_cpu(wa_descr->bcdWAVersion) & 0xff00) >> 8,
 			 le16_to_cpu(wa_descr->bcdWAVersion) & 0x00ff);
 	result = 0;
 error:
-- 
2.1.2

