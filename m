Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab3HNPjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:39:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50597 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab3HNPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:39:42 -0400
Date: Wed, 14 Aug 2013 16:39:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130814153906.GU6427@sirena.org.uk>
References: <20130814113848.GP6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308141023150.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="853vXHwZJ9DppLtj"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308141023150.1701-100000@iolanthe.rowland.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--853vXHwZJ9DppLtj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 10:27:26AM -0400, Alan Stern wrote:
> On Wed, 14 Aug 2013, Mark Brown wrote:

> > I'd expect that we're just looking at hooks around connection and
> > disconnection here here - if we're looking at much more it seems like we
> > must be doing something wrong.

> Connection and disconnection of what?

The device on the bus.

> In the example mentioned earlier, the GPIOs to power an on-board USB
> hub would have to be initialized when the host controller was started. =
=20
> You wouldn't want to wait for the on-board hub to be detected, because
> without those GPIOs set properly, it never would be discovered on the
> USB bus.  Right?

Yes, so you'd want callbacks when the device actually appears and
disappears.

> Perhaps the platform-level code would need to hook into the places
> where the discoverable bus is registered and unregistered.

We'd need some way to get information to the drivers still, and to
handle drivers that want to stop and start things.

--853vXHwZJ9DppLtj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC6SXAAoJELSic+t+oim9hDsP/jXZ902addaAU11yHE9ShSZe
drRBg8OATN22TF6wABNZeFKFS+Uzfhj9eWoW5jza3FRHSeNTzIRsi+4pVmUMFQKQ
xhQOWFQ3/6gbIuhQPHEt1xLcpKQo5T9cFpE9lH1eNJjF9WUSFY/nvE24WvADLmIj
jEGCQrgNl73+Lg9Vc//tW8GXLR135iKUNtphkGZ+ZhAW6h84FfkYCqaqx+s4s1tg
tdrybVsF9MINx86ftwaIMQYxLuMo9lW9mOU2OhxMR3hw4oZblfkIOrVlk8CoOrgt
jdZdgEFh8O/ApncfKJanB6lDN9hN3UFa2hxrfjCRYm7T7PN0CjRzcSwLnwHn/Fk1
tlUsR76w0BUn/SzXNv+G75iBKtAoCpe7Wn6hO1eZIHSF6VXeuOE0qF+i4BtNwLjW
A+Tzca4I4KTIqxYpJMqGGuYki86qNjk6bvtFV7lr0cYhZIYj8lHZzVsVn6gFVPA5
DyclswuZM3y1/hw0W4Fzj4+RjW8kn52bIb4MTxc86vavvGQzJVKtPDrn8p+FW/+c
cIkpihGFKuQc5GmCComlo289H2+7xRj0kaQAunfMV8qenZQyoX+vQ3rQ7Au+5Lx/
G0sSLqtTrfRkk6f1vE8pxrpwL0L89uyP6hwhWRcKjuLFZCaASsGD68VA83cjRjc1
/gnQFC/HK94PIQ77TppB
=yW2Q
-----END PGP SIGNATURE-----

--853vXHwZJ9DppLtj--
