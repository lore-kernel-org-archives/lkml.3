Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3FND4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:56:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61584 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3FND4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:56:52 -0400
Message-ID: <51BA9466.5040500@huawei.com>
Date: Fri, 14 Jun 2013 11:56:22 +0800
From: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com> <51BA7B3D.1020402@huawei.com> <CAE9FiQX-jCZYPyxeHCp2h-6qx1GMyQYuaTk5JwZR6H1t4jRg9g@mail.gmail.com> <51BA8524.9050507@huawei.com> <CAE9FiQWTD8RpRodPGgZv_ikfVgBnS6GRn2KUJg+5+siFy40Xrg@mail.gmail.com> <CAE9FiQUByRY74HxvJo6T=PmksK1+ekKSv7_e81+M+hP31p9a9A@mail.gmail.com>
In-Reply-To: <CAE9FiQUByRY74HxvJo6T=PmksK1+ekKSv7_e81+M+hP31p9a9A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.77.35]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/14 11:43, Yinghai Lu wrote:
> On Thu, Jun 13, 2013 at 8:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Thu, Jun 13, 2013 at 7:51 PM, Jiang Liu (Gerry) <jiang.liu@huawei.com> wrote:
>
>>> For the first step, I'm trying to make hotplug case work in the same way as
>>> boot time. Do you think this patch help?
>>>
>>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c
>>> b/drivers/pci/hotplug/acpiphp_gl
>>> index 270fdba..12e3f6e 100644
>>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>>> @@ -837,13 +837,13 @@ static int __ref enable_device(struct acpiphp_slot
>>> *slot)
>>>                                  max = pci_scan_bridge(bus, dev, max, pass);
>>>                                  if (pass && dev->subordinate) {
>>>                                          check_hotplug_bridge(slot, dev);
>>> - pci_bus_size_bridges(dev->subordinate);
>>> + pcibios_resource_survey_bus(dev->subordi
>>>                                  }
>>>                          }
>>>                  }
>>>          }
>>>
>>> -       pci_bus_assign_resources(bus);
>>> +       pci_assign_unassigned_bus_resources(bus);
>
> can not use use pci_assign_unassigned_bus_resources directly. as bus
> could have devices that is there already
> before this enable_device and could have driver loaded before.
>
> that is why we have checking
>      if (PCI_SLOT(dev->devfn) != slot->device)
>
Thanks for reminder.
This a quick solution for prove of concept and it should be OK for
this Sony laptop case.
On the other hand, we may need to enhance 
pci_bus_size_bridges(dev->subordinate) and
pci_bus_assign_resources(bus) to support realloc_list.

> .
>


