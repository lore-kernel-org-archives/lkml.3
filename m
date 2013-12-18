Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3LRSB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:01:29 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35450 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab3LRSB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:01:28 -0500
Date: Wed, 18 Dec 2013 10:00:54 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Bradley Grove <linuxdrivers@attotech.com>, Joe Perches <joe@perches.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: esas2r: fix potential format string flaw
Message-ID: <20131218180054.GA5739@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure format strings cannot leak into the printk call via the
constructed buffer.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Bradley Grove <bgrove@attotech.com>
---
v2:
 - add newline via printk instead.
---
 drivers/scsi/esas2r/esas2r_log.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index 9bf285df58dd..a82030aa8577 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -165,13 +165,9 @@ static int esas2r_log_master(const long level,
 
 		/*
 		 * Put a line break at the end of the formatted string so that
-		 * we don't wind up with run-on messages.  only append if there
-		 * is enough space in the buffer.
+		 * we don't wind up with run-on messages.
 		 */
-		if (strlen(event_buffer) < buflen)
-			strcat(buffer, "\n");
-
-		printk(event_buffer);
+		printk("%s\n", event_buffer);
 
 		spin_unlock_irqrestore(&event_buffer_lock, flags);
 	}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
