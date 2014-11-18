Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaKRJAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:00:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39426 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaKRJAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:00:11 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-71-546b0a80fe01
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 4/5] rtc: s5m: Add the support for S2MPS13 RTC
Date: Tue, 18 Nov 2014 17:59:42 +0900
Message-id: <1416301183-10478-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSqNvAlR1icP+socWSi1fZLaY+fMJm
	cf3Lc1aL+UfOsVr8mdDKZjHp/gQWi9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbN4OuEim8Xp
	blaLiyu+MDnweeycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYI/isklJzcks
	Sy3St0vgypi64SlTwQKZiiOfrjA3ML4V62Lk5JAQMJG4ceUNG4QtJnHh3nowW0hgKaPE4rt8
	MDUbJ61mhohPZ5RYMEOmi5ELyG5iktjY9IURJMEmoCWx/8UNsGYRgWiJ40+PM4IUMQv0MEm8
	790I5HBwCAs4SFz+6AVSwyKgKvH/zmJWEJtXwFXi1LJWJohlChLLls8Ei3MKuEkcOL4Y6iBX
	idOdB5lBZkoIXGOXuDz1JiPEIAGJb5MPsYDMlxCQldh0gBlijqTEwRU3WCYwCi9gZFjFKJpa
	kFxQnJReZKJXnJhbXJqXrpecn7uJERg5p/89m7CD8d4B60OMAhyMSjy8iVOzQoRYE8uKK3MP
	MZoCbZjILCWanA+Mz7ySeENjMyMLUxNTYyNzSzMlcd7XUj+DhQTSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTB2aa5ava1326Ii6QB7XvZ56ZKybSwrD664IO9yVfrWs0lWrV3+DzaaFGl6Lji9
	M+TnkwsZ2WfMuqU2THF6071axn9W2MEzN1ZN9533XeVFlXjnmYyL6bscl+Twab+dGD9JxD7A
	It/87ePLZ5a592jan/r/I0HbemHVLfX/TF47+YP/7zi8QL5eiaU4I9FQi7moOBEAlPRGZpcC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jQd0GruwQgw87NCyWXLzKbjH14RM2
	i+tfnrNazD9yjtXiz4RWNotJ9yewWLx+YWhxtukNu8X9r0cZLb5d6WCyuLxrDpvF0wkX2SxO
	d7NaXFzxhcmBz2PnrLvsHptWdbJ53Lm2h81j3slAj74tqxg9ps/7yeTxeZNcAHtUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMqRueMhUskKk48ukKcwPjW7EuRk4OCQET
	iY2TVjND2GISF+6tZwOxhQSmM0osmCHTxcgFZDcxSWxs+sIIkmAT0JLY/+IGWJGIQLTE8afH
	GUGKmAV6mCTe924Ecjg4hAUcJC5/9AKpYRFQlfh/ZzEriM0r4CpxalkrE8QyBYlly2eCxTkF
	3CQOHF8MtdhV4nTnQeYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH5jPpHYyr
	GiwOMQpwMCrx8CZOzQoRYk0sK67MPcQowcGsJMJ7rhsoxJuSWFmVWpQfX1Sak1p8iNEU6KqJ
	zFKiyfnApJFXEm9obGJmZGlkbmhhZGyuJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoExUHy7
	wZEbJuWSTT4pjQ1V+Vp912e+7bE8XMjMnfpkubD4qyma+1PlyoRz9J4XTY9sqbeantV69GDw
	3wDdqLpHTQxaQpsXbb7qc3j9ui9y6TnWu/TMagOyV3RU+ap42TyaE6+tn5ScrGduvYnt7eRJ
	exbs6FfgE3PnZLactiL2eFvsni1XrimxFGckGmoxFxUnAgDHS0Gp4gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds only the compatible string for S2MPS13 RTC which is identical
with S2MPS14 RTC driver.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/rtc/rtc-s5m.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 8754c33..e5fdfd3 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -191,6 +191,7 @@ static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
 		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		val &= S5M_ALARM0_STATUS;
 		break;
+	case S2MPS13X:
 	case S2MPS14X:
 		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
 				&val);
@@ -254,6 +255,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	case S5M8767X:
 		data &= ~S5M_RTC_TIME_EN_MASK;
 		break;
+	case S2MPS13X:
 	case S2MPS14X:
 		data |= S2MPS_RTC_RUDR_MASK;
 		break;
@@ -311,7 +313,9 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	u8 data[info->regs->regs_count];
 	int ret;
 
-	if (info->device_type == S2MPS14X) {
+	switch (info->device_type) {
+	case S2MPS13X:
+	case S2MPS14X:
 		ret = regmap_update_bits(info->regmap,
 				info->regs->rtc_udr_update,
 				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
@@ -333,6 +337,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		break;
 
 	case S5M8767X:
+	case S2MPS13X:
 	case S2MPS14X:
 		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
 		break;
@@ -359,6 +364,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		s5m8763_tm_to_data(tm, data);
 		break;
 	case S5M8767X:
+	case S2MPS13X:
 	case S2MPS14X:
 		ret = s5m8767_tm_to_data(tm, data);
 		break;
@@ -406,6 +412,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		break;
 
 	case S5M8767X:
+	case S2MPS13X:
 	case S2MPS14X:
 		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
 		alrm->enabled = 0;
@@ -454,6 +461,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 		break;
 
 	case S5M8767X:
+	case S2MPS13X:
 	case S2MPS14X:
 		for (i = 0; i < info->regs->regs_count; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
@@ -498,6 +506,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 		break;
 
 	case S5M8767X:
+	case S2MPS13X:
 	case S2MPS14X:
 		data[RTC_SEC] |= ALARM_ENABLE_MASK;
 		data[RTC_MIN] |= ALARM_ENABLE_MASK;
@@ -537,6 +546,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		break;
 
 	case S5M8767X:
+	case S2MPS13X:
 	case S2MPS14X:
 		s5m8767_tm_to_data(&alrm->time, data);
 		break;
@@ -641,6 +651,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
 		break;
 
+	case S2MPS13X:
 	case S2MPS14X:
 		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
@@ -678,6 +689,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	switch (pdata->device_type) {
+	case S2MPS13X:
 	case S2MPS14X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
 		info->regs = &s2mps_rtc_regs;
@@ -831,6 +843,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
 
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc",		S5M8767X },
+	{ "s2mps13-rtc",	S2MPS13X },
 	{ "s2mps14-rtc",	S2MPS14X },
 };
 
-- 
1.8.5.5

