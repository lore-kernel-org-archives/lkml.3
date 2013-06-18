Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab3FRSec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:34:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52021 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab3FRSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:34:31 -0400
Date: Tue, 18 Jun 2013 19:33:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Message-ID: <20130618183359.GR1403@sirena.org.uk>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-3-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130618113606.GA26763@n2100.arm.linux.org.uk>
 <CACRpkdZTVN2O-Rv4u-Ccb9EzV0At3zc7GYQyTq=HkseOi=GTeg@mail.gmail.com>
 <20130618151116.GZ2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sEhs5GQW+P4Mb8ab"
Content-Disposition: inline
In-Reply-To: <20130618151116.GZ2718@n2100.arm.linux.org.uk>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 02/10] pinctrl: mvebu: dove pinctrl driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sEhs5GQW+P4Mb8ab
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 04:11:16PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jun 18, 2013 at 05:02:49PM +0200, Linus Walleij wrote:
> > Nowadays I would do the above with regmap_update_bits().

> > Mutual exclusion for read-modify-write of individual bits in a
> > register is one of those cases where doing a regmap over
> > a memory-mapped register range makes a lot of sense.
> > (drivers/mfd/syscon.c being a nice example)

> So, for that solution we need to have some kind of global regmap per
> register or somesuch.  Then you run into regmap needing a struct
> device - well, with a shared register, which struct device do you
> use, or do you have to invent one?

> That sounds more heavy-weight than is really necessary.

Yes, regmap is far too heavyweight for a lot of these things - it
shouldn't really go in performance critical at the CPU level paths, it's
designed around things where I/O costs are considerable and worth
avoiding.

I do think that this is a very good idea - with the I2C/SPI drivers I
was reviewing prior to regmap there were always just far too many simple
bugs with read/modify/write cycles so factoring out the code really
helped with review.

--sEhs5GQW+P4Mb8ab
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJRwKgUAAoJELSic+t+oim931YP9jgT/xuYt1YPLvhNf0/K6YN5
t/d+KbC9qgJ1bsujku0xCFXAJozmt3b1WdvVYgz4CAgHLBmLMk3zeGeRTkjT1F+v
HJAwDGyHu6uX27GDSkGSemJoo2w3OUbJurcs8684dFLtOqYXYkdvPg4csyGilG29
8CnybUedH+wM3Lpd08r1NyKU4imuwzeCoLAV9LO7jAy9BikmyHDWtaW6QHYtQjz9
xD50jgxVKXWT+6zEUCFTrZVExmfFcJFoh7VPhI54ZjJId5Ljb4xS41uVUZB+fMz2
BrRDp156qr1CjC2moNgd0eFW5HO6iB8RPxg8spFpFAz06mupBvgj/mGK8bsTd9P/
3xXBhszaXSe08H7bd32KS7fEkEoRGnPI2eKzThF24atjN6vTUInyfnucYresPwA6
JVE2bNIfnAVF0DXcSksQm6FyNrcIn9po69ZjonR6vAH8NXrE/oc8767Q5voASzxw
mAbYf658nPJ/d9fA+lgoI/ALFFgbT6qrDrWh4ooVHhw0rSquwiWKJbCda085Ifvc
EMIKfRYcJKFDBPyEwzYoZ9c+LlDw5YXVzTrXz5o/5yTUX+xktwks01JdmhkyIaSW
G1FmomSA54Nvw+4wa1SsLIXRyfRFNTEVoyuyxA4zQDbjdbmYn6aMUuT4BdSLy6EU
yhvZavCs2IgnZS+xdXg=
=LaNA
-----END PGP SIGNATURE-----

--sEhs5GQW+P4Mb8ab--
