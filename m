Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3CDM7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:59:38 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33246 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab3CDM7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:35 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH -v3 13/23] uwb: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:21 +0900
Message-Id: <1362401911-14074-14-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-usb@vger.kernel.org
---

No change from v2

 drivers/uwb/rsv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uwb/rsv.c b/drivers/uwb/rsv.c
index 0b0d8bc..f4ae05f 100644
--- a/drivers/uwb/rsv.c
+++ b/drivers/uwb/rsv.c
@@ -231,7 +231,7 @@ void uwb_rsv_backoff_win_increment(struct uwb_rc *rc)
 		return;
 
 	bow->window <<= 1;
-	bow->n = random32() & (bow->window - 1);
+	bow->n = prandom_u32() & (bow->window - 1);
 	dev_dbg(dev, "new_window=%d, n=%d\n: ", bow->window, bow->n);
 
 	/* reset the timer associated variables */
@@ -557,7 +557,7 @@ int uwb_rsv_establish(struct uwb_rsv *rsv)
 	if (ret)
 		goto out;
 
-	rsv->tiebreaker = random32() & 1;
+	rsv->tiebreaker = prandom_u32() & 1;
 	/* get available mas bitmap */
 	uwb_drp_available(rc, &available);
 
-- 
1.8.1.2

