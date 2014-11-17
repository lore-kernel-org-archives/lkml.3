Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaKQKTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:19:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39935 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaKQKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:19:33 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-e7-5469cbb2cb94
Message-id: <5469CBB0.5070704@samsung.com>
Date: Mon, 17 Nov 2014 11:19:28 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xK7qbTmeGGNw6zmmx5OJVdoupD5+w
	WVz/8pzVYv6Rc6wWfya0sllMuj+BxeL1C0OLs01v2C3ufz3KaPHtSgeTxeVdc9gsnk64yGZx
	upvV4uKKL0wOfB47Z91l99i0qpPN4861PWwe804GevRtWcXoMX3eTyaPz5vkAtijuGxSUnMy
	y1KL9O0SuDJuL4opWKJQ0bXzAXMD41HJLkZODgkBE4lpm3sYIWwxiQv31rN1MXJxCAksZZT4
	0bAJLCEk8JlRYuFDZxCbV0BLYuq+VcwgNouAqsSxhnWsIDabgIfEtO89YHFRgQiJK2vmMELU
	C0r8mHyPBWSoiEAjo8TTJb/AHGaB04wSaxcsYwKpEhZwkpg0/xMbxLZaiYbVH4C6OTg4BVwk
	pkzXBzGZBdQlpkzJBalgFpCX2LzmLfMERoFZSFbMQqiahaRqASPzKkbR1NLkguKk9FwjveLE
	3OLSvHS95PzcTYyQqPm6g3HpMatDjAIcjEo8vAeKMkOEWBPLiitzDzFKcDArifB+Pg4U4k1J
	rKxKLcqPLyrNSS0+xMjEwSnVwDjxQgNj1L2MT52u/g8sFFxNj+eGtC6//ZfN4e/7jTOMNbk/
	777v7VpVvcdXZMoKrphzf60rDy+deU/BfN+e+sabCtucOypk95VME8jV/Bb6cPuuZIOFRytD
	S7Mrj0yrVDg0h6v/w59C2YkG89g+vjO/saz4TcSNL3mTd+37d8myaEsLP1sbY7gSS3FGoqEW
	c1FxIgCLTj6zeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 01:42, Chanwoo Choi wrote:
> This patch adds only the compatible string for S2MPS13 clock which is identical
> with S2MPS14 clock driver.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/rtc/rtc-s5m.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)

The RTC block looks exactly the same as S2MPS14. I wonder can S2MPS13 be
supported without adding all "+ case S2MPS13X:" here? Maybe pass the
same ID in s5m_rtc_id? This would reduce number of changes to only one line.

Best regards,
Krzysztof


> 
> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
> index 8754c33..e5fdfd3 100644
> --- a/drivers/rtc/rtc-s5m.c
> +++ b/drivers/rtc/rtc-s5m.c
> @@ -191,6 +191,7 @@ static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
>  		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
>  		val &= S5M_ALARM0_STATUS;
>  		break;
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
>  				&val);
> @@ -254,6 +255,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
>  	case S5M8767X:
>  		data &= ~S5M_RTC_TIME_EN_MASK;
>  		break;
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		data |= S2MPS_RTC_RUDR_MASK;
>  		break;
> @@ -311,7 +313,9 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>  	u8 data[info->regs->regs_count];
>  	int ret;
>  
> -	if (info->device_type == S2MPS14X) {
> +	switch (info->device_type) {
> +	case S2MPS13X:
> +	case S2MPS14X:
>  		ret = regmap_update_bits(info->regmap,
>  				info->regs->rtc_udr_update,
>  				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
> @@ -333,6 +337,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
>  		break;
> @@ -359,6 +364,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
>  		s5m8763_tm_to_data(tm, data);
>  		break;
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		ret = s5m8767_tm_to_data(tm, data);
>  		break;
> @@ -406,6 +412,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
>  		alrm->enabled = 0;
> @@ -454,6 +461,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		for (i = 0; i < info->regs->regs_count; i++)
>  			data[i] &= ~ALARM_ENABLE_MASK;
> @@ -498,6 +506,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		data[RTC_SEC] |= ALARM_ENABLE_MASK;
>  		data[RTC_MIN] |= ALARM_ENABLE_MASK;
> @@ -537,6 +546,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		s5m8767_tm_to_data(&alrm->time, data);
>  		break;
> @@ -641,6 +651,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
>  		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
>  		break;
>  
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
>  		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
> @@ -678,6 +689,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	switch (pdata->device_type) {
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		regmap_cfg = &s2mps14_rtc_regmap_config;
>  		info->regs = &s2mps_rtc_regs;
> @@ -831,6 +843,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
>  
>  static const struct platform_device_id s5m_rtc_id[] = {
>  	{ "s5m-rtc",		S5M8767X },
> +	{ "s2mps13-rtc",	S2MPS13X },
>  	{ "s2mps14-rtc",	S2MPS14X },
>  };
>  
> 

