Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaCOJkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 05:40:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:60255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaCOJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 05:40:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Minchan Kim <minchan@kernel.org>
Subject: [PATCH] zram: include linux/err.h
Date: Sat, 15 Mar 2014 10:40:08 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403151040.09139.arnd@arndb.de>
X-Provags-ID: V02:K0:bxRt/q4TwOqzaM14dTmuLcv/QWy6LvNAH/bP/u/Elpb
 xA/vdbdv4AYRkBDmA2qc6pYPZvX1dXt2mg7xEy2kaHnQdHM/Ff
 b4YKr1ocDUeD67c+jPLuPKNh6ZLxrQXI385wUZgskAJsm8/NDS
 mOCjl5f0up4XXUoZ6mEqzQS6QRqZGk85cPT5E9Sw/LjwkW9SGN
 Aa2L61b9zEB4D67Ga0hiYm0uVs0ioNaY0bl+cX0gidC9GuVNWL
 S8j9li2HEYgI2mUWUPKGrWnAKl4rtiH6F+8aPoKqOvspiosFhl
 lUCYesnM3K57AV7wVvrbXiAQhM/5hc+X0NhQBHmhZyZmfErWCB
 O1OyQAtrSPT2GdBqokBneV8sCKugZc2WZolqyNyLl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zram driver uses the ERR_PTR macro defined in <linux/err.h>
and relies on this header to be included implicitly through
other headers, which is not (always) the case on the ARM architecture.

Adding an explicit #include allows us to build the driver in
all configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 92a83df..3507bef 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -7,6 +7,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/slab.h>
