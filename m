Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaGIN7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:59:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41057 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbaGIN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:59:30 -0400
Date: Wed, 9 Jul 2014 09:59:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v3 1/7] xen-pciback: Document the various
 parameters and attributes in SysFS
Message-ID: <20140709135922.GD21837@laptop.dumpdata.com>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
 <1404845909-13563-2-git-send-email-konrad@kernel.org>
 <53BD32C2.6000306@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD32C2.6000306@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:17:06PM +0100, David Vrabel wrote:
> On 08/07/14 19:58, konrad@kernel.org wrote:
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Which hadn't been done with the initial commit.
> [...]
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> > @@ -0,0 +1,84 @@
> > +What:           /sys//module/xen_pciback/parameters/verbose_request
> 
> It's my understanding that module parameters are not typically part of
> the ABI.
> 
> > +What:           /sys/module/xen_pciback/parameters/permissive
> > +Date:           Oct 2011
> > +KernelVersion:  3.1
> > +Contact:        xen-devel@lists.xenproject.org
> > +Description:
> > +                Allow non-emulated (raw) access to PCI configuration space by
> > +                the guest frontend. This can have adverse affect as the guest
> > +                can destabilize the initial domain.
> 
> WTF?  Why does it even have such an unsafe option?

For those users who want to those drivers to have full access to it.
> 
> 
> > +What:           /sys/bus/pci/drivers/pciback/irq_handlers
> > +Date:           Oct 2011
> > +KernelVersion:  3.1
> > +Contact:        xen-devel@lists.xenproject.org
> > +Description:
> > +                A list of all of the PCI devices owned by Xen PCI back and
> > +                whether Xen PCI backend will acknowledge the interrupts received
> > +                and the amount of interrupts received. Xen PCI back acknowledges
> > +                said interrupts only when they are level, shared with another
> > +                guest, and enabled by the guest.
> 
> This should be a device property or something in debugfs.

<nods>Good idea.

<puts it on the todo list>
> 
> > +What:           /sys/bus/pci/drivers/pciback/irq_handler_state
> > +Date:           Oct 2011
> > +KernelVersion:  3.1
> > +Contact:        xen-devel@lists.xenproject.org
> > +Description:
> > +                An option to toggle Xen PCI back to acknowledge (or stop)
> > +                interrupts for the specific device regardless of whether the
> > +                device is shared, enabled, or on a level interrupt line.
> > +                Writing a string of DDDD:BB:DD.F will toggle the state.
> > +                This is Domain:Bus:Device.Function where domain is optional.
> 
> I do not understand under what circumstances this should be used in.

So that dom0 does not disable the IRQ line as it would be getting the IRQs
for the guest as well (because the IRQ line is level and another guest
uses an PCI device that is using the same line).
> 
> David
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
