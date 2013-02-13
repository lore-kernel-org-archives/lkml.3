Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3BMKkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:40:35 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49789 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3BMKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:40:33 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-fbdev@vger.kernel.org
Cc: joe@perches.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] fb: hx8357: Change parameters of the write function to u8
Date: Wed, 13 Feb 2013 11:40:24 +0100
Message-Id: <1360752028-7301-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360752028-7301-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1360752028-7301-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving from void* to u8* removes the need for castslater on in the
function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/video/backlight/hx8357.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index 00925c0..071525c 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -79,8 +79,8 @@ struct hx8357_data {
 };
 
 static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
-				void *txbuf, u16 txlen,
-				void *rxbuf, u16 rxlen)
+				u8 *txbuf, u16 txlen,
+				u8 *rxbuf, u16 rxlen)
 {
 	struct hx8357_data *lcd = lcd_get_data(lcdev);
 	struct spi_message msg;
@@ -102,7 +102,7 @@ static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
 		}
 
 		for (i = 0; i < txlen; i++) {
-			local_txbuf[i] = ((u8 *)txbuf)[i];
+			local_txbuf[i] = txbuf[i];
 			if (i > 0)
 				local_txbuf[i] |= 1 << 8;
 		}
-- 
1.7.10.4

