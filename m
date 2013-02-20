Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab3BTWiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:38:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3BTWiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:38:00 -0500
Date: Thu, 21 Feb 2013 09:37:44 +1100
From: NeilBrown <neilb@suse.de>
To: Paul Menzel <pm.debian@googlemail.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH linux-next] DM RAID: validate_raid_redundancy: Silence
 uninitialized variable warning
Message-ID: <20130221093744.3ad146c4@notabene.brown>
In-Reply-To: <1361398597.4895.24.camel@mattotaupa>
References: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
	<1361398597.4895.24.camel@mattotaupa>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Nzd5Is/CwURP9gl+pwoR1D0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nzd5Is/CwURP9gl+pwoR1D0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Feb 2013 23:16:37 +0100 Paul Menzel <pm.debian@googlemail.com>
wrote:

> Dear Tim,
>=20
>=20
> thanks for the patch.
>=20
>=20
> Am Mittwoch, den 20.02.2013, 13:31 -0700 schrieb Tim Gardner:
>=20
> Noting the `gcc` version and build environment is never wrong. ;-)
>=20
> > drivers/md/dm-raid.c: In function 'raid_ctr':
> > drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used =
uninitialized in this function [-Wuninitialized]
> > drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared he=
re
> >=20
> > It appears unlikely that rebuilds_per_group could be used before set,
>=20
> Why? Otherwise the compiler would not complain, right?

It is not simply unlikely, it is impossible.  But gcc isn't that clever yet.

> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -380,7 +380,7 @@ static int validate_region_size(struct raid_set *rs=
, unsigned long region_size)
> >  static int validate_raid_redundancy(struct raid_set *rs)
> >  {
> >  	unsigned i, rebuild_cnt =3D 0;
> > -	unsigned rebuilds_per_group, copies, d;
> > +	unsigned rebuilds_per_group =3D 0, copies, d;

This should either be:
        unsigned uninitialized_var(rebuilds_per_group);
        unsigned copies, d;

which the old way and is being deprecated, but at least is consistent with
the kernel as it is, or

        unsigned rebuilds_per_group =3D 0 /* GCC */;
	unsigned copies,d;

which is apparently the new way which I believe is due to be imposed on the
kernel immediately after 3.9-rc1
   https://lwn.net/Articles/529954/

NeilBrown


--Sig_/Nzd5Is/CwURP9gl+pwoR1D0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUSVQODnsnt1WYoG5AQLd3Q//UL3Ci1uFP3bUejUumo0dx6x4HAiopoYP
88K1zfVw14QsX8lI4bXzQkBlVjnBhGeOLptZxqptN7ncbtVxpj2Mm576ZDj+cKkn
DR/0z3sT9ezWlyqWizy0sjkOE/sP8XMs/Z7t11C1HjBLce2kO9NRbGjtD1zstYLD
nYToJ8fjnrf5KeGd+TI/gL/02maiPIAKC6UiQR/auCnIg5Bc2m9aJYyUxgjHaxOI
w91KLfPI6fMX1UJmWvIeYYCqOGctdbLnP4fB7CExDvgjEUSsd6CRpAaPvJe0+/g5
R1Znn2MdqY5bDpMYE1LSeDGOecuEag1EOurNIkjhip9KKnegkfkvfvEZPtZ7fvNw
O9t5OvYIi+bsGGxJTtNOldulcmWjL+sE7on2jLEGXKz/HSCu60YiXlfoU8XzXANc
1tC3EoHE8LQ+bZzP1rMozBwmQk0dCHkJ6s+Nwu4Jch6/2czdGGvyvE1Ixrehogc5
b6Y4ci+tXO1cZNJxWbawqlL3fFFwLuCBPPcVQkH2IiEPW1qQWDPemCnE4D1gubZS
V1AGSqnRchRCGMxDe89i3uKJcbSUWTUbMoi8XDggjsNRsu8FtezHA7vGKJeJfOnB
tKUETcKGmGiUPwsYkbn+3wDUAfprQyaIYZeo0RldmIBPyGM93MvtjgOQqx1vgLpV
gmVI/MCdSgQ=
=yQzY
-----END PGP SIGNATURE-----

--Sig_/Nzd5Is/CwURP9gl+pwoR1D0--
