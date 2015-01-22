Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbbAVHkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:40:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64934 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAVHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:40:05 -0500
Date: Thu, 22 Jan 2015 08:40:02 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
Message-ID: <20150122074001.GB427@ulmo>
References: <1421756555-20266-1-git-send-email-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1421756555-20266-1-git-send-email-digetx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2015 at 03:22:25PM +0300, Dmitry Osipenko wrote:
> Support CPU BE mode by adding endianness conversion for memcpy interactio=
ns.
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  drivers/i2c/busses/i2c-tegra.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegr=
a.c
> index 28b87e6..e0d3ef1 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -286,6 +286,7 @@ static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_d=
ev *i2c_dev)
>  	if (rx_fifo_avail > 0 && buf_remaining > 0) {
>  		BUG_ON(buf_remaining > 3);
>  		val =3D i2c_readl(i2c_dev, I2C_RX_FIFO);
> +		val =3D cpu_to_le32(val);

Should this not technically be le32_to_cpu() since the data originates
=66rom the I2C controller?

>  		memcpy(buf, &val, buf_remaining);
>  		buf_remaining =3D 0;
>  		rx_fifo_avail--;
> @@ -343,7 +344,9 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_de=
v *i2c_dev)
>  	 */
>  	if (tx_fifo_avail > 0 && buf_remaining > 0) {
>  		BUG_ON(buf_remaining > 3);
> +		val =3D 0;

Why does this have to be initialized to 0 now?

Thierry

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUwKlRAAoJEN0jrNd/PrOhSi8P/1Wrpun9jCZ6mpZOR6ygP4YZ
REPC0O8KsInUmV5i904LvvSP+giJCCAp/WS54Q5bAGqdsN517IsTFkrp5OVM1+yS
kIjOkXA94idZjflCJl8fLDLZUSqNBj92Kh2ijCx39e+l8P+Cu5dVoHit/iU9t4Bd
8uBt1GWXwYSWU/lnTDaj1AcSJeuZ9mblRcNNoYegjPR095GQFbiMt0qWFLQRIbcO
/fJDlLYsNvhex6We3HukaPFXZ5FxVNkkSwjJ2HqUVifnBA5OxuzYTTozPjmegFIh
gF1Vz/dnyJHCJxj5lsnCCBqGxck5mxEKCOJTTpPOrj5kIeasgDVtTKlU+o7O2mKh
1GRNNdGZBQ/7fLeb315v2Q+czS4JXA+zL5D+guWhlJxRK6DnUPtScsJ+7M866u4v
xJ+6W/lO3msk6sfXVrNEtzzAghrcCmSBCxIPGNCG2aV22vQb0IechFVanzHow8oa
go9u7BB+UUPnTTEccZLgODEKCynBQy8M9lkMI0tCDrJV6L1c4DWinAd0w4HGDsmO
gj69l0aYAc+ELFFrtzyHT98iHM8vpX3JWbkTIcT0AXSqJPWwRXJm0CZ1CsXmXCM/
i5u2x/RHETfMQM8AcO8N+Qrt6EXaEr4Qroeh9sN17M1ldI3yBKpLXcoGM+SrJIH4
jOiV+zHnJlu0LvbhFf/e
=4Htm
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
