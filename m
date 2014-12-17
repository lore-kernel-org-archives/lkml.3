Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaLQReu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:34:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLQRet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:34:49 -0500
Date: Wed, 17 Dec 2014 09:34:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
Message-ID: <20141217173448.GB24913@kroah.com>
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
 <20141217082958.GC3303@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217082958.GC3303@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 09:30:03AM +0100, Thierry Reding wrote:
> On Thu, Dec 04, 2014 at 01:06:07PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> > 
> > Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> > failure") broke platforms that rely on deferred probing to order probing
> > of PHY and host controller drivers. The reason is that the commit simply
> > propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
> > PHY has been registered yet for a given device tree node. The only case
> > in which -EPROBE_DEFER would now be returned is if try_module_get() did
> > fail, which does not make sense.
> > 
> > The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
> > registered yet. The only condition under which it makes sense to return
> > -ENODEV is if the device tree node representing the PHY has been
> > disabled (via the status property) because in that case the PHY will
> > never be registered.
> > 
> > This patch addresses the problem by making __of_usb_find_phy() return an
> > appropriate error code while keeping in line with the above-mentioned
> > commit to propagate error codes rather than overwriting them. At the
> > same time the check for a valid PHY is decoupled from the check for the
> > try_module_get() call and a separate error code is returned if the
> > latter fails.
> > 
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/usb/phy/phy.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> Ping?

It's the middle of the merge window, we can't do anything until 3.19-rc1
is out at the earliest.

And then my vacation kicks in, so it will be a week or so more after
that :)

greg k-h
