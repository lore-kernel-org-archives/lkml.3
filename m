Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3AUMgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:36:03 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48174 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3AUMgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:36:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v9 10/11] PCI: Add match_driver in struct pci_dev
Date: Mon, 21 Jan 2013 13:41:59 +0100
Message-ID: <2498419.CI4NCxq5bO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWaiPDpmdxm34YPoxcGVMUV+rgFqFZVBZsQy7JOaA4yXQ@mail.gmail.com>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org> <2129071.O9G31gJZfd@vostro.rjw.lan> <CAE9FiQWaiPDpmdxm34YPoxcGVMUV+rgFqFZVBZsQy7JOaA4yXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 20, 2013 09:22:04 PM Yinghai Lu wrote:
> On Sun, Jan 20, 2013 at 3:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, January 17, 2013 11:53:21 PM Yinghai Lu wrote:
> >> with that we could move out attaching driver for pci device,
> >> out of device_add for pci hot add path.
> >>
> >> pci_bus_attach_device() will attach driver to pci device.
> >
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > for the code, but you still aren't saying in the changelog why the change
> > is needed.
> 
> Thanks.
> 
> Please check if the changelog is good to you.

It's fine by me.

Thanks,
Rafael


> ---
> Subject: [PATCH] PCI: Skip attaching driver in device_add()
> 
> We want to add pci device to device tree as early as possible but
> delay attach driver in next following path.
> 
> To make that patch smaller, in this patch:
> 
> We add match_driver field in pci_dev and default vaule is false, it will
> make pci_bus_match fail, so device_add  will skip attaching driver,
> then pci_bus_attach_device() will set match_driver to true so
> pci_bus_match will return true and device_attach will attach driver
> to pci device.
> 
> ---
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
