Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3CRXP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:15:29 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:36665 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3CRXP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:15:28 -0400
Date: Mon, 18 Mar 2013 16:16:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Peter Hurley <peter@hurleysoftware.com>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] TTY: add tty_port_tty_wakeup helper
Message-ID: <20130318231644.GA16304@kroah.com>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
 <1362658360-26629-5-git-send-email-jslaby@suse.cz>
 <1362754976.4219.29.camel@thor.lan>
 <513A35B1.4040808@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A35B1.4040808@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 08:02:09PM +0100, Jiri Slaby wrote:
> On 03/08/2013 04:02 PM, Peter Hurley wrote:
> > On Thu, 2013-03-07 at 13:12 +0100, Jiri Slaby wrote:
> >> It allows for cleaning up on a considerable amount of places. They did
> >> port_get, wakeup, kref_put. Now the only thing needed is to call
> >> tty_port_tty_wakeup which does exactly that.
> >>
> >> One exception is ifx6x60 where tty_wakeup was open-coded. We now call
> >> tty_wakeup properly there.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >> ---
> >>  arch/um/drivers/line.c                  |  8 +-------
> > 
> > 	Cc: Jeff Dike <jdike@addtoit.com>
> > 	Cc: Richard Weinberger <richard@nod.at>
> > 
> >>  drivers/isdn/capi/capi.c                |  7 +------
> > 
> > 	Cc: Karsten Keil <isdn@linux-pingi.de>
> > 
> >>  drivers/isdn/gigaset/interface.c        |  6 +-----
> > 
> > 	Cc: Hansjoerg Lipp <hjlipp@web.de>
> > 	Cc: Tilman Schmidt <tilman@imap.cc>
> > 	Cc: gigaset307x-common@lists.sourceforge.net
> > 	Cc: netdev@vger.kernel.org
> > 
> >>  drivers/net/usb/hso.c                   | 13 ++-----------
> > 
> > 	Cc: Jan Dumon <j.dumon@option.com>
> > 	Cc: linux-usb@vger.kernel.org
> > 
> >>  drivers/s390/char/sclp_tty.c            |  9 ++-------
> >>  drivers/s390/char/sclp_vt220.c          |  8 +-------
> > 
> > 	Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 	Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 	Cc: linux390@de.ibm.com
> > 	Cc: linux-s390@vger.kernel.org
> > 
> >>  drivers/staging/fwserial/fwserial.c     | 10 ++--------
> > 
> > 	Cc: Me :)
> > 
> >>  drivers/staging/serqt_usb2/serqt_usb2.c |  7 +------
> > 
> > 	Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> > 	Cc: Devendra Naga <devendra.aaru@gmail.com>
> > 
> > and so on...
> > 
> > Same for the other mega-patches.
> 
> I'm not sure whether to CC all the people for such patches. I always
> tended not to and instead rely on people reading LKML :P.
> 
> If this is the preferred way, I of course can do it next time.

It's nice to at least cc: driver maintainers if you can, you can script
get_maintainers.pl to do this for you.  But don't worry about it this
time.

thanks,

greg k-h
