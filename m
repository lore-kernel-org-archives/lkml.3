Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaJUO6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:58:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63453 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:58:36 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] staging: rtl8712: Remove redundant cast
Date: Tue, 21 Oct 2014 16:58:26 +0200
Message-Id: <1413903507-3256-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct firmware::data has type const u8*, as does *ppmappedfw, so the
cast to u8* is unnecessary and slightly confusing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/rtl8712/hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 1d6ade0..cc6b390 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -86,7 +86,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, const u8 **ppmappedfw)
 			(int)padapter->fw->size);
 		return 0;
 	}
-	*ppmappedfw = (u8 *)((*praw)->data);
+	*ppmappedfw = ((*praw)->data);
 	return (*praw)->size;
 }
 
-- 
2.0.4

