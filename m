Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaG1POF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:14:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaG1PN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:13:59 -0400
Date: Mon, 28 Jul 2014 07:56:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH v5 1/6] xen-pciback: Document the various parameters and
 attributes in SysFS
Message-ID: <20140728145636.GC8027@kroah.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
 <1405354736-7358-2-git-send-email-konrad.wilk@oracle.com>
 <53D64A52.7030705@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D64A52.7030705@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:04:18PM +0100, David Vrabel wrote:
> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> > Which hadn't been done with the initial commit.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> > v2: Dropped the parameters and one that is unlikeable.
> > ---
> >  Documentation/ABI/testing/sysfs-driver-pciback | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
> > new file mode 100644
> > index 0000000..cdc8340
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> > @@ -0,0 +1,25 @@
> > +What:           /sys/bus/pci/drivers/pciback/quirks
> > +Date:           Oct 2011
> > +KernelVersion:  3.1
> > +Contact:        xen-devel@lists.xenproject.org
> > +Description:
> > +                If the permissive attribute is set, then writing a string in
> > +                the format of DDDD:BB:DD.F-REG:SIZE:MASK will allow the guest
> > +                to write and read from the PCI device. That is Domain:Bus:
> 
> "...write and read the PCI device's configuration space."

How is this different from the normal pci device config file?

> 
> > +                Device.Function-Register:Size:Mask (Domain is optional).
> > +                For example:
> > +                #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/quirks
> > +                will allow the guest to read and write to the configuration
> > +                register 0x0E.
> > +
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
> That's not very nice sysfs file.  This sort of thing ought to be in
> debugfs.  Perhaps we shouldn't document it for now and try to move it to
> debugfs later?

Move it to debugfs now would be better, that's not an acceptable sysfs
file at all, thanks for pointing it out.

thanks,

greg k-h
