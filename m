Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaBKTIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:08:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaBKTH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rich Freeman <rich0@gentoo.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 47/79] [media] nxt200x: increase write buffer size
Date: Tue, 11 Feb 2014 11:05:51 -0800
Message-Id: <20140211184722.312199422@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/nxt200x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -40,7 +40,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 /* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
+#define MAX_XFER_SIZE  256
 
 #define NXT2002_DEFAULT_FIRMWARE "dvb-fe-nxt2002.fw"
 #define NXT2004_DEFAULT_FIRMWARE "dvb-fe-nxt2004.fw"


