Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaGHSqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:46:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40090 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaGHSqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:46:35 -0400
Date: Tue, 8 Jul 2014 14:46:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] xen/pciback: Implement PCI reset slot or bus with
 'do_flr' SysFS attribute
Message-ID: <20140708184626.GA15548@laptop.dumpdata.com>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
 <1404845909-13563-5-git-send-email-konrad@kernel.org>
 <53BC324B.5090600@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BC324B.5090600@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 07:02:51PM +0100, David Vrabel wrote:
> On 08/07/14 19:58, konrad@kernel.org wrote:
> > --- a/Documentation/ABI/testing/sysfs-driver-pciback
> > +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> > @@ -82,3 +82,14 @@ Description:
> >                  device is shared, enabled, or on a level interrupt line.
> >                  Writing a string of DDDD:BB:DD.F will toggle the state.
> >                  This is Domain:Bus:Device.Function where domain is optional.
> > +
> > +What:           /sys/bus/pci/drivers/pciback/do_flr
> > +Date:           July 2014
> > +KernelVersion:  3.16
> > +Contact:        xen-devel@lists.xenproject.org
> > +Description:
> > +                An option to slot or bus reset an PCI device owned by
> > +                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
> > +                the driver to perform an slot or bus reset if the device
> > +                supports. It also checks to make sure that all of the devices
> > +                under the bridge are owned by Xen PCI backend.
> 
> Not sure I like this new interface.  I solved this by adding a new reset
> file that looked like the regular one the pci would have if it supported
> FLR.  I'm fairly sure I posted a series for this.  Was there a reason
> you didn't do this?

It did not work.

During bootup kobject would complain about a secondary 'reset' SysFS
on the PCI device.

> 
> David
