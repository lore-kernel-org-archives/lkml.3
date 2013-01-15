Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3AOHKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:10:40 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58121 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3AOHKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:10:38 -0500
MIME-Version: 1.0
In-Reply-To: <1620774.KjdX6JUoJy@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1357944049-29620-23-git-send-email-yinghai@kernel.org>
	<1620774.KjdX6JUoJy@vostro.rjw.lan>
Date: Mon, 14 Jan 2013 23:10:36 -0800
X-Google-Sender-Auth: Obo9ZeuaRcgGJg1kNhtcSD7vl2g
Message-ID: <CAE9FiQVrUkMTP8yFcXVgq3SW9tv6r0WBxfHbV=yT0vYbO=zmFQ@mail.gmail.com>
Subject: Re: [PATCH v8 22/22] PCI: move device_add out of pci_bus_add_device()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 3:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Move out device registering out of pci_bus_add_devices, so we could
>> put new created pci devices in device tree early.
>>
>> new pci_bus_add_devices will do the device_attach work to load pci drivers
>> instead.
>
> I wonder what problem it solves?

we want to put created pci device in the device tree as soon as possible.
so for_pci_dev will not miss them.

but at that time, we can not load driver for them yet. need to after
pci_assign_unsigned_resources etc to make sure all pci devices get
resource allocated at first.

so only move adding to device tree early, and leave loading driver on
the old places.

Yinghai
