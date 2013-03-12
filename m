Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3CLXNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:13:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3CLWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 045/100] hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality
Date: Tue, 12 Mar 2013 15:31:30 -0700
Message-Id: <20130312223127.860019211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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


