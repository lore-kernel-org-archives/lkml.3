Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3FFPVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:21:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3FFPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:21:32 -0400
Date: Thu, 6 Jun 2013 08:21:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Increase the number of USB to serial devices we can
 support at once
Message-ID: <20130606152131.GA6935@kroah.com>
References: <20130605175426.GA13461@kroah.com>
 <20130606150112.GA22984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606150112.GA22984@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:01:12AM -0400, Dave Jones wrote:
> On Wed, Jun 05, 2013 at 10:54:26AM -0700, Greg KH wrote:
>  > Here are 3 patches that I've tested out on my system with only a small
>  > number of devices, but it seems to work, so why not let others try it
>  > out...
>  > 
>  > These patches make the USB to serial core have the ability to support up
>  > to 3000 devices at once now.  
> 
> I'm curious how this works. What systems have 3000 usb ports ?
> Or are there some kind of multiplexer devices out there ?
> (If so, I'd like a link, I could use one of those).

You don't need a multiplexer, you can have a bunch of different USB root
hubs in PCI slots, with USB hubs plugged into them, and lots of
multi-port USB devices connected to them.  Tobias has such a system with
272 single-port USB to serial devices connected, so it's not impossible
to create.

In thinking about it some more, I'll change that number to 500 for now,
as it's a static array within the tty layer, and then work on making
that dynamic so we don't have any limitations other than the number of
minor numbers for a single major.

thanks,

greg k-h
