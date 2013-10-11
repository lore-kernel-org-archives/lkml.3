Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3JKUJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:09:06 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63370 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab3JKUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:09:01 -0400
Date: Fri, 11 Oct 2013 22:08:49 +0200 (CEST)
From: Roel Kluin <roel.kluin@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: tty: incorrect test of echo_buf() result for ECHO_OP_START
Message-ID: <alpine.DEB.2.02.1310112126001.11060@Z>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested, but this looks like a bug to me
-----------
test echo_buf() result for ECHO_OP_START

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 7a744b6..42b6cca 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -767,7 +767,7 @@ static size_t __process_echoes(struct tty_struct *tty)
 	 * of echo overrun before the next commit), then discard enough
 	 * data at the tail to prevent a subsequent overrun */
 	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
-		if (echo_buf(ldata, tail == ECHO_OP_START)) {
+		if (echo_buf(ldata, tail) == ECHO_OP_START) {
 			if (echo_buf(ldata, tail) == ECHO_OP_ERASE_TAB)
 				tail += 3;
 			else

