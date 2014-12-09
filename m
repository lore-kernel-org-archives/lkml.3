Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaLIIyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:54:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54583 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaLIIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:54:10 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d4-5486b8af7f13
Message-id: <5486B8AE.5000408@samsung.com>
Date: Tue, 09 Dec 2014 09:54:06 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd> <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd> <547C7420.4080801@samsung.com>
 <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
 <20141206124310.GB3411@amd> <5485D7F8.10807@samsung.com>
 <20141208201855.GA16648@amd>
In-reply-to: <20141208201855.GA16648@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xq7rrd7SFGJx5rWexccZ6VoujOycy
	WZxtesNucXnXHDaLrW/WMVr0bNjKanH31FE2i927nrJaHH7TzmpxZv9KNgcuj52z7rJ7HP66
	kMVjz/wfrB59W1YxeqxY/Z3d4/MmuQC2KC6blNSczLLUIn27BK6M7T8eMBU0CFUcvNbI1sC4
	nq+LkZNDQsBEYtb/pewQtpjEhXvr2boYuTiEBJYySjRfaGGEcD4ySmz4PZERpIpXQEvi6M8G
	NhCbRUBV4sT/xywgNpuAocTPF6+ZQGxRgQiJP6f3sULUC0r8mHwPrEZEQF5ia98KZpChzAIN
	zBIPlz8FGyQskCrx5s0/qG2LmCV+//4GdhOngKbE3P/bwSYxC1hLrJy0jRHClpfYvOYt8wRG
	gVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCEx8XUH49JjVocYBTgY
	lXh4dyi2hQixJpYVV+YeYpTgYFYS4VVaChTiTUmsrEotyo8vKs1JLT7EyMTBKdXA6JZrkJFg
	I+gww3PXR/Opkj69TAxHRY/Pj3I5N83sfJyc4kbNTRGH3eMWH+JjmNP25vE7AR/v55MYpiSn
	nLg+4eJhxV8tT9NnLfgjWWDkWfC6V3/pAZODEUlrfW/FZEqr6LVM22QuGDxTgTW/rLQ4cr3Y
	a4X7XseTDnsall6ZcStoWc+166YeSizFGYmGWsxFxYkAAaqwh2cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 12/08/2014 09:18 PM, Pavel Machek wrote:
> On Mon 2014-12-08 17:55:20, Jacek Anaszewski wrote:
>> On 12/06/2014 01:43 PM, Pavel Machek wrote:
>>>
>>>>> The format of a sysfs attribute should be concise.
>>>>> The error codes are generic and map directly to the V4L2 Flash
>>>>> error codes.
>>>>>
>>>>
>>>> Actually I'd like to see those flash fault code defined in LED
>>>> subsystem. And V4L2 will just include LED flash header file to use it.
>>>> Because flash fault code is not for V4L2 specific but it's a feature
>>>> of LED flash devices.
>>>>
>>>> For clearing error code of flash devices, I think it depends on the
>>>> hardware. If most of our LED flash is using reading to clear error
>>>> code, we probably can make it simple as this now. But what if some
>>>> other LED flash devices are using writing to clear error code? we
>>>> should provide a API to that?
>>>
>>> Actually, we should provide API that makes sense, and that is easy to
>>> use by userspace.
>>>
>>> I believe "read" is called read because it does not change anything,
>>> and it should stay that way in /sysfs. You may want to talk to sysfs
>>> maintainers if you plan on doing another semantics.
>>
>> How would you proceed in case of devices which clear their fault
>> register upon I2C readout (e.g. AS3645)? In this case read does have
>> a side effect. For such devices attribute semantics would have to be
>> different than for the devices which don't clear faults on readout.
>
> No, semantics should be same for all devices.
>
> If device clears fault register during I2C readout, kernel will simply
> gather faults in an variable, and clear them upon write to sysfs file.

This approach would require implementing additional mechanisms on
both sides: LED Flash class core and a LED Flash class driver.
In the former the sysfs attribute write permissions would have
to be decided in the runtime and in the latter caching mechanism
would have to be implemented per driver. We would have to also
consider how to approach the issue in case of sub-leds.

The only reason for this overhead is trying to avoid side effects
on reading sysfs attribute. After weighing the pros and cons,
I am not sure if it is worthwhile.

Best Regards,
Jacek Anaszewski
