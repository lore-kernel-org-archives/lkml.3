Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbaCRPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:09:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43801 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbaCRPJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:09:57 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-64-532861c23da0
Message-id: <532861BE.7020601@samsung.com>
Date: Tue, 18 Mar 2014 16:09:50 +0100
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
In-reply-to: <20140318185605.0380c8dfe6559c06183092e5@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Zd1DiRrBBovOCFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mr4Nq+sYIF+xdUH31kbGBvUuhg5OSQETCTWH13KBmGL
	SVy4tx7I5uIQEljKKLH721lGkISQwGdGiXvfxUBsXgEtifkPPrOA2CwCqhJLpi0Hq2ETUJP4
	3PAIbBA/UM2aputgNaICERJzJ25mg+gVlPgx+R5YXERAQ+LzlfWsIMuYBRpZJR7dX8YOkhAW
	CJc4deMjC8QVsxgl1h3oBUtwCjhJ3H5/HKybWcBaYuWkbYwQtrzE5jVvmScwCs5CsmQWkrJZ
	SMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJua87GJceszrEKMDBqMTDKxGrESzE
	mlhWXJl7iFGCg1lJhHe1O1CINyWxsiq1KD++qDQntfgQIxMHp1QDo7MFK4vDxGPXb9dHcDyr
	Ylt3XjVoTsItVmnpPVv0/8dLa0hq/fET5zRv5qmt61WaOlmYR+z/lMPV8VI/ct/POn7kbN5K
	leuSfN4nm1KYFixUMlo4516Ez7ptzW9V+J/flvgd/FOB+/6NVr6dG3c7avY/3X2V9e/tG7GG
	m1U9Jqp7LCyrOpo9T4mlOCPRUIu5qDgRAH4LImeXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 10:56, Cho KyongHo wrote:
> On Fri, 14 Mar 2014 13:59:00 +0100, Tomasz Figa wrote:
>> Hi KyongHo,
>>
>> On 14.03.2014 06:08, Cho KyongHo wrote:

[snip]

>>> -static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
>>> +static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
>>
>> If you are changing the names anyway, it would be probably a good idea
>> to reduce code obfuscation a bit and drop the underscores from
>> beginnings of function names. Also I'd suggest keeping the "exynos_" prefix.
>
> Thanks for the suggestion.
> __exynos_sysmmu_disable is splitted into 2 functions: __sysmmu_disable
> and __sysmmu_disable_nocount.
> I agree with you that it is good idea to reduce code obfuscation but
> I don't think dropping beginning underscores of function names reduces
> obfuscation.
>

Well, if you are ending up with a function like 
__sysmmu_enable_nocount() below with every line starting with two 
underscores, do you think this improves code readability?

Of course this is a minor issue, but let's keep some code quality level 
in Linux kernel.

>>
>>>    {
>>> -	unsigned long flags;
>>> -	bool disabled = false;
>>> -
>>> -	write_lock_irqsave(&data->lock, flags);

[snip]

Here's the function mentioned above:

>>> +
>>> +static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
>>> +{
>>> +	__master_clk_enable(data);
>>> +	__sysmmu_clk_enable(data);
>>> +
>>> +	__raw_writel(CTRL_BLOCK, data->sfrbase + REG_MMU_CTRL);
>>> +
>>> +	__sysmmu_init_config(data);
>>> +
>>> +	__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
>>> +
>>> +	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
>>> +
>>> +	__master_clk_disable(data);
>>> +}
>>> +

[snip]

>>>
>>> @@ -629,7 +700,7 @@ err_pgtable:
>>>    static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>>>    {
>>>    	struct exynos_iommu_domain *priv = domain->priv;
>>> -	struct sysmmu_drvdata *data;
>>> +	struct exynos_iommu_owner *owner;
>>>    	unsigned long flags;
>>>    	int i;
>>>
>>> @@ -637,11 +708,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>>>
>>>    	spin_lock_irqsave(&priv->lock, flags);
>>>
>>> -	list_for_each_entry(data, &priv->clients, node) {
>>> -		while (!exynos_sysmmu_disable(data->dev))
>>> +	list_for_each_entry(owner, &priv->clients, client) {
>>> +		while (!exynos_sysmmu_disable(owner->dev))
>>>    			; /* until System MMU is actually disabled */
>>
>> What about using list_for_each_entry_safe() and calling list_del_init()
>> here directly?
>>
>
> That require another variable to be defined.

Is it a problem?

> I just wanted to avoid that because I think it is prettier.
> Moreover, list_del_init() below the empty while() clause may make
> the source code readers misunderstood..

This raises another question, why the loop above is even needed. 
exynos_sysmmu_disable() should make sure that SYSMMU is actually 
disabled, without any need for looping like this.

>>>    	}
>>>
>>> +	while (!list_empty(&priv->clients))
>>> +		list_del_init(priv->clients.next);
>>> +
>>>    	spin_unlock_irqrestore(&priv->lock, flags);
>>>
>>>    	for (i = 0; i < NUM_LV1ENTRIES; i++)

[snip]

>>> +static int sysmmu_hook_driver_register(struct notifier_block *nb,
>>> +					unsigned long val,
>>> +					void *p)
>>> +{
>>> +	struct device *dev = p;
>>> +
>>> +	switch (val) {
>>> +	case BUS_NOTIFY_BIND_DRIVER:
>>> +	{
>>> +		struct exynos_iommu_owner *owner;
>>
>> Please move this variable to the top of the function and drop the braces
>> around case blocks.
>
> I don't think it is required because this function is modified
> by the following patches.

OK, if so, and similar issue is not present after further patches.

>
>>
>>> +
>>> +		/* No System MMU assigned. See exynos_sysmmu_probe(). */
>>> +		if (dev->archdata.iommu == NULL)
>>> +			break;
>>
>> This looks strange... (see below)
>>
>> Also this looks racy. There are no guarantees about device probing
>> order, so you may end up with master devices being probed before the
>> IOMMUs. Deferred probing should be used to handle this correctly.
>
> System MMU driver must be probed earlier than the drivers of master devices
> because the drivers may want to use System MMU for their initial task.

As I said, there are no guarantees about platform device probe order in 
Linux kernel. Code must be designed to check whether required 
dependencies are met and if not, deferred probing must be used.

>>
>>> +
>>> +		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
>>> +		if (!owner) {
>>> +			dev_err(dev, "No Memory for exynos_iommu_owner\n");
>>> +			return -ENOMEM;
>>> +		}
>>> +
>>> +		owner->dev = dev;
>>> +		INIT_LIST_HEAD(&owner->client);
>>> +		owner->sysmmu = dev->archdata.iommu;
>>> +
>>> +		dev->archdata.iommu = owner;
>>
>> I don't understand what is happening here in this case statement. There
>> is already something assigned to dev->archdata.iommu, but this code
>> reassigns something else to this field. This means that you attempt to
>> use the same field to store pointers to objects of different types,
>> which I believe is broken, because you have no way to check what kind of
>> object is currently pointed by such (void *) pointer.
>>
>
> exynos_sysmmu_probe() assigns the device descriptor of the probing System MMU
> to archdata.iommu of its master device. The assignment is just a marker that
> the device is a master device of a System MMU.
> If dev->archdata.iommu has a value in the case of BUS_NOTIFY_BIND_DRIVER,
> the 'dev' is a master devices of a System MMU. Then sysmmu_hook_driver_register()
> assigns the data structure to handle System MMU to dev->archdata.iommu.

Which is wrong (or even if you don't consider it wrong, it is ugly), 
because one (void *) pointer in the same object is used to store 
pointers to two completely different types.

Best regards,
Tomasz
