Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3H0XBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:01:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3H0XBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:01:30 -0400
Date: Tue, 27 Aug 2013 16:03:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Alexander Savchenko <oleksandr.savchenko@ti.com>, jslaby@suse.cz,
        matts@commtech-fastcom.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, dhowells@redhat.com,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: UART: Keep the TX fifo full when possible
Message-ID: <20130827230348.GA5705@kroah.com>
References: <1373277884-3006-1-git-send-email-oleksandr.savchenko@ti.com>
 <CAGa+x866vUhX-uctWfZpw42hW7bRTG92Qz=4j=gWL-vgpdryDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGa+x866vUhX-uctWfZpw42hW7bRTG92Qz=4j=gWL-vgpdryDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:57:25AM -0700, Kevin Hilman wrote:
> + Felipe
> 
> On Mon, Jul 8, 2013 at 3:04 AM, Alexander Savchenko
> <oleksandr.savchenko@ti.com> wrote:
> > From: Dmitry Fink <finik@ti.com>
> >
> > Current logic results in interrupt storm since the fifo
> > is constantly below the threshold level. Change the logic
> > to fill all the available spaces in the fifo as long as
> > we have data to minimize the possibilty of underflow and
> > elimiate excessive interrupts.
> >
> > Signed-off-by: Dmitry Fink <finik@ti.com>
> > Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
> 
> Hmm, another OMAP serial patch that wasn't Cc'd to linux-omap where
> OMAP users might have seen it. :(
> 
> I just bisected a strange problem in linux-next on OMAP3 down to this
> patch.  Reverting it fixes the problem.
> 
> On OMAP3530 Beagle and Overo, after boot, doing a 'cat /proc/cpuinfo'
> was not returning to a prompt, suggesting something strange with the
> FIFO.  Hitting return gets me back to a prompt.
> 
> Greg, this one should also be dropped from tty-next until it can be
> further investgated and the problem solved.

Now reverted, thanks.

greg k-h
