Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbbAEVdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:33:42 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:34169 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbbAEVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:33:15 -0500
Date: Mon, 5 Jan 2015 17:33:06 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Zhang Rui <rui.zhang@intel.com>, Tero Kristo <t-kristo@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] thermal: ti-soc-thermal: ti-bandgap.c:  Remove unused
 function
Message-ID: <20150105213304.GC31536@developer>
References: <1419183823-10787-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <549AD44A.8010603@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <549AD44A.8010603@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2014 at 08:57:14AM -0600, Nishanth Menon wrote:
> On 12/21/2014 11:43 AM, Rickard Strandqvist wrote:
> > Remove the function ti_bandgap_write_thot() that is not used anywhere.
> >=20
> > This was partially found by using a static code analysis program called=
 cppcheck.
> >=20
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> > ---
> >  drivers/thermal/ti-soc-thermal/ti-bandgap.c |   13 -------------
> >  drivers/thermal/ti-soc-thermal/ti-bandgap.h |    1 -
> >  2 files changed, 14 deletions(-)
> >=20
> > diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/ther=
mal/ti-soc-thermal/ti-bandgap.c
> > index 634b6ce..cbb6a5f 100644
> > --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > @@ -611,19 +611,6 @@ int ti_bandgap_read_thot(struct ti_bandgap *bgp, i=
nt id, int *thot)
> >  }
> > =20
> >  /**
> > - * ti_bandgap_write_thot() - sets sensor current thot
> > - * @bgp: pointer to bandgap instance
> > - * @id: sensor id
> > - * @val: desired thot value
> > - *
> > - * Return: 0 on success or the proper error code
> > - */
> > -int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
> > -{
> > -	return _ti_bandgap_write_threshold(bgp, id, val, true);
> > -}
> > -
> > -/**
> >   * ti_bandgap_read_tcold() - reads sensor current tcold
> >   * @bgp: pointer to bandgap instance
> >   * @id: sensor id
> > diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/ther=
mal/ti-soc-thermal/ti-bandgap.h
> > index b3adf72..976afc0 100644
> > --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> > +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> > @@ -371,7 +371,6 @@ struct ti_bandgap_data {
> >  };
> > =20
> >  int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot);
> > -int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val);
> >  int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold);
> >  int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val);
> >  int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
> >=20
>=20
> Not sure if removing support for programming of hot threshold is a
> good idea. how about ti_bandgap_write_tcold then?


Agreed here. I believe the right thing to do is to use those functions
to update the thresholds when necessary.

>=20
>=20
> --=20
> Regards,
> Nishanth Menon

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqwMIAAoJEMLUO4d9pOJWQGkH/2tQKSp5Uk0u8BGQJ7T9Xyfn
XFH/kh9aY+FeGqBOirdDVVkvEXSzYfw6w6Ooo8Yqk+DzIGAFI9cg0EYfr4+TdwDi
c4ucrapUBRnFBnGrLNgkdE7MXHHwvEqZKNVkJhTyKYmxbbYDd/PcQHAzhHXubaR3
Xpugs8WSKfO7LBsVP6ctJ0X1oiCvwEc59vyynPA0ygJAX/j0OJ1Bxm4S6/3rEd+o
E9ltQZL9W3Ou6dUZm6GTCn3VIUWwz0f3n5p3c9/5eeErhsVwbCe0llF+TGTdkuk1
hERFgD/nHclkHaZy2Q39iZV0R29jKGR9zcxw7APW4zaM9dOZjOlPRMi+xP9MdbI=
=Hfew
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
