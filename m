Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaEPP2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:28:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:34963 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaEPP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:28:30 -0400
Date: Fri, 16 May 2014 17:28:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org
Subject: Re: [RFC Patch Part1 V1 00/30] use irqdomain to dynamically allocate
 IRQ for IOAPIC pin
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1405161601060.4039@ionos.tec.linutronix.de>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,

On Fri, 16 May 2014, Jiang Liu wrote:

> On x86 platforms, IRQ number are statically allocated to IOAPIC pins at boot.
> There are two issues with this design. First it causes trouble to IOAPIC
> hotplug because we need to allocate a block of IRQ numbers for each IOAPIC.
> Second it may waste IRQ nubmers even if some IOAPIC pins are not used because
> IRQ numbers are statically assigned.
> 
> This patchset tries to enable dynamic IRQ number allocation for IOAPIC
> by adopting the irqdomain framework, it solves the two issues mentioned
> above. It also simplifies the IOAPIC driver by consolidating ways to
> program IOAPIC pins with the irqdomain map interface.
> 
> We will enhance the IOAPIC driver core to support ACPI based IOAPIC hotplug
> once the IOAPIC driver has been converted to irqdomain.

Thanks for tackling this!
 
> This patchset applies to v3.15-rc4-260-g38583f095c5a and has been tested

That's a bit unfortunate, as there are conflicting changes in the tip
tree irq/core branch. Can you please rebase on top of that.

> TODO list:
> 1) check whether it affects Xen or not
> 
> Patch 1-17 are trivial code improvements, bugfixes and preparation.

Can you please move the bugfixes before the other changes, so we can
pick them up independently from the outcome?
 
> Patch 18-24 enable basic irqdomain support and IRQ number dynamic
> allocation.
> 
> Patch 25-29 consoldate the way to program IOAPIC pins by using
> irqdomain map() interface.
> 
> Patch 30 cleans up unused interfaces and functions in IOAPIC driver.
> 
> Tests and comments are warmly welcomed!

I like the general approach, but we have now a mixture of legacy irq
handling and irq domains. We really want to cleanup the legacy PIC no
ioapic case as well. That will cleanup the code further.

The other thing we discussed here: https://lkml.org/lkml/2014/5/7/901
in several places of the thread is to move the vector allocation into
a irqdomain with a generic matrix allocator as well. We have other use
cases for this as well. It would be nice if you could look at that as
well.

Thanks,

	tglx




