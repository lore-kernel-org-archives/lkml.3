Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3CSO4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:56:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58696 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756233Ab3CSO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:56:05 -0400
Date: Tue, 19 Mar 2013 10:56:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Julius Werner <jwerner@chromium.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: Make USB persist default configurable
In-Reply-To: <20130319000656.GC6516@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1303191044150.15684-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Greg Kroah-Hartman wrote:

> On Mon, Mar 18, 2013 at 05:02:19PM -0700, Julius Werner wrote:
> > > Why can't you just revert this in userspace?  Isn't that easier than
> > > doing a kernel patch and providing an option that we need to now
> > > maintain for pretty much forever?
> > 
> > I could solve it in userspace, but that really feels like a hacky
> > workaround and not a long term solution. It would mean that every new
> > device starts with persist enabled and stays that way for a few
> > milliseconds (maybe up to seconds if it's connected on boot), until
> > userspace gets around to disable it again... opening the possibility
> > for very weird race conditions and bugs with drivers/devices that
> > don't work with persist.
> 
> What drivers/devices don't work with persist?  We need to know that now,
> otherwise all other distros and users have problems, right?
> 
> > This default is a policy that really resides in the kernel, it has
> > changed in the past, and since there is no definitive better choice
> > for all cases I thought making it configurable is the right thing to
> > do.
> 
> Too many options can be a bad thing.
> 
> I think Alan made this a "always on" option, so I'd like to get his
> opinion on it.  Alan?

Originally the "persist" attribute defaulted to "off".  Linus disliked 
this (at least, he disliked it for mass-storage devices) and so at his 
request the default was changed to "on".  There didn't seem to be any 
reason to treat other devices differently from mass-storage devices; 
consequently the default is now "on" for everything.

Julius's commit message mentions the disadvantage of "persist": Resume
times can be increased.  But it doesn't mention the chief advantage:  
Filesystems stored on USB devices are much less likely to be lost
across suspends.

The races mentioned above don't seem to be very dangerous.  How likely
is it that the system will be suspended within a few milliseconds of
probing a new USB device?

As for buggy devices and drivers that can't handle persist, we have
better ways of dealing with them.  Buggy devices can get a quirk flag
(USB_QUIRK_RESET).  Buggy drivers should be fixed.

Alan Stern

