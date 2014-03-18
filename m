Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaCRPMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:12:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35229 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaCRPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:12:34 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-ff-5328625f5f52
Message-id: <5328625B.508@samsung.com>
Date: Tue, 18 Mar 2014 16:12:27 +0100
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
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <53230404.6070601@samsung.com>
 <20140318193817.3448387b75e109e814b9c025@samsung.com>
In-reply-to: <20140318193817.3448387b75e109e814b9c025@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4Fd34JI1ggytr1Czu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7Bb/eg8yWkxZdJjV4vCb
	dlaLk396GS1m3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGVs/9zBWLBMoKL710O2BsZ+3i5GTg4JAROJzv//mCBs
	MYkL99azdTFycQgJLGWU2P+5gR3C+cwo0d36A6yKV0BNYvXlzSwgNouAqsTbrR2sIDYbUPxz
	wyM2EJtfQEtiTdN1sBpRgQiJuRM3s0H0Ckr8mHwPLC4ioCHx+cp6VpAFzAKNrBKP7i9jB0kI
	CwRIvDjZwAKxeRajxKoVt8ASnAJOEpsedzKC2MwC1hIrJ22DsuUlNq95yzyBUXAWkiWzkJTN
	QlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZI3H3dwbj0mNUhRgEORiUeXolYjWAh
	1sSy4srcQ4wSHMxKIryr3YFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGBN2XJ6jH3ggbFI573+W
	N3PdGfffuXjjs6FqiQSzStzUPm9nrhMlz7/8/b912985pXXzbvelp01QuP/4eRqnUnvm9l3T
	Q9zPxlzap5P54K76hu+bDypPVtm6JoeZ3azo6s/V1V0VC+pXe7Gna4mpPuwVO/ZBpGiu7aRg
	oc85h2e7z60NEsoQ/q7EUpyRaKjFXFScCACBK0+1mQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 11:38, Cho KyongHo wrote:
> On Fri, 14 Mar 2014 14:28:36 +0100, Tomasz Figa wrote:
>> Hi KyongHo,
>>
>> On 14.03.2014 06:05, Cho KyongHo wrote:
>>> This patch uses managed device helper functions in the probe().
>>>
>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>>> ---
>>>    drivers/iommu/exynos-iommu.c |   64 +++++++++++++++++-------------------------
>>>    1 file changed, 26 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
>>> index 36e6b73..33b424d 100644
>>> --- a/drivers/iommu/exynos-iommu.c
>>> +++ b/drivers/iommu/exynos-iommu.c
>>> @@ -499,51 +499,48 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>>>
>>>    static int exynos_sysmmu_probe(struct platform_device *pdev)
>>>    {
>>> -	int ret;
>>> +	int irq, ret;
>>>    	struct device *dev = &pdev->dev;
>>>    	struct sysmmu_drvdata *data;
>>>    	struct resource *res;
>>>
>>> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
>>> -	if (!data) {
>>> -		dev_dbg(dev, "Not enough memory\n");
>>> -		ret = -ENOMEM;
>>> -		goto err_alloc;
>>> -	}
>>> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>>> +	if (!data)
>>> +		return -ENOMEM;
>>>
>>>    	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>    	if (!res) {
>>> -		dev_dbg(dev, "Unable to find IOMEM region\n");
>>> -		ret = -ENOENT;
>>> -		goto err_init;
>>> +		dev_err(dev, "Unable to find IOMEM region\n");
>>> +		return -ENOENT;
>>>    	}
>>
>> No need to check for error and print message, because
>> devm_ioremap_resource() already checks the passed resource and handles
>> error cases.
>>
>
> Yes but devm_ioremap_resource() just tells that the given 'res' is not
> correct. I think the message in the driver is more informative.

The common practice used in Linux kernel is to not duplicate such 
messages. It is obvious that devm_ioremap_resource() printing such 
message is related to an IOMEM resource anyway, as you can't used it 
with other types of resources.

Best regards,
Tomasz
