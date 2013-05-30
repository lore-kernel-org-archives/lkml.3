Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968199Ab3E3KzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:55:21 -0400
Received: from sauhun.de ([89.238.76.85]:50891 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459Ab3E3KzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:55:07 -0400
Date: Thu, 30 May 2013 12:56:45 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jingoo Han <jg1.han@samsung.com>,
        linux-pm@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Message-ID: <20130530105644.GA3595@katana>
References: <000201ce453f$5ce4fc90$16aef5b0$@samsung.com>
 <1474315.q4folvZv3e@vostro.rjw.lan>
 <20130503092311.GA13832@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20130503092311.GA13832@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2013 at 11:23:11AM +0200, Pavel Machek wrote:
> Hi!
>=20
> > > Add pm_ops_ptr() macro that allows the .pm entry in the driver struct=
ures
> > > to be assigned without having an #define xxx NULL for the case that P=
M is
> > > not enabled.
> > >=20
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >=20
> > I've queued this up as v3.11 material.
>=20
> > > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > > @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *de=
v)
> > >  }
> > >  #endif
> > > =20
> > > -#ifdef CONFIG_PM
> > >  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops =3D {
> > >  #ifdef CONFIG_PM_SLEEP
> > >  	.suspend_noirq =3D s3c24xx_i2c_suspend_noirq,
> > > @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev=
_pm_ops =3D {
> > >  #endif
> > >  };
> > > =20
> > > -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> > > -#else
> > > -#define S3C24XX_DEV_PM_OPS NULL
> > > -#endif
> > > -
> > >  /* device driver for platform bus bits */
>=20
> Will not this enlarge .data by sizeof(struct dev_pm_ops)?

Same question here. Is it the preferred way now to use this new macro
although having the cost of having an empty dev_pm_ops?


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpzBsAAoJEBQN5MwUoCm2vmUQAICn0bA747jbp//x5rGrcPtE
HjKFmCfWKvZNuCrMa3MWo+jXipnDElU/Es0/Cx9jr3C8rlwTsrxsCXTdBcROffj+
bdc9jOB6sG2MM3eiVaW5kuCQQCTqOtBmWfl463jJKqLCLsrUMTRU+sIQYHbU8i0O
iaXaGsRBjq9Brhm3Dq9ItVwzMigi3FPgA04rfcC6zdi+ZoZxxO8V8O7h2iVmTHDH
t5T/qPjFei5TZFlIj1rzDDaQH3b5TfNuAJmzg6wHbSpi8t1n+4Dg6GPsR805VqQO
obTeicPAauzfnQ1lPDmN8fyGEpkpi4PrIdwdLGL3ySPEPhy4uuIKj3VeAHLwObhB
YQ7YEZT5uK7PXs54RiE1grdFjUlIv2IzyHTz6gEAS1bLu/JB24kTxwRZybhhsNua
xJBs1Y3YsvfgtC4AEHlRmhKim1i0JE/XmO+crtm7wFwHWAzy4URh6c/FO91sWc71
3iwky+Yv8CpRxnY7RYEexUoppuP3RLnjnVLdAiBpDYbMwocYO1TqWFYInp1F+R2z
Q283CJmwWxSAixOf+TATFf373eGdEeYPa6RuEmJh4JnE7EzPLx+79OQ6EEdelEdE
B1AFsQLTROupW1HKUSUylj1mxbc7gLndWFFYEEdiz5WS6Z1uif4tIaxSTY/WULlT
lPOXhX/0T8rla6KQD3yW
=SLpC
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
