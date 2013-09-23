Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3IWLBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:01:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37795 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3IWLBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:01:47 -0400
Date: Mon, 23 Sep 2013 12:01:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
Message-ID: <20130923110140.GB21013@sirena.org.uk>
References: <1379926127-8935-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NwQOVL9IuL7Lgg8R"
Content-Disposition: inline
In-Reply-To: <1379926127-8935-1-git-send-email-jhovold@gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] driver core: prevent deferred probe with
 platform_driver_probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NwQOVL9IuL7Lgg8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 10:48:47AM +0200, Johan Hovold wrote:
> Prevent drivers relying on platform_driver_probe from requesting
> deferred probing in order to avoid further futile probe attempts (either
> the driver has been unregistered or its probe function has been set to
> platform_drv_probe_fail when probing is retried).
>=20
> Note that several platform drivers currently return subsystem errors
> from probe and that these can include -EPROBE_DEFER (e.g. if a gpio
> request fails).

This doesn't seem like the right end to address the problem from, it
seems like it would be better to move these drivers over to being normal
plaform drivers.  Using module_platform_driver() means relying on init
ordering which is the sort of thing we're trying to get away from.

--NwQOVL9IuL7Lgg8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQB+RAAoJELSic+t+oim9SksQAJy9hPRJKP/nqcpH4Sx64QBg
JHvDQPBjjX7bkLC0ZOH9EeOatfc0UV6KmEJ9iIjQkruOF7LpQk5TEJ4XzVxiN0RS
7+iee/7OCcttWRExV7ZS1eMU9rd6Guv0rx2LKs34VJG2qVItfxWQ8dAj8jiX50+r
2awH39jcn0W7gInmfavpyWh/ug6yU0FyWvK4qNLzvk/k11a3eNPY5AH52mwMyq/k
aUoC1kqW4JhtfOLFTw3CJe1xJakLfU5tYb3ItNajKZWr/g+n1ksaS5DQ2bidc8dQ
on1FNOI0UnmGoTIdnqhKonKg5vyU2cRyP+G2I1gi8uppQJHjNAEIVGoAN0dhEZaq
Ze1qXQH4prvCR+QagMAmd1Na+VyEyHxI+QSAIWY8LwIh/KzOxRFzEUHYoMJWHcrX
Owx94JadgR7lFr/S8gsmZ7YaXslnaSkyDwLswYpjTvgz5oFzjJtfvcDz6M0qhs6L
ZuHE5DulF6UVwk5UTtFNEj7ZhReFSAhR8uavf8BFLsf/SCItVbDjRVGg/LLU46xM
Wh4yfDrbOYo3EKRE7VCXZg1B5R+jgw/4jXDA3/J1SwdzZcfDenjhM7OUK2CKRJ8R
iDmlriLMxh4X82fjd8rpQC0VjlLHow3/oofxlZRKeTzOjvAEpKu39VCQaSN1OK72
jJDfg/5UO7V8T+Duj6SE
=fsoh
-----END PGP SIGNATURE-----

--NwQOVL9IuL7Lgg8R--
