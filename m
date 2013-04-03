Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945Ab3DCPrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:47:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37679 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776Ab3DCPrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:47:43 -0400
Date: Wed, 3 Apr 2013 18:47:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <swarren@wwwdotorg.org>,
        <sylvester.nawrocki@gmail.com>, <rob@landley.net>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <mchehab@redhat.com>,
        <santosh.shilimkar@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <swarren@nvidia.com>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/6] drivers: phy: add generic PHY framework
Message-ID: <20130403154704.GD19093@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364993634-6378-1-git-send-email-kishon@ti.com>
 <1364993634-6378-2-git-send-email-kishon@ti.com>
 <20130403134102.GC14680@arwen.pp.htv.fi>
 <515C3A42.4020404@ti.com>
 <20130403142747.GK14680@arwen.pp.htv.fi>
 <515C3D94.1060000@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <515C3D94.1060000@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 08:02:52PM +0530, Kishon Vijay Abraham I wrote:
> >>>>+		ret =3D -EINVAL;
> >>>>+		goto err0;
> >>>>+	}
> >>>>+
> >>>>+	if (!phy_class)
> >>>>+		phy_core_init();
> >>>
> >>>why don't you setup the class on module_init ? Then this would be a
> >>>terrible error condition here :-)
> >>
> >>This is for the case where the PHY driver gets loaded before the PHY
> >>framework. I could have returned EPROBE_DEFER here instead I thought
> >>will have it this way.
> >
> >looks a bit weird IMO. Is it really possible for PHY to load before ?
>=20
> yeah. it actually happened when I tried with beagle and had all the
> modules as built-in. Because twl4030 has subsys_initcall(), it loads
> before PHY framework.

that's a bug in twl4030.

--=20
balbi

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXE74AAoJEIaOsuA1yqREhR8P/jdBsfIWk5F+FRL20sflOaaH
13di2G7fjFq8smKog+YR48DhMyDSF4wO6l9LK+T9iIbt2jA65YfZ2LgZVXVCSUH1
coqm3yY2tfVGaDWd9s+oUP65sUCJT6Y57HKXIl1VOPex1YAiyESDXW3xT+Y+Cqg2
nzdtKbQexAP+tmFt2mrairEHhO5guWe1O/dFOfPKFScU++bpJ8iMYndEBy9ACqNW
felCwwIQaQHuU+axAgnNdK/Yy0UbEJwVxWMtQ1jcVrNCZQw1UO6xrpkodMJer+4I
98c7zvUb6dtVUfwWCAyGMfkw6uZ8Ydjpse7rmPy7qRsyTg74pfIfgM18iSj5AqKn
zLJ0+00Ij+EiJoPl1JL/JWdGMk3PxBhJBKwQSNXbO4Kbo5c9EiOqycgfg7Wd+4li
hx1YUYk/fQxmELb7ynZdaO9rgEQJ5ogS3p8Juxndr2cVHc89qT9pLJc0QKYrVlUD
BuXwB87cZSppheUeQ1lIOw8GIwmihs/eymLzAwrvoa0KbZfGiUa5Zg1AqLXeJXWo
xG6tFtZdc49xD7kwyiFyQaJ+7FxuOcLE1O6OSuAGN9ODsyYGe6VhyQqDb3rajK8W
RDv4B6cV9dZwOdvN8i3OnQ1Iz0zhAOeeZSoNJeoQEI8X1pt4IH6SVafyu9vG4WtH
nCKnVNuQ1rzUX1AAiEqI
=7PWu
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
