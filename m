Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3CREfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:35:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33703 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab3CREbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:12 -0400
Message-Id: <20130318042146.567423109@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 23/82] hwmon: (pmbus/ltc2978) Use detected chip ID to select supported
 functionality
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit f366fccd0809f13ba20d64cae3c83f7338c88af7 upstream.

We read the chip ID from the chip, use it to determine if the chip ID provided
to the driver is correct, and report it if wrong. We should also use the
correct chip ID to select supported functionality.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/pmbus/ltc2978.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -328,7 +328,7 @@ static int ltc2978_probe(struct i2c_clie
 	data->temp_max = 0x7c00;
 	data->temp2_max = 0x7c00;
 
-	switch (id->driver_data) {
+	switch (data->id) {
 	case ltc2978:
 		info->read_word_data = ltc2978_read_word_data;
 		info->pages = 8;


