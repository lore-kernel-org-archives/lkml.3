Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3F0Q6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:58:35 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:44090 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3F0Q6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:58:34 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2013 12:58:33 EDT
Message-ID: <51CC6CAE.6070401@gentoo.org>
Date: Thu, 27 Jun 2013 11:47:42 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130520 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-devel@vger.kernel.org,
        mjg59@srcf.ucam.org, torvalds@linux-foundation.org
CC: kernel@gentoo.org, hardened-kernel@gentoo.org, corsac@debian.org
Subject: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when booting
 with mem=300M
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2UPCERNTLQCXCKTWSPJRN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UPCERNTLQCXCKTWSPJRN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

There is an early boot failure with linux-3.[9,10].??? when booting
using uefi on low memory systems.

This seems like it might be hardware specific, I am running on a Lenovo
T520, running bios version 1.42, firmware rev 1.36.

This seems to be limited to x86_64, as i386 does boot.

I build my initram into the kernel image, the following boot line
triggers the issue.  The issue causes no kernel messages to be printed
to screen (looks like the kernel isn't loading at all to my untrained eye=
s).

linux	/kernel-3.9.7 mem=3D300M

the following link contains kernel images and vmlinux for both amd64 and
the referenced kernel versions
http://dev.gentoo.org/~prometheanfire/bugs/471626/

we are tracking the bug here (keep in mind, this is NOT a pax bug)
https://bugs.gentoo.org/show_bug.cgi?id=3D471626

I have tested the following combinations.
amd64 - 300M - 3.9.7    -    bug hit
amd64 - 300M - 3.10-rc7 -    big hit
amd64 - 16G  - 3.9.7    -    bug not hit
amd64 - 16G  - 3.10-rc7 -    bug not hit
i386  - 300M - 3.9.7    -    bug not hit
i386  - 300M - 3.10-rc7 -    other bug possibly hit
i386  - 16G  - 3.9.7    -    bug not hit
i386  - 16G  - 3.10-rc7 -    other bug possibly hit

the pictures taken for the other possible bug hit are located at
http://goo.gl/741ub


--=20
-- Matthew Thode (prometheanfire)


------enig2UPCERNTLQCXCKTWSPJRN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzGy/AAoJECRx6z5ArFrDFjkP/jFRdlVKvtx5wFpd4/JDsafr
Hvk3p6+yKHgVlYUYxAyhXbfoAptkEmF9XVh2zmXjEk5AkA0WS1AJerqe1rcsrxdK
FWGwCkC216WLW0tSWXgAsMqDis2pOX3aFMta09yoWbWIw/an39QqfjEr3AX4sWGs
CLTTdned8zOZQliyzuL2uG23FOp9Is++ns3So7Txo4646X2b7GX3g7Pe7PghVIX+
6Tg/UNTmXueW5YY5XAWHeadw6TC3340PAijqbQE1opiPJGHUd+hEdbbJTZ0RGall
QxQb5Jqvvd6VmldzHSjUH5CZsZEEHgIdVgRtkULYZi3eSssc+wbnpbTBxWw6qAIq
rRdrNIZfbsoC5l4IbShwZrN3pgoIm4f84rwOzWXBEuzkIdauhVSou+vObfHzgnkF
qYT9W8hvc376ZHhEDGzAOALziCEbNdjmKIhyU6Xa3ItjMjPdGOZ5f76nEn7S5oMn
0ZXG/ERuoqRhV1P+rE5o1sN87hHN8Hy/zseIiD1J6ibQstZP3yq7cYSDxvKwPMtq
/B+MKvbR80q4N6aeHhtJAhQDkAbHk8vu/7+vtUnebC+2akL4k95XtmntKPROZeQm
tlVwhioKyMnc/nGasD6pfZVaGjqO1x7d4y8tCZAqtV6dxjGQ028g0quZwP0bqlHJ
wR4x5eb0H+duf3n9ceqR
=0lS/
-----END PGP SIGNATURE-----

------enig2UPCERNTLQCXCKTWSPJRN--
