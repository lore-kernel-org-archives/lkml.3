Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaE1Abc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:31:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaE1Aba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:31:30 -0400
Date: Tue, 27 May 2014 17:35:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 3/3] mei: add WPT second mei interface
Message-ID: <20140528003504.GB22892@kroah.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
 <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
 <20140527212207.GB26089@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFFBCDC@HASMSX106.ger.corp.intel.com>
 <20140527220630.GA7924@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFFBE0A@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFFBE0A@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:47:44PM +0000, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, May 28, 2014 01:07
> > To: Winkler, Tomas
> > Cc: arnd@arndb.de; linux-kernel@vger.kernel.org; Usyskin, Alexander
> > Subject: Re: [char-misc-next 3/3] mei: add WPT second mei interface
> > 
> > On Tue, May 27, 2014 at 09:42:19PM +0000, Winkler, Tomas wrote:
> > > > > +/* PCH devices MEI 2 interface */
> > > > > +const struct mei_cfg mei_me_pch_2_cfg = {
> > > > > +	MEI_CFG_PCH_HFS,
> > > > > +	.mei_id = 1
> > > >
> > > > That's going to be a recipe for disaster.  Have the MEI core allocate
> > > > the id numbers as things are registered, don't have the individual
> > > > drivers create their id.
> > >
> > > I'm don't think can ensure the enumeration order.
> > 
> > You should not be relying on the order to get anything right.
> > 
> > > This is per device not per driver configuration structure.
> > > Each pci device is actually just  another head to one MEI device but heads are not
> > equal the name/id matters
> > > Yes I assume it looks odd at the first glance, anyhow we are open to any
> > reasonable suggestions
> > 
> > Just dynamically allocate the numbers like all other subsystems do?
> >
> > Then userspace can open the device nodes it cares about, it should be
> > able to somehow tell what device is what somehow, right?  If not, you
> > are doing something wrong with the interface as you can't rely on minor
> > numbers.
> > 
> 
> The only way for user space to distinguish among interfaces is the same way as driver does by looking for device id. 

What's with the lack of line-wrapping?

Anyway, why does userspace care?  If it wants to look at the device id,
then just look at the symlink to the device id of the device node.  Then
you don't care what the device node is named / numbered.

> The assignment of the device name/id is pretty much static in the HW.
> Now the same device id database from the driver has to be copied to
> the udev rules or equivalent  and kept in sync.

What?  No.  Why would you want to do that?  Why does it matter what
order these devices are connected?  Are they talked to in different
ways?  Are they different "classes" of devices?  What are they and why
aren't they just "interchangeable" as far as userspace cares?

> Most importantly all the legacy user space just opens /dev/mei  so I
> wanted to leave /dev/mei (not /dev/mei0) to be assigned always to the
> first mei head and to not break existing user space. 

That's fine, I have no objection to that.

> Can you be a bit more specific on why we cannot depend on minor
> numbers and default naming rules, what is the scenario that will
> break? 

Why is the kernel picking a name for these with a specific minor number
in it?  What makes this different from a random tty device where you
don't care what the minor number is, you just care about where is it
connected so you look at the other things "around" it (pci path, vendor
id, etc.) and create a deterministic name from with a symlink, if you
care, with udev / mdev.

thanks,

greg k-h
