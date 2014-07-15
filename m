Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaGOIyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:54:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaGOIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:53:56 -0400
Date: Tue, 15 Jul 2014 10:53:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer
 failure
Message-ID: <20140715085342.GR9918@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1407141633190.4920@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fK3V1lYkOC7b6W9K"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407141633190.4920@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fK3V1lYkOC7b6W9K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 04:33:47PM -0700, David Rientjes wrote:
> On Mon, 30 Jun 2014, David Rientjes wrote:
>=20
> > It's unnecessary to excessively spam the kernel log anytime the BTS buf=
fer=20
> > cannot be allocated, so make this allocation __GFP_NOWARN.
> >=20
> > The user probably will want to at least find some artifact that the=20
> > allocation has failed in the past, probably due to fragmentation becaus=
e=20
> > of its large size, when it's not allocated at bootstrap.  Thus, add a=
=20
> > WARN_ONCE() so something is left behind for them to understand why perf=
=20
> > commnads that require PEBS is not working properly.
> >=20
> > Signed-off-by: David Rientjes <rientjes@google.com>
>=20
> Peter, would you like to ack this?  Trying to get this merged in time for=
=20
> the next merge window.

I've queued it; still don't like it though.

--fK3V1lYkOC7b6W9K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxOwQAAoJEHZH4aRLwOS6nGkP+wcvEDnKaS7Kniv7otj7GxM1
6vl8bce/OVNfBcIp20iVuaKyH5KHF3HR6TrouH/Xq62DTHs/gJs7S0E241m+0+mO
q3coEdlvVOiEXVFkqyVrN/yqnk3e/YYVMLbTkPo0MgJS4K1h7Df4A1vNHx2h0bf5
Pi4X8DRIjSmKl7p3ZziDxgtHrOnaaOTHC1S+z2gwHe5IIZ+OOn4oGrik/BDbDwaX
tJjv+n5tq6bjYvpa3HOQ3/BJyKS2KeinSK1o6YuZASPg7UkQ/4o5qjKfWbO9ThRs
rE/tQCtbnZLtxXEOPisFZqQ/va9LDnxXPK9YSxuPyTkdUuXRoYe1MJddaWBjgdtR
uD/G3iTuUTy03dBfCewoxGyJ5GDENZdpj7htmAGvu1W6dWIjEF5EYKmlHvZY56gt
xkurpJkZH52dIrPkgSvExUp65UeX4kTowGkHSaPPqSVmMelrSfDcChCAnu6vVqhE
zAm1g9RsH2e2vZiXi/hv/Q7izkBpT55UlJevmqaBfpdv6B/QcHzSRhsf27ZCk24a
UXHMkSHZmjPGkkK3vZpW0qBfeLp5K8UY5oXKfEgw7hVhbMfz3Mcpx7u3/xdqkmDX
7JfqVHJax0dgJkL2DJQ7IoYG+402BmyXMN0eaBbsSifFWaOeT3gTOm0pPf3VYuSN
VAFNt9DythWbWY3uhqLb
=jiK+
-----END PGP SIGNATURE-----

--fK3V1lYkOC7b6W9K--
