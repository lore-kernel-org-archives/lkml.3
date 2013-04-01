Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3DAM5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:57:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35062 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503Ab3DAM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:57:47 -0400
Date: Mon, 1 Apr 2013 13:57:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Subject: Re: [PATCH V3 4/5] spi: s3c64xx: Added provision for dedicated cs pin
Message-ID: <20130401125744.GG18636@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
 <1363157014-9615-5-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c7hkjup166d4FzgN"
Content-Disposition: inline
In-Reply-To: <1363157014-9615-5-git-send-email-ks.giri@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c7hkjup166d4FzgN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 12:13:33PM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>
>=20
> The existing driver supports gpio based /cs signal.
> For controller's that have one device per controller,
> the slave device's /cs signal might be internally controlled
> by the chip select bit of slave select register. They are not
> externally asserted/deasserted using gpio pin.

Applying this patch breaks my S3C64xx based system (Cragganmore, a
non-DT platform).  It'll break all existing non-DT platforms since...

> + * @cs_gpio: CS line status, 'true' if CS line is asserted by gpio.
> + * 	     'false' if asserted by internal dedicated pin.
>   * @line: Custom 'identity' of the CS line.
>   *
>   * This is per SPI-Slave Chipselect information.
> @@ -25,6 +27,7 @@ struct platform_device;
>   */
>  struct s3c64xx_spi_csinfo {
>  	u8 fb_delay;
> +	bool cs_gpio;
>  	unsigned line;
>  };

=2E..you've added this new cs_gpio field to the platform data but not
updated any of the existing users (including Cragganmore).  It would
seem better to make the default behaviour stay as per the current
default and make the new behaviour optional but at a minimum all
existing in-tree users need to be updated.

It's also a bit odd that we end up checking cs_gpio and then using line
in the code, it'd be more idiomatic if cs_gpio were the GPIO number.

--c7hkjup166d4FzgN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWYQ0AAoJELSic+t+oim99lwP/RI1suNm4qdYtkjcGcCaphi3
l0uXXq/qGgbTSwqYF256uSzl/58jQwwfrdsOjU+Qn874hUi+nDB9ERL2YEqUhGfK
ZfCcclb8W0ftRonwcioAuW+rrwsMkftSBwXf3CChhw2COpWffisHaqL5rqGwmgdy
EQ5G/V9wd/vO4NKgYF3vuzBf7LoDTlWyKCzQnt4tZl+R6r5jsCmq/gbXEd9FKWcH
ZTQBDGDQfakQ2XflbYu1OL8NF6gRxHY25z6zWuLj9Xdq+jSG2Mu3jGHaJ1H2KDOP
0EISWFcGe1AHdTauj8QPuAA3RGCi7dW1Qm2L3ORgh0hpus2MPAUNWOU/QC7PmE0i
wEN7284jUo9BUY/r82PI6cpPepxeZHkOMFHg2aS2CAGs6BkG/cMP6B0JVWPwsWFc
DB3egyct9p1i/vvAhmsYjO+bePoUJzZGCpcu9pS5yrlcQxKaq21oire6KUIV68ML
lws99skOTA+4ED4Q13+B0wwSdQGvQ0Jsz4tgMk443SRaMW3rNuPGUO/lnqkt4rMN
RvRvgMwisyZO3Y9Vr98U8QS9hQRRV7uoIWA6GZL5Primh7dHBUC/QFv06olzVqjk
tQMnm0DpBdjdsza3h6+qNEHqrZ6RciY6Xyu+8Sk2yr5O+MRHjYJWJ7eAx8RCFmrf
LI4YYDIm73Y+fJiAbK+a
=cX7P
-----END PGP SIGNATURE-----

--c7hkjup166d4FzgN--
