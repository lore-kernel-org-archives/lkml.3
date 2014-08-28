Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbaH1RBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:01:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaH1RB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:01:28 -0400
Message-ID: <53FF6066.5020106@infradead.org>
Date: Thu, 28 Aug 2014 10:01:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Jim Davis <jim.epost@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] media/radio: fix radio-miropcm20.c build with io.h
 header file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors in radio-miropcm20.c due to missing header file:

drivers/media/radio/radio-miropcm20.c: In function 'rds_waitread':
drivers/media/radio/radio-miropcm20.c:90:3: error: implicit declaration of function 'inb' [-Werror=implicit-function-declaration]
drivers/media/radio/radio-miropcm20.c: In function 'rds_rawwrite':
drivers/media/radio/radio-miropcm20.c:106:3: error: implicit declaration of function 'outb' [-Werror=implicit-function-declaration]

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/media/radio/radio-miropcm20.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next-20140828/drivers/media/radio/radio-miropcm20.c
===================================================================
--- linux-next-20140828.orig/drivers/media/radio/radio-miropcm20.c
+++ linux-next-20140828/drivers/media/radio/radio-miropcm20.c
@@ -27,6 +27,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <linux/kthread.h>
