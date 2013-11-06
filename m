Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3KFNEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:04:42 -0500
Received: from imap.thunk.org ([74.207.234.97]:54931 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3KFNEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:04:40 -0500
Date: Wed, 6 Nov 2013 08:04:32 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131106130432.GK14235@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, Pavel Machek <pavel@ucw.cz>,
	sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
References: <2579337.FPgJGgHYdz@tauon>
 <4306229.ErfOL470s2@tauon>
 <20131106124354.GJ14235@thunk.org>
 <9172761.DO0L6FkY0c@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9172761.DO0L6FkY0c@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:51:17PM +0100, Stephan Mueller wrote:
> >That's unfortunate, since it leaves open the question of whether this
> >jitter is something that could be at least somewhat predictable if you
> >had a lot more information about the internal works of the CPU or
> >not....
> 
> I do not understand that answer: I thought we are talking about the 
> search of non-predictable noise sources. If you cannot predict the 
> sequence even if you have the state of the CPU, that is what we are 
> looking for, is it not?

I was asking the question about whether someone who knew more about
the internal _workings_ of the CPU, note of the state of the CPU.
This is not necessarily "the NSA guy", but someone who knows more
about the internal workings of the Intel CPU (such as an Intel
engineer --- and I've had Intel express misgivings about approaches
which depend on "CPU jitter" approaches), or just someone who has
spent a lot more time trying to examine the black box of the Intel CPU
from the outside.

I remember making my own home-grown encryption algorithm before I
entered college, secure in my arrogance that I had created something
so complicated that no one could crack it.  Of course, as I got older
and wiser, I realized that it just meant it was just something *I*
couldn't yet anaylze and crack.  The argument "the internal state of
the CPU is sooooo large, and the state transitions ar sooooo complex
that it *must* be unpredictable, because *I* can't predict them" seems
to be a very similar mistake that I made many years ago when I was in
high school.

Of course, some of the state in the CPU may not be unknown to the
attacker, if it is derived by external events that are not visible to
the attacker, such as a network interrupt.  But if that's the case,
why not measure network interrupts directly?  We're much less likely
to overestimate the amount of entropy we can extract the system in
that case.

> Also, does your answer mean you would disregard radioactive decay that 
> is not predictable due to quantum physics and Heisenberg?

No, because that's uncertainty that we can tie to a physical source.
My concern about CPU state is that we haven't yet tied that to a
physical source of entropy, or to exactly what external inputs that
are not available to an external attacker.  We know that quantum
events are not predictable.  We also know that digital circuits in
general are very carefully designed to *be* predictable.

Regards,

						- Ted
