Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3GKCgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:36:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:8252 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3GKCgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:36:52 -0400
Message-ID: <51DE1A35.2030108@huawei.com>
Date: Thu, 11 Jul 2013 10:36:37 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Oliver Neukum <oneukum@suse.de>,
        Paul Bolle <pebolle@tiscali.nl>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] PCI: introduce PCIe Device Serial NUmber Capability
 support
References: <1373356545-45944-1-git-send-email-wangyijing@huawei.com> <CAErSpo6L8W40JBjNfE+bf_HWaW5be0VLdK+YyN3+J+05--ukyA@mail.gmail.com>
In-Reply-To: <CAErSpo6L8W40JBjNfE+bf_HWaW5be0VLdK+YyN3+J+05--ukyA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + */
>> +void pci_get_dsn(struct pci_dev *dev, u64 *sn)
> 
> How about:
> 
>     u64 pci_device_serial_number(struct pci_dev *dev)
> 
> "get" suggests reference counting, which isn't happening here.  And
> why pass a pointer to a return value when we can just as easily return
> it directly?

Yes, u64 pci_device_serial_number(struct pci_dev *dev) is better, thanks!

> 
id pci_init_capabilities(struct pci_dev *dev)
>>         /* Power Management */
>>         pci_pm_init(dev);
>>
>> +       /* Device Serial Number */
>> +       pci_dsn_init(dev);
> 
>     dev->sn = pci_serial_number(dev);
> 
> Obvious, no comment or wrapper function needed.

OK, will remove the unnecessary comment.

> 
>> +
>>         /* Vital Product Data */
>>         pci_vpd_pci22_init(dev);

