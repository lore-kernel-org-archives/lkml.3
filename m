Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaIJVgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:36:39 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:48031 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaIJVgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:36:37 -0400
From: hachyang@gmail.com
X-Google-Original-From: ryang@hach.com
To: thierry.reding@gmail.com, linux-pwm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ryang <ryang@hach.com>
Subject: [PATCH 1/1] PWM-atmel: Fixed a bug which set the pwm clock prescaler incorrectly. In the defect code the prescaler was always one more than expected value, which resulted in the pwm output with wrong frequency and duty cycle.
Date: Wed, 10 Sep 2014 15:35:19 -0600
Message-Id: <1410384919-41303-1-git-send-email-ryang@hach.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ryang <ryang@hach.com>

Signed-off-by: ryang <ryang@hach.com>
---
 drivers/pwm/pwm-atmel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 6e700a5..2dca0bf 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -128,7 +128,8 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			return -EINVAL;
 		}
 	}
-
+	/* Need to reduce the prescaler by 1 */
+	pres--;
 	/* Calculate the duty cycles */
 	prd = div;
 	div *= duty_ns;
-- 
1.9.1

