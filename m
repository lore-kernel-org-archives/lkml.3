Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937090Ab3DJQdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:33:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58285 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374Ab3DJQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:33:43 -0400
Date: Wed, 10 Apr 2013 09:33:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific
 Kconfig options
Message-ID: <20130410163340.GA21840@kroah.com>
References: <1365610097-10955-1-git-send-email-kys@microsoft.com>
 <20130410154957.GA13849@kroah.com>
 <a3b67bf6e11c462d826c1fc4957c3da9@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3b67bf6e11c462d826c1fc4957c3da9@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:12:24PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, April 10, 2013 11:50 AM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific Kconfig
> > options
> > 
> > On Wed, Apr 10, 2013 at 09:08:17AM -0700, K. Y. Srinivasan wrote:
> > > The guest ID captures information about the guest and has room for
> > > distributions to add distro specific information. Add Kconfig options
> > > to support distro specific information to be managed easily.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  drivers/hv/Kconfig        |   14 ++++++++++++++
> > >  drivers/hv/hv.c           |    4 +++-
> > >  drivers/hv/hyperv_vmbus.h |    2 +-
> > >  3 files changed, 18 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> > > index 0403b51..d2ca9c7 100644
> > > --- a/drivers/hv/Kconfig
> > > +++ b/drivers/hv/Kconfig
> > > @@ -19,4 +19,18 @@ config HYPERV_BALLOON
> > >  	help
> > >  	  Select this option to enable Hyper-V Balloon driver.
> > >
> > > +config HYPERV_GUEST_D1
> > > +	hex "Distro specific information"
> > > +	range 0x00 0xff
> > > +	default 0
> > > +	help
> > > +	  This specifies the Distro vendor
> > 
> > And just what is a distro supposed to set the value here to?  For
> > example, what would Arch Linux pick?  Fedora?  RHEL?  SLES?  openSUSE?
> > You do know that there are more than 0xff different Linux distro
> > "vendors"?  Do they all just get to pick a number that they like?
> 
> MSFT is planning to manage this space; we will assign distributions
> unique numbers that they can use here.

And how will that happen?  A single line in a Kconfig file doesn't cut
it, sorry.

What's wrong with lanana.org managing it instead?  That's who manages
all of the rest of the kernel-limited resources.

And what happens when you have more than 256?  We already know that's
not going to be enough numbers, why start out already with an obsolete
range?

> > > +config HYPERV_GUEST_D2
> > > +	hex "Additional Distro specific information"
> > > +	range 0x0000 0xffff
> > > +	default 0
> > > +	help
> > > +	  Additional Distro specific kernel version information
> > 
> > Again, what is a distro supposed to do here?  What's wrong with the
> > kernel version information that the kernel already has?  Can't you just
> > use that string?
> 
> We already have the kernel version information. Distros can choose to
> use this as they please. We are recommending that they use this field
> to track some distro specific build number.

That's in the kernel version already, why put it here again?

Again, you need _way_ more than just a single Kconfig line for new
configuration options where you expect distros to set a value to a
unique thing,

And lastly, you do know about /etc/os-release, the cross-distro,
standardized way to specify distro version and build information,
right?  Why aren't you just using that instead of creating your own
"unique" way of defining the exact same thing?

Don't create a new standard just when we all finally picked one to
follow, it makes it look like you don't think what the community decided
on is valid, which isn't a wise decision.

greg k-h
