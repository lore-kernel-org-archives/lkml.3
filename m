Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3JHJJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:09:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54649 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3JHJJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:09:18 -0400
Date: Tue, 8 Oct 2013 10:09:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131008090910.GW21581@sirena.org.uk>
References: <5253A17E.10503@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FmwJltL8yKUx7YXQ"
Content-Disposition: inline
In-Reply-To: <5253A17E.10503@nvidia.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FmwJltL8yKUx7YXQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 02:09:02PM +0800, Wei Ni wrote:

> In the latest regulator framework, it default to provide dummy
> regulators with full constraints by your patch "regulator: core: Provide
> a dummy regulator with full constraints".

> I tried to use regulator_get() on lm90.c. If not set vcc-supply property
> in the dts file to assume the regulator is physically present and
> enabled, but it still can't get dummy regulator, just return -ENODEV.
> I traced it, the regulator_dev_lookup() will return -ENODEV, and at that
> time the has_full_constraints is still false, didn't be initialized in
> regulator_init_complete() yet, so it will not return dummy regulator,
> and will not return -EPROBE_DEFER either. This will cause the
> lm90_probe() failed.

> Could you take a look ?

Could you take a look at why we're getting -ENODEV please - this
indicates a problem with the device tree code since it should be what's
requesting probe deferral when it sees a link is present.

--FmwJltL8yKUx7YXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSU8uzAAoJELSic+t+oim92eQQAIqj9E+47p0Qw8HRGgd6VWLU
nHB3xlYzQLxCEgDUO15AgUiLuggqrVz+/DfkOggzvU7yBYcuazmCtT5XewDQIzKw
b9VhHCLjiDSdbUg8Dz7Xhwhj7Nhnmt8f6CZ0xRhWq3bJ+vRoeKIE4SZXnckGIa3g
eKihRz3mxdqXT4ozvcL1meXcQ4+Xk8CkH5dGqB4oD236S5bB2W7NJ7eMG3/kwgWS
IdMAdD08uRBO/M9sx39y4+T4NcXhSHDZbv6vJ+n0Et2mulb2Z4l0i9HPZY6UiVhm
0GQA02DO4NiuWRjbHYLLZ66qsGNFh+BiZiKC/X84GS0l3qgA9EYOb1zCIEW1ZUOD
2jXomK7xSRUhYS5z/S5OrNKtSSdasBEGC5mNhyF8BMmliANE0HrWKsLRxG2A3kku
iLSjy9AgPzCinGMg7KfbpHfRHV09XRrMMvbqDEtikzc0uLtu0b/orr3RTnzm9KKf
4SdyiwLAspdwC5vhrZ0GsyRouFZKP8bgmEip6btwg76HKxy7WyPvfzcZrw+obUSB
t9pSpSMn9AKmbG9QGvEwIfjQUeUvdisgyeUdjR2+haok6Eyblb44j0UtGgm9KK91
dEDFd81Vq5ibB3loZQyLA1KeCBBnpBOAzY328ebl3a7JSHM9LP0WgE62CBSgQsk8
8O3et3DLK8yVpAN9N0UK
=lrzj
-----END PGP SIGNATURE-----

--FmwJltL8yKUx7YXQ--
