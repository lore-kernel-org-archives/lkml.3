Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3BMKlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:41:12 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49796 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab3BMKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:40:35 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-fbdev@vger.kernel.org
Cc: joe@perches.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] fb: hx8357: Fix inverted parameters for kcalloc
Date: Wed, 13 Feb 2013 11:40:25 +0100
Message-Id: <1360752028-7301-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360752028-7301-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1360752028-7301-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The element size and the number of elements was inverted in the kcalloc
call.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/video/backlight/hx8357.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index 071525c..2691fd6 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -94,7 +94,7 @@ static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
 	if (txlen) {
 		int i;
 
-		local_txbuf = kcalloc(sizeof(*local_txbuf), txlen, GFP_KERNEL);
+		local_txbuf = kcalloc(txlen, sizeof(*local_txbuf), GFP_KERNEL);
 
 		if (!local_txbuf) {
 			dev_err(&lcdev->dev, "Couldn't allocate data buffer.\n");
-- 
1.7.10.4

