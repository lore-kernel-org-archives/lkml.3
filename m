Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3FEMEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:04:45 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:35467 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389Ab3FEMEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:04:44 -0400
From: Matthias Schid <aircrach115@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, sjakub@gmail.com, jonbrett.dev@gmail.com,
        cruz@massive-dynamics.biz, joe@perches.com, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, steffhip@googlemail.com,
        simon.puels@gmail.com, Matthias Schid <aircrach115@gmail.com>
Subject: [PATCH 2/2] staging/asus_oled fixed linebreak and printk issue
Date: Wed,  5 Jun 2013 14:04:32 +0200
Message-Id: <1370433872-25251-1-git-send-email-aircrach115@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130605111512.GW28112@mwanda>
References: <20130605111512.GW28112@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a linebreak within an error message string coding style
issue reported by checkpatch.pl and dev_err format parameters

Signed-off-by: Matthias Schid <aircrach115@gmail.com>
Signed-off-by: Stefan Huber <steffhip@googlemail.com>
Signed-off-by: Simon Puels <simon.puels@gmail.com>
---
 drivers/staging/asus_oled/asus_oled.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 173fb9a..9fe13d0 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -383,10 +383,8 @@ static int append_values(struct asus_oled_dev *odev, uint8_t val, size_t count)
 		}
 
 		if (i >= odev->buf_size) {
-			dev_err(odev->dev, "Buffer overflow! Report a bug:"
-			       "offs: %d >= %d i: %d (x: %d y: %d)\n",
-			       (int) odev->buf_offs, (int) odev->buf_size,
-			       (int) i, (int) x, (int) y);
+			dev_err(odev->dev, "Buffer overflow! Report a bug: offs: %zu >= %zu i: %zu (x: %zu y: %zu)\n",
+			       odev->buf_offs, odev->buf_size, i, x, y);
 			return -EIO;
 		}
 
-- 
1.7.10.4

