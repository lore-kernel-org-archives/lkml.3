Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3I0Sfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:35:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35188 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3I0Sff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:35:35 -0400
Date: Fri, 27 Sep 2013 19:34:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20130927183456.GM19304@sirena.org.uk>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7trrzIZ+323l9a6P"
Content-Disposition: inline
In-Reply-To: <1380292469-17347-1-git-send-email-lars@metafoo.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7trrzIZ+323l9a6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 04:34:27PM +0200, Lars-Peter Clausen wrote:
> This patch adds a new spi_w8r16be() helper, which is similar to spi_w8r16()
> except that it converts the read data word from big endian to native endianness
> before returning it. The reason for introducing this new helper is that for SPI

This actually feels like a bug in spi_w8r16() - I'd expect it to be
returning native endian in the first place since in SPI a word is by
default big endian so I'd expect this to have more of a register I/O
model.  It certainly seems to match what almost all of the users are
doing.

That said I'm not sure this is worth fixing in which case the new API
makes sense.  Or converting the users to regmap I guess.

--7trrzIZ+323l9a6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRc/NAAoJELSic+t+oim93NQP/RHbzfrfaSV7HU3/tidrmOtB
Aowo5KNj7szZ3GO8WUQlAhQnsavAvlkjSUIAaiCuqxecFYCKWX+b87dkB+1B9kT3
u5G6lpW14OzIhLlq6nYvL8TymhgYpkcjQ3eGQvweUuQpEv62Bi/9Ji5+hyxRJ5UR
Vto1QZmvN7HOKNm5DWSsAw7j/rZYtxn9V325OZEshCEhpoUwhKyAidEN8ggYxNTq
AnYK1fDB4GLeTS8v5syeNpYgpxyz2ZNQzwOiUebvMVLsR+mFf52Xb8dsWx9dDAGG
sYjrpSuldnlCcyFuIPJyJNuCNDYXDR8S0UV1XHhyA4Eq6gB96HSU3wZxtAhfLq9S
mMkj9wusXR2SzLgok3KYGjAHbqrRUhXmaWt4NuPRri8ShBhN7FlYAnpvDjAmXE0s
ugKN0zn1whWb+5DwO3aFIeOcXWN/6WCLSPpFsQHe7Vn4qnttcLCUaKpnbnBB6ITI
sOA6wzFG2BaUI5A8XVwVWSyfi16nHhLQbdoyLqJiVimS9j37qhJ6lxEnKhB/+smS
y7ZXedqm47Gebh+y24+y9Ml6rhf6zn0xghz3agN7oERXvPMdDBd4jtUy0586X2EG
AeuaZsHXozm+aytVk5KMh61VX6Kn9CAv5M/eZJbpKZRJSe5zxIYI2H89hz7c7Cct
ecejrKWQgqCik84K+4pv
=bQi1
-----END PGP SIGNATURE-----

--7trrzIZ+323l9a6P--
