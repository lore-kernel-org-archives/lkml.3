Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab3CLWzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:55:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780Ab3CLWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 21/40] hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality
Date: Tue, 12 Mar 2013 15:43:42 -0700
Message-Id: <20130312223213.775513638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit f366fccd0809f13ba20d64cae3c83f7338c88af7 upstream.

We read the chip ID from the chip, use it to determine if the chip ID provided
to the driver is correct, and report it if wrong. We should also use the
correct chip ID to select supported functionality.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/ltc2978.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -326,7 +326,7 @@ static int ltc2978_probe(struct i2c_clie
 	data->temp_max = 0x7c00;
 	data->temp2_max = 0x7c00;
 
-	switch (id->driver_data) {
+	switch (data->id) {
 	case ltc2978:
 		info->read_word_data = ltc2978_read_word_data;
 		info->pages = 8;


