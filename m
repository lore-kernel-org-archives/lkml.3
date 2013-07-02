Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3GBPm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:42:56 -0400
Received: from cpc6-farn7-2-0-cust119.6-2.cable.virginmedia.com ([81.110.26.120]:42314
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752222Ab3GBPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:41:58 -0400
From: Dean Jenkins <Dean_Jenkins@mentor.com>
To: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/5] SLIP: Add error message for xleft non-zero
Date: Tue,  2 Jul 2013 16:31:33 +0100
Message-Id: <1372779094-11730-5-git-send-email-Dean_Jenkins@mentor.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a printk to show when xleft is non-zero in sl_encaps.

The idea is to see whether a previous SLIP frame failed to be
fully transmitted.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
---
 drivers/net/slip/slip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index f7303e0..e2eff84 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -395,6 +395,10 @@ static void sl_encaps(struct slip *sl, unsigned char *icp, int len)
 #endif
 		count = slip_esc(p, sl->xbuff, len);
 
+	if (sl->xleft)
+		printk(KERN_ERR "%s: ERROR: xleft is non-zero %d\n",
+		       __func__, sl->xleft);
+
 	/* ensure xleft set by the previous SLIP frame is zero for this frame
 	 * otherwise slip_write_wakeup() can cause a recursive loop.
 	 */
-- 
1.8.1.5

