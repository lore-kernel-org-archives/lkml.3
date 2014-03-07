Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaCGDWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:22:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57162 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaCGDWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:22:49 -0500
Date: Fri, 7 Mar 2014 10:48:41 +0800
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: ks.giri@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140307024841.GV13126@sirena.org.uk>
References: <1394125539-28062-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2U/oBqajgtCGL8Y7"
Content-Disposition: inline
In-Reply-To: <1394125539-28062-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/s3c64xx: Update DT binding documentation to match
 code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2U/oBqajgtCGL8Y7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 05:05:39PM +0000, Charles Keepax wrote:

> The following patch added support for spi controllers with a dedicated
> chip select pin:
>=20
> commit 3146beec21b64f4551fcf0ac148381d54dc41b1b
> spi: s3c64xx: Added provision for dedicated cs pin
>=20
> It updated the device tree binding to require a "cs-gpio" property to be
> specified on the spi controller node if chip selects will be given as
> GPIOs per slave, rather than the controller having a dedicated internal
> chip select pin.

No, it doesn't - it's saying that if the device has a "cs-gpio" property
then to use that as the chip select.  It's not a boolean, it's a GPIO
specifier.  Looking at the code it looks like the intention is to search
all children for a cs-gpio during the controller probe, it's possible
that this isn't working correctly.

> Apologies if I missed something but there are a couple of
> things I am not sure about in the original patch, there
> seems to be no special handling for the dedicated case, like
> set a bit that enables this or some such, which implies that
> parts with dedicated cs pins will always update them even
> if cs-gpio is specified. In which case wasn't what existed
> before reasonable?

The chip select signal within the IP always needs to be manipulated for
the hardware to work regardless of a GPIO being used, if a GPIO is being
used as the actual chip select then the expecation is that the pinmux
will be set up so that the signal isn't actually brought out of the
device.=20

--2U/oBqajgtCGL8Y7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGTOFAAoJELSic+t+oim92lMP/1dd/y7XwSndh9v0Xs04tY7n
apDMNlfvI2/tPrMjv3kT8zrXTHMqfyxEityi3KOb83ZyIXZsRJPHcaLZVop6V/s7
aoptcll1RFnPbvwXM59gHSk4kdD46BgMfHqEEUQgMVOZIdHIN1uI2PxmZH4hCAIg
ZltxK/bft8OlTPUB+kSCW6AS544yMQ4PMfkExkynLmfeazDlHBFLeLyvg9b56j23
NpIs2HBWNE5MfRFIkoyEIPe1DeIbUBvIvT16KLI9bo4dF3SMv/w+Yp6R5XbK1aaA
8ZXcEd+Giz5TnG00afFAYUtJYe+ryXQtfcmN1M/RqqKfQ6Fzy2Rc20VA74GcMfK6
H+VQBI+/q1D2NvXVihNV30UoGfWmysZxW7+qqOevSMBNLFUVwOuXugu5CVAxTRmL
f2Hg3ye2a4BX6YV4H886TutrDPLb23Tsghub6QlZLRvkgKK2lkdKkYeJJNIDXLWE
1t5Djd/At42W5yxtCu0DMwZP3xEKE7kxzu5sIVTu2+0S95wjKknJIl1IvPIy+ZcR
iyMqmwx7BsgSt5vCi+L7pU+wacVNl6qwHdi53gaWGwS8T5hxzIn8K3zzy4aG3e35
nt1yJw01r5Y8DZLQefDYWGAeJBU+1Y7kqASYdc+kQot4+ClkgXGIrEG67NPxLlmY
+Q6L8K4oeiyQm2PEAbxr
=yeir
-----END PGP SIGNATURE-----

--2U/oBqajgtCGL8Y7--
