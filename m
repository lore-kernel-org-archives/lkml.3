Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaCFBev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:34:51 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54458 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaCFBes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <1394067147.17842.45.camel@calx>
References: <20140303235148.GA7601@www.outflux.net>
	<20140304153841.GN1872@titan.lakedaemon.net>
	<CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
	<20140304195356.GS1872@titan.lakedaemon.net>
	<CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
	<1393972797.8344.190.camel@calx>
	<20140305211145.GV1872@titan.lakedaemon.net>
	<1394067147.17842.45.camel@calx>
Date: Wed, 5 Mar 2014 17:34:48 -0800
X-Google-Sender-Auth: EhMdb-aj6TWqq4FCPoXzQmkC2TQ
Message-ID: <CAGXu5j+ddoy_v4y-cwgZmiKCe5DTARgkQYNntfNaY5msyADvtg@mail.gmail.com>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng sources
From: Kees Cook <keescook@chromium.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Jason Cooper <jason@lakedaemon.net>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 4:52 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Wed, 2014-03-05 at 16:11 -0500, Jason Cooper wrote:
>> > In other words, if there are 4096 bits of "unknownness" in X to start
>> > with, and I can get those same 4096 bits of "unknownness" back by
>> > unmixing X' and Y, then there must still be 4096 bits of "unknownness"
>> > in X'. If X' is 4096 bits long, then we've just proven that
>> > reversibility means the attacker can know nothing about the contents of
>> > X' by his choice of Y.
>>
>> Well, this reinforces my comfortability with loadable modules.  The pool
>> is already initialized by the point at which the driver is loaded.
>>
>> Unfortunately, any of the drivers in hw_random can be built in.  When
>> built in, hwrng_register is going to be called during the kernel
>> initialization process.  In that case, the unknownness in X is not 4096
>> bits, but far less.  Also, the items that may have seeded X (MAC addr,
>> time, etc) are discoverable by a potential attacker.  This is also well
>> before random-seed has been fed in.
>
> To which I would respond.. so?
>
> If the pool is in an attacker-knowable state at early boot, adding
> attacker-controlled data does not make the situation any worse. In fact,
> if the attacker has less-than-perfect control of the inputs, mixing more
> things in will make things exponentially harder for the attacker.
>
> Put another way: mixing can't ever removes unknownness from the pool, it
> can only add more. So the only reason you should ever choose not to mix
> something into the pool is performance.

Excellent. So it sounds like you're okay with my original patch as-is?

-Kees

-- 
Kees Cook
Chrome OS Security
