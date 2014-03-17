Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaCQCMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:12:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56864 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbaCQCMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:12:47 -0400
Message-ID: <532659F5.2030005@zytor.com>
Date: Sun, 16 Mar 2014 19:12:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>, Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng sources
References: <20140303235148.GA7601@www.outflux.net>	 <20140304153841.GN1872@titan.lakedaemon.net>	 <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>	 <20140304195356.GS1872@titan.lakedaemon.net>	 <CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com> <1393972797.8344.190.camel@calx>
In-Reply-To: <1393972797.8344.190.camel@calx>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 02:39 PM, Matt Mackall wrote:
> 
> [temporarily coming out of retirement to provide a clue]
> 
> The pool mixing function is intentionally _reversible_. This is a
> crucial security property.
> 
> That means, if I have an initial secret pool state X, and hostile
> attacker controlled data Y, then we can do:
> 
> X' = mix(X, Y)
> 
>  and 
> 
> X = unmix(X', Y)
> 
> We can see from this that the combination of (X' and Y) still contain
> the information that was originally in X. Since it's clearly not in Y..
> it must all remain in X'.
> 

This of course assumes that the attacker doesn't know the state of the
pool X.

The other thing to note is that reversible doesn't necessarily mean
linear (the current mixing function is linear.)  AES, for example, is
reversible (if and only if you possess the key) but is highly nonlinear.

I'm not saying we should use AES to mix the pool -- it is almost
guaranteed to be too expensive.

	-hpa


