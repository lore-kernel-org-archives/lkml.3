Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaCNQM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:12:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44716 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaCNQMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:12:24 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-2b-53232a5517fd
Message-id: <53232A53.4040708@samsung.com>
Date: Fri, 14 Mar 2014 17:12:03 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
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
In-reply-to: <20140314141050.c8bedcb66532d277c496796d@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4Vd1QLeVgg9OzLCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7Bb/eg8yWkxZdJjV4vCb
	dlaLk396GS1m3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGVMX7WRuWAWV8XNvlUsDYyzOboYOTkkBEwkZh07xgph
	i0lcuLeerYuRi0NIYCmjRPuDn4wQzmdGia7zk4GqODh4BbQkVl5PAGlgEVCVOL9vAROIzSag
	JvG54REbiM0PVLKm6ToLiC0qECExd+JmsDivgKDEj8n3WEBmigisY5I4dmQnmMMs8JtJ4tm7
	x8wgVcICiRIPP00Cmyok4Chx/ddssEmcAk4SD258ZQSxmQWsJVZO2gZly0tsXvOWeQKj4Cwk
	S2YhKZuFpGwBI/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCo+7KDcfExq0OMAhyMSjy8
	F5SUg4VYE8uKK3MPMUpwMCuJ8K5QBQrxpiRWVqUW5ccXleakFh9iZOLglGpgdHOW6EpvF7jZ
	u7Kh4U5naNq/RzUFf1el/z7QnTzp7MlqyVnTTmwRfCkoUNdqb57657dYWfOO/VObs8Tz85ia
	PL7cv3pGfNkhPZfFZ+ftllIPWhY77bKAq1RTeN/B7yEmZ/R/MM/41nS24cZ9hZVhJv+XVHUm
	y1dv/dnyx2Lmw+UtzLf969i/KrEUZyQaajEXFScCALp8NIGYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14.03.2014 06:10, Cho KyongHo wrote:
> Some master device descriptor like fimc-is which is an abstraction
> of very complex H/W may have multiple System MMUs. For those devices,
> the design of the link between System MMU and its master H/W is needed
> to be reconsidered.
>
> A link structure, sysmmu_list_data is introduced that provides a link
> to master H/W and that has a pointer to the device descriptor of a
> System MMU. Given a device descriptor of a master H/W, it is possible
> to traverse all System MMUs that must be controlled along with the
> master H/W.

NAK.

A device driver should handle particular hardware instances separately, 
without abstracting a virtual hardware instance consisting of multiple 
physical ones.

If such abstraction is needed, it should be done above the exynos-iommu 
driver, e.g. by something like iommu-composite driver that would 
aggregate several IOMMUs. Keep in mind that such IOMMUs in a group could 
be different, e.g. different Exynos SysMMU versions or even completely 
different IPs handled by different drivers.

Still, I don't think there is a real need for such abstraction. Instead, 
related drivers shall be fixed to properly handle multiple memory 
masters and their IOMMUs.

Best regards,
Tomasz
