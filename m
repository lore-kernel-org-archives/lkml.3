Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaLQNIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:08:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47036 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaLQNIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:08:18 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a8-5491803dce24
Message-id: <5491803C.4030000@samsung.com>
Date: Wed, 17 Dec 2014 14:08:12 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v3 1/2] PM / Domains: Extend API
 pm_genpd_dev_need_restore to use restore types
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
 <54901341.20106@samsung.com>
 <CADGdYn60ONwuLtcdXSegbQLgFaF-me+mZY6-LPYRQvdfmWFMdA@mail.gmail.com>
In-reply-to: <CADGdYn60ONwuLtcdXSegbQLgFaF-me+mZY6-LPYRQvdfmWFMdA@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xa7q2DRNDDK48krFouBpiMXf2JEaL
	3gVX2Sy+Hl7BaDFryl4mi02Pr7FaXN41h83ic+8RRosZ5/cxWSza+oXd4szpS6wWh9+0s1p0
	LGO0WLXrD6PF8bXhDvweE8/qeuycdZfdY/Gel0wed67tYfPYvKTeY8vVdhaPvi2rGD0+b5IL
	4IjisklJzcksSy3St0vgynjXv561YKJ0xZvprg2Mr0S7GDk5JARMJK4dvMUKYYtJXLi3nq2L
	kYtDSGApo8SeX6uYIZxPjBLnL/wHq+IV0JLonvIPzGYRUJV4sO0tM4jNJmAo0fW2iw3EFhWI
	kVi8cDUzRL2gxI/J91i6GDk4RIBqZn0XB5nJLNDJKjFt+2qwemGBTIm2a9tYIZatYZToedHA
	BJLgFAiWaJ+wBGwZs4CZxJeXh6FseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpamlxQnJSe
	a6hXnJhbXJqXrpecn7uJERJLX3YwLj5mdYhRgINRiYf3xfUJIUKsiWXFlbmHGCU4mJVEeD8H
	TgwR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwOhsw2o7y5rJ4MQc2zO6E0Vvsx0/dtzJy+SKw0lD
	QQv25dGd4dOuzNfWFv/pzljMMv2d6a3VoVk2vjFPtuWIHbyi9+zJqUdJbI8eO5YsstTmPLp1
	Qq8iZ5SkZr/AIn254HsSke2qP0TTsgW/pLr/8Rao5wjQfvBESOliZt6GFzKnJl1p3C3opcRS
	nJFoqMVcVJwIAJHQPAGDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-12-17 03:43, amit daniel kachhap wrote:
> On Tue, Dec 16, 2014 at 4:40 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> Hello,
>>
>> On 2014-12-13 17:51, Amit Daniel Kachhap wrote:
>>> Instead of using bool to restore suspended devices initially, use flags
>>> like GPD_DEV_SUSPEND_INIT, GPD_DEV_RESTORE_INIT and GPD_DEV_RESTORE_FORCE.
>>> The first two flags will be similar to the existing true/false
>>> functionality.
>>> The third flag may be used to force restore of suspended devices
>>> whenever their associated power domain is turned on.
>>>
>>> Currently, PD power off function powers off all the associated unused
>>> devices. The functionality added in this patch is similar to it.
>>>
>>> This feature may be used for those devices which are always in ON state
>>> if the PD associated with them is ON but may need local runtime resume
>>> and suspend during PD On/Off. These devices (like clock) may not implement
>>> complete pm_runtime calls such as pm_runtime_get/pm_runtime_put due to
>>> subsystems interaction behaviour or any other reason.
>>>
>>> The model works like,
>>>       DEV1 (Attaches itself with PD but no calls to pm_runtime_get and
>>>       /  pm_runtime_put. Its local runtime_suspend/resume is invoked via
>>>      /   GPD_DEV_RESTORE_FORCE option)
>>>     /
>>> PD -- DEV2 (Implements complete PM runtime and calls pm_runtime_get and
>>>     \    pm_runtime_put. This in turn invokes PD On/Off)
>>>      \
>>>       DEV3 (Similar to DEV1)
>>>
>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> The idea of adding new gen_pd flag and reusing runtime pm calls intead of
>> additional
>> notifiers looks promising, but I have some doubts. I don't see any guarantee
>> that
>> devices with GPD_DEV_RESTORE_FORCE flag will be suspended after all "normal"
>> devices
>> and restored before them. Without such assumption it will be hard to use
>> this approach
>> for iommu related activities, because device might need to use (in its
>> suspend/resume
>> callbacks) the functionality provided by the other device with
>> GPD_DEV_RESTORE_FORCE
>> flag. Maybe some additional flags like suspend/resume priority (or more
>> flags) will
>> solve somehow this dependency.
> Thanks for pointing this issue out. I agree that there is no priority
> in suspending devices with this flag. But this works well in syncing
> with power domain on/off as the devices of these types have only
> dependency with power domain. BTW I tested this implementation with
> your first version of IOMMU save/restore patches. Although i have not
> posted those but they work fine. I can post those after cleaning them
> up.

Right, they will work, but mainly because right now master devices don't
do any memory DMA operations in suspend/resume callbacks. However, to 
propose
it as a generic solution, the priority and the order of operations 
should be
somehow determined.

> Here, the ordering between various devices is taken care as they are
> probed at different point of time(clock then IOMMU). so the suspend
> happens in reverse probe order and resume happens in probe order. I
> will check more on this and get back.

Right now, it probably used the order of probing. Because iommu controllers
are probed earlier, so they are handled before the master devices.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

