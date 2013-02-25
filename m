Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3BYUdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:33:02 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43329 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab3BYUc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:32:59 -0500
Message-ID: <512BCA76.6080601@gentoo.org>
Date: Mon, 25 Feb 2013 21:32:54 +0100
From: Justin <jlec@gentoo.org>
Reply-To: jlec@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130222 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use config scripts to detect ncurses libs for, menuconfig/nconfig
 dialogs
References: <512A36BB.9070309@gentoo.org> <201302251930.22293.yann.morin.1998@free.fr>
In-Reply-To: <201302251930.22293.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2XQANFQHVMBDXSMXSHCCS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XQANFQHVMBDXSMXSHCCS
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 25.02.2013 19:30, Yann E. MORIN wrote:
> Justin, All,
>=20
> On Sunday 24 February 2013 Justin wrote:
>> when ncurses is build with --with-termlib several symbols are moved to=
 a
>> seperate terminfo library (libtinfo.so). Current Kernel buildsystem
>> results in a build error with menuconfig and nconfig dialogs.
>=20
> Do you know of a distribution where this is the case, so I can test?

This is using Gentoo Linux testing with ld.gold. But I assume you will
get the same result using any distro with gold.

>=20
> I think I would prefer spearate patches, one for mconf, one for nconf.

I will send new patches in a separate mail, so that we can do the review
there.

>>
>> -HOSTLOADLIBES_nconf	=3D -lmenu -lpanel -lncurses
>> +HOSTLOADLIBES_nconf	=3D `pkg-config --libs menu panel ncurses`
>=20
> On my distro (Debian stable) ncurses has no pkg-config file installed, =
so
> this fails.

I already feared that. Will convert it to ncurses5-config which should
be available on any recent distro.


>> -			fi
>> +	if type -p ncurses5-config &> /dev/null ; then
>                                    ^^
> This is a bashism, and will not work on purely POSIX shells.
> Please use: >/dev/null 2>&1

Thanks for noting this.

>> +		exit 0
>=20
> (nit-picking) I'd prefer you be consistent with existing code which jus=
t
> calls 'exit' without a number.

I added it to be more precise on the return value. But I don't care as
simple exit should result in the same.

Thanks for the review.


------enig2XQANFQHVMBDXSMXSHCCS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlErynYACgkQgAnW8HDreRZ8eACeOfn6O+RVa/yp1uX7DrQRqKxj
nCgAoInNT90cabzVndlNvP8fJf1tHP6K
=fBvS
-----END PGP SIGNATURE-----

------enig2XQANFQHVMBDXSMXSHCCS--
