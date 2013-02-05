Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3BEXSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:18:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52452 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400Ab3BEXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:18:34 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
Date: Tue, 5 Feb 2013 18:18:28 -0500
User-Agent: KMail/1.13.7 (Linux/3.7.1; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        uclinux-dist-devel@blackfin.uclinux.org, Jonas <jonas.bonn@gmail.com>
References: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com> <201302030117.26295.vapier@gentoo.org> <5110DFEF.8000505@imgtec.com>
In-Reply-To: <5110DFEF.8000505@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1870282.lNtgSctV19";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302051818.30349.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1870282.lNtgSctV19
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 05 February 2013 05:33:19 James Hogan wrote:
> On 03/02/13 06:17, Mike Frysinger wrote:
> > On Thursday 31 January 2013 04:41:43 James Hogan wrote:
> >> --- a/Makefile
> >> +++ b/Makefile
> >>=20
> >> +ifneq ($(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX)),)
> >> +  depmod_args =3D -P $(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> >> +endif
> >> ...
> >>  # Run depmod only if we have System.map and depmod is executable
> >>  quiet_cmd_depmod =3D DEPMOD  $(KERNELRELEASE)
> >>        cmd_depmod =3D $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh
> >>        $(DEPMOD) \
> >> -                   $(KERNELRELEASE)
> >> +                   $(KERNELRELEASE) $(depmod_args)
> >=20
> > scripts/Makefile.lib just does:
> > 	ifdef CONFIG_SYMBOL_PREFIX
> >=20
> > so you should do the same
>=20
> arch/openrisc/Kconfig now defines SYMBOL_PREFIX as "", so this isn't
> sufficient (arguably it probably shouldn't be defined empty like that?)

yes, that should simply be deleted

> > that said, cmd_depmod is just a shell command.  and you're running
> > another script helper (depmod.sh).  how about passing it unconditionally
> > ?
> >=20
> > 	cmd_depmod =3D ... -P "$(CONFIG_SYMBOL_PREFIX)"
> >=20
> > since the default will be "no prefix", using -P "" is the same thing.
>=20
> Yep, I could do this, but depmod.sh would need modifying to drop it if
> the prefix is empty, otherwise you get the following from depmod:
> FATAL: -P only takes a single char
>=20
> I don't mind adding that, but what do you think?

i mean depmod.sh should only pass -P to depmod if the arg is non-empty
=2Dmike

--nextPart1870282.lNtgSctV19
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJREZNGAAoJEEFjO5/oN/WBlpkQAK1bun7GNczz/+siKuXIs4+k
eVBvUmRJYxpa30mhBhY9R5QrbQjkGm5bTAzSHRwjI6lBO5/ADD6Jh3/6QeNrDii7
MPkB9Pk9Q8sr1NkQcjwir2yhF1WGsVn5pJd2eRHvFGiMHLzaKEcZfKilY33ThMpG
PGLxnUdw7bgXBmse4pDl8LqDD47ICv8r5S1LAY76a6420VCnZHZzD25OMpvRA7SH
aQME6nOZJukTeDKRuQQLr2opxpy+0lE49jx9ZN0jcwlLPXKLXpH7zf4+TIwFy6Dj
e0cPe64DCGFWcArPRYFGW3bzeUdXhD5QdehtEjP4w66YGZwqOik6MXM1+HuQizLt
uGu8NsyJBlrojByY4KGHlaIRiVvBrtw8XVThyCgD2lEhMTKrrf4THHhTUkrqXyyc
XpLZxWQ7vsfMmspiufnhb5pkbSj2oMHCpoYngi/eCc5Uh6FIaPPMLBX/EMH/HNdL
MkdkIM8vDvE0hfSfxPioRDdlY5p2xxcMn6f3tEXD+ZAKxeim8o9qC/Zs2bwzP9JX
8zAouKKHBvGcdCrF9pjtZ4hqosgr5eEl+9R/IN7vtFUXpRUnG5Gr+WAMAb3FpbHB
MGXTdgHc4EN/WpDpfe0qIWWAZxytOz8rW1OhejYLtP4+3rOXiPDOLWSO73bcxMRM
serlIwgb9E2lmYoYMn9v
=Xrt7
-----END PGP SIGNATURE-----

--nextPart1870282.lNtgSctV19--
