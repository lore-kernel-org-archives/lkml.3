Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3AOG3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:29:53 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:43880 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab3AOG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <50F2D1FA.6000000@gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1357944049-29620-7-git-send-email-yinghai@kernel.org>
	<3931059.ZcnvRQRmKT@vostro.rjw.lan>
	<50F2D1FA.6000000@gmail.com>
Date: Mon, 14 Jan 2013 22:29:48 -0800
X-Google-Sender-Auth: pslVRvFhI-0xN9RGPRGF0_UymyI
Message-ID: <CAE9FiQVdnys7+bXhHCW6CXYkA9TrKf52Kww60_QhmZke3rYwoA@mail.gmail.com>
Subject: Re: [PATCH v8 06/22] PCI: split registration of PCI bus devices into
 two stages
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 7:25 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 01/13/2013 06:34 AM, Rafael J. Wysocki wrote:
>> On Friday, January 11, 2013 02:40:33 PM Yinghai Lu wrote:
>>> From: Jiang Liu <jiang.liu@huawei.com>
>>>
>>> When handling BUS_NOTIFY_ADD_DEVICE event for a PCI bridge device,
>>> the notification handler can't hold reference count to the new PCI bus
>>> because the device object for the new bus (pci_dev->subordinate->dev)
>>> hasn't been initialized yet.
>>
>> It doesn't look like BUS_NOTIFY_ADD_DEVICE is used by the PCI bus type
>> in the mainline.
>>
>> Is it in linux-next?
>>
>> If not, then I don't see why we need this patch.
> Hi Rafael,
>         Originally it's a preparation patch for pci_slot/acpiphp/pci_bind
> related fixups. With recent work from you to remove bind/unbind from struct
> acpi_bus_type, we have no dependency on this patch anymore.

ok, will drop this one.

Yinghai
