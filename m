Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3IWHfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:35:01 -0400
Received: from sauhun.de ([89.238.76.85]:33626 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab3IWHe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:34:59 -0400
Date: Mon, 23 Sep 2013 09:34:51 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 8/9] of/i2c: Resolve interrupt references at probe time
Message-ID: <20130923073451.GE3051@katana>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-9-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Content-Disposition: inline
In-Reply-To: <1379320326-13241-9-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 10:32:05AM +0200, Thierry Reding wrote:
> Instead of resolving interrupt references at device creation time, delay
> resolution until probe time. At device creation time, there is nothing
> that can be done if an interrupt parent isn't ready yet, and the device
> will end up with an invalid interrupt number (0).
>=20
> If the interrupt reference is resolved at probe time, the device's probe
> can be deferred, so that it's interrupt resolution can be retried after
> more devices (possibly including its interrupt parent) have been probed.
>=20
> However, individual drivers shouldn't be required to do that themselves,
> over and over again, so this commit implements this functionality within
> the I2C core.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/i2c/i2c-core.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 29d3f04..163a1e8 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -236,6 +236,21 @@ int i2c_recover_bus(struct i2c_adapter *adap)
>  	return adap->bus_recovery_info->recover_bus(adap);
>  }
> =20
> +static int of_i2c_probe(struct i2c_client *client)

This function should be in the CONFIG_OF block.

> +{
> +	struct device_node *np =3D client->dev.of_node;
> +	int ret;
> +
> +	/* skip if the device node specifies no interrupts */
> +	if (of_get_property(np, "interrupts", NULL)) {
> +		ret =3D of_irq_get(client->dev.of_node, 0, &client->irq);

of_irq_get really sounds as it does refcounting. +1 to change the name.

Thanks,

   Wolfram


--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSP+8bAAoJEBQN5MwUoCm2G9AP/Ay3YBsjFpAv5Ki2PC2bMrlS
7TV4G1bzGYDvSvDJHT/azoOF+5HofCL9iXtbuqX6CB352AphfHh4XIP+qKc9K4cN
e8K04mQpXhkrlOmC9HUB2z2QtLRCKBiaahKeH9OHTK9FtvqtIx2Xcn81WNQj742k
1Vn2EYVdF2YmfLQruAksT+9GxZNuy5Mk675HHK4nTquXPHlbhZMP8t8LpsBX/f7p
mgdPvcy6GREO6Yn8RJkxpdc3tyBo5IHuHwDyG1UGEDeVpMTlkYnrRszB0TzCwMEr
LOIQCbb9ZOPaU7ZEqZvz/cXB62jYPk0B9xMmhEjkiOgylzWmU0jxeVAkh7KO9ofu
hUZ3NNqLKaH1WChUvqGFbvwEWAbF5YisWquV4KSX8GlVaxoAco65WgjH6Oyy8xyJ
Hr1ZjtFY/w4DFLsS3v/K71ghFik/A/BZq73BPgw5LKM57NjSiQQJiVJpWODt2Gxe
tC/82zok4aGgeMbXrWt9MQ1pa3pG2gcl06hTjBRNcWU/8aX9Yspt3SNzkYHKQlYB
Hu27YJ4HyOn4hbB+QkmcyIFnsFSxPdnBW/6qPgAuo1VJ12erParTbXiupe5yejCi
Q79D0EzOaOtaD2mQ1JPx3m307kW6SqEuMdZVSfa7sX7Wk/BJe0emCWGZFmMehvfT
Ku3RPeKJrrkh4KVUMG84
=/7nF
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
