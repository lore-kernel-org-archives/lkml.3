Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaFYHOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:14:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54463 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaFYHOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:14:43 -0400
From: Raphael Poggi <poggi.raph@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Raphael Poggi <poggi.raph@gmail.com>
Subject: [PATCH 2/2 RESEND] staging: lirc: remove return void function
Date: Wed, 25 Jun 2014 09:14:31 +0200
Message-Id: <1403680471-13212-2-git-send-email-poggi.raph@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403680471-13212-1-git-send-email-poggi.raph@gmail.com>
References: <1403680471-13212-1-git-send-email-poggi.raph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpath "WARNING: void function return statements are not generally useful".
The removed return were useless in that case.

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index f8c3375..96c76b3 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -482,8 +482,6 @@ static void usb_tx_callback(struct urb *urb)
 	/* notify waiters that write has finished */
 	atomic_set(&context->tx.busy, 0);
 	complete(&context->tx.finished);
-
-	return;
 }
 
 /**
@@ -548,7 +546,6 @@ static void ir_close(void *data)
 	}
 
 	mutex_unlock(&context->ctx_lock);
-	return;
 }
 
 /**
@@ -573,7 +570,6 @@ static void submit_data(struct imon_context *context)
 
 	lirc_buffer_write(context->driver->rbuf, buf);
 	wake_up(&context->driver->rbuf->wait_poll);
-	return;
 }
 
 static inline int tv2int(const struct timeval *a, const struct timeval *b)
@@ -709,8 +705,6 @@ static void usb_rx_callback(struct urb *urb)
 	}
 
 	usb_submit_urb(context->rx_urb, GFP_ATOMIC);
-
-	return;
 }
 
 /**
-- 
1.7.9.5

