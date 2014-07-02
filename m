Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaGBR42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:56:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaGBR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:56:26 -0400
Date: Wed, 2 Jul 2014 10:56:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Message-ID: <20140702175611.GB21063@kroah.com>
References: <3135210.ApPvOPL31q@vostro.rjw.lan>
 <Pine.LNX.4.44L0.1407021002380.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1407021002380.874-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 10:27:06AM -0400, Alan Stern wrote:
> On Wed, 2 Jul 2014, Rafael J. Wysocki wrote:
> 
> > > Then you have no other objections to the patch?
> > 
> > My concern still is that it will be confusing, because people won't read the
> > documentation carefully enough and will confuse "runtime PM never used" with
> > "hardware can't do PM".  I'm not sure how to make that more clear, though.
> 
> I could emphasize that distinction a little more strongly in the 
> documentation.
> 
> > Also we have the no_callbacks flag and I wonder if/how it is related to the
> > new one.  Do we still need both?
> 
> They mean different things.  The no_callbacks flag is used when we want 
> the PM core to think the device can be in RPM_SUSPENDED at times (it is 
> "logically suspended").  rpm_not_supported is used when we want the PM 
> core to think the device must always be in RPM_ACTIVE.
> 
> > In addition to that, I think that "hardware can't do PM" should apply to the
> > handling of system suspend resume too.
> 
> Maybe.  For the use case Dan Williams and I are working on, it doesn't 
> matter; for other cases it might matter.  That's why I named the flag 
> "rpm_not_supported" -- it applies specifically to runtime PM, not 
> system PM.
> 
> Here's a brief summary of the story behind this patch...
> 
> At one point, I suggested to Dan that instead of doing something
> special for these devices, we could simply have the runtime_suspend()
> routine always return -EBUSY.  He didn't like that idea because then
> the user would see the device was never powering down but would have no
> idea why.  The rpm_not_supported flag provides this information to the
> user by causing the power/runtime_status attribute to say "not
> supported".  (Although to be entirely fair, we could just put a message
> in the kernel log during probe if the hardware doesn't support runtime
> suspend.)
> 
> Instead, Dan introduced a messy PM QoS mechanism in commit
> e3d105055525.  I didn't like that approach, but Greg merged it before I
> objected.

Sorry about that, we can always revert it :)

greg k-h
