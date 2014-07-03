Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbaGCPNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:13:16 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:55972 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754485AbaGCPNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:13:13 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 10/15] Input: atmel_mxt_ts - add bootloader addresses for new chips
Date: Thu,  3 Jul 2014 16:01:32 +0100
Message-Id: <1404399697-26484-11-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

Later chips (for example mXT1664S) different mappings for bootloader addresses.
This means that we must look at the family ID to determine which address to
use.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index f9db3e1..5fe3285 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -391,6 +391,12 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data)
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
2.0.1

