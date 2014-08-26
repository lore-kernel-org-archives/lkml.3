Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbaHZGXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:23:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64432 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaHZGXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:23:06 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-56-53fc27c699ef
Message-id: <53FC27C5.7030400@samsung.com>
Date: Tue, 26 Aug 2014 08:23:01 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 04/29] drivers: base: add notifier for failed driver bind
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
 <20140825200539.GA22076@kroah.com>
In-reply-to: <20140825200539.GA22076@kroah.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xK7rH1P8EG8z4bWXxd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVmc
	uv6ZzeJf70FGizOnL7Fa/N+zg93i8Jt2VosjD3ezW6za9YfR4vZvPgcRjycH5zF5/P41idFj
	56y77B6zO2ayemxa1cnmsX/uGnaPzUvqPW7/e8zsMfnGckaPKyeaWD16m9+xeWy52s7i0bdl
	FaPH501yAXxRXDYpqTmZZalF+nYJXBn/D39jL7jAV3H04g62BsY33F2MnBwSAiYS9z60s0DY
	YhIX7q1n62Lk4hASWMooseL+TlYI5xOjxM3Dl4CqODh4BbQkZv8xBzFZBFQljvzMAellEzCU
	6HrbxQYSFhWIkjj2NQ8kzCsgKPFj8j2w8SICxhL9Z2exg0xkFrjOKtH0+w0TSEJYwFfi27Xz
	UKvWMEqsWvqNESTBKaAvMXPmMrAiZgEziS8vD7NC2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8
	ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkdr/uYFx6zOoQowAHoxIP74O038FCrIllxZW5
	hxglOJiVRHgZHgKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MOY2StpynHHvVKrZKHwn00DoTpyG
	w8LUp0/uTJ29nPOG34S+0HtMH4OfrfJsl+s8Ma/voV/QozYTV+8Xs0Xqjn18G2w0W7VWb/Ge
	JYveml4JDVr9SyDr/uqnmeZ19ZUuU64HS28sKmZyPCj+TXbL1kbxO+nSohynKzYW5J1c6/5J
	U9nTLNIkSImlOCPRUIu5qDgRAHLfk627AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-25 22:05, Greg Kroah-Hartman wrote:
> On Tue, Aug 05, 2014 at 12:47:32PM +0200, Marek Szyprowski wrote:
>> This patch adds support for getting a notify for failed device driver
>> bind, so all the items done in BUS_NOTIFY_BIND_DRIVER event can be
>> cleaned if the driver fails to bind.
> But doesn't the bus know if the driver fails to bind, so why would a
> notifier be needed here?  Can't it unwind any problems then?

Some other subsystems (like IOMMU) might register its own notifiers on
the given bus. Such notifier is called before driver probe
(BUS_NOTIFY_BIND_DRIVER event), so one can allocate some resources there.
However there is no way to do the cleanup if the driver fails to bind,
because no notifier is called in such case.

>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>   drivers/base/dd.c      | 10 +++++++---
>>   include/linux/device.h |  4 +++-
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>> index e4ffbcf..541a41f 100644
>> --- a/drivers/base/dd.c
>> +++ b/drivers/base/dd.c
>> @@ -237,10 +237,14 @@ static int driver_sysfs_add(struct device *dev)
>>   	return ret;
>>   }
>>   
>> -static void driver_sysfs_remove(struct device *dev)
>> +static void driver_sysfs_remove(struct device *dev, int failed)
> I _hate_ having functions with a flag that does something different
> depending on it.  If you _really_ need this, just make the notifier call
> before calling this function, which should work just fine, right?

Ok, I will fix this. If I remember correctly I followed the 
driver_sysfs_add()
function pattern, which (surprisingly, especially when one considers only
the function name) also calls the bus notifiers.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

