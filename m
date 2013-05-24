Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3EXX34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:29:56 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.99]:6013 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732Ab3EXX3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:29:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1369438194!8412936!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/14] misc/ep93xx_pwm: use kstrtol instead of strict_strtol
Date: Fri, 24 May 2013 16:28:44 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241628.44544.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strict_strtol is deprecated in favor of kstrtol.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index b5ad0c6..cdb67a9 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -92,7 +92,7 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 	long val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err)
 		return -EINVAL;
 
@@ -145,7 +145,7 @@ static ssize_t ep93xx_pwm_set_duty_percent(struct device *dev,
 	long val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err)
 		return -EINVAL;
 
@@ -179,7 +179,7 @@ static ssize_t ep93xx_pwm_set_invert(struct device *dev,
 	long val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err)
 		return -EINVAL;
 
-- 
1.8.1.4

