Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab3GaJuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:50:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50069 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab3GaJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:50:01 -0400
Date: Wed, 31 Jul 2013 12:49:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, Illia Smyrnov <illia.smyrnov@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/3] Input: omap-keypad: Enable wakeup capability for
 keypad.
Message-ID: <20130731094948.GB15583@radagast>
Reply-To: <balbi@ti.com>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
 <2416808.ThTjdiEasK@dtor-d630.eng.vmware.com>
 <20130729203605.GB6547@radagast>
 <1861803.h9dhBdaB3X@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1861803.h9dhBdaB3X@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 01:40:28PM -0700, Dmitry Torokhov wrote:
> On Monday, July 29, 2013 11:36:05 PM Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Jul 29, 2013 at 12:59:23PM -0700, Dmitry Torokhov wrote:
> > > > > > > @@ -439,12 +444,50 @@ static const struct of_device_id
> > > > > > > omap_keypad_dt_match[] =3D {>
> > > > > > >=20
> > > > > > >  MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
> > > > > > >  #endif
> > > > > > >=20
> > > > > > > +#ifdef CONFIG_PM_SLEEP
> > > > > > > +static int omap4_keypad_suspend(struct device *dev)
> > > > > > > +{
> > > > > > > +	struct platform_device *pdev =3D to_platform_device(dev);
> > > > > >=20
> > > > > > you don't need to access the platform_device...
> > > > > >=20
> > > > > > > +	struct omap4_keypad *keypad_data =3D platform_get_drvdata(p=
dev);
> > > > > >=20
> > > > > > ... since this can become:
> > > > > > 	struct omap4_keypad *keypad_data =3D dev_get_drvdata(dev);
> > > > >=20
> > > > > No, please use correct accessors for the objects. Platform drivers
> > > > > deal
> > > > > with platform devices and I prefer using platform_get_drvdata() on
> > > > > them.
> > > >=20
> > > > The argument to this function is a struct device, you prefer to do =
some
> > > > pointer math to find the containing pdev, then deref that back to d=
ev,
> > > > then to struct device_private and further to driver_data ?
> > > >=20
> > > > Sounds like a waste of time IMHO. You already have the device point=
er
> > > > anyway, why would you go through the trouble of calculating the
> > > > offsets for the containing struct platform_device ?
> > >=20
> > > This assumes knowledge of dev_get_drvdata() implementation and assump=
tion
> > > that it will stay the same. Unless I hear from device core guys that
> > > <bus>_{get|set}_drvdata() methods are obsolete and will be eventually
> > > removed I will require proper accessors being used.
> >=20
> > they're not obsolete and will never be removed. They're nothing but
> > helpers though. Instead of calling:
> >=20
> > 	dev_set_drvdata(&pdev->dev);
> >=20
> > you call:
> >=20
> > 	platform_set_drvdata(pdev);
> >=20
> > same is valid for every single bus, but in the end they all just wrap a
> > call dev_{set,get}_drvdata() internally. If you already have a struct
> > device pointer as argument, why waste cycles doing pointer math just to
> > go back to the same struct device pointer on the next call ?
>=20
> Because I do not want to rely on the fact that what my driver set up
> with platform_set_drvdata(pdev, XXX) is the same as what dev_get_drvdata()
> will return *in the current implementation*. Software layers and all
> that...

fair enough, your call. It's a waste of CPU anyway.

--=20
balbi

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+N28AAoJEIaOsuA1yqREIVkP/0xMHfXbUhTQ9fJxGfjh0RI0
5BAT6Ewq7y4mhWEwDSu5cnAU3uI3tpk2mCQjmYaBi5MeSz8PxG7dF6fZ0HSW+TAr
zw9+Vf+0QbMH3bw21EnPaeHeaxEdnRh9wgKiNO14MbAheE4sedwIT5SwdTcoRdRo
j0VSWOiPiMeABYVSN+V1BuBnoSJ/LMIBK/3/cDwjLnexbbDR1clhx7Q/q+VuQuGQ
TtHueiWOsYsE9TKkFh2EJ1gi3J1nGBFtKsOYkBENBi8ApR/gn80wtXGppkYb1HTk
4pVYPqH8E5iJ9Iy9bLEZ9XtnO56avLYAbEGuYI2OyKi6LVabLQV8BpCNpT4gEv33
BbOlw5Cr3aj5F0weOen6fRMLo46F2VypXOpLBB8MLBSpFMwqHHmUhaT2mQAwtIj7
QFydRfLIM9H9qr9l38d+AZuXgEwb3iS9BosZE4RBq8yTexxco7wEBuOCVn1cN3cv
BNLquAHRs85fyqX3c6s3nCC5Nj+L5Ur5+b6r1HUtlEQftEcx+jsBKaRxba/2Xbn2
zfnsoYwr6tdzyjdgQdfoHjhXgvVnjTDABXlH00aFuOFb0ydHJ30Xz/FjcZtqslRU
XMb+4c+OB0orMUse7YdOaQKW5Zv6Cz6y+2LSR8wLvssHNJhfB/VtSrYqfl5tShdm
RjWxpjsoqXOkBnGiX9jY
=yfkA
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
