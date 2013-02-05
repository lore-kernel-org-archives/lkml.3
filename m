Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3BEOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:41:05 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58800 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab3BEOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:41:01 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/2] tty: metag_da: update flip functions to use tty_port
Date: Tue, 5 Feb 2013 14:40:49 +0000
Message-ID: <1360075250-21970-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
References: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_05_14_40_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "TTY: switch tty_flip_buffer_push" and "TTY: convert more
flipping functions" switched tty_flip_buffer_push() and
tty_prepare_flip_string() to take tty_port rather than a tty_struct.

Convert the metag_da tty driver similarly.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/metag_da.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/metag_da.c b/drivers/tty/metag_da.c
index 6a0b2e6..fc2a36b 100644
--- a/drivers/tty/metag_da.c
+++ b/drivers/tty/metag_da.c
@@ -163,13 +163,14 @@ static int fetch_data(struct tty_struct *tty)
 			int space;
 			unsigned char *cbuf;
 
-			space = tty_prepare_flip_string(tty, &cbuf, received);
+			space = tty_prepare_flip_string(&dport->port, &cbuf,
+							received);
 
 			if (space <= 0)
 				goto unlock;
 
 			memcpy(cbuf, dport->rx_buf, space);
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&dport->port);
 		}
 	}
 unlock:
-- 
1.7.7.6


