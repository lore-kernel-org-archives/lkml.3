Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbbA2LmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:42:06 -0500
Received: from sauhun.de ([89.238.76.85]:38640 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbbA2LmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:42:03 -0500
Date: Thu, 29 Jan 2015 12:41:55 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andrey Danin <danindrey@mail.ru>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        ac100@lists.launchpad.net, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCH 1/3] i2c: tegra: implement slave mode
Message-ID: <20150129114155.GA9080@katana>
References: <1422516022-27161-1-git-send-email-danindrey@mail.ru>
 <1422516022-27161-2-git-send-email-danindrey@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1422516022-27161-2-git-send-email-danindrey@mail.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> Initialization code is based on NVEC driver.
>=20
> There is a HW bug in AP20 that was also mentioned in kernel sources
> for Toshiba AC100.
>=20
> Signed-off-by: Andrey Danin <danindrey@mail.ru>

Cool, thanks for the converison. While I usually like to only get the
patches which I need to handle, please CC me to all patches next time. I
am interested what changes were needed for the user of the slave
framework, too.

> +static bool tegra_i2c_slave_isr(int irq, struct tegra_i2c_dev *i2c_dev)
> +{
> +	unsigned long status;
> +	u8 value;
> +
> +	if (!i2c_dev->slave || !i2c_dev->slave->slave_cb)
> +		return false;

Can this happen?

> +	/* i2c master sends data to us */
> +	if (is_write(status)) {
> +		i2c_slave_event(i2c_dev->slave, I2C_SLAVE_REQ_WRITE_START,
> +				NULL);

Can this HW create an interrupt once the address detection + RW bit are
received? Or only if a complete write has been received?

> +static int tegra_reg_slave(struct i2c_client *slave)
> +{
> +	struct tegra_i2c_dev *i2c_dev =3D i2c_get_adapdata(slave->adapter);
> +
> +	if (i2c_dev->slave)
> +		return -EBUSY;
> +
> +	i2c_dev->slave =3D slave;
> +
> +	tegra_i2c_clock_enable(i2c_dev);
> +
> +	reset_control_assert(i2c_dev->rst);
> +	udelay(2);
> +	reset_control_deassert(i2c_dev->rst);

Why do you need a reset when a slave gets registered?

> +
> +	i2c_writel(i2c_dev, I2C_SL_CNFG_NEWSL, I2C_SL_CNFG);
> +	i2c_writel(i2c_dev, 0x1E, I2C_SL_DELAY_COUNT);

What does this magic number mean?

> +
> +	i2c_writel(i2c_dev, slave->addr, I2C_SL_ADDR1);
> +	i2c_writel(i2c_dev, 0, I2C_SL_ADDR2);

Handling 10 bit addresses?

> +
> +	return 0;
> +}
> +

>  static const struct tegra_i2c_hw_feature tegra30_i2c_hw =3D {
> @@ -679,6 +808,7 @@ static const struct tegra_i2c_hw_feature tegra30_i2c_=
hw =3D {
>  	.has_single_clk_source =3D false,
>  	.clk_divisor_hs_mode =3D 3,
>  	.clk_divisor_std_fast_mode =3D 0,
> +	.slave_read_start_delay =3D 0,

No need to init to 0 IMO.


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyhyDAAoJEBQN5MwUoCm2pTAP/0Y5Nqt/YdL+ug7MTyX4Tq1i
3X7MgYamvmc5QrSvW/ee4z+d7zK+2ep1QlATGoSog5lA7k8pGP7MweunNmV0EvC4
EFVYTTYD0o+kqVtTbEpXztnaGWV97eOMwz9zEBFI5Z+C8ok0leQ++UrvHywPgwRo
Eo77T9CXNV4B2jhMCHNIJhSeCL+9UfpuVXx8nA0P0CSVnBW6cux/ozqa6OosJqHX
oyW9s+e+nobf45juPiINTGDKcNurCR1rhv6+pYZ/+QE5HmBVFGcJOzZpwjC7W6f3
aFksCtjNQQKDDgyQvCvkMGbcxgmXr//tu4ZW7BHn8R7Gax3iBVw65qO4f98ZnBEM
TcX3SeeFFDZwyYTObwCa8MMLhoBT3emllsYd4cDzMcMV5VnhuT8Wwa4+OhO9KsFx
MmHJT5HRtovJioXB08imSJVpif1R4b7Gepwj9aqdRzocOOtcGewD2hUonuvuTXWJ
73MBox+JLexAcEo2fj9OOb9oeZzuLOdCSDnC1HT5WGfsDnXd8M/cA6BdCH4pREOP
TTdpcYXzqgf/1JBPJkiL+UCeFyrYYz8mPK6gfHGaZDc20UTVW9/6DtKqmwXCFxFe
0fHHFGo/SvmUk3apQ98wRNO35Mh2YOv1ttGc6wyVu0lGAPJRtR2wSn2gd8h4RbAc
eIVKbbItBsfAouK56fzx
=PfQo
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
