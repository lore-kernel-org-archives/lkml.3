Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaEOIZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:25:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbaEOIZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:25:12 -0400
Date: Thu, 15 May 2014 10:25:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
Message-ID: <20140515082507.GC30445@twins.programming.kicks-ass.net>
References: <20140512190438.314125476@linutronix.de>
 <20140513035404.GA68181@dvhart-mac01.local>
 <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de>
 <53731608.3010803@redhat.com>
 <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de>
 <5373D94E.5030800@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/SlKNoLjL08cymhl"
Content-Disposition: inline
In-Reply-To: <5373D94E.5030800@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/SlKNoLjL08cymhl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 04:59:58PM -0400, Carlos O'Donell wrote:
> I will make my personal opinion clear:
>=20
> - Internal defects should raise immediate assertions.
>=20
> - Real problems like resource availability, deadlocks, and
>   other recoverable errors should result in the API returning
>   an appropriate error code that must not diverge from the POSIX
>   definitions for those codes (when such a definition exists).
>=20
> I'm not a believer in "only the hot path matters", there are such
> things as robustness and error detection, and they matter.

Awesome. In case of doubt though, I would prefer a return to an assert,
just in case userspace actually does know wtf its doing ;-)

Granted, that seems to be very rare, but still, its entirely annoying
for those few people who do care to get dead programs.

Alternatively, we could have something like you have for the allocator
(which is, afaik, also considered a hot path) these env variables like
MALLOC_CHECK_ to influence this edge behaviour.

--/SlKNoLjL08cymhl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHnjAAoJEHZH4aRLwOS6QSsP/3YF0Zgr/Gtovu4ybl5oY5kb
Z2jjX1XdiE55IDCgahLWECSh7iZyM4JfEcIUUqmYEnofgaKk+4ACecLFD7it8fp4
Xt/ROS43oQpgAKkQ89QQ6xxVLYWYKsyOwU2z1VTmP6H0FgbrodLXBkWif7GcupAl
I5qXn8s2VNMtN3VdWlzoxuGr+PkLPXyZWkVKJDzSz1RNsotpphUN8KU6Gl22KIG/
6udhK0FtrBP3s0wpA00Tqqz7dhJThNU/tfdDvQwjRTb9qzYXGgDDiO74VKBQ4tMv
JwdVkETr5xOyQt8o2Eb+3GLmttqfL1H1MMxqc30yyEhBee4b4SQ8ylnV241o0l4o
iIIVqpo+YIt7X6gBQ1fEJFCfFURHckV3J7lCU5CDFIeqpHJnR33Un/mmnsvfY7ff
s8tH+HUtQGvPQcXmVxw8EFfzp+a5Ga42AyI7FIVokKRTSdd5+36wIjGHUkYyqGWm
Qk4Mi1K7DCOmt4OydSsaFqY7cmx+lWrZXPSfetIqvoo3SVoXyJE4kBYyAcIbteev
Bqm538RqkrUx6GSC0Du4kh54oQ4mXpl1BD9Fr4AdKXOgQqAKFK4GiMWbNn8T/LNe
mtDvc0aBwVrgDzO3JcMMqxgzs4iz10x48qC0Oim5JrcPJ2RWoeTPMdrDq3kr5Qnp
wv/gGgy3yn3uI6Vk9Php
=Qfxg
-----END PGP SIGNATURE-----

--/SlKNoLjL08cymhl--
