Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3ICR7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:59:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3ICR7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:59:34 -0400
Date: Tue, 3 Sep 2013 10:59:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: RESEND: Generating interrupts from a USB device driver?
Message-ID: <20130903175933.GA8463@kroah.com>
References: <52251562.5000208@att.net>
 <20130902230738.GA22494@kroah.com>
 <52253E1F.6000101@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52253E1F.6000101@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 08:40:47PM -0500, Daniel Santos wrote:
> On 09/02/2013 06:07 PM, Greg KH wrote:
> >On Mon, Sep 02, 2013 at 05:46:58PM -0500, Daniel Santos wrote:
> >>Hello guys.  I didn't get a response the last time so hopefully with
> >>3.11 out I'll get one this time.
> >>
> >>I need to be able to generate interrupts from a USB device driver while
> >>servicing the complete() function of an interrupt URB.
> >No you don't :)
> >
> >>While I realize that this may seem strange, the purpose is for a USB
> >>to SPI/GPIO bridge chip (the MCP2210). When something happens on the
> >>remote device where a chip is expecting it's interrupt out pin to
> >>trigger an interrupt on some local (to the board) microcontroller, the
> >>MCP2210 instead receives that signal and communicates it to the host
> >>the next time it's queried. This is the interrupt that I need to, in
> >>effect propagate locally. Since my spi_master and gpio_chip are all
> >>functioning now, this is the last step to get one of my spi protocol
> >>drivers working correctly.
> >Just pass the data up the spi stack in your interrupt endpoint handler.
> >No need to try to create a "real" interrupt.  There are other USB SPI
> >drivers that should give you the idea of how to do it.
> Thanks for your response! I haven't been able to find these drivers,
> can you please point me to one? I guess I don't know the "spi stack"
> well enough to know how to propagate that notification up to the
> driver for the spi device (let alone that it was called a "stack" :)

Hm, I thought we used to have some of them, I guess people have been
saying they would write a driver for this type of hardware for a long
time now :(

Anyway, look at the spi core, I think you want to tie into the
spi_new_device() call in your usb driver, and start sending/receiving
data through the SPI interfaces the spi core provides.

The Linux SPI mailing list should be able to help you out a lot more
here than I can.

greg k-h
