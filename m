Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3J0W1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:27:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59434 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab3J0W1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:27:02 -0400
Message-ID: <1382912801.2994.61.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Ben Hutchings <ben@decadent.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Date: Sun, 27 Oct 2013 22:26:41 +0000
In-Reply-To: <1382912049.30941.5.camel@joe-AO722>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
	 <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
	 <1382912049.30941.5.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yvBhL6H7kiF9CEsJJ4Ad"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yvBhL6H7kiF9CEsJJ4Ad
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-10-27 at 15:14 -0700, Joe Perches wrote:
> On Sun, 2013-10-27 at 22:02 +0000, Ben Hutchings wrote:
> > On Sun, 2013-10-27 at 14:58 -0700, Joe Perches wrote:
> > > On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> > > > Physical addresses may be wider than virtual addresses (e.g. on i38=
6
> > > > with PAE) and must not be formatted with %p.
> > >=20
> > > %pa works.  %pa also prefixes with 0x.
> >=20
> > Only as long as pci_resource_start() happens to be an lvalue.  I'd
> > rather not introduce that assumption.
>=20
> pci_resource_start returns a resource_size_t which is a phys_addr_t.
>=20
> Changing that from an lvalue would cause a _lot_ of breakage.

I don't think so.  This doesn't find anything:
    git grep '&[ (]*pci_resource_start'

and I was able to build drivers/{net,pci,scsi}/ successfully with
pci_resource_start() changed to an inline function.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-yvBhL6H7kiF9CEsJJ4Ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2TIee/yOyVhhEJAQp7AQ//WEmqg3V78tJmR4AfgXvQ7gp/h3C48O5z
xNje9Ou7CQf6nv8wB1bw8ynRQX6AKFr1zfkTw4TbjHPEo+JvA+6dKdSUiEdj00gE
4SUTEKTVQj+nUV8qqKbMpq3smB1b5zRbq20PzIsAQIawe+P7i1d7s+OUn2uXSxkU
RJzaVhZCuPAl7mGZhALWHM1olEQCN7gAQVBgJvj2+66w1NUeaTemUXyReTFt1j1K
oB9N21uWpEbwh0cKsl9ce5Yg8TaC4OfaLBK27xZWGn3PdW5X6iLPWhY0ADVJtNTD
hfOoXn1hY29AovhUqf7M8fRyv08k+4CEd1wJXyZmi3+/k6Wii81kbIhpjuRHq4VH
TaPIvUogeDRTyFLiXTaS7sywNWnAMwYJOHR/Do7pHzlf54qer5Q+C//3y1Tx7ESK
BFr23uJQvanJs8KbBw7AjThzI0bp3Kw7f3vsA4bP1oYSKWXIXX5O1VNYB8SvJLVl
6fTap3RT93pQ5NcCpf5mRGe7h3x1ifF6muekLpOhsRxEu0Qo1btiBkbhc1kg4/OK
iZNnQ/8gC7PngkCcYtf7cRVkE+BjUkpMTQBw3ujIs7TrmXRL+H3mTxnN4YlQDyot
d86ZzYjd+qIRiO7162MvUax2Ky2cELlSblo7Z4kHrf0Zn/mtNUadUkA7CS4v2F/U
2d6CbKjXOUE=
=qmAJ
-----END PGP SIGNATURE-----

--=-yvBhL6H7kiF9CEsJJ4Ad--
