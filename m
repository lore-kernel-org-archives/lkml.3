Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbaCSNNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:13:10 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18874 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914AbaCSNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:13:04 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-53-532997dcdff2
Message-id: <532997D7.6090608@samsung.com>
Date: Wed, 19 Mar 2014 14:12:55 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
 <5322FD14.5090602@samsung.com>
 <20140318185605.0380c8dfe6559c06183092e5@samsung.com>
 <532861BE.7020601@samsung.com>
 <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
In-reply-to: <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4Zd070zWDDWZ94bG4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2slv86z3IaDFl0WFWi8Nv
	2lktTv7pZbSYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVxqNOu4KRFxcvjJg2MR3S7GDk5JARMJFa/Xs4MYYtJ
	XLi3nq2LkYtDSGApo8TE0/OZIJzPjBJ7dj1hBKniFdCSuPD/LWsXIwcHi4CqxPUWCZAwm4Ca
	xOeGR2wgNj9QyZqm6ywgtqhAhMTciZvZIFoFJX5MvgcWFxHQkPh8ZT0ryHxmgUZWiUf3l7GD
	JIQFwiVO3fjIAre4+fhuJpAEp4CTxJtHy1lBbGYBa4mVk7YxQtjyEpvXvGWewCg4C8mSWUjK
	ZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJOK+7GBcfMzqEKMAB6MSD69krEaw
	EGtiWXFl7iFGCQ5mJRHeX1M0g4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzv3KZ6nqbvlV0O7o
	ZZnd6rNdjsvxlReeSW4/FPDmxhGJs49rfv6P4rijsontefx0LVYtzmkBShkG3NmCka/CJJTM
	w7g7pz7USFjfZjX3dp7h5GLu2wZPIu1MwlmWXtpXMufuI/vAe6+YirmPJ9681b2j925ww/mn
	1kxcB2u/upodN+DKWHNDiaU4I9FQi7moOBEAGe8M1ZYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2014 02:03, Cho KyongHo wrote:
> On Tue, 18 Mar 2014 16:09:50 +0100, Tomasz Figa wrote:
>> On 18.03.2014 10:56, Cho KyongHo wrote:
>>> On Fri, 14 Mar 2014 13:59:00 +0100, Tomasz Figa wrote:
>>>> Hi KyongHo,
>>>>
>>>> On 14.03.2014 06:08, Cho KyongHo wrote:

[snip]

>>>>> @@ -637,11 +708,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>>>>>
>>>>>     	spin_lock_irqsave(&priv->lock, flags);
>>>>>
>>>>> -	list_for_each_entry(data, &priv->clients, node) {
>>>>> -		while (!exynos_sysmmu_disable(data->dev))
>>>>> +	list_for_each_entry(owner, &priv->clients, client) {
>>>>> +		while (!exynos_sysmmu_disable(owner->dev))
>>>>>     			; /* until System MMU is actually disabled */
>>>>
>>>> What about using list_for_each_entry_safe() and calling list_del_init()
>>>> here directly?
>>>>
>>>
>>> That require another variable to be defined.
>>
>> Is it a problem?
>>
> That is not a problem.
> But I think using list_for_each_entry() is not a problem likewise.
>
>>> I just wanted to avoid that because I think it is prettier.
>>> Moreover, list_del_init() below the empty while() clause may make
>>> the source code readers misunderstood..
>>
>> This raises another question, why the loop above is even needed.
>> exynos_sysmmu_disable() should make sure that SYSMMU is actually
>> disabled, without any need for looping like this.
>
> Some driver needs enabling sysmmu to be counted due to its complex structure.
> It can be also removed by the driver with an extra effort
> but the reality is important.

My comment was not about the need to have reference counting, as this is 
a common design pattern, but rather that there should be a low level 
power control function, which simply disables the IOMMU, without the 
need to loop through existing references.

Actually there is already such function - __sysmmu_disable_nocount() - 
so the code could look like:

	list_for_each_entry_safe(owner, n, &priv->clients, client) {
		__sysmmu_disable_nocount(owner->dev);
		list_del_init(&owner->client);
	}

As for reference counting in this use case in general, as far as I'm 
looking through the whole driver code, there is no other usage of this 
reference counting than exynos_iommu_attach_device() and 
exynos_iommu_detach_device(). Assuming that there is just a single 
master for each SYSMMU, I don't see why reference counting is even 
needed, as you can't bind a device to IOMMU multiple times.

> Device driver is not only for the scholarship but also for the real use.

Huh? I'm not sure what kind of comment is this.

>
>>>>>     	}
>>>>>
>>>>> +	while (!list_empty(&priv->clients))
>>>>> +		list_del_init(priv->clients.next);
>>>>> +
>>>>>     	spin_unlock_irqrestore(&priv->lock, flags);
>>>>>
>>>>>     	for (i = 0; i < NUM_LV1ENTRIES; i++)
>>
>> [snip]
>>
>>>>> +static int sysmmu_hook_driver_register(struct notifier_block *nb,
>>>>> +					unsigned long val,
>>>>> +					void *p)
>>>>> +{
>>>>> +	struct device *dev = p;
>>>>> +
>>>>> +	switch (val) {
>>>>> +	case BUS_NOTIFY_BIND_DRIVER:
>>>>> +	{
>>>>> +		struct exynos_iommu_owner *owner;
>>>>
>>>> Please move this variable to the top of the function and drop the braces
>>>> around case blocks.
>>>
>>> I don't think it is required because this function is modified
>>> by the following patches.
>>
>> OK, if so, and similar issue is not present after further patches.
>>
>>>
>>>>
>>>>> +
>>>>> +		/* No System MMU assigned. See exynos_sysmmu_probe(). */
>>>>> +		if (dev->archdata.iommu == NULL)
>>>>> +			break;
>>>>
>>>> This looks strange... (see below)
>>>>
>>>> Also this looks racy. There are no guarantees about device probing
>>>> order, so you may end up with master devices being probed before the
>>>> IOMMUs. Deferred probing should be used to handle this correctly.
>>>
>>> System MMU driver must be probed earlier than the drivers of master devices
>>> because the drivers may want to use System MMU for their initial task.
>>
>> As I said, there are no guarantees about platform device probe order in
>> Linux kernel. Code must be designed to check whether required
>> dependencies are met and if not, deferred probing must be used.
>>
>
> I told that System MMU driver must be probed earlier.
> That's why exynos_iommu_init() is called by subsys_initcall level.
> I also noticed that it must be promoted to arch_initcall for some driver.
>

No. Proper Linux drivers must support deferred probing mechanism and 
there should be no assumptions about probing orders. Using other 
initcall level than module_initcall for particular drivers is strongly 
discouraged.

>>>>
>>>>> +
>>>>> +		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
>>>>> +		if (!owner) {
>>>>> +			dev_err(dev, "No Memory for exynos_iommu_owner\n");
>>>>> +			return -ENOMEM;
>>>>> +		}
>>>>> +
>>>>> +		owner->dev = dev;
>>>>> +		INIT_LIST_HEAD(&owner->client);
>>>>> +		owner->sysmmu = dev->archdata.iommu;
>>>>> +
>>>>> +		dev->archdata.iommu = owner;
>>>>
>>>> I don't understand what is happening here in this case statement. There
>>>> is already something assigned to dev->archdata.iommu, but this code
>>>> reassigns something else to this field. This means that you attempt to
>>>> use the same field to store pointers to objects of different types,
>>>> which I believe is broken, because you have no way to check what kind of
>>>> object is currently pointed by such (void *) pointer.
>>>>
>>>
>>> exynos_sysmmu_probe() assigns the device descriptor of the probing System MMU
>>> to archdata.iommu of its master device. The assignment is just a marker that
>>> the device is a master device of a System MMU.
>>> If dev->archdata.iommu has a value in the case of BUS_NOTIFY_BIND_DRIVER,
>>> the 'dev' is a master devices of a System MMU. Then sysmmu_hook_driver_register()
>>> assigns the data structure to handle System MMU to dev->archdata.iommu.
>>
>> Which is wrong (or even if you don't consider it wrong, it is ugly),
>> because one (void *) pointer in the same object is used to store
>> pointers to two completely different types.
>
> archdata.iommu has a pointer to sysmmu descriptor for a very short time
> during booting time to build complete data structure to handle System MMU.
> It is it also a matter?

Yes. It is a serious issue from code readability point of view, as you 
don't know what kind of object pointed by this pointer to expect when 
reading the driver.

Keep in mind that readability is one of the key factors affecting driver 
maintainability which is important if the driver is intended to be kept 
in mainline for many Linux kernel releases, adding support for new 
hardware variants and keeping the driver in good shape over future 
kernel changes (e.g. large refactors of upper layers, such as IOMMU 
subsystem).

>
> Anyway, this style of initialization just maintained to make the driver work
> with the old design. It is changed with the following patches.

OK. If this is just a temporary step, then I guess we can ignore this 
issue. I just noted that such usage is a problem in general.

Best regards,
Tomasz
