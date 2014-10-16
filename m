Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaJPIhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:37:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57890 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPIhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:37:38 -0400
Date: Thu, 16 Oct 2014 10:36:53 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141016083653.GE724@sirena.org.uk>
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413390039-19364-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <1413390039-19364-3-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/9] regulator: max77802: Add .{get,set}_mode callbacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 15, 2014 at 06:20:32PM +0200, Javier Martinez Canillas wrote:

> +#define MAX77802_MODE(pval) ((pval == MAX77802_OPMODE_NORMAL) ?	\
> +			     REGULATOR_MODE_NORMAL : REGULATOR_MODE_STANDBY)
> +

Make this a static inline function if there's any need for it, this is
both more legible and more helpful for the compiler.

> +	switch (mode) {
> +	case REGULATOR_MODE_IDLE:
> +	case REGULATOR_MODE_STANDBY:
> +		val = MAX77802_OPMODE_LP;	/* ON in Low Power Mode */
> +		break;

You should never have multiple modes mapping onto a singel value - if
the user sets a mode they should find that the device has that mode.

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP4OkAAoJECTWi3JdVIfQ1vEH/jt/HeGUMQPFr+kveVeX1p3J
OafinCxvlHbecauZmecnlE78N8lI8sp5zB4zyyZgI5/8xzFM5wZb3e35xTAVFz29
oyt2+6JFZzhZMpONPx8cysuvM5vF4seuGUDHvVeEGDAHMr7HUkHzKLA97inmLS1x
Sgz3Ckg6dKxmMW03TmeoK5EVyF/dnipeFIFD+mtOs7dUcetF9nwz+gba8oUDPTUX
PM29FvIT+7CRlRcK0LasGPcnlDtKPxquqBbxBYdBkQB5ysP+BMA4cYvi/uagPyuC
giScpXgKcR/pXJRRxp92Ine4tYPIAes+JSj6b//u1yYS6MfRiUUbtt5tWY3R1tw=
=9pD9
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
