Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaLHM0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:26:53 -0500
Received: from relay05.alfahosting-server.de ([109.237.142.241]:52843 "EHLO
	relay05.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717AbaLHM0w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:26:52 -0500
X-Spam-DCC: : 
Date: Mon, 8 Dec 2014 13:27:20 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] misc: ioc4: fix variable may be used uninitialized warning
Message-ID: <20141208132720.16356743@frodo>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19748/Mon Dec  8 06:41:21 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning:
drivers/misc/ioc4.c: In function ‘ioc4_probe’:
drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized
in this function [-Wmaybe-uninitialized]
  period = (end - start) /
                ^
drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
  uint64_t start, end, period;
           ^

As far as I can tell 'start' cannot really be used uninitialized
here, but for the sanity of gcc output explicitly initialize it.
Same goes for the 'end' variable.

Signed-off-by: Richard Leitner <dev@g0hl1n.net>
---
Used gcc version was 4.9.1 (Debian 4.9.1-19)
P.S.: I know I'm too late for 3.18 but hopefully it still helps.
---
 drivers/misc/ioc4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 3336ddc..7ec2733 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -145,7 +145,7 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 	union ioc4_int_out int_out;
 	union ioc4_gpcr gpcr;
 	unsigned int state, last_state = 1;
-	uint64_t start, end, period;
+	uint64_t start = 0, end = 0, period;
 	unsigned int count = 0;
 
 	/* Enable output */
-- 
2.1.3

