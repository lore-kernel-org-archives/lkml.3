Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3H2Aqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:46:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3H2Aqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:46:32 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-52-521e99e5e159
From: Jingoo Han <jg1.han@samsung.com>
To: Anton Vorontsov <anton@enomsg.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] power: use dev_get_platdata()
Date: Thu, 29 Aug 2013 09:46:29 +0900
Message-id: <001b01cea451$32f97ac0$98ec7040$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6kUTLUEHYba0RHTQiw9yTIUYuEbQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zQ92nM+WCDNb2GFnMWb+GzeLgVk2L
	qQ+fsFm8/jedxWLiysnMFs2L17NZXF54idVi9v3HLBaXd81hc+D0mND/idFj8wotj02rOtk8
	Tsz4zeKxf+4ado+PT2+xeHxZdY3Zo2/LKkaPz5vkAjijuGxSUnMyy1KL9O0SuDK+HjnLXHDw
	CGPFry0nWBsY7y1j7GLk5JAQMJG42PcCyhaTuHBvPVsXIxeHkMAyRonJzbPYYIpOP9nPDpFY
	xCjx4HIXlPOLUeL6j1PMIFVsAmoSX74cZgexRQRCJS71v2ECKWIWmMIksfvMU1aQhLCAoUT3
	86lgY1kEVCXOrdjPAmLzCthKrHm8hh3CFpT4MfkeWJxZQEti87YmVghbXmLzmrdAyziATlKX
	ePRXF2KXnsS15bfZIEpEJPa9eAf1TiuHxMeZrhCrBCS+TT7EAtEqK7HpADNEiaTEwRU3WCYw
	is1CsngWksWzkCyehWTDAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghsdy7g/H2AetD
	jMlA6ycyS4km5wNTQV5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGC0mS1/6WXD5BJ+X3fPl6hPbLjJfsVjNzjjRPuOO6GLTJ/cNNPVaPl7ytAn2
	PZ7mLZQdZrvjuf6M849X9Jx5fPOkecSK0GpTudJay+1Z7JcTE9RfMxbvitp/ua9Rd8IPttvT
	ThrkcfqGdkyRlj1QLXrLVon37ZlJ4TOijvrJ1psdYrJ9/o1pshJLcUaioRZzUXEiAM4xxjD7	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jAd2nM+WCDPZO1LKYs34Nm8XBrZoW
	Ux8+YbN4/W86i8XElZOZLZoXr2ezuLzwEqvF7PuPWSwu75rD5sDpMaH/E6PH5hVaHptWdbJ5
	nJjxm8Vj/9w17B4fn95i8fiy6hqzR9+WVYwenzfJBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPM+HrkLHPBwSOMFb+2nGBtYLy3jLGLkZNDQsBE4vST/ewQtpjEhXvr
	2boYuTiEBBYxSjy43MUO4fxilLj+4xQzSBWbgJrEly+HwTpEBEIlLvW/YQIpYhaYwiSx+8xT
	VpCEsIChRPfzqWwgNouAqsS5FftZQGxeAVuJNY/XsEPYghI/Jt8DizMLaEls3tbECmHLS2xe
	8xZoGQfQSeoSj/7qQuzSk7i2/DYbRImIxL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4FTxTHoH46oGi0OMAhyMSjy8Eb9lg4RYE8uKK3MPMUpw
	MCuJ8E7JlAsS4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgGssriTc0NjEzsjQyszAyMTcn
	TVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYqD0efu/fkpe60d0gGe0aeK35pvtOLN6L4
	9I5/LRGKsbm2ORo9phO3Hbx7Wf5cLP/0eQdrWFprrN9fvbH4+swfPQ5fK6Yfn1Oz7nHruo22
	sRWiS/Q0lju2J1xa/cMivnuCxvePsR+/c28XuRKWkLZCPafd7BjDuq9MjorPa8JYPvqbmbR6
	HVRiKc5INNRiLipOBABlQgK2WQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Rebased on the latest power git tree.
- Added motivation to the commit message
- Fixed bq24190_charger driver.

 drivers/power/88pm860x_battery.c    |    2 +-
 drivers/power/ab8500_btemp.c        |    2 +-
 drivers/power/ab8500_charger.c      |    2 +-
 drivers/power/ab8500_fg.c           |    2 +-
 drivers/power/abx500_chargalg.c     |    2 +-
 drivers/power/avs/smartreflex.c     |    8 ++++----
 drivers/power/bq2415x_charger.c     |    4 ++--
 drivers/power/bq24190_charger.c     |    2 +-
 drivers/power/bq27x00_battery.c     |    4 ++--
 drivers/power/da9030_battery.c      |    2 +-
 drivers/power/da9052-battery.c      |    2 +-
 drivers/power/ds2782_battery.c      |    2 +-
 drivers/power/generic-adc-battery.c |    2 +-
 drivers/power/gpio-charger.c        |    3 ++-
 drivers/power/isp1704_charger.c     |    2 +-
 drivers/power/jz4740-battery.c      |    3 ++-
 drivers/power/lp8727_charger.c      |    2 +-
 drivers/power/max17040_battery.c    |    2 +-
 drivers/power/max17042_battery.c    |    4 ++--
 drivers/power/max8903_charger.c     |    2 +-
 drivers/power/max8925_power.c       |    4 ++--
 drivers/power/pda_power.c           |    2 +-
 drivers/power/pm2301_charger.c      |    3 ++-
 drivers/power/s3c_adc_battery.c     |   10 +++++-----
 drivers/power/sbs-battery.c         |    6 +++---
 drivers/power/smb347-charger.c      |    2 +-
 drivers/power/twl4030_charger.c     |    2 +-
 drivers/power/wm831x_backup.c       |    4 ++--
 drivers/power/wm831x_power.c        |    4 ++--
 drivers/power/wm97xx_battery.c      |   12 ++++++------
 drivers/power/z2_battery.c          |    2 +-
 31 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
index dfcda3a..90ef60c 100644
--- a/drivers/power/88pm860x_battery.c
+++ b/drivers/power/88pm860x_battery.c
@@ -929,7 +929,7 @@ static int pm860x_battery_probe(struct platform_device *pdev)
 	    (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
 	info->dev = &pdev->dev;
 	info->status = POWER_SUPPLY_STATUS_UNKNOWN;
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	mutex_init(&info->lock);
 	platform_set_drvdata(pdev, info);
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 7f9a454..302cb40 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1057,7 +1057,7 @@ static char *supply_interface[] = {
 static int ab8500_btemp_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct ab8500_btemp *di;
 	int irq, i, ret = 0;
 	u8 val;
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a4c4a10..814f9c9 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3438,7 +3438,7 @@ static char *supply_interface[] = {
 static int ab8500_charger_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct ab8500_charger *di;
 	int irq, i, charger_status, ret = 0, ch_stat;
 
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 7549707..1e30392 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -3090,7 +3090,7 @@ static char *supply_interface[] = {
 static int ab8500_fg_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct ab8500_fg *di;
 	int i, irq;
 	int ret = 0;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d27236..2e0d544 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -2046,7 +2046,7 @@ static char *supply_interface[] = {
 static int abx500_chargalg_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct abx500_chargalg *di;
 	int ret = 0;
 
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973b..c989085 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -207,7 +207,7 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
  */
 static int sr_late_init(struct omap_sr *sr_info)
 {
-	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&psr_info->pdev->dev);
 	int ret = 0;
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
@@ -842,7 +842,7 @@ DEFINE_SIMPLE_ATTRIBUTE(pm_sr_fops, omap_sr_autocomp_show,
 static int __init omap_sr_probe(struct platform_device *pdev)
 {
 	struct omap_sr *sr_info;
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&pdev->dev);
 	struct resource *mem, *irq;
 	struct dentry *nvalue_dir;
 	int i, ret = 0;
@@ -984,7 +984,7 @@ err_list_del:
 
 static int omap_sr_remove(struct platform_device *pdev)
 {
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&pdev->dev);
 	struct omap_sr *sr_info;
 
 	if (!pdata) {
@@ -1011,7 +1011,7 @@ static int omap_sr_remove(struct platform_device *pdev)
 
 static void omap_sr_shutdown(struct platform_device *pdev)
 {
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&pdev->dev);
 	struct omap_sr *sr_info;
 
 	if (!pdata) {
diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 0727f92..a17b882 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1509,7 +1509,7 @@ static int bq2415x_probe(struct i2c_client *client,
 	char *name;
 	struct bq2415x_device *bq;
 
-	if (!client->dev.platform_data) {
+	if (!dev_get_platdata(&client->dev)) {
 		dev_err(&client->dev, "platform data not set\n");
 		return -ENODEV;
 	}
@@ -1546,7 +1546,7 @@ static int bq2415x_probe(struct i2c_client *client,
 	bq->autotimer = 0;
 	bq->automode = 0;
 
-	memcpy(&bq->init_data, client->dev.platform_data,
+	memcpy(&bq->init_data, dev_get_platdata(&client->dev),
 			sizeof(bq->init_data));
 
 	bq2415x_reset_chip(bq);
diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index 88de31f..6525c40 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -1359,7 +1359,7 @@ static int bq24190_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct device *dev = &client->dev;
-	struct bq24190_platform_data *pdata = client->dev.platform_data;
+	struct bq24190_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct bq24190_dev_info *bdi;
 	int ret;
 
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b309713..c8d4be5 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -899,7 +899,7 @@ static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
 			bool single)
 {
 	struct device *dev = di->dev;
-	struct bq27000_platform_data *pdata = dev->platform_data;
+	struct bq27000_platform_data *pdata = dev_get_platdata(dev);
 	unsigned int timeout = 3;
 	int upper, lower;
 	int temp;
@@ -932,7 +932,7 @@ static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
 static int bq27000_battery_probe(struct platform_device *pdev)
 {
 	struct bq27x00_device_info *di;
-	struct bq27000_platform_data *pdata = pdev->dev.platform_data;
+	struct bq27000_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	if (!pdata) {
diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index ae6c418..08af5a5 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -494,7 +494,7 @@ static int da9030_battery_charger_init(struct da9030_charger *charger)
 static int da9030_battery_probe(struct platform_device *pdev)
 {
 	struct da9030_charger *charger;
-	struct da9030_battery_info *pdata = pdev->dev.platform_data;
+	struct da9030_battery_info *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	if (pdata == NULL)
diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index f8f4c0f..622267b 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -606,7 +606,7 @@ static s32 da9052_bat_probe(struct platform_device *pdev)
 	bat->health = POWER_SUPPLY_HEALTH_UNKNOWN;
 	bat->nb.notifier_call = da9052_USB_current_notifier;
 
-	pdata = bat->da9052->dev->platform_data;
+	pdata = dev_get_platdata(bat->da9052->dev);
 	if (pdata != NULL && pdata->use_for_apm)
 		bat->psy.use_for_apm = pdata->use_for_apm;
 	else
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 5631748..0155668 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -380,7 +380,7 @@ static struct ds278x_battery_ops ds278x_ops[] = {
 static int ds278x_battery_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
-	struct ds278x_platform_data *pdata = client->dev.platform_data;
+	struct ds278x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct ds278x_info *info;
 	int ret;
 	int num;
diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 59a1421..750bebc 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -240,7 +240,7 @@ static int gab_probe(struct platform_device *pdev)
 {
 	struct gab *adc_bat;
 	struct power_supply *psy;
-	struct gab_platform_data *pdata = pdev->dev.platform_data;
+	struct gab_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	enum power_supply_property *properties;
 	int ret = 0;
 	int chan;
diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 4e858a2..ab1e2fa 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -70,7 +70,8 @@ static enum power_supply_property gpio_charger_properties[] = {
 
 static int gpio_charger_probe(struct platform_device *pdev)
 {
-	const struct gpio_charger_platform_data *pdata = pdev->dev.platform_data;
+	const struct gpio_charger_platform_data *pdata =
+				dev_get_platdata(&pdev->dev);
 	struct gpio_charger *gpio_charger;
 	struct power_supply *charger;
 	int ret;
diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index fc04d19..1046528 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -87,7 +87,7 @@ static inline int isp1704_write(struct isp1704_charger *isp, u32 val, u32 reg)
  */
 static void isp1704_charger_set_power(struct isp1704_charger *isp, bool on)
 {
-	struct isp1704_charger_data	*board = isp->dev->platform_data;
+	struct isp1704_charger_data	*board = dev_get_platdata(isp->dev);
 
 	if (board && board->set_power)
 		board->set_power(on);
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index d9686aa..d9ea2c6 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -241,7 +241,8 @@ static void jz_battery_work(struct work_struct *work)
 static int jz_battery_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct jz_battery_platform_data *pdata = pdev->dev.parent->platform_data;
+	struct jz_battery_platform_data *pdata =
+			dev_get_platdata(pdev->dev.parent);
 	struct jz_battery *jz_battery;
 	struct power_supply *battery;
 	struct resource *mem;
diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 32de636..1001b90 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -556,7 +556,7 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 
 	pchg->client = cl;
 	pchg->dev = &cl->dev;
-	pchg->pdata = cl->dev.platform_data;
+	pchg->pdata = dev_get_platdata(&cl->dev);
 	i2c_set_clientdata(cl, pchg);
 
 	mutex_init(&pchg->xfer_lock);
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index c7ff6d6..31b524c7 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -212,7 +212,7 @@ static int max17040_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->client = client;
-	chip->pdata = client->dev.platform_data;
+	chip->pdata = dev_get_platdata(&client->dev);
 
 	i2c_set_clientdata(client, chip);
 
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index d664ef5..aed1e95 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -657,7 +657,7 @@ max17042_get_pdata(struct device *dev)
 	struct max17042_platform_data *pdata;
 
 	if (!np)
-		return dev->platform_data;
+		return dev_get_platdata(dev);
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -678,7 +678,7 @@ max17042_get_pdata(struct device *dev)
 static struct max17042_platform_data *
 max17042_get_pdata(struct device *dev)
 {
-	return dev->platform_data;
+	return dev_get_platdata(dev);
 }
 #endif
 
diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 08f0d79..5b99ccc 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -183,7 +183,7 @@ static int max8903_probe(struct platform_device *pdev)
 {
 	struct max8903_data *data;
 	struct device *dev = &pdev->dev;
-	struct max8903_pdata *pdata = pdev->dev.platform_data;
+	struct max8903_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int ret = 0;
 	int gpio;
 	int ta_in = 0;
diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b4513f2..318378a 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -441,7 +441,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 	struct max8925_power_pdata *pdata;
 
 	if (!nproot)
-		return pdev->dev.platform_data;
+		return dev_get_platdata(&pdev->dev);
 
 	np = of_find_node_by_name(nproot, "charger");
 	if (!np) {
@@ -472,7 +472,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 static struct max8925_power_pdata *
 max8925_power_dt_init(struct platform_device *pdev)
 {
-	return pdev->dev.platform_data;
+	return dev_get_platdata(&pdev->dev);
 }
 #endif
 
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 0c52e2a..da96140 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -273,7 +273,7 @@ static int pda_power_probe(struct platform_device *pdev)
 		goto wrongid;
 	}
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->init) {
 		ret = pdata->init(dev);
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 1c0bfcb..129a82c 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1001,7 +1001,8 @@ static const struct dev_pm_ops pm2xxx_pm_ops = {
 static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		const struct i2c_device_id *id)
 {
-	struct pm2xxx_platform_data *pl_data = i2c_client->dev.platform_data;
+	struct pm2xxx_platform_data *pl_data =
+			dev_get_platdata(&i2c_client->dev);
 	struct pm2xxx_charger *pm2;
 	int ret = 0;
 	u8 val;
diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index 5948ce0..eba6596 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -292,7 +292,7 @@ static irqreturn_t s3c_adc_bat_charged(int irq, void *dev_id)
 static int s3c_adc_bat_probe(struct platform_device *pdev)
 {
 	struct s3c_adc_client	*client;
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	client = s3c_adc_register(pdev, NULL, NULL, 0);
@@ -315,7 +315,7 @@ static int s3c_adc_bat_probe(struct platform_device *pdev)
 		goto err_reg_main;
 	if (pdata->backup_volt_mult) {
 		backup_bat.client = client;
-		backup_bat.pdata = pdev->dev.platform_data;
+		backup_bat.pdata = dev_get_platdata(&pdev->dev);
 		backup_bat.volt_value = -1;
 		ret = power_supply_register(&pdev->dev, &backup_bat.psy);
 		if (ret)
@@ -370,7 +370,7 @@ err_reg_main:
 static int s3c_adc_bat_remove(struct platform_device *pdev)
 {
 	struct s3c_adc_client *client = platform_get_drvdata(pdev);
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 
 	power_supply_unregister(&main_bat.psy);
 	if (pdata->backup_volt_mult)
@@ -395,7 +395,7 @@ static int s3c_adc_bat_remove(struct platform_device *pdev)
 static int s3c_adc_bat_suspend(struct platform_device *pdev,
 	pm_message_t state)
 {
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->gpio_charge_finished >= 0) {
 		if (device_may_wakeup(&pdev->dev))
@@ -412,7 +412,7 @@ static int s3c_adc_bat_suspend(struct platform_device *pdev,
 
 static int s3c_adc_bat_resume(struct platform_device *pdev)
 {
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->gpio_charge_finished >= 0) {
 		if (device_may_wakeup(&pdev->dev))
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index b5f2a76..05fa847 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -617,7 +617,7 @@ static struct sbs_platform_data *sbs_of_populate_pdata(
 		struct i2c_client *client)
 {
 	struct device_node *of_node = client->dev.of_node;
-	struct sbs_platform_data *pdata = client->dev.platform_data;
+	struct sbs_platform_data *pdata = dev_get_platdata(&client->dev);
 	enum of_gpio_flags gpio_flags;
 	int rc;
 	u32 prop;
@@ -671,7 +671,7 @@ of_out:
 static struct sbs_platform_data *sbs_of_populate_pdata(
 	struct i2c_client *client)
 {
-	return client->dev.platform_data;
+	return dev_get_platdata(&client->dev);
 }
 #endif
 
@@ -679,7 +679,7 @@ static int sbs_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct sbs_info *chip;
-	struct sbs_platform_data *pdata = client->dev.platform_data;
+	struct sbs_platform_data *pdata = dev_get_platdata(&client->dev);
 	int rc;
 	int irq;
 	char *name;
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index acf84e8..c518ddd 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -1197,7 +1197,7 @@ static int smb347_probe(struct i2c_client *client,
 	struct smb347_charger *smb;
 	int ret;
 
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	if (!pdata)
 		return -EINVAL;
 
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index d98abe9..39f621b 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -498,7 +498,7 @@ static enum power_supply_property twl4030_charger_props[] = {
 static int __init twl4030_bci_probe(struct platform_device *pdev)
 {
 	struct twl4030_bci *bci;
-	struct twl4030_bci_platform_data *pdata = pdev->dev.platform_data;
+	struct twl4030_bci_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 	u32 reg;
 
diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index 56fb509..9a4fa61 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -44,7 +44,7 @@ static int wm831x_backup_read_voltage(struct wm831x *wm831x,
 
 static void wm831x_config_backup(struct wm831x *wm831x)
 {
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_backup_pdata *pdata;
 	int ret, reg;
 
@@ -164,7 +164,7 @@ static enum power_supply_property wm831x_backup_props[] = {
 static int wm831x_backup_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_backup *devdata;
 	struct power_supply *backup;
 	int ret;
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 3bed2f5..e7414fc 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -215,7 +215,7 @@ static void wm831x_battey_apply_config(struct wm831x *wm831x,
 
 static void wm831x_config_battery(struct wm831x *wm831x)
 {
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_battery_pdata *pdata;
 	int ret, reg1, reg2;
 
@@ -492,7 +492,7 @@ static irqreturn_t wm831x_pwr_src_irq(int irq, void *data)
 static int wm831x_power_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_power *power;
 	struct power_supply *usb;
 	struct power_supply *battery;
diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 58f7348..674bff4 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -32,7 +32,7 @@ static enum power_supply_property *prop;
 
 static unsigned long wm97xx_read_bat(struct power_supply *bat_ps)
 {
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	return wm97xx_read_aux_adc(dev_get_drvdata(bat_ps->dev->parent),
@@ -42,7 +42,7 @@ static unsigned long wm97xx_read_bat(struct power_supply *bat_ps)
 
 static unsigned long wm97xx_read_temp(struct power_supply *bat_ps)
 {
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	return wm97xx_read_aux_adc(dev_get_drvdata(bat_ps->dev->parent),
@@ -54,7 +54,7 @@ static int wm97xx_bat_get_property(struct power_supply *bat_ps,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val)
 {
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	switch (psp) {
@@ -105,7 +105,7 @@ static void wm97xx_bat_external_power_changed(struct power_supply *bat_ps)
 static void wm97xx_bat_update(struct power_supply *bat_ps)
 {
 	int old_status = bat_status;
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	mutex_lock(&work_lock);
@@ -167,7 +167,7 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 	int ret = 0;
 	int props = 1;	/* POWER_SUPPLY_PROP_PRESENT */
 	int i = 0;
-	struct wm97xx_pdata *wmdata = dev->dev.platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(&dev->dev);
 	struct wm97xx_batt_pdata *pdata;
 
 	if (!wmdata) {
@@ -265,7 +265,7 @@ err:
 
 static int wm97xx_bat_remove(struct platform_device *dev)
 {
-	struct wm97xx_pdata *wmdata = dev->dev.platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(&dev->dev);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	if (pdata && gpio_is_valid(pdata->charge_gpio)) {
diff --git a/drivers/power/z2_battery.c b/drivers/power/z2_battery.c
index 814d2e3..5801d37 100644
--- a/drivers/power/z2_battery.c
+++ b/drivers/power/z2_battery.c
@@ -186,7 +186,7 @@ static int z2_batt_probe(struct i2c_client *client,
 	int ret = 0;
 	int props = 1;	/* POWER_SUPPLY_PROP_PRESENT */
 	struct z2_charger *charger;
-	struct z2_battery_info *info = client->dev.platform_data;
+	struct z2_battery_info *info = dev_get_platdata(&client->dev);
 
 	if (info == NULL) {
 		dev_err(&client->dev,
-- 
1.7.10.4


