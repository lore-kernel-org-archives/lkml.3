Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaASJb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 04:31:59 -0500
Received: from s3.neomailbox.net ([178.209.62.157]:9146 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaASJby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 04:31:54 -0500
Message-ID: <52DB9B39.9090502@meshcoding.com>
Date: Sun, 19 Jan 2014 10:30:33 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chen Gang <gang.chen.5i5j@gmail.com>, David Miller <davem@davemloft.net>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de,
        b.a.t.m.a.n@lists.open-mesh.org, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-metag@vger.kernel.org
Subject: Re: [PATCH linux-next] net: batman-adv: use "__packed __aligned(2)"
 for each structure instead of "__packed(2)" region
References: <52DA65F4.5070501@gmail.com> <52DA7B9E.4040202@meshcoding.com> <4915262.qEFumRrH4p@radagast>
In-Reply-To: <4915262.qEFumRrH4p@radagast>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dwlJkL9EKIhSkSimllsEG6nT9F2A7dCAa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dwlJkL9EKIhSkSimllsEG6nT9F2A7dCAa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19/01/14 02:10, James Hogan wrote:
>=20
> It appears that the following gcc patch adds support for #pragma pack:
> http://gcc.gnu.org/ml/gcc-patches/2006-10/msg01115.html
>=20
> I gave it a quick spin on metag gcc (which is unfortunately stuck on an=
 old=20
> version) and it seems to fix my simple test case so that #pragma pack(2=
)=20
> becomes equivalent to __packed __aligned(2) (for sizeof and __alignof__=
).
>=20

Then I personally think that it is better to fix metag gcc instead of
changing the kernel.

Actually there are many different spots where "#pragma pack" is used.
batman-adv is just the only one having compile time checks for structure
sizes.

>=20
> However, the __packed and __aligned are linux specific macros to abstra=
ct=20
> compiler details, whereas #pragma pack appears to be a compiler-specifi=
c WIN32=20
> style equivalent to GCC's __attribute__((packed)) and=20
> __attribute__((aligned(2))) (these are what __packed and __aligned use =
in=20
> compiler-gcc.h).
>=20
> Therefore I believe using the Linux abstractions is still more correct =
here.

If you really think so, I'd suggest to grep in the kernel and catch all
the other occurrences of "#pragma pack" and change them all (assuming
that using __attribute__((aligned(2))) is the way to go).

Cheers,


--=20
Antonio Quartulli


--dwlJkL9EKIhSkSimllsEG6nT9F2A7dCAa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS25s8AAoJEEKTMo6mOh1VXCAP/A8qzEMtBis4jfr4qSBamy8P
tGGhZYRnn8WnH+YPndVTmfXtao7A+lTk1LF1cmMNbk/Tsp6e4sAoIolB2xF4/kHh
SDAwA4BOZfy0SyVnaDEHoJgfN9pBsGaxaogqcYRwvRpGGXbcI/QgU3nGB01MSDjm
lfcUo+kPP0JLtAbGfqUYnxhWjhFauq12Csaf7eZ2yT3g8RmxliCCSD+YA4gMWfAl
htSnBfd5mEb8FlGc8hfmON/zk9oiLkZ3doaISwbrEj1Bp5E6dr/ExkVrQmanV9Ln
WbidBglTq0heM8Ym7HVkXdhSMNP2FWZyU/IC+wmwXAmL9YdYgLIaySfu7Wk/B/us
tBqTBbEezUomOunLL0j2AQktlDB42AqSI390o70GgT9qgMenrMPXK4EG1LnUsby5
RitJPvGgu2yKqIp9CYZ1RJYBig1Aom+aJNQo3wdACeqEIFpp3rUYay+eKjBCFCj5
SzbJM7wYpmrRC1VnwL7WCyJRFqSVqAhuRF74euM9mrO76C5jBrTniwB7FQaf0+Ja
QpMRSBr3rvXDnX9Wt5YECDOFdmR+QGATVbZG0T4ot06gB69ebHwbQKo+09K4CDpo
vo1WU/pmd2E7zNTDlrJ1zgTTiBWg9AQ3pWZHbcHf7NOuJn1yThgLMD+wSVBu4mdQ
ESx1DyVwg93m8HP0a6GL
=JR3W
-----END PGP SIGNATURE-----

--dwlJkL9EKIhSkSimllsEG6nT9F2A7dCAa--
