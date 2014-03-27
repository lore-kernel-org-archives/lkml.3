Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaC0Oyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:54:44 -0400
Received: from verein.lst.de ([213.95.11.211]:54284 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbaC0Oym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:54:42 -0400
Date: Thu, 27 Mar 2014 15:54:38 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 02/03]: hwrng: create filler thread
Message-ID: <20140327145438.GA18563@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 06:03:37PM -0700, H. Peter Anvin wrote:
> I'm wondering more about the default.  We default to 50% for arch_get_random_seed, and this is supposed to be the default for in effect unverified hwrngs...

If the default were 0, it would be exactly the old behaviour.
How about that? Plus, driver authors would have to come up
with an estimate on their own.

> On March 26, 2014 5:50:09 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
> >> +		 "current hwrng entropy estimation per mill");
> >
> >As an electrical engineer (sort of), I can't read this without thinking
> >you're talking about the amount by which the current is derated.  For
> >example, a 14-50 electrical outlet is rated to 50 Amps.  If you use it
> >continuously for a long time, though, the current is derated to 40
> >Amps.
> >
> >Shouldn't this be called credit_derating or, even better,
> >credit_per_1000bits?

That's an awkward name for a parameter.

> >Also, "per mill" is just obscure enough that someone might think it
> >means "per million".

No. I looked it up, as we have the precise term "Promille" in German.
Also in electrical engineering, (imperial :-) PCB design, a mil
is one 1000th of an inch. Per million would surely be named PPM.

> >Why the check for derating > 0?  Paranoid users may want zero credit,
> >but they probably still want the thing to run.

[...]

> >ratelimit (heavily), please.

The kthread will stop once the estimated entropy is above the threshold.
derating=0 will wind up one CPU core to 100%. So it's an elegant way
to disable the whole mechanism.

> >Also, would it make sense to round-robin all hwrngs?  Even better:
> >collect entropy from each one and add them to the pool all at once.  If
> >so, would it make sense for the derating to be a per-rng parameter. 

Finally, the derating _is_ a per-RNG parameter. I also thought about 
mixing already, but first I want to see a machine with more than 1 HWRNG :-)

	Torsten

