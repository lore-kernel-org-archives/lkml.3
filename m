Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3JJRo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:44:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3JJRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:44:58 -0400
Date: Thu, 10 Oct 2013 10:44:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sysfs for my chips
Message-ID: <20131010174457.GE13759@kroah.com>
References: <1381378788.4330.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381378788.4330.30.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 03:19:48PM +1100, Benjamin Herrenschmidt wrote:
> Hi Greg !
> 
> (random CC list of clueful people)
> 
> On some new powerpc platforms (non-hypervisor or rather linux is the
> hypervisor), I want to expose a bunch of stuff per "chip", the chips
> being currently the processor chips and the "centaurs" (think of them as
> the bottom half of the memory controllers).
> 
> Among other, I want a sysfs file in there to access "xscom" on the chip
> which is a sideband bus used for low level stuff (think jtag on steroid)
> which we can use, among others, for chip health monitoring, general
> debugging and diagnostics, etc...
> 
> I might add more such as VPD, model information, etc... later or at
> least a link to corresponding device-tree node.

So a mixture of things that traditionally have been in /proc/cpuinfo?

I've always wanted to see the cpuinfo files turn into sysfs files, so
that tools can parse them "properly" and not have to do different things
on different arches, like the proc/cpuinfo file is today (a mess).

> How do you suggest I expose that ? So far I've been thinking about
> something like
> 
> 	/sys/chips/{processor,centaur}/chip#/files
> 
> or to avoid namespace clashes
> 
> 	/sys/firmware/chips/{processor,centaur}/chip#/files
> 
> Or maybe just
> 
> 	/sys/firmware/chips/chip#/files
> 
> (the chip type can be inferred from the chip#, they use the same space
> at least as far my firmware exposes them to Linux)
> 
> (the actual access to xscom goes via firmware tho it makes *some* sense)
> 
> But I could instead create platform devices corresponding to the
> device-tree representation of each of those chips ... and have the
> platform devices contain the magic attributes. That's a bit more
> convoluted though.

We already create platform devices for the cpus in the system in
/sys/devices/system/, so can you just hang the attribute files off of
those platform devices?

And system devices seem like the correct thing for your "chips" that are
not cpus, right?

thanks,

greg k-h
