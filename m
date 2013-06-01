Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3FAENC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:13:02 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48553 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755021Ab3FAEMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:12:31 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 7/8] pktcdvd: Convert pr_info to pkt_info
Date: Fri, 31 May 2013 21:11:28 -0700
Message-Id: <73553be7ec239a510306ea1d0ecc35ab38b90fa2.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722> <cover.1370048648.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new pkt_info macro to prefix the name to the logging output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3815f01..995d688 100644
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
@@ -1564,10 +1566,10 @@ work_to_do:
 
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
@@ -2115,7 +2117,7 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 			return 1;
 	}
 	if (*speed) {
-		pr_info("maximum media speed: %d\n", *speed);
+		pkt_info(pd, "maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
 		pkt_notice(pd, "unknown speed %d for sub-type %d\n", sp, st);
@@ -2242,7 +2244,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
-		pr_info("%lukB available on disc\n", lba << 1);
+		pkt_info(pd, "%lukB available on disc\n", lba << 1);
 	}
 
 	return 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

