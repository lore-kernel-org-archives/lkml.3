Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaDKM77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:59:59 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60981 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbaDKM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:59:58 -0400
Message-ID: <5347E74B.4030801@gmail.com>
Date: Fri, 11 Apr 2014 14:59:55 +0200
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nandini Hanumanthagowda <nandu.hgowda@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: fix bad symbol declaration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With sparse, the following error appears :
  CHECK   drivers/staging/vt6656/aes_ccmp.c
drivers/staging/vt6656/aes_ccmp.c:221:6: warning: symbol 'AESbGenCCMP' was not declared. Should it be static?

Add correct include header in order to have function declaration.

Signed-off-by: Neil 'Superna' Armstrong <superna9999@gmail.com>
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
