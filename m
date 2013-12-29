Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3L2Bms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 20:42:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36331 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab3L2Bmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 20:42:45 -0500
X-Sasl-enc: RVARrqRWBHytXLRNrubqn/JhI4S7Uuqe3wdaGHZVkE0Z 1388281364
Date: Sat, 28 Dec 2013 17:43:24 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Joe Xue <lgxue@hotmail.com>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: how to represent sequence of brightnesses in /sys (was Re:
 [PATCH] Add the LED burst trigger)
Message-ID: <20131229014324.GB18455@kroah.com>
References: <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
 <20131227095705.GC17143@amd.pavel.ucw.cz>
 <BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>
 <20131228101622.GA13564@amd.pavel.ucw.cz>
 <CAMuHMdVz7FWgYZRVHy6pK+g_2QKxTW00N8jmjWHe05m5CJvPOw@mail.gmail.com>
 <20131228192935.GA28119@amd.pavel.ucw.cz>
 <CAMuHMdXDJ6uhe6srV-+0a8=cpBUgP+VakG+_wyLwAuiQSRVhqQ@mail.gmail.com>
 <20131228212523.GA8733@amd.pavel.ucw.cz>
 <20131228215042.GA7048@kroah.com>
 <20131228235045.GA8786@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131228235045.GA8786@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 12:50:46AM +0100, Pavel Machek wrote:
> On Sat 2013-12-28 13:50:42, Greg KH wrote:
> > On Sat, Dec 28, 2013 at 10:25:23PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > >> Sysfs is meant to be human-readable/writable, so please use plain ASCII
> > > > >> numbers in strings instead.
> > > > >
> > > > > Actually, sysfs is meant to be one value per file, and it is
> > > > 
> > > > Ideally, yes.
> > > > 
> > > > > understood that data that are "natively blob" are just passed as
> > > > > blob. (I believe this qualifies).
> > > > 
> > > > But it doesn't buy us much here, does it? It will make e.g. shell scripts
> > > > needlessly complicated.
> > > 
> > > echo -ne '\012' is not that bad, and parsing array of integers from
> > > kernel will be an ugly piece of code.
> > 
> > Ick, no.  What are you trying to do here?  Have the kernel intrepret a
> > sequence of bytes to flash an LED?  I thought we have frameworks in
> > userspace already to handle this type of thing.  Please don't invent new
> > ways of doing stuff...
> 
> Idea would be "sequence of brigtnesses" (one file) and "delay between
> changes" (second file).

Ick.

> Reason to do it in kernel is that some machines actually have
> "coprocessor" on i2c that can do it while main CPU is suspended. (For
> more reasons, see beggining of thread).

Ick ick.

> Binary attribute with array of bytes should be acceptable, rights?

Not at all.

> (IOW write(..., buf, size) )
> 
> Ascii array of decimal integers -- no so, right?
> 
> (IOW printf("%d %d ..", buf[0], buf[1]) )

Use an ioctl with a structure to get things correct as a character
device.  As odds are, you aren't going to be able to create a "generic"
format for all of this for all types of devices that support such a
"co-processor".

greg k-h
