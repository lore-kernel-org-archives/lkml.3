Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3CFRml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:42:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48881 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3CFRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:42:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,795,1355126400"; 
   d="scan'208";a="27928801"
Message-ID: <5137800F.1000702@codeaurora.org>
Date: Wed, 06 Mar 2013 09:42:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Tejun Heo'" <tj@kernel.org>, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
References: <009001ce13c3$9504bff0$bf0e3fd0$%han@samsung.com> <D958900912E20642BCBC71664EFECE3E6E4F721A54@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E4F721A54@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 22:03, Venu Byravarasu wrote:
>
>> +/**
>> + * devm_rtc_device_register - resource managed rtc_device_register()
>> + * @name: the name of the device
>> + * @dev: the device to register
>> + * @ops: the rtc operations structure
>> + * @owner: the module owner
>> + *
>> + * @return a struct rtc on success, or an ERR_PTR on error
>> + *
>> + * Managed rtc_device_register(). The rtc_device returned from this
>> function
>> + * are automatically freed on driver detach. See rtc_device_register()
>> + * for more information.
>> + */
>> +
>> +struct rtc_device *devm_rtc_device_register(const char *name,
>> +					struct device *dev,
> As most of devm_* functions use  " struct device *dev" as their first param,
> why not this function also modified to be in sync with them?

I suspect it's because the signature matches rtc_device_register(). This
way you can do a simple search and replace and avoid having to reorder
arguments.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

