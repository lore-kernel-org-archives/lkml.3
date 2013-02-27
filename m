Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab3B0OaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:30:25 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:53005 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759975Ab3B0OaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:30:23 -0500
Message-ID: <512E186F.6090507@gentoo.org>
Date: Wed, 27 Feb 2013 15:30:07 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use config scripts to detect ncurses libs for, menuconfig/nconfig
 dialogs
References: <512A36BB.9070309@gentoo.org> <201302251930.22293.yann.morin.1998@free.fr> <512BCA76.6080601@gentoo.org> <201302252153.39465.yann.morin.1998@free.fr>
In-Reply-To: <201302252153.39465.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2IPNTDIXUNMBLPJERUVWT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2IPNTDIXUNMBLPJERUVWT
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 25/02/13 21:53, Yann E. MORIN wrote:
>>> Do you know of a distribution where this is the case, so I can test?

Fedora is also building with --with-termlib but they are using a ld
script to workaround the linking problem. I talked to our (Gentoo Linux)
base-system maintainers but they refused to apply this, instead they
said the consuming packages should be fixed. This is now an ongoing effor=
t.

> But I'll see at installing a Gentoo (if that's not too complex) in a
> VM to do the checks (can you confirm that Gentoo by default configures
> ncurses with --with-termlib ?).
>=20

It is not the "default" configuration in a classic sense, because it
will only build with that option if a consuming package requests this.

Here the receipt for generic reproduction:

* Get yourself a copy of our live dvd
(http://gentoo.inode.at//releases/x86/20121221/)
* Kick a vm or boot from the dvd (Make sure you have enough RAM, because
you will compile ncurses on it and place the git checkout there.)
* Get a terminal and switch to root
* Update the package db by running: emerge --sync
* Rebuild ncurses with:
ACCEPT_KEYWORDS=3D"~x86" USE=3D"tinfo" emerge -va1 ncurses
Important here that "tinfo" is marked as changing USE (colored green)
* Switch to ld.gold with "binutils-config --linker ld.gold" (make sure
that it worked out -> ld -v)
* git clone the kernel and do your testing.


Justin


------enig2IPNTDIXUNMBLPJERUVWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEuGG8ACgkQgAnW8HDreRZRAQCfXKHb4IHN5/vKMc6fFIbiZ7xT
VZ4AnR4jdTHd0bn9KghYnK400AUHke0/
=66a6
-----END PGP SIGNATURE-----

------enig2IPNTDIXUNMBLPJERUVWT--
