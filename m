Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaEGPRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:17:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaEGPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:17:44 -0400
Date: Wed, 7 May 2014 17:17:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140507151735.GQ30445@twins.programming.kicks-ass.net>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
 <20140505133113.GD1429@laptop.programming.kicks-ass.net>
 <20140505150356.GB2099@localhost.localdomain>
 <20140505151228.GR26782@laptop.programming.kicks-ass.net>
 <20140505153405.GD2099@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
Content-Disposition: inline
In-Reply-To: <20140505153405.GD2099@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 05:34:08PM +0200, Frederic Weisbecker wrote:
> On Mon, May 05, 2014 at 05:12:28PM +0200, Peter Zijlstra wrote:
> > > Note the current ordering:
> > >=20
> > >     cmpxchg(&qsd->pending, 0, 1)       get ipi
> > >     csd_lock(qsd->csd)                 xchg(&qsd->pending, 1)
> > >     send ipi                           csd_unlock(qsd->csd)
> > >=20
> > >=20
> > > So there shouldn't be racing updaters. Also ipi sender shouldn't
> > > race with ipi receiver, the update shouldn't always eventually see
> > > the unlock happening.
> >=20
> > Yeah, I've not spotted how this particular train wreck happens either.
> >=20
> > The problem is reproduction, it took me 9 hours to confirm I could
> > reproduce the problem on my machine. So how long to I run it with this
> > patch reverted to show its gone..
>=20
> Maybe it could be favoured cpu hotplug. Anyway converting to irq_work sho=
uld
> fix it.

Ingo needs a commit msg for the revert of this patch; do you think you
have time to look into _why_ this patch is broken and write such a
thing?

--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTak6PAAoJEHZH4aRLwOS69hUQAKlT4ZTa/JCys+vIQ78970gf
ao++5cWVha6laKANYHGtoNyIGL0tpEonqMyTiP2+BvL5fCQt2rYYQ0piDkbIDhQs
eI3YiCKz8LM/Oee23U9pMeHEnmNAnhvk7pWrNWjzipKeV9x25PKWOk2QV1hT4bP7
qb1q0+iNB3KNipKRwmUSEkwhD3OhoL/b5ylqxW8xzFCuz/mJ1L4kHCjCTWim28Y8
4QcIrNyhDbPBOO6APbIoJo++NQmjVkXTBI9tqNUEdDxqJyEv560IlkfXlqk0bgcA
sqJzQgEmRXFpnUUbtGEB+z0Ela0hPzAzBDXCImsT3eT44+XcDY06dB4sk3SJlkZs
ww6A2IB3/BLpFMIQmY7TRU8Nwu/b5pdxTQT5xLs+G/cLhKo1/0RkVvpA7tuPBhh0
ZyQwL5C67XAQQgXxudZHxjiFEc0H/AeWkHajHFEMi9HApgdKe2FBlaVLWJsuKypx
Z/GD3rII10AGdSKNwWD+iCNfhJc9Ec4RXXyw76LBjPzOFUA/Q9AgXOYTqWGfIke1
6FiUG2rM0snxvgXuQzcW8WLGeknNd3lkuR/ZQ2ZhqrfFuXWZHnWuHj42S3pbvlRo
YX7k+To0MAfCktvdZHcd3taiGJISmZ7AK+ByLRpTtbL4nZTBnNjEh+scyIoq0eOQ
mQDgAmL6XpngjNBbssJD
=sbDR
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--
