Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3ILOZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:25:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:58994 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3ILOZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:25:52 -0400
Date: Thu, 12 Sep 2013 10:25:46 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130912142546.GE12918@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
References: <10005394.BRCyBMYWy3@tauon>
 <CAMuHMdXcXGpgE5ArcjNU-RgAr52qB8ih_b48jwR=+OqK4RDhFA@mail.gmail.com>
 <20130910211454.GJ29237@thunk.org>
 <2947789.S63SVUbC3N@tauon>
 <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 01:59:04PM +0200, Geert Uytterhoeven wrote:
> 
> BTW, I prefer a different name than "random_get_fast_cycles()", as it's better
> to have something that returns different and unpredictable numbers than an
> actual monotonic cycle counter.

I'm open to a different name; the point I was trying to make with that
name proposal was to be clear that it had to be very low overhead, and
that the intent of this interface was that it be time dependent in
some fashion (since that is how we are trying to generate the entropy
source).  The problem with "time" is that it implies that it is in
units of seconds.  I was trying to come up with something that was
more generic, which is why I suggested "randome_get_fast_cycles()".

If the CPU has a source which is specified to be complately
unpredictable, we have arch_get_random_long(), which the random driver
uses as well.

I get that there could be other things, such as some kind of dram
refresh counter, or the raster scan line if you had an embedded video
chip on something like an Apple II :-) and thse things would work too.

But if someone can suggest a different name, sure, let's talk about
it.  It may be, though, that the best we can do is to pick a name
which is not too misleading, even if it is not 100% precise.  That can
happen sometimes, alas.

Regards,

						- Ted
