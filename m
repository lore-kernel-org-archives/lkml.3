Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3KSRkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:40:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3KSRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:40:33 -0500
Date: Tue, 19 Nov 2013 09:40:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Heorhi Valakhanovich <valahanovich@tut.by>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Only hangup once
Message-ID: <20131119174032.GB22604@kroah.com>
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>
 <20131117203850.46df2124@tormoz-pc>
 <20131118134211.17861db3@alan.etchedpixels.co.uk>
 <528A5043.6030901@hurleysoftware.com>
 <528A797B.6020807@hurleysoftware.com>
 <20131119000923.5ca40e51@tormoz-pc>
 <528B6BB3.7020303@hurleysoftware.com>
 <20131119201952.2d63b8ce@tormoz-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119201952.2d63b8ce@tormoz-pc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 08:19:52PM +0300, Heorhi Valakhanovich wrote:
> On Tue, 19 Nov 2013 08:46:27 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
> 
> > Would you please test the patch below and confirm the fix?
> > 
> > --->%---
> > Subject: [PATCH] tty: Reset hupped state on open
> > 
> > A common security idiom is to hangup the current tty (via vhangup())
> > after forking but before execing a root shell. This hangs up any
> > existing opens which other processes may have and ensures subsequent
> > opens have the necessary permissions to open the root shell tty/pty.
> > 
> > Reset the TTY_HUPPED state after the driver has successfully
> > returned the opened tty (perform the reset while the tty is locked
> > to avoid racing with concurrent hangups).
> > 
> > Reported-by: Heorhi Valakhanovich <valahanovich@tut.by>
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > ---
> >   drivers/tty/tty_io.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> > index 3a1a01a..c74a00a 100644
> > --- a/drivers/tty/tty_io.c
> > +++ b/drivers/tty/tty_io.c
> > @@ -2086,6 +2086,7 @@ retry_open:
> >   			filp->f_op = &tty_fops;
> >   		goto retry_open;
> >   	}
> > +	clear_bit(TTY_HUPPED, &tty->flags);
> >   	tty_unlock(tty);
> > 
> > 
> 
> It looks like this patch works. It solves my problem. Thanks.
> Will wait for such fix in mainline.

I'll queue this up after 3.13-rc1 is out.

It should be backported to 3.12, and any other kernels?

thanks,

greg k-h
