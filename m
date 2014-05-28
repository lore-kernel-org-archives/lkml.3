Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaE1VWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:22:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:40467 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaE1VWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:22:34 -0400
Date: Wed, 28 May 2014 23:22:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch V3 19/37] x86, irq: introduce mechanisms to support
 dynamically allocate IRQ for IOAPIC
In-Reply-To: <alpine.DEB.2.10.1405282301310.3952@nanos>
Message-ID: <alpine.DEB.2.10.1405282320430.3952@nanos>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com> <1401178092-1228-20-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405271445050.21720@ionos.tec.linutronix.de> <53856D8E.3010401@linux.intel.com>
 <alpine.DEB.2.10.1405282301310.3952@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Thomas Gleixner wrote:
> On Wed, 28 May 2014, Jiang Liu wrote:
> > This is used to work around special non-ISA interrupts with GSI below
> > NR_IRQS_LEGACY. The original code for the special case is:
> > /*
> >  * Provide an identity mapping of gsi == irq except on truly
> >  * weird platforms that have non isa irqs in the first 16 gsis.
> >  */
> > return gsi >= NR_IRQS_LEGACY ? gsi : gsi_top + gsi;
> 
> That looks really, really wrong. What's wrong with assigning that irq
> irq number on those platforms?
> 
> The weird stuff is SFI and devicetree, if I understand your code
> correctly.
> 
> So if those platforms do not have actual legacy irqs, what's wrong
> with giving out the legacy numbers?

Though if it's a real issue, we can simply mark the ioapic on those
devices as DYNAMIC and avoid that whole magic.

Thanks,

	tglx
