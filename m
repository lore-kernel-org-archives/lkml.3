Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3GJWXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:23:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3GJWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:23:38 -0400
Date: Wed, 10 Jul 2013 15:23:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: Driver core and sysfs changes for attribute groups
Message-ID: <20130710222337.GB3644@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <20130710220441.GA21611@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710220441.GA21611@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 03:04:41PM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 01:05:08PM -0700, Greg Kroah-Hartman wrote:
> > Hi all,
> > 
> > Guenter and Oliver have been pointing out a few limitations of the
> > driver core's ability to create files properly (i.e. in a way that
> > doesn't race with userspace.)  The driver core allows this, but it
> > doesn't export that ability to drivers very easily, and for binary
> > files, not at all.
> > 
> > So here's a set of 6 patches that I'll be queueing up to go to Linus in
> > time for 3.11 so that people can start using them in their driver
> > subsystems.  It adds some new macros to make using attributes and
> > attribute groups easier, adds binary file capabilities to attribute
> > groups, and finally, lets subsystems (like platform drivers) set a
> > attribute group for when their device is created.
> > 
> > If anyone has any problems with these patches, please let me know.
> > 
> > Guenter, I've tweaked your original patch a bit, changing the name of
> > the function and putting the kernel doc comments in the correct place so
> > the build doesn't complain about it.
> > 
> I like it - thanks a lot for picking that up. I think there are several
> drivers who could and should use the new API call (gpio, infiniband/umad,
> c2port, ptp, scsi/osst, android/timed_output, asus_oled are some examples).

Yes, I'll be sweeping the tree for the next few released doing all of
this.  The amount of sysfs "cruft" that has accumulated in the past few
years since I last looked is crazy...

> For hwmon, I ended up having to handle device creation internally after all.
> Reason is that I also had to set device->type to a new hwmon device type.
> That in turn was necessary to be able to support the hwmon 'name' attribute
> properly (it has to be optional, meaning I could not use class->dev_attrs but
> had to use device_type->groups instead). I hope I can send out a revised
> series of patches soon .. only I'll leave for pto next week and I am bugged
> down with other work right now, so it may have to wait until after I return.
> 
> Wonder if it would make sense to support a core driver API call for that
> purpose as well - ie one that not only has the additional groups argument,
> but one that (also ?) accepts a pointer to the the device type. I didn't spend
> any time tracking down potential users, though, so I may be off track here.

I don't understand the problem, for USB we have different "types" of
devices on the bus just fine.  Or are you saying that the function you
created isn't going to be used in the hwmon core in the end?

I doubt device_create() really needs to worry about different types, but
I could be wrong :)

thanks,

greg k-h
