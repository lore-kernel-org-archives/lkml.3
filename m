Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaHGOIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:08:10 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12374 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757457AbaHGOH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:07:27 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 2/2] Input: atmel_mxt_ts - mXT224 DMA quirk was fixed in firmware v2.0.AA
Date: Thu,  7 Aug 2014 15:07:18 +0100
Message-Id: <1407420438-6289-3-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407420438-6289-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1407420438-6289-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index da497db..67ea728 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1424,10 +1424,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		switch (object->type) {
 		case MXT_GEN_MESSAGE_T5:
-			if (data->info.family_id == 0x80) {
+			if ((data->info.family_id == 0x80)
+			    && (data->info.version < 0x20)) {
 				/*
-				 * On mXT224 read and discard unused CRC byte
-				 * otherwise DMA reads are misaligned
+				 * On mXT224 firmware versions prior to V2.0
+				 * read and discard unused CRC byte otherwise
+				 * DMA reads are misaligned
 				 */
 				data->T5_msg_size = mxt_obj_size(object);
 			} else {
-- 
1.9.1

