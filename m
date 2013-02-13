Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab3BMKkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:40:39 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49802 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933670Ab3BMKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:40:36 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-fbdev@vger.kernel.org
Cc: joe@perches.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] fb: hx8357: Remove useless error message
Date: Wed, 13 Feb 2013 11:40:26 +0100
Message-Id: <1360752028-7301-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360752028-7301-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1360752028-7301-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of a failing allocation, a dump stack will be printed anyway, so
the dev_err is redundant.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/video/backlight/hx8357.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index 2691fd6..7c82561 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -96,10 +96,8 @@ static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
 
 		local_txbuf = kcalloc(txlen, sizeof(*local_txbuf), GFP_KERNEL);
 
-		if (!local_txbuf) {
-			dev_err(&lcdev->dev, "Couldn't allocate data buffer.\n");
+		if (!local_txbuf)
 			return -ENOMEM;
-		}
 
 		for (i = 0; i < txlen; i++) {
 			local_txbuf[i] = txbuf[i];
-- 
1.7.10.4

