Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3APRAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:00:10 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34600 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab3APRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:00:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130116105327.GA16543@mudshark.cambridge.arm.com>
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
	<20130116105327.GA16543@mudshark.cambridge.arm.com>
Date: Thu, 17 Jan 2013 02:00:03 +0900
X-Google-Sender-Auth: 9JbHB5M7mRjGyM9Jt5iCydYzKXg
Message-ID: <CAHQjnOMonei8ZS+wKhv4REXq_dpXPdnGrdKEfkdJ+J7QF7kf8w@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
From: KyongHo Cho <pullip.cho@samsung.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 7:53 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Dec 26, 2012 at 01:53:15AM +0000, Cho KyongHo wrote:
>> notice: v6 patch-set is rebased on next/iommu-exynos branch of
>> linux-samsung.git.  This patch-set does not include 2 patches (05 and 06
>> patches in v5 patch-se) because they alread exist already in the branch.
>
> Given that devicetree-discuss has been notably absent from discussion
> surrounding the proposed binding, I think that including that patch in
> linux-samsung.git and dropping it from this series is rather premature.
>
> I have comments on the binding, so I'll dig up the version you posted in v5
> and add devicetree-discuss to CC.

Thank you.

>> The current exynos-iommu(System MMU) driver does not work autonomously
>> since it is lack of support for power management of peripheral blocks.
>> For example, MFC device driver must ensure that its System MMU is disabled
>> before MFC block is power-down not to invalidate IOTLB in the System MMU
>> when I/O memory mapping is changed. Because A System MMU is resides in the
>> same H/W block, access to control registers of System MMU while the H/W
>> block is turned off must be prohibited.
>>
>> This set of changes solves the above problem with setting each System MMUs
>> as the parent of the device which owns the System MMU to recieve the
>> information when the device is turned off or turned on.
>>
>> Another big change to the driver is the support for devicetree.
>> The bindings for System MMU is described in
>> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
>
> This should probably be Documentation/devicetree/bindings/iommu/ no?

Please let me check it.

Thank you.

KyongHo.
