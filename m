Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab3CHOzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:55:48 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:56497 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3CHOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:55:47 -0500
Message-ID: <1362754537.4219.24.camel@thor.lan>
Subject: Re: [PATCH 10/16] TTY: cleanup tty->hw_stopped uses
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 09:55:37 -0500
In-Reply-To: <5139F9B2.1070909@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
	  <1362658360-26629-10-git-send-email-jslaby@suse.cz>
	 <1362753564.4219.17.camel@thor.lan> <5139F9B2.1070909@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 15:46 +0100, Jiri Slaby wrote:
> On 03/08/2013 03:39 PM, Peter Hurley wrote:
> > On Thu, 2013-03-07 at 13:12 +0100, Jiri Slaby wrote:
> >> --- a/drivers/net/caif/caif_serial.c
> >> +++ b/drivers/net/caif/caif_serial.c
> >> @@ -88,7 +88,6 @@ static inline void update_tty_status(struct ser_device *ser)
> >>  {
> >>  	ser->tty_status =
> >>  		ser->tty->stopped << 5 |
> >> -		ser->tty->hw_stopped << 4 |
> >>  		ser->tty->flow_stopped << 3 |
> >>  		ser->tty->packet << 2 |
> >>  		ser->tty->port->low_latency << 1 |
> > 
> > I would maybe leave this with a code comment instead.
> > 
> > 		ser->tty->hw_stopped << 4 |      /* hw_stopped is not used by tty layer */
> 
> Yeah, maybe...

Plus this is documented in Documentation/networking/caif/README

> >> @@ -4256,9 +4251,6 @@ static void seq_line_info(struct seq_file *m, struct e100_serial *info)
> >>  		if (info->port.tty->stopped)
> >>  			seq_printf(m, " stopped:%i",
> >>  				   (int)info->port.tty->stopped);
> >> -		if (info->port.tty->hw_stopped)
> >> -			seq_printf(m, " hw_stopped:%i",
> >> -				   (int)info->port.tty->hw_stopped);
> > 
> > User-space visible. Tool may expect this field.
> 
> I thought that on the first glance too. But look what does that whole
> seq_printf depend on.

Oh, right, duh. That field's never been printed :)


