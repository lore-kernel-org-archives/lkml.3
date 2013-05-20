Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab3ETPvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:51:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:9852 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab3ETPvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="337074544"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: RE: [PATCH 1/3] Thermal: core: Ask .get_trip_temp() to register
 thermal zone device.
Thread-Topic: [PATCH 1/3] Thermal: core: Ask .get_trip_temp() to register
 thermal zone device.
Thread-Index: AQHOU60xTwmQ0mr0IEud3GqBv44jgpkOPERw
Date: Mon, 20 May 2013 15:51:10 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B909263011023E6@SHSMSX101.ccr.corp.intel.com>
References: <1368870627-1143-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1368870627-1143-1-git-send-email-jonghwa3.lee@samsung.com>
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
> Sent: Saturday, May 18, 2013 5:50 PM
> To: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Zhang, Rui; Eduardo Valentin; Amit
> Dinel Kachhap; Jonghwa Lee; MyungJoo Ham
> Subject: [PATCH 1/3] Thermal: core: Ask .get_trip_temp() to register
> thermal zone device.
> Importance: High
> 
> This patch adds a requirement needing .get_trip_temp() callback
> function for registering thermal zone device. This function is used
> when thermal zone is updated and essential where thermal core handles
> thermal trip based only polling way not hw interrupt.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied to thermal -next.

Thanks,
rui
> ---
>  drivers/thermal/thermal_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c index d755440..f753f48 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1624,7 +1624,7 @@ struct thermal_zone_device
> *thermal_zone_device_register(const char *type,
>  	if (!ops || !ops->get_temp)
>  		return ERR_PTR(-EINVAL);
> 
> -	if (trips > 0 && !ops->get_trip_type)
> +	if (trips > 0 && (!ops->get_trip_type || !ops->get_trip_temp))
>  		return ERR_PTR(-EINVAL);
> 
>  	tz = kzalloc(sizeof(struct thermal_zone_device), GFP_KERNEL);
> --
> 1.7.9.5

