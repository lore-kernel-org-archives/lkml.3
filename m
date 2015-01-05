Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbbAEVgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:36:11 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:56333 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbAEVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:36:09 -0500
Date: Mon, 5 Jan 2015 17:35:59 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] ti-soc-thermal: implement eocz bit to make driver useful
 on omap3
Message-ID: <20150105213557.GD31536@developer>
References: <20150103114632.GA21883@amd>
 <20150103122634.GB22356@developer>
 <20150103162241.GA26680@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <20150103162241.GA26680@amd>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 03, 2015 at 05:22:42PM +0100, Pavel Machek wrote:
> Hi!
>=20
> > > When periodic mode is not enabled, it is neccessary to force reads.
> > >=20
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >=20
>=20
> > > --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > > +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > > @@ -43,6 +43,8 @@
> > > =20
> > >  #include "ti-bandgap.h"
> > > =20
> > > +static int ti_bandgap_force_single_read(struct ti_bandgap *bgp, int =
id);
> > > +
> > >  /***   Helper functions to access registers and their bitfields   **=
*/
> > > =20
> > >  /**
> > > @@ -852,14 +831,20 @@ int ti_bandgap_read_temperature(struct ti_bandg=
ap *bgp, int id,
> > >  	if (ret)
> > >  		return ret;
> > > =20
> > > +	if (!TI_BANDGAP_HAS(bgp, MODE_CONFIG)) {
> > > +		ret =3D ti_bandgap_force_single_read(bgp, id);
> >=20
> > not sure MODE_CONFIG is sufficient condition for single read on all OMAP
> > versions.
>=20
> Ok, what do you suggest? AFAICT, without MODE_CONFIG, continuous ADC
> mode is not available, so we have to force it periodically, so this
> should be correct.

I will have a better look and let you know. for now, adding a single
read should not hurt ( but I will double check)

>=20
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > >  	spin_lock(&bgp->lock);
> > >  	temp =3D ti_bandgap_read_temp(bgp, id);
> > >  	spin_unlock(&bgp->lock);
> > > =20
> > > -	ret |=3D ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> > > +	ret =3D ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> >=20
> > this one should be part of your clean up patch
>=20
> Ok, can you apply the cleanup patch and I'll prepare one on the top of
> it?

I mean, you should resend the cleanup patch including the above '|=3D' remo=
val, as you are already doing in the cleanup patch.

>=20
> 									Pavel
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqwO0AAoJEMLUO4d9pOJWaJgH/ArebtCW23ANA7+na+NEBnGo
H0OmnHM6ZmICCLCeDi/yIbk/B+Hl5tgnlWyvsY3htXAw2bbNDanS8OzfxsfkbHJO
qkN/APJM6vC+PNCiNgQQPJZYycAXMBtsiNqZgMGXzqZiqIZPhbcJG5iA698Dfiui
BbVVI7i0xmCk0myDlCGy8xSvid+gfVTyliViQMzICwPgPfY/82I+lzcpfy5WaSkc
tgVmBHAPCkskQwDmJ8FPlRyOIqLS8wGtsvndySzynaVJL5Ob0AhZkVIRbACN9VYH
NIGwBFsDT6ijTpChow1xZLve0wMKQA5i/hJ+DA8G8SapR9pn0pgR5DbdgHV0u3Q=
=Y667
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
