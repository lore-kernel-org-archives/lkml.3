Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3BVCTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:19:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3BVCTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:19:17 -0500
X-AuditID: cbfee68e-b7fc26d000001938-46-5126d5a46e4a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com,
        "'Igor Grinberg'" <grinberg@compulab.co.il>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cb01ce100d$dc282200$94786600$%han@samsung.com>
In-reply-to: <00cb01ce100d$dc282200$94786600$%han@samsung.com>
Subject: [PATCH V2] rtc: rtc-v3020: use gpio_request_array()
Date: Fri, 22 Feb 2013 11:19:15 +0900
Message-id: <008a01ce10a3$02d28db0$0877a910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDdwKC6fcYlQATrOgz+ir+bOZGwAlPYIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ90lV9UCDf5+YLO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZSzunsRbcEqk4OXcvYwPjJYEuRk4OCQETiaOf77JB2GISF+6t
	B7K5OIQEljFKvJ74kgmm6FnrPFaIxCJGiRftfVDObCaJdesWsoNUsQmoSXz5chjI5uAQEdCX
	aGvRAKlhFtjFKLF0Yi8rSI2QgK3EmofXWEBsTgE7iaXz3oPFhQVsJO62PGcGsVkEVCVa5z0E
	m8kLVH/qy30mCFtQ4sfke2C9zAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcTBBU+h
	ykUk9r14xwhyj4TAInaJ5SfuQu0SkPg2+RALRK+sxKYDzBAPS0ocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESW307GG8esD7EmAy0fiKzlGhy
	PjA280riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	MdV+05M/8ircLNdefmmYxThX03+J/FWhdDkVz3PtCjcyBb7lPhLe2fd3Y9DGe+8zcl+4f9j/
	ojFzwoJli1v1un1fnje6+/Db9fYXtcIXL+tc5QiqqxS7/Ghp1TJnEyc1/p22Iif42px4Gos1
	Ux+uvbPnUrvC7/e35to/bl6rxrnG4ZQCz553jkosxRmJhlrMRcWJAPNkhO3DAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO7iq2qBBl3/bSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtLOaawFt0QqTs7dy9jA
	eEmgi5GTQ0LAROJZ6zxWCFtM4sK99WxdjFwcQgKLGCVetPexQjizmSTWrVvIDlLFJqAm8eXL
	YSCbg0NEQF+irUUDpIZZYBejxNKJvWCThARsJdY8vMYCYnMK2EksnfceLC4sYCNxt+U5M4jN
	IqAq0TrvIdhMXqD6U1/uM0HYghI/Jt8D62UW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRF
	BIwkDi54ClUuIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzhyn0nvYFzVYHGIUYCDUYmHt8NbLVCINbGsuDL3EKMEB7OSCK9+KFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84FJJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MFY4synds4rNCnhSUOpp9jk7/mrXwXsPH8dEcczeJj97QfFii8ehvQ88
	E7i2/k/UOK+sMkH2lWv6/4MCW3Juab0/eWy638ZVEpNXvm1o4Ky3mynjsFRlYSnX4Uthzp9/
	WP5wnvNRcPJtrhg7tuzYqWrPqkoP1K15+yJve4tsbG+VddNr7g/S85RYijMSDbWYi4oTAQLM
	TqQgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using gpio_request_array()/gpio_free_array() can make the code
simpler because it can set the direction and initial value
in one shot and the for loop is unnecessary.

Also, struct v3020_gpio is removed, because the struct v3020_gpio
is replaced with struct gpio.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Replace gpio_request_one() with gpio_request_array()

 drivers/rtc/rtc-v3020.c |   37 ++++++++++++-------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index bca5d67..600798c 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -49,18 +49,13 @@ struct v3020_chip_ops {
 #define V3020_RD	2
 #define V3020_IO	3
 
-struct v3020_gpio {
-	const char *name;
-	unsigned int gpio;
-};
-
 struct v3020 {
 	/* MMIO access */
 	void __iomem *ioaddress;
 	int leftshift;
 
 	/* GPIO access */
-	struct v3020_gpio *gpio;
+	struct gpio *gpio;
 
 	struct v3020_chip_ops *ops;
 
@@ -107,48 +102,40 @@ static struct v3020_chip_ops v3020_mmio_ops = {
 	.write_bit	= v3020_mmio_write_bit,
 };
 
-static struct v3020_gpio v3020_gpio[] = {
-	{ "RTC CS", 0 },
-	{ "RTC WR", 0 },
-	{ "RTC RD", 0 },
-	{ "RTC IO", 0 },
+static struct gpio v3020_gpio[] = {
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC CS"},
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC WR"},
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC RD"},
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC IO"},
 };
 
 static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
 			  struct v3020_platform_data *pdata)
 {
-	int i, err;
+	int err;
 
 	v3020_gpio[V3020_CS].gpio = pdata->gpio_cs;
 	v3020_gpio[V3020_WR].gpio = pdata->gpio_wr;
 	v3020_gpio[V3020_RD].gpio = pdata->gpio_rd;
 	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
 
-	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
-		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
-		if (err)
-			goto err_request;
-
-		gpio_direction_output(v3020_gpio[i].gpio, 1);
-	}
+	err = gpio_request_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
+	if (err)
+		goto err_request;
 
 	chip->gpio = v3020_gpio;
 
 	return 0;
 
 err_request:
-	while (--i >= 0)
-		gpio_free(v3020_gpio[i].gpio);
+	gpio_free_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
 
 	return err;
 }
 
 static void v3020_gpio_unmap(struct v3020 *chip)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++)
-		gpio_free(v3020_gpio[i].gpio);
+	gpio_free_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
 }
 
 static void v3020_gpio_write_bit(struct v3020 *chip, unsigned char bit)
-- 
1.7.2.5


