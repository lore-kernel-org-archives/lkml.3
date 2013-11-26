Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3KZEbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:31:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3KZEbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:31:20 -0500
Date: Tue, 26 Nov 2013 15:31:06 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: fengguang.wu@intel.com, "Li, Shaohua" <shaohua.li@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: kernel BUG at drivers/md/raid5.c:693!
Message-ID: <20131126153106.6ae734c0@notabene.brown>
In-Reply-To: <20131125095323.GW10022@twins.programming.kicks-ass.net>
References: <20131123032205.GB20794@localhost>
	<20131125103522.6a1c1b36@notabene.brown>
	<20131125095323.GW10022@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nrEUlSL7i4ap.UJKWo9K/be"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nrEUlSL7i4ap.UJKWo9K/be
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Nov 2013 10:53:23 +0100 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Mon, Nov 25, 2013 at 10:35:22AM +1100, NeilBrown wrote:
> > Ingo/Peter: is it considered OK to call wake_up while holding a spinloc=
k?
>=20
> Yes, very much so. Doing a wakeup isn't _that_ expensive.

Oh good.  Thanks.

>=20
> > Could "sleeping spinlocks" affect this at all? (some sample stack trace=
s are
> > below).
>=20
> Not entirely sure, are you referencing to -rt where me make spinlock_t
> pi-mutexes?

I'm not sure either.  Just stabbing in the dark really.

The stack trace in the previous email seemed to suggest that a process was
blocking inside a wake_up call, but it wasn't at all conclusive.  And I've
seen a few wake_ups in other stack traces which seem to be connected with
other deadlock.  Probably some sort of co-incidence.

Thanks,
NeilBrown

--Sig_/nrEUlSL7i4ap.UJKWo9K/be
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpQkCjnsnt1WYoG5AQLKSRAApDI4zj/SkSRojgZ31ChTeMgyDpa8brOT
Z5mDETeH0OZpJ7FSyuc7Gd+32dXydhVdp+Ky2HsUlQb3q5M2FRtDEIlFtNTYROlx
1oVXBx65HiQhM9IdFY6xJH+CvG6xVLzNs0UHN//xtbzKta/4S1EIRRRXpj8YV94Q
RdI7bb9A9gpx/uE4r/pIq1vSTA547y777Tec9ndwRgncTVwnWIIbpa0jOUuLitcn
5iNujrfjcYm1sG4jPi8pZwdEiTjCM+uHUWfhzEnc0jLQHpna3/zCa+3JgKqe1O8j
lLQuYAW32DL8X7FcVW8Pq5SGg6XZg+yXNPoDxeRJy9E2I0qtUpOo+e5XeOc0wTYJ
DiHyjq+zwAAIwTeWfxEE9zzennVcdTuEJX1D5FTpc55qUOjJ/sQxJdopeeMhkzIH
b6RWshXzWWFAWkUAtwwn3GgKGQdEkGLu+ME9X+lWnS9eMi2KhjE6eBkUsCwsNNQq
WI9rcQEB9I/AAqkagPOaykydXk7okbyFgzWRiBXhLCQsNklkCkxGKxTXFZD9YHss
Ggrkkf1NGvm5R7vnAo8UfuMk72k/NRyiworAEkwYzeVJ3YmF5a/bPExD/ixZ9Chq
edebveJwyguWAM1hWzj9Yw6PhO6POP4Wv3hhetdBlmRFAseaY9Ewy7lRQf2f8Vi8
1afKZO3OWx4=
=FL5n
-----END PGP SIGNATURE-----

--Sig_/nrEUlSL7i4ap.UJKWo9K/be--
