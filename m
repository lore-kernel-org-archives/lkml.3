Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3ETP6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:58:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:15215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab3ETP6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:58:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="337077127"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: RE: [PATCH 2/3] Thermal: core: Modify temp_crit_show() to use
 proper callback function.
Thread-Topic: [PATCH 2/3] Thermal: core: Modify temp_crit_show() to use
 proper callback function.
Thread-Index: AQHOU6048Z2Tp93+2UCmawOe0oG14JkOPQgA
Date: Mon, 20 May 2013 15:57:45 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092630110240D@SHSMSX101.ccr.corp.intel.com>
References: <1368870656-1183-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1368870656-1183-1-git-send-email-jonghwa3.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
> Sent: Saturday, May 18, 2013 5:51 PM
> To: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Zhang, Rui; Eduardo Valentin; Amit
> Dinel Kachhap; Jonghwa Lee; MyungJoo Ham
> Subject: [PATCH 2/3] Thermal: core: Modify temp_crit_show() to use
> proper callback function.
> Importance: High
> 
> This patch modifies temp_crit_show() which is used to create hwmon's
> sysfs node to use .get_crit_temp callback function of thermal zone
> device rather than .get_trip_temp.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

The problem is that .get_crit_temp is optional for thermal drivers
that has a critical trip point.
At least we do not have such kind of check in thermal core.
Take rcar_thermal driver for example,
It supports critical trip point but it does not have .get_crit_type.

So I'd like to see a fix in rcar thermal driver and thermal core
for this issue, together with this patch.

Thanks,
rui
> ---
>  drivers/thermal/thermal_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c index f753f48..ce4384a 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -924,7 +924,7 @@ temp_crit_show(struct device *dev, struct
> device_attribute *attr,
>  	long temperature;
>  	int ret;
> 
> -	ret = tz->ops->get_trip_temp(tz, 0, &temperature);
> +	ret = tz->ops->get_crit_temp(tz, &temperature);
>  	if (ret)
>  		return ret;
> 
> --
> 1.7.9.5

