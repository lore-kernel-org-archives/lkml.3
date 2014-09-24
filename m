Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaIXSEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:04:09 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43214 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXSEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <3082935.e3X4GsVUDn@wuerfel>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
	<1411573068-12952-4-git-send-email-rric@kernel.org>
	<3082935.e3X4GsVUDn@wuerfel>
Date: Wed, 24 Sep 2014 23:34:04 +0530
Message-ID: <CA+sq2Ce8sb=YGma05qEk_992Mc9M92TxCk+RWsyi6tY-FVOCXw@mail.gmail.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LAKML <linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 24 September 2014 17:37:45 Robert Richter wrote:
>>
>> +       pcie0@0x8480,00000000 {
>
> The name should be pci, not pci0.

Thanks, will change.

>
>> +               compatible = "cavium,thunder-pcie";
>> +               device_type = "pci";
>> +               msi-parent = <&its>;
>> +               bus-range = <0 255>;
>> +               #size-cells = <2>;
>> +               #address-cells = <3>;
>> +               reg = <0x8480 0x00000000 0 0x10000000>;  /* Configuration space */
>> +               ranges = <0x03000000 0x8010 0x00000000 0x8010 0x00000000 0x70 0x00000000>, /* mem ranges */
>> +                       <0x03000000 0x8300 0x00000000 0x8300 0x00000000 0x80 0x00000000>,
>> +                       <0x03000000 0x87e0 0x00000000 0x87e0 0x00000000 0x01 0x00000000>;
>> +        };
>
> If you claim the entire 0-255 bus range, I think you should also
> specify a domain, otherwise it's not predictable which domain you
> get.
>
> The interrupt-map and interrupt-map-mask properties are required for PCI,
> otherwise you can't do LSI interrupts.

This PCI controller supports only MSIx interrupts which are edge triggered.

>
> If your hardware can support it, you should also list I/O space and prefetchable
> memory spaces. Can you explain why you have multiple non-prefetchable ranges?

Our hardware is an ECAM based host controller and doesn't support I/O
and prefetchable memory spaces.
All on-board PCI devices connected to this PCI controller have fixed resources
and doesn't have to be allocated/reassigned. Some of these devices are
SRIOV based.
Kernel's SRIOV (pci/iov.c) is expecting 'resource->parent' hierarchy
to be set, otherwise doesn't
enable SRIOV device. So, here multiple non-prefetchable ranges of root bus
aid in resource claiming and setting res->parent hierarchy.

We do call "pci_claim_resource" in controller driver code.
"[PATCH 1/6] pci, thunder: Add support for Thunder PCIe host controller."

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
