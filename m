Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3G2UgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:36:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57981 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab3G2UgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:36:16 -0400
Date: Mon, 29 Jul 2013 23:36:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, Illia Smyrnov <illia.smyrnov@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/3] Input: omap-keypad: Enable wakeup capability for
 keypad.
Message-ID: <20130729203605.GB6547@radagast>
Reply-To: <balbi@ti.com>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
 <7605900.g1IUvSbegi@dtor-d630.eng.vmware.com>
 <20130729191324.GA5767@radagast>
 <2416808.ThTjdiEasK@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <2416808.ThTjdiEasK@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 29, 2013 at 12:59:23PM -0700, Dmitry Torokhov wrote:
> > > > > @@ -439,12 +444,50 @@ static const struct of_device_id
> > > > > omap_keypad_dt_match[] =3D {>
> > > > >=20
> > > > >  MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
> > > > >  #endif
> > > > >=20
> > > > > +#ifdef CONFIG_PM_SLEEP
> > > > > +static int omap4_keypad_suspend(struct device *dev)
> > > > > +{
> > > > > +	struct platform_device *pdev =3D to_platform_device(dev);
> > > >=20
> > > > you don't need to access the platform_device...
> > > >=20
> > > > > +	struct omap4_keypad *keypad_data =3D platform_get_drvdata(pdev);
> > > >=20
> > > > ... since this can become:
> > > > 	struct omap4_keypad *keypad_data =3D dev_get_drvdata(dev);
> > >=20
> > > No, please use correct accessors for the objects. Platform drivers de=
al
> > > with platform devices and I prefer using platform_get_drvdata() on th=
em.
> >=20
> > The argument to this function is a struct device, you prefer to do some
> > pointer math to find the containing pdev, then deref that back to dev,
> > then to struct device_private and further to driver_data ?
> >=20
> > Sounds like a waste of time IMHO. You already have the device pointer
> > anyway, why would you go through the trouble of calculating the
> > offsets for the containing struct platform_device ?
>=20
> This assumes knowledge of dev_get_drvdata() implementation and assumption
> that it will stay the same. Unless I hear from device core guys that
> <bus>_{get|set}_drvdata() methods are obsolete and will be eventually
> removed I will require proper accessors being used.

they're not obsolete and will never be removed. They're nothing but
helpers though. Instead of calling:

	dev_set_drvdata(&pdev->dev);

you call:

	platform_set_drvdata(pdev);

same is valid for every single bus, but in the end they all just wrap a
call dev_{set,get}_drvdata() internally. If you already have a struct
device pointer as argument, why waste cycles doing pointer math just to
go back to the same struct device pointer on the next call ?

--=20
balbi

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9tI1AAoJEIaOsuA1yqREDyMQAJlThkNzLee8vWcWwgQ7QX4m
r7qwOXCUQQHOKIdgeT6u9TRAezKwWo+Rf38f+XtLOjeetBZBRxe9yYME8kdoMxWS
wvbcyzt1dTG//tl+NNZqiUDS3z2kqDpCdRe5Ku/yeKwTXGEgNnbCbcXdlDf2zCOr
Dp5VObyW0g4HdicN0OCWDWDU7Y/6ZN7Bi1hr5lNYSCZHRJJBHlZwevLzGJRfnEXX
z3l76nEU35KN2vIqreTtCfV0D7Aqsrv3bZIV5ToDnwyF7x8LT06ur2hb/CQKbUZv
TNAd0pK1IZb2+f3YVOxQpieOzoE0CN5g9kHpe2SFeQlLWg5FawkDQoBaoMBcHsyx
fRatLx3VIw3GD87gUhMUwSxEJMXSngBfY2b+VpIiZ+CY6BrgmYmbEUkuQ8E/+G+0
p/Uu6f0cWKDuj8guYz17iajXFWMoQdxCaHDLs4V+AJAxJGj2Ai86UTpi6ylNMGRs
K4efB/mH0iSXRoNLoJslMFwvoEnPTt/qMLcGEzu3VpLrh6Xpsj4XH3s2hcOvHXb2
PMNca6e0pBlK372APpz65rJzlYdsTVg2qGyFduFujVvm5AEojezwjvXj4x3BAkuA
IBo8WA3t2fUYxp4L9tvE6nmayzTU8WluzDpEvw4z+erXJfhjKDLVxhyUly10Rzu5
z0RssZwcBUv+PxaR6G5p
=qM/g
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
