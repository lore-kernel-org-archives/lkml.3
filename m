Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3EYPTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:19:35 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51849 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3EYPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:19:29 -0400
Message-ID: <51A0D663.1030901@gmail.com>
Date: Sat, 25 May 2013 23:18:59 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [RFC PATCH v2, part 2 14/18] PCI, EDAC: use hotplug-safe PCI
 bus iterators to walk PCI buses
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com> <1368550322-1045-14-git-send-email-jiang.liu@huawei.com> <519C45A3.3000005@cn.fujitsu.com>
In-Reply-To: <519C45A3.3000005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22 May 2013 12:12:19 PM CST, Gu Zheng wrote:
> On 05/15/2013 12:51 AM, Jiang Liu wrote:
>
>> Enhance EDAC drviers to use hotplug-safe iterators to walk PCI buses.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Doug Thompson <dougthompson@xmission.com>
>> Cc: linux-edac@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/edac/i7core_edac.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
>> index 0ec3e95..39d5823 100644
>> --- a/drivers/edac/i7core_edac.c
>> +++ b/drivers/edac/i7core_edac.c
>> @@ -1296,7 +1296,7 @@ static unsigned i7core_pci_lastbus(void)
>>   	int last_bus = 0, bus;
>>   	struct pci_bus *b = NULL;
>>
>> -	while ((b = pci_find_next_bus(b)) != NULL) {
>> +	for_each_pci_root_bus(b)
>
> missing the "{":
> +	for_each_pci_root_bus(b) {
Hi Zheng,
             Thanks for review! Will fix it in next version.
Regards!
Gerry

>
>>   		bus = b->number;
>>   		edac_dbg(0, "Found bus %d\n", bus);
>>   		if (bus > last_bus)
>
>


