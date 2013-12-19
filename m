Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3LSJcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:32:36 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37713 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3LSJcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:32:33 -0500
Date: Thu, 19 Dec 2013 15:02:22 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, josh@joshtriplett.org
Subject: [PATCH 01/13] drivers: block: Mark the functions as static in
 skd_main.c
Message-ID: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions skd_skmsg_state_to_str() and skd_skreq_state_to_str() as
static in skd_main.c because they are not used outside this file.

This eliminates the following warnings in skd_main.c:
drivers/block/skd_main.c:5272:13: warning: no previous prototype for ‘skd_skmsg_state_to_str’ [-Wmissing-prototypes]
drivers/block/skd_main.c:5284:13: warning: no previous prototype for ‘skd_skreq_state_to_str’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/skd_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 9199c93..eb6e1e0 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5269,7 +5269,7 @@ const char *skd_skdev_state_to_str(enum skd_drvr_state state)
 	}
 }
 
-const char *skd_skmsg_state_to_str(enum skd_fit_msg_state state)
+static const char *skd_skmsg_state_to_str(enum skd_fit_msg_state state)
 {
 	switch (state) {
 	case SKD_MSG_STATE_IDLE:
@@ -5281,7 +5281,7 @@ const char *skd_skmsg_state_to_str(enum skd_fit_msg_state state)
 	}
 }
 
-const char *skd_skreq_state_to_str(enum skd_req_state state)
+static const char *skd_skreq_state_to_str(enum skd_req_state state)
 {
 	switch (state) {
 	case SKD_REQ_STATE_IDLE:
-- 
1.7.9.5

