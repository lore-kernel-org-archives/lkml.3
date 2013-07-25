Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3GYNQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:16:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41535 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab3GYNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:16:23 -0400
Date: Thu, 25 Jul 2013 14:15:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130725131556.GD9858@sirena.org.uk>
References: <1624911.6TtmtVmU1T@avalon>
 <CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
 <1408178.cxAUTUGJc5@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j8mZs4DFq4CNSWJ6"
Content-Disposition: inline
In-Reply-To: <1408178.cxAUTUGJc5@avalon>
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


--j8mZs4DFq4CNSWJ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 11:45:33AM +0200, Laurent Pinchart wrote:

> The two devices are independent, so there's no real parent/child relation=
ship.=20
> However, as Grant proposed, I could list all the interrupts associated wi=
th=20
> GPIOs in the GPIO controller DT node. I would then just call=20
> irq_of_parse_and_map() in the .to_irq() handler to magically translate th=
e=20
> GPIO number to a mapped IRQ number.

> The number of interrupts can be pretty high (up to 58 in the worst case s=
o=20
> far), so an alternative would be to specify the interrupt-parent only, an=
d=20
> call irq_create_of_mapping() directly. What solution would you prefer ?

Are the interrupts in a contiguous block in the controller so you can
just pass around the controller and a base number?

--j8mZs4DFq4CNSWJ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8SUJAAoJELSic+t+oim9z/cP/R64rP34dn7tcWqn4Bg9CIKJ
IFieZCVJOfZY5PBqWx/sCG2FI9O0k5jx0K4tNQUsDiVXkmgSOTSfA+Bs50US0x5Y
dfXidgkvG2EXuRoSDQGhHqpYBvRnfkqMvIvpduyLivNEvYLS+ApfQie2IXMG9wK6
7W4dcsV0KwBULYFe6Pigqz27XinhhUcbQIGLXw6ODMAGJyXoaqky/G3pJOEbPmiZ
XCfTEH8ViHGX24KzeMktTjxMZRV+B5BAoBdukKpVeTxaDrh3khVkVGY5cV5Swh17
FafJINPiTfr8VqyeDZzzPYf11lISHTSrWA1j5XMvMRG15ca/A6y8ASbTSBRww25r
I1/i+L8uMoMNrdpTMX/maW3yrk70Ryq99MCnJ0mjH2n1IKN7+h6ugAUSL4Myr0qO
nF4WcIlhi2KC3aCWDmvk6q0lVW0C26ILJXUUQ00so5OcEFTN+klxYrRHoiTMhDz5
HDp9PcpB3cebG7/wkvQGGKlKav+MuxS5F2jU5baTzDuWn+iaOu3RStG2rUgd1piS
xsz8NlWt09EShWUSE1EMFRsVU2FZMsmJcdjHPcHkN0vWDF8hM5ppD76OMpjQ8+P0
ItoIePW0a1O9QkRUxt1XyqVDnlbJlhw5rhAHSn/mVoItZKxykR69j8dCbyCVCJlJ
3R4JWjArP03elptBditn
=nohB
-----END PGP SIGNATURE-----

--j8mZs4DFq4CNSWJ6--
