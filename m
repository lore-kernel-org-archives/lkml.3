Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaB0BbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:31:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaB0BbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:31:18 -0500
Date: Wed, 26 Feb 2014 17:34:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
Message-ID: <20140227013424.GA9991@kroah.com>
References: <530E6F76.1070605@zytor.com>
 <20140226232859.GA9213@kroah.com>
 <530E82B2.3040305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E82B2.3040305@zytor.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 04:11:30PM -0800, H. Peter Anvin wrote:
> On 02/26/2014 03:28 PM, Greg KH wrote:
> >>
> >> What do we need to do to actually make our tools be able to do work for
> >> us?  Newbie projects to clean up?  Trying to get the larger Linux
> >> companies to put resources on it?
> > 
> > It's not the easiest "newbie" project as usually the first reflex to
> > "just cast it away" is wrong for a lot of sparse warnings.  I know this
> > from people trying to fix up the sparse warnings in drivers/staging/
> > 
> 
> I have seen this phenomenon, too.  I also see a bunch of sparse warnings
> which are clearly bogus, for example complaining about sizeof(bool) when
> in bits like:
> 
> 		__this_cpu_write(swallow_nmi, false);
> 
> So getting this to the point where it is genuinely useful and can be
> made a ubiquitous part of the Linux development process is going to take
> more work and probably involve improvements to sparse so we can indicate
> in the kernel sources when something is okay or removing completely
> bogus warnings, and so on.

Yes, for some areas of the kernel it will take some work, but for
others, sparse works really well.  As an example, building all of
drivers/usb/* with sparse only brings up 2 issues, both of which should
probably be fixed (or annotated properly in the case of the locking
warning.)  So keeping things "sparse clean" there is quite easy and part
of taking new patches.

> The bigger question, again, is what do we need to do to make this
> happen, assuming it is worth doing?  We certainly have had bugs,
> including security holes, which sparse would have caught.  At the same
> time, this kind of work tends to not be the kind that attract the top
> hackers, unfortunately, as it is not "fun".

I guess the first thing would be to do is look to try to fix things like
the "bool" issue you have here.  And just grind away at the issues, one
by one.  Some of us like doing those types of things, so I'm sure you
can find people willing to do it if you get the word out.

Once we hit a "tipping point" of the kernel being almost sparse clean,
having the main subsystem maintainers always run it would be good.  I
know the 0-day bot runs it, as I get patches all the time from it to fix
up some sparse warnings.

greg k-h
