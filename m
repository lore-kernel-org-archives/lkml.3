Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaBGMt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:49:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaBGLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/233] [media] nxt200x: increase write buffer size
Date: Fri,  7 Feb 2014 11:45:26 +0000
Message-Id: <1391773652-25214-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit fa1e1de6bb679f2c86da3311bbafee7eaf78f125 upstream.

The buffer size on nxt200x is not enough:

	...
	> Dec 20 10:52:04 rich kernel: [   31.747949] nxt200x: nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
	...

Increase it to 256 bytes.

Reported-by: Rich Freeman <rich0@gentoo.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/nxt200x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index fbca985..4bf0575 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -40,7 +40,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 /* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
+#define MAX_XFER_SIZE  256
 
 #define NXT2002_DEFAULT_FIRMWARE "dvb-fe-nxt2002.fw"
 #define NXT2004_DEFAULT_FIRMWARE "dvb-fe-nxt2004.fw"
-- 
1.8.3.2

