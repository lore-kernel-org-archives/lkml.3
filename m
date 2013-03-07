Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab3CGJrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:47:25 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:48584 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3CGJrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:47:22 -0500
Message-ID: <51386223.3020901@gentoo.org>
Date: Thu, 07 Mar 2013 10:47:15 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Final versions of ncurses libs detection patches
References: <Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs> <1362574922-4799-1-git-send-email-jlec@gentoo.org> <201303062223.24541.yann.morin.1998@free.fr>
In-Reply-To: <201303062223.24541.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2CKCXLSEHGOJELXQNGUVF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2CKCXLSEHGOJELXQNGUVF
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 06/03/13 22:23, Yann E. MORIN wrote:
> On Ubuntu Quantal, ncurses is indeed compiled with tinfo as a separate
> lib, but these two patches are not needed, because libncurses has prope=
r
> (NEEDED) on libtinfo:
>=20
>   $ readelf -d /lib/x86_64-linux-gnu/libncurses.so.5.9 |grep tinfo
>   0x0000000000000001 (NEEDED)             Shared library: [libtinfo.so.=
5]

Hi Yann,

Same here

$ scanelf -n /lib//libncurses.so.5.9
 TYPE   NEEDED FILE
ET_DYN libc.so.6,libdl.so.2,libtinfo.so.5 /lib//libncurses.so.5.9


But why it works on ubuntu and debian is that

/lib/lib/x86_64-linux-gnu/libncurses.so.5.9

is a ld script with following content

INPUT(libncurses.so.9 -ltinfo)

It instructs the linker at link time to add additionally -ltinfo.

On Gentoo, the base-system maintainers refuse to do this (I would agree
if you call it a bug on our side), but I am not allowed to touch those
packages.

Luckily ncurses provides the config scripts and the pkg-config modules
to do sane linking. This should be done if possible regardless the
situation on a single distributions.

>=20
> If I just configure ncurses with:
>   $ ./configure --with-termlib --with-shared --without-normal && make
>   $ readelf -d lib/libncurses.so.5.9 |grep tinfo
>   0x0000000000000001 (NEEDED)             Shared library: [libtinfo.so.=
5]
>=20
> I wonder how you configured your ncurses.

=2E/configure --prefix=3D/usr --build=3Dx86_64-pc-linux-gnu
--host=3Dx86_64-pc-linux-gnu --mandir=3D/usr/share/man
--infodir=3D/usr/share/info --datadir=3D/usr/share --sysconfdir=3D/etc
--localstatedir=3D/var/lib --libdir=3D/usr/lib64
--with-terminfo-dirs=3D/etc/terminfo:/usr/share/terminfo --with-shared
--without-hashed-db --without-ada --with-cxx --with-cxx-binding
--without-debug --without-profile --with-gpm --disable-termcap
--enable-symlinks --with-rcs-ids --with-manpage-format=3Dnormal
--enable-const --enable-colorfgbg --enable-echo --enable-pc-files
--enable-warnings --without-assertions --disable-leaks
--without-expanded --with-macros --without-trace --with-termlib
--with-chtype=3Dlong --with-mmask-t=3Dlong --disable-ext-colors
--disable-ext-mouse --without-pthread --without-reentrant

>=20
> Thanks for staying around during the iterations.

No problem, this is how it works. Thanks for your suggestions,

Justin



------enig2CKCXLSEHGOJELXQNGUVF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlE4YiQACgkQgAnW8HDreRabTQCeMEKmuZPgLO712KEuyZBgsedg
mvoAnR2QmfqnRnysiREtCEaGsU6YHeNa
=SnNw
-----END PGP SIGNATURE-----

------enig2CKCXLSEHGOJELXQNGUVF--
