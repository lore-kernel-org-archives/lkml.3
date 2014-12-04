Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaLDOiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:38:50 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51875 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaLDOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:38:49 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] misc: suppress build warning
Date: Thu,  4 Dec 2014 14:38:30 +0000
Message-Id: <1417703910-2474-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes following build warning:

drivers/misc/ioc4.c: In function ‘ioc4_probe’:
drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  period = (end - start) /
                ^
drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
  uint64_t start, end, period;

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Note:- I have compile tested only, and this was noticed
 on linux-next

 drivers/misc/ioc4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 3336ddc..c1f1e6c 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -145,7 +145,7 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 	union ioc4_int_out int_out;
 	union ioc4_gpcr gpcr;
 	unsigned int state, last_state = 1;
-	uint64_t start, end, period;
+	uint64_t start = 0, end, period;
 	unsigned int count = 0;
 
 	/* Enable output */
-- 
1.9.1

