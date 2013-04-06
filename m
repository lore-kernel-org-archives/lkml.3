Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163160Ab3DFCcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 22:32:21 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:50138 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3DFCcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 22:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <7u61w2ppuct79kmjwclqv15y.1365211547178@email.android.com>
References: <7u61w2ppuct79kmjwclqv15y.1365211547178@email.android.com>
Date: Fri, 5 Apr 2013 19:32:19 -0700
X-Google-Sender-Auth: RktUohvycKa2M1wawc1yvJFTSlw
Message-ID: <CAE9FiQVuLCaCxTrgpVm7nmJbFkAWTRJqA9T6oJo3LSqSKwq3Fg@mail.gmail.com>
Subject: Re: [PATCH v6] irq: add quirk for broken interrupt remapping on 55XX chipsets
From: Yinghai Lu <yinghai@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 6:25 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> I'm sorry.  Forgot to change the wording of the error for the new model that I'm following here.  Although the message is mostly right as bios is responsible for setting and clearing the IRQ remapping feature bit in the chips capabilities register.
>
> I'll fix and repost Monday

>>> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
>>> index d56f8c1..2b56e92 100644
>>> --- a/drivers/iommu/irq_remapping.c
>>> +++ b/drivers/iommu/irq_remapping.c
>>> @@ -19,6 +19,7 @@
>>>  int irq_remapping_enabled;
>>>
>>>  int disable_irq_remap;
>>> +int irq_remap_broken;
>>>  int disable_sourceid_checking;
>>>  int no_x2apic_optout;
>>>
>>> @@ -216,6 +217,17 @@ int irq_remapping_supported(void)
>>>         if (disable_irq_remap)
>>>                 return 0;
>>>
>>> +       if (irq_remap_broken) {
>>> +               WARN_TAINT(1, TAIN_FIRMWARE_WORKAROUND,
>>> +                          "This system BIOS has enabled interrupt remapping\n"
>>> +                          "on a chipset that contains an erratum making that\n"
>>> +                          "feature unstable.  Please reboot with nointremap\n"
>>> +                          "added to the kernel command line and contact\n"
>>> +                          "your BIOS vendor for an update");

Also please put those warning code in to
drivers/iommu/intel_irq_remapping.c::intel_irq_remapping_supported()

It does not belong to drivers/iommu/irq_remapping.c.

Thanks

Yinghai
