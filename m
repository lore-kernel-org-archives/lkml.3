Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbaIOXKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:10:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbaIOWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 142/187] hwmon: (gpio-fan) Prevent overflow problem when writing large limits
Date: Mon, 15 Sep 2014 15:09:12 -0700
Message-Id: <1410818997-9432-143-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 2565fb05d1e9fc0831f7b1c083bcfcb1cba1f020 upstream.

On platforms with sizeof(int) < sizeof(unsigned long), writing a rpm value
larger than MAXINT will result in unpredictable limit values written to the
chip. Avoid auto-conversion from unsigned long to int to fix the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/gpio-fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 73181be..814f7ee 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -173,7 +173,7 @@ static int get_fan_speed_index(struct gpio_fan_data *fan_data)
 	return -ENODEV;
 }
 
-static int rpm_to_speed_index(struct gpio_fan_data *fan_data, int rpm)
+static int rpm_to_speed_index(struct gpio_fan_data *fan_data, unsigned long rpm)
 {
 	struct gpio_fan_speed *speed = fan_data->speed;
 	int i;
-- 
1.9.1

