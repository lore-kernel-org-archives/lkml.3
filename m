Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbbATTPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:15:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16574 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbATTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:14 -0500
Date: Tue, 20 Jan 2015 14:12:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-pci@vger.kernel.org
Subject: Re: [Bugfix v4 1/2] xen/pci: Fix xen IRQ allocation failure caused
 by commit b81975eade8c
Message-ID: <20150120191242.GC13409@l.oracle.com>
References: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
 <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com>
 <1421327077-19894-2-git-send-email-jiang.liu@linux.intel.com>
 <20150116181318.GA22690@l.oracle.com>
 <54BC8AF4.6010504@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BC8AF4.6010504@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:41:24PM +0800, Jiang Liu wrote:
> 
> On 2015/1/17 2:13, Konrad Rzeszutek Wilk wrote:
> > On Thu, Jan 15, 2015 at 09:04:35PM +0800, Jiang Liu wrote:
> <snit>
> >>
> >> Note: we need to test this patch on those special AMD systems which
> >> override normal SCI GSI (9) with strange GSI (20).
> > 
> > [    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 2.1c       10/28/2011
> > ..
> >      0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> > [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
> > [    0.000000] ACPI: IRQ0 used by override.
> > ..
> >     6.358737] xen: registering gsi 20 triggering 0 polarity 1
> > [    6.358756] xen: --> pirq=20 -> irq=20 (gsi=20)
> > ...
> > -bash-4.1# cat /proc/interrupts |grep acpi
> >  20:          0          0          0  xen-pirq-ioapic-level  acpi
> Hi Konrad,

> 	May I assume an Tested-by from you here?

Yes for this particular use case. I hadn't yet tried to push the ACPI buttons
(this printout was from an server in a basement).
> Thanks!
> Gerry
