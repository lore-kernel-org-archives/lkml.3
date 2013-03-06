Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3CFNjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:39:11 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50371 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab3CFNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:39:02 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 5/7] n_tty: Untangle read completion variables
Date: Wed,  6 Mar 2013 08:38:23 -0500
Message-Id: <1362577105-19757-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
References: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3fd657b..b2f621f 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1814,20 +1814,16 @@ do_it_again:
 	minimum = time = 0;
 	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (!ldata->icanon) {
-		time = (HZ / 10) * TIME_CHAR(tty);
 		minimum = MIN_CHAR(tty);
 		if (minimum) {
+			time = (HZ / 10) * TIME_CHAR(tty);
 			if (time)
 				ldata->minimum_to_wake = 1;
 			else if (!waitqueue_active(&tty->read_wait) ||
 				 (ldata->minimum_to_wake > minimum))
 				ldata->minimum_to_wake = minimum;
 		} else {
-			timeout = 0;
-			if (time) {
-				timeout = time;
-				time = 0;
-			}
+			timeout = (HZ / 10) * TIME_CHAR(tty);
 			ldata->minimum_to_wake = minimum = 1;
 		}
 	}
-- 
1.8.1.2

