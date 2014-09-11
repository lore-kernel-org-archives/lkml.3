Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaIKNIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:08:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588AbaIKNEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sachin Kamat" <sachin.kamat@linaro.org>,
        "T. Mertelj" <tomaz.mertelj@guest.arnes.si>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.529027535@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 037/131] hwmon: (amc6821) Fix return value
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 3499e5b2e14b792fe411302fea3b6fcc4ba40ef2 upstream.

Propagate return value obtained from i2c_smbus_read_byte_data()
instead of hardcoding.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: T. Mertelj <tomaz.mertelj@guest.arnes.si>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/amc6821.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -364,7 +364,7 @@ static ssize_t set_pwm1_enable(
 	if (config < 0) {
 			dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
-			return -EIO;
+			return config;
 	}
 
 	switch (val) {
@@ -673,7 +673,7 @@ static ssize_t set_fan1_div(
 	if (config < 0) {
 		dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
-		return -EIO;
+		return config;
 	}
 	mutex_lock(&data->update_lock);
 	switch (val) {

