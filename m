Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaK1RPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:15:46 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:49712 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaK1RPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:15:44 -0500
Date: Fri, 28 Nov 2014 11:09:35 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 1/1] thermal: cpu_cooling: check for the readiness of
 cpufreq layer
Message-ID: <20141128150932.GA24720@developer>
References: <1417186410-24551-1-git-send-email-edubezval@gmail.com>
 <20141128171024.GW3836@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20141128171024.GW3836@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Russel,

On Fri, Nov 28, 2014 at 05:10:24PM +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 28, 2014 at 10:53:30AM -0400, Eduardo Valentin wrote:
> > diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> > index 3f5ad25..d4eaa1b 100644
> > --- a/drivers/thermal/samsung/exynos_thermal_common.c
> > +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> > @@ -371,9 +371,10 @@ int exynos_register_thermal(struct thermal_sensor_=
conf *sensor_conf)
> >  		th_zone->cool_dev[th_zone->cool_dev_size] =3D
> >  					cpufreq_cooling_register(&mask_val);
> >  		if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size])) {
> > -			dev_err(sensor_conf->dev,
> > -				"Failed to register cpufreq cooling device\n");
> > -			ret =3D -EINVAL;
> > +			ret =3D PTR_ERR(th_zone->cool_dev[th_zone->cool_dev_size]);
> > +			if (ret !=3D -EPROBE_DEFER)
> > +				dev_err(sensor_conf->dev,
> > +					"Failed to register cpufreq cooling device\n");
>=20
> Something which bugs me quite a lot is when there is an error code (which
> tells you why something didn't work) and you have an error message, and
> the error message doesn't bother printing the error code.
>=20
> You might as well just print "Failed\n" and leave it at that, or md5sum
> the error message and print the sum instead. :)
>=20

I like the md5sum better! :-)


> Knowing why something failed allows you to read the source, and find
> possible reasons for the failure (which could come down to one reason)
> and allows faster resolution of the problem.
>=20

Sure. I will resend with the error codes in the error messages. Makes
completely sense.

Thanks for taking the time and reviewing.


Eduardo Valentin

> --=20
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJAhAAoJEMLUO4d9pOJWNtgIAIVUhNPVtwVWHQGEfglfo9P9
8lluSQs00PNqhA6zkn7nz9emKkhkiUKebxCRa3ni9Rf/SwWAGf4a70jO5/7xoHIB
yq0DHIjVDf2s7H+EpaAisuDCU5i2SRxTPg+r9CMM2hZWMczQ5SEkuMJ3LvoifhJ6
bXpTXw14vv/2Ko2LaOp1fM3zUnbCleVILpn+MWPgwIBz8TQSQQrJQ+KELzxvLZtB
vLrnFa9K9wPZMWZcwCXRY+2aklaayMgcRWCcEBNzxcZ6hi8m6068Kow0d8LvHcQo
hmWvxaaHlyFuMvSaaYik374PlMrB0OY1NqqIJgExoqYsWMkd7f0XaIjspOq6NP8=
=0+hj
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
