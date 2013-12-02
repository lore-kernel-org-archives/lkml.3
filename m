Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3LBVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:12:33 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:51325 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3LBVM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:12:28 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 1/4] tty: Fix stale tty_buffer_flush() comment
Date: Mon,  2 Dec 2013 16:12:02 -0500
Message-Id: <1386018725-4781-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d7a68be4f265be10e24be931c257af30ca55566b,
'tty: Only perform flip buffer flush from tty_buffer_flush()',
removed buffer flushing from flush_to_ldisc().

Fix function header comment which describes the former behavior.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6664f0d..2cea1ab 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -208,9 +208,7 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
  *	tty_buffer_flush		-	flush full tty buffers
  *	@tty: tty to flush
  *
- *	flush all the buffers containing receive data. If the buffer is
- *	being processed by flush_to_ldisc then we defer the processing
- *	to that function
+ *	flush all the buffers containing receive data.
  *
  *	Locking: takes buffer lock to ensure single-threaded flip buffer
  *		 'consumer'
-- 
1.8.1.2

