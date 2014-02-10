Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaBJRJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:09:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40165 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaBJRJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:09:13 -0500
Date: Mon, 10 Feb 2014 17:09:00 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Message-ID: <20140210170900.GC13533@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207171202.GD1757@sirena.org.uk>
 <1392049766.2853.43.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <1392049766.2853.43.camel@iivanov-dev>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 06:29:26PM +0200, Ivan T. Ivanov wrote:
> On Fri, 2014-02-07 at 17:12 +0000, Mark Brown wrote:=20

> > > +	if (!xfer)
> > > +		return IRQ_HANDLED;

> > Are you sure?  It seems wrong to just ignore interrupts, some comments
> > would help explain why.

> Of course this should never happen. This was left from initial stage
> of the implementation.

OK, so reporting them as errors seems better then.

> > > +	if (controller->speed_hz !=3D chip->speed_hz) {
> > > +		ret =3D clk_set_rate(controller->cclk, chip->speed_hz);
> > > +		if (ret) {
> > > +			dev_err(controller->dev, "fail to set frequency %d",
> > > +				chip->speed_hz);
> > > +			return -EIO;
> > > +		}
> > > +	}

> > Is calling into the clock framework really so expensive that we need to
> > avoid doing it? =20

> Probably not. But why to call it if the frequency is the same.

It's less code that could go wrong and the check is already there in the
clock framework hopefully.

> > You also shouldn't be interacting with the hardware in
> > setup().

> This is internal hw-setup, not master::setup() or I am
> missing something?

The naming could probably be clearer then - config or something.

> > > +	if (chip->bits_per_word <=3D 8)
> > > +		controller->bytes_per_word =3D 1;
> > > +	else if (chip->bits_per_word <=3D 16)
> > > +		controller->bytes_per_word =3D 2;
> > > +	else
> > > +		controller->bytes_per_word =3D 4;

> > This looks like a switch statement, and looking at the above it's not
> > clear that the device actually supports anything other than whole bytes.
> > I'm not sure what that would mean from an API point of view.

> SPI API didn't validate struct spi_transfer::len field.

It's supposed to; if the validation is incomplete then that should be
fixed.

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+QepAAoJELSic+t+oim98m8P/1CnfiS2JrsBUDbqMteVfjQ6
s1rS7R3SU7gNCvuq7wOD2uNmS2CFK1EeSQirPzot1tS3rNeZx6AuRieortYPJfJb
Z894ofWT8thXHOWNDX2QGKDUS6XZAvsp5y5HOl8b/4R4xwRT7dYqXOjv84KAwa3l
ONdiWw+z+jjvdwQupSlpGOpN+lgp5CTtlo4k/oQ35VaZ6VdQAcma2psdJamdAzCK
ayovd01VwhL9s1d81Jd6Hp4+erQONHPWA3v6CBElkyXnCLvXnMTGvDCn4A9dud3q
WAucQ+xgYPqII4ZnexDyfF2rvp0Cad9536OY8Sw5zx94PipXxW1xbbpGIBUtbFr4
9/+xU2gr8zMBBWGaQzQb5bIeAmb4q9Ly+vPi9eBMcRgsIDVA0fAPbSrQ0U0xIyVx
vqoDRKRhCO8gnNwGeTSVCrRx0SnZP9WbPzdCw0pk8t3FABL1jFQFeUql4UJCrfkj
KSKnPBoRsy4FwL8Bbx+gr7fPcQX/bB/sTNi/+u7wcgK5KAHN9f3C4po5Qstedz3Z
qC5Kc4MMVM0Utlze66a2mUWxlD59UM/xgHX7ZFkvMl/fgq8JGnC5WZmRc7d/Mai0
DSJgS6E2asUDd+Bkiv7Ac1O+2Ngwch289970P6AOqY38ZEi7+/XtL41juJfyEZxD
gTftlYdakcZxbAIWQ3Pl
=7/+x
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
