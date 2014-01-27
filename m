Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaA0W6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:58:15 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:34971 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754199AbaA0W6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <CALdTtnsEo74UeYgoQ0DF7=LN074b_0bL0vg6Bxs02B9nDkRTNA@mail.gmail.com>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
	<CALdTtnsEo74UeYgoQ0DF7=LN074b_0bL0vg6Bxs02B9nDkRTNA@mail.gmail.com>
Date: Mon, 27 Jan 2014 14:58:10 -0800
Message-ID: <CACoXjcmwspC58WwELQgfbJ-ye5RR0OQh9QA=sVeRDvFTuAxBUA@mail.gmail.com>
Subject: Re: [RFC PATCH V3 0/4] APM X-Gene PCIe controller
From: Tanmay Inamdar <tinamdar@apm.com>
To: Dann Frazier <dann.frazier@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 8:09 AM, Dann Frazier
<dann.frazier@canonical.com> wrote:
> On Fri, Jan 24, 2014 at 2:32 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>> This patch adds support for AppliedMicro X-Gene PCIe host controller. The
>> driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
>> cards.
>>
>> X-Gene PCIe controller driver has depedency on the pcie arch support for
>> arm64. The arm64 pcie arch support is not yet part of mainline Linux kernel
>> and approach for arch support is under discussion with arm64 maintainers.
>> The reference patch can be found here --> https://lkml.org/lkml/2013/10/23/244
>
> The reference patch looks corrupted (pcibios.c has no includes, etc),
> would you mind reposting?

Yes. You are right. I will re-post the patch.

>
>   -dann
>
>> If someone wishes to test PCIe on X-Gene, arch support patch must be applied
>> before the patches in this patch set.
>>
>> changes since V2:
>> 1. redefined each PCI port in different PCI domain correctly.
>> 2. removed setup_lane and setup_link functions from driver.
>> 3. removed scan_bus wrapper and set_primary_bus hack.
>> 4. added pci_ioremap_io for io resources.
>>
>> changes since V1:
>> 1. added PCI domain support
>> 2. reading cpu and pci addresses from device tree to configure regions.
>> 3. got rid of unnecessary wrappers for readl and writel.
>> 4. got rid of endpoint configuration code.
>> 5. added 'dma-ranges' property support to read inbound region configuration.
>> 6. renamed host driver file to 'pci-xgene.c' from 'pcie-xgene.c'
>> 7. dropped 'clock-names' property from bindings
>> 8. added comments whereever requested.
>>
>> Tanmay Inamdar (4):
>>   pci: APM X-Gene PCIe controller driver
>>   arm64: dts: APM X-Gene PCIe device tree nodes
>>   dt-bindings: pci: xgene pcie device tree bindings
>>   MAINTAINERS: entry for APM X-Gene PCIe host driver
>>
>>  .../devicetree/bindings/pci/xgene-pci.txt          |   52 ++
>>  MAINTAINERS                                        |    7 +
>>  arch/arm64/boot/dts/apm-mustang.dts                |    8 +
>>  arch/arm64/boot/dts/apm-storm.dtsi                 |  155 ++++
>>  drivers/pci/host/Kconfig                           |   10 +
>>  drivers/pci/host/Makefile                          |    1 +
>>  drivers/pci/host/pci-xgene.c                       |  784 ++++++++++++++++++++
>>  7 files changed, 1017 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pci.txt
>>  create mode 100644 drivers/pci/host/pci-xgene.c
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
