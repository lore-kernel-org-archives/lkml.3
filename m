Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3A2By0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:54:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49733 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab3A2ByY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:54:24 -0500
Date: Tue, 29 Jan 2013 09:54:15 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: spi: Support asynchronous I/O for SPI
Message-ID: <20130129015411.GD4748@opensource.wolfsonmicro.com>
References: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5106D3CA.4030203@codeaurora.org>
 <20130129013858.GA4748@opensource.wolfsonmicro.com>
 <51072A38.6090505@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <51072A38.6090505@codeaurora.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 28, 2013 at 05:47:36PM -0800, Stephen Boyd wrote:
> On 01/28/13 17:39, Mark Brown wrote:

> > We could but I tend not to if the interface strictly requires that the
> > pointers be type punnable.

> What is the interface requiring strict type punning here? async_write?

Yes, the async data must always be the first member of the bus specific
struct.  This is to avoid having to do an additional allocation for the
bus specific private data.

> I just hope we don't move the fields around in the regmap_async_spi
> struct and then this code silently breaks. I hope the compiler is smart
> enough to skip doing any math if we used container_of() with the current
> struct layout.

It would break anyway, like I say the interface relies on it currently.
The other option is to do a callback into the bus code and return the
contained structure but it seemed more involved and this is fairly
idiomatic.

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRByu4AAoJELSic+t+oim9A8oQAJUbl3wsv02mvo+fjUDTVDGs
PSCNEUDRrdOStdrfuevvedD+KdMrEMPsuXjFg92OgF8lJ3CpfqmKe2KYI3LYBj05
jBHG7G79umEGBuPFQXae35z1/tQM2NW/OVNo9JJr00UrGdTZrhkKF5oWKJBzXaRk
2OkDXrbzYlz3dANe+nAqcNe/LYuDaHsLFaLJLrHVOWqFnZyZzhqBhShItOwDVPRt
oZueEsLqz5bLGQlvxD5ew+F6mrKC4rNLxWrLAX7NenSiaushfqFWHfU7RBhNqyp8
YBDTfc6b11lLlpIFcERbf0La+PDVLxXdt6CRCULpOr6fGJvDuq2xbeFWiQclKm/r
9CenF8lcEfG2niUEw+2NJ3+7kMTKeTnUxgE76Pig7krRHpUHOP7eEdjYOjq/gR5B
Frhu0vCbMowwleWt69G+3Mhz0WDoQANpNRhSp0ihfN6YWjoaucKbPA0KMmQKKZ6a
8KpaCKR2l3EkcdAxCPi19l3uBqbN6FQa0qvSqfzTO72t76ZMhQWlWq38XztmDyob
KMxI5r3p6zTkRKYXO15cD+a5yAQHKVPdloD5MzQ3GA11OlNhmNwAx2OULvtE2hWc
49qcD9RwT6YVB/YEPk/gdDB/BFw7ANi23OH3wMhdMIeb4YXL/qRik686gOcHuP6x
Y8uamZwrD9yXlTQovf+f
=hglR
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
