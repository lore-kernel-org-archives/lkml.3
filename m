Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3EaWXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab3EaWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/15] [SCSI] nsp32: use mdelay instead of large udelay constants
Date: Sat,  1 Jun 2013 00:22:41 +0200
Message-Id: <1370038972-2318779-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2imDeWH65yZmK2vLjZbhLeadmBBJsneRY+JyQLdEa2p
 vP19715EFZ0irZmi3e5Nl9iAvX0p5XkILVt6P9yyZ2kXa0Sa4O
 U6WRwVjcqfo9WrjuhQmRf2zQtWorC1x63rGuiEJ0jwqucIIhLQ
 HKi5UtB+93v6uQO1bATj17StFUI0dWVwUFkwGpLbQ2mwfxJl14
 upLee9ha+1NsTzGT77OO8xjkrHVkUtyV9LjBY9PSFQJ5Wr2Dmo
 4lu84gEQPmkTK/NPftwzQmi8rdnEWqmQ8xRJFlebyRkAlq1CfX
 WspQR28v41Jmhe9nBfxNnIpaGTgu/8BfVqm/SfxlaCrhp4qXI6
 tnTlsMPAJMNpjKapR/2EV6Lp5mwM3FTys96Hj6auT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/nsp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 1e3879d..0665f9c 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2899,7 +2899,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME / 1000);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
-- 
1.8.1.2

