Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbaCTVMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:12:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbaCTVM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:12:28 -0400
Date: Thu, 20 Mar 2014 14:14:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH/RFC] serial_core: Fix pm imbalance on unbind
Message-ID: <20140320211432.GA2813@kroah.com>
References: <1394481265-7275-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdVmrEoRkqUB=3mBRNrPEJiR701YUmr8C7HX1O6UxT_NUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVmrEoRkqUB=3mBRNrPEJiR701YUmr8C7HX1O6UxT_NUg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:23:00AM +0100, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Mon, Mar 10, 2014 at 8:54 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >
> > When a serial port is closed, uart_close() takes care of shutting down the
> > hardware, and powering it down.
> >
> > When a serial port is unbound while in use, uart_close() bypasses all of
> > this, as this is supposed to be done through uart_hangup() (invoked via
> > tty_vhangup() in uart_remove_one_port()).
> >
> > However, uart_hangup() does not set the hardware's power state, leaving it
> > powered up.  This may also lead to unbounded nesting counts in clock and
> > power management, depending on their internal implementation.
> >
> > Make sure to power down the port in uart_hangup(), except when the port is
> > used as a serial console. For serial consoles, this must be postponed until
> > after their deregistration in uart_remove_one_port() (symmetry with
> > registration in uart_configure_port(), invoked from uart_add_one_port()).
> >
> > After this, the module clock used by the sh-sci driver is disabled on
> > unbind while the serial port is in use.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> I noticed you have applied all serial patches I've sent, except for this one.
> Is there any specific reason you skipped this one?

It was marked "RFC" so I didn't think it was to be applied...

If it's ready, please resend.

thanks,

greg k-h
