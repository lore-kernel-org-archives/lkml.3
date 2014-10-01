Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaJATOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:14:11 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35275 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaJATOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:14:07 -0400
Date: Wed, 1 Oct 2014 13:14:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com
Subject: Re: [PATCH v10 0/4] APM X-Gene PCIe host controller
Message-ID: <20141001191403.GC22713@google.com>
References: <1411765707-28822-1-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411765707-28822-1-git-send-email-tinamdar@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 02:08:23PM -0700, Tanmay Inamdar wrote:
> This patch adds support for AppliedMicro X-Gene PCIe host controller. The
> driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
> cards.
> 
> X-Gene PCIe controller driver has depedency on the pcie arm64 arch support.
> Liviu Dudau from ARM has sent a patch set for pcie arm64 arch support and
> support for creating generic pcie bridge from device tree. Liviu's patches
> are available here
> https://lkml.org/lkml/2014/9/23/852
> 
> If someone wishes to test PCIe on X-Gene with this patch set, above mentioned
> patches from Liviu must be applied before the patches in this patch set. Also
> please use latest xgene u-boot firmware.

I applied these on pci/host-xgene (based on pci/host-generic).  I hope to
merge these for v3.18.  It'd be nice to have a device tree person like Arnd
or Rob take a look at the arch/arm64/boot/dts/ bits.

> changes since V9:
> 1. Remove 'xgene_pcie_fixup_bridge' and hide the bridge BAR0 and BAR1 by
>    faking bridge's config space read and write to BAR0 and BAR1.
> 2. Remove whitespace and fit in one line.
> 3. Follow usual block comment.
> 4. user '%pR' for printing out resource info
> 5. Add device and vendor ID programming to make driver operable with older
>    firmware.
> 
> changes since V8:
> 1. Add 'dma-coherent' attribute in device node.
> 
> changes since V7:
> 1. Fix outbound region mapping for IO region. Thanks Liviu for the catch.
> 
> changes since V6:
> 1. Port driver to changed interface as per Liviu's v10 series.
> 
> changes since V5:
> 1. Port driver to changed interface of 'of_create_pci_host_bridge'
> 2. Fix the prefetch bit setting
> 3. Removed bunch of register programming which is already done by firmware
> 
> changes since V4:
> 1. fix section mismatch warnings
> 2. fix the patch description
> 3. fix indentation
> 4. update read/write cfg functions by passing both addr and offset.
> 5. use 'time_before' for timeout.
> 6. remove unnecessary 'IS_ERR_OR_NULL'. Keep 'IS_ERR' for 'clk_get'
> 7. remove BUG_ON for pci_ioremap_io.
> 
> changes since V3:
> 1. remove 'struct hw_pci' and supporting ops in hw_pci
> 2. add code to create the host bridge from dts
> 3. add code to scan the the host bridge
> 4. modify outbound windows setup function to get resource information from
>    'bridge->windows'
> 5. add compatible string in pcie dts node with current X-Gene SOC name.
> 
> changes since V2:
> 1. redefined each PCI port in different PCI domain correctly.
> 2. removed setup_lane and setup_link functions from driver.
> 3. removed scan_bus wrapper and set_primary_bus hack.
> 4. added pci_ioremap_io for io resources.
> 
> changes since V1:
> 1. added PCI domain support
> 2. reading cpu and pci addresses from device tree to configure regions.
> 3. got rid of unnecessary wrappers for readl and writel.
> 4. got rid of endpoint configuration code.
> 5. added 'dma-ranges' property support to read inbound region configuration.
> 6. renamed host driver file to 'pci-xgene.c' from 'pcie-xgene.c'
> 7. dropped 'clock-names' property from bindings
> 8. added comments whereever requested.
> 
> Tanmay Inamdar (4):
>   pci:host: APM X-Gene PCIe host controller driver
>   arm64: dts: APM X-Gene PCIe device tree nodes
>   dt-bindings: pci: xgene pcie device tree bindings
>   MAINTAINERS: entry for APM X-Gene PCIe host driver
> 
>  .../devicetree/bindings/pci/xgene-pci.txt          |  57 ++
>  MAINTAINERS                                        |   8 +
>  arch/arm64/boot/dts/apm-mustang.dts                |   8 +
>  arch/arm64/boot/dts/apm-storm.dtsi                 | 165 ++++++
>  drivers/pci/host/Kconfig                           |  10 +
>  drivers/pci/host/Makefile                          |   1 +
>  drivers/pci/host/pci-xgene.c                       | 659 +++++++++++++++++++++
>  7 files changed, 908 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pci.txt
>  create mode 100644 drivers/pci/host/pci-xgene.c
> 
> -- 
> 1.9.1
> 
