Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbaDWRnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:43:55 -0400
Received: from mout.gmx.net ([212.227.17.22]:49156 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbaDWRnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:43:53 -0400
Date: Wed, 23 Apr 2014 19:43:35 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Marek Vasut <marex@denx.de>
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if
 aad_size is too big
Message-ID: <20140423194335.2d72d7a4@spike>
In-Reply-To: <201404230133.05256.marex@denx.de>
References: <20140421204439.7999f1c6@spike>
	<20140421204559.75b8aa71@spike>
	<201404230133.05256.marex@denx.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//SuvCvuci+K/glLkCjY/wjv"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:WhPFJZKPJGQepypgH8cynSDluB5z9TiZ+jIuEmxEF/8OL/AHY3I
 llIiqkDG7BHo0DvEp5jV0IBGaEoaqJTQh3jE5xH+wWvLHV6vz9C5uxXs/haIB8+KiI6KGEM
 hqmz1YOEDA1lCaU61iK0bUarixtPtj/fH4VhoBYB/b8wCM6ZW1Y57eszp/4lzDNb8ETvPUK
 4YZrWL/4Qytn1pR0XL+sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//SuvCvuci+K/glLkCjY/wjv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 01:33:05 +0200, Marek Vasut <marex@denx.de> wrote:
> On Monday, April 21, 2014 at 08:45:59 PM, Christian Engelmayer wrote:
> > +	if (aad_size >=3D PAGE_SIZE) {
>=20
> On an unrelated note ... Won't if (aad_size > PAGE_SIZE) be sufficient he=
re?

=46rom what I have seen how the buffers are allocated via __get_free_page() I
thought so too. However, as it previously read

	if (aad_size < PAGE_SIZE)
		memset(assoc, 0xff, aad_size);
	else {

my intention was simply to make the modification so that the bug is address=
ed
without introducing an additional change.

Regards,
Christian

--Sig_//SuvCvuci+K/glLkCjY/wjv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV/vHAAoJEKssnEpaPQKEbvAP/R0pH9/JW+ljtvpi+thy7DnM
KJ2yCr/OTDMuSvbvcPyeXxaaTfd/thDZL8J41tBrlb60fx/u5ncHCikOm/0DeEET
DNCrRf57Ql/GoVhhHSfTEGlQ2dwsVM5y8gxh8O9C3WhWTHFt7spp0/ihaLqKRlQA
ZJdOfgd1Cn6fi+K/5cI0NBjBHkYIMDgtFPyrvDz1gG0sK0T2M+p0K/gouz3D78te
J54g+BmPNgFKOS/0rGQxlcPYdoaCosBrBcMVVobM/gfB+zpcWUH4wu0+FuktxNdH
O474xrfiwVzLx9O/bumstBgnhUeUaaVPEuQMy1mFMnWVKiT2GCW6FSLyD6Qa9Qfe
/7gVQC7d4Rbddp5nljkANUf/b3jNCSTiaQ6S5AbkXTUDLKLPs+pTTRKYnRuv0SXa
wECbRPd4JMK+D5z6YbrtgDge8yaI8sm97ycJ/eMjDAtnWhK48rE2uK/LlLVGvzKf
GtT0oQ0BRUY7BA77DOgIXptg+1Wv1zvfQfF1BpSHzab8zJ4hZPVT7Npv76N+0I2y
0KxTqD0BKq+bRHr2k+Vl4Nwak/1ajqZUTdosz2j0O/MV2m4H5bEp89UztrSw0vHC
VFq6XE3GKh989wKfUxV5Na3qsJsXxyMKV1KTabWxivbzk1+G+a1NR+aSqD5lg61b
A0tf/fKNz15EZmP8oM5t
=yzZ/
-----END PGP SIGNATURE-----

--Sig_//SuvCvuci+K/glLkCjY/wjv--
