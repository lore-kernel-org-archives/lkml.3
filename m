Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaGPNjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:39:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996AbaGPNjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:39:01 -0400
Date: Wed, 16 Jul 2014 09:33:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 00/16] Enable support of IOAPIC hotplug on x86
 platforms
Message-ID: <20140716133305.GG19585@laptop.dumpdata.com>
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
 <20140714172642.GA12920@laptop.dumpdata.com>
 <20140714194133.GA22857@laptop.dumpdata.com>
 <53C54876.5090606@linux.intel.com>
 <20140715161035.GA8097@laptop.dumpdata.com>
 <53C5EB19.7060104@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C5EB19.7060104@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 11:01:45AM +0800, Jiang Liu wrote:
> Hi Konrad,

Hey Jiang,
> 	We have found the root cause with your great support. If BIOS
> assigns an IRQ number for a PCI device, acpi_pci_irq_enable() fails to

I would think that is a common scenario?

> assign IOAPIC IRQ then due to the check:
>         if (dev->irq > 0)
>                 return 0;

I should really look in the code to figure this out - but I think your
patch will have a detail analysis that will make tglrx happy, so
will just wait till then :-)

> 	For a quick workaround, just comment out above check. But we
> need some time to figure out a clean fixup for it. We will send out new
> version once it gets resolved.

Excellent. Once you do, please do give me the git tree so I can slurp
it in my testing

> 	Thanks for your great help again.

Of course! Thank you for your quick turn-around.
> Regards!
> Gerry
> On 2014/7/16 0:10, Konrad Rzeszutek Wilk wrote:
> > already assigned IRQ
