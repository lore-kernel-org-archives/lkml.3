Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaIZO3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:29:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55731 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaIZO3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:29:38 -0400
Date: Fri, 26 Sep 2014 16:29:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFT Part2 v2 00/24] Enable hierarchy irqdomian on x86 platforms
Message-ID: <20140926142931.GA10066@nazgul.tnic>
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 10:02:01PM +0800, Jiang Liu wrote:
> We plan to restructure x86 interrupt code based on hierarchy irqdomain,
> that is to build irqdomains for CPU vector, interrupt remapping unit,
> IOAPIC, MSI and HPET etc and organize those irqdomains in hierarchy mode.
> Each irqdomain manages corresponding interrupt controller and talks to
> parent interrupt controller through public irqdomain interfaces. We also
> support stacked irq_chip based on hierarchy irqdomain. It will make the
> x86 interrupt architecture much more clear and more easy to maintain
> with hierarchy irqdomain and stacked irq_chip. It may also help ARM
> interrupt management architecture too.
> 
> This is the second patch set to enable support of hierarchy irqdomain
> on x86 platforms. It depends on the first part at:
> https://lkml.org/lkml/2014/9/26/501
> And you may access it at:
> https://github.com/jiangliu/linux.git irqdomain/p2v2
> 
> And there will be a third patch set to convert IOAPIC driver to support
> hierarchy irqdomain and clean up code.
> 
> The first patch extends irqdomain interfaces to support hierarchy
> irqdomain. Hope this interface could be used by other architectures too,
> such as ARM/ARM64.
> The second patch introduces two helper functions to support stacked
> irq_chip.
> Patch 3-9 implements an irqdomain to manange CPU interrupt vectors, and
> it's the root irqdomain for x86 platforms.
> Patch 10-13 converts Intel and AMD interrupt remapping drivers to
> support hierarchy irqdomain.
> Patch 14-16 converts HPET and MSI to support hierarchy irqdomain.
> Patch 17-20 cleans up unsued code in x86 arch and interrupt remapping
> drivers.
> Patch 21-24 converts DMAR, HTIRQ and UV to support hierarchy irqdomain.
> 
> We have tested this patchset on Intel 32-bit and 64-bit systems. And it
> also passes Fengguang's 0day tests. But helps are need for testing:
> 1) AMD interrupt remapping 
> 2) AMD HT_IRQ

Adding Aravind.

@Aravind: you might want to give that patchset a run just in case, to
make sure it doesn't break anything on AMD. You'll need the previous
patchset to go before too, though:

https://lkml.kernel.org/r/1411738196-29958-1-git-send-email-jiang.liu@linux.intel.com

I'm sure Jiang will help you if you have more questions.

Thanks.

-- 
Regards/Gruss,
    Boris.
--
