Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaCGBDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:03:23 -0500
Received: from dliviu.plus.com ([80.229.23.120]:40695 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaCGBDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:03:22 -0500
Date: Fri, 7 Mar 2014 01:01:41 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v5 3/3] arm64: Add architecture support for PCI
Message-ID: <20140307010140.GH13582@bart.dudau.co.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>
References: <1393948216-11599-1-git-send-email-Liviu.Dudau@arm.com>
 <201403042328.51361.arnd@arndb.de>
 <20140306161713.GH6457@e106497-lin.cambridge.arm.com>
 <201403070117.47125.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201403070117.47125.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Mar  7 01:03:21 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53191ad93192421914577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:17:46AM +0100, Arnd Bergmann wrote:
> On Thursday 06 March 2014, Liviu Dudau wrote:
> > On Tue, Mar 04, 2014 at 10:28:51PM +0000, Arnd Bergmann wrote:
> > > On Tuesday 04 March 2014, Liviu Dudau wrote:
> > > 
> > > > +extern int isa_dma_bridge_buggy;
> > > 
> > > As commented before, I still think we can hardcode this to off
> > 
> > Unfortunately that doesn't work when you have CONFIG_PCI=y. drivers/pci/pci.c has:
> > 
> > drivers/pci/pci.c:int isa_dma_bridge_buggy;
> > drivers/pci/pci.c:EXPORT_SYMBOL(isa_dma_bridge_buggy);
> > 
> > and drivers/pci/quirks.c does:
> > 
> > drivers/pci/quirks.c:   if (!isa_dma_bridge_buggy) {
> > drivers/pci/quirks.c:           isa_dma_bridge_buggy=1;
> > drivers/pci/quirks.c-           dev_info(&dev->dev, "Activating ISA DMA hang workarounds\n");
> > drivers/pci/quirks.c-   }
> > 
> 
> Ah, I see. Should we maybe move the declaration to a more generic header
> file then? If the architectures cannot override it anyway, it shouldn't
> be up to the architecture to declare it.

Yes, it's one of those cleanup jobs that seems that no one wants to take on.
I'm reluctant to deal with it here as it would easily double the size of the
patchset, so I'm currently playing along like all other architectures.

Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

