Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3BKNqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:46:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:28302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab3BKNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="285693805"
Date: Mon, 11 Feb 2013 14:46:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V2] mei: bus: Initial MEI bus type
 implementation
Message-ID: <20130211134612.GO20996@sortiz-mobl>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
 <20130208235341.GA24127@kroah.com>
 <20130210032555.GG20996@sortiz-mobl>
 <201302111150.26785.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302111150.26785.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Feb 11, 2013 at 11:50:26AM +0000, Arnd Bergmann wrote:
> On Sunday 10 February 2013, Samuel Ortiz wrote:
> > > >  
> > > >  /**
> > > > + * mei_bus_client
> > > 
> > > I don't really understand this structure, please explain it better.
> > This is a structure that links the MEI bus client pointer passed to the driver
> > with the actual ME client. It also allows the ME driver to implement
> > technology specific ME protocol through the send/recv hooks.
> 
> I think part of the confusion is that this is what in other subsystems
> is called a device, not a client. I believe I'm still confused in the
> same way that Greg is.
Ok, I understand where the confusion comes from now. Yes, for most of the
other subsystems, this is a device. Initially I tried to keep the MEI bus code
as little intrusive as possible and I didn't want to rename mei_device to
something else.

 
> You already have a 'struct mei_device', which refers to the PCI device
> that owns the bus, and has clients attached to it. While it may be
> a little confusing to people that already worked with the current
> mei code, I think it would help to rename the existing 'mei_device'
> to 'mei_host' or something else that feels appropriate, and introduce
> the new structure as 'mei_device' derived from 'struct device', again
> matching what most other subsystems do.
I understand, and I agree it would make sense. As we're aiming at having this
patchset merged during the next merge window, would it be ok to have this
renaming phase as a follow up patch ?

> Similarly, you can then rename 'mei_bus_driver' to 'mei_driver' to fit
> that logic, since I would consider a 'bus_driver' to be something
> that is responsible for the entire bus, not just for one device.
That would make sense as well, and I can have this done through patchset v4.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
