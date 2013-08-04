Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3HDRnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 13:43:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18722 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3HDRnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 13:43:50 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <fengguang.wu@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: ozwpan: Fix build warning.
Date: Sun, 4 Aug 2013 18:43:26 +0100
Message-ID: <1375638206-5916-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following build warning.

drivers/built-in.o: In function `oz_hcd_heartbeat':
>> (.text+0x30aadd): undefined reference to `__divdi3'
   drivers/built-in.o: In function `oz_hcd_heartbeat':
>> (.text+0x30ac85): undefined reference to `__divdi3'

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index f81a0c5..db9c81e 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1042,7 +1042,7 @@ int oz_hcd_heartbeat(void *hport)
 		if (ep->credit < 0)
 			continue;
 		delta = timespec_sub(ts, ep->timestamp);
-		ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
+		ep->credit += div64_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);
 		if (ep->credit > ep->credit_ceiling)
 			ep->credit = ep->credit_ceiling;
 		ep->timestamp = ts;
@@ -1086,7 +1086,7 @@ int oz_hcd_heartbeat(void *hport)
 			continue;
 		}
 		delta = timespec_sub(ts, ep->timestamp);
-		ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
+		ep->credit += div64_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);
 		ep->timestamp = ts;
 		while (!list_empty(&ep->urb_list)) {
 			struct oz_urb_link *urbl =
-- 
1.7.9.5

