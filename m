Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaFWNFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaFWNFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <jdelvare@suse.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 90/93] hwmon: (ntc_thermistor) Fix OF device ID mapping
Date: Mon, 23 Jun 2014 14:03:09 +0100
Message-Id: <1403528592-2163-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit ead82d6792ef5c600d535bca6ec50a4da14ff7c7 upstream.

The mapping from OF device IDs to platform device IDs is wrong.
TYPE_NCPXXWB473 is 0, TYPE_NCPXXWL333 is 1, so
ntc_thermistor_id[TYPE_NCPXXWB473] is { "ncp15wb473", TYPE_NCPXXWB473 }
while
ntc_thermistor_id[TYPE_NCPXXWL333] is { "ncp18wb473", TYPE_NCPXXWB473 }.

So the name is wrong for all but the "ntc,ncp15wb473" entry, and the
type is wrong for the "ntc,ncp15wl333" entry.

So map the entries by index, it is neither elegant nor robust but at
least it is correct.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 9e8269de hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/ntc_thermistor.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 518fc3caff38..2847767e3375 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -44,6 +44,7 @@ struct ntc_compensation {
 	unsigned int	ohm;
 };
 
+/* Order matters, ntc_match references the entries by index */
 static const struct platform_device_id ntc_thermistor_id[] = {
 	{ "ncp15wb473", TYPE_NCPXXWB473 },
 	{ "ncp18wb473", TYPE_NCPXXWB473 },
@@ -163,15 +164,15 @@ static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
 
 static const struct of_device_id ntc_match[] = {
 	{ .compatible = "ntc,ncp15wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[0] },
 	{ .compatible = "ntc,ncp18wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[1] },
 	{ .compatible = "ntc,ncp21wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[2] },
 	{ .compatible = "ntc,ncp03wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[3] },
 	{ .compatible = "ntc,ncp15wl333",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWL333] },
+		.data = &ntc_thermistor_id[4] },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, ntc_match);
-- 
1.9.1

