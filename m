Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaHRJR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:17:27 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62859 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaHRJRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <53E9E052.3070308@monstr.eu>
References: <1406131381-25577-1-git-send-email-sthokal@xilinx.com>
	<CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>
	<8258903.Rn4s07GKGV@wuerfel>
	<CA+mB=1LeZn1k2VHNby2TRBcb1xuFFTQio=C845_xe2A=ZciYqg@mail.gmail.com>
	<53E9E052.3070308@monstr.eu>
Date: Mon, 18 Aug 2014 14:47:23 +0530
X-Google-Sender-Auth: lga-eHQnqgDZT2Iu9kwJHxyqvmI
Message-ID: <CA+mB=1LX=yOqkx1xNoCBQLbYna76qAeRTqiW6SDpb1MYco7ZVQ@mail.gmail.com>
Subject: Re: [PATCH v5] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: monstr@monstr.eu
Cc: Bjorn Helgaas <bhelgaas@google.com>, Srikanth Thokala <sthokal@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        svemula@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, anirudh@xilinx.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Aug 12, 2014 at 3:07 PM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Bjorn,
>
> On 07/30/2014 01:24 PM, Srikanth Thokala wrote:
>> Hi Arnd,
>>
>> On Mon, Jul 28, 2014 at 6:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Monday 28 July 2014 18:04:34 Srikanth Thokala wrote:
>>>> Hi Arnd and Rob,
>>>>
>>>> I discussed with Bjorn and we believe this patch is in good shape to
>>>> apply.  And Bjorn requires ACKs to apply this patch.  So, could you
>>>> guys please review this patch and provided your ACKs to this patch.
>>>
>>> Looks great for the most part. I've looked through the whole driver
>>> again, and I have two small issues remaining:
>>>
>>> a) Please clarify in the changeset description why there is no support
>>>    for PCI I/O space.
>>
>> Sure, I will add to my changeset.
>>
>>>
>>> b) I think you should use the 'msi-parent' property, and the
>>>    of_pci_find_msi_chip_by_node() to find the msi_chip for the
>>>    PCI controller. This will make it possible to forward MSIs
>>>    to the main interrupt controller in the system, which is more
>>>    efficient. See the pcie-mvebu driver for an example of this.
>>
>> Ok, I need to look into this and I will plan to implement on top of this patch.
>>
>>>
>>> Other than these:
>>>
>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Thanks Arnd for the Ack.
>
> What's the status on this one?

It looks like Bjorn is on vacation.  I have sent v6 patch by adding
Ack from Arnd, which
I feel is in good shape to be applied.

>
> Srikanth:
> Isn't pcie-xilinx.c better name if this is just pcie host bridge?

Yes, it looks better.  But, many other drivers which are basically
drivers for PCIe host
controllers has the prefix 'pci-' in the file name.  So, I feel it
should be fine and would
be happy to change if I have to.

Thanks
Srikanth

>
> Thanks,
> Michal
>
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture
> Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
>
>
