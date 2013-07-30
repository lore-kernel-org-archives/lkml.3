Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3G3H4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:56:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40794 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3G3H4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:56:47 -0400
X-AuditID: cbfee68e-b7f276d000002279-f3-51f771bd2e6b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 02/35] rtc: use dev_get_platdata()
Date: Tue, 30 Jul 2013 16:56:44 +0900
Message-id: <003401ce8cfa$55bc00a0$013401e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6M+kCoGkQC6YkIRWaRqNbENrn53w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd29hd8DDU5tEbVYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4+OPM6wFU2sqbu/ma2CckdHFyMEhIWAi8eFIYBcjJ5ApJnHh3nq2LkYuDiGBZYwS
	O3Z+ZYepWfM+DCK+iFHi2fl97BDOL0aJud2PGUG62QTUJL58OQzWICKgL9HWogFSwyzQyyhx
	pnc3O0iNsICRxLczS1hAbBYBVYlJx+Yygdi8ApYSJ29cZoSwBSV+TL4HVsMsoCWxfudxJghb
	XmLzmrfMEJcqSOw4+xqsXkRAT2Lr1W2MEDUiEvtevGMEWSwhcIpd4um6fWwQywQkvk0+xALx
	jazEpgNQcyQlDq64wTKBUWwWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvX
	S87P3cQIibu+HYw3D1gfYkwGWj+RWUo0OR8Yt3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcK
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYEwpnBYYuePARdd1N6fd4LB70vGzZBr7+T+R4lOe
	+rDpPXsx+ZOMt/zBZ39rt8XGm0RzhjEVcfu81mTeuY1xtemLJTw9Rs1vnlpYKV9j6d1/4KVt
	Qg3HPGHDp/mPVfbWFLU8n10o84o7wiLI9sN7vmYxkYiYi3qqRwx8BQM+BU84cW0R559LnUos
	xRmJhlrMRcWJAOb3iQ3RAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd29hd8DDY5s4LdYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePjjzOsBVNrKm7v5mtgnJHRxcjBISFgIrHm
	fVgXIyeQKSZx4d56ti5GLg4hgUWMEs/O72OHcH4xSsztfswIUsUmoCbx5cthdpBmEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBYwkvp1ZwgJiswioSkw6NpcJxOYVsJQ4eeMyI4QtKPFj8j2wGmYB
	LYn1O48zQdjyEpvXvGWGuEhBYsfZ12D1IgJ6EluvbmOEqBGR2PfiHeMERoFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHNfPpHcwrmqwOMQowMGoxMO7oeBb
	oBBrYllxZe4hRgkOZiURXpYbQCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OB6acvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgrJih7ma8i63m/72Nx36K
	91/k7+lwmHry9HF5F4WvklaMy05qT/3pKnZ+b/MSmRvlz8N+X3Q44XXl4FGBB2sbq/+9NMiY
	f9OQ6/CUDR6KzqsfJz5pm+L7qOXxvKdvXq57wJtn0bV8p9GB4nnLJGoe8ZqfL2Q0tjZ+muPT
	X/h0m/h+vdwTnScu3FdiKc5INNRiLipOBADJJGunLwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-88pm80x.c         |    8 ++++----
 drivers/rtc/rtc-88pm860x.c        |    2 +-
 drivers/rtc/rtc-cmos.c            |    2 +-
 drivers/rtc/rtc-da9055.c          |    2 +-
 drivers/rtc/rtc-ds1305.c          |    2 +-
 drivers/rtc/rtc-ds1307.c          |    2 +-
 drivers/rtc/rtc-ds2404.c          |    2 +-
 drivers/rtc/rtc-ep93xx.c          |    6 +++---
 drivers/rtc/rtc-hid-sensor-time.c |    4 ++--
 drivers/rtc/rtc-m48t59.c          |   20 ++++++++++----------
 drivers/rtc/rtc-m48t86.c          |    8 ++++----
 drivers/rtc/rtc-pcf2123.c         |    2 +-
 drivers/rtc/rtc-rs5c348.c         |    4 ++--
 drivers/rtc/rtc-sh.c              |    5 +++--
 drivers/rtc/rtc-v3020.c           |    2 +-
 15 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 354c937..0916089 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -251,14 +251,15 @@ static SIMPLE_DEV_PM_OPS(pm80x_rtc_pm_ops, pm80x_rtc_suspend, pm80x_rtc_resume);
 static int pm80x_rtc_probe(struct platform_device *pdev)
 {
 	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm80x_platform_data *pm80x_pdata;
+	struct pm80x_platform_data *pm80x_pdata =
+				dev_get_platdata(pdev->dev.parent);
 	struct pm80x_rtc_pdata *pdata = NULL;
 	struct pm80x_rtc_info *info;
 	struct rtc_time tm;
 	unsigned long ticks = 0;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (pdata == NULL)
 		dev_warn(&pdev->dev, "No platform data!\n");
 
@@ -326,8 +327,7 @@ static int pm80x_rtc_probe(struct platform_device *pdev)
 	regmap_update_bits(info->map, PM800_RTC_CONTROL, PM800_RTC1_USE_XO,
 			   PM800_RTC1_USE_XO);
 
-	if (pdev->dev.parent->platform_data) {
-		pm80x_pdata = pdev->dev.parent->platform_data;
+	if (pm80x_pdata) {
 		pdata = pm80x_pdata->rtc;
 		if (pdata)
 			info->rtc_dev->dev.platform_data = &pdata->rtc_wakeup;
diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 4e30c85..81650484 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -316,7 +316,7 @@ static int pm860x_rtc_probe(struct platform_device *pdev)
 	unsigned long ticks = 0;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_rtc_info),
 			    GFP_KERNEL);
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index be06d71..91a4957 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -595,7 +595,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 static int INITSECTION
 cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 {
-	struct cmos_rtc_board_info	*info = dev->platform_data;
+	struct cmos_rtc_board_info	*info = dev_get_platdata(dev);
 	int				retval = 0;
 	unsigned char			rtc_control;
 	unsigned			address_space;
diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index e00642b..48cb2ac3 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -278,7 +278,7 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	rtc->da9055 = dev_get_drvdata(pdev->dev.parent);
-	pdata = rtc->da9055->dev->platform_data;
+	pdata = dev_get_platdata(rtc->da9055->dev);
 	platform_set_drvdata(pdev, rtc);
 
 	ret = da9055_rtc_device_init(rtc->da9055, pdata);
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index dd6170a..80f3237 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -606,7 +606,7 @@ static int ds1305_probe(struct spi_device *spi)
 	struct ds1305			*ds1305;
 	int				status;
 	u8				addr, value;
-	struct ds1305_platform_data	*pdata = spi->dev.platform_data;
+	struct ds1305_platform_data	*pdata = dev_get_platdata(&spi->dev);
 	bool				write_ctrl = false;
 
 	/* Sanity check board setup data.  This may be hooked up
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index ca18fd1..9843aa0 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -672,7 +672,7 @@ static int ds1307_probe(struct i2c_client *client,
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
 	unsigned char		*buf;
-	struct ds1307_platform_data *pdata = client->dev.platform_data;
+	struct ds1307_platform_data *pdata = dev_get_platdata(&client->dev);
 	static const int	bbsqi_bitpos[] = {
 		[ds_1337] = 0,
 		[ds_1339] = DS1339_BIT_BBSQI,
diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index 2ca5a23..fc209dc 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -224,7 +224,7 @@ static const struct rtc_class_ops ds2404_rtc_ops = {
 
 static int rtc_probe(struct platform_device *pdev)
 {
-	struct ds2404_platform_data *pdata = pdev->dev.platform_data;
+	struct ds2404_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct ds2404 *chip;
 	int retval = -EBUSY;
 
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 549b3c3..99b5e11 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -42,7 +42,7 @@ struct ep93xx_rtc {
 static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 				unsigned short *delete)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 	unsigned long comp;
 
 	comp = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_SWCOMP);
@@ -60,7 +60,7 @@ static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 
 static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 	unsigned long time;
 
 	 time = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
@@ -71,7 +71,7 @@ static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int ep93xx_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 
 	__raw_writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);
 	return 0;
diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index b5a2874..8c37c4e 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -236,7 +236,7 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_sensor_hub_device *hsdev = dev_get_platdata(&pdev->dev);
 	struct hid_time_state *time_state = devm_kzalloc(&pdev->dev,
 		sizeof(struct hid_time_state), GFP_KERNEL);
 
@@ -289,7 +289,7 @@ static int hid_time_probe(struct platform_device *pdev)
 
 static int hid_time_remove(struct platform_device *pdev)
 {
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_sensor_hub_device *hsdev = dev_get_platdata(&pdev->dev);
 
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index fcb0329..11880c1 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -68,7 +68,7 @@ m48t59_mem_readb(struct device *dev, u32 ofs)
 static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val;
@@ -111,7 +111,7 @@ static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val = 0;
@@ -158,7 +158,7 @@ static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
 static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	unsigned long flags;
@@ -205,7 +205,7 @@ static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	u8 mday, hour, min, sec;
@@ -266,7 +266,7 @@ static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int m48t59_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 
@@ -283,7 +283,7 @@ static int m48t59_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val;
@@ -304,7 +304,7 @@ static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
 {
 	struct device *dev = (struct device *)dev_id;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	u8 event;
 
@@ -340,7 +340,7 @@ static ssize_t m48t59_nvram_read(struct file *filp, struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	ssize_t cnt = 0;
 	unsigned long flags;
@@ -360,7 +360,7 @@ static ssize_t m48t59_nvram_write(struct file *filp, struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	ssize_t cnt = 0;
 	unsigned long flags;
@@ -385,7 +385,7 @@ static struct bin_attribute m48t59_nvram_attr = {
 
 static int m48t59_rtc_probe(struct platform_device *pdev)
 {
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = NULL;
 	struct resource *res;
 	int ret = -ENOMEM;
diff --git a/drivers/rtc/rtc-m48t86.c b/drivers/rtc/rtc-m48t86.c
index 2d30314..32f64c9 100644
--- a/drivers/rtc/rtc-m48t86.c
+++ b/drivers/rtc/rtc-m48t86.c
@@ -46,7 +46,7 @@ static int m48t86_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -84,7 +84,7 @@ static int m48t86_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -123,7 +123,7 @@ static int m48t86_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -147,7 +147,7 @@ static const struct rtc_class_ops m48t86_rtc_ops = {
 static int m48t86_rtc_probe(struct platform_device *dev)
 {
 	unsigned char reg;
-	struct m48t86_ops *ops = dev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&dev->dev);
 	struct rtc_device *rtc;
 
 	rtc = devm_rtc_device_register(&dev->dev, "m48t86",
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 1725b50..d1953bb 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -327,7 +327,7 @@ kfree_exit:
 
 static int pcf2123_remove(struct spi_device *spi)
 {
-	struct pcf2123_plat_data *pdata = spi->dev.platform_data;
+	struct pcf2123_plat_data *pdata = dev_get_platdata(&spi->dev);
 	int i;
 
 	if (pdata) {
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index f7a90a1..090a101 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -64,7 +64,7 @@ static int
 rs5c348_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct rs5c348_plat_data *pdata = spi->dev.platform_data;
+	struct rs5c348_plat_data *pdata = dev_get_platdata(&spi->dev);
 	u8 txbuf[5+7], *txp;
 	int ret;
 
@@ -100,7 +100,7 @@ static int
 rs5c348_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct rs5c348_plat_data *pdata = spi->dev.platform_data;
+	struct rs5c348_plat_data *pdata = dev_get_platdata(&spi->dev);
 	u8 txbuf[5], rxbuf[7];
 	int ret;
 
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 6d87e26..d0d2b04 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -649,8 +649,9 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 	clk_enable(rtc->clk);
 
 	rtc->capabilities = RTC_DEF_CAPABILITIES;
-	if (pdev->dev.platform_data) {
-		struct sh_rtc_platform_info *pinfo = pdev->dev.platform_data;
+	if (dev_get_platdata(&pdev->dev)) {
+		struct sh_rtc_platform_info *pinfo =
+			dev_get_platdata(&pdev->dev);
 
 		/*
 		 * Some CPUs have special capabilities in addition to the
diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index d07d898..25222cd 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -303,7 +303,7 @@ static const struct rtc_class_ops v3020_rtc_ops = {
 
 static int rtc_probe(struct platform_device *pdev)
 {
-	struct v3020_platform_data *pdata = pdev->dev.platform_data;
+	struct v3020_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct v3020 *chip;
 	int retval = -EBUSY;
 	int i;
-- 
1.7.10.4


