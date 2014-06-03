Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaFCHyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:54:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:40108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaFCHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:54:43 -0400
Date: Tue, 3 Jun 2014 09:54:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603075433.GI11096@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
 <538CB56E.5010709@hp.com>
 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
 <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eOjGLwyQwZ6mtm8V"
Content-Disposition: inline
In-Reply-To: <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eOjGLwyQwZ6mtm8V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 01:22:10PM -0700, Linus Torvalds wrote:
> On Mon, Jun 2, 2014 at 1:05 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> >
> > So the question is, do you prefer subtly broken code or hard compile
> > fails? Me, I go for the compile fail.
>=20
> The thing is, parisc has a perfectly fine "cmpxchg" implementation in
> practice, and ACCESS_ONCE() and friends work fine too for reading.
>=20
> What the "use a spinlock" approach cannot generally do is:
>=20
>  - ACCESS_ONCE() to _write_ things doesn't work well. You really
> should use "atomic_set()".
>=20
>  - you may not necessarily be able to mix partial updates (ie
> differently sized updates to the same thing) depending on just how the
> spinlock hashing works
>=20
> but both of those are really rare issues and don't affect normal code.

Agreed on the second, although that would be fairly easy to fix by
masking out the lower few bits in the pointer address before hashing.

The first, you're probably, right, but seeing how its a completely
silent fail atm I'm not at all comfortable with it.

--eOjGLwyQwZ6mtm8V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjX85AAoJEHZH4aRLwOS6nngQAK9nbOEBxJRjxLBTjGqT2h3H
CblDpBj0FzQanVUULCmxxLuGwqwqTCcGF/LClYd4+SUaKjD0DErQj5bDI9+IM2zv
ypDvuWUo7M6OlyMMXEBSkw9E6zSZzl0W5Icznx2gj0Hh0DgcGmuYzHwSKRCdk290
00soo4700xK7beYrQ9iF2iBgYIY0tqFoP5FQPeOTNX4eTvnYyRjz0BXAAWxqO2Hl
qMVDtclFkfe3JoQmr2r24ZDdgN9XIjIlIK0UXSwL3S2paSZxBHzq9e1jil9VD+/b
LORmUqIXdz+56RG7Vqdn1V/RwlOk/K8RPYRby7FvzQx993k6XvxYWS9GwgLQhn0U
y2wz3O72K3qirIxzXF5CP714xHe+ChMh9F9O91nLxxecdwEwvm7u/xe63XMI4eNV
TWwAy0Tiv2gPY3cozgYMWBm1989ZQ1zfS98mJhDOdmsirYeV5F8fwzxD7eJeE/4A
nlTIMzQqC/FeRYFOdxdWK3kCr1QG/a+1H8snBIUgdZZjG3NajXvgGWtzThXPZ+VU
O+Xt7CQiGiIdSv+eXTULSdD+mcvCcw9VjFevMY4P+EYti8oAHBGv9GJr9YQhOx1Y
4RcgUJ3hqVwhH+Y6unZXfbddcjAdHGU8h87DqI0daS7j85wJZtN8yxi+/4Dx8Z4a
eEdB2bjrS8tuAg7Wof/2
=zSlX
-----END PGP SIGNATURE-----

--eOjGLwyQwZ6mtm8V--
