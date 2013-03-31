Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3CaPHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 11:07:37 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36294 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3CaPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 11:07:36 -0400
Message-ID: <1364742450.3834.8.camel@phoenix>
Subject: [PATCH] pwm: twl: Return proper error if twl6030_pwm_enable() fails
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 23:07:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return proper error instead of 0 if twl6030_pwm_enable() fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
index ee7fa5d..2782001 100644
--- a/drivers/pwm/pwm-twl.c
+++ b/drivers/pwm/pwm-twl.c
@@ -248,7 +248,7 @@ static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	twl->twl6030_toggle3 = val;
 out:
 	mutex_unlock(&twl->mutex);
-	return 0;
+	return ret;
 }
 
 static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
1.7.10.4



