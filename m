Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaKJU6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:58:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:49077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaKJU6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:58:21 -0500
Date: Mon, 10 Nov 2014 21:58:14 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFCv2 5/8] [media] si4713: add device tree support
Message-ID: <20141110205814.GA2591@earth.universe>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
 <1413904027-16767-6-git-send-email-sre@kernel.org>
 <54594962.2090207@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <54594962.2090207@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Tue, Nov 04, 2014 at 11:47:14PM +0200, Sakari Ailus wrote:
> Nice set of patches! Thanks! :-)

Thanks :)

> > [...]
> >  	struct si4713_device *sdev;
> > -	struct si4713_platform_data *pdata =3D client->dev.platform_data;
> >  	struct v4l2_ctrl_handler *hdl;
> > -	int rval, i;
> > +	struct si4713_platform_data *pdata =3D client->dev.platform_data;
> > +	struct device_node *np =3D client->dev.of_node;
> > +	int rval;
> > +
>=20
> Why empty line here?
>=20
> It's not a bad practice to declare short temporary variables etc. as last.

Fixed in PATCHv3.

> > +	struct radio_si4713_platform_data si4713_pdev_pdata;
> > +	struct platform_device *si4713_pdev;
> > =20
> >  	sdev =3D devm_kzalloc(&client->dev, sizeof(*sdev), GFP_KERNEL);
> >  	if (!sdev) {
> > @@ -1608,8 +1612,31 @@ static int si4713_probe(struct i2c_client *clien=
t,
> >  		goto free_ctrls;
> >  	}
> > =20
> > +	if ((pdata && pdata->is_platform_device) || np) {
> > +		si4713_pdev =3D platform_device_alloc("radio-si4713", -1);
>=20
> You could declare si4713_pdev here since you're not using it elsewhere.

It has been used in the put_main_pdev jump label at the bottom
outside of the scope and all access will happen out of the scope
after the refactoring you suggested below.

> > +		if (!si4713_pdev)
> > +			goto put_main_pdev;
> > +
> > +		si4713_pdev_pdata.subdev =3D client;
> > +		rval =3D platform_device_add_data(si4713_pdev, &si4713_pdev_pdata,
> > +						sizeof(si4713_pdev_pdata));
> > +		if (rval)
> > +			goto put_main_pdev;
> > +
> > +		rval =3D platform_device_add(si4713_pdev);
> > +		if (rval)
> > +			goto put_main_pdev;
> > +
> > +		sdev->pd =3D si4713_pdev;
> > +	} else {
> > +		sdev->pd =3D NULL;
>=20
> sdev->pd is NULL already here. You could simply return in if () and
> proceed to create the platform device if need be.

Right. I simplified the code accordingly in PATCHv3.

> Speaking of which --- I wonder if there are other than historical
> reasons to create the platform device. I guess that's out of the scope
> of the set anyway.

I think this was done, so that the usb device can export its own
control functions.

> > [...]
> >
> > +	if (sdev->pd)
> > +		platform_device_unregister(sdev->pd);
>=20
> platform_device_unregister() may be safely called with NULL argument.

Ok. Changed in PATCHv3.

> > [...]

-- Sebastian

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUYSbmAAoJENju1/PIO/qa90IP/22e/fi1cIzIKoCeIjQKQsXB
nMxwX5/ejk8JMbRe4d3dDVWtIBYE/FqDFpM5jwfF295WzykKqZUpwlrzPff+iDjV
SRt33b163fim/qu7NhpgaMH4/i0dTJYtIoyx+pIlXdWy560j+YIN+FIU92DZvShp
ZekibJUQRPiL8uXp8qLWngdO4A7oCEGDWr5G5Kb5aj5bzuXvcJGpTvx7aSOqfOen
Rt1XXmLRd9314je1bMdtszjdXGqXmnejUnqynANtI7l7MyV9FgMWUaAqc97ei1o0
uHZ4cYzBtocOUFqbHnUp3uOmbrp8ulBJAfn0xq+C/6d86qwVL/Oqgrxipy4cRDZl
jPaI3GlPJz690OBGg4YfnjTXae/AHnWkLpgz39XaSOdmdG26KKg1jav0wosfsvsV
3VbotsVwDQsgzIHUbKmYQmv4Pc7bHSaJLRHtsz/BJjcT46qSbe8I7ozyQFmAkFJ+
o8uVybLrfaDdt9weH6WeJKJEmQBzMz66C2YoZEKRB8K86ILF8aCq1K7lmMorAQvH
Nc0JDlp/CRlfCZdIuJqe2VES99bGOMnoQmdYiAC08f3Ns3K31cLlTS3cwTI/gG9B
JSrJXRMPCycpw5lnS0SduHsK9tVWo/F/BU5EOoYLmDQ4LUFhy5ipPIVArmJJOKsq
xiuIClevWOzCji0IXQZH
=GQV+
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
