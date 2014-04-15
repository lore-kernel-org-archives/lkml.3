Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDOQrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:47:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34154 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaDOQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:47:00 -0400
Date: Tue, 15 Apr 2014 17:46:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140415164613.GF12304@sirena.org.uk>
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140414210429.GJ25182@sirena.org.uk>
 <534CE16D.8010508@free-electrons.com>
 <20140415100922.GN12304@sirena.org.uk>
 <534D1DDA.40207@free-electrons.com>
 <534D252B.8060009@metafoo.de>
 <20140415125654.GD12304@sirena.org.uk>
 <534D357F.9040906@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iBipwI8N6cjWJAiJ"
Content-Disposition: inline
In-Reply-To: <534D357F.9040906@metafoo.de>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over smbus
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iBipwI8N6cjWJAiJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 03:34:55PM +0200, Lars-Peter Clausen wrote:
> On 04/15/2014 02:56 PM, Mark Brown wrote:

> >  - Providing APIs for registering actual smbus devices as a convenience
> >    for devices with that constraint, regardless of how that is done
> >    behind the scenes.

> >  - Having the I2C implementation automatically use the smbus APIs if
> >    it can and either the controller is smbus only or it makes sense to
> >    do so for optimisation.

> I don't think it makes sense to expose smbus explicitly. We can already
> describe smbus restricted devices just fine with the current regmap_config
> and already support them with the current I2C regmap implementation. Using

Please note what I said about convenience - if lots of devices have
exactly the same set of constraints to set up it's possible sensible to
have a standard way of specifying them.  It's going to be a bit easier
to just say it's smbus than to remember exactly what that means.

> native I2C to access these devices will be more efficient than going through
> the smbus emulation layer. The smbus emulation layer essentially does the
> same as we do in regmap, so using the smbus emulation layer through regmap
> means doing the same thing twice.

Right, that's why I said it's probably only worth it if the controller
does smbus natively.

> As I see it there are currently 3 cases:

> 1) Device is strictly smbus only and the controller supports native smbus
>    => Use smbus
> 2) The device is smbus compatible but has extensions (e.g. support for multi
> register writes) and the controller supports only smbus.
>    => Use smbus
> 3) For every other case
>    => Use native I2C.

It's not clear to me that if the controller supports smbus we shouldn't
use it; presumably it's adding some value to have written the code to
take advantage of it.  That would mean another case for device is smbus
only and controller has explicit smbus support.

--iBipwI8N6cjWJAiJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTWJSAAoJELSic+t+oim9VCgP/RQf04EdRtp9LXE603x8quHo
f5lWWOSEnRpw8GIEKL9kqNkOivMZjC+QfEFoeOiHfmEgcWo9aekwm0y1zQSHBnAc
mMzJiyzvXbXLP68k0RI1AcpgX4yHdmpnaf2E2EkKcd7LAMV0Q3GQ2d33Gt2MKw8w
QJ+wYNWufFN72g/wMJhhTR9DaRPJDCnc8hFwDwaTox4pxkgRfhYPYNVmROsgQ4Lk
7cgOD9VRxA0dBhtYmochOfZbPQAMlBMMsFsWCVKJ0gqKf20u2GxsrJaQupkSt/g3
3rahTLOKVD/2fufAqVtETaOF+b0pd5X1UPSDjC1SvoxxXPnyJIaHRGWsqR2oar/T
mbPQHPNjNvPdZESwZ+mKl0i1bvw/Oat7LHTHzxMKfwy8JsoZ6DDan5v1K2Dl3Grt
XVznsVYzG8Nb2x4AbSx2YlNgAohsgisNVa3nvIwdPhWMXkCTAYsPhBfi7LtnBcKc
tsyCzzTlkOOeyOuX64AzYs5+bpQSkhIkaPUY6dpbNpQX0HsAFLrt7UXa551w3F3m
iXJ1afnrzHHx92W7YjxAYcOfmqwX4YWpJsBKwpkOfRtnQ9d+4RaNO8OInGGeWKOc
Bklt5/28rPYfd4UjLM022ZbJGoUHuK+cxhXSu3TxP6lgwiwUH7qDf/EGoHijQrxv
lpU14Q53H5q6RmefKnVJ
=zx2y
-----END PGP SIGNATURE-----

--iBipwI8N6cjWJAiJ--
