Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3DOP0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:26:39 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45238 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3DOP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:26:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 05/16] tty: Use generic names for flip buffer list cursors
Date: Mon, 15 Apr 2013 11:25:56 -0400
Message-Id: <1366039567-8620-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index a428fa2..0259a76 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -44,15 +44,15 @@ static void tty_buffer_reset(struct tty_buffer *p, size_t size)
 void tty_buffer_free_all(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
-	struct tty_buffer *thead;
+	struct tty_buffer *p;
 
-	while ((thead = buf->head) != NULL) {
-		buf->head = thead->next;
-		kfree(thead);
+	while ((p = buf->head) != NULL) {
+		buf->head = p->next;
+		kfree(p);
 	}
-	while ((thead = buf->free) != NULL) {
-		buf->free = thead->next;
-		kfree(thead);
+	while ((p = buf->free) != NULL) {
+		buf->free = p->next;
+		kfree(p);
 	}
 	buf->tail = NULL;
 	buf->memory_used = 0;
@@ -143,13 +143,13 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 static void __tty_buffer_flush(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
-	struct tty_buffer *thead;
+	struct tty_buffer *next;
 
 	if (unlikely(buf->head == NULL))
 		return;
-	while ((thead = buf->head->next) != NULL) {
+	while ((next = buf->head->next) != NULL) {
 		tty_buffer_free(port, buf->head);
-		buf->head = thead;
+		buf->head = next;
 	}
 	WARN_ON(buf->head != buf->tail);
 	buf->head->read = buf->head->commit;
-- 
1.8.1.2

