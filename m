Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3CAHhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:37:46 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:58865 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CAHhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:37:45 -0500
Message-ID: <51305AC4.2030008@gentoo.org>
Date: Fri, 01 Mar 2013 08:37:40 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: Sven Joachim <svenjoac@gmx.de>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org> <1362045557-9123-1-git-send-email-jlec@gentoo.org> <874ngwhzuy.fsf@turtle.gmx.de>
In-Reply-To: <874ngwhzuy.fsf@turtle.gmx.de>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2FKVNXIUHVKBTRDNSLEMU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FKVNXIUHVKBTRDNSLEMU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 28/02/13 22:50, Sven Joachim wrote:
> On 2013-02-28 10:59 +0100, jlec@gentoo.org wrote:
>=20
>> Ncurses provides a config script (ncurses5-config) to assist finding n=
curses.
>> This patch makes use of it to detect the necessary libs for linking of=
 the
>> ncurses nconfig dialog.
>=20
> That script is not necessarily called ncurses5-config, it might also be=

> called ncurses6-config is ncurses is configured for a different ABI
> (--enable-ext-colors, --enable-ext-mouse).  Although I would suspect
> that any distribution who does that provides a compatibility symlink.
>

We don't do that, but I rechecked with building ncurses manually. You
are right. How widely spread is the usage of this options? Or is it
rather an experimental option?
What we could do is simple extending the syntax to additionally check
for the ABI version 6 config scripts. Is this an option to consider?

>>  scripts/kconfig/Makefile | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
>> index 3091794..c372976 100644
>> --- a/scripts/kconfig/Makefile
>> +++ b/scripts/kconfig/Makefile
>> @@ -216,7 +216,9 @@ HOSTCFLAGS_gconf.o	=3D `pkg-config --cflags gtk+-2=
=2E0 gmodule-2.0 libglade-2.0` \
>> =20
>>  HOSTLOADLIBES_mconf   =3D $(shell $(CONFIG_SHELL) $(check-lxdialog) -=
ldflags $(HOSTCC))
>> =20
>> -HOSTLOADLIBES_nconf	=3D -lmenu -lpanel -lncurses
>> +HOSTLOADLIBES_nconf	=3D -lmenu -lpanel
>> +HOSTLOADLIBES_nconf	+=3D $(shell    ncursesw5-config --libs 2>/dev/nu=
ll \
>> +				   || ncurses5-config --libs 2>/dev/null  )
>=20
> This will link with ncursesw, not ncurses.  Probably not what you want,=

> since nconf.h does not #include the right headers for that.
>=20

That's true, and again it would change two things at once. I will go
back to simple -lncurses as it was before.

> On Debian/Ubuntu, there's also the problem that ncursesw5-config exists=

> even if the libncursesw5-dev package is not installed, so this patch
> makes the build fail in such cases.

Will be solved when reverting as described above. But actually it smells
like a bug in the package management, doesn't it? Why are build time
config scripts shipped in runtime only packages? What is their purpose?

>=20
> Can we just call ncurses5-config and not ncursesw5-config, or are there=

> any distros who ship the latter and not the former?
>=20

I can't talk about distro wide situation, but manual building gives only
one of the two. So there might be a situation where only one of the two
is present.

It seems we have a little dilemma here. Any suggestions how to solve it?


Thanks,
Justin


------enig2FKVNXIUHVKBTRDNSLEMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEwWsUACgkQgAnW8HDreRa6aQCfSV39rQoxH2h2AFLi6v5W4BVF
WYAAnRBInUXexTBMRW5Zfo3FjAIP1daZ
=nIB/
-----END PGP SIGNATURE-----

------enig2FKVNXIUHVKBTRDNSLEMU--
