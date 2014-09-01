Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaIAMHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:07:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57763 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaIAMHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:07:41 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-dd-5404618a8f20
Message-id: <54046186.5030407@samsung.com>
Date: Mon, 01 Sep 2014 14:07:34 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Thierry Reding <treding@nvidia.com>,
        Rob Herring <robh@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <4621634.jlJLccozTJ@wuerfel> <54044EAC.6010701@samsung.com>
 <5493968.dbuSPSqts4@wuerfel>
In-reply-to: <5493968.dbuSPSqts4@wuerfel>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xy7pdiSwhBhN2clj8nXSM3aJ58Xo2
	i0n3J7BYLNhvbdE5ewO7Re+Cq2wWZ5vesFt0TlzCbvHlykMmi02Pr7FaXN41h81ixvl9TBan
	rn9ms/jXe5DR4szpS6wW//fsYLc4/Kad1eLIw93sFqt2/WG0uP2bz0HE48nBeUwev39NYvTY
	Oesuu8fsjpmsHptWdbJ57J+7ht1j85J6j9v/HjN7TL6xnNHjyokmVo/e5ndsHluutrN49G1Z
	xejxeZNcAF8Ul01Kak5mWWqRvl0CV8a+j+fYCnbxVtzY+Z29gfENVxcjJ4eEgInEh0uv2CFs
	MYkL99azdTFycQgJLGWUaDjawAzhfGKUmHXoBZDDwcEroCUxt9cXpIFFQFVi75mXrCA2m4Ch
	RNfbLjaQElGBKIljX/NAwrwCghI/Jt9jAbFFBBQlpr54BjaSWeAfm8TSw4+YQRLCAp4Ss57M
	ZYdb/P/AQbChnAKaEu833WYEsZkFzCS+vDzMCmHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG
	0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkOj9soNx8TGrQ4wCHIxKPLwvFjKHCLEmlhVX5h5i
	lOBgVhLhnRzLEiLEm5JYWZValB9fVJqTWnyIkYmDU6qBUbFIwMzKQeSW2azYYq8XhU6ml2vF
	XQweh7ssPB1ieGxy7OJ2gVsK3gbW3kcb06Tyy4xKZhRoKxeX/jPrX8Kd+vKZo0onV9HetMef
	Va6W/mt80BVT3Dl1rtuvH0tO//EXWDKbZ9k1m/1fNJvVMqOXyJQp8BT9d3yn/sa2tP588r1T
	Gilvl91UYinOSDTUYi4qTgQAdkI8+bwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-09-01 13:56, Arnd Bergmann wrote:
> On Monday 01 September 2014 12:47:08 Marek Szyprowski wrote:
>>> Who do you think needs to set this flag, and who needs to read it?
>> In the proposed solution Exynos IOMMU driver creates a separate IO
>> address space
>> for every client device in a system and binds it to the default
>> dma-mapping space
>> for the given device. When drivers are doing its own management of IO
>> address
>> space, instead of relying on what is available by default with dma-mapping
>> interface, this will require releasing of the previously created default
>> structures and resources. So this flag is set by the driver doing its own
>> management of io address space. The flags is then checked by Exynos
>> IOMMU driver
>> to avoid creating the default dma-mapping address space for devices
>> which driver
>> does its own management.
> I don't completely understand it yet. I would assume the device
> to be added to the default domain at device creation time
> (of_platform_populate), way before we know which device driver
> is going to be used. How can this prevent the iommu driver
> from doing the association with the domain?

of_platform_populate() is too early to do the association, because that 
time the
exynos iommu driver is even not yet probed.

The association with default dma-mapping domain is done in
IOMMU_GROUP_NOTIFY_BIND_DRIVER notifier, just before binding the driver 
to the
given device. This way iommu driver can check dev->driver->flags and 
skip creating
default dma-mapping domain if driver announces that it wants to handle it by
itself.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

