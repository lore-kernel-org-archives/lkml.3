Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3GYUHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:07:19 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:51481 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:07:13 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jon.nettleton@gmail.com, cjb@laptop.org, dilinger@queued.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH] Staging: olpc_dcon: change to msleep to usleep_range
Date: Thu, 25 Jul 2013 22:06:32 +0200
Message-Id: <1374782792-2088-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resolution of msleep is related to HZ, so with HZ set to
100 any msleep of less then 10ms will become ~10ms. This is
not what we want. Use usleep_range to get more control of
what is happening here.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 193e1c6..7c460f2 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -131,13 +131,13 @@ power_up:
 			pr_warn("unable to force dcon to power up: %d!\n", x);
 			return x;
 		}
-		msleep(10); /* we'll be conservative */
+		usleep_range(10000, 11000);  /* we'll be conservative */
 	}
 
 	pdata->bus_stabilize_wiggle();
 
 	for (x = -1, timeout = 50; timeout && x < 0; timeout--) {
-		msleep(1);
+		usleep_range(1000, 1100);
 		x = dcon_read(dcon, DCON_REG_ID);
 	}
 	if (x < 0) {
-- 
1.7.9.5

