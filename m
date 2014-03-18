Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbaCRPdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:33:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36305 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaCRPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:33:12 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-56-53286735332e
Message-id: <53286730.1060807@samsung.com>
Date: Tue, 18 Mar 2014 16:33:04 +0100
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
        Varun Sethi <Varun.Sethi@freescale.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v11 19/27] iommu/exynos: add support for power management
 subsystems.
References: <20140314141028.4b0b62d895905988ab5dda88@samsung.com>
 <53232959.7020306@samsung.com>
 <20140318202320.a3101304bbc51cc9f169cdaa@samsung.com>
In-reply-to: <20140318202320.a3101304bbc51cc9f169cdaa@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t/xK7qm6RrBBvdXMFvcuXuO1WLjjPWs
	FvOPAFmvjvxgsliw39qic/YGdoveBVfZLL4eXsFosenxNVaLy7vmsFnMOL+PyeLN7xfsFmuP
	3GW3uLBiI7vFv96DjBZTFh1mtThz+hKrxeE37awWJ//0MlocXxtuMfPWGhYHUY8nB+cxeayZ
	t4bRY3bDRRaPf4f7mTzuXNvD5rF5Sb3H5BvLGT22XG1n8ejbsorR4/MmOY8rR88wBXBHcdmk
	pOZklqUW6dslcGXsO7STrWAJZ8W/QywNjCfYuxg5OSQETCR6Gn6zQthiEhfurWfrYuTiEBJY
	yigxfcE2VgjnM6PErxezmEGqeAW0JBY1fWIBsVkEVCUWvPzJBGKzCahJfG54xAZi8wPVrGm6
	DlYjKhAhMXfiZjaIXkGJH5PvgcVFBDQkPl9ZD7aAWaCfXeLirl1gJwkLREu8vbkWavMsRol/
	TdvAOjgFnCQmTPwAto1ZwFpi5aRtjBC2vMTmNW+ZJzAKzkKyZBaSsllIyhYwMq9iFE0tTS4o
	TkrPNdQrTswtLs1L10vOz93ECInhLzsYFx+zOsQowMGoxMMrGasRLMSaWFZcmXuIUYKDWUmE
	d7U7UIg3JbGyKrUoP76oNCe1+BAjEwenVAOjhGeR4BGXGV7zReTar9fPO3fnB7shy5LiWfMl
	A55xLurnPpRSbDw5e3LUTasptS5FXg9fSz5KvMC0Rfv4qb4/pwwW7Jm9Nb14tsxuzwnNT+Rt
	Hq4vun8xaI7uSQa3DR5fY+TdjYr9RCyL2M52FCybWPS5KMXaZ9nXs8HJOyxYglMPV1kfMF6p
	xFKckWioxVxUnAgArKixDb8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 12:23, Cho KyongHo wrote:
> On Fri, 14 Mar 2014 17:07:53 +0100, Tomasz Figa wrote:
>> Hi KyongHo,
>>
>> On 14.03.2014 06:10, Cho KyongHo wrote:

[snip]

>>> @@ -677,11 +679,40 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>>>    	platform_set_drvdata(pdev, data);
>>>
>>>    	pm_runtime_enable(dev);
>>> +	data->runtime_active = !pm_runtime_enabled(dev);
>>
>> Hmm, this seems to be a bit misleading. The field is named
>> runtime_active, but the assignment makes it true if PM runtime is _not_
>> enabled (i.e. inactive). Is this correct?
>>
>
> I agree that it may lead misunderstood.
> data->runtime_active actually indicates if electric power is asserted
> to the System MMU. pm_runtime_enable() call must enable runtime pm
> for the given device. If runtime pm is not enabled although pm_runtime_enable()
> is called, CONFIG_PM_RUNTIME is not configured.
>
> Actually, it is replacible with
> if (IS_ENABLED(CONFIG_PM_RUNTIME))
>      data->runtime_active = true;

I would keep it as !pm_runtime_enabled(dev), but rename the field to 
something more meaningful, like data->is_powered_on.

Best regards,
Tomasz
