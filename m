Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaIQL0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:26:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48221 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbaIQL0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:26:04 -0400
Message-ID: <1410953151.3040.101.camel@decadent.org.uk>
Subject: Re: [PATCH 3.13 044/187] x86_64/entry/xen: Do not invoke espfix64
 on Xen
From: Ben Hutchings <ben@decadent.org.uk>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 17 Sep 2014 12:25:51 +0100
In-Reply-To: <1410818997-9432-45-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
	 <1410818997-9432-45-git-send-email-kamal@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ehnw/tIPYlBKT9aXGGHj"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:cde6:1b3a:bf85:5ca0
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ehnw/tIPYlBKT9aXGGHj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-15 at 15:07 -0700, Kamal Mostafa wrote:
> 3.13.11.7 -stable review patch.  If anyone has any objections, please let=
 me know.
>=20
> ------------------
>=20
> From: Andy Lutomirski <luto@amacapital.net>
>=20
> commit 7209a75d2009dbf7745e2fd354abf25c3deb3ca3 upstream.
>=20
> This moves the espfix64 logic into native_iret.  To make this work,
> it gets rid of the native patch for INTERRUPT_RETURN:
> INTERRUPT_RETURN on native kernels is now 'jmp native_iret'.
>=20
> This changes the 16-bit SS behavior on Xen from OOPSing to leaking
> some bits of the Xen hypervisor's RSP (I think).
>=20
> [ hpa: this is a nonzero cost on native, but probably not enough to
>   measure. Xen needs to fix this in their own code, probably doing
>   something equivalent to espfix64. ]
>=20
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Link: http://lkml.kernel.org/r/7b8f1d8ef6597cb16ae004a43c56980a7de3cf94.1=
406129132.git.luto@amacapital.net
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
[...]

There's another fix related to espfix on Xen, commit 8762e5092828
("x86/espfix/xen: Fix allocation of pages for paravirt page tables").
But I'm not sure whether it's actually needed after this.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-Ehnw/tIPYlBKT9aXGGHj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBlvxOe/yOyVhhEJAQoMpQ//a5rwP0sy6W4fib+y0LV1U0yJd1zRumlw
7PuMAQiB/T5ana7yUVu+hhp6QlgqE0p24ZfHUX6e7lbvSwOgYpDEPzLjSLt6me9a
wTdYIubzk6BFjJqa1Vf0OXT/JBS3ThuGFL+a3aXFbJNqiwhT44Sz3a69YPUcRTyv
znaqHA8oNkeuJ91VvQ7GIx7DjKUjQBxWiDge2uP4U5Veq8u59TB8Wp4uYOU0VW+w
L3CgptDSwwAZJJlNKMrmJvyUSc7bRwSyNHvgQtzPyHKAYy9jI8q+s4KlKRFRPTGz
vtZncQQ2fmP6pVvQK+Virqfw8hhpU5pHqzLh5ekW/aSN3QFXpKkrHyfvAjplgaan
Rr0qk89sUgZvwlV8aJ35uhS/QYv7xDWcLRVadSPuso+1ZZdiBDXommdUsoxmpki0
Ezb0ZkUQGsffMGH/rkv1UYZkUpLAt6uInm0JVcHFlMq2iauy6Baco9fbAFtrRRmf
KFtbWpWPt4AspHS7DkiEG4bzwO/sW66db29XAMywJN79mUogOc/Q1Xaoebhtg3EA
pNoRtPNvLjJ3NhRL0yGiGpHMib6h9iy8AK+RP6MfbX77U3Yftp3+FilF28SuJieT
zV2KoiPJ3SeV0rlteXwMSs4cAVitUYPipWTX4Pzy1WA/OaEqoaz/esoA3z/UxCCa
t08o+CNlPMY=
=HU/x
-----END PGP SIGNATURE-----

--=-Ehnw/tIPYlBKT9aXGGHj--
