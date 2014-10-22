Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaJVVXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:23:19 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35032 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaJVVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:23:17 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2] staging: rtl8712: Remove redundant cast
Date: Wed, 22 Oct 2014 23:22:27 +0200
Message-Id: <1414012947-11606-1-git-send-email-linux@rasmusvillemoes.dk>
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
index 1d6ade0..83f9341 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -86,7 +86,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, const u8 **ppmappedfw)
 			(int)padapter->fw->size);
 		return 0;
 	}
-	*ppmappedfw = (u8 *)((*praw)->data);
+	*ppmappedfw = (*praw)->data;
 	return (*praw)->size;
 }
 
-- 
2.0.4

