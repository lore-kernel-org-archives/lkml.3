Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaF1RAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:00:53 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59945 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaF1RAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:00:51 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-next@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Magnus Damm <damm+renesas@opensource.se>
Subject: [PATCH linux-next] staging: emxx_udc: replace strict_strtol call
Date: Sat, 28 Jun 2014 19:00:23 +0200
Message-Id: <1403974823-23578-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 582e9d37a9a3 'include/linux: remove strict_strto* definitions' has
obsoleted the strict_strtol function. Use kstrtol instead.

This fixes the following compilation error:

  drivers/staging/emxx_udc/emxx_udc.c: In function ‘nbu2ss_drv_set_ep_info’:
  drivers/staging/emxx_udc/emxx_udc.c:3287:3: error: implicit declaration of function ‘strict_strtol’ [-Werror=implicit-function-declaration]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Magnus Damm <damm+renesas@opensource.se>
---

Hi,

This compilation error can be seen with e.g. linux next-20140627 and arm
allmodconfig.

Best regards,

V.

 drivers/staging/emxx_udc/emxx_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index ee0094d..b5c1511 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -3285,7 +3285,7 @@ static void __init nbu2ss_drv_set_ep_info(
 
 		tempbuf[0] = name[2];
 		tempbuf[1] = '\0';
-		res = strict_strtol(tempbuf, 16, &num);
+		res = kstrtol(tempbuf, 16, &num);
 
 		if (num == 0)
 			ep->ep.maxpacket = EP0_PACKETSIZE;
-- 
2.0.0

