Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbaFIWqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:46:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934037AbaFIWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH 3.10 10/40] hwmon: (ntc_thermistor) Fix OF device ID mapping
Date: Mon,  9 Jun 2014 15:48:41 -0700
Message-Id: <20140609224839.542190076@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ntc_thermistor.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -44,6 +44,7 @@ struct ntc_compensation {
 	unsigned int	ohm;
 };
 
+/* Order matters, ntc_match references the entries by index */
 static const struct platform_device_id ntc_thermistor_id[] = {
 	{ "ncp15wb473", TYPE_NCPXXWB473 },
 	{ "ncp18wb473", TYPE_NCPXXWB473 },
@@ -163,15 +164,15 @@ static int ntc_adc_iio_read(struct ntc_t
 
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


