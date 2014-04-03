Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162412AbaDCHKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:10:30 -0400
Received: from sauhun.de ([89.238.76.85]:44899 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162361AbaDCHK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:10:27 -0400
Date: Thu, 3 Apr 2014 09:10:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
Message-ID: <20140403071004.GA2571@katana>
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
 <533CF913.4020308@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <533CF913.4020308@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Please don't quote large parts of the message f you are not referring to
it.

> > +#ifdef CONFIG_PM_SLEEP
> > +/**
> > + * cdns_i2c_suspend - Suspend method for the driver
> > + * @_dev:	Address of the platform_device structure
> > + * Return: 0 always
> > + *
> > + * Put the driver into low power mode.
> > + */
> > +static int cdns_i2c_suspend(struct device *_dev)
> > +{
> > +	struct platform_device *pdev =3D container_of(_dev,
> > +			struct platform_device, dev);
> > +	struct cdns_i2c *xi2c =3D platform_get_drvdata(pdev);
> > +
> > +	clk_disable(xi2c->clk);
> > +	xi2c->suspended =3D 1;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * cdns_i2c_resume - Resume from suspend
> > + * @_dev:	Address of the platform_device structure
> > + * Return: 0 on success and error value on error
> > + *
> > + * Resume operation after suspend.
> > + */
> > +static int cdns_i2c_resume(struct device *_dev)
> > +{
> > +	struct platform_device *pdev =3D container_of(_dev,
> > +			struct platform_device, dev);
> > +	struct cdns_i2c *xi2c =3D platform_get_drvdata(pdev);
> > +	int ret;
> > +
> > +	ret =3D clk_enable(xi2c->clk);
> > +	if (ret) {
> > +		dev_err(_dev, "Cannot enable clock.\n");
> > +		return ret;
> > +	}
> > +
> > +	xi2c->suspended =3D 0;
> > +
> > +	return 0;
> > +}
> > +#endif
>=20
> Can you also please remove this #ifdef and use __maybe_used
> instead? Better not to have any ifdef in the code.

Is this a new pattern? For PM_SLEEP, #ifdef seems to be quite common.


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTPQlMAAoJEBQN5MwUoCm2bfwP/2QR+0NWXZUdp0aCJkqHX89N
07bsE6M3U72uo4TIX22dDwx98k35H8V5xW9Rwv9xQ9dR4TKkoF4M3sDoOt66HIJ9
aYOYHu2XxmDihjM8VwqTK3/ha2XAQzQGNHw7H7FSZE4qea6t8ydMQyH7NsRGSW7o
ladSlAGUB2aU5zs4PbAvzkV6Xwlok78wMn/jwjSyVf9yWDh1zoWFnJQoHrmMmVj4
REuqgWkQxyfBaeCK10RJtNcMXXCEUkxPnCMOIlQDQGBB4fGMRL+vVfwmyH0zNvWC
CrtLdGbiJfCevMvGeps3XrmxLjZWYsG2bpQijnq2EdLbajA/n5OK8nyY6CaofOO4
IpQGUoGry5o7liMCmUe9Pd0pGqt+qMqpPfDsIQ1oRyj1Hjap6xty511LeyUiTOyg
WAcyBnerCccr4Jjxu8zVBnByLHYhIMf/3MyJw0BmeLC+ezUr18un3Y29lvAbZOGb
+BLUfk++DdMH54BwbJ2gRLtMYSkrc3cUtxqwRgaZ7nRbOsPcDz006pHZjdRTLcrS
k3wWQVSDwMUszxn8ajH68wgeWkD+cvnZfUGEmFl0HaJrDwR+ukwv+Y3buvSR55tg
IEGK+n7GF68DG03ZZ0tRuAzRt4hVz0KEtHqXYxR4nh47ewNMm+LuZ964KqSSA8UE
sf8cvy6ARjYSnk7KqHiu
=4VTZ
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
