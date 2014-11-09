Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaKIBXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:23:40 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57032 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKIBW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:22:28 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: cascardo@linux.vnet.ibm.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 1/5] serial: jsm: Remove unnecessary parameter from clear_break()
Date: Sun,  9 Nov 2014 02:22:16 +0100
Message-Id: <1415496140-14997-2-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415496140-14997-1-git-send-email-bergo.torino@gmail.com>
References: <1415496140-14997-1-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'force' parameter to the {cls,neo}_send_break() function has been
removed because it has not been used. The client to this API (the tty
code) always called this function with only one value.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/jsm/jsm.h     | 2 +-
 drivers/tty/serial/jsm/jsm_cls.c | 2 +-
 drivers/tty/serial/jsm/jsm_neo.c | 2 +-
 drivers/tty/serial/jsm/jsm_tty.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
index 72ed5c1..39b325b 100644
--- a/drivers/tty/serial/jsm/jsm.h
+++ b/drivers/tty/serial/jsm/jsm.h
@@ -120,7 +120,7 @@ struct board_ops {
 	void (*disable_receiver) (struct jsm_channel *ch);
 	void (*enable_receiver) (struct jsm_channel *ch);
 	void (*send_break) (struct jsm_channel *ch);
-	void (*clear_break) (struct jsm_channel *ch, int);
+	void (*clear_break) (struct jsm_channel *ch);
 	void (*send_start_character) (struct jsm_channel *ch);
 	void (*send_stop_character) (struct jsm_channel *ch);
 	void (*copy_data_from_queue_to_uart) (struct jsm_channel *ch);
diff --git a/drivers/tty/serial/jsm/jsm_cls.c b/drivers/tty/serial/jsm/jsm_cls.c
index 4cb9275..3df9112 100644
--- a/drivers/tty/serial/jsm/jsm_cls.c
+++ b/drivers/tty/serial/jsm/jsm_cls.c
@@ -311,7 +311,7 @@ static void cls_set_no_input_flow_control(struct jsm_channel *ch)
  * No locks are assumed to be held when calling this function.
  * channel lock is held and released in this function.
  */
-static void cls_clear_break(struct jsm_channel *ch, int force)
+static void cls_clear_break(struct jsm_channel *ch)
 {
 	unsigned long lock_flags;
 
diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index dc2cd90..b9faee7 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -689,7 +689,7 @@ static void neo_flush_uart_read(struct jsm_channel *ch)
 /*
  * No locks are assumed to be held when calling this function.
  */
-static void neo_clear_break(struct jsm_channel *ch, int force)
+static void neo_clear_break(struct jsm_channel *ch)
 {
 	unsigned long lock_flags;
 
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index c60e454..524e86a 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -188,7 +188,7 @@ static void jsm_tty_break(struct uart_port *port, int break_state)
 	if (break_state == -1)
 		channel->ch_bd->bd_ops->send_break(channel);
 	else
-		channel->ch_bd->bd_ops->clear_break(channel, 0);
+		channel->ch_bd->bd_ops->clear_break(channel);
 
 	spin_unlock_irqrestore(&port->lock, lock_flags);
 }
-- 
1.9.1

