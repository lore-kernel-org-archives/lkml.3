Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaCETc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:32:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59842 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaCETcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:32:25 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] rtc: pm8xxx: fixup checkpatch/style issues
Date: Wed,  5 Mar 2014 13:29:31 -0600
Message-Id: <1394047776-13827-2-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before performing additional cleanups to this driver, do the easy
cleanups first.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c | 88 +++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index bd76ffe9..772b070 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -53,7 +53,7 @@ struct pm8xxx_rtc {
 	int rtc_read_base;
 	int rtc_write_base;
 	int alarm_rw_base;
-	u8  ctrl_reg;
+	u8 ctrl_reg;
 	struct device *rtc_dev;
 	spinlock_t ctrl_reg_lock;
 };
@@ -63,7 +63,7 @@ struct pm8xxx_rtc {
  * hardware limitation.
  */
 static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-		int base, int count)
+			       int base, int count)
 {
 	int i, rc;
 	struct device *parent = rtc_dd->rtc_dev->parent;
@@ -80,7 +80,7 @@ static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
 }
 
 static int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-		int base, int count)
+				int base, int count)
 {
 	int i, rc;
 	struct device *parent = rtc_dd->rtc_dev->parent;
@@ -126,15 +126,15 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		alarm_enabled = 1;
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-				1);
+					  1);
 		if (rc < 0) {
-			dev_err(dev, "Write to RTC control register "
-								"failed\n");
+			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
 		rtc_dd->ctrl_reg = ctrl_reg;
-	} else
+	} else {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
+	}
 
 	/* Write 0 to Byte[0] */
 	reg = 0;
@@ -146,7 +146,7 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	/* Write Byte[1], Byte[2], Byte[3] */
 	rc = pm8xxx_write_wrapper(rtc_dd, value + 1,
-					rtc_dd->rtc_write_base + 1, 3);
+				  rtc_dd->rtc_write_base + 1, 3);
 	if (rc < 0) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
@@ -162,10 +162,9 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	if (alarm_enabled) {
 		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
 		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-									1);
+					  1);
 		if (rc < 0) {
-			dev_err(dev, "Write to RTC control register "
-								"failed\n");
+			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
 		rtc_dd->ctrl_reg = ctrl_reg;
@@ -186,7 +185,7 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
 	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->rtc_read_base,
-							NUM_8_BIT_RTC_REGS);
+				 NUM_8_BIT_RTC_REGS);
 	if (rc < 0) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
@@ -204,7 +203,8 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (unlikely(reg < value[0])) {
 		rc = pm8xxx_read_wrapper(rtc_dd, value,
-				rtc_dd->rtc_read_base, NUM_8_BIT_RTC_REGS);
+					 rtc_dd->rtc_read_base,
+					 NUM_8_BIT_RTC_REGS);
 		if (rc < 0) {
 			dev_err(dev, "RTC read data register failed\n");
 			return rc;
@@ -222,8 +222,8 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	}
 
 	dev_dbg(dev, "secs = %lu, h:m:s == %d:%d:%d, d/m/y = %d/%d/%d\n",
-				secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
-				tm->tm_mday, tm->tm_mon, tm->tm_year);
+		secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
+		tm->tm_mday, tm->tm_mon, tm->tm_year);
 
 	return 0;
 }
@@ -245,7 +245,7 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-							NUM_8_BIT_RTC_REGS);
+				  NUM_8_BIT_RTC_REGS);
 	if (rc < 0) {
 		dev_err(dev, "Write to RTC ALARM register failed\n");
 		goto rtc_rw_fail;
@@ -253,7 +253,7 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 	ctrl_reg = rtc_dd->ctrl_reg;
 	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
-					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
+				    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
 
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
@@ -264,9 +264,9 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	rtc_dd->ctrl_reg = ctrl_reg;
 
 	dev_dbg(dev, "Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
-				alarm->time.tm_hour, alarm->time.tm_min,
-				alarm->time.tm_sec, alarm->time.tm_mday,
-				alarm->time.tm_mon, alarm->time.tm_year);
+		alarm->time.tm_hour, alarm->time.tm_min,
+		alarm->time.tm_sec, alarm->time.tm_mday,
+		alarm->time.tm_mon, alarm->time.tm_year);
 rtc_rw_fail:
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 	return rc;
@@ -280,7 +280,7 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
 	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-			NUM_8_BIT_RTC_REGS);
+				 NUM_8_BIT_RTC_REGS);
 	if (rc < 0) {
 		dev_err(dev, "RTC alarm time read failed\n");
 		return rc;
@@ -297,9 +297,9 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	}
 
 	dev_dbg(dev, "Alarm set for - h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
-				alarm->time.tm_hour, alarm->time.tm_min,
-				alarm->time.tm_sec, alarm->time.tm_mday,
-				alarm->time.tm_mon, alarm->time.tm_year);
+		alarm->time.tm_hour, alarm->time.tm_min,
+		alarm->time.tm_sec, alarm->time.tm_mday,
+		alarm->time.tm_mon, alarm->time.tm_year);
 
 	return 0;
 }
@@ -313,8 +313,8 @@ static int pm8xxx_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 	ctrl_reg = rtc_dd->ctrl_reg;
-	ctrl_reg = (enable) ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
-				(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
+	ctrl_reg = enable ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
+			    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
 
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
@@ -354,8 +354,8 @@ static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
-		dev_err(rtc_dd->rtc_dev, "Write to RTC control register "
-								"failed\n");
+		dev_err(rtc_dd->rtc_dev,
+			"Write to RTC control register failed\n");
 		goto rtc_alarm_handled;
 	}
 
@@ -364,19 +364,19 @@ static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 
 	/* Clear RTC alarm register */
 	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-						PM8XXX_ALARM_CTRL_OFFSET, 1);
+				 PM8XXX_ALARM_CTRL_OFFSET, 1);
 	if (rc < 0) {
-		dev_err(rtc_dd->rtc_dev, "RTC Alarm control register read "
-								"failed\n");
+		dev_err(rtc_dd->rtc_dev,
+			"RTC Alarm control register read failed\n");
 		goto rtc_alarm_handled;
 	}
 
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_CLEAR;
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-						PM8XXX_ALARM_CTRL_OFFSET, 1);
+				  PM8XXX_ALARM_CTRL_OFFSET, 1);
 	if (rc < 0)
-		dev_err(rtc_dd->rtc_dev, "Write to RTC Alarm control register"
-								" failed\n");
+		dev_err(rtc_dd->rtc_dev,
+			"Write to RTC Alarm control register failed\n");
 
 rtc_alarm_handled:
 	return IRQ_HANDLED;
@@ -409,7 +409,7 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	}
 
 	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
-							"pmic_rtc_base");
+						    "pmic_rtc_base");
 	if (!(rtc_resource && rtc_resource->start)) {
 		dev_err(&pdev->dev, "RTC IO resource absent!\n");
 		return -ENXIO;
@@ -436,31 +436,31 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
 									1);
 		if (rc < 0) {
-			dev_err(&pdev->dev, "Write to RTC control register "
-								"failed\n");
+			dev_err(&pdev->dev,
+				"Write to RTC control register failed\n");
 			return rc;
 		}
 	}
 
 	rtc_dd->ctrl_reg = ctrl_reg;
-	if (rtc_write_enable == true)
+	if (rtc_write_enable)
 		pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
 
 	platform_set_drvdata(pdev, rtc_dd);
 
 	/* Register the RTC device */
 	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
-				&pm8xxx_rtc_ops, THIS_MODULE);
+					       &pm8xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_dd->rtc)) {
 		dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
-					__func__, PTR_ERR(rtc_dd->rtc));
+			__func__, PTR_ERR(rtc_dd->rtc));
 		return PTR_ERR(rtc_dd->rtc);
 	}
 
 	/* Request the alarm IRQ */
 	rc = request_any_context_irq(rtc_dd->rtc_alarm_irq,
-				 pm8xxx_alarm_trigger, IRQF_TRIGGER_RISING,
-				 "pm8xxx_rtc_alarm", rtc_dd);
+				     pm8xxx_alarm_trigger, IRQF_TRIGGER_RISING,
+				     "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
 		return rc;
@@ -505,7 +505,9 @@ static int pm8xxx_rtc_suspend(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops, pm8xxx_rtc_suspend, pm8xxx_rtc_resume);
+static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops,
+			 pm8xxx_rtc_suspend,
+			 pm8xxx_rtc_resume);
 
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

