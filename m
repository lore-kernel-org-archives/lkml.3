Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3HLUX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:23:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab3HLUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:23:57 -0400
Date: Mon, 12 Aug 2013 13:23:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tilegx: Add tty serial support for TILE-Gx on-chip UART
Message-ID: <20130812202356.GA26536@kroah.com>
References: <201308121836.r7CIa3Kj004272@farm-0021.internal.tilera.com>
 <20130812184329.GB19875@kroah.com>
 <52092FE5.8030006@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52092FE5.8030006@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 02:56:37PM -0400, Chris Metcalf wrote:
> On 8/12/2013 2:43 PM, Greg Kroah-Hartman wrote:
> > On Mon, Aug 12, 2013 at 02:11:44PM -0400, Chris Metcalf wrote:
> >> +/*
> >> + * Enable modem status interrupts.
> >> + */
> >> +static void tilegx_enable_ms(struct uart_port *port)
> >> +{
> >> +	/* N/A */
> >> +}
> >> +
> >> +/*
> >> + * Control the transmission of a break signal.
> >> + */
> >> +static void tilegx_break_ctl(struct uart_port *port, int break_state)
> >> +{
> >> +	/* N/A */
> >> +}
> > For most of these "empty" callbacks, you shouldn't have to declare them
> > at all, and all should work just fine.
> 
> I may be missing something, but it looks like drivers/tty/serial/serial_core.c
> calls all of the "empty" callbacks unconditionally, so some definition
> is required.

Ah, you are right, I was looking at the "raw" tty driver, not the uart
driver, my mistake.

greg k-h
