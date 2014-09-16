Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaIPQU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:20:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42814 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaIPQUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:20:24 -0400
Date: Tue, 16 Sep 2014 17:20:19 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH v6 0/4] APM X-Gene PCIe host controller
Message-ID: <20140916162019.GH15899@e106497-lin.cambridge.arm.com>
References: <1409963143-11951-1-git-send-email-tinamdar@apm.com>
 <CAErSpo643rAAqR0AAy5CwSkMv28Cw8Y55EYrYo0AHvQZxgvgXg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAErSpo643rAAqR0AAy5CwSkMv28Cw8Y55EYrYo0AHvQZxgvgXg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 16 Sep 2014 16:20:20.0393 (UTC) FILETIME=[1C35F190:01CFD1CA]
X-MC-Unique: 114091617202200301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 03:17:43PM +0100, Bjorn Helgaas wrote:
> On Fri, Sep 5, 2014 at 6:25 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> > This patch adds support for AppliedMicro X-Gene PCIe host controller. The
> > driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
> > cards.
> >
> > X-Gene PCIe controller driver has depedency on the pcie arm64 arch support.
> > Liviu Dudau from ARM has sent a patch set for pcie arm64 arch support and
> > support for creating generic pcie bridge from device tree. Liviu's patches
> > are available here
> > 1. https://lkml.org/lkml/2014/8/12/361
> 
> I'm hoping to merge Liviu's patches and this X-Gene support for v3.18.
> I'm currently waiting for Liviu's v10 series (hopefully based on
> v3.17-rc2), and since your series depends on that, I'm going to wait
> for a v7 of your series that is rebased on top of Liviu's v10.  Does
> that make sense?

Hi Bjorn,

Are you happy so far with my v10 and Tanmay's v7? I will try to chase Rob Herring
here at Linaro Connect to see if he is happy with my latest update to the
pci-domain comments, but I would like to know if you think that there is anything
else preventing you from pulling these series.

Best regards,
Liviu

> 
> > If someone wishes to test PCIe on X-Gene with this patch set, above mentioned
> > patches from Liviu must be applied before the patches in this patch set. Also
> > please use latest xgene u-boot firmware.
> >
> > changes since V5:
> > 1. Port driver to changed interface of 'of_create_pci_host_bridge'
> > 2. Fix the prefetch bit setting
> > 3. Removed bunch of register programming which is already done by firmware
> >
> > changes since V4:
> > 1. fix section mismatch warnings
> > 2. fix the patch description
> > 3. fix indentation
> > 4. update read/write cfg functions by passing both addr and offset.
> > 5. use 'time_before' for timeout.
> > 6. remove unnecessary 'IS_ERR_OR_NULL'. Keep 'IS_ERR' for 'clk_get'
> > 7. remove BUG_ON for pci_ioremap_io.
> >
> > changes since V3:
> > 1. remove 'struct hw_pci' and supporting ops in hw_pci
> > 2. add code to create the host bridge from dts
> > 3. add code to scan the the host bridge
> > 4. modify outbound windows setup function to get resource information from
> >    'bridge->windows'
> > 5. add compatible string in pcie dts node with current X-Gene SOC name.
> >
> > changes since V2:
> > 1. redefined each PCI port in different PCI domain correctly.
> > 2. removed setup_lane and setup_link functions from driver.
> > 3. removed scan_bus wrapper and set_primary_bus hack.
> > 4. added pci_ioremap_io for io resources.
> >
> > changes since V1:
> > 1. added PCI domain support
> > 2. reading cpu and pci addresses from device tree to configure regions.
> > 3. got rid of unnecessary wrappers for readl and writel.
> > 4. got rid of endpoint configuration code.
> > 5. added 'dma-ranges' property support to read inbound region configuration.
> > 6. renamed host driver file to 'pci-xgene.c' from 'pcie-xgene.c'
> > 7. dropped 'clock-names' property from bindings
> > 8. added comments whereever requested.
> >
> > Tanmay Inamdar (4):
> >   pci:host: APM X-Gene PCIe controller driver
> >   arm64: dts: APM X-Gene PCIe device tree nodes
> >   dt-bindings: pci: xgene pcie device tree bindings
> >   MAINTAINERS: entry for APM X-Gene PCIe host driver
> >
> >  .../devicetree/bindings/pci/xgene-pci.txt          |  55 ++
> >  MAINTAINERS                                        |   8 +
> >  arch/arm64/boot/dts/apm-mustang.dts                |   8 +
> >  arch/arm64/boot/dts/apm-storm.dtsi                 | 160 ++++++
> >  drivers/pci/host/Kconfig                           |  10 +
> >  drivers/pci/host/Makefile                          |   1 +
> >  drivers/pci/host/pci-xgene.c                       | 638 +++++++++++++++++++++
> >  7 files changed, 880 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pci.txt
> >  create mode 100644 drivers/pci/host/pci-xgene.c
> >
> > --
> > 1.9.1
> >
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

