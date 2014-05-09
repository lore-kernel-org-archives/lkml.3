Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaEIJLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:11:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaEIJLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:11:37 -0400
Date: Fri, 9 May 2014 11:11:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] metag: fix memory barriers
Message-ID: <20140509091131.GL30445@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1405081546110.4346@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2vfFyZRy2guiefOI"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1405081546110.4346@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2vfFyZRy2guiefOI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 03:51:37PM -0400, Mikulas Patocka wrote:
> Volatile access doesn't really imply the compiler barrier. Volatile access
> is only ordered with respect to other volatile accesses, it isn't ordered
> with respect to general memory accesses. Gcc may reorder memory accesses
> around volatile access, as we can see in this simple example (if we
> compile it with optimization, both increments of *b will be collapsed to
> just one):
>=20
> void fn(volatile int *a, long *b)
> {
> 	(*b)++;
> 	*a =3D 10;
> 	(*b)++;
> }
>=20
> Consequently, we need the compiler barrier after a write to the volatile
> variable, to make sure that the compiler doesn't reorder the volatile
> write with something else.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Acked-by: Peter Zijlstra <peterz@infradead.org>

--2vfFyZRy2guiefOI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbJvDAAoJEHZH4aRLwOS66z8P/1wA4CXNZYZ4jD9uefHpJaLe
VTsH/VvL6SV48oiBzK81GqaA5mY8wUPoGWvkiEBZJ9acpLREItRDcSNXsyhve/Y8
tuNLJT+WwlOeLrRxGOn//XRKK7TVTfl9ZYFrGhNe/b2hCvHZFmJ0swTOJ9f21cfN
w3ljsyrCEVK2C4Va0VvxrG1otvCBzqVkgBiR8nP3vh7Rd+dXvBbc03mTMrsdyxd7
b/Ns7TT/XcD736qEGJW+kjpFUcaby6alcvTs/xUFJjKEjrqYVv4b7kJKp1vEBsZ7
3BhCZxPRGtyDxNOxypfTzh57lbS09ExN46Ny6EfWu4jmbiVQoyNx8T5bxB3RiBpj
rvhuOaYe1V+6mBGBSMoHM9DcAbS4fDsvp48nDaZStcxdbtOVnbc7orOsyYQEOAlz
BNsTGANGIT6zpDnbMG7BBRTuAYa0KtdWVOXbXAYjntwezHprshkG6WS60zCBXTob
7ae492l6p+zFifHCiC2JyiTs3bCTohc3o3nLuaY5sBE1g7ToppcMBUdkfPhz/BGL
I9PHA2If3+5cvGvi1uXD+B9aOT+z6YmNTLAzsdPkxyScyEPjdEwjovxwNNnQ/1rc
OW6bPRl0PbpZdCnxGryueGLIEGvljPdGgrvehfPz+7G1dmNrqJn+mcfPepoZUk0E
cG5AMZDmTqAVgfmDatG4
=dBHj
-----END PGP SIGNATURE-----

--2vfFyZRy2guiefOI--
