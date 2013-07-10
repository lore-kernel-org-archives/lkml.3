Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3GJWEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:04:44 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:44940 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3GJWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:04:42 -0400
Date: Wed, 10 Jul 2013 15:04:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: Driver core and sysfs changes for attribute groups
Message-ID: <20130710220441.GA21611@roeck-us.net>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 01:05:08PM -0700, Greg Kroah-Hartman wrote:
> Hi all,
> 
> Guenter and Oliver have been pointing out a few limitations of the
> driver core's ability to create files properly (i.e. in a way that
> doesn't race with userspace.)  The driver core allows this, but it
> doesn't export that ability to drivers very easily, and for binary
> files, not at all.
> 
> So here's a set of 6 patches that I'll be queueing up to go to Linus in
> time for 3.11 so that people can start using them in their driver
> subsystems.  It adds some new macros to make using attributes and
> attribute groups easier, adds binary file capabilities to attribute
> groups, and finally, lets subsystems (like platform drivers) set a
> attribute group for when their device is created.
> 
> If anyone has any problems with these patches, please let me know.
> 
> Guenter, I've tweaked your original patch a bit, changing the name of
> the function and putting the kernel doc comments in the correct place so
> the build doesn't complain about it.
> 
I like it - thanks a lot for picking that up. I think there are several
drivers who could and should use the new API call (gpio, infiniband/umad,
c2port, ptp, scsi/osst, android/timed_output, asus_oled are some examples).

For hwmon, I ended up having to handle device creation internally after all.
Reason is that I also had to set device->type to a new hwmon device type.
That in turn was necessary to be able to support the hwmon 'name' attribute
properly (it has to be optional, meaning I could not use class->dev_attrs but
had to use device_type->groups instead). I hope I can send out a revised
series of patches soon .. only I'll leave for pto next week and I am bugged
down with other work right now, so it may have to wait until after I return.

Wonder if it would make sense to support a core driver API call for that
purpose as well - ie one that not only has the additional groups argument,
but one that (also ?) accepts a pointer to the the device type. I didn't spend
any time tracking down potential users, though, so I may be off track here.

> I also have a set of follow-on patches, about 50+ big so far, that goes
> through the kernel and converts different drivers and subsystems to
> properly use attribute groups, instead of open-coding binary files and
> attributes.  Those patches will be sent out later, and will be for 3.12
> as they aren't needed at the moment, this infrastructure changes are
> needed first.
> 
Wow ... you really got into cleanup mode!

Thanks,
Guenter
