Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaKER1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:27:20 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48745 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932432AbaKER06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:58 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 9/9] serial: 8250_em: Remove out-of-memory message
Date: Wed,  5 Nov 2014 12:26:32 -0500
Message-Id: <1415208392-16189-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kzalloc() already warns if allocation fails; remove duplicate
message.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_em.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index 56c8723..478599d 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -102,10 +102,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "unable to allocate private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->sclk = devm_clk_get(&pdev->dev, "sclk");
 	if (IS_ERR(priv->sclk)) {
-- 
2.1.3

