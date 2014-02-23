Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaBWWd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:33:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:52602 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBWWdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:33:24 -0500
Date: Sun, 23 Feb 2014 23:33:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
cc: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: locking changes in tty broke low latency feature
In-Reply-To: <53064672.3000807@hurleysoftware.com>
Message-ID: <alpine.DEB.2.02.1402232330190.21251@ionos.tec.linutronix.de>
References: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net> <53056E99.9070900@hurleysoftware.com> <53064672.3000807@hurleysoftware.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Peter Hurley wrote:

> On 02/19/2014 09:55 PM, Peter Hurley wrote:
> > On 02/19/2014 06:06 PM, Hal Murray wrote:
> > > > Can you give me an idea of your device's average and minimum required
> > > > latency (please be specific)?  Is your target arch x86 [so I can
> > > > evaluate the
> > > > the impact of bus-locked instructions relative to your expected]?
> > > 
> > > The code I'm familiar with is ntpd and gpsd.  They run on almost any
> > > hardware
> > > or OS and talk to a wide collection of devices.
> > > 
> > > There is no hard requirement for latency.  They just work better with
> > > lower
> > > latency.  The lower the better.
> > > 
> > > People gripe about the latency due to USB polling which is about a ms.
> > 
> > Have you tried 3.12+ without low_latency? I ripped out a lot of locks
> > from 3.12+ so it's possible it already meets your requirements.
> 
> Using Alan's idea to mock up a latency test, I threw together a test jig
> using two computers running 3.14-rc1 and my fwserial driver (modified to
> not aggregrate writes) in raw mode where the target does this:

This is a complete pointless test. Use a bog standard 8250 UART on the
PC and connect a microcontroller on the other end which serves you an
continous stream of data at 115200 Baud.

There is no way you can keep up with that without the low latency
option neither on old and nor on new machines if you have enough other
stuff going on in the system.

Thanks,

	tglx



