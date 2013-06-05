Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3FER6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:58:11 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:44043 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757107Ab3FERsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:14 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 31/53] Input: atmel_mxt_ts - Add bootloader addresses for new chips
Date: Wed,  5 Jun 2013 18:37:24 +0100
Message-Id: <1370453866-16534-32-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later chips (for example mXT1664S) different mappings for bootloader addresses.
This means that we must look at the family ID to determine which address to
use. There is an additional complication: when we probe and we don't know the
family ID yet, we need to try both possible addresses to find the bootloader.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 125fe2f..06b631b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -397,6 +397,12 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data)
 	switch (appmode) {
 	case 0x4a:
 	case 0x4b:
+		/* Chips after 1664S use different scheme */
+		if (data->info.family_id >= 0xa2) {
+			bootloader = appmode - 0x24;
+			break;
+		}
+		/* Fall through for normal case */
 	case 0x4c:
 	case 0x4d:
 	case 0x5a:
-- 
1.7.10.4

