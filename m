Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaDHGuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:50:10 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:57603 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaDHGuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:50:07 -0400
Date: Tue, 8 Apr 2014 08:49:53 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
Message-ID: <20140408064953.GH3339@pcnci.linuxbox.cz>
References: <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
 <20140402135812.GI3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB112D@HASMSX106.ger.corp.intel.com>
 <20140402143635.GA4410@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
 <20140407132530.GF3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7512@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ohhUr6qMC+8zx6A6"
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFB7512@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on proxybox by F-Secure antivirus, database version 2014-04-08_02
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ohhUr6qMC+8zx6A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Tomas,

> I'm not sure how this is possible that this is failing for you
>=20
> if ((0xa301 & 0x600) =3D=3D 0x200)
> 	goto no_mei;=20
> so this is okay, the driver should not bind
>=20
> How the patch worked for you before this test? =20
>=20
> Sorry for asking but can you please double check your compilation setup.=
=20

You're right of course :-(

I tried rebuilding rpm again now, and patch spits following:

Hunk #1 succeeded at 105 (offset -2 lines).
patch unexpectedly ends in middle of line

it's bad rpm build didn't abort at this point, but apparently
this is patch's fault:

[root@dev6 linux-3.10]# cat /tmp/mei/1 | patch -sp1
patch unexpectedly ends in middle of line
[root@dev6 linux-3.10]# echo $?
0

:-(

well, this sucks, I really wouldn't expect that kind of bug in such widely
used program as patch :(

I'll report that.

(btw this error was caused by one whitespace character at last line of patc=
h)

anyways, You can certainly forgot about that, it was my fault :(

sorry about that

nik


> =20
> Thanks
> Tomas
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--ohhUr6qMC+8zx6A6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlNDnBEACgkQ3xdJJrLygV5koQCgs3f5ze+cfWevn7yAPUkqtMxr
fz4AoNyz0EUuiEjya9PtYlQdJnzgqYsL
=B0zC
-----END PGP SIGNATURE-----

--ohhUr6qMC+8zx6A6--
