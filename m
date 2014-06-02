Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaFBFHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:07:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62124 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaFBFHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:07:41 -0400
Date: Mon, 2 Jun 2014 14:06:53 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: dgap: remove bogus null test in dgap_tty_init()
Message-ID: <20140602050653.GA29902@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- The channels array were set to NULL in dgap_found_board().
- Removes redundant null check for channels array in for loop,
if one of the channel cannot be allocated, dgap_tty_init() just returns
an error.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 5556a6e..fcfa061 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1379,12 +1379,10 @@ static int dgap_tty_init(struct board_t *brd)
 	 * when the driver was first loaded.
 	 */
 	for (i = 0; i < brd->nasync; i++) {
-		if (!brd->channels[i]) {
-			brd->channels[i] =
-				kzalloc(sizeof(struct channel_t), GFP_KERNEL);
-			if (!brd->channels[i])
-				return -ENOMEM;
-		}
+		brd->channels[i] =
+			kzalloc(sizeof(struct channel_t), GFP_KERNEL);
+		if (!brd->channels[i])
+			return -ENOMEM;
 	}
 
 	ch = brd->channels[0];
@@ -1398,9 +1396,6 @@ static int dgap_tty_init(struct board_t *brd)
 	/* Set up channel variables */
 	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i], bs++) {
 
-		if (!brd->channels[i])
-			continue;
-
 		spin_lock_init(&ch->ch_lock);
 
 		/* Store all our magic numbers */
-- 
1.7.1

