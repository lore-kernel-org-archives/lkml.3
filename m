Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3LBJYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:24:06 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:35629 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3LBJYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:24:03 -0500
Message-ID: <1385976238.12531.8.camel@host5.omatika.ru>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
From: Sergei Ianovich <ynvich@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Date: Mon, 02 Dec 2013 13:23:58 +0400
In-Reply-To: <20131202090253.GE3942@xps8300>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
	 <20131202090253.GE3942@xps8300>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 11:02 +0200, Heikki Krogerus wrote:
> On Sun, Dec 01, 2013 at 10:26:14AM +0400, Sergei Ianovich wrote:
> > PXA serial ports have "standard" UART names (ttyS[0-3]), major
> > device number (4) and first minor device number (64) by default.
> > 
> > If the system has extra 8250 serial port hardware in addition
> > to onboard PXA serial ports, default settings produce a device
> > allocation conflict.
> > 
> > The patch provides a configuration option which can move onboard
> > ports out of the way of 8250_core by assigning a different (204)
> > major number and corresponding device names (ttySA[0-3]).
> > 
> <snip>
> 
> If drivers/tty/serial/pxa.c was converted to an other probe driver for
> the 8250, this would not be an issue.

It seems that my patch is not going to be accepted. However, there is a
device which has both PXA ports and a additional 8250 accent chip. As a
result, there is a device allocation conflict. For the device to be
usable the conflict needs to be resolved.

Do you mean that drivers/tty/serial/pxa.c needs to be rewritten to
support lp8x4x special case?

