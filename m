Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3GLCbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:31:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:36368 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3GLCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:31:14 -0400
Message-ID: <51DF6A48.4070506@huawei.com>
Date: Fri, 12 Jul 2013 10:30:32 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH -v2 1/3] PCI: introduce PCIe Device Serial Number Capability
 support
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com> <1373535825-49972-2-git-send-email-wangyijing@huawei.com> <51DE8032.4040808@redhat.com> <CAErSpo50ni41TiscZDVpg8wMFK2wgWmS1sySfNTs8X9JA7Mmkw@mail.gmail.com>
In-Reply-To: <CAErSpo50ni41TiscZDVpg8wMFK2wgWmS1sySfNTs8X9JA7Mmkw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> }
>>>
>>> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
>>> +       if (!pos)
>>> +               return 0;
>>> +
>>> +       pci_read_config_dword(dev, pos + 4,&lo);
>>> +       pci_read_config_dword(dev, pos + 8,&hi);
>>> +       sn = ((u64)hi<<  32) | lo;
>>
>> See comment below:
>>         dev->sn = ((u64)hi<<  32) | lo;
>>         return;
>>
>>> +       return sn;
>>> +}
>>> +EXPORT_SYMBOL(pci_device_serial_number);
>>> +
>>> +/**
>>>    * pci_configure_ari - enable or disable ARI forwarding
>>>    * @dev: the PCI device
>>>    *
>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>> index 46ada5c..c4c1a2b 100644
>>> --- a/drivers/pci/probe.c
>>> +++ b/drivers/pci/probe.c
>>> @@ -1322,6 +1322,8 @@ static void pci_init_capabilities(struct pci_dev
>>> *dev)
>>>         /* Power Management */
>>>         pci_pm_init(dev);
>>>
>>> +       dev->sn = pci_device_serial_number(dev);
>>> +
>>
>> Finally, 'the comment below':
>> I know you were following Bjorn's suggestion, which I thought
>> was an improvement, but why not do above assignment in
>> pci_device_serial_number() ?
>> See above....
> 
> pci_device_serial_number() would then have the side-effect of saving
> the result somewhere, and callers would have to know where to look.
> Personally, I think it's simpler to return the serial number directly
> and avoid the side-effect, but maybe this is just bike-shedding.
> 
> As long as we are bike-shedding, I'd just drop "sn" and do:
> 
>     return ((u64)hi << 32) | lo;
> 
> And of course, you need spaces before "&hi" and "&lo" in the
> pci_read_config_dword() calls.

OK, will drop "sn", strangely my original patch has spaces before "&hi" and "&lo",
but in reply the spaces disappeared.

Thanks!
Yijing.


> 



> .
> 


-- 
Thanks!
Yijing

