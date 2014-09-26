Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaIZKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:09:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43180 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbaIZKJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:09:23 -0400
Date: Fri, 26 Sep 2014 11:08:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Weike Chen <alvin.chen@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-ID: <20140926100832.GE27755@sirena.org.uk>
References: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
 <1411752349-31490-2-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ugMgaRwDDWDxqvmW"
Content-Disposition: inline
In-Reply-To: <1411752349-31490-2-git-send-email-alvin.chen@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ugMgaRwDDWDxqvmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 10:25:49AM -0700, Weike Chen wrote:

> +static u32 pxa2xx_spi_get_ssrc1_change_mask(const struct driver_data *dr=
v_data)
> +{
> +	if (!is_quark_x1000_ssp(drv_data))
> +		return SSCR1_CHANGE_MASK;
> +
> +	return QUARK_X1000_SSCR1_CHANGE_MASK;
> +}

These functions would be much better written as switch statements -
think how they're going to look when we've got another controller which
needs custom values.  It might also be helpful for review to have two
patches, one splitting things out into the functions and another adding
the Quark support.

> +/*  see Quark SPI data sheet for implementation rationale */
> +static u32 quark_x1000_set_clk_regvals(u32 rate, u32 *dds, u32 *clk_div)
> +{

Please document this in the driver - I don't know if this datasheet is
public but even if it is it may not stay that way.

> @@ -613,6 +759,8 @@ static void pump_transfers(unsigned long data)
>  	u32 cr1;
>  	u32 dma_thresh =3D drv_data->cur_chip->dma_threshold;
>  	u32 dma_burst =3D drv_data->cur_chip->dma_burst_size;
> +	u32 change_mask =3D pxa2xx_spi_get_ssrc1_change_mask(drv_data);
> +
> =20

Extra blank line being added here.

> @@ -145,6 +147,9 @@ static inline int pxa25x_ssp_comp(struct driver_data =
*drv_data)
>  		return 1;
>  	if (drv_data->ssp_type =3D=3D CE4100_SSP)
>  		return 1;
> +	if (drv_data->ssp_type =3D=3D QUARK_X1000_SSP)
> +		return 1;
> +
>  	return 0;
>  }

Things like this should also be refactored into switch statements - in
general anything that's deciding what to do based on ssp_type probably
ought to be using switch statements.

--ugMgaRwDDWDxqvmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJTsfAAoJECTWi3JdVIfQE+gH/16f2SYwr2HYqCpe7Vin3oVI
eh/D/ty70TT5l0/U2C4cSeb5IB2hDd1o79+L2qEDm5Cxmf9jtUYoTtagsVmd1gz3
cOoq0ifuwMzEDmI+UEnp+97jt5x+AfPGKO7+qKoTDWXIAU7ppPRguv4YC/TH9sla
0YPKOU/0AByy9DEiIsTld91eFvKcUggbGdEJVYiRtodLrnrf36/txXJ/VAERO6+K
F5cMRjEmy+7NXYLNKn30KbTG0BaOdPYJjIUyxuM6uFAGAYAajB9XqzvUIp7/b3u7
MhHfQU0AzJ4a8C6rqa172Y81QS24d2mKP6zjuotLYvYtWq3P3tGFD9qOFoW81CE=
=EhTZ
-----END PGP SIGNATURE-----

--ugMgaRwDDWDxqvmW--
