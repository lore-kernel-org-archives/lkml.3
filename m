Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbaGOVbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:31:32 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64381 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbaGOVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:24 -0400
Date: Wed, 16 Jul 2014 03:01:17 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] dib7000m: Remove unnecessary null test
Message-ID: <20140715213117.GA28037@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the null test on ch. ch is initialized at the
beginning of the function to &demod->dtv_property_cache. Since demod
is dereferenced prior to the null test, demod must be a valid pointer,
and &demod->dtv_property_cache cannot be null.

The following Coccinelle script is used for detecting the change:

@r@
expression e,f;
identifier g,y;
statement S1,S2;
@@

*e = &f->g
<+...
 f->y
 ...+>
*if (e != NULL || ...)
 S1 else S2

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/media/dvb-frontends/dib7000m.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index 148bf79..dcb9a15 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -1041,10 +1041,7 @@ static int dib7000m_tune(struct dvb_frontend *demod)
 	u16 value;
 
 	// we are already tuned - just resuming from suspend
-	if (ch != NULL)
-		dib7000m_set_channel(state, ch, 0);
-	else
-		return -EINVAL;
+	dib7000m_set_channel(state, ch, 0);
 
 	// restart demod
 	ret |= dib7000m_write_word(state, 898, 0x4000);
-- 
1.9.1

