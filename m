Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaDKTAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:00:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbaDKTAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:00:16 -0400
Date: Fri, 11 Apr 2014 21:00:14 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [Cocci] [PATCH] coccinelle: add pycocci wrapper for
	multithreaded support
Message-ID: <20140411190014.GL14815@wotan.suse.de>
References: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com> <1397152289.4757.28.camel@jlt4.sipsolutions.net> <20140410175748.GK14815@wotan.suse.de> <534783DB.4080200@users.sourceforge.net> <alpine.DEB.2.02.1404110800120.2032@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z9sQuz+HmDh2hVO4"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404110800120.2032@localhost6.localdomain6>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z9sQuz+HmDh2hVO4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 08:01:04AM +0200, Julia Lawall wrote:
>=20
>=20
> On Fri, 11 Apr 2014, SF Markus Elfring wrote:
>=20
> > > I checked the profile results, the reason the jobs finish is some thr=
eads
> > > had no work or little work.
> >=20
> > Could you find out during the data processing which parts or files
> > result in a special application behaviour you would like to point out h=
ere?
>=20
> I don't understand the question at all, but since the various files have=
=20
> different properties, it is hard to determine automatically in advance ho=
w=20
> much work Coccinelle will need to do on each one.

For the person who might work on enhancing multithreading support, I'd wond=
er
if there could be gains of actually putting an effort out first to evaluate
which files have one rule hit and then adding the file to an activity file =
lis
to later be spread between the threads. As you note though it is hard to
determine this in advance though given that each rule express any change.

I think one small change which could help, and likely not incur a drastic
immediate change on architecture could be to not let theads take files / jo=
bs
list of files, but instead just take say:

	work_task_n =3D (files / jobs) / 10

The list of files needing work could then be kept on a list protected
against the threads, and each thread will only die if all the files
have been worked on already. This would enable keeping number_cpu
threads only, as each CPU would indeed be busy all the time.

BTW is the patch Acked-by Julia? Can we commit it :)

  Luis

--z9sQuz+HmDh2hVO4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTSDu+AAoJEPep4JnvMe6zZgoP/2Sc84WZBgEzJnTiy2zZrvSw
pXkdOBnRjonma9F+Rh7leBLYXi20ZzU0Uu46wDKACo55yz8dRPIstp9zAIQut3Ce
QmdOCC3Ti2iYBz+hbdbz8EinGKXYLOzeBZOG1p9Bk8YxDEyQ/AGqYvVJhR502UrQ
1nSJU3s/GtNaU7mxU42Xxbs/iOAV8lM+Z6RYulfgcVKVv8bZFMNIIsfvv8+iAfua
VvKz1m01zTrM+5lbv8Fj3+AeT0YksOgP6lRyNOzYHY5qzFZz83B3yoxkrkEvXfUp
yexn5hCpSOdno6RupUMnOMiCQJj7MsTQvmRS5zcU6nwNsfVhw2Wczh3sJWXxet3t
IzvLF2qxNgAbgbfDzkLRNeWbjoz/aLnfxy7GO3gWcx4TPfcd2I8SHtRynHJey9Q9
GaZ6FIByUePe0g4b+XADCSz88TB26VpiMk2Q9+Xb3hGGkNMmQifUTVt3gPgTgVq2
MKPxDo41BZkQ+xtWtDVWYcmk7usyOVj1FHIl/lSa8kaEZkiwLHkp0hRVgeTPOaJb
9B4Bxu1K6Ioldawrr5yvbTH9+Fg2K0S+Ls5U05z2ppiGvXh8f9X5fKXh+eqCwgp7
Ga6C7tFMidXkKaqNKCI93u4GCrSf1vZHHS+i/83NiBCBZy344Ajw0/qt86APf2au
b7CaTxyMnrWXKCxU06K+
=m0g6
-----END PGP SIGNATURE-----

--z9sQuz+HmDh2hVO4--
