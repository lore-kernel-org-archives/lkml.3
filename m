Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaAWUDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:03:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaAWUDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:03:08 -0500
Date: Thu, 23 Jan 2014 15:03:03 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] atyfb: set FBINFO_READS_FAST
In-Reply-To: <CA+55aFxrZE6oxu5CxFo3mRwGdVcq3jvnn_ChoSJDFgQz45Lq_A@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401231448100.7971@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFxPfHmpcMH-bmRcTPUQeq5=67cKVmra6+SvT26ybvQaug@mail.gmail.com>
 <alpine.LRH.2.02.1401231426470.7971@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFxrZE6oxu5CxFo3mRwGdVcq3jvnn_ChoSJDFgQz45Lq_A@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jan 2014, Linus Torvalds wrote:

> On Thu, Jan 23, 2014 at 11:31 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Both mach64 and matrox have a hardware bitter that is faster than
> > rewriting the console - that's why FBINFO_READS_FAST improves performance
> > for them.
> 
> My point is that I'd expect *anything* that has a hardware blitter to
> be faster than rewriting the screen.
>
> FBINFO_READS_FAST is documented to be about "soft-copy" being faster
> than re-rendering. Which I take to be about actually doing copying in
> *software*.
> 
> In particular, updatescrollmode() seems to do this right. It sets
> p->scrollmode based on whether there's an accelerated copyarea. But
> then SCROLL_PAN/WRAP_MOVE ends up re-testing FBINFO_READS_FAST,
> ignoring any hw-accelerated copy-area, and I don't quite see why..
> 
>                 Linus

I think the argument why not to use the blitter was this:

Some hardware have font expansion - you submit monochromatic bitwise image 
of the character via writes to some register and the hardware expands it 
to full color. Mach64 has this capability, matrox doesn't (maybe it does, 
but the driver doesn't use it).

If you use font expansion, you actually generate less load on the videoram 
than using the blitter (the expander only writes to the videoram; the 
blitter reads data from the videoram and stores them back).

But the benchmarks that I performed show that the blitter is faster than 
the font expander. Maybe on a different computer that has better 
bufferring in the PCI chipset the font expander could be faster - who 
knows?

Mikulas
