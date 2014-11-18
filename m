Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaKRKCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:02:00 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30087 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKRKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:01:58 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-b4-546b1913ae99
Content-transfer-encoding: 8BIT
Message-id: <1416304913.1301.4.camel@AMDC1943>
Subject: Re: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it, lgirdwood@gmail.com, sbkim73@samsung.com,
        sameo@linux.intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 18 Nov 2014 11:01:53 +0100
In-reply-to: <546A9D7D.7040207@samsung.com>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
 <5469CBB0.5070704@samsung.com> <546A9D7D.7040207@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7rCktkhBhs2ylosuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WS0u
	rvjC5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB7T5/1k8vi8SS6APYrLJiU1J7MstUjf
	LoErY/7cNSwFk7Uqvn+6ydrA+F+hi5GTQ0LARGLZmiksELaYxIV769m6GLk4hASWMkpsb53F
	CpLgFRCU+DH5HlARBwezgLzEkUvZIGFmAXWJSfMWMUPUf2aU2PlsCTtEvZ5E186nbCC2sICT
	xKT5n8BsNgFjic3Ll4DZIgIaEjP/XmEEaWYWWMYkceTsK7AFLAKqEmf6TEFqOAW0JSZu/84K
	sWAvo8SZp88ZQWokBJQlGvvdJjAKzEJy3iyE82YhOW8BI/MqRtHU0uSC4qT0XEO94sTc4tK8
	dL3k/NxNjJB4+bKDcfExq0OMAhyMSjy8DRuzQoRYE8uKK3MPMUpwMCuJ8J7rBgrxpiRWVqUW
	5ccXleakFh9iZOLglGpgTN7Sp77ao9V784OWj0e4s1ZLRj9ZEuDutWa2mEvBcYYf0ovsNr69
	YLLIfur7Jee4Wl/7986dpKF+lP+YU+cP39bmttTumfFnnh+J2rL/wuyWjTuM33JIP7t+tbXi
	gu3kaX/fv5lQUNF15dvZm71LzHRbrAIfedwqi/+/7ntL/JoiNUnFggk3vyixFGckGmoxFxUn
	AgA3ID+JdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-18 at 10:14 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> On 11/17/2014 07:19 PM, Krzysztof Kozłowski wrote:
> > On 17.11.2014 01:42, Chanwoo Choi wrote:
> >> This patch adds only the compatible string for S2MPS13 clock which is identical
> >> with S2MPS14 clock driver.
> >>
> >> Cc: Alessandro Zummo <a.zummo@towertech.it>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> ---
> >>  drivers/rtc/rtc-s5m.c | 15 ++++++++++++++-
> >>  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > The RTC block looks exactly the same as S2MPS14. I wonder can S2MPS13 be
> > supported without adding all "+ case S2MPS13X:" here? Maybe pass the
> > same ID in s5m_rtc_id? This would reduce number of changes to only one line.
> 
> I tried to use S2MPS14x type without adding S2MPS13X.
> But, there are two method to probe RTC driver probe.
> First, as you comment, use s5m_rtc_id (in drivers/rtc/rtc-s5m.c) to probe S2MPS13 RTC.
> Second, register mfd devcies for s2mps13 RTC(in drivers/mfd/sec-core.c) to probe S2MPS13 RTC.
> 
> We could support S2MPS13 RTC to modify s5m_rtc_id table in first case as you comment,
> But, We could not support S2MPS13 RTC in second case because S2MPS13 is different from S2MPS14
> and S2MPS13 must have other type form existing S2MPS14x type.

OK, I'm fine with that. The patch looks good so:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> 
> Best Regards,
> Chanwoo Choi
> 
> > 
> > Best regards,
> > Krzysztof
> > 
> > 
> >>
> >> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
> >> index 8754c33..e5fdfd3 100644
> >> --- a/drivers/rtc/rtc-s5m.c
> >> +++ b/drivers/rtc/rtc-s5m.c
> >> @@ -191,6 +191,7 @@ static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
> >>  		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
> >>  		val &= S5M_ALARM0_STATUS;
> >>  		break;
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
> >>  				&val);
> >> @@ -254,6 +255,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
> >>  	case S5M8767X:
> >>  		data &= ~S5M_RTC_TIME_EN_MASK;
> >>  		break;
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		data |= S2MPS_RTC_RUDR_MASK;
> >>  		break;
> >> @@ -311,7 +313,9 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
> >>  	u8 data[info->regs->regs_count];
> >>  	int ret;
> >>  
> >> -	if (info->device_type == S2MPS14X) {
> >> +	switch (info->device_type) {
> >> +	case S2MPS13X:
> >> +	case S2MPS14X:
> >>  		ret = regmap_update_bits(info->regmap,
> >>  				info->regs->rtc_udr_update,
> >>  				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
> >> @@ -333,6 +337,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
> >>  		break;
> >>  
> >>  	case S5M8767X:
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
> >>  		break;
> >> @@ -359,6 +364,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
> >>  		s5m8763_tm_to_data(tm, data);
> >>  		break;
> >>  	case S5M8767X:
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		ret = s5m8767_tm_to_data(tm, data);
> >>  		break;
> >> @@ -406,6 +412,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> >>  		break;
> >>  
> >>  	case S5M8767X:
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
> >>  		alrm->enabled = 0;
> >> @@ -454,6 +461,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
> >>  		break;
> >>  
> >>  	case S5M8767X:
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		for (i = 0; i < info->regs->regs_count; i++)
> >>  			data[i] &= ~ALARM_ENABLE_MASK;
> >> @@ -498,6 +506,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
> >>  		break;
> >>  
> >>  	case S5M8767X:
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		data[RTC_SEC] |= ALARM_ENABLE_MASK;
> >>  		data[RTC_MIN] |= ALARM_ENABLE_MASK;
> >> @@ -537,6 +546,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> >>  		break;
> >>  
> >>  	case S5M8767X:
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		s5m8767_tm_to_data(&alrm->time, data);
> >>  		break;
> >> @@ -641,6 +651,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
> >>  		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
> >>  		break;
> >>  
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
> >>  		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
> >> @@ -678,6 +689,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
> >>  		return -ENOMEM;
> >>  
> >>  	switch (pdata->device_type) {
> >> +	case S2MPS13X:
> >>  	case S2MPS14X:
> >>  		regmap_cfg = &s2mps14_rtc_regmap_config;
> >>  		info->regs = &s2mps_rtc_regs;
> >> @@ -831,6 +843,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
> >>  
> >>  static const struct platform_device_id s5m_rtc_id[] = {
> >>  	{ "s5m-rtc",		S5M8767X },
> >> +	{ "s2mps13-rtc",	S2MPS13X },
> >>  	{ "s2mps14-rtc",	S2MPS14X },
> >>  };
> >>  
> >>
> > 
> > 

