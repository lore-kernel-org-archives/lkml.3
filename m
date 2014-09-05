Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaIEPx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:53:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44091 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaIEPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:53:57 -0400
Date: Fri, 5 Sep 2014 10:53:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v6 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140905155321.GF24449@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409931392-22340-1-git-send-email-peter.griffin@linaro.org>
 <1409931392-22340-2-git-send-email-peter.griffin@linaro.org>
 <20140905154700.GE24449@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Content-Disposition: inline
In-Reply-To: <20140905154700.GE24449@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 10:47:01AM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Fri, Sep 05, 2014 at 04:36:30PM +0100, Peter Griffin wrote:
> > +static int st_dwc3_remove_child(struct device *dev, void *c)
> > +{
> > +	struct platform_device *pdev =3D to_platform_device(dev);
> > +
> > +	of_device_unregister(pdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int st_dwc3_remove(struct platform_device *pdev)
> > +{
> > +	struct st_dwc3 *dwc3_data =3D platform_get_drvdata(pdev);
> > +
> > +	device_for_each_child(&pdev->dev, NULL, st_dwc3_remove_child);
>=20
> same as before, of_platform_depopulate(). I can fix this one myself this
> time.

it's in my testign/next branch, please make sure it looks alright.

--=20
balbi

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCdxxAAoJEIaOsuA1yqRETUsP/0a6P2X0Emj5opvf9JPRjxHN
ADZyrZuaGJWaPZtElplAdVYmpWzqPJ/XsO+V6WRhOSQO0BqW2zJPQ02Ao8N4rw3s
7ar7+T5TkOnNmctfTg+rA7a9snXuuK/IJWm+4URGgeaQJmqai6/rMnFOdiBd71ft
grE5mhbjIM+TrwEfzW3prctNdYbhakB5yDSczxa7NPK0IDt9Ic0N6BkieBhcTWqj
JU5FteTeKfZgweJLqRdfwFgmEEwoeF/EZF73oCIMjV/9FHYz79MmhV8DYV/deeBc
CGGKWVCglUhAfUAoQiLadSnBcvB7mTklRYnEkysje2Q3zPwXyt7wEzVsW7blQFk1
7bxHTslyH8D6HBkcY//jydDyVzVHCT/fWHt86ZFSy9x+O9a7f6q6DsI7cqqVQXSC
qDplebSC1AiXFKdwCDiLGgyKg5sl4z05JQPGEvLfK5xlTA91mZM5kSDh/sZtcpXM
r273ejeHFyX8dTfVt8CdZ+Xc0VCVOvirBNGxTceaT4Z1bZpwgpDVGtjaWpIDFwx/
VCEWEs7A2KByahYNlIYTBpxZJdph5YmTAGvgihQVEJTZLK/0+07KX+dTiGuAIXR6
gVzBK21M7tUFAc99l7kzliueRA4odfJQwNDjP+IVlUz6ahFZwEghL9RAOJZmL4cW
M8aLD07H8U9Uaj10g1mb
=b7D2
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
