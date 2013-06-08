Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3FHJR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:17:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60991 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3FHJRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:17:53 -0400
Message-ID: <51B2F694.7010008@gentoo.org>
Date: Sat, 08 Jun 2013 05:17:08 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130522 Thunderbird/17.0.6
MIME-Version: 1.0
To: gentoo-dev@lists.gentoo.org
CC: Sergei Trofimovich <slyfox@gentoo.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        kernel@gentoo.org, gentooligan@gmail.com
Subject: Re: [gentoo-dev] dm-crypt reordering BIOs across barriers?
References: <51B2A955.4010906@gentoo.org> <20130608091114.441c5f17@sf>
In-Reply-To: <20130608091114.441c5f17@sf>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2DXMRNMLHKVXDLBPEOFES"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2DXMRNMLHKVXDLBPEOFES
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/08/2013 02:11 AM, Sergei Trofimovich wrote:
> On Fri, 07 Jun 2013 23:47:33 -0400
> Richard Yao <ryao@gentoo.org> wrote:
>=20
>> When you use dm-crypt, block IO requests to a dm-* device will invoke
>> dm_request_fn() -> map_request() -> crypt_map(). If a BIO is a write
>> barrier, crypt_map() will return DM_MAPIO_REMAPPED to map_request(),
>> which will immediately queue it to the device.
>>
>> If a few dozen IOs are queued in rapid succession with multiple write
>> barriers, all write barriers will be executed before any actual write
>> BIOs occur because the write IOs will be processed asynchronously in a=

>> work queue. Since the barriers will be long gone by the time the write=

>> IOs are queued, they can be queued in any order.
>>
>> Am I misunderstanding this or is dm-crypt ignoring proper write barrie=
r
>> semantics?
>>
> http://www.saout.de/pipermail/dm-crypt/2012-April/002441.html
> http://lwn.net/Articles/400541/
>=20

It might be worth stating that I thought flush was a synonym for
barrier. It still looks like there is an issue, despite my incorrect
terminology.


------enig2DXMRNMLHKVXDLBPEOFES
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRsvacAAoJECDuEZm+6Exk9q8P/1RtjD9/vqXi5+y+m08gt2Wu
Kav5QBNpltNgo2trSLlr+HMyO0+Wv2Ibjnde1/AoNhJhIHcG2MHKObUfX3KykVwN
lDn5YZynujLxJSMCqkYG16WTuvt+SkimbBNnZQyXWmtk3IxHqjFBSArxcuR5+YhH
Ctl1wQHQXnLjtGmoXlGsD5Lz7GJsGNiMfoMqqYFeAsNL9nd/LjtvzxOeC81QYXBA
HZbK/9UXxsBxrxdY8LtPHFn/eYA3DjmPXeGy9S4OLwsxnIHX7JbpOMzLsIWZUSbo
4BJV1q+YrdI6y4YyZTv/kNrJ7p+60desmYy2oc+Fd1MbMqkIT3S20gjt5KdczsUx
uxmpbyovVSqV3tesqTMTYSaGu/6wkKXsljNx4+9+3+/RMeJ4s5aIXw2u6DaftUhT
RGXYcIdBgSGRCIMq4uzIq+GRtEF5q8Cy3kGPfNe2mj568Qs7Uzr156wzqGu6zG+K
IKg+LhwRpYSPV2K9LIuzfiemzvimBRrgu8HnNdIaCaqDubdyiujtiRIwFT/QLH/c
0Q/sT6qrDXqTDQAXkeMdI/Cwxc/2KfETUSv+P624eHRd7HCuu4CpISmMy8WG46e3
bM3DMgQQeGW4D4Rk58iCNuPjqzOLpk8scjFmhUJtwyjclF+ebJhbNGVgd8ET8/ff
ZYtnIgHusUQ/9XgzLkYA
=4E3r
-----END PGP SIGNATURE-----

------enig2DXMRNMLHKVXDLBPEOFES--
