Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaAWTbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:31:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaAWTbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:31:07 -0500
Date: Thu, 23 Jan 2014 14:31:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] atyfb: set FBINFO_READS_FAST
In-Reply-To: <CA+55aFxPfHmpcMH-bmRcTPUQeq5=67cKVmra6+SvT26ybvQaug@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401231426470.7971@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFxPfHmpcMH-bmRcTPUQeq5=67cKVmra6+SvT26ybvQaug@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jan 2014, Linus Torvalds wrote:

> Hmm. You're doing this for Matrix and now the aty driver.
> 
> Maybe the problem is at the fbcon level? Depending on
> FBINFO_READS_FAST to decide whether you should scroll or rewrite
> sounds a bit silly: even if a device doesn't have fast reads, maybe it
> has a fast accelerated BLIT operation and scrolls quickly. Should the
> fbcon test perhaps be for FBINFO_READS_FAST _or_ the
> FBINFO_HWACCEL_COPYAREA bits?

Both mach64 and matrox have a hardware bitter that is faster than 
rewriting the console - that's why FBINFO_READS_FAST improves performance 
for them.

One could improve generic framebuffer core to benchmark the performance of 
scrolling using blitter and rewrite and select FBINFO_READS_FAST 
automatically...

Mikulas

> I dunno. I didn't actually check the ->bcopy implementations, maybe
> they don't use copyarea. So I'm just going by a general "this feels
> wrong" feeling..
> 
>                 Linus


> On Thu, Jan 23, 2014 at 10:18 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Set FBINFO_READS_FAST so that the console code uses scrolling instead of
> > rewriting. This improves scrolling speed.
> 
