Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaESKyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaESKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:23 -0400
Date: Mon, 19 May 2014 12:54:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140519105404.GZ30445@twins.programming.kicks-ass.net>
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
 <20140514154459.GE4570@linux.vnet.ibm.com>
 <1400123931.5175.38.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HditFSw+SJxJh6AP"
Content-Disposition: inline
In-Reply-To: <1400123931.5175.38.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HditFSw+SJxJh6AP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 05:18:51AM +0200, Mike Galbraith wrote:
> On Wed, 2014-05-14 at 08:44 -0700, Paul E. McKenney wrote:
>=20
> > In practice, not sure how much testing CONFIG_NO_HZ_FULL=3Dy has receiv=
ed
> > for -rt kernels in production environments.
>=20
> I took 3.14-rt out for a quick spin on my 64 core box, it didn't work at
> all with 60 cores isolated.  I didn't have time to rummage, but it looks
> like there are still bugs to squash.=20
>=20
> Biggest problem with CONFIG_NO_HZ_FULL is the price tag.  It just raped
> fast mover performance last time I measured.

Syscall entry and exit times are through the roof with it. So anything
doing loads of syscalls will suffer badly.

--HditFSw+SJxJh6AP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTeeLMAAoJEHZH4aRLwOS6KCAP/ilJRsxFkR9rQNK6LanTx6S3
RbvdAmgdvRTvELyJTT2QzGyBo/GNz/f4LbXnLd37iGQwBEUY8eLEpLuUVKPXPAkk
VuEDsQy/Y8K2GOlJ4E0D8ZHa0/VFpcWvJrFE6fhbHioq2E0EOU/AiliKU74u+y2j
XufiDl4xo8cH36tO2pM5VNEvM0p/0KxwELJNB5RUpdhxS/H8o2QoEfwlMY45WTzW
Uss/jxt/FfB9xXLBozaQUkSr5fC+ZpyXrGkT7EIasCgp6GfH55iz6JvSq1fn/Qtb
xAMsxrAMHkr3CMejUQaoJ9A8S6IrBcS7Cn8nkFWwdun98EHXJnh9Cx9G2uKzeTDu
2+Nf/mZqDspncKSt+TmhOB2e7Xs8SXOfpErtFPdLyQeubH1QgyY7jSvYryGCNuP9
b94II8bPIfp2OpAThpDhzVqNhw3oSGPiiZom8CZMKSs0uSq38Oqqn7iaOLueSaeC
Yth3U4+bmNQk858W18whwZP6ShGXLrGcuIVSTXd/zLI1GB+iCtxYlJ2j/oPmFgfg
TAsX8MXY5FVVN9ffoIQLMfHScMVt4rOdvxNGFF3kmP+RgS0+UoORieKk2gEb05BR
gr+N81Q2qAYBFoBb/8t7zJAMPlWgAVCQU7xLJwqG7888tt/oPphrGBwmWRO5GvMr
/OTXqYgc7d3jUQ2LqD6H
=xbBp
-----END PGP SIGNATURE-----

--HditFSw+SJxJh6AP--
