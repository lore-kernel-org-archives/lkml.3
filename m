Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3EFThE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:37:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56066 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3EFTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:36:59 -0400
Date: Mon, 6 May 2013 20:36:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Message-ID: <20130506193636.GE7478@sirena.org.uk>
References: <511FBBF7.2020103@gmail.com>
 <20130217162337.GB1583@opensource.wolfsonmicro.com>
 <5187DB0C.2060605@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <5187DB0C.2060605@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: regmap: Question about devices with unequal register sizes
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 06, 2013 at 06:32:12PM +0200, Daniel Mack wrote:
> On 17.02.2013 17:23, Mark Brown wrote:

> > The regmap I/O code isn't making any effort to support such devices, the
> > hardware is just too crazy to worry about.  The best you can do is use
> > the no-bus support and open code your physical I/O so you can still use
> > the cache.

> So it turns out I need to write these registers now on the TAS5086
> codec, which has such a strange layout. I wonder how I can possibly open
> code the physical I/O with registers that are up to 20 bytes in size,
> while the reg_write callback in struct regmap_config assumes an unsigned
> int suffices for the data? Any example you can point me to?

There's just no attempt being made in regmap to cater for such devices.
I'm not sure it's worth bothering, sorry, though if you come up with a
non-intrusive way of handling such hardware of course it'd be worth
considering.

Using the no-bus support, having that take a lock and then bypassing it
completely to do the 20 byte writes would probably work.

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiAZBAAoJELSic+t+oim9fp8P/3DvJw0R4l166DnJVW+46QeM
TGpV4UDwEt8ZDyzc5xZiy+3jpJK0XzhQl6uMyV5qyF4W+1+idwofLPHUxrAq2bB7
zGGGVciLu3Tg68TNLBB260/QxdxN6PufDfU+HD5JpKO2mwvcra9COp8ryrpxVTSv
3kDPUx1nPQEDvOJ89bROvrLSHLf8w2mFT0hXoiPH6wmtS7cg5MENVLwmPYCnqY1h
VOgdqXkxB+VifkQhiNlpRmvqgSADH+nnJpH73tDS8Tt19JAQ8PD2LqDffhsf3uI3
VA0ZilV9/8kJprbp0/u1iC9R1LNMkBpJ+6hIfPdOi5mmBYKihHVRiWyv9A2PCFP7
tHX7ig7CpWMBbD7yIQ9FFnuETYLDYem3oYbKSdKCK9DH0knk3RcEgythl9fk8g4e
AugnmhxOCtmG5/CTmCswMQUj8o9bM3MSpexviVwRKmCZ0recRbGquXDUkW3XwWKN
P4ZeCl+btTzGR3DtuxzaXjiGBTkJOlQlnAf6vUTHG9y2uCP2CwhKKb+aS8ATBl8H
3ykS3ouFevRxdj/qCMRpzRMMjf3d4GuLYFAgU0KtSpNvwqGhu1ewz17sfts5b9ey
6e0JI50bweh2D/gnet85H4ZDxgJtN9UtUu+27Hj8xNUXQkpx0E/+Mx0Ffs3/ZP1F
05VxMeIYgZhX4RUUESW5
=p4bj
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
