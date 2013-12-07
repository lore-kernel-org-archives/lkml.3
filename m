Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3LGRMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:12:22 -0500
Received: from smtp-out-165.synserver.de ([212.40.185.165]:1040 "EHLO
	smtp-out-151.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758671Ab3LGRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:12:18 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 3230
From: Lars-Peter Clausen <lars@metafoo.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 1/2] pwm: jz4740: Pass device to clk_get()
Date: Sat,  7 Dec 2013 18:13:15 +0100
Message-Id: <1386436396-2307-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to switching the jz4740 clk driver to the common clk framework
make sure to pass the device to clk_get().

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/pwm/pwm-jz4740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index 0a2ede3..a44d890 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -171,7 +171,7 @@ static int jz4740_pwm_probe(struct platform_device *pdev)
 	if (!jz4740)
 		return -ENOMEM;
 
-	jz4740->clk = clk_get(NULL, "ext");
+	jz4740->clk = clk_get(&pdev->dev, "ext");
 	if (IS_ERR(jz4740->clk))
 		return PTR_ERR(jz4740->clk);
 
-- 
1.7.10.4

