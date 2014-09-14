Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaINP7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:59:22 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:58469 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaINP7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:59:21 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Karsten Keil <isdn@linux-pingi.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: act2000: capi.c:  Cleaning up unnecessary use of memset in conjunction with strncpy
Date: Sun, 14 Sep 2014 18:01:11 +0200
Message-Id: <1410710471-14341-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using memset before strncpy just to ensure a trailing null
character is an unnecessary double writing of a string

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/isdn/act2000/capi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/act2000/capi.c b/drivers/isdn/act2000/capi.c
index 3f66ca2..1267739 100644
--- a/drivers/isdn/act2000/capi.c
+++ b/drivers/isdn/act2000/capi.c
@@ -907,10 +907,10 @@ actcapi_dispatch(struct work_struct *work)
 		case 0xff02:
 			/* MANUFACTURER_IND */
 			if (msg->msg.manuf_msg == 3) {
-				memset(tmp, 0, sizeof(tmp));
 				strncpy(tmp,
 					&msg->msg.manufacturer_ind_err.errstring,
-					msg->hdr.len - 16);
+					sizeof(tmp));
+				tmp[sizeof(tmp) - 1] = '\0';
 				if (msg->msg.manufacturer_ind_err.errcode)
 					printk(KERN_WARNING "act2000: %s\n", tmp);
 				else {
@@ -1136,9 +1136,9 @@ actcapi_debug_msg(struct sk_buff *skb, int direction)
 			       msg->msg.manufacturer_ind_err.controller);
 			printk(KERN_DEBUG " Code = 0x%08x\n",
 			       msg->msg.manufacturer_ind_err.errcode);
-			memset(tmp, 0, sizeof(tmp));
 			strncpy(tmp, &msg->msg.manufacturer_ind_err.errstring,
-				msg->hdr.len - 16);
+				sizeof(tmp));
+			tmp[sizeof(tmp) - 1] = '\0';
 			printk(KERN_DEBUG " Emsg = '%s'\n", tmp);
 			break;
 		}
-- 
1.7.10.4

