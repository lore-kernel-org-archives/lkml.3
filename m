Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab3FCQqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:46:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53820 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752663Ab3FCQqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:46:45 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 7/8] pktcdvd: Convert pr_info to pkt_info
Date: Mon,  3 Jun 2013 09:45:40 -0700
Message-Id: <0f148f9bf2674ca0c0df6dde84924b117957ea40.1370276576.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370276576.git.joe@perches.com>
References: <20130603125057.GB23987@mwanda> <cover.1370276576.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new pkt_info macro to prefix the name to the logging output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index faae94c..f81648c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -75,6 +75,8 @@
 	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
 #define pkt_notice(pd, fmt, ...)					\
 	pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
+#define pkt_info(pd, fmt, ...)						\
+	pr_info("%s: " fmt, pd->name, ##__VA_ARGS__)
 
 #define pkt_dbg(level, pd, fmt, ...)					\
 do {									\
@@ -1563,10 +1565,10 @@ work_to_do:
 
 static void pkt_print_settings(struct pktcdvd_device *pd)
 {
-	pr_info("%s packets, %u blocks, Mode-%c disc\n",
-		pd->settings.fp ? "Fixed" : "Variable",
-		pd->settings.size >> 2,
-		pd->settings.block_mode == 8 ? '1' : '2');
+	pkt_info(pd, "%s packets, %u blocks, Mode-%c disc\n",
+		 pd->settings.fp ? "Fixed" : "Variable",
+		 pd->settings.size >> 2,
+		 pd->settings.block_mode == 8 ? '1' : '2');
 }
 
 static int pkt_mode_sense(struct pktcdvd_device *pd, struct packet_command *cgc, int page_code, int page_control)
@@ -2114,7 +2116,7 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 			return 1;
 	}
 	if (*speed) {
-		pr_info("maximum media speed: %d\n", *speed);
+		pkt_info(pd, "maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
 		pkt_notice(pd, "unknown speed %d for sub-type %d\n", sp, st);
@@ -2241,7 +2243,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
-		pr_info("%lukB available on disc\n", lba << 1);
+		pkt_info(pd, "%lukB available on disc\n", lba << 1);
 	}
 
 	return 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

