Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaCGASS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:18:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaCGASQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:18:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v5 3/3] arm64: Add architecture support for PCI
Date: Fri, 7 Mar 2014 01:17:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
References: <1393948216-11599-1-git-send-email-Liviu.Dudau@arm.com> <201403042328.51361.arnd@arndb.de> <20140306161713.GH6457@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140306161713.GH6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403070117.47125.arnd@arndb.de>
X-Provags-ID: V02:K0:yjLtEat20V3HaEoXzXIn+yhN8B8mcJFyPqFfLsqZZjf
 oJZEl2UA76Vwg0pp/qE3vz40Q4E4CHjrrr2LE8VJO2BcnfbP7H
 8TY/mXM1F+7tjt7UBrgrUzn35eksdyMa9ynEvNGrPqCi/ywtFd
 6kzm9k5AqMDReafYiHJvrGDfca1eBZ81CpbDGsIdp1d5rHbyNT
 9BslIU1BMfqunhSabqi0G3daRLeDhyMT8C7WIyVQvFDAGSXrJG
 pOr1uCrWcKiO9qRojcOrpTUbrXFnUms+NvG1McDCJcSwRf70Ev
 OxDTPTZuOm4sIPOyWrMVVGTMOGiYTYbskYooZ10toJfv9vDGyR
 1zWzB027n+ddzZc3BhAnqP6glpUmqc9z7fi5ph9/1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2014, Liviu Dudau wrote:
> On Tue, Mar 04, 2014 at 10:28:51PM +0000, Arnd Bergmann wrote:
> > On Tuesday 04 March 2014, Liviu Dudau wrote:
> > 
> > > +extern int isa_dma_bridge_buggy;
> > 
> > As commented before, I still think we can hardcode this to off
> 
> Unfortunately that doesn't work when you have CONFIG_PCI=y. drivers/pci/pci.c has:
> 
> drivers/pci/pci.c:int isa_dma_bridge_buggy;
> drivers/pci/pci.c:EXPORT_SYMBOL(isa_dma_bridge_buggy);
> 
> and drivers/pci/quirks.c does:
> 
> drivers/pci/quirks.c:   if (!isa_dma_bridge_buggy) {
> drivers/pci/quirks.c:           isa_dma_bridge_buggy=1;
> drivers/pci/quirks.c-           dev_info(&dev->dev, "Activating ISA DMA hang workarounds\n");
> drivers/pci/quirks.c-   }
> 

Ah, I see. Should we maybe move the declaration to a more generic header
file then? If the architectures cannot override it anyway, it shouldn't
be up to the architecture to declare it.

	Arnd
