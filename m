Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaFJPuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:50:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaFJPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:50:43 -0400
Date: Tue, 10 Jun 2014 17:50:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Per-task wait_queue_t
Message-ID: <20140610155037.GG3213@twins.programming.kicks-ass.net>
References: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com>
 <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IRIOLc8eTv1AOxGv"
Content-Disposition: inline
In-Reply-To: <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IRIOLc8eTv1AOxGv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 02:29:17PM +0200, Rasmus Villemoes wrote:
> This is an attempt to reduce the stack footprint of various functions
> (those using any of the wait_event_* macros), by removing the need to
> allocate a wait_queue_t on the stack and instead use a single instance
> embedded in task_struct. I'm not really sure where the best place to
> put it is; I just placed it next to other list bookkeeping fields.
>=20
> For now, there is a little unconditional debugging. This could later
> be removed or maybe be made dependent on some CONFIG_* variable. The
> idea of using ->flags is taken from Pavel [1] (I originally stored
> (void*)1 into ->private).
>=20
> Compiles, but not actually tested.
>=20

Doesn't look too bad, would be good to be tested and have some numbers
on the amount of stack saved etc..

--IRIOLc8eTv1AOxGv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlylNAAoJEHZH4aRLwOS6aq0P/iv9B6H4kJixIA20W6rb/ijb
s45/PqyBO82rH6pv9RAuOZcuNBVJq5sJfY/rzs7g42KN3jPw5qUQCSv+djFiOqx4
9i0tBoGpQYibWEuC9Yzpa3pAMCFkY1BfFEdezwY274CwyyHyhGBr0+Pnb7Hrp9Lz
FD/jI/ryq0ygh/24fpY78mZ/qs5xXgws4+sg/xJiseJJ5vkNIyqoblhQAPE5JTEL
Rimxc1OH4vU1EzsamoKxJvdKgONmR6YcoUHLI3CgyHwm9yPlpj4leb+QQn3HfN9X
0Vnlx1AAQCeJ9Q4aNv2Ho0a3KYEC6gDxfsSgw6Z+x7HzwMoEKbHd5qGUV+BJXGs4
riqycw+7WCZKXYpxrvvhQFH9y5w2+imMr92Pn5SoyXnAAbCGA0i7zlmfZf8cZYr9
nCzYt0cMOib0GSY8wt7i5/7MWTyQn0QnsFUKChSMGCSlxWC0aFEMDbtvfCAPOaV5
0gwOPVcuckDSgqnKH/sugryxl1MqmAjcxoL9EdTWBADXpHR6H0Pr2jjQvBB0367C
5+4EszP5ZfcAt/nU86PlVqW+Iyh4JRKnHhZF1oEO5A8Xe26j/2szXb1/y/iSR+jV
ioOeHMPFFlXvX5rzmhNf6XNakOYufqMyGKecRZp45l5vRIHAwkqrnK1XLv3Pkdpb
B64sXYLsOuRtLwhgJ9yi
=kBKT
-----END PGP SIGNATURE-----

--IRIOLc8eTv1AOxGv--
