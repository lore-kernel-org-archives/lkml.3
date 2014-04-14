Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaDNVFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:05:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33050 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaDNVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:05:04 -0400
Date: Mon, 14 Apr 2014 22:04:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140414210429.GJ25182@sirena.org.uk>
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XK4NhNJ9GVfup2vH"
Content-Disposition: inline
In-Reply-To: <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over SMBus
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XK4NhNJ9GVfup2vH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2014 at 03:08:05PM +0200, Boris BREZILLON wrote:
> SMBus is a subset of the I2C protocol, oftenly used to access registers on
> external devices.

This is basically fine.  However...

> +	switch (ctx->transfer_type) {
> +	case REGMAP_SMBUS_BYTE_TRANSFER:
> +		while (count > 0 && !ret) {
> +			ret = i2c_smbus_write_byte_data(ctx->i2c, reg++,
> +							*(u8 *)data++);
> +
> +			count--;
> +		}
> +		break;

The transfer type gets set once per device at init time so why not just
parameterise based on val_bytes?

> +	case REGMAP_SMBUS_I2C_BLOCK_TRANSFER:
> +		while (count > 0 && !ret) {
> +			ret = i2c_smbus_write_i2c_block_data(ctx->i2c,
> +							     reg,
> +							     ctx->val_bytes,
> +							     (const u8 *)data);

Fix the const correctness of the API rather than casting.

> +			reg += ctx->val_bytes;
> +			count -= ctx->val_bytes;
> +			data += ctx->val_bytes;
> +		}

I'm assuming this will only be used if val_bytes isn't 1 or 2?

--XK4NhNJ9GVfup2vH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTE1aAAoJELSic+t+oim9uDwQAJdp3xE31tvmX+oHZNGcuSDN
3+8ZmzMoF9bEhQIJzKsl57Pds9zZ7wVXkozEU6pEwBw2ljMO4qbnPDngpiBcGw8O
yhUsnpxF/2EVDc3nEMPwfuZFFw9bnDIbaGP+UJsd5zKsCnVdXzpeEKL3aTt1SIi/
7CxaRSFiaFa2oVTEm1darv4wcFxq/KmxH080CiKMC0Pq+D8LxXBB2taOcuanfMuQ
gBHrbS7ifVmWIAXfOGE6HGceapXLUz53YAXKDiQEQGXErzM3Mican1z57sAyHggO
VoJyAW1jP4VU8t8GNPn9POnscKaPfDqO1l0dKXkK/rR2+x32CH0dlwF+5fk8vC81
UoBcsIDqEN25TRxiV641If5IztQabdtWjJRGPh0C43eL6vZSqc6vTU1INeaFKFEX
BYfiRk8OIsFp2Blr2Ogu6Ki0JQJvJR4uaa8vEgHTcc3ogyw2ETbNLblyX03DieJB
3QQAHuGpjMxJfWC11xjuAArt59/iPf1TRXethAORjdonkIHJxKzHgsMSZuajQias
am7jTomlxmLHTU3sey4jGt0CIAXcmSVLeMkPlQFyxkR1irNBqULHcpf7h7GyURif
FjHwmTHsCE/3psaSQe/MMKOnd8crfLY8YqNqm0D4ufYd8x81EctFBXwPVzq4aJm5
JVTqKlYJfKasR6vjpyb3
=AQyr
-----END PGP SIGNATURE-----

--XK4NhNJ9GVfup2vH--
