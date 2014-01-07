Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaAGHAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 02:00:55 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7164 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbaAGHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 02:00:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] pwm: core: Use devm_kzalloc instead of kzalloc
Date: Tue, 7 Jan 2014 14:05:00 +0800
Message-ID: <1389074700-1825-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc instead of kzalloc to free automatically and make
the cleanup paths simpler and the code slightly shorter.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/pwm/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 2ca9504..74c9f9a 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -80,7 +80,6 @@ static void free_pwms(struct pwm_chip *chip)
 
 	bitmap_clear(allocated_pwms, chip->base, chip->npwm);
 
-	kfree(chip->pwms);
 	chip->pwms = NULL;
 }
 
@@ -245,7 +244,9 @@ int pwmchip_add(struct pwm_chip *chip)
 	if (ret < 0)
 		goto out;
 
-	chip->pwms = kzalloc(chip->npwm * sizeof(*pwm), GFP_KERNEL);
+	chip->pwms = devm_kzalloc(chip->dev,
+				  chip->npwm * sizeof(*pwm),
+				  GFP_KERNEL);
 	if (!chip->pwms) {
 		ret = -ENOMEM;
 		goto out;
-- 
1.8.4


