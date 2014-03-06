Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbaCFAwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:52:45 -0500
Received: from waste.org ([173.11.57.241]:40456 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbaCFAwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:52:43 -0500
Message-ID: <1394067147.17842.45.camel@calx>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
From: Matt Mackall <mpm@selenic.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 05 Mar 2014 18:52:27 -0600
In-Reply-To: <20140305211145.GV1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
	 <20140304153841.GN1872@titan.lakedaemon.net>
	 <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
	 <20140304195356.GS1872@titan.lakedaemon.net>
	 <CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
	 <1393972797.8344.190.camel@calx>
	 <20140305211145.GV1872@titan.lakedaemon.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 16:11 -0500, Jason Cooper wrote:
> > In other words, if there are 4096 bits of "unknownness" in X to start
> > with, and I can get those same 4096 bits of "unknownness" back by
> > unmixing X' and Y, then there must still be 4096 bits of "unknownness"
> > in X'. If X' is 4096 bits long, then we've just proven that
> > reversibility means the attacker can know nothing about the contents of
> > X' by his choice of Y.
> 
> Well, this reinforces my comfortability with loadable modules.  The pool
> is already initialized by the point at which the driver is loaded.
> 
> Unfortunately, any of the drivers in hw_random can be built in.  When
> built in, hwrng_register is going to be called during the kernel
> initialization process.  In that case, the unknownness in X is not 4096
> bits, but far less.  Also, the items that may have seeded X (MAC addr,
> time, etc) are discoverable by a potential attacker.  This is also well
> before random-seed has been fed in.

To which I would respond.. so?

If the pool is in an attacker-knowable state at early boot, adding
attacker-controlled data does not make the situation any worse. In fact,
if the attacker has less-than-perfect control of the inputs, mixing more
things in will make things exponentially harder for the attacker.

Put another way: mixing can't ever removes unknownness from the pool, it
can only add more. So the only reason you should ever choose not to mix
something into the pool is performance.

-- 
Mathematics is the supreme nostalgia of our time.


