Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3JVXqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:46:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JVXqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:46:17 -0400
Date: Wed, 23 Oct 2013 00:47:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/misc: add rawio framework and drivers
Message-ID: <20131022234743.GA12031@kroah.com>
References: <5265C0C5.70905@linux.intel.com>
 <20131022054406.GA14163@kroah.com>
 <20131022181930.GA53231@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022181930.GA53231@bingao-desk1.fm.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 11:19:30AM -0700, Bin Gao wrote:
> On Tue, Oct 22, 2013 at 06:44:06AM +0100, Greg Kroah-Hartman wrote:
> > So, just because userspace is "hard" you want to add stuff to the kernel
> > instead.
> > 
> Well, there are other reasons - "hard" is just one of them.
> For instance, on some platforms with runtime pm enabled, access to registers
> of a device which is in low power state will cause problems(syste reboot, etc.).
> You can only wake it up to running state by runtime API from kernel space.

Then write a UIO pci driver, that should work, right?

> > Sorry, but for over the past decade, we have been doing just the
> > opposite, if things can be done in userspace, then they should be done
> > there.  So for us to go in the opposite direction, like these patches
> > show, would be a major change.
> > 
> Agree, but as mentioned above, for some situation we can't do it from
> user space.
> 
> > You can already do this today for PCI with the UIO framework, right?
> > Why duplicate that functionality here with another userapce API that we
> > will then have to maintain for the next 40+ years?
> > 
> No, UIO is not appropriate for my requirement.

I don't know what your "requirements" are.

> The thing I need is to dump any registers just by 2 simple commands.

I find it hard to believe that your "requirement" dictates the exact
method of _how_ you get access to this hardware.

> > Have you run these proposed changes by any of the Intel kernel
> > developers?  What did they say to them?
> > 
> > If not, why haven't you, isn't that a resource you should be using for
> > things like this?
> > 
> Why you had these strange questions?

It's something I ask any Intel developer who sends odd patches that have
obviously not been reviewed by Intel's kernel developers.  They are a
resource you should be using to tell you these types of things, don't
make me, a community member, tell you this.

> Over years, we have been maintaining and using these drivers internally 
> for various purpose across our group for SoC pre-silicon and post-silicon
> degugging, e.g. IOAPIC RTE dumping, GPIO tunning, raw device degugging
> without a driver(i2c, spi, uart), etc., etc., ...
> Trying to push some existed codes upstream is not a bad thing.

Trying to push code that is incorrect is a bad thing.  Just because it
has been living in a private tree for X number of years is not an
excuse, because you are now asking me and others to maintain this API
you have created (which is undocumented) for the next 40+ years.

Again, use the interfaces we already have, and if they are not
sufficient for whatever reason, help make them better.  Don't create
whole new ones just because someone 5+ years ago didn't know about them,
or that they weren't even present at that time.  That's not the
community's fault, it's yours.

greg k-h
