Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3GIO4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:56:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40349 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3GIO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:56:03 -0400
Date: Tue, 9 Jul 2013 15:55:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Message-ID: <20130709145510.GZ27646@sirena.org.uk>
References: <20130705201118.GM2959@lukather>
 <5811519.oHVuMujf0I@wuerfel>
 <20130706120112.GA11069@lukather>
 <8997501.Dchyii8uWX@wuerfel>
 <20130708083426.GO27646@sirena.org.uk>
 <20130708202538.GK11243@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3aDtFGIaURYlkDgg"
Content-Disposition: inline
In-Reply-To: <20130708202538.GK11243@lukather>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: MTD EEPROM support and driver integration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3aDtFGIaURYlkDgg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 10:25:38PM +0200, Maxime Ripard wrote:
> On Mon, Jul 08, 2013 at 09:34:26AM +0100, Mark Brown wrote:

> > I'd really like to see more discussion of this "DT parsing code for
> > regmap" idea...  I've missed almost all the context here.

> The context was that I found we lack a way to simply express the need
> for one driver to get a value from an EEPROM-like device, for example to
> get a MAC Address, or a serial number, in a generic way, without having
> to poke directly with some custom function that would be exported by the
> EEPROM driver.

This sort of information is often stored in places like flash partitions
too.  Are we sure that regmap is a good place to be hooking in here?
The use case is sane, and being able to use regmap to do some of it
seems sensible (I've seen people use OTP in PMICs for similar purposes)
but perhaps an additional layer of abstraction on top makes sense.

> What we've been discussing so far is that:
>   - To have a common framework we could base our work on, we could move
>     the EEPROM drivers from drivers/misc/eeprom to MTD
>   - To declare the ranges that needed to be used by a driver that was
>     needing a value from one of those MTD drivers, we would use regmap
>     with a MTD backend
>   - And since we actually need to declare which ranges and in which
>     device one driver would have to retrieve this value from, we were
>     actually in need of DT bindings.

> This is pretty much the only context involved, and we are at the early
> stage of the discussion, so any comment is very welcome :)

If this stuff is being represented in MTD doesn't MTD already have
adequate abstractions for saying "this region in flash".  But otherwise
this seems fine, it's not a generic regmap DT binding but instead rather
more specific than that.

--3aDtFGIaURYlkDgg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3CRLAAoJELSic+t+oim9/fkQAIfgoN5SRhyj8ZAbGa4b4Ulm
JzOoeIMuSKHxri5+dpG4mpCtORIrDq+dThd+c6plhBVBLZlJ2UoCT7NatfGB6jqM
PFmZQ43nOZVcWwR291arCyG8b6gpd2c1AzrO3Ofufw0dlm3GgPKs4EuEZszPunoy
Mkad+y8z0iGOvHEzXm0fAs4zC5tjHEVkgLToHxogZ6McF9OrIMrLey2BeUwvQJIY
GQppcVJagLrRAROKECWfmdjlJSmkr3QqyZMMG/uaQovSVuJOPyDOBysE5i8XsBWY
7nnH14YXykmw6oUzH45E9ZBpI0R51VVhvMIdvIJMxqsclTd6M1y2JJxJV8AxhnJt
odb7sMGEbEV2yUO7sSBFPLoAuPrT8GIO5IvNuJE0JP9b04O2Dvq/NDl8puhVw5Jo
o+k3+y5WI3+PJDVrxKlp+w7Vuu6C0EOomQHYaEq8xhhkwwehIdtUMHXiPPU06ztm
vXfzCVWWbaiEDHXX14tGP4Y+s14+3Tv/R6X+1+uyCyDflCJ+gIDq87uLLB9wnfpL
V02xc/brP8Hu+cnedVgnzPx4NlzqHDhgNFifwpejx72zBJHDtW4w3TrxjaPvLw5a
WVirvW65t8rHgxgA4Nw+p3ven3rEKfkW7Cn9mMVnJycFcrDO/NunI71tu1Oxr18A
Q9Xq6ZRpziwfbvLdqhBj
=OEHm
-----END PGP SIGNATURE-----

--3aDtFGIaURYlkDgg--
