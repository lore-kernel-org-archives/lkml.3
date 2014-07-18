Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbaGRUXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:23:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:46575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbaGRUXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:23:02 -0400
Date: Fri, 18 Jul 2014 22:22:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140718202250.GR9918@twins.programming.kicks-ass.net>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <20140718191338.GF3935@laptop>
 <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
 <20140718193417.GG3935@laptop>
 <53C97995.2090500@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AAf1pfr5RnNeEo0"
Content-Disposition: inline
In-Reply-To: <53C97995.2090500@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AAf1pfr5RnNeEo0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 12:46:29PM -0700, John Stultz wrote:
> On 07/18/2014 12:34 PM, Peter Zijlstra wrote:
> > On Fri, Jul 18, 2014 at 12:25:48PM -0700, John Stultz wrote:
> >> Also, assuming we someday will merge the x86 sched_clock logic into
> >> the generic sched_clock code, we'll have to handle cases where they
> >> aren't the same.
> > I prefer that to not happen. I spend quite a bit of time and effort to
> > make the x86 code go fast, and that generic code doesn't look like fast
> > at all.
>=20
> A stretch goal then :)
>=20
> But yes, the generic sched_clock logic has really just started w/ ARM
> and is hopefully moving out to pick up more architectures. I suspect it
> will need to adapt many of your tricks from (if not a whole migration to
> some of) the x86 code. And even if the x86 code stays separate for
> optimization reasons, thats fine.

So the generic stuff seems optimized for 32bit arch, short clocks and
seems to hard assume the clock is globally consistent.

The x86 sched_clock code is optimized for 64bit, has a full 64bit clock
and cannot ever assume the thing is globally consistent (until Intel/AMD
stop making the TSC register writable -- including, and maybe
especially, for SMM).

There is just not much that overlaps there.

> But as folks try to align things like perf timestamps with time domains
> we expose to userspace, we'll have to keep some of the semantics in sync
> between the various implementations, and having lots of separate
> implementations will be a burden.

We're already there, there's about nr_arch - 5 implementations,
hopefully many trivial ones though.

--7AAf1pfr5RnNeEo0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTyYIVAAoJEHZH4aRLwOS6DtIP/0g/Hrn02n0EVhHt1QlZ58He
3KkjY3h+9oxIbMv9sLVqumccI82634O0Zqq4ZMgkxqx8vDXSo9XW2Hf3zvgPiCO8
vcC7/grGRfr/K0heWiJs6xtEXpx58rV6hVI4/J/SlH9remux8FMkNrT8S6507+rN
t5WepReMyOn2AohYEHnNJUOYzNmWXZAxBGvRQ1ukzh39HgCwOo9NqVuMuEWxa1Yd
dUThd4nreJx71kzXmL47UI0sPUk2Xw2D/aUE5KO8DXqAGU4ErIdM5rx1N74pzVqN
nDJHrxJsJ8xvSj4TXKHiyUhiFOxPzKeYgd/YZmJf+VgSpxVYv23vXfQ7/2SYterf
iOtJwlqQiaLD0IwWp0dCVheAM6dFuG5x1Gn47n1frFvMqRv2s6Y/lA0Ahj1kNBx1
jaern+ZbJ3yn2pW2EqgQvAJkAhY85m1v36RNHtVezkoSXWCAPv1BqJf40yGTDcvW
LPvzjPuA9rLz9cLvlLW9qbonpWh2rRhpSoY9GD+XF+Ylji6Pv4GJSY1lr/D0C4SH
B4BTf4EX7BhUhH6tu21Tdi0ESe4X+sefp4hE/P+pyhTRLlRZkwI9gDui5g0+j6xR
lmO6sdgRYwGa7pYGRgPxLOgn+i9OkiOlt/EaR0CBYGYwrlxQ/eiCE+Pz0DrnAMm/
xFdgKeDrgImDfsFWwHRz
=UfFs
-----END PGP SIGNATURE-----

--7AAf1pfr5RnNeEo0--
