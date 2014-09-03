Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbaICJ7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:59:10 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57471 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932611AbaICJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:59:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 33/56] hwmon: (gpio-fan) Prevent overflow problem when writing large limits
Date: Wed,  3 Sep 2014 11:26:52 +0200
Message-Id: <2f8d1a117fe52498e3405a7a693d9aae1cfa4872.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2565fb05d1e9fc0831f7b1c083bcfcb1cba1f020 upstream.

On platforms with sizeof(int) < sizeof(unsigned long), writing a rpm value
larger than MAXINT will result in unpredictable limit values written to the
chip. Avoid auto-conversion from unsigned long to int to fix the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/gpio-fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index b7d6a5704eb2..ee21bdd610ee 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -172,7 +172,7 @@ static int get_fan_speed_index(struct gpio_fan_data *fan_data)
 	return -EINVAL;
 }
 
-static int rpm_to_speed_index(struct gpio_fan_data *fan_data, int rpm)
+static int rpm_to_speed_index(struct gpio_fan_data *fan_data, unsigned long rpm)
 {
 	struct gpio_fan_speed *speed = fan_data->speed;
 	int i;
-- 
2.1.0

