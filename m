Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaF0TS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:18:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaF0TS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:18:28 -0400
Date: Fri, 27 Jun 2014 12:22:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Message-ID: <20140627192238.GA7646@kroah.com>
References: <3098868.U0NfB8kYvJ@vostro.rjw.lan>
 <Pine.LNX.4.44L0.1406271417120.875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1406271417120.875-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:27:28PM -0400, Alan Stern wrote:
> On Wed, 25 Jun 2014, Rafael J. Wysocki wrote:
> 
> > On Sunday, June 22, 2014 12:45:42 PM Alan Stern wrote:
> > > On Sun, 22 Jun 2014, Rafael J. Wysocki wrote:
> > > 
> > > > > How would you treat them specially?  Add a "runtime_pm_not_supported" 
> > > > > flag?
> > > > 
> > > > I thought about a "runtime PM has been enabled at least once" flag rather
> > > > that would be set by pm_runtime_enable() every time it is called and never
> > > > cleared.  That would allow the core to distinguish between "runtime PM
> > > > disabled temporarily" and "runtime PM not used" which turn out to be
> > > > sufficiently different cases.
> > > 
> > > Interesting idea, but it can't tell the difference between "runtime PM
> > > not supported" and "runtime PM not enabled yet".  I think a simple "not
> > > supported" flag will be more straightforward.
> > 
> > The question is who will set the "unsupported" flag (think devices without
> > drivers etc.).  Or perhaps the idea is that it will be set to start with?
> 
> Drivers or subsystems will set the flag.  It should not be set for
> devices without drivers or subsystems, because the flag means that the
> hardware doesn't support runtime power management, and the kernel
> wouldn't know this if there was no driver or subsystem.
> 
> The flag will not be set to start with.  The idea is that you set it 
> when you know for certain that the device cannot be power-managed, but 
> you still want the Runtime PM API to work with the device.  In 
> particular, calls to pm_runtime_resume() will succeed.
> 
> > > > Yes.  The core definitely needs to be able to distinguish between the
> > > > "runtime PM disabled temporarily" and "runtime PM not supported/not used"
> > > > situations.
> > > 
> > > Let me work out a patch, and we'll see what you think.  For the time
> > > being we can stick with our "runtime PM must be disabled (or in error)  
> > > when the status is changed" approach.
> > 
> > OK
> 
> The patch is below.  I haven't tested it with anything meaningful, but 
> it seems straightforward enough.
> 
> One side point: The patch changes the string displayed for the 
> power/runtime_status attribute file when disable_depth > 0.  Instead of 
> "unsupported", it will now say "disabled".  The attribute will contain 
> "not supported" when the new flag is set.
> 
> Is this acceptable?

Why change the "unsupported" string?  Can't we just leave that one
alone?  I'd prefer to not break userspace tools...

thanks,

greg k-h
