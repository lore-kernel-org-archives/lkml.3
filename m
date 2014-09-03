Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbaICWWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933912AbaICWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.16 042/125] hwmon: (gpio-fan) Prevent overflow problem when writing large limits
Date: Wed,  3 Sep 2014 15:06:39 -0700
Message-Id: <20140903220624.914324155@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 2565fb05d1e9fc0831f7b1c083bcfcb1cba1f020 upstream.

On platforms with sizeof(int) < sizeof(unsigned long), writing a rpm value
larger than MAXINT will result in unpredictable limit values written to the
chip. Avoid auto-conversion from unsigned long to int to fix the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/gpio-fan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -173,7 +173,7 @@ static int get_fan_speed_index(struct gp
 	return -ENODEV;
 }
 
-static int rpm_to_speed_index(struct gpio_fan_data *fan_data, int rpm)
+static int rpm_to_speed_index(struct gpio_fan_data *fan_data, unsigned long rpm)
 {
 	struct gpio_fan_speed *speed = fan_data->speed;
 	int i;


