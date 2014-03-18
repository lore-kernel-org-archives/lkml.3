Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaCRO06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:26:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32566 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaCRO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:26:55 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-e3-532857ac5a18
Message-id: <532857A8.5060000@samsung.com>
Date: Tue, 18 Mar 2014 15:26:48 +0100
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
Subject: Re: [PATCH v11 20/27] iommu/exynos: allow having multiple System MMUs
 for a master H/W
References: <20140314141050.c8bedcb66532d277c496796d@samsung.com>
 <53232A53.4040708@samsung.com>
 <20140318220128.564740c88d06b86c9c5c10e3@samsung.com>
In-reply-to: <20140318220128.564740c88d06b86c9c5c10e3@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4Zd014RrBBi2txhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdot/vQcZLaYsOsxqcfhN
	O6vFyT+9jBYzb61hceD3eHJwHpPH7IaLLB7/Dvczedy5tofNY/OSeo/JN5YzevRtWcXo8XmT
	nMeVo2eYAjijuGxSUnMyy1KL9O0SuDL2TWhlKlgkUnHiyXHWBsaFAl2MnBwSAiYST45uZYKw
	xSQu3FvP1sXIxSEksJRRYsqxc+wgCSGBz4wSC84rdzFycPAKaElcmiQOYrIIqEp8++4FUsEm
	oCbxueERG4jND1Sxpuk6C4gtKhAhMXfiZrA4r4CgxI/J98DiIgIaEp+vrGcFWcUs0Mgq8ej+
	MrBVwgKJEg8/TWKCuGEWo8TKax+YQJZxCjhJHLhhAlLDLGAtsXLSNkYIW15i85q3zBMYBWch
	2TELSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTE25cdjIuPWR1iFOBgVOLh
	fcGmHizEmlhWXJl7iFGCg1lJhHe1u0awEG9KYmVValF+fFFpTmrxIUYmDk6pBka29A0Xnhjv
	i3abbbHB7vuF37dSztybX9lpe/bTrCTnxp+8Rf91Z0YnRq8SFOy+nPl+ZufH2zt/FvUEqfpf
	fJW83KayJDX43NnI0qxbkjPqcxU/PqtMn5x9je/EXV+Ob8qSSgax+o2lsmKJwSY7b6nciGg7
	oS2VwniqY3HJn/qkEu0krr7TykosxRmJhlrMRcWJAKjAw7mVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18.03.2014 14:01, Cho KyongHo wrote:
> On Fri, 14 Mar 2014 17:12:03 +0100, Tomasz Figa wrote:
>> Hi KyongHo,
>>
>> On 14.03.2014 06:10, Cho KyongHo wrote:
>>> Some master device descriptor like fimc-is which is an abstraction
>>> of very complex H/W may have multiple System MMUs. For those devices,
>>> the design of the link between System MMU and its master H/W is needed
>>> to be reconsidered.
>>>
>>> A link structure, sysmmu_list_data is introduced that provides a link
>>> to master H/W and that has a pointer to the device descriptor of a
>>> System MMU. Given a device descriptor of a master H/W, it is possible
>>> to traverse all System MMUs that must be controlled along with the
>>> master H/W.
>>
>> NAK.
>>
>> A device driver should handle particular hardware instances separately,
>> without abstracting a virtual hardware instance consisting of multiple
>> physical ones.
>>
>> If such abstraction is needed, it should be done above the exynos-iommu
>> driver, e.g. by something like iommu-composite driver that would
>> aggregate several IOMMUs. Keep in mind that such IOMMUs in a group could
>> be different, e.g. different Exynos SysMMU versions or even completely
>> different IPs handled by different drivers.
>>
>> Still, I don't think there is a real need for such abstraction. Instead,
>> related drivers shall be fixed to properly handle multiple memory
>> masters and their IOMMUs.
>>
>
> G2D, Scalers and FIMD of Exynos5420 has 2 System MMUs while aother SoC like
> Exynos5250 does not.
>
> I don't understand why you are negative to this approach.
> This is the simplest than the others.
>
> Let me show you an example.
> FIMC-IS driver just controls MCU in FIMC-IS subsystem and the firmware of
> the MCU controls all other peripherals in the subsystem. Each peripherals
> have their own System MMU. Moreover, the configuration of the peripherals
> varies according to the SoCs.
>
> If System MMU driver accepts multiple masters, everything is done in DT.
> But I worry that it is not easy if System MMU driver does not support
> multiple masters.

I believe I have stated enough reasons why this kind of implementation 
is bad. I'm not going to waste time repeating myself.

Your concerns presented above are valid, however they are not related to 
what is wrong with this patch. I have given you two proper ways to 
handle this, none should be forced upon particular IOMMU master drivers 
- their authors should have the chance to select the method that works 
best for them.

Best regards,
Tomasz
