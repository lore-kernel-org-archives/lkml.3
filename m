Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3HZRTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:19:11 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43255 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3HZRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:19:06 -0400
Date: Mon, 26 Aug 2013 10:19:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Meelis Roos <mroos@linux.ee>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steve Cotton <steve@s.cotton.clara.co.uk>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: OHCI: fix build error related to ohci_suspend/resume
Message-ID: <20130826171903.GA21675@roeck-us.net>
References: <20130826042653.GA2778@kroah.com>
 <Pine.LNX.4.44L0.1308261051340.1445-100000@iolanthe.rowland.org>
 <20130826153840.GA29862@kroah.com>
 <20130826160627.GA11307@roeck-us.net>
 <20130826165022.GA2113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826165022.GA2113@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:50:22AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Aug 26, 2013 at 09:06:27AM -0700, Guenter Roeck wrote:
> > On Mon, Aug 26, 2013 at 08:38:40AM -0700, Greg Kroah-Hartman wrote:
> > > On Mon, Aug 26, 2013 at 10:53:53AM -0400, Alan Stern wrote:
> > > > Commit 9a11899c5e69 (USB: OHCI: add missing PCI PM callbacks to
> > > > ohci-pci.c) added missing ohci_suspend and ohci_resume callback
> > > > pointers, but forgot that these callbacks are declared and defined
> > > > only when CONFIG_PM is enabled.
> > > > 
> > > > This patch adds a preprocessor conditional to avoid build errors when
> > > > PM is disabled.
> > > > 
> > > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > > > 
> > > > ---
> > > 
> > > Guenter and Meelis, does the patch below fix the problem for you?
> > > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> > 
> > Previously failing builds:
> > 	mips:ath79_defconfig
> > 	powerpc:ppc64e_defconfig
> > 	powerpc:cell_defconfig
> > 	powerpc:maple_defconfig
> > 	parisc:defconfig
> > 	tile:defconfig
> > 	sparc32:defconfig
> > 	sparc64:defconfig
> > 
> > 	as well as the powerpc qemu test (with the config file used
> > 	by the yocto project)
> > 
> > All builds pass with the patch applied, as does the qemu test.
> 
> Thanks for testing, I'll queue it up later today (at an airport right
> now, about to board a flight), and send it to Linus later tonight if no
> one else has any problems with it.
> 
To simplify this kind of testing, I added a 'testing' branch to the list of
branches I am auto-building. Right now it runs a complete test cycle with the
patch applied on top of v3.11-rc7. This should ensure that the patch doesn't
break any previously passing builds. You should see the results in the 'testing'
column of the stable queue build table on http://server.roeck-us.net:8010/builders
when you get out of the plane.

Guenter
