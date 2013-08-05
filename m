Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3HELOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:14:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51199 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3HELOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:14:14 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <anca.emanuel@gmail.com>, <fengguang.wu@intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2] staging: ozwpan: Fix build warning.
Date: Mon, 5 Aug 2013 12:14:04 +0100
Message-ID: <1375701244-6021-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <51FF788B.6060804@atmel.com>
References: <51FF788B.6060804@atmel.com>
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
index f81a0c5..ed63868 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1042,7 +1042,7 @@ int oz_hcd_heartbeat(void *hport)
 		if (ep->credit < 0)
 			continue;
 		delta = timespec_sub(ts, ep->timestamp);
-		ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
+		ep->credit += div_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);
 		if (ep->credit > ep->credit_ceiling)
 			ep->credit = ep->credit_ceiling;
 		ep->timestamp = ts;
@@ -1086,7 +1086,7 @@ int oz_hcd_heartbeat(void *hport)
 			continue;
 		}
 		delta = timespec_sub(ts, ep->timestamp);
-		ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
+		ep->credit += div_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);
 		ep->timestamp = ts;
 		while (!list_empty(&ep->urb_list)) {
 			struct oz_urb_link *urbl =
-- 
1.7.9.5

