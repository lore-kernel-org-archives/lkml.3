Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaJUDes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:34:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25470 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJUDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:34:47 -0400
Message-ID: <5445D44D.60808@huawei.com>
Date: Tue, 21 Oct 2014 11:34:37 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Thermal:Remove usless if(!result) before return tz
References: <5444C78F.10404@huawei.com> <20141020121039.GA3688@developer>
In-Reply-To: <20141020121039.GA3688@developer>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/10/20 20:10, Eduardo Valentin wrote:
> Hello Yao
>
> On Mon, Oct 20, 2014 at 04:27:59PM +0800, Yao Dongdong wrote:
>> result is always zero when comes here.
>>
>> Signed-off-by:yaodongdong@huawei.com
>>
>> ---
>>  drivers/thermal/thermal_core.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
>> index 5b7d466..19cac8e 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -1568,8 +1568,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
>>
>>     thermal_zone_device_update(tz);
>>
>> -   if (!result)
>> -       return tz;
>> +   return tz;
>>
> Adding a return here will make the resource release below not reachable
> in the fail path.

But all fails above followed a "goto unregister", so i think it must be successful when come here.

Thanks.

>>  unregister:
>>     release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
>> --
>> 1.8.0.1
>>
>>


