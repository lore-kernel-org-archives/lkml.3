Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3AOLOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:14:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41145 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3AOLOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:14:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 22/22] PCI: move device_add out of pci_bus_add_device()
Date: Tue, 15 Jan 2013 12:19:57 +0100
Message-ID: <4095307.lo3tHnmrev@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVrUkMTP8yFcXVgq3SW9tv6r0WBxfHbV=yT0vYbO=zmFQ@mail.gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1620774.KjdX6JUoJy@vostro.rjw.lan> <CAE9FiQVrUkMTP8yFcXVgq3SW9tv6r0WBxfHbV=yT0vYbO=zmFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 11:10:36 PM Yinghai Lu wrote:
> On Sat, Jan 12, 2013 at 3:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> Move out device registering out of pci_bus_add_devices, so we could
> >> put new created pci devices in device tree early.
> >>
> >> new pci_bus_add_devices will do the device_attach work to load pci drivers
> >> instead.
> >
> > I wonder what problem it solves?
> 
> we want to put created pci device in the device tree as soon as possible.
> so for_pci_dev will not miss them.
> 
> but at that time, we can not load driver for them yet. need to after
> pci_assign_unsigned_resources etc to make sure all pci devices get
> resource allocated at first.
> 
> so only move adding to device tree early, and leave loading driver on
> the old places.

I see, thanks.

Perhaps you can put that explanation into the changelog? It would help people
to understand the reason for the change in the future.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
