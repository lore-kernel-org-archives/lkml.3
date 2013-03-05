Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3CEWDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:03:18 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:51978 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3CEWDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:03:16 -0500
Message-ID: <1362520976.18799.134.camel@thor.lan>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jhovold@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Mar 2013 17:02:56 -0500
In-Reply-To: <51366A29.2060808@suse.cz>
References: <1362085054.3337.20.camel@thor.lan> <51361724.4050107@suse.cz>
	 <1362503170.18799.33.camel@thor.lan> <51366A29.2060808@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 22:56 +0100, Jiri Slaby wrote:
> On 03/05/2013 06:06 PM, Peter Hurley wrote:
> >>> @@ -225,15 +232,13 @@ void tty_port_hangup(struct tty_port *port)
> >>         spin_lock_irqsave(&port->lock, flags);
> >>         port->count = 0;
> >>         port->flags &= ~ASYNC_NORMAL_ACTIVE;
> >> -       if (port->tty) {
> >> +       if (port->tty)
> >>                 set_bit(TTY_IO_ERROR, &port->tty->flags);
> >> -               tty_kref_put(port->tty);
> >> -       }
> >> -       port->tty = NULL;
> >>         spin_unlock_irqrestore(&port->lock, flags);
> >>> +       tty_port_shutdown(port, port->tty);
> >>
> >> What prevents port->tty to be NULL here already?
> > 
> > Nothing. That's why it's tested in tty_port_shutdown() above.
> 
> I know :).

Sorry :)

> But the question is rather don't we want to pass the real
> refcounted port->tty (take a snapshot inside the lock) instead?

I think that's why he moved the kref release to after the shutdown (via
tty_port_set_tty()) -- but I'm tired and maybe I'm missing something
here?

Regards,
Peter Hurley


