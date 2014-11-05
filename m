Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKEWIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:08:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaKEWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:08:07 -0500
Date: Wed, 5 Nov 2014 14:08:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: sostalle <sean.stalley@intel.com>
Cc: steph <stephanie.s.wallick@intel.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141105220806.GB15806@kroah.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
 <20141103212139.GB7379@kroah.com>
 <20141104000442.GC8890@steph-desktop>
 <20141104001355.GA10900@kroah.com>
 <20141105201433.GA4354@sean.stalley.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105201433.GA4354@sean.stalley.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 12:14:33PM -0800, sostalle wrote:
> On Mon, Nov 03, 2014 at 04:13:55PM -0800, Greg KH wrote:
> > On Mon, Nov 03, 2014 at 04:04:42PM -0800, steph wrote:
> > > On Mon, Nov 03, 2014 at 01:21:39PM -0800, Greg KH wrote:
> > > > On Mon, Nov 03, 2014 at 12:42:48PM -0800, Stephanie Wallick wrote:
> [snip] 
> > > > > +static int mausb_hcd_init(void)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	/* register HCD driver */
> > > > > +	ret = platform_driver_register(&mausb_driver);
> > > > 
> > > > Why is this a platform driver?  How does this relate to platform
> > > > hardware?
> > > > 
> > > The driver doesn't require platform resources. It looks like a host
> > > controller driver but communicates over the network instead of to
> > > a physical host controller. There is no MA USB-specific hardware.
> > > 
> > > Should we use a struct device instead of a struct platform_device?
> > 
> > Yes, please make it a "virtual" device.
> > 
> 
> Is it OK for our virtual host controller to use struct platform_device?
> 
> The other virtual host controllers (usbip/vhci_hcd.c & gadget/udc/dummy_hcd.c)
> use the platform_device struct. Unless I am missing something, it doesn't look
> like the other virtual host controllers use platform resources.
> 
> If it is not ok, is there a good example somewhere of a virtual non-platform
> device?

If your device is not really a platform device (i.e. no platform
resources), then just create a virtual device with a call to
device_create() and don't pass in a parent pointer.  But you need to
create a class for it, which is a pain, but shouldn't be that hard.

Hope this helps,

greg k-h
