Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3CFGEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:04:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10171 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3CFGE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:04:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Mar 2013 22:04:13 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Tejun Heo'" <tj@kernel.org>, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Wed, 6 Mar 2013 11:33:11 +0530
Subject: RE: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Thread-Topic: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Thread-Index: Ac4Tw5Tl8LnUauaRRFO4J+k+4bUCfQGbCziw
Message-ID: <D958900912E20642BCBC71664EFECE3E6E4F721A54@BGMAIL02.nvidia.com>
References: <009001ce13c3$9504bff0$bf0e3fd0$%han@samsung.com>
In-Reply-To: <009001ce13c3$9504bff0$bf0e3fd0$%han@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Jingoo Han
> Sent: Tuesday, February 26, 2013 7:20 AM
> To: 'Andrew Morton'
> Cc: linux-kernel@vger.kernel.org; 'Tejun Heo'; 'Greg KH'; 'Alessandro
> Zummo'; rtc-linux@googlegroups.com; 'Jingoo Han'
> Subject: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
> 
> These functios allows the driver core to automatically clean up
> any allocation made by rtc drivers. Thus, it simplifies the error
> paths.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v2:
> - Removed unnecessary WARN_ON() of devm_rtc_device_match()
> 
> Changes since v1:
> - Simplified 'if' statements using WARN_ON()
> - Added a description of the return value of devm_rtc_device_register()
> 
>  drivers/rtc/class.c |   70
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/rtc.h |    6 ++++
>  2 files changed, 76 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 9b742d3..b72b40b 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c

> +/**
> + * devm_rtc_device_register - resource managed rtc_device_register()
> + * @name: the name of the device
> + * @dev: the device to register
> + * @ops: the rtc operations structure
> + * @owner: the module owner
> + *
> + * @return a struct rtc on success, or an ERR_PTR on error
> + *
> + * Managed rtc_device_register(). The rtc_device returned from this
> function
> + * are automatically freed on driver detach. See rtc_device_register()
> + * for more information.
> + */
> +
> +struct rtc_device *devm_rtc_device_register(const char *name,
> +					struct device *dev,

As most of devm_* functions use  " struct device *dev" as their first param,
why not this function also modified to be in sync with them?

> +					const struct rtc_class_ops *ops,
> +					struct module *owner)
> +{
> +	struct rtc_device **ptr, *rtc;
