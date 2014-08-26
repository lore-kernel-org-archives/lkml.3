Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbaHZGaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:30:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64756 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHZGaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:30:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d8-53fc296d92a7
Message-id: <53FC296C.1030202@samsung.com>
Date: Tue, 26 Aug 2014 08:30:04 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 04/29] drivers: base: add notifier for failed driver bind
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
 <20140825211823.GH16329@8bytes.org>
In-reply-to: <20140825211823.GH16329@8bytes.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xy7q5mn+CDU7c1rX4O+kYu0Xz4vVs
	FpPuT2CxWLDf2qJz9gZ2i94FV9kszja9YbfonLiE3eLLlYdMFpseX2O1uLxrDpvFjPP7mCxO
	Xf/MZvGv9yCjxZnTl1gt/u/ZwW5x+E07q8WRh7vZLVbt+sNocfs3n4OIx5OD85g8fv+axOix
	c9Zddo/ZHTNZPTat6mTz2D93DbvH5iX1Hrf/PWb2mHxjOaPHlRNNrB69ze/YPLZcbWfx6Nuy
	itHj8ya5AL4oLpuU1JzMstQifbsErox3D5+zFmzkqPhweTZTA+MXti5GTg4JAROJh9MXMELY
	YhIX7q0HinNxCAksZZR49W4/C4TziVFixZU5zCBVvAJaEnMmTgdKcHCwCKhKfDmlCBJmEzCU
	6HrbxQYSFhWIkjj2NQ+iWlDix+R7LCC2iICSxPXPrawgI5kF3rBKHJ/ezg6SEBbwlfh27Twr
	xK61jBJf9v1jBUlwChhIPH/0GqybWcBM4svLw6wQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKv
	YhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJ3i87GBcfszrEKMDBqMTD+6Hkd7AQa2JZcWXu
	IUYJDmYlEV6Gh0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjBtncAeF26/+t7DraZAl77ND7ku4
	vtU9k5oYxRP88YQCU4FriPWhnDk+9U8ff9uauOHo+Xkn9aebsHCVvrW0j9ec7XxhksFlsxOe
	Th5KUj4Nk8X8/x8s+r9GoujdKanVH+5Nq83p/m+WXSfN0pzV+XGRiaTu0w8vv6zetSn5muvh
	6bpi912TA5RYijMSDbWYi4oTAfc9hDG8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-25 23:18, Joerg Roedel wrote:
> On Tue, Aug 05, 2014 at 12:47:32PM +0200, Marek Szyprowski wrote:
>> +	if (failed && dev->bus)
>> +		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
>> +					     BUS_NOTIFY_DRVBIND_FAILED, dev);
>> +
> Why can't you just use the notifier for BUS_NOTIFY_UNBIND_DRIVER or
> BUS_NOTIFY_UNBOUND_DRIVER when something goes wrong in driver
> initialization?

Hmmm, you might be right. BUS_NOTIFY_UNBIND_DRIVER event happens before 
unbinding
the driver, but BUS_NOTIFY_UNBOUND_DRIVER is called when driver remove 
has been
finished, so it can be considered as a symmetrical pair for 
BUS_NOTIFY_BIND_DRIVER.
Driver which registered bus notifiers is mainly interested in doing 
right cleanup,
so the code executed for IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER and
IOMMU_GROUP_NOTIFY_DRVBIND_FAILED is same.

I will remove this additional event and simply add a call to
BUS_NOTIFY_UNBOUND_DRIVER event when driver probe fails.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

