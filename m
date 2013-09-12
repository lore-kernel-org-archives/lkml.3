Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3ILWxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:53:39 -0400
Received: from longford.logfs.org ([213.229.74.203]:60212 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3ILWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:53:27 -0400
Date: Thu, 12 Sep 2013 17:18:44 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephan Mueller <smueller@chronox.de>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130912211844.GD3809@logfs.org>
References: <10005394.BRCyBMYWy3@tauon>
 <2947789.S63SVUbC3N@tauon>
 <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
 <5896310.H6rEVunj63@tauon>
 <CAMuHMdX5-kSWVJ_QFXY+L2L6iY0Zo7GAL5uF-uPGJAXM=wZxgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdX5-kSWVJ_QFXY+L2L6iY0Zo7GAL5uF-uPGJAXM=wZxgw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 September 2013 14:15:35 +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 12, 2013 at 2:08 PM, Stephan Mueller <smueller@chronox.de> wrote:
> >>BTW, I prefer a different name than "random_get_fast_cycles()", as it's
> >>better to have something that returns different and unpredictable
> >>numbers than an actual monotonic cycle counter.
> >
> > A monotonic counter is fully ok. Note, for /dev/random, the occurrence
> > of events delivers entropy. Thus, we have to be able to precisely
> > measure that occurrence. The timer itself does not need to deliver any
> > entropy as long as it is fast.
> 
> Well, in my specific case (m68k/Amiga) I can use:
>   - a 24-bit counter running at only ca. 15 or 31 kHz (actual
> frequency may vary),
>   - a 16-bit counter running at ca. 700 kHz.

Assuming the same cost, please use the 700kHz counter.  Or both.

Jiffies is a relatively poor choice, as it can be predicted with high
certainty.  Most of the time it will be identical to the last value
for jiffies, most of the remaining time it will be off by exactly one.
So on average you don't even get a single unpredictable bit from
jiffies.

A counter that is fast when compared to interrupt rate will give you
relatively many useful bits.  A slow counter - no matter how wide -
will have little useful randomness.  Ideal is a counter that cannot be
externally derived even with the most expensive measurement kit.  So
an unstable clock is actually a bonus.  Think high precision and low
realiability.

And if you have to drop bits from the counter, please drop the high
bits, as they are the easily predictable ones.

Jörn

--
I can say that I spend most of my time fixing bugs even if I have lots
of new features to implement in mind, but I give bugs more priority.
-- Andrea Arcangeli, 2000
