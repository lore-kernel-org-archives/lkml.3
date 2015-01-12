Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbbALAXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:23:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60454 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbbALAXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:23:17 -0500
Message-ID: <1421022180.19708.37.camel@decadent.org.uk>
Subject: [stable] ARM: 8108/1: mm: Introduce {pte,pmd}_isset and
 {pte,pmd}_isclear
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Steve Capper <steve.capper@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Hou Pengyang <houpengyang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Mon, 12 Jan 2015 00:23:00 +0000
In-Reply-To: <1418653622-21105-72-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	 <1418653622-21105-72-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Q/bkr3aZ086FFlWBfieW"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q/bkr3aZ086FFlWBfieW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-12-15 at 14:25 +0000, Luis Henriques wrote:
> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> ------------------
>=20
> From: Steven Capper <steve.capper@linaro.org>
>=20
> commit f2950706871c4b6e8c0f0d7c3f62d35930b8de63 upstream.
>=20
> Long descriptors on ARM are 64 bits, and some pte functions such as
> pte_dirty return a bitwise-and of a flag with the pte value. If the
> flag to be tested resides in the upper 32 bits of the pte, then we run
> into the danger of the result being dropped if downcast.
>=20
> For example:
> 	gather_stats(page, md, pte_dirty(*pte), 1);
> where pte_dirty(*pte) is downcast to an int.
>=20
> This patch introduces a new macro pte_isset which performs the bitwise
> and, then performs a double logical invert (where needed) to ensure
> predictable downcasting. The logical inverse pte_isclear is also
> introduced.
>=20
> Equivalent pmd functions for Transparent HugePages have also been
> added.
>=20
> Signed-off-by: Steve Capper <steve.capper@linaro.org>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Hou Pengyang <houpengyang@huawei.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[...]

This has only been applied to 3.16 so far, but it appears to be suitable
for every branch from 3.4 onwards as ARM LPAE was introduced in 3.3.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-Q/bkr3aZ086FFlWBfieW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLMT6ee/yOyVhhEJAQqTHxAAl/Ao7eCChY5K6Yim85fwZ7V9eHN0KEU7
OxTGzhVssLTXbJLrJzA9Q1HwV7LK7+RYmOXAY/oq8Xkei3+ZLvIC4CNPmkLlDJLf
Tnh9UpKRIug0rjetdtl/7sgNf9jW4oogvBLmZGDXqekNxcvyC0RYWZ6y5vx47h7f
TPH3iqaORSZPfEJElC88ZEc67w6fEgJoAmyAPrxpH6JUj7KyFvsHNQRUeo58JtNH
4vt4JGECLh3VJQ6/8ZO3Z6J90SoXMRfYTwQ0VYD9pjl0NgeOpw7ajpRkObUFEgjS
biODIG8kunSRto/sSPbkrSiCv4LVmrTX+VavFad1HvNNmZ/gMEiaMZ4IlyF/eDIU
ehAQqmdi40WqsjjQye9aeV6e2/PEQF8Zi5wCwoaI5gAkW4U1BDapIsvTZmDLkcrh
bMVzc+cYaTp2f1j81dF73Ogue8GDJt2Jyf0MvV47GJWNLZGgVR8PnleZzlyNFmvC
MkaPmOldnYIpzwH+Pm7vbHGQ51G+gKGS743UstAmobQUt203A9pXL1ezaM9TZfxF
EczOvUTaNMnp5WQ2iBLzU6Zy5YH2XB+7FNDPIu87lN6zOSgDk4EDPmTBFCIbWQS8
wK1t70g6j06f+JymL4HkyJZoetRvkkewPy3FlTDGm8f8D1rP5osRvW9HN9Vg93qE
IFszCcqtaaY=
=er4t
-----END PGP SIGNATURE-----

--=-Q/bkr3aZ086FFlWBfieW--
