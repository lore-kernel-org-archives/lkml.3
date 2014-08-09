Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHIXl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:41:29 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34630 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaHIXl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:41:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] message: fusion: mptbase.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:42:56 +0200
Message-Id: <1407627776-24424-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/message/fusion/mptbase.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index ebc0af7..66324f8 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7706,8 +7706,10 @@ mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 		ds = "Unknown";
 		break;
 	}
-	if (ds)
+	if (ds) {
 		strncpy(evStr, ds, EVENT_DESCR_STR_SZ);
+		evStr[EVENT_DESCR_STR_SZ - 1] = '\0';
+	}
 
 
 	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-- 
1.7.10.4

