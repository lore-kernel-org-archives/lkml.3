Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab3HMUPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:15:50 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43352 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137Ab3HMUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:15:47 -0400
Date: Tue, 13 Aug 2013 15:12:54 -0500
From: Andrew Ruder <andy@aeruder.net>
To: Mark Jackson <mpfj-list@newflow.co.uk>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] OMAP: allow GPIO pin to enable/disable external UART
 driver chip.
Message-ID: <20130813201254.GA14631@gmail.com>
Mail-Followup-To: Mark Jackson <mpfj-list@newflow.co.uk>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <520646F0.9010801@newflow.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520646F0.9010801@newflow.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply, I've been thinking about this for some time
and was sad to see it didn't really evoke any sort of discussion :(.

On Sat, Aug 10, 2013 at 02:58:08PM +0100, Mark Jackson wrote:
> When a UART transmitter is connected to (eg) a RS485 driver, it is
> necessary to turn the driver on/off as quickly as possible.  This is
> best achieved in the serial driver itself (rather than in userspace
> where the latency can be quite large).
> 
> This patch allows the GPIO pin to be defined (via DT) that controls
> the enabling of the driver at the start of a message, and disables
> the driver when the message has been completed.
> 
> Still to do:-
> Allow userspace to turn this feature on/off
> Do the same for the receiver (useful for 2 wire RS485)

I've been wondering about this as well but I have a slightly different
situation.  On my board the RTS line controls the RS485 transmit/receive
direction.

I don't know if you've found the Documentation/serial/serial-rs485.txt
file but it describes, at the very least, a standard API For controlling
several parameters related to RS485 including configurable delay between
rts->start of data/end of data->rts.  Unfortunately it seems like only
one driver really implements the full API (Atmel AT91) and I guess it
needs to be bolted onto each serial driver individually (although it
seems like a fairly general concept that could be handled at another
level).

That being said, maybe this patch would better be rethought as a way to
specify a GPIO for the RTS line (I don't know enough about OMAP and
whether or not it already provides for hardware flow control in its
builtin UARTs and you just aren't using it for RS485 flow control?) and
then in a separate patch implement this already documented user->kernel
API?

- Andy
