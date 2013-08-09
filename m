Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031698Ab3HIXqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:46:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031620Ab3HIXqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:46:31 -0400
Date: Fri, 9 Aug 2013 16:46:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130809234629.GA16866@kroah.com>
References: <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202B674.7060005@linuxtoys.org>
 <20130807213325.GB5373@kroah.com>
 <520569B2.4000704@linuxtoys.org>
 <20130809230150.GA23418@kroah.com>
 <52057CB4.2020603@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52057CB4.2020603@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 04:35:16PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> >Good protocols exist, look at protobufs from Google if you want to
> >define your own.  Never create your own protocol these days, it doesn't
> >make sense, be it a text one or something else.
> 
> OK.  I was using the term in the broader sense in which _meaning_ is
> assigned to the data in the protocol, not just the data marshaling.

Again, protobufs are a great way to define the meaning of the protocol
in a manner that is descriptive, fast, versioned, discoverable, and best
of all for you, with bindings for all languages :)

> >Not true at all, I know all about userspace drivers, look at the UIO
> >code in the Linux kernel.  It was created explicitly for this exact
> >thing, and to prevent the myrads of broken implementations from being
> >created again and again and again.  Just use it if you wish to talk to
> >your hardware directly, lots of people do so.
> Well, not this exact thing.  UIO is great if your hardware hangs
> on a bus directly connected to the CPU.  It does nothing to help
> the case of hardware connected over some communications link.

Like PCI?  :)

Actually, I'm not kidding about that, I have a PCI bus here that is
across a flexible cable that can dynamically be plugged and unplugged
from a machine at any point in time using a communications link.  It's
called Thunderbolt today, but has been called ExpressBus, and lots of
other names in the past.

> >>As an _opinion_ only, I think maybe userspace device drivers do exist.
> >>It refers to  hardware that the kernel is not, and should not, be aware
> >>of.  This hardware is not seen because it is at the end of some kind of
> >>communications channel like USB-serial or Ethernet. A developer might
> >>like to view that hardware as part of the overall system even if Linux
> >>and the CPU do not have direct access to it.  A userspace driver looks
> >>something like this
> >>
> >>	=(ProxyDevNode)====(daemon)===(CommChannel)===(hardware)
> >
> >Not really, you are just using an IPC to talk to a "real" device driver.
> 
> Yes, each of the "=" above has data passing through a real driver.

No it doesn't.  A "real" driver talks to hardware.  You only have that
for the last "===".

> >FPGAs are interesting things, people are creating "real" drivers for
> >them (see the linux-kernel archives for a few examples.)  Other people
> >just use the UIO layer instead, which works quite well for them.  I
> >suggest you do the same thing.
> 
> UIO can not see hardware at the end of a USB-serial link.

Nor should it ever be used for something like that.  There is a protocol
for this device that the kernel exposes, use it :)

thanks,

greg k-h
