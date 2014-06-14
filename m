Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaFNUIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:08:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:62048 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaFNUIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:08:48 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Joe Perches <joe@perches.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] serial: samsung: Fix compile error with SERIAL_SAMSUNG_DEBUG
Date: Sat, 14 Jun 2014 22:07:14 +0200
Message-Id: <1402776434-31613-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:b9p14YsvNGVUnB5fILjUfCYf77RUIRvpXpLup+IMRuSTAkOJTJI
 WMKJcdek5Uy37CbTt1c1gL+l3zkx2L+A6+NXv6amOG/miYzo23SPy9piiARKUVO9P6G6u8U
 Mv62q56gyQSLNDmcX8zgj7I/wHkOQRMb1DGBGJLSVvsbyJean3H2P6Jw3cL+hGWkMn3b5M7
 1kiTTD9I3I+rSCO4T+wJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e4ac92d (serial: samsung: Neaten dbg uses) contains a typo in the
changed dbg() function regarding the name of the used character buffer.
This breaks the build if actually compiled with CONFIG_SERIAL_SAMSUNG_DEBUG.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested. Applies against branch tty-next in tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
---
 drivers/tty/serial/samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 3293377..c1d3ebd 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -66,7 +66,7 @@ static void dbg(const char *fmt, ...)
 	char buff[256];
 
 	va_start(va, fmt);
-	vscnprintf(buff, sizeof(buf), fmt, va);
+	vscnprintf(buff, sizeof(buff), fmt, va);
 	va_end(va);
 
 	printascii(buff);
-- 
1.9.1

