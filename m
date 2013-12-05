Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab3LEELs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:11:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3LEELq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:11:46 -0500
Date: Wed, 4 Dec 2013 20:12:51 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
Message-ID: <20131205041251.GA24906@kroah.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
 <20131202090253.GE3942@xps8300>
 <1385976238.12531.8.camel@host5.omatika.ru>
 <20131202094932.GF3942@xps8300>
 <1385980005.12531.21.camel@host5.omatika.ru>
 <20131202141033.GK3942@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202141033.GK3942@xps8300>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 04:10:33PM +0200, Heikki Krogerus wrote:
> Hi,
> 
> On Mon, Dec 02, 2013 at 02:26:45PM +0400, Sergei Ianovich wrote:
> > On Mon, 2013-12-02 at 11:49 +0200, Heikki Krogerus wrote:
> > > On Mon, Dec 02, 2013 at 01:23:58PM +0400, Sergei Ianovich wrote:
> > > > On Mon, 2013-12-02 at 11:02 +0200, Heikki Krogerus wrote:
> > > > > 
> > > > > If drivers/tty/serial/pxa.c was converted to an other probe driver for
> > > > > the 8250, this would not be an issue.
> > > > 
> > > > It seems that my patch is not going to be accepted. However, there is a
> > > > device which has both PXA ports and a additional 8250 accent chip. As a
> > > > result, there is a device allocation conflict. For the device to be
> > > > usable the conflict needs to be resolved.
> > > > 
> > > > Do you mean that drivers/tty/serial/pxa.c needs to be rewritten to
> > > > support lp8x4x special case?
> > > 
> > > Sorry I was not clear. I was suggesting that drivers/tty/serial/pxa.c
> > > would be converted to drivers/tty/serial/8250/8250_pxa.c since it
> > > looks to me like just an other 16x50 compatible UART. That would fix
> > > the issue with the name conflict. You would then simply register 8250
> > > ports from two probe drivers (drivers/tty/serial/8250/8250_pxa.c and
> > > drivers/tty/serial/8250/8250_lp8x4x.c).
> > > 
> > > Depending on the order you register your platform devices (which you
> > > decide in your platform code), but let's say the pxa gets registered
> > > first and let's say it only has one port. You will then have in your
> > > system /dev/ttyS0 for the pxa port and /dev/ttyS[1-4] for the other
> > > UART.
> > > 
> > > I hope I was able to explain what I mean this time :)
> > 
> > Sorry, I wasn't clear as well. I got it right the first time. You mean
> > pxa.c needs to merged into 8250. This will solve the conflict in
> > question, and do it the right way. However, this will be a *much* bigger
> > patch, and it will affect everyone on pxa.
> > 
> > Who makes the decision which way to go?
> 
> Greg and Russel make this decision. By having the pxa driver simply
> register 8250 ports would probable reduce the code. Thats about the
> biggest benefit from it.
> 
> It would still be something nice to have IMO. Ideally all the
> 8250/16x50 UARTs should register the ports with 8250_core.c, and not
> create complete uart driver on their own.

I agree, this is the best way to resolve this, having a separate uart
driver isn't that good at all to be doing, if at all possible.

thanks,

greg k-h
