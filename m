Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaEUKei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:34:38 -0400
Received: from sauhun.de ([89.238.76.85]:46940 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaEUKeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:34:36 -0400
Date: Wed, 21 May 2014 12:34:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, naveenkrishna.ch@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        linux-kernel@vger.kernel.org, cpgs@samsung.com, broonie@kernel.org,
        t.figa@samsung.com
Subject: Re: [PATCH] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
Message-ID: <20140521103432.GM2708@katana>
References: <1398675598-25991-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="00sTfE/IIAT5d2r5"
Content-Disposition: inline
In-Reply-To: <1398675598-25991-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--00sTfE/IIAT5d2r5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 02:29:58PM +0530, Naveen Krishna Chatradhi wrote:
> HSI2C module on Exynos5260 differs from current modules in
> following ways:
> 1.  HSI2C on Exynos5260 has fifo_depth of 16bytes
> 2.  Module needs to be reset as a part of init sequence.
>=20
> Hence, Following changes are involved.
> 1. Add a new compatible string and Updates the Documentation dt bindings.
> 2. Introduce a variant struct to support the changes in H/W
> 3. Reset the module during init. Thus, bringing the module back
> to default state irrespective of what firmware did with it.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ich.naveen@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---

=2E..

> -		fifo_ctl |=3D HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
> +		trig_lvl =3D (i2c->msg->len > i2c->variant->fifo_depth) ?
> +			(i2c->variant->fifo_depth * 3/4) : i2c->msg->len;
> +		fifo_ctl |=3D HSI2C_RXFIFO_TRIGGER_LEVEL(trig_lvl);
> +

Dunno why checkpatch missed the 'space around operator' issue, yet I
fixed it here...

Applied to for-next, thanks!


--00sTfE/IIAT5d2r5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfIE4AAoJEBQN5MwUoCm2YF0P/0EFkN+wHA4u0tnxLbjfCXiT
mvz+QdM0aDBfnZ94TzkuDIYdDfH79QHG6goj0co6w33MqMS++E8tHhFO+7cFF5Ol
dkto2A0nJNHnqoC8hmvCoL9MaqTSsVrcOhWgrRcaxKj4CC8nQnJj+BkLgsf+PCXY
tfJEEwO+7N9Z7eWokF3Vyr/uzLEDPgkSgCsJLLvNNaAxNB8OGCpMPpHnNkL7eWdL
KqlkDqqvGTIpQZ4yJFTEE5RDMmACB+XzVrKF4L3Fu7ZwEZaKgOmlImo8qKAyRfeE
Pt0gLxSGQZyM0nlK+P16Fmk4cB96gwBJKzOAX956NltuEe0ykh0mR4Xzstczeb/G
hkD3R7XeYHYQ+6vDBvGlR3kZjYvWaUnfEiUGVaj+8lTQmaKqZbBESc25r3D93MsI
+D+BZ13CsGs1Q6sJAdYiH2D3ujdy80V8wtgUBAMyXTZNAVhd5sFF2wbhNn3AZlwO
TGXs8oBWu4IMqRvjcdH7Me2PAHVdP62miN7Gq3PFoyrMgSB1PX213JoJvE0ccCP1
CCSLdJq8ittMeiF0EhqWnq40xQMd0E6c518B6fd8rSNH2G586CCu6qHNdsddrbAw
NdAt0uKX4t/TBcQJiZVJDahDGQ+pvz13tv2zVApZqZ4/XrBjKFfwmJhpVtaK9Bhg
2OUAzmXWRBZ+EEwOUppr
=2qMU
-----END PGP SIGNATURE-----

--00sTfE/IIAT5d2r5--
