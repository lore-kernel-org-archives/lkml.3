Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3GYNxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:53:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40168 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab3GYNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:53:42 -0400
Date: Thu, 25 Jul 2013 14:53:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130725135319.GF9858@sirena.org.uk>
References: <1624911.6TtmtVmU1T@avalon>
 <CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
 <1408178.cxAUTUGJc5@avalon>
 <20130725131556.GD9858@sirena.org.uk>
 <CACRpkdY-mdLbMY16aMqR9Jwu8qs9q4KNyxOxnwhXiGrAAxpKjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CpYjv1NmbuaesVen"
Content-Disposition: inline
In-Reply-To: <CACRpkdY-mdLbMY16aMqR9Jwu8qs9q4KNyxOxnwhXiGrAAxpKjg@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control
 its IRQ domain ?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CpYjv1NmbuaesVen
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 03:21:35PM +0200, Linus Walleij wrote:
> On Thu, Jul 25, 2013 at 3:15 PM, Mark Brown <broonie@kernel.org> wrote:

> > Are the interrupts in a contiguous block in the controller so you can
> > just pass around the controller and a base number?

> That works with platform data and in-kernel structures, but AFAICT
> device tree has no such "bulk" concept but expects you to list
> each and every line individually in cases like this.

It works fine with domains as well - the domains all have a hwirq number
which is local to the domain context and doesn't correspond to a Linux
interrupt number.  If you can say "the X interrupts in this domain
starting at Y correspond to these X GPIOs" then you should be able to
cope.  Hopefully.

--CpYjv1NmbuaesVen
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8S3MAAoJELSic+t+oim94EYQAIYI56pkZM0keswLufghLH27
nxhbKPacDImJHnFaCLtW0w+lPSPq7n8TSxK/UovBJPi1WS4CJKA/SXG1IbFQuQ8s
TkqH24paaviGXq5Vnh7PznKG4zV8gskPQjPct7en7hobEKiJBOis6x69263zhKjZ
UfCGryusLzYw3X2vujK4HSfvFuVWNYpxxEf5O2sWTzo1qpbd9i8Hc6Jf6xr4DeBG
f0r8TZQF9X1uxSFdpCWyg3R5MATwFkf/CwkH/wJ0gWztyQV25s15dntUpsr4OzCo
5HXuAi1T+bsCIxg4bhkTOI6eL93Q52UQ0FdgLGInNPnu29b+uM7DGR5LN3JXSUsX
rAqcCpxZ+SFUgj+7dMT2tsKhiMzZZPyKIvXJG1nUyTUJTnKhmx2gM0gYVQyTOLrx
Vhu7weXTNIDq3+xzcH32egP5HYRfSqd3MD+aDTpYH0downc6xoSv8g6dSjSNSar8
JG9IeSeX7Z9Uu42dwTrrcM8ajbegwAEk4jKMM0/jpPUH/bjzJrbroxX7KbIodQOz
LfH0Z6XaLjHc3/oBgXGYeWaOv/5mzRBPI6y0zASldim5Ce+QP5yzbms1R9YyA5N1
beQnQMj6d6iF+43+CfRGemBOXEaMIIp5Ce/hPyCb3miyNyB6r0PsaxDrb+J20sMi
tKkcCbTRWOff+tx+ia5f
=AoxK
-----END PGP SIGNATURE-----

--CpYjv1NmbuaesVen--
