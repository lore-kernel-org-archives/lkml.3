Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbaD3K5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:57:33 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:44506 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967AbaD3K5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <26065037.GxQQuIURPg@wuerfel>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <26065037.GxQQuIURPg@wuerfel>
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
Date: Wed, 30 Apr 2014 16:27:10 +0530
Message-ID: <CAOD6ATqZ5UwRwSKiPDQLrgmX=UUrJVE7ybM_RhXz_CEUjM3W7w@mail.gmail.com>
Subject: Re: [PATCH v12 00/31] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        "supash.ramaswamy" <supash.ramaswamy@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, sunil joshi <joshi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 2:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 27 April 2014 13:07:32 Shaik Ameer Basha wrote:
>> The current exynos-iommu(System MMU) driver does not work autonomously
>> since it is lack of support for power management of peripheral blocks.
>> For example, MFC device driver must ensure that its System MMU is disabled
>> before MFC block is power-down not to invalidate IOTLB in the System MMU
>> when I/O memory mapping is changed. Because a System MMU resides in the
>> same H/W block, access to control registers of System MMU while the H/W
>> block is turned off must be prohibited.
>>
>> This set of changes solves the above problem with setting each System MMUs
>> as the parent of the device which owns the System MMU to receive the
>> information when the device is turned off or turned on.
>>
>> Another big change to the driver is the support for devicetree.
>> The bindings for System MMU is described in
>> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
>
> Sorry I've been absent from the review so far. Most of the patches
> seem entirely reasonable to me, but I'm worried about the DT binding
> aspect. We are going to see more systems shipping with IOMMUs now,
> and we are seeing an increasing number of submissions for 64-bit
> systems. We really have to work out what the DT representation for
> IOMMUs should look like in general before adding another ad-hod
> implementation that is private to one driver.


I have one question.

This series is going on for quite a long time and most of the patches here
doesn't depend on dt bindings. As Exynos IOMMU h/w is introducing new versions
very frequently, maintaining and reviewing all these patches again and
again is quite a hard job.

If it is acceptable, I can post one more series with the subset of
above patches,
which doesn't depend on dt-bindings. As all the patches which doesn't depend on
DT bindings are already tested,  I hope merging these subset of patches may help
in reducing the rework and review effort every time.

Once we finalize the generic DT bindings for the IOMMU devices, the driver
can be updated with the proposed DT bindings in mind.

Regards,
Shaik


>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
