Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaDKVE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:04:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59437 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbaDKVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:03:59 -0400
X-Sasl-enc: 6kXD7fV/tDjp3De4OO/PIQJEPax2TuucPfBkIzX5bTXT 1397250234
Date: Fri, 11 Apr 2014 14:06:39 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Daniel J Blueman <daniel@quora.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [Patch v2 00/14] Thunderbolt support for Apple MBP
Message-ID: <20140411210639.GA22760@kroah.com>
References: <1397175901-4023-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397175901-4023-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 02:24:47AM +0200, Andreas Noever wrote:
> Hi
> 
> This is version 2 of my Thunderbolt driver for Apple hardware (see [1] for v1).
> The short story is that Apple decided to implement hotplug support in a driver
> instead of the firmware. The firmware will only initialize coldplugged devices.
> Hotplugged devices do not work.
> 
> This series adds support for single device hotplug (no chaining) for the Cactus
> Ridge C4 Thunderbolt controller (device id 0x1547, present on MacBookPro10,1).
> As far as I can tell newer generations work quite similar and it should be
> possible to add support for more controllers with some work.
> 
> Changes from v1:
>  - suspend/hibernate support (yeah)
>  - general cleanups and refactoring
> 
> >From my perspective the driver is working quite well and is ready for merging
> (maybe someone can tell me whom I should ask to get a review?). I have taken
> some care to not stomp on tunnels setup by the firmware for coldplugged
> devices. If this works as intendend then there should be no regressions
> (coldplugged devices continue to work and simple hotplugged devices will start
> working). In particular the Apple Ethernet adapter works very well (and this is
> probably the most used TB device out there).
> 
> Some notes:
>  - The patch requires Matthew's acpi_osi fix [2]
>  - @pci, Bjorn: I hope patch 12 is acceptable. If there is a better way to do
>    this please let me know.
>  - Thunderbolt displays: I have a pretty good idea on how they should work, but
>    I did not yet write any code to support them. Also judging by the replies I
> got for v1 of the patch it seems that there are some graphics driver problems
> even with coldplugged tb displays (at least on MBP models with discrete
> graphics cards).
>  - Hibernate gotcha: The amount of available memory reported by the firmware
>    depends on whether a tb device is connected. This makes Linux refuse to
> restore the saved image. This has nothing to do with this driver, but you might
> run into it during testing.

Very nice work with all of this, I never thought I would ever see this
happen for Linux.  Of course, I now can't find my thunderbolt ethernet
device around here anymore to test this out, I'll go get another one
soon...

thanks,

greg k-h
