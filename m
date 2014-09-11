Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaIKMq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:46:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51632 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755432AbaIKMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Axel Lin" <axel.lin@ingics.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.752774590@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 049/131] hwmon: (gpio-fan) Prevent overflow problem
 when writing large limits
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 2565fb05d1e9fc0831f7b1c083bcfcb1cba1f020 upstream.

On platforms with sizeof(int) < sizeof(unsigned long), writing a rpm value
larger than MAXINT will result in unpredictable limit values written to the
chip. Avoid auto-conversion from unsigned long to int to fix the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/gpio-fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -195,7 +195,7 @@ static int get_fan_speed_index(struct gp
 	return -EINVAL;
 }
 
-static int rpm_to_speed_index(struct gpio_fan_data *fan_data, int rpm)
+static int rpm_to_speed_index(struct gpio_fan_data *fan_data, unsigned long rpm)
 {
 	struct gpio_fan_speed *speed = fan_data->speed;
 	int i;

