Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaGODCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:02:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62663 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbaGODCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:02:22 -0400
Date: Tue, 15 Jul 2014 12:01:06 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] staging: dgap: remove unused case value in
 dgap_parsefile()
Message-ID: <20140715030106.GA14356@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rc is zero, this function will returns with an error and
cannot reach switch-case statement.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 10bd0f2..470ae7b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -6357,10 +6357,6 @@ static int dgap_parsefile(char **in)
 		}
 
 		switch (rc) {
-		case 0:
-			dgap_err("unexpected end of file");
-			return -1;
-
 		case BEGIN:	/* should only be 1 begin */
 			dgap_err("unexpected config_begin\n");
 			return -1;
-- 
1.7.1

