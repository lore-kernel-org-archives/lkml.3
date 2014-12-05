Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaLENx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:53:27 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:59522 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaLENxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:53:25 -0500
Date: Fri, 5 Dec 2014 13:51:33 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>,
        <uwe@kleine-koenig.org>
Subject: Re: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Message-ID: <20141205135133.37fb96f6@lxorguk.ukuu.org.uk>
In-Reply-To: <20141202015118.GA1891@saruman>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
	<20141129094823.GA10840@linutronix.de>
	<20141129173418.GY2817@atomide.com>
	<20141201140914.728aaa46@lxorguk.ukuu.org.uk>
	<20141201231338.GA14524@fuloong-minipc.musicnaut.iki.fi>
	<20141202015118.GA1891@saruman>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 19:51:18 -0600
Felipe Balbi <balbi@ti.com> wrote:

> On Tue, Dec 02, 2014 at 01:13:38AM +0200, Aaro Koskinen wrote:
> > Hi,
> > 
> > On Mon, Dec 01, 2014 at 02:09:14PM +0000, One Thousand Gnomes wrote:
> > > > Well the nightmare userspace switch from ttyS to ttyO few years ago is
> > > > something we want to avoid.. I think the best solution would be to make
> > > > serial-omap.c transparently provide support for ttyO using the new 8250
> > > > code so both ttyS and ttyO devices would just work. Otherwise it will
> > > > be years of "my serial port stopped working" questions again.
> > > 
> > > Thata a udev problem not a kernel one surely.
> > 
> > People also use serial console to observe the early kernel boot before
> > the userspace is started.
> 
> right, we need a way to tell the kernel that ttyO%d and ttyS%d are the
> exact same device so that console=ttyO0 and console=ttyS0 mean the same
> thing. That maintains backwards compatibility and lets people move on

Yes.. and that possibly also means a temporary char driver that claims
ttyO* and simply redirects the calls into the tty.
