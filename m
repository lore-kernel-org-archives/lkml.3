Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaIQWe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:34:26 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40353 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbaIQWeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:34:23 -0400
Message-ID: <541A0C69.1030402@linaro.org>
Date: Wed, 17 Sep 2014 23:34:17 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ssbi: promote the driver to subsys level
References: <1410915594-15599-1-git-send-email-srinivas.kandagatla@linaro.org> <20140917160305.GH30918@lee--X1> <CAGkH4DOPHQWBVZgiLZugcoTZNJiS-ar8KNvq96W5UmX8C6GCTg@mail.gmail.com> <20140917164925.GO30918@lee--X1> <20140917222519.GV30918@lee--X1>
In-Reply-To: <20140917222519.GV30918@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17/09/14 23:25, Lee Jones wrote:
> On Wed, 17 Sep 2014, Lee Jones wrote:
>
>> On Wed, 17 Sep 2014, Srinivas Kandagatla wrote:
>>
>>> On 17 Sep 2014 09:03, "Lee Jones" <lee.jones@linaro.org> wrote:
>>>>
>>>> On Wed, 17 Sep 2014, Srinivas Kandagatla wrote:
>>>>
>>>>> This patch promtes the driver to be at subsystem level as this driver
>>>>> will be used by gpio controller drivers which inturn are used by many
>>>>> platform drivers.
>>>>
>>>> Any reason why you're not using -EPROBE?
>>>>
>>> EPROBE is possible but it's going to add few more cycles to boot time.
>>>
>>> As this driver is a very basic driver on which other drivers depend
>>> ensuring the sequence would improve the boot time.
>>
>> We only tend to promote drivers' init level as a last resort.  If
>> -EPROBE_DEFER is possible, please use that instead.
>
> To conclude for any casual/interested observers; I'd be willing to
> accept the patch if you can provide some metrics that prove boot-time
> is sufficiently increased as a result of using -EPROBE_DEFER.

That's fair enough I will get the details..

>
>>>>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>>>> ---
>>>>>   drivers/mfd/ssbi.c | 7 ++++++-
>>>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
>>>>> index b78942e..4fbe02e 100644
>>>>> --- a/drivers/mfd/ssbi.c
>>>>> +++ b/drivers/mfd/ssbi.c
>>>>> @@ -331,7 +331,12 @@ static struct platform_driver ssbi_driver = {
>>>>>                .of_match_table = ssbi_match_table,
>>>>>        },
>>>>>   };
>>>>> -module_platform_driver(ssbi_driver);
>>>>> +
>>>>> +static int ssbi_init(void)
>>>>> +{
>>>>> +     return platform_driver_register(&ssbi_driver);
>>>>> +}
>>>>> +subsys_initcall(ssbi_init);
>
> Also, as a nasty side-effect of this patch, this module will no longer
> be unloadable, which is probably not what you want.
>
>>>>>   MODULE_LICENSE("GPL v2");
>>>>>   MODULE_VERSION("1.0");
>
