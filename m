Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031567Ab3HIXFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:05:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031522Ab3HIXE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:26 -0400
Date: Fri, 9 Aug 2013 16:04:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130809230424.GB23418@kroah.com>
References: <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202BC11.6040605@linuxtoys.org>
 <20130807214010.GA5902@kroah.com>
 <5202C1EE.40607@linuxtoys.org>
 <20130809215449.GB21756@kroah.com>
 <5205727B.7090807@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5205727B.7090807@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 03:51:39PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> >On Wed, Aug 07, 2013 at 02:53:50PM -0700, Bob Smith wrote:
> >>Agreed.  But you need root permissions to install an application
> >>and part of that installation can be setting up systemd files
> >>that allocate resources at boot.
> >
> >Do you have examples of those systemd files?  Last I looked, they didn't
> >have mknod permissions anymore, which is a good thing.
> 
> The difference is that Linux usually detects the hardware that is
> connected to it and automatically creates device nodes for it.
> This is part of the boot process.
>     In the case of a userspace device driver, the kernel never sees
> the hardware so it is up the USD to create the nodes for the hardware.

Again, this isn't about hardware, it's about an ipc that you are
creating for user to user communication.  For this to require root
access isn't acceptable.

> >>Also, some applications start as root just so they can do this kind of
> >>allocation.  The app can (and should) drop root privileges when it
> >>can.
> >You shouldn't require root for a new feature, that seems strange.
> 
> OK, but root for a new feature dealing with hardware seems OK.

But you are NOT dealing with hardware here (well, your specific
implementation just happens to do so, but the driver sure doesn't.)

Also, root for hardware is not ok, otherwise how would you as a user be
able to talk to your serial port, or filesystem.

> >Also, namespaces aren't addressed at all, but that's a totally different
> >issue...
> 
> No, but I hope namespace policy can be handled in userspace and not
> in the proxy module itself.

How would that work out?

> > (snip)
> >>As noted above, yes, root has to set it up and set the permissions,
> >>but this is hardly unusual, is it?
> >
> >Yes it is, modern userspace does not create any device nodes anymore,
> >please let's not regress on that point.
> 
> Yes, I suppose this can be viewed as a regression, but I don't see a
> way around this right now.  The problem is that only the userspace
> driver sees the new hardware and so knows what device nodes to create.

Again, there is no "hardware" in your driver, that just happens to be
how you are using this IPC.  I could be using "hardware" for a daemon
that talks over a named pipe, but that doesn't mean anything to the
kernel code, right?

thanks,

greg k-h
