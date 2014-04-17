Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaDQJEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:04:04 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33199 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDQJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:04:01 -0400
From: chihuanqi <chihuanqi@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        nandu.hgowda@gmail.com, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com, himangi774@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        huanqi chi <chihuanqi@gmail.com>
Subject: [PATCH] vt6656/aes_ccmp.c: Fix a sparse "symbol not declared" warning
Date: Thu, 17 Apr 2014 17:03:21 +0800
Message-Id: <1397725401-24923-1-git-send-email-chihuanqi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains as follows:
	drivers/staging/vt6656/aes_ccmp.c:221:6: warning: symbol 'AESbGenCCMP'
was not declared. Should it be static?
In order to suppress the warning, we include the aes_ccmp.h header file
which contains an appropriate extern declaration.

Signed-off-by: huanqi chi <chihuanqi@gmail.com>
---
 drivers/staging/vt6656/aes_ccmp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/aes_ccmp.c b/drivers/staging/vt6656/aes_ccmp.c
index e2bfa8d..a9d5168 100644
--- a/drivers/staging/vt6656/aes_ccmp.c
+++ b/drivers/staging/vt6656/aes_ccmp.c
@@ -32,6 +32,7 @@
 
 #include "device.h"
 #include "80211hdr.h"
+#include "aes_ccmp.h"
 
 /*
  * SBOX Table
-- 
1.7.10.4

