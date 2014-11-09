Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKIW5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:57:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbaKIW5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:57:18 -0500
Date: Mon, 10 Nov 2014 09:57:07 +1100
From: NeilBrown <neilb@suse.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>,
        "chr >> Doug Anderson" <dianders@chromium.org>,
        Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "christian.strobel@iis.fraunhofer.de >> Christian Strobel" 
	<christian.strobel@iis.fraunhofer.de>
Subject: Re: [PATCH] iio: gyro: itg3200: add suspend/resume support.
Message-ID: <20141110095707.62e718c4@notabene.brown>
In-Reply-To: <545E0401.2000505@kernel.org>
References: <20141108111833.3829480c@notabene.brown>
	<545E0401.2000505@kernel.org>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Yngu3fWEmsqBCFlhU//5xnQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Yngu3fWEmsqBCFlhU//5xnQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 08 Nov 2014 11:52:33 +0000 Jonathan Cameron <jic23@kernel.org> wrot=
e:

> On 08/11/14 00:18, NeilBrown wrote:
> >=20
> >=20
> > Unless we put the device to sleep when not it use, it wastes
> > 6mA.
> >=20
> > If the device is asleep on probe, the 'id' register
> > sometimes mis-reads - so reset first.  If the device responds
> > at all a command sent to the address, it is almost certainly
> > the correct device already.
> >=20
> > Signed-off-by: NeilBrown <neil@brown.name>
> Hi Neil,
>=20
> Looks fine to me - but you should have cc'd a few people from
> the listed driver authors.  Will give them a few days to respond...

Over-dependence on get_maintainers.pl I guess. :-(

Thanks,
NeilBrown


>=20
> Jonathan
> >=20
> > diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200=
_core.c
> > index 6a8020d48140..394667fb23f9 100644
> > --- a/drivers/iio/gyro/itg3200_core.c
> > +++ b/drivers/iio/gyro/itg3200_core.c
> > @@ -223,6 +223,7 @@ static int itg3200_initial_setup(struct iio_dev *in=
dio_dev)
> >  	int ret;
> >  	u8 val;
> > =20
> > +	ret =3D itg3200_reset(indio_dev);
> >  	ret =3D itg3200_read_reg_8(indio_dev, ITG3200_REG_ADDRESS, &val);
> >  	if (ret)
> >  		goto err_ret;
> > @@ -351,6 +352,35 @@ static int itg3200_remove(struct i2c_client *clien=
t)
> >  	return 0;
> >  }
> > =20
> > +#ifdef CONFIG_PM_SLEEP
> > +static int itg3200_suspend(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev =3D dev_get_drvdata(dev);
> > +	struct itg3200 *st =3D iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	dev_dbg(&st->i2c->dev, "suspend device");
> > +
> > +	ret =3D itg3200_write_reg_8(indio_dev,
> > +			ITG3200_REG_POWER_MANAGEMENT,
> > +			ITG3200_SLEEP);
> > +	return ret;
> > +}
> > +
> > +static int itg3200_resume(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev =3D dev_get_drvdata(dev);
> > +
> > +	itg3200_reset(indio_dev);
> > +	return 0;
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(itg3200_pm_ops, itg3200_suspend, itg3200_resu=
me);
> > +#define ITG3200_PM_OPS (&itg3200_pm_ops)
> > +#else
> > +#define ITG3200_PM_OPS NULL
> > +#endif
> > +
> >  static const struct i2c_device_id itg3200_id[] =3D {
> >  	{ "itg3200", 0 },
> >  	{ }
> > @@ -361,6 +391,7 @@ static struct i2c_driver itg3200_driver =3D {
> >  	.driver =3D {
> >  		.owner  =3D THIS_MODULE,
> >  		.name	=3D "itg3200",
> > +		.pm	=3D ITG3200_PM_OPS,
> >  	},
> >  	.id_table	=3D itg3200_id,
> >  	.probe		=3D itg3200_probe,
> >=20


--Sig_/Yngu3fWEmsqBCFlhU//5xnQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF/xQznsnt1WYoG5AQIrow/8DkGRFTCYZysIwzWIxg4Kh6TPDFen/zrJ
n102xtxOQw1lWHwksHJiPVDC4bxt9apL37mDx2vaNOCBFt1hhaM9k8E43x2Sp7LQ
c1drXKcOmRl5fWnKkjrhAYyBlaNTpMWSHKrBnTvfVrNfbf4JySOhBh5ypE8e0MAA
2uFYJeeS1eWR2P+px6S7LGVe0c0JbBOHSnf4NN+IR0Tgay1T2bREt/oUNsxsVLUC
hDkLAbRI+L2EXwSOojVpsOTVd4Yecjjs4OswjSjpu84gmAG05sil70jwtOBuhZvP
A2l0Z2JC9GspLn3ICLNc8VjXi1eLY8ovsqElbHtxbYkqpIhaNX6hw2VRo/HGRmCu
Pb/MmQudnRXdEKQTllxikVJwRlULVQYbdFLNLy5IBKzNNM3mU9ClXKeaiL7VykZR
1eydvBFwJN9XG6c6+V953VAY9Bepcl9NE4fcgfU0UbArnsBmmgzayQQUp57/LPyz
f/YJF9jO7kKHiOI1QQckKmAqd/vqGNd04vVIb8wWh/bJAFcu7f1bwQAH1/4ZrQ9M
JWBsMQrHXJhpcF8ZGF+yYqIQeRuu+3HrkWkXu6ZS9NXH2khxLYNXjPPAmWm3Rybk
z+hspPIOFcRVNOf8V+K6dZwH4k9XsKVmaCOMC9p9zPnYiKwCA+EX6cFfB+Tcq2Pe
F86JX3/RyUs=
=VM7y
-----END PGP SIGNATURE-----

--Sig_/Yngu3fWEmsqBCFlhU//5xnQ--
