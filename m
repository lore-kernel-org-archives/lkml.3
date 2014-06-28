Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaF1PcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 11:32:24 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42306 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752718AbaF1PcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 11:32:22 -0400
Date: Sat, 28 Jun 2014 11:32:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
In-Reply-To: <20140627205039.GA5552@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1406281131360.983-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, Greg Kroah-Hartman wrote:

> On Fri, Jun 27, 2014 at 04:11:35PM -0400, Alan Stern wrote:
> > On Fri, 27 Jun 2014, Greg Kroah-Hartman wrote:
> > 
> > > > One side point: The patch changes the string displayed for the 
> > > > power/runtime_status attribute file when disable_depth > 0.  Instead of 
> > > > "unsupported", it will now say "disabled".  The attribute will contain 
> > > > "not supported" when the new flag is set.
> > > > 
> > > > Is this acceptable?
> > > 
> > > Why change the "unsupported" string?  Can't we just leave that one
> > > alone?  I'd prefer to not break userspace tools...
> > 
> > I changed it because it's wrong.  disable_depth > 0 means that runtime 
> > PM has temporarily been disabled, or was never enabled in the first 
> > place.  It doesn't mean that runtime PM is unsupported.
> > 
> > In fact, the word "unsupported" is ambiguous.  Does it mean unsupported 
> > by the hardware or unsupported by the kernel?  The hardware can't 
> > change, but the kernel can be altered by loading a module.
> > 
> > If that change is too intrusive, I can remove it from the patch.
> 
> Do you know of any tools that actually look at these files?

I don't.  Of course, that doesn't mean much.

> If there isn't any, then we can try to change it and see who screams :)

It'll be a learning experience...

Alan Stern

