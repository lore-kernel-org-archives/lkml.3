Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3IPXh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:37:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57666 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3IPXh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:37:26 -0400
Date: Mon, 16 Sep 2013 16:37:20 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] dvb: fix potential format string leak
Message-ID: <20130916233720.GA3967@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that a format string cannot accidentally leak into the printk
buffer.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/dvb-frontends/dib9000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 6201c59..61b2cfe 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -649,7 +649,7 @@ static int dib9000_risc_debug_buf(struct dib9000_state *state, u16 * data, u8 si
 	b[2 * (size - 2) - 1] = '\0';	/* Bullet proof the buffer */
 	if (*b == '~') {
 		b++;
-		dprintk(b);
+		dprintk("%s", b);
 	} else
 		dprintk("RISC%d: %d.%04d %s", state->fe_id, ts / 10000, ts % 10000, *b ? b : "<emtpy>");
 	return 1;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
