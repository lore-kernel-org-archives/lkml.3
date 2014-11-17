Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaKQAnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:43:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27864 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaKQAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:43:07 -0500
X-AuditID: cbfee691-f79b86d000004a5a-c6-5469449615a2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
Date: Mon, 17 Nov 2014 09:42:59 +0900
Message-id: <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSoDvNJTPEYFW/qcWSi1fZLaY+fMJm
	cf3Lc1aL+UfOsVr8mdDKZjHp/gQWi7NNb9gt7n89ymjx7UoHk8XlXXPYLJ5OuMhmcbqb1eLi
	ii9MDrweO2fdZffYtKqTzePOtT1sHvNOBnr0bVnF6DF93k8mj8+b5ALYo7hsUlJzMstSi/Tt
	Ergytre0sBUskam4NP8tcwPjR7EuRk4OCQETif1dF1ggbDGJC/fWs3UxcnEICSxllNi27hYz
	TNGlW9uYQGwhgemMEvOP50IUNTFJ7N3TBlbEJqAlsf/FDTYQW0QgWuL40+OMIEXMAp8ZJZ5d
	2sQOkhAWsJOYf3MJ2DoWAVWJe3tvsILYvALOEg07WlghtilILFs+E8zmFHCR2NC8jBlis7PE
	m883wM6TELjELtF79hYTxCABiW+TDwEN5QBKyEpsOgB1taTEwRU3WCYwCi9gZFjFKJpakFxQ
	nJReZKpXnJhbXJqXrpecn7uJERg1p/89m7iD8f4B60OMAhyMSjy8HNYZIUKsiWXFlbmHGE2B
	NkxklhJNzgfGZl5JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYwum5xlOPZafVn3obvKrrLqCH9mjgjPi6bbB9saUlbns3CEPpdQsYxLdntf9iniJ8OX
	AgEDQTPumNMH3fYe+HHDejN3cP8LO4kMI7u7hgFCMxY1S760nn3Qgf39NtXKLV6bEko+nU3Q
	jpvlaVdutnvFJa35N27piTVv5nTRtnp8VL7H0FNWTomlOCPRUIu5qDgRAIVUe+mVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd1pLpkhBie/6VgsuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WS0u
	rvjC5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB7T5/1k8vi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b2lha2giUyFZfmv2VuYPwo1sXIySEhYCJx6dY2
	JghbTOLCvfVsILaQwHRGifnHc7sYuYDsJiaJvXvamEESbAJaEvtf3AArEhGIljj+9DgjSBGz
	wGdGiWeXNrGDJIQF7CTm31zCAmKzCKhK3Nt7gxXE5hVwlmjY0cIKsU1BYtnymWA2p4CLxIbm
	ZcwQm50l3ny+wTaBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCYfCa9g3FVg8Uh
	RgEORiUe3g0WGSFCrIllxZW5hxglOJiVRHiX6GSGCPGmJFZWpRblxxeV5qQWH2I0BbpqIrOU
	aHI+MF3klcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgjFTQv/5G
	Y0/tPL0Jiw++2r+fa/+Nnqwz2y483dqcqRnuYq2ve6Cy++LqhjPnW1bPl5i4dsOvlmV3wmY+
	M7D023/sVNr7NWJTE2/rGlabcp/o4bMW/n/64g/rYpUGXgZHg5tVqR1Mec4cJy+w+Lzd3Sz5
	4e/iz0en3l17Te70VfvQi7qu4R0/pJVYijMSDbWYi4oTAY/jmtffAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds only the compatible string for S2MPS13 clock which is identical
with S2MPS14 clock driver.

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

