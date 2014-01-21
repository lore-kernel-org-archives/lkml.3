Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaAUS4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:56:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57711 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaAUSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:55:58 -0500
Date: Tue, 21 Jan 2014 18:55:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140121185553.GW17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fJLw1dhSMr+9E5PS"
Content-Disposition: inline
In-Reply-To: <1389900750-27625-1-git-send-email-nm@ti.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fJLw1dhSMr+9E5PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 01:32:30PM -0600, Nishanth Menon wrote:

> -	abb->base = devm_ioremap_resource(dev, res);

> +	abb->base = devm_ioremap_nocache(dev, res->start, resource_size(res));

devm_ioremap_resouce() should do the right thing if the memory region is
marked as uncacheable (with IORESOURCE_CACHEABLE not set).  Since I
can't see the OF code actually setting that flag on the resources unless
I'm missing something this change isn't needed?

--fJLw1dhSMr+9E5PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3sK2AAoJELSic+t+oim9ClwP/3NkQLt/mxG6IiRa88CEscFn
hekzf9gKmrBK+sodAM+kbdwteizCuH2z0TsBHlDdUs5uKCS3VgUKl0583+MGnPrm
VtT3bI4rCU9b5Yx8RuAR9tXnFrVbpanpp1ofQUUId0HbNMNRlT8HNafO4FfejSZK
7D7rhJb4C+557IDcReMOMakq1sCRf8yrrYJyYPBXAVN7/GJNcv2xj6ZWJlcChXK6
xSjaTrKqSxUX9yHq7Yv/arCfpiQSMaJhd5fWdF0Yjvy7w0VVYYdDNxjhCPwQlCxK
NBS6m+WFD7aKn1uBbRvrXzABA83oakrpUKCn9EIJ4MvK352emiWt8i59NtfAA/al
pIXzifLAKptRO0IAqIZxgWNf+7EKx5ni+Fbd3TobhKB8weCfw2JyqSveC4TiJsHD
ppDQsRGj0NnnfQHf7bVbuu6SD7cqeYcwZSnLk2yhmtXGYtIP5iDwmItk8ZmGJaHi
pupwKXMgYzWfrIr5HXXqsId1TXpxbCSq/gIdQVBWrobSB3mdgZnUuMQFm+kj+Gqt
237QJYb15EVtq6lV8Oj6qyzwZKTBb2aCRZl6YkSvkFmNzT91tpMp1V3C8RUYtRmP
9HRvUdCXOu8vaWw6YtTF/FKZfvrmJb1JTh8DQFbpdYUMuZXxJuKu4KfUdaK/x/D4
XVrDkb0ivqllk0/QDm+W
=cn1t
-----END PGP SIGNATURE-----

--fJLw1dhSMr+9E5PS--
