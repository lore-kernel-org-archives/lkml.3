Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3KQELl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 23:11:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33976 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab3KQELb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 23:11:31 -0500
Message-ID: <1384661479.19290.9.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.4 11/26] md: Fix skipping recovery for read-only
 arrays.
From: Ben Hutchings <ben@decadent.org.uk>
To: Pawel Baldysiak <pawel.baldysiak@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>, NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 17 Nov 2013 04:11:19 +0000
In-Reply-To: <20131109065051.007223561@linuxfoundation.org>
References: <20131109065050.089866597@linuxfoundation.org>
	 <20131109065051.007223561@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vdsscNEJagU2EXDjzgNV"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.209
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vdsscNEJagU2EXDjzgNV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-11-08 at 22:51 -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Lukasz Dorau <lukasz.dorau@intel.com>
>=20
> commit 61e4947c99c4494336254ec540c50186d186150b upstream.
>=20
> Since:
>         commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
>         md: Allow devices to be re-added to a read-only array.
>=20
> spares are activated on a read-only array. In case of raid1 and raid10
> personalities it causes that not-in-sync devices are marked in-sync
> without checking if recovery has been finished.
>=20
> If a read-only array is degraded and one of its devices is not in-sync
> (because the array has been only partially recovered) recovery will be sk=
ipped.
>=20
> This patch adds checking if recovery has been finished before marking a d=
evice
> in-sync for raid1 and raid10 personalities. In case of raid5 personality
> such condition is already present (at raid5.c:6029).
>=20
> Bug was introduced in 3.10 and causes data corruption.

So this fix was not needed for 3.4.  Is it harmful if applied to this
version?

Ben.

> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/md/raid1.c  |    1 +
>  drivers/md/raid10.c |    1 +
>  2 files changed, 2 insertions(+)
>=20
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1357,6 +1357,7 @@ static int raid1_spare_active(struct mdd
>  			}
>  		}
>  		if (rdev
> +		    && rdev->recovery_offset =3D=3D MaxSector
>  		    && !test_bit(Faulty, &rdev->flags)
>  		    && !test_and_set_bit(In_sync, &rdev->flags)) {
>  			count++;
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1534,6 +1534,7 @@ static int raid10_spare_active(struct md
>  			}
>  			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
>  		} else if (tmp->rdev
> +			   && tmp->rdev->recovery_offset =3D=3D MaxSector
>  			   && !test_bit(Faulty, &tmp->rdev->flags)
>  			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
>  			count++;

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-vdsscNEJagU2EXDjzgNV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUohB5+e/yOyVhhEJAQp1UhAA0lFhf4bQhN6OqBW4Jh/AvYzUfNncmubE
oq+RTrx0NUqsqTJ0gNgKNg32aYKjyWVos8u+3zNfX1KqReQn4jV5r4D2Us3Bbetc
Gehc+77S7xizZqS+6Sn7Fkj3wEphFUcgr/oEpc3MCO6ABbH0NTIrf1ZhgcIQphG7
8HfdDJjImeGu2sBow0SFJupPLFrewwxZ+YutUgjS5/4G4JoJehwdgkdCPaVEaZmJ
PdlDGLKdwtDcAWoacvl8AZWDIc2ZIJFI/vIFpC6rObMrDHr39f7hKfREkJono6Y7
VaM3lH2ox3rhWjURfNiOCslqYMYXaa2CstGkJUCiEUY7U/vM5v1bjXn5JoLygkCf
gp2tT2f8T9g4am9FqKWds/eSkJXGPVYLCYPsS4+vMwcG1mS1hJ4DA/74oMMl7ycC
qf5z83xmQgQXwtFA0oOctidnxyQpz7oY/ouPFiCimG1jtzZTOQtGPti6byO9uDGC
M7gLwHkIxmA8+7nQWdriw7rHs2MQQJE9BBj6rSHiT6BzS/nFRjL1gS881LN7SnS2
XC9eXuvMEtHJCwjhdyeqgeRebXq7KlFtSgU4mdFDq/VT+cWjXeW8R2aMMRT6P+w+
oDi6xbVbAwTaXgJkYpGA2D6o2F9GyFkzm/r8Mw3wdUQZJxBF/at+pE0mC+LOK+W7
SAR687EY/g4=
=R9NH
-----END PGP SIGNATURE-----

--=-vdsscNEJagU2EXDjzgNV--
