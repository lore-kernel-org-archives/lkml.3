Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935569AbaH0TUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:20:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbaH0TUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:20:52 -0400
Date: Wed, 27 Aug 2014 12:20:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, balbi@ti.com,
        ming.lei@canonical.com, mwelling@emacinc.com,
        stefan@herbrechtsmeier.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "[3.8+]" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: hub: Prevent hub autosuspend if usbcore.autosuspend
 is -1
Message-ID: <20140827192052.GB8732@kroah.com>
References: <Pine.LNX.4.44L0.1408041006530.1169-100000@iolanthe.rowland.org>
 <53FDB37C.8030707@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FDB37C.8030707@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:31:24PM +0300, Roger Quadros wrote:
> On 08/04/2014 05:07 PM, Alan Stern wrote:
> > On Mon, 4 Aug 2014, Roger Quadros wrote:
> > 
> >> If user specifies that USB autosuspend must be disabled by module
> >> parameter "usbcore.autosuspend=-1" then we must prevent
> >> autosuspend of USB hub devices as well.
> >>
> >> commit 596d789a211d introduced in v3.8 changed the original behaivour
> >> and stopped respecting the usbcore.autosuspend parameter for hubs.
> >>
> >> Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"
> >>
> >> Cc: [3.8+] <stable@vger.kernel.org>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> 
> Just noticed the below error by the Intel's build script
> 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-linus
> > head:   039368901ad0a6476c7ecf0cfe4f84d735e30135
> > commit: bdd405d2a5287bdb9b04670ea255e1f122138e66 [19/20] usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
> > config: make ARCH=sparc64 defconfig
> > 
> > All error/warnings:
> > 
> >    drivers/usb/core/hub.c: In function 'hub_probe':
> >>> drivers/usb/core/hub.c:1735:21: error: 'struct dev_pm_info' has no member named 'autosuspend_delay'
> >      if (hdev->dev.power.autosuspend_delay >= 0)
> >                         ^
> 
> Seems like the "if" has to be placed within a #ifdef CONFIG_PM_RUNTIME.
> 
> Greg,
> 
> Should I send a v2 of this patch or a fix on top of your usb-linus branch?

Please send a fix-on-top, as I already have your patch applied, and
can't remove it.

thanks,

greg k-h
