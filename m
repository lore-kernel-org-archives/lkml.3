Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3FOL33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:29:29 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37970 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3FOL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:28:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/4] n_tty: Untangle read completion variables
Date: Sat, 15 Jun 2013 07:28:29 -0400
Message-Id: <1371295711-3963-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371295711-3963-1-git-send-email-peter@hurleysoftware.com>
References: <20130319141017.GB24900@kroah.com>
 <1371295711-3963-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f1806de..fa5cb46 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1801,20 +1801,16 @@ do_it_again:
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

