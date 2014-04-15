Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaDOKKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:10:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33682 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDOKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:10:04 -0400
Date: Tue, 15 Apr 2014 11:09:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140415100922.GN12304@sirena.org.uk>
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140414210429.GJ25182@sirena.org.uk>
 <534CE16D.8010508@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nb8zVy0QMK3AA1xu"
Content-Disposition: inline
In-Reply-To: <534CE16D.8010508@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over SMBus
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nb8zVy0QMK3AA1xu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 09:36:13AM +0200, Boris BREZILLON wrote:
> On 14/04/2014 23:04, Mark Brown wrote:

> > The transfer type gets set once per device at init time so why not
> > just parameterise based on val_bytes?

> Actually, you may want to transfer 1 byte registers using the block
> method (if your device only support block transfers). This depends on
> the device being accessed and what it supports, but I'm not sure we can
> assume 1 byte registers will always be transferred using SMBUS byte
> transfers.

OK, so if this a realistic issue then it seems like it's better to
implement three different buses - there is not really any common code
between the various paths.  This would also mean that you avoid having
gather write when it can't be implemented.

The code is also not validating the lengths for two byte values.

> >> +    case REGMAP_SMBUS_I2C_BLOCK_TRANSFER: +        while (count
> >> > 0 && !ret) { +            ret =
> >> i2c_smbus_write_i2c_block_data(ctx->i2c, +
> >> reg, +                                 ctx->val_bytes, +
> >> (const u8 *)data);

> > Fix the const correctness of the API rather than casting.

> The API is correct because the i2c_smbus_write_i2c_block does not modify
> the data pointer.
> Just removing the const keyword in the cast should be enough, because
> you can safely cast a non const pointer to a const one.

If you need to cast away from void at all something is going wrong (and
we appear to be always passing in write buffers as const too, I can't
remember which operation this was though).

--nb8zVy0QMK3AA1xu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTQVPAAoJELSic+t+oim9xo0P/3UbGayJRJCdKOav7yKf1wFS
R8TvwzYLBG3q+TdtG8nPJlPBK13nnceYJhdEmRBMXDg2UYWtZ/efzAE2qtr0UMts
ptf/aFKnVot1uBFIGOj+7i5/0fpwEl8npguD0TvZiwGBfuudOysFve3OGZZfjqTB
K5CgTb3zl/RUu4js6VqyTBy5Bx+gmba5jqtCSJ32T93al8nvbCNKTaEMlfZpvlGi
nliqh4D7/Vl9EJ+5bv4RlHRpuF0teHwBWPu2YNvxIT6Oy55eB5Vfz0Gv4M1M7hLO
8p9jeXTvmCNil2ZNnxcsxm2YNTBOgVUhjM87QttuuSSEUXifHYPWiZ2ckP+zSOIn
nuEm/9ljDhe2v9ZTuup3srfRSTEPsKWW1CLVqMGC7XXT1r3mBoAcN1xkoNwfbH7I
IzoUBiakOS3kwNSrU3N18Z0uc7qAXQl/SwBuv12ipl5UJh07uU4C8kVGFp/EM0iL
81OFZ+jvaA4iCEQmQAD9OuhjP9f7oMdcmuxOP+vfxhUgJD6ZjtllHzvhBCipsG4H
bj+c2jSSZ97Pq01EP6fCmMlthF+x6gQNAoBnTYcW3bS0LWm9Zpe+Ly73Jtse1mER
8J4nDzH6PG5ItFQWXJFTd19Q3CY16AS36cUJZpz/AkazhLRYfW+RLuc5e25Vpr9J
rJZ7eLq4SzgjdsZaZHPm
=9I/v
-----END PGP SIGNATURE-----

--nb8zVy0QMK3AA1xu--
