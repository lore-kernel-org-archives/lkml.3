Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaCRPZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:25:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39735 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaCRPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:25:19 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-50-5328655c8259
Message-id: <53286557.6070808@samsung.com>
Date: Tue, 18 Mar 2014 16:25:11 +0100
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
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
 <53230695.9080606@samsung.com>
 <20140318195210.14c953a70498f634032f35b7@samsung.com>
In-reply-to: <20140318195210.14c953a70498f634032f35b7@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Fd2YVI1gg0Pf+C3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7Bb/eg8yWkxZdJjV4vCb
	dlaLk396GS1m3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGV8O/KDteAXZ8XZvi+MDYwdHF2MnBwSAiYSV358YYSw
	xSQu3FvP1sXIxSEksJRR4uz9d8wgCSGBz4wSv59odTFycPAKaEksWpkCEmYRUJVY//4oK4jN
	JqAm8bnhERuIzQ9UsqbpOguILSoQITF34mawOK+AoMSPyffA4iICGhKfr6xnBdnFLNDIKvHo
	/jJ2kISwgIvEg6abzBBHzGKUOPXoFhNIglPASeL401Vg3cwC1hIrJ21jhLDlJTavecs8gVFw
	FpIls5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSMx93cG49JjVIUYBDkYl
	Hl6JWI1gIdbEsuLK3EOMEhzMSiK8q92BQrwpiZVVqUX58UWlOanFhxiZODilGhjXOwdLpDJd
	refdfziU5eNuVpFA78yLF261RJnJNC92KuY8wFhWF7BYdsvJoBscXreM7z9+Mik6vpid6wRP
	9COOsoUXrL+citRY0R3QOaF9fuUpnUiGicksO5r/uHFuN5z+e339Z6esoCv7A7aoL1rxJHHt
	pZ2/ltwpqYrk1ZiiumBpqG3jDS0lluKMREMt5qLiRAAJbtx0lwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 11:52, Cho KyongHo wrote:
> On Fri, 14 Mar 2014 14:39:33 +0100, Tomasz Figa wrote:
>>> @@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
>>>    	return 0;
>>>    }
>>>
>>> -static struct platform_driver exynos_sysmmu_driver = {
>>> -	.probe		= exynos_sysmmu_probe,
>>> -	.driver		= {
>>> +#ifdef CONFIG_OF
>>> +static struct of_device_id sysmmu_of_match[] __initconst = {
>>> +	{ .compatible	= "samsung,sysmmu-v1", },
>>> +	{ .compatible	= "samsung,sysmmu-v2", },
>>> +	{ .compatible	= "samsung,sysmmu-v3.1", },
>>> +	{ .compatible	= "samsung,sysmmu-v3.2", },
>>> +	{ .compatible	= "samsung,sysmmu-v3.3", },
>>
>> Do you need all these compatible strings? I mean, are there any
>> implementation differences that can't be identified by reading IP
>> registers, such as REG_MMU_VERSION?
>>
>
> Unfortunately, there is a SoC which overrides REG_MMU_VERSION with
> a value for RTL designers and it is not related to System MMU
> versions.

OK.

What about having a generic compatible string for Samsung SysMMU then, 
but an additional property that can override the version to account for 
such brokenness? If not provided, the version would be read from 
REG_MMU_VERSION.

Best regards,
Tomasz
