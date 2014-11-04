Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaKDCBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:01:41 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:33382 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaKDCBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:01:38 -0500
Message-ID: <5458336F.6090600@huawei.com>
Date: Tue, 4 Nov 2014 10:01:19 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Thermal:Fix memory leak if occur goto unregister
References: <5444C778.8050008@huawei.com> <20141020123338.GA3744@developer> <4D68720C2E767A4AA6A8796D42C8EB590902F30A@BGSMSX101.gar.corp.intel.com> <20141103183510.GA441@developer>
In-Reply-To: <20141103183510.GA441@developer>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/4 2:35, Eduardo Valentin wrote:
> Hello,
>
> On Mon, Nov 03, 2014 at 06:17:37PM +0000, R, Durgadoss wrote:
>>> -----Original Message-----
>>> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
>>> owner@vger.kernel.org] On Behalf Of Eduardo Valentin
>>> Sent: Monday, October 20, 2014 6:04 PM
>>> To: Yao Dongdong
>>> Cc: Zhang, Rui; linux-pm@vger.kernel.org; LKML
>>> Subject: Re: [PATCH 1/2] Thermal:Fix memory leak if occur goto unregister
>>>
>>> Hello,
>>>
>>> On Mon, Oct 20, 2014 at 04:27:36PM +0800, Yao Dongdong wrote:
>>>> Signed-off-by:yaodongdong@huawei.com
>>> Acked-by: Eduardo Valentin <edubezval@gmail.com>
>>>
>>> Rui, would you take care of this?
>>>
>> If I remember it right, this 'tz' is freed in the thermal_release()
>> function, during device_unregister().
>>
>> It is similar in all other functions in thermal_core.c
>>
>> So, Yao, Did you really test this patch ?
>> And did not see any crashes ?
>>
> Yao, reading the patch change carefully, now I see that Durga is correct
> here. 
>
>> Thanks,
>> Durga
>>
>>>> ---
>>>>  drivers/thermal/thermal_core.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
>>>> index 71b0ec0..5b7d466 100644
>>>> --- a/drivers/thermal/thermal_core.c
>>>> +++ b/drivers/thermal/thermal_core.c
>>>> @@ -1574,6 +1574,7 @@ struct thermal_zone_device
>>> *thermal_zone_device_register(const char *type,
>>>>  unregister:
>>>>     release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
>>>>     device_unregister(&tz->device);
>>>> +   kfree(tz);
> The device unregister is called above your kfree call, which will cause
> the thermal_release to be called. Did you test the code for double kfree
> calls? Your patch probably inserts a memory corruption.
>
> I will revert your patch from my tree until you provide an answer about
> your testing.

Yes, i have checked it and you are right, the patch will double kfree tz.

Thansks Durga for correcting me.

> Thanks,
>
>
> Eduardo Valentin
>
>>>>     return ERR_PTR(result);
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(thermal_zone_device_register);
>>>> --
>>>> 1.8.0.1
>>>>
>>>>


