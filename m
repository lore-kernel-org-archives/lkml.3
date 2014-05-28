Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaE1RUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:20:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:43911 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaE1RUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:20:06 -0400
Date: Wed, 28 May 2014 19:19:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528171957.GW30445@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
 <20140528165144.GK29957@tassilo.jf.intel.com>
 <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
 <20140528171243.GL29957@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="31SVYaQYwlkHQLrz"
Content-Disposition: inline
In-Reply-To: <20140528171243.GL29957@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--31SVYaQYwlkHQLrz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 10:12:43AM -0700, Andi Kleen wrote:
> > So, you're telling me this is a sanity check. That p->status can
> > only have one bit set. Somehow that's not how I recall it working.
>=20
> It can have multiple bits set. We don't know for sure for which
> it is, but we should only deliver it for one anyways.
>=20
> > The point is that a single PEBS record is enough for multiple
> > events when the overflows occur simultaneously because they
> > all get the same machine state which is correct.  A single entry
> > also saves space in the buffer.
>=20
> The CPU will generate multiple PEBS records in this case.
> So if we delivered it for all you would overcount by factor 4x
>=20
> [Again this is a very unlikely situation. Normally counters
> are not in lock step]

Well, the thing is, the delay between overflow and the assist being
armed can be quite a few cycles, and then waiting for the next event to
trigger can again be quite a few cycles.

So the window is fairly large for another to slip in, esp if you have a
fast (say inst-ret) and a slow (say br-misp) event.

Also, it really blows this never got addressed, even though I've been
complaining about this for years.

--31SVYaQYwlkHQLrz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThhq9AAoJEHZH4aRLwOS6CWcP/Rw+OWhf8zg7nMwC4hBG+o1j
jYBQPwOOdBIeJoj3BI7bJKartsMCzO3pC602pJjca4zF8ZCLBYjUxQt1zXfmHZ7m
faU8XLIr0sQAI6EpaNFh4t2VRw76jVlWMtmnQ4p39nwzNYZ8GpNevqsUU0Hlpcmn
2LLeX2rANcFHt+0yqORjAehPscNEwLGEQ6Arzn/3x13Fc0mHknh1sngZqULfyCc7
rDgFTjprtEEZYIc4yOpS55ApgGRwg9Tez+XK/qrl7VX8AA+PwofGruwCIQfTRYel
0fPIQW9CTvtXGks1UPe6izOUVb27V72/GGWzfM5/e0tDiD7YHC60/Rh48n6qxQ8H
uoHe5n+N8KH/cCHyVqKfqMhvC+fS9rVjao2TKPT5lTehLgvM0l4+kqhnlZFkb64C
5ehcyHd4Ef90z0ZV1gYqTTqkJgGf5m2yO1WTXfIKFLjNw3JffM7+gQk4ZGmjUvkI
Gs6DyOl7Ub6eaZjSJvQrqFGRUzesQBLoutqpwKe5wjLW36qaeL4kJDLZa26jRFAi
w8IlwZzHd+Jnpq2Aa7zRnOB3iDBqLqgl0wxbVY0+Z4pVSgeJnFC2OwdFW6hLxVY+
RrRu//AptO39SlJQRHMfggWvkdCIwYvMv//y6dEqBAq35iqsEUWQRJplxWZIjW3y
/irmLrO7TtsZUM/cCA7a
=ZKK7
-----END PGP SIGNATURE-----

--31SVYaQYwlkHQLrz--
