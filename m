Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3BYK66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:58:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52785 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3BYK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:58:56 -0500
Date: Mon, 25 Feb 2013 21:58:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the kbuild tree
Message-Id: <20130225215845.c0ec14a467aa6fe8e788e80e@canb.auug.org.au>
In-Reply-To: <512B3CD8.5070802@suse.cz>
References: <20130225105650.6b89477b11c895ba99a666fe@canb.auug.org.au>
	<512B3CD8.5070802@suse.cz>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Feb_2013_21_58_45_+1100_BTNemRO8t10dQgWh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2013_21_58_45_+1100_BTNemRO8t10dQgWh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Mon, 25 Feb 2013 11:28:40 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
> On 25.2.2013 00:56, Stephen Rothwell wrote:
> >=20
> > After merging the kbuild tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > scripts/link-vmlinux.sh: line 135: .: .config: file not found
> >=20
> > Presumably caused by commit 03b25b47e0f4 ("scripts/link-vmlinux.sh:
> > source variables from KCONFIG_CONFIG").
>=20
> Strange, I did a couple of testbuilds before pushing the new branch.
> Wild guess: what version of what shell are you using on the
> buildmachine? It is probably the missing ./ that makes the difference.

I am using a Debian Testing machine (its not quite up to date):

----------------------------------------------------------------------
$ ls -l /bin/sh
lrwxrwxrwx 1 root root 4 Jul  7  2010 /bin/sh -> bash
$ bash --version
GNU bash, version 4.2.20(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.htm=
l>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
----------------------------------------------------------------------

I am also using a cross compiler and O=3D on the command line if that
matters.  '.' is not in my path and .config is not executable.  If I cd
to the object directory, then ". .config" works fine.

But bash in sh mode does not work:

$ cat xtst.sh
#!/bin/sh

cd /scratch/sfr/powerpc_ppc64_defconfig

. .config

exit 0
$ ./xtst.sh
./xtst.sh: line 5: .: .config: file not found
$ ls -l /scratch/sfr/powerpc_ppc64_defconfig/.config
-rw-r--r-- 1 sfr users 79005 Feb 25 15:45 /scratch/sfr/powerpc_ppc64_defcon=
fig/.config

Changing the ". .config" to ". ./.config" makes it work.

Anything else?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Feb_2013_21_58_45_+1100_BTNemRO8t10dQgWh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRK0PlAAoJEECxmPOUX5FEX+MP/2cTnvp9tM/UI451o3iaUI9e
YfXxH35YlMRdi3TjmNWPBlheKNrTBqjMbCd8gi6vHtu+I35eoeS7jOlXXTITtKYb
l+YppuzEc0hW2ZyslKmzM0wGaUUtdy0YlfceaJrTFERE+ni5J96dHkueOD8pKo+w
ed787Qb7aPD0aOeZ5IdUoPgTOuUjXGmnVidx2vJ/jL8CsWTq8sEoxjPF38WRTigt
COQDhia4+8Y2DjZqr36m5O5ufV2r9ijmf6FR5SQWb5kKuzXhqYmuz7Gv7GGCWZQd
qq+HlczY4Lcf6OZgeNzzT5+Eh7yh1M0WUxk18hWf3W8SnFsQiw8sfv1U2Z1jiUm2
3T28hadDQogCqpaGxsPAFxHNNQaMllQGrvne+sFNJlNSoUZrmGo0rlZ+D+f23CNA
Cc/s82yrI7s0vFFStL4yM3NNUEBijbo+Ht6YZwISRURzA4d5O+vzPn6cDQ/sTPWJ
gbW2KyrGFaot/elDDVhlz5E7Y32yQJdi2YtAO2nL/GC9gYPghJe1daJMoavkiCvU
mC6DRMxrgS2VgpiZgVKdXbaGhk3Y+GqJYdW8DxYKNgWxBNeaXca5HKk/wBvQQ3xO
1vIUaOOj1KNrxjRDojZWuTBUzCT0RyizQuC5sWvozU1qgdom+F8FR0lq3A1lQbdr
F795SnIa+KH2W6tNGxsX
=PdNi
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2013_21_58_45_+1100_BTNemRO8t10dQgWh--
