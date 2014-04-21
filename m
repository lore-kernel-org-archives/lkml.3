Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaDUWKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:10:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33905 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaDUWKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:10:52 -0400
Date: Mon, 21 Apr 2014 17:08:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        <linux-kernel@vger.kernel.org>, <agross@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH RFC 06/12] mmc: mmci: Add write delay to variant
 structure.
Message-ID: <20140421220819.GA4468@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1398116898-31478-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1398116898-31478-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 21, 2014 at 10:48:18PM +0100, srinivas.kandagatla@linaro.org wr=
ote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>=20
> This patch adds write delay parameter required after each write to contro=
ller
> registers on some of the SOCs like Qualcomm ones. The delay parameter will
> provide information on how many clock cycle delay required after each wri=
te.
>=20
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/mmc/host/mmci.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 4f8d0ba..86bf330 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -55,6 +55,8 @@ static unsigned int fmax =3D 515633;
>   *	      is asserted (likewise for RX)
>   * @fifohalfsize: number of bytes that can be written when MCI_TXFIFOHAL=
FEMPTY
>   *		  is asserted (likewise for RX)
> + * @reg_write_delay: delay in number of clock cycles required after each=
 write
> + *		     to controller registers.
>   * @sdio: variant supports SDIO
>   * @st_clkdiv: true if using a ST-specific clock divider algorithm
>   * @blksz_datactrl16: true if Block size is at b16..b30 position in data=
ctrl register
> @@ -72,6 +74,7 @@ struct variant_data {
>  	unsigned int		datalength_bits;
>  	unsigned int		fifosize;
>  	unsigned int		fifohalfsize;
> +	unsigned int		reg_write_delay;
>  	bool			sdio;
>  	bool			st_clkdiv;
>  	bool			blksz_datactrl16;
> @@ -178,7 +181,12 @@ static inline u32 mmci_readl(struct mmci_host *host,=
 u32 off)
> =20
>  static inline void mmci_writel(struct mmci_host *host, u32 data, u32 off)
>  {
> +	struct variant_data *var =3D host->variant;
> +
>  	writel(data, host->base + off);
> +
> +	if (var->reg_write_delay && host->mclk)
> +		udelay(1 + ((var->reg_write_delay * USEC_PER_SEC)/host->mclk));

looks like this should be quirk flag instead of a write delay... No
strong feelings though, but it looks like the following would be better,
perhaps:

	if (host_is_qualcom(host))
		udelay(1 + ((3 * USEC_PER_SEC)/host->mclk));

--=20
balbi

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVZbTAAoJEIaOsuA1yqRE8YAP/jjgALhJzj3GPy/mjHJ4bVwc
kDRI3NMSaXcN1CwAFtVXtAfIkHXt+ec9QYQjBgXybAHjbQJ/RcHe70YTSkx16X2C
KGK0kOju6ELO/svnnVBrd5LX5UZo4HRMdfHfnN9cXDGBI2Zob1HNTg32GRRfmw0j
CtudKCf8sk27L8SFt8hsg0+d2Z0bR/cFFrkEyb+V/aXa4dg3UYEGq8X5dKa3ZWzN
W2ktvdEyJCJYXNMscdw7ofLjoVEiW7Omka98IjicDusap5FHoaoLADp2qK4NWmSY
6Y8RTHtEPjfBulReZubpCNuvOWQHjbzD6Znz+VW6ksZDBXslkUNdhyI0/5EuTjQy
Wvlw0fFN7N6IZcG1iMAfnDlQ7nlhD5LmvGYzz65MoqMcH1bmJ3YUSCmXP82SPUAI
zWqYctCx87Bki7148lfovC13O9TzozH4aC4+FnvqMvQLdn6iT3vst9QxmgUQ9QZp
5yOxwS1S8LHabSkKG5Ke65lcerJ4LYtqvCFonbci+KTzO0tGCSWaX/Or7VPzBUCf
9YAX/wkPuLKex0a3lOgqt9TNeuhF+fFdWkF+Fts9yOivlKZ2DDT/mAufhFDKeaKn
wnv8NlBNPfsYJP9n7XfME2jz6ZmKYFQr2paaAm8SsgkxdKI6NZz4V5TrKfUChlBc
vqd4l2xo3rbzCvkS7tvv
=R5rq
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
