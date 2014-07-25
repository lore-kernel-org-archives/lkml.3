Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbaGYPxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:53:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaGYPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:53:45 -0400
Date: Fri, 25 Jul 2014 17:53:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
Message-ID: <20140725155332.GC6758@twins.programming.kicks-ass.net>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <20140725150445.GG18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1wow/xSTdHOmT240"
Content-Disposition: inline
In-Reply-To: <20140725150445.GG18735@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1wow/xSTdHOmT240
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 05:04:45PM +0200, Andi Kleen wrote:
> > You can't.. the events might have different security context.
> >=20
> > Remember, the overflow bit is set from the overflow until the PEBS
> > event is generated, this is quite a long time. So if another PEBS event
> > gets generated while the other is still pending it will have both bits
> > set. Even though the second bit is for another (unrelated) counter.
>=20
> When an event is not allowed by some policy it should be disabled
> in global ctrl right? And disabling makes sure overflow is cleared,
> and PEBS will not report it.
>=20
> When it's not disabled it could happen any time and there
> is no isolation.
>=20
> Or is the concern that the PEBS buffer may not be flushed
> on event switch/disable and you see something stale? I believe it is
> flushed.

Suppose two pebs events, one has exclude_kernel set. It overflows,
before entering the kernel, the other event generates PEBS records from
inside the kernel with both events marked in the overflow field.

And only once we leave the kernel can the exclude_kernel event tick
again and trigger the assist, finalyl clearing the bit.

If you were to report the records to both events, one would get a lot of
kernel info he was not entitled to.

--1wow/xSTdHOmT240
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0n17AAoJEHZH4aRLwOS6vooP/02GvbWN5QeNsqQFlZR9y9Gr
s+DGO/epaMlr4PtOeC3OzusILJFX2xblFVXLQrVf+25Ll06P2m6Pp6ULRFH4xqvq
7Ql73hX0AN9QxviSYUVrWnf0KTPIsnQMO+X7XjjcAEjsJUiNYo7yDR5Xa4c/GS14
iBovkrKr3LbDvNB9+ZMqvW8+yo9HSxjSFnr9PiMYH+lqtrL685vnWvjOynu12RqM
BtvYX7pxcFQCdn7V+QdY16p06YERhgamTOlNGQIvMERELWnkukc0aut4rpmWazn0
pxYH3YUiTpI+gW3FQDZmTSfumVlY6wOJ5vwiIrOL9q7NnLZN7Z7jFRV5bjsmE/Mc
LYMs/aDz1sBB7M8f7MVwce8Emy26N+ZpGj8S6tORLhov5tr6Fj/nEiewmTI5Fxap
4RTSR1gqmeoDPC6iz+RinlI2BBM7fYkE7E76vP78yf/nSyNV1uFDKFNv5PGLXD8M
gNu7SneB4ZQXL55I1ImIlANrZZgsBM2+bfkL4ugVIrAf6syvRUH6gUyobnWKZP5Y
GF2KghQFURR8PkZIFP37K7rovc9Aj9EissmOaw8VDHz9Ax06Xbcra91y8iJHSybv
D+LTk1w8kD8+QnrhXw3t/REDZV39rE7jw0EAdvtzUBJR8V7VMEz3I0Sr41UJc5gr
ntIcvEk3JkdLYDse0clo
=Cy7Y
-----END PGP SIGNATURE-----

--1wow/xSTdHOmT240--
