Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3AUFWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:22:08 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35336 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3AUFWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:22:05 -0500
MIME-Version: 1.0
In-Reply-To: <2129071.O9G31gJZfd@vostro.rjw.lan>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org>
	<1358495602-22867-11-git-send-email-yinghai@kernel.org>
	<2129071.O9G31gJZfd@vostro.rjw.lan>
Date: Sun, 20 Jan 2013 21:22:04 -0800
X-Google-Sender-Auth: ay8Juvjh_OOMxnX1zpOFqLJATa0
Message-ID: <CAE9FiQWaiPDpmdxm34YPoxcGVMUV+rgFqFZVBZsQy7JOaA4yXQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/11] PCI: Add match_driver in struct pci_dev
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

On Sun, Jan 20, 2013 at 3:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 17, 2013 11:53:21 PM Yinghai Lu wrote:
>> with that we could move out attaching driver for pci device,
>> out of device_add for pci hot add path.
>>
>> pci_bus_attach_device() will attach driver to pci device.
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> for the code, but you still aren't saying in the changelog why the change
> is needed.

Thanks.

Please check if the changelog is good to you.

---
Subject: [PATCH] PCI: Skip attaching driver in device_add()

We want to add pci device to device tree as early as possible but
delay attach driver in next following path.

To make that patch smaller, in this patch:

We add match_driver field in pci_dev and default vaule is false, it will
make pci_bus_match fail, so device_add  will skip attaching driver,
then pci_bus_attach_device() will set match_driver to true so
pci_bus_match will return true and device_attach will attach driver
to pci device.

---
