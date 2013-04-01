Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab3DAJui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:50:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20825 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab3DAJuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:50:32 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-1c-515958679072
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 26/27] rtc: rtc-stmp3xxx: use devm_*() functions
Date: Mon, 01 Apr 2013 18:50:30 +0900
Message-id: <002501ce2ebe$58ce1d90$0a6a58b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAASTFg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfd30iMhAg1U94hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlbNx+mL3gi1jF5pcPGBsY3wl1MXJySAiYSDSs2cwKYYtJXLi3ng3EFhJYxihxeqEk
	TM3rz/+AariA4tMZJXo3tzBBOL8YJZZfX8oMUsUmoCbx5cth9i5GDg4RAX2JthYNkBpmgV5G
	iTO9u9khptpK/Dj7HayeU8BO4s3CeYwgtrCAg8TRtdfArmARUJVYumczE4jNC1Q/u6sdyhaU
	+DH5HguIzSygJbF+53EmCFteYvOat8wgeyUE1CUe/dWFOMFI4uUpqAoRiX0v3jGCnCMhcI9d
	4tvxcywQqwQkvk0+xALRKiux6QAzxL+SEgdX3GCZwCgxC8niWUgWz0KyeBaSFQsYWVYxiqYW
	JBcUJ6UXmeoVJ+YWl+al6yXn525ihMTpxB2M9w9YH2JMBlo/kVlKNDkfGOd5JfGGxmZGFqYm
	psZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA83fvgrdiryZaZp9fU
	5Qlw1Vov6n/zfP3fucnz71+3NMj49qyxfvPk39L/Hvcu4by/5Jrkhj2MM32XPVrLtvz4+3SV
	gAev/KdJeaksq27aotH8LzOcycTjb5XsUTWLzsibd4SuiiU9+h9WGJd/VOFc4vXNxQESDokG
	KdOvr7+luYLrQnrbrkBWJZbijERDLeai4kQAsdEtG+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd30iMhAg+OHhCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNi4/TB7wRexis0vHzA2ML4T6mLk5JAQMJF4
	/fkfK4QtJnHh3nq2LkYuDiGB6YwSvZtbmCCcX4wSy68vZQapYhNQk/jy5TB7FyMHh4iAvkRb
	iwZIDbNAL6PEmd7d7CA1QgK2Ej/Ofger5xSwk3izcB4jiC0s4CBxdO01sG0sAqoSS/dsZgKx
	eYHqZ3e1Q9mCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6ECcYSbw8BVUhIrHv
	xTvGCYxCs5AMmoVk0Cwkg2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgNPJPe
	wbiqweIQowAHoxIPb8SFiEAh1sSy4srcQ4wSHMxKIrw+34BCvCmJlVWpRfnxRaU5qcWHGJOB
	/pzILCWanA9MUXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wGip4zc/iX/SQivdx52bsgOcOlTUssKT992IW/fz5qrmWp/rK7vM2lNOfJ45z2nxp2quPZPm
	R7xkO5fbeW2ShlK6TeyVez+uHFoc/ZmNz+T+1etmiSkXyuY9V2y3nXfst83jL2wJE38ZN/1c
	vEEjMqdXwu3B39xNNR9n3NR6/tlvV+Dxm0GN/WpKLMUZiYZazEXFiQCGduTHRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-stmp3xxx.c |   34 +++++++++++-----------------------
 1 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 98f0d3c..0930f27 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -227,11 +227,7 @@ static int stmp3xxx_rtc_remove(struct platform_device *pdev)
 
 	writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
-	free_irq(rtc_data->irq_alarm, &pdev->dev);
-	rtc_device_unregister(rtc_data->rtc);
 	platform_set_drvdata(pdev, NULL);
-	iounmap(rtc_data->io);
-	kfree(rtc_data);
 
 	return 0;
 }
@@ -242,22 +238,20 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 	struct resource *r;
 	int err;
 
-	rtc_data = kzalloc(sizeof *rtc_data, GFP_KERNEL);
+	rtc_data = devm_kzalloc(&pdev->dev, sizeof(*rtc_data), GFP_KERNEL);
 	if (!rtc_data)
 		return -ENOMEM;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "failed to get resource\n");
-		err = -ENXIO;
-		goto out_free;
+		return -ENXIO;
 	}
 
-	rtc_data->io = ioremap(r->start, resource_size(r));
+	rtc_data->io = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!rtc_data->io) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		err = -EIO;
-		goto out_free;
+		return -EIO;
 	}
 
 	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
@@ -265,8 +259,7 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 	if (!(readl(STMP3XXX_RTC_STAT + rtc_data->io) &
 			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
 		dev_err(&pdev->dev, "no device onboard\n");
-		err = -ENODEV;
-		goto out_remap;
+		return -ENODEV;
 	}
 
 	platform_set_drvdata(pdev, rtc_data);
@@ -281,31 +274,26 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 			STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 
-	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc_data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_data->rtc)) {
 		err = PTR_ERR(rtc_data->rtc);
-		goto out_remap;
+		goto out;
 	}
 
-	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt, 0,
-			"RTC alarm", &pdev->dev);
+	err = devm_request_irq(&pdev->dev, rtc_data->irq_alarm,
+			stmp3xxx_rtc_interrupt, 0, "RTC alarm", &pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
 			rtc_data->irq_alarm);
-		goto out_irq_alarm;
+		goto out;
 	}
 
 	stmp3xxx_wdt_register(pdev);
 	return 0;
 
-out_irq_alarm:
-	rtc_device_unregister(rtc_data->rtc);
-out_remap:
+out:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(rtc_data->io);
-out_free:
-	kfree(rtc_data);
 	return err;
 }
 
-- 
1.7.2.5


