Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3KQHVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 02:21:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3KQHVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 02:21:13 -0500
Date: Sun, 17 Nov 2013 18:20:54 +1100
From: NeilBrown <neilb@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Pawel Baldysiak <pawel.baldysiak@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.4 11/26] md: Fix skipping recovery for read-only
 arrays.
Message-ID: <20131117182054.1b57fd20@notabene.brown>
In-Reply-To: <1384661479.19290.9.camel@deadeye.wl.decadent.org.uk>
References: <20131109065050.089866597@linuxfoundation.org>
	<20131109065051.007223561@linuxfoundation.org>
	<1384661479.19290.9.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qgl=lXOqqDx.4w4A7IZO9Pd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Qgl=lXOqqDx.4w4A7IZO9Pd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 17 Nov 2013 04:11:19 +0000 Ben Hutchings <ben@decadent.org.uk> wrot=
e:

> On Fri, 2013-11-08 at 22:51 -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Lukasz Dorau <lukasz.dorau@intel.com>
> >=20
> > commit 61e4947c99c4494336254ec540c50186d186150b upstream.
> >=20
> > Since:
> >         commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
> >         md: Allow devices to be re-added to a read-only array.
> >=20
> > spares are activated on a read-only array. In case of raid1 and raid10
> > personalities it causes that not-in-sync devices are marked in-sync
> > without checking if recovery has been finished.
> >=20
> > If a read-only array is degraded and one of its devices is not in-sync
> > (because the array has been only partially recovered) recovery will be =
skipped.
> >=20
> > This patch adds checking if recovery has been finished before marking a=
 device
> > in-sync for raid1 and raid10 personalities. In case of raid5 personality
> > such condition is already present (at raid5.c:6029).
> >=20
> > Bug was introduced in 3.10 and causes data corruption.
>=20
> So this fix was not needed for 3.4.  Is it harmful if applied to this
> version?

It is not needed, but it is also not harmful.

NeilBrown


>=20
> Ben.
>=20
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > ---
> >  drivers/md/raid1.c  |    1 +
> >  drivers/md/raid10.c |    1 +
> >  2 files changed, 2 insertions(+)
> >=20
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1357,6 +1357,7 @@ static int raid1_spare_active(struct mdd
> >  			}
> >  		}
> >  		if (rdev
> > +		    && rdev->recovery_offset =3D=3D MaxSector
> >  		    && !test_bit(Faulty, &rdev->flags)
> >  		    && !test_and_set_bit(In_sync, &rdev->flags)) {
> >  			count++;
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1534,6 +1534,7 @@ static int raid10_spare_active(struct md
> >  			}
> >  			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
> >  		} else if (tmp->rdev
> > +			   && tmp->rdev->recovery_offset =3D=3D MaxSector
> >  			   && !test_bit(Faulty, &tmp->rdev->flags)
> >  			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
> >  			count++;
>=20


--Sig_/Qgl=lXOqqDx.4w4A7IZO9Pd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUohuVjnsnt1WYoG5AQIPfg/9E6J9Gs9fksiKz/WIdrYWj9WTc04T79fD
29D+sTWPnnTZkzGurZwycwHyO2gDgrU/z+ArfrAHAqebCvwZ5EgG9+X5cH+3cggr
XVdiVWpH58YOlFU3IIqVAr1ikcisvB4jGm0f0JXoY0WI8wvLrFDAxSIaca3lOL8T
w5IzuyxjnYYvEmL3YkOHUQcF0EIZWjG50HP/cwhqXS5br1TfjQrZbukwUI32D2S0
uWSJlsdZlUSQGaG63HSeiLZ092eGVM0ELsblzsO/bXwDFxstDahJfq09UHDWHCp+
uorworihN/nJ5sThwAihLoDl28VW52BjmWilyejXGcCYMTA/7BeyR6JCg/hlJPHg
8xPEfLgQrQXFUiECEUzn46aDNS+uvRVyDai3E+5GzzGqlDEUJDH+Y3RS/IJ1zF9K
QpaWE7AFzEW7HMHTpgfwP+ybkP+xTk+FS4SzTGBsjiZeqU771u9MzTcHdHgLLv/w
RWNUQTUNZAL/NdVLW6Z6TtlOqX9cpO1vWkjwvw6yum7Y6jW7fCm4RC00PBEG4rxp
V2Fpw3zW//vdsEDI4cFBxyo07dtxC6A8i/pP0PsPzKl1HNFpVPjme8hB4x6gJX1l
kamlkCJw+EF1OQv++heHHpSto9GCO5OkwhiLOJmQ3XLOJAzbccdggFYJSM0HsMUb
184puoxiAnY=
=98Dq
-----END PGP SIGNATURE-----

--Sig_/Qgl=lXOqqDx.4w4A7IZO9Pd--
